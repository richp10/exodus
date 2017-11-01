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
unit IRCPlugin;

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
    Login, IRCSession, Classes, 
    Exodus_TLB, ComObj, ActiveX, ExIRCPlugin_TLB, StdVcl;

type
  TIRCPlugin = class(TAutoObject, IExodusPlugin)
  protected
    function NewIM(const jid: WideString; var Body, Subject: WideString;
      const XTags: WideString): WideString; safecall;
    procedure Configure; safecall;
    procedure MenuClick(const ID: WideString); safecall;
    procedure MsgMenuClick(const ID, jid: WideString; var Body,
      Subject: WideString); safecall;
    procedure NewChat(const jid: WideString; const Chat: IExodusChat);
      safecall;
    procedure NewOutgoingIM(const jid: WideString;
      const InstantMsg: IExodusChat); safecall;
    procedure NewRoom(const jid: WideString; const Room: IExodusChat);
      safecall;
    procedure Process(const xpath, event, xml: WideString); safecall;
    procedure Shutdown; safecall;
    procedure Startup(const ExodusController: IExodusController); safecall;

  private
    _exodus: IExodusController;
    _menuid: Widestring;
    _sessions: TStringList;
    _rooms: TStringList;

  public

    procedure StartRoom(sess: TfrmIRC; jid: string);
    procedure Initialize; override;

  end;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
implementation

uses
    Windows, Forms, RoomPlugin, SysUtils, Controls, JabberID, ComServ;

procedure TIRCPlugin.Initialize;
begin
    //
    IsMultiThread := true;
    CoInitFlags := COINIT_MULTITHREADED;
    CoInitialize(nil);
end;


{---------------------------------------}
function TIRCPlugin.NewIM(const jid: WideString; var Body,
  Subject: WideString; const XTags: WideString): WideString;
begin

end;

{---------------------------------------}
procedure TIRCPlugin.Configure;
begin

end;

{---------------------------------------}
procedure TIRCPlugin.MenuClick(const ID: WideString);
var
    f: TfrmStartSession;
    s: TfrmIRC;
begin
    if (ID = _menuid) then begin
        f := TfrmStartSession.Create(nil);
        if (f.ShowModal() = mrOK) then begin
            Application.handle := GetForegroundWindow();
            s := TfrmIRC.Create(Application);
            Application.handle := 0;
            
            s.server := f.txtServer.Text;
            s.port := f.txtPort.Text;
            s.nickname := f.txtNickname.Text;
            s.alt := f.txtAlt.Text;
            s.plugin := Self;

            _sessions.AddObject(s.server, s);
            _exodus.CreateDockableWindow(s.Handle, 'IRC Session');
            s.Show();
        end;
        f.Close();
    end;
end;

{---------------------------------------}
procedure TIRCPlugin.MsgMenuClick(const ID, jid: WideString; var Body,
  Subject: WideString);
begin

end;

{---------------------------------------}
procedure TIRCPlugin.NewChat(const jid: WideString;
  const Chat: IExodusChat);
begin

end;

{---------------------------------------}
procedure TIRCPlugin.NewOutgoingIM(const jid: WideString;
  const InstantMsg: IExodusChat);
begin

end;

{---------------------------------------}
procedure TIRCPlugin.NewRoom(const jid: WideString;
  const Room: IExodusChat);
var
    h, i: integer;
    r: TIRCRoom;
    tmp_jid: TJabberID;
    c: string;
begin
    i := _rooms.IndexOf(jid);
    if (i = -1) then exit;

    if (_rooms.Objects[i] = nil) then begin
        tmp_jid := TJabberID.Create(jid);
        h := _sessions.IndexOf(tmp_jid.domain);
        if (h = -1) then exit;

        r := TIRCRoom.Create();
        r.jroom := Room;
        r.jid := jid;
        r.sess := TfrmIRC(_sessions.Objects[h]);
        Room.RegisterPlugin(r.plug);

        c := '#' + tmp_jid.user;
        r.sess.MonitorChannel(c, r);
        r.sess.IRC.Join(c);
    end;

end;

{---------------------------------------}
procedure TIRCPlugin.Process(const xpath, event, xml: WideString);
begin

end;

{---------------------------------------}
procedure TIRCPlugin.Shutdown;
begin
    _exodus.removePluginMenu(_menuid);
    FreeAndNil(_sessions);
    FreeAndNil(_rooms);
end;

{---------------------------------------}
procedure TIRCPlugin.Startup(const ExodusController: IExodusController);
begin
    _exodus := ExodusController;
    _menuid := _exodus.addPluginMenu('Start IRC Session');
    _sessions := TStringlist.Create();
    _rooms := TStringlist.Create();
end;

{---------------------------------------}
procedure TIRCPlugin.StartRoom(sess: TfrmIRC; jid: string);
begin
    //
    _rooms.Add(jid);
    _exodus.startRoom(jid, sess.nickname, '', false);
end;

initialization

  //CoInitializeEx(nil, COINIT_MULTITHREADED);

  TAutoObjectFactory.Create(ComServer, TIRCPlugin, Class_IRCPlugin,
    ciMultiInstance, tmApartment);

  {
finalization
  CoUninitialize();
  }

end.
