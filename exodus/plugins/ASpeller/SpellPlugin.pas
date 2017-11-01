{
    Copyright 2001-2008, Estate of Peter Millard
	
	This file is part of Exodus.
	
	Exodus is free software; you can redistribute it and/or modify
	it under the terms of the GNU General Public License as published by
	the Free Software Foundation; either version 2 of the License, or
	(at your option) any later version.
	
	Exodus is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU General Public License for more details.
	
	You should have received a copy of the GNU General Public License
	along with Exodus; if not, write to the Free Software
	Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
}
unit SpellPlugin;


{$WARN SYMBOL_PLATFORM OFF}

interface

uses
    ASpellHeadersDyn, Exodus_TLB,
    Classes, ComObj, ActiveX, ExASpell_TLB, StdVcl;

type
  TSpellPlugin = class(TAutoObject, IExodusPlugin)
  protected
    function NewIM(const jid: WideString; var Body, Subject: WideString;
      const XTags: WideString): WideString; safecall;
    procedure Configure; safecall;
    procedure MenuClick(const ID: WideString); safecall;
    procedure MsgMenuClick(const ID, jid: WideString; var Body,
      Subject: WideString); safecall;
    procedure NewChat(const jid: WideString; const Chat: IExodusChat);
      safecall;
    procedure NewRoom(const jid: WideString; const Room: IExodusChat);
      safecall;
    procedure Process(const xpath, event, xml: WideString); safecall;
    procedure Shutdown; safecall;
    procedure Startup(const ExodusController: IExodusController); safecall;
    procedure NewOutgoingIM(const jid: WideString;
      const InstantMsg: IExodusChat); safecall;
    //IExodusMenuListener
    procedure OnMenuItemClick(const menuID : WideString; const xml : WideString); safecall;
  private
    _exodus: IExodusController;
    _loaded: boolean;
    _dicts: TStringlist;
    _config: ASpellConfig;
    _speller: ASpellSpeller;

    procedure attemptConfigure();
  end;


resourcestring
    sAspellLoadError = 'Could not load the aspell system. Make sure you have properly installed aspell, and it is registered.';
    sAspellNoDicts = 'The ASpell plugin was unable to load any dictionaries. Make sure you have at least 1 aspell dictionary installed.';

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
implementation
uses
    Controls, ComServ, ChatSpeller, Dialogs;

{---------------------------------------}
function TSpellPlugin.NewIM(const jid: WideString; var Body,
  Subject: WideString; const XTags: WideString): WideString;
begin

end;

{---------------------------------------}
procedure TSpellPlugin.Configure;
begin
    if (MessageDlg('Attempt to reload and configure ASpell?', mtConfirmation,
        [mbYes, mbNo], 0) = mrYes) then
        attemptConfigure();
end;

{---------------------------------------}
procedure TSpellPlugin.MenuClick(const ID: WideString);
begin

end;

{---------------------------------------}
procedure TSpellPlugin.MsgMenuClick(const ID, jid: WideString; var Body,
  Subject: WideString);
begin

end;

{---------------------------------------}
procedure TSpellPlugin.NewChat(const jid: WideString;
  const Chat: IExodusChat);
var
    cp: TChatSpeller;
    chat_com: IExodusChat;
begin
    // a new chat window is firing up
    if (not _loaded) then exit;

    chat_com := IUnknown(Chat) as IExodusChat;
    cp := TChatSpeller.Create(_speller, chat_com);
    cp.ObjAddRef();
    cp.reg_id := chat_com.RegisterPlugin(IExodusChatPlugin(cp));
end;

{---------------------------------------}
procedure TSpellPlugin.NewRoom(const jid: WideString;
  const Room: IExodusChat);
var
    cp: TChatSpeller;
    chat_com: IExodusChat;
begin
    // a new room window is firing up
    if (not _loaded) then exit;

    chat_com := IUnknown(Room) as IExodusChat;
    cp := TChatSpeller.Create(_speller, chat_com);
    cp.ObjAddRef();
    cp.reg_id := chat_com.RegisterPlugin(IExodusChatPlugin(cp));
end;

{---------------------------------------}
procedure TSpellPlugin.NewOutgoingIM(const jid: WideString;
  const InstantMsg: IExodusChat);
var
    cp: TChatSpeller;
    chat_com: IExodusChat;
begin
    // a new IM window is firing up
    if (not _loaded) then exit;

    chat_com := IUnknown(InstantMsg) as IExodusChat;
    cp := TChatSpeller.Create(_speller, chat_com);
    cp.ObjAddRef();
    cp.reg_id := chat_com.RegisterPlugin(IExodusChatPlugin(cp));
end;

{---------------------------------------}
procedure TSpellPlugin.Process(const xpath, event, xml: WideString);
begin

end;

{---------------------------------------}
procedure TSpellPlugin.Shutdown;
begin
    if (_loaded) then begin
        delete_aspell_speller(_speller);
        delete_aspell_config(_config);
    end;
    
    _dicts.Clear();
    _dicts.Free();
end;

{---------------------------------------}
procedure TSpellPlugin.Startup(const ExodusController: IExodusController);
begin
    _exodus := ExodusController;
    _dicts := TStringlist.Create();
    _config := nil;
    _speller := nil;

    attemptConfigure();
end;

{---------------------------------------}
procedure TSpellPlugin.attemptConfigure();

    procedure showError(msg: string);
    begin
        MessageDlg(msg, mtError, [mbOK], 0);
        _loaded := false;
    end;

var
    res: boolean;
    di_list: AspellDictInfoList;
    di_elements: AspellDictInfoEnumeration;
    di: TAspellDictInfo;
    poss_error: ASpellCanHaveError;
begin

    // try to initialize the aspell system..
    // passing a blank string asks the registry for the location
    // of all things aspell'ish
    res := LoadAspell('');
    if (not res) then begin
        ShowError(sAspellLoadError);
        exit;
    end;

    // Remove the old ones.
    if (_speller <> nil) then begin
        delete_aspell_speller(_speller);
        _speller := nil;
    end;
    if (_config <> nil) then begin
        delete_aspell_config(_config);
        _config := nil;
    end;

    // get the dictionaries from the _config..
    _config := new_aspell_config();
    di_list := get_aspell_dict_info_list(_config);

    // run through all dicts..
    _dicts.Clear();
    di_elements := aspell_dict_info_list_elements(di_list);
    repeat
        di := aspell_dict_info_enumeration_next(di_elements)^;
        _dicts.add(di.name);
    until (aspell_dict_info_enumeration_at_end(di_elements) <> 0);

    delete_aspell_dict_info_enumeration(di_elements);

    if (_dicts.Count = 0) then begin
        ShowError(sAspellNoDicts);
        exit;
    end;


    // Get Config strings for the default dictionary
    // xxx: do we really need to do what the demo does
    // in getConfigStrings() ??

    poss_error := new_aspell_speller(_config);
    if (aspell_error_number(poss_error) <> 0) then exit;

    _speller := to_aspell_speller(poss_error);

    _loaded := true;
end;

//IExodusMenuListener
procedure TSpellPlugin.OnMenuItemClick(const menuID : WideString; const xml : WideString);
begin

end;

initialization
  TAutoObjectFactory.Create(ComServer, TSpellPlugin, Class_SpellPlugin,
    ciMultiInstance, tmApartment);
end.
