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
unit IRCSession;

interface

uses
    Exodus_TLB, RoomPlugin,
    Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
    Dialogs, StdCtrls, ExtCtrls, IdBaseComponent, IdComponent,
    IdTCPConnection, IdTCPClient, IdIRC, IdAntiFreezeBase, IdAntiFreeze;

type

  TfrmIRC = class;

  TIRCRoom = class
  public
    jroom: IExodusChat;
    jid: string;
    sess: TfrmIRC;
    plug: TIRCRoomPlugin;

    constructor Create();
    destructor Destroy(); override;
  end;

  TfrmIRC = class(TForm)
    Status: TMemo;
    Panel1: TPanel;
    btnDisconnect: TButton;
    btnJoin: TButton;
    IRC: TIdIRC;
    btnConnect: TButton;
    Button1: TButton;
    procedure btnConnectClick(Sender: TObject);
    procedure IRCConnected(Sender: TObject);
    procedure IRCSystem(Sender: TObject; AUser: TIdIRCUser;
      ACmdCode: Integer; ACommand, AContent: String);
    procedure IRCStatus(ASender: TObject; const AStatus: TIdStatus;
      const AStatusText: String);
    procedure IRCDisconnected(Sender: TObject);
    procedure btnJoinClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure IRCAction(Sender: TObject; AUser: TIdIRCUser;
      AChannel: TIdIRCChannel; Content: String);
    procedure IRCMessage(Sender: TObject; AUser: TIdIRCUser;
      AChannel: TIdIRCChannel; Content: String);
    procedure IRCNames(Sender: TObject; AUsers: TIdIRCUsers;
      AChannel: TIdIRCChannel);
    procedure IRCPart(Sender: TObject; AUser: TIdIRCUser;
      AChannel: TIdIRCChannel);
    procedure btnDisconnectClick(Sender: TObject);
    procedure IRCJoined(Sender: TObject; AChannel: TIdIRCChannel);
    procedure IRCConnect(Sender: TObject);
    procedure IRCReceive(Sender: TObject; ACommand: String);
    procedure IRCRaw(Sender: TObject; AUser: TIdIRCUser; ACommand,
      AContent: String; var Suppress: Boolean);
  private
    { Private declarations }
    _rooms: TStringlist;

    function GetRoom(AChannel: TIdIRCChannel): TIRCRoom;
    
  public
    { Public declarations }
    server: String;
    port: string;
    nickname: string;
    alt: string;
    plugin: TObject;

    procedure MonitorChannel(c: string; room: TObject);
    procedure RemoveChannel(c: string);
  end;

var
  frmIRC: TfrmIRC;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
implementation

{$R *.dfm}
uses
    ActiveX, IRCPlugin;

{---------------------------------------}
constructor TIRCRoom.Create();
begin
    plug := TIRCRoomPlugin.Create(Self);
end;

{---------------------------------------}
destructor TIRCRoom.Destroy();
begin
    plug.Free();
end;

{---------------------------------------}
procedure TfrmIRC.btnConnectClick(Sender: TObject);
begin
    // try to connect
    irc.Host := server;
    irc.Port := StrToIntDef(port, 6667);
    irc.AltNick := alt;
    irc.Nick := Nickname;

    irc.Connect();
end;

{---------------------------------------}
procedure TfrmIRC.IRCConnected(Sender: TObject);
begin
    Status.Lines.Add('Connected to IRC Server');
    btnConnect.Enabled := false;
    btnDisconnect.Enabled := true;
    btnJoin.Enabled := true;
end;

{---------------------------------------}
procedure TfrmIRC.IRCSystem(Sender: TObject; AUser: TIdIRCUser;
  ACmdCode: Integer; ACommand, AContent: String);
begin
    Status.Lines.Add('SERVER: ' + AContent);
end;

{---------------------------------------}
procedure TfrmIRC.IRCStatus(ASender: TObject; const AStatus: TIdStatus;
  const AStatusText: String);
begin
    Status.Lines.Add(AStatusText);
end;

{---------------------------------------}
procedure TfrmIRC.IRCDisconnected(Sender: TObject);
begin
    btnConnect.Enabled := true;
    btnDisconnect.Enabled := false;
    btnJoin.Enabled := false;
end;

{---------------------------------------}
procedure TfrmIRC.btnJoinClick(Sender: TObject);
var
    c: String;
    jid: string;
begin
    // Join a channel.
    c := 'jabber';
    if InputQuery('Channel Name', 'Channel: ', c) = false then exit;
    jid := c + '@' + irc.Host;
    TIRCPlugin(plugin).startRoom(Self, jid);
end;

{---------------------------------------}
procedure TfrmIRC.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    Action := caFree;
end;

{---------------------------------------}
procedure TfrmIRC.FormCreate(Sender: TObject);
begin
    _rooms := TStringlist.Create();
end;

{---------------------------------------}
procedure TfrmIRC.MonitorChannel(c: string; room: TObject);
begin
    _rooms.AddObject(c, room);
end;

{---------------------------------------}
procedure TfrmIRC.RemoveChannel(c: string);
var
    r: TIRCRoom;
    i: integer;
begin
    i := _rooms.IndexOf(c);
    if (i >= 0) then begin
        r := TIRCRoom(_rooms.Objects[i]);
        if (r <> nil) then
            FreeAndNil(r);
        _rooms.Delete(i);
    end;
end;

{---------------------------------------}
function TfrmIRC.GetRoom(AChannel: TIdIRCChannel): TIRCRoom;
var
    i: integer;
begin
    Result := nil;
    i := _rooms.IndexOf(AChannel.Name);
    if (i = -1) then exit;

    Result := TIRCRoom(_rooms.Objects[i]);
end;

{---------------------------------------}
procedure TfrmIRC.IRCAction(Sender: TObject; AUser: TIdIRCUser;
  AChannel: TIdIRCChannel; Content: String);
var
    r: TIRCRoom;
    jid, txt: string;
begin
    // display action
    r := GetRoom(AChannel);
    if (r = nil) then exit;

    txt := '/me ' + Content;
    jid := r.Jid + '/' + AUser.Nick;
    r.JRoom.DisplayMessage(txt, '', jid);
end;

{---------------------------------------}
procedure TfrmIRC.IRCMessage(Sender: TObject; AUser: TIdIRCUser;
  AChannel: TIdIRCChannel; Content: String);
var
    r: TIRCRoom;
    jid: string;
begin
    // display message
    r := GetRoom(AChannel);
    if (r = nil) then exit;

    jid := r.Jid + '/' + AUser.Nick;
    r.JRoom.DisplayMessage(Content, '', jid);
end;

{---------------------------------------}
procedure TfrmIRC.IRCNames(Sender: TObject; AUsers: TIdIRCUsers;
  AChannel: TIdIRCChannel);
var
    i: integer;
    r: TIRCRoom;
    jid: string;
begin
    // Add users
    r := GetRoom(AChannel);
    if (r = nil) then exit;
    
    for i := 0 to AUsers.Count - 1 do begin
        jid := r.jid + '/' + AUsers.Items[i].Nick;
        r.JRoom.AddRoomUser(jid, AUsers.Items[i].Nick);
    end;
end;

{---------------------------------------}
procedure TfrmIRC.IRCPart(Sender: TObject; AUser: TIdIRCUser;
  AChannel: TIdIRCChannel);
var
    jid: string;
    r: TIRCRoom;
begin
    r := GetRoom(AChannel);
    if (r = nil) then exit;

    jid := r.jid + '/' + AUser.Nick;
    r.jroom.RemoveRoomUser(jid);
end;

{---------------------------------------}
procedure TfrmIRC.btnDisconnectClick(Sender: TObject);
begin
    irc.Disconnect(true);
end;

{---------------------------------------}
procedure TfrmIRC.IRCJoined(Sender: TObject; AChannel: TIdIRCChannel);
begin
    Status.Lines.Add('JOINED: ' + AChannel.Name);
end;

{---------------------------------------}
procedure TfrmIRC.IRCConnect(Sender: TObject);
begin
    CoInitialize(nil);
end;

procedure TfrmIRC.IRCReceive(Sender: TObject; ACommand: String);
begin
    Status.Lines.Add('RECV: ' + ACommand);
end;

procedure TfrmIRC.IRCRaw(Sender: TObject; AUser: TIdIRCUser; ACommand,
  AContent: String; var Suppress: Boolean);
begin
    //
end;

initialization
  CoInitializeEx(nil, COINIT_MULTITHREADED);

finalization
  CoUninitialize();


end.
