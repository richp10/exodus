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
unit NMPlugin;

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
    Exodus_TLB, XMLParser,
    ComObj, ActiveX, ExNetMeeting_TLB, StdVcl;

type
  TExNetmeetingPlugin = class(TAutoObject, IExodusPlugin, IExodusMenuListener)
  protected
    function onInstantMsg(const Body, Subject: WideString): WideString;
      safecall;
    procedure Configure; safecall;
    procedure NewChat(const jid: WideString; const Chat: IExodusChat);
      safecall;
    procedure NewRoom(const jid: WideString; const Room: IExodusChat);
      safecall;
    procedure Process(const xpath, event, xml: WideString); safecall;
    procedure Shutdown; safecall;
    procedure Startup(const ExodusController: IExodusController); safecall;
    function NewIM(const jid: WideString; var Body, Subject: WideString;
      const XTags: WideString): WideString; safecall;
    procedure NewOutgoingIM(const jid: WideString;
      const InstantMsg: IExodusChat); safecall;
        //IExodusMenuListener
    procedure OnMenuItemClick(const menuID : WideString; const xml : WideString); safecall;
  private
    _menu_id: Widestring;
    _exodus: IExodusController;
    _xpath: Widestring;
    _cb: integer;
    _parser: TXMLTagParser;
  end;

resourcestring
    sNetMeetingConnError = 'Your connection type does not support direct connections.';
    sNetMeetingStartErr = 'Could not start NetMeeting. Make sure it is running.';

implementation
uses
    ComServ, Dialogs, Registry, ShellAPI, XMLTag, Windows;

function TExNetmeetingPlugin.onInstantMsg(const Body,
  Subject: WideString): WideString;
begin

end;

procedure TExNetmeetingPlugin.Configure;
begin

end;

procedure TExNetmeetingPlugin.NewChat(const jid: WideString;
  const Chat: IExodusChat);
begin

end;

procedure TExNetmeetingPlugin.NewRoom(const jid: WideString;
  const Room: IExodusChat);
begin

end;

procedure TExNetmeetingPlugin.Process(const xpath, event, xml: WideString);
var
    data: String;
    iq, url: TXMLTag;
begin
    // we are getting a OOB..
    _parser.ParseString(xml, '');
    if (_parser.Count > 0) then begin
        iq := _parser.popTag();
        url := iq.QueryXPTag('/iq/query/url');
        if (url <> nil) then begin
            // check for callto: urls
            data := url.Data;
            if (Pos('callto:', data) = 1) then begin
                ShellExecute(0, 'open', PChar(Data), nil, nil, SW_SHOWNORMAL);
            end;
        end;
    end;
end;

procedure TExNetmeetingPlugin.Shutdown;
begin
    _exodus.removeContactMenu(_menu_id);
    _exodus.UnRegisterCallback(_cb);
    _cb := -1;
end;

procedure TExNetmeetingPlugin.Startup(
  const ExodusController: IExodusController);
begin
    _parser := TXMLTagParser.Create();
    _exodus := ExodusController;
    _menu_id := _exodus.addContactMenu('Start NetMeeting Call... ', Self);
    _xpath := '/packet/iq[@type="set"]/query[@xmlns="jabber:iq:oob"]';
    _cb := _exodus.RegisterCallback(_xpath, Self);
end;

function TExNetmeetingPlugin.NewIM(const jid: WideString; var Body,
  Subject: WideString; const XTags: WideString): WideString;
begin

end;

procedure TExNetmeetingPlugin.NewOutgoingIM(const jid: WideString;
  const InstantMsg: IExodusChat);
begin

end;

//IExodusMenuListener
procedure TExNetmeetingPlugin.OnMenuItemClick(const menuID : WideString; const xml : WideString);
var
    p: IExodusPresence;
    pres: IExodusPPDB;
    myip, jid: Widestring;
    iq, q: TXMLTag;
    reg : TRegistry ;
    NMName : String ;
begin
    if (menuID <> _menu_id) then exit;

    // ok, we have our menu item..
    jid := _exodus.getActiveContact();
    pres := _exodus.PPDB;
    p := pres.Find(jid, '');
    if (p <> nil) then begin
        // send the iq-set to this contact
        reg := TRegistry.Create ;
        reg.RootKey := HKEY_LOCAL_MACHINE;
        if reg.OpenKey('SOFTWARE\Clients\Internet Call\Microsoft NetMeeting\shell\open\Command', false) then
        begin
            NMName := reg.ReadString('') ;
            ShellExecute(0, 'open', PChar(NMName), nil, nil, SW_SHOWNORMAL);
        end
        else
            MessageDlg(sNetMeetingStartErr, mtWarning, [mbOK], 0);
        reg.Free;

        myip := _exodus.LocalIP;
        if (myip = '') then begin
            MessageDlg(sNetMeetingConnError, mtError, [mbOK], 0);
            exit;
        end;

        iq := TXMLTag.Create('iq');
        iq.setAttribute('to', p.fromJid);
        iq.setAttribute('type', 'set');

        q := iq.AddTag('query');
        q.setAttribute('xmlns', 'jabber:iq:oob');

        q.AddBasicTag('url', 'callto:' + myip + '+type=ip');
        q.AddBasicTag('desc', 'Netmeeting compatible call');

        _exodus.Send(iq.xml);

        iq.Free();
    end;
end;

initialization
  TAutoObjectFactory.Create(ComServer, TExNetmeetingPlugin, Class_ExNetmeetingPlugin,
    ciMultiInstance, tmApartment);
end.
