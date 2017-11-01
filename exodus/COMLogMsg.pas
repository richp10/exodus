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
unit COMLogMsg;


{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  XMLTag, JabberMsg, ComObj, ActiveX, Exodus_TLB, StdVcl;

type
  TExodusLogMsg = class(TAutoObject, IExodusLogMsg)
  private
    _body: Widestring;
    _dir: Widestring;
    _from: Widestring;
    _to: Widestring;
    _id: Widestring;
    _type: Widestring;
    _nick: Widestring;
    _subject: Widestring;
    _thread: Widestring;
    _delay: Widestring;
    _extraXML: Widestring;

  public
    constructor Create(msg: TJabberMessage);

  protected
    // IExodusLogMsg
    function Get_Body: WideString; safecall;
    function Get_Direction: WideString; safecall;
    function Get_FromJid: WideString; safecall;
    function Get_ID: WideString; safecall;
    function Get_MsgType: WideString; safecall;
    function Get_Nick: WideString; safecall;
    function Get_Subject: WideString; safecall;
    function Get_Thread: WideString; safecall;
    function Get_Timestamp: WideString; safecall;
    function Get_ToJid: WideString; safecall;
    function Get_XML: WideString; safecall;

  end;

const
    LOG_MESSAGE_DIRECTION_OUT = 'out';
    LOG_MESSAGE_DIRECTION_IN  = 'in';

implementation

uses
    XMLUtils, ComServ;

constructor TExodusLogMsg.Create(msg: TJabberMessage);
begin
    if (msg.isMe) then
        _dir := LOG_MESSAGE_DIRECTION_OUT
    else
        _dir := LOG_MESSAGE_DIRECTION_IN;

    _nick := msg.Nick;
    _id := msg.id;
    _type := msg.MsgType;
    _from := msg.FromJid;
    _to := msg.ToJid;
    _body := msg.Body;
    _thread := msg.Thread;
    _subject := msg.Subject;
    _delay := DateTimeToJabber(msg.Time);
    _extraXML := msg.XML;
end;

function TExodusLogMsg.Get_Body: WideString;
begin
    Result := _body;
end;

function TExodusLogMsg.Get_Direction: WideString;
begin
    Result := _dir;
end;

function TExodusLogMsg.Get_FromJid: WideString;
begin
    Result := _from;
end;

function TExodusLogMsg.Get_ID: WideString;
begin
    Result := _id;
end;

function TExodusLogMsg.Get_MsgType: WideString;
begin
    Result := _type;
end;

function TExodusLogMsg.Get_Nick: WideString;
begin
    Result := _nick;
end;

function TExodusLogMsg.Get_Subject: WideString;
begin
    Result := _subject;
end;

function TExodusLogMsg.Get_Thread: WideString;
begin
    Result := _thread;
end;

function TExodusLogMsg.Get_Timestamp: WideString;
begin
    Result := _delay;
end;

function TExodusLogMsg.Get_ToJid: WideString;
begin
    Result := _to;
end;

function TExodusLogMsg.Get_XML: WideString;
begin
    Result := _extraXML;
end;


initialization
  TAutoObjectFactory.Create(ComServer, TExodusLogMsg, Class_ExodusLogMsg,
    ciMultiInstance, tmApartment);
end.
