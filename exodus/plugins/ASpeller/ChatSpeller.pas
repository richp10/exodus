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
unit ChatSpeller;


{$WARN SYMBOL_PLATFORM OFF}

interface

uses
    ASpellHeadersDyn,
    Exodus_TLB, RichEdit2, ExRichEdit,
    Classes, ComObj, ActiveX, ExASpell_TLB, StdVcl, Unicode;

type
  TChatSpeller = class(TAutoObject, IExodusChatPlugin, IExodusMenuListener)
  protected
    function onAfterMessage(var Body: WideString): WideString; safecall;
    function onBeforeMessage(var Body: WideString): WordBool; safecall;
    procedure onClose; safecall;
    procedure onContextMenu(const ID: WideString); safecall;
    procedure onKeyPress(const Key: WideString); safecall;
    function OnKeyUp(key: Integer; shiftState: Integer): WordBool; safecall;
    function OnKeyDown(key: Integer; shiftState: Integer): WordBool; safecall;
    procedure onNewWindow(HWND: Integer); safecall;
    procedure onRecvMessage(const Body, xml: WideString); safecall;
    function OnBeforeRecvMessage(const Body: WideString; const XML: WideString): WordBool; safecall;
    procedure OnAfterRecvMessage(var Body: WideString); safecall;

        //IExodusMenuListener
    procedure OnMenuItemClick(const menuID : WideString; const xml : WideString); safecall;

  private
    _chat: IExodusChat;
    _msgout: TExRichEdit;
    _speller: ASpellSpeller;

    // stuff to do replacements, etc..
    _cur_start: integer;
    _cur_len: integer;
    _cur_word: string;

    // menu's we add on mis-spelled words.
    _ignore: Widestring;
    _ign_all: Widestring;
    _add: Widestring;
    _add_lower: Widestring;
    _sep: Widestring;
    
    _suggs: TWideStringlist;
    _words: TStringlist;

    function checkWord(w: Widestring): boolean;
    procedure removeMenus();

  public
    reg_id: integer;

    constructor Create(Speller: ASpellSpeller; chat_controller: IExodusChat);
    destructor Destroy(); override;
  end;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
implementation

uses
    ComServ, Graphics, SysUtils;

const
    // space, tab, LF, CR, !, ,, .
    WhitespaceChars = [#09, #10, #13, #32, #33, #34, #35, #36, #37, #38, #39, #40, #41, #42, #43, #44, #46, #47];

resourcestring
    sIgnore = 'Ignore';
    sIgnoreAll = 'Ignore All';
    sAddCustom = 'Add to Dictionary';
    sAddCustomLower = 'Add Lowercase to Dictionary';

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
constructor TChatSpeller.Create(Speller: ASpellSpeller;
    chat_controller: IExodusChat);
begin
    //
    inherited Create();
    _speller := Speller;
    _chat := chat_controller;
    _msgout := nil;

    _suggs := TWidestringlist.Create();
    _words := TStringlist.Create();
end;

{---------------------------------------}
destructor TChatSpeller.Destroy();
begin
    //
    _suggs.Free();
    _words.Free();
end;

{---------------------------------------}
function TChatSpeller.onAfterMessage(var Body: WideString): WideString;
begin
    if (_ignore <> '') then removeMenus();
end;

{---------------------------------------}
function TChatSpeller.onBeforeMessage(var Body: WideString): WordBool;
begin
    Result := true;
end;

{---------------------------------------}
procedure TChatSpeller.onClose;
begin
    if (_ignore <> '') then
        removeMenus();

    _chat.UnRegisterPlugin(reg_id);
end;

{---------------------------------------}
procedure TChatSpeller.onContextMenu(const ID: WideString);
begin

end;

{---------------------------------------}
procedure TChatSpeller.onKeyPress(const Key: WideString);
var
    adr: integer;
    tmps: String;
    k: Char;
    ok: boolean;
    last, cur: longint;
    word: WideString;
begin
    if (_MsgOut = nil) then begin
        adr := _chat.getMagicInt(Ptr_MsgInput);
        _MsgOut := TExRichEdit(Pointer(adr)^);
        end;

    tmps := Key;
    k := tmps[1];

    if ((k in WhitespaceChars) and (_MsgOut.SelStart > 0)) then begin
        // check spelling for this word
        cur := _MsgOut.SelStart;
        last := cur;

        // find the last word break..
        while ((last > 0) and ((_MsgOut.Text[last] in WhitespaceChars) = false)) do
            dec(last);

        word := Trim(Copy(_MsgOut.Text, last + 1, (cur - last) + 1));
        if (word = '') then
            ok := true
        else
            ok := checkWord(word);

        // XXX: look for numbers in the word, and don't spell check

        with _MsgOut do begin
            SelStart := last;
            SelLength := (cur - last);
            if (ok) then begin
                SelAttributes.Color := clBlack;
                SelAttributes.Style := [];
            end
            else begin
                _cur_start := SelStart;
                _cur_len := SelLength;
                SelAttributes.Color := clRed;
                SelAttributes.Style := [fsUnderline];
                SelAttributes.UnderlineType := ultDotted;
            end;
            SelStart := cur;
            SelLength := 0;
            SelAttributes.Color := clBlack;
            SelAttributes.Style := [];
        end;
    end;
end;
{---------------------------------------}
function TChatSpeller.OnKeyUp(key: Integer; shiftState: Integer): WordBool;
begin
    Result := false;
end;
{---------------------------------------}
function TChatSpeller.OnKeyDown(key: Integer; shiftState: Integer): WordBool;
begin
    Result := false;
end;
{---------------------------------------}
function TChatSpeller.checkWord(w: Widestring): boolean;
var
    tmps: String;
    res: integer;
    suggestions: AspellWordList;
    elements: AspellStringEnumeration;
    word_: PChar;
    menu_id: widestring;
begin
    tmps := w;
    _cur_word := tmps;
    res := aspell_speller_check(_speller, PChar(tmps), length(tmps));
    Result := (res = 1);

    // handle suggestions
    if (res <> 1) then begin
        suggestions := aspell_speller_suggest(_speller, PChar(tmps), length(tmps));
        elements := aspell_word_list_elements(suggestions);

        if (_ignore <> '') then removeMenus();

        // populate our lists..
        _ignore := _chat.AddMsgOutMenu(sIgnore, Self);
        _ign_all := _chat.AddMsgOutMenu(sIgnoreAll, Self);
        _add := _chat.AddMsgOutMenu(sAddCustom, Self);
        _add_lower := _chat.AddMsgOutMenu(sAddCustomLower, Self);
        _sep := _chat.AddMsgOutMenu('-', nil);

        repeat
            word_ := aspell_string_enumeration_next(elements);
            if (word_ <> nil) then begin
                menu_id := _chat.AddMsgOutMenu(word_, Self);
                if (menu_id <> '') then begin
                    _suggs.Add(menu_id);
                    _words.Add(word_);
                end;
            end;
        until (word_ = nil);
        delete_aspell_string_enumeration(elements);
    end;
end;

{---------------------------------------}
procedure TChatSpeller.removeMenus();
var
    i: integer;
begin
    // remove all the context menus
    _chat.RemoveMsgOutMenu(_ignore);
    _chat.RemoveMsgOutMenu(_ign_all);
    _chat.RemoveMsgOutMenu(_add);
    _chat.RemoveMsgOutMenu(_add_lower);
    _chat.RemoveMsgOutMenu(_sep);

    for i := 0 to _suggs.Count - 1 do
        _chat.RemoveMsgOutMenu(_suggs[i]);

    _suggs.Clear();
    _words.Clear();

    _ignore := '';
    _ign_all := '';
    _add := '';
    _add_lower := '';
    _sep := '';

end;

{---------------------------------------}
procedure TChatSpeller.onNewWindow(HWND: Integer);
begin
    _MsgOut := nil;
end;

{---------------------------------------}
procedure TChatSpeller.onRecvMessage(const Body, xml: WideString);
begin

end;
function TChatSpeller.OnBeforeRecvMessage(const Body: WideString; const XML: WideString): WordBool;
begin
    Result := false;
end;
procedure TChatSpeller.OnAfterRecvMessage(var Body: WideString);
begin

end;

procedure TChatSpeller.OnMenuItemClick(const menuID : WideString; const xml : WideString);
    procedure doSelection(new_word: string = '');
    var
        o_start, o_len: integer;
    begin
        with _MsgOut do begin
            o_start := SelStart;
            o_len := SelLength;

            SelStart := _cur_start;
            SelLength := _cur_len;

            SelAttributes.Color := clBlack;
            SelAttributes.Style := [];
            if (new_word <> '') then
                SelText := new_word;

            SelStart := o_start;
            SelLength := o_len;
        end;
    end;


var
    sidx: integer;
    rep: string;
begin
    // check for our various menus
    sidx := _suggs.IndexOf(menuID);
    if (sidx >= 0) then begin
        // they clicked a suggestion
        rep := _words[sidx];
        aspell_speller_store_replacement(_speller, PChar(_cur_word),
            length(_cur_word), PChar(rep), length(rep));
        doSelection(rep);
    end

    else if (menuID = _ignore) then begin
        // ignore, just change formatting back
        doSelection();
    end

    else if (menuID = _ign_all) then begin
        // ignore all
        aspell_speller_add_to_session(_speller, PChar(_cur_word), length(_cur_word));
        doSelection();
    end

    else if (menuID = _add) then begin
        // add to dict
        aspell_speller_add_to_personal(_speller, PChar(_cur_word), length(_cur_word));
        doSelection();
    end

    else if (menuID = _add_lower) then begin
        // add lower to dict
        aspell_speller_add_to_personal(_speller, PChar(LowerCase(_cur_word)),
            length(_cur_word));
        doSelection();
    end
    else
        // break out so we don't removeMenus
        exit;

    removeMenus();
end;

initialization
  TAutoObjectFactory.Create(ComServer, TChatSpeller, Class_ChatSpeller,
    ciMultiInstance, tmApartment);
end.
