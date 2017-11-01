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
unit RoomPlugin;

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  ExodusCOM_TLB, ComObj, ActiveX, ExIRCPlugin_TLB, StdVcl;

type
  TIRCRoomPlugin = class(TAutoObject, IExodusChatPlugin)
  protected
    function onAfterMessage(var Body: WideString): WideString; safecall;
    procedure onBeforeMessage(var Body: WideString); safecall;
    procedure onClose; safecall;
    procedure onContextMenu(const ID: WideString); safecall;
    procedure onKeyPress(const Key: WideString); safecall;
    procedure onMenu(const ID: WideString); safecall;
    procedure onNewWindow(HWND: Integer); safecall;
    procedure onRecvMessage(const Body, xml: WideString); safecall;
  private
    _room: TObject;

  public
    constructor Create(room: TObject);
  end;

implementation

uses
    JabberID, IRCSession, ComServ;

constructor TIRCRoomPlugin.Create(room: TObject);
begin
    _room := room;
end;

function TIRCRoomPlugin.onAfterMessage(var Body: WideString): WideString;
begin

end;

procedure TIRCRoomPlugin.onBeforeMessage(var Body: WideString);
begin

end;

procedure TIRCRoomPlugin.onClose;
var
    r: TIRCRoom;
    c: string;
    tmp_jid: TJabberID;
begin
    r := TIRCRoom(_room);
    tmp_jid := TJabberID.Create(r.jid);
    c := '#' + tmp_jid.user;
    r.sess.IRC.Part(c);
    r.sess.RemoveChannel(tmp_jid.user);
    tmp_jid.Free();
end;

procedure TIRCRoomPlugin.onContextMenu(const ID: WideString);
begin

end;

procedure TIRCRoomPlugin.onKeyPress(const Key: WideString);
begin

end;

procedure TIRCRoomPlugin.onMenu(const ID: WideString);
begin

end;

procedure TIRCRoomPlugin.onNewWindow(HWND: Integer);
begin

end;

procedure TIRCRoomPlugin.onRecvMessage(const Body, xml: WideString);
begin

end;

initialization
  TAutoObjectFactory.Create(ComServer, TIRCRoomPlugin, Class_IRCRoomPlugin,
    ciMultiInstance, tmApartment);
end.
