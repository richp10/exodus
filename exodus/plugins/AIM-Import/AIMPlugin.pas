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
unit AIMPlugin;


{$WARN SYMBOL_PLATFORM OFF}

interface

uses
    Exodus_TLB, XMLParser,
    ComObj, ActiveX, ExImportAIM_TLB, StdVcl;

type
  TAIMImportPlugin = class(TAutoObject, IExodusPlugin, IExodusMenuListener)
  protected
    procedure Startup(const ExodusController: IExodusController); safecall;
    procedure Shutdown; safecall;
    procedure Process(const xpath: WideString; const event: WideString; const xml: WideString); safecall;
    procedure NewChat(const jid: WideString; const Chat: IExodusChat); safecall;
    procedure NewRoom(const jid: WideString; const Room: IExodusChat); safecall;
    procedure Configure; safecall;
    function NewIM(const jid: WideString; var Body, Subject: WideString;
      const XTags: WideString): WideString; safecall;
    procedure NewOutgoingIM(const jid: WideString;
      const InstantMsg: IExodusChat); safecall;
    procedure OnMenuItemClick(const menuID : WideString; const xml : WideString); safecall;
    { Protected declarations }
  private
    _controller: IExodusController;
    _menu_id: Widestring;
    _parser: TXMLTagParser;
    _agent_cb: integer;

    procedure AgentsList(Server: Widestring);
  end;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
implementation

uses
    XMLTag, Importer, StrUtils, SysUtils,
    Dialogs, ComServ;

{---------------------------------------}
procedure TAIMImportPlugin.AgentsList(Server: Widestring);
var
    f: TfrmImport;
begin
    // we got back an agents list
    f := getImportForm(_controller, false);
    if (f <> nil) then begin
        if (AnsiSameText(Server, f.txtGateway.Text)) then begin
            f.processAgents();
        end;
    end;
end;

{---------------------------------------}
procedure TAIMImportPlugin.NewChat(const jid: WideString;
  const Chat: IExodusChat);
begin

end;

{---------------------------------------}
procedure TAIMImportPlugin.NewRoom(const jid: WideString;
  const Room: IExodusChat);
begin

end;

{---------------------------------------}
procedure TAIMImportPlugin.Process(const xpath: WideString;
    const event: WideString; const xml: WideString);
var
    a: TXMLTag;
begin
    if (xpath = '/session/agents') then begin
        // we have an agents list
        _parser.ParseString(xml, '');
        if (_parser.Count < 0) then exit;
        a := _parser.popTag();
        AgentsList(a.GetAttribute('from'));
        a.Free();
    end;
end;

{---------------------------------------}
procedure TAIMImportPlugin.Shutdown;
begin
    _controller.removePluginMenu(_menu_id);
    _controller.UnRegisterCallback(_agent_cb);
    _parser.Free();
end;

{---------------------------------------}
procedure TAIMImportPlugin.Startup(
  const ExodusController: IExodusController);
begin
    _controller := ExodusController;
    _menu_id := _controller.addPluginMenu('Import AIM Buddy List', Self);
    _agent_cb := _controller.RegisterCallback('/session/agents', Self);
    _parser := TXMLTagParser.Create();
end;

{---------------------------------------}
procedure TAIMImportPlugin.Configure;
begin
    //
end;

{---------------------------------------}
function TAIMImportPlugin.NewIM(const jid: WideString; var Body,
  Subject: WideString; const XTags: WideString): WideString;
begin

end;

{---------------------------------------}
procedure TAIMImportPlugin.NewOutgoingIM(const jid: WideString;
  const InstantMsg: IExodusChat);
begin

end;

procedure TAimImportPlugin.OnMenuItemClick(const menuID : WideString; const xml : WideString);
var
    f: TfrmImport;
begin
    if (menuID = _menu_id) then begin
        // make sure we are online..
        if (_controller.Connected = false) then begin
            MessageDlg('You must be connected before trying to import a AIM Buddy List.',
                mtError, [mbOK], 0);
            exit;
        end;
        f := getImportForm(_controller, true);
        f.Show();
    end;
end;

initialization
  TAutoObjectFactory.Create(ComServer, TAIMImportPlugin, CLASS_AIMPlugin,
    ciMultiInstance, tmApartment);
end.
