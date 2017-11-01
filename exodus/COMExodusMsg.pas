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
unit COMExodusMsg;


{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  XMLTag, JabberMsg, ComObj, ActiveX, Exodus_TLB, StdVcl;

type
  TExodusMsg = class(TAutoObject, IExodusMsg)
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
    _additionalXML: Widestring;
    _rawXML: Widestring;
    _priority: integer;

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
    function Get_AdditionalXML: WideString; safecall;
    procedure FillMsg(const ID, Timestamp, ToJid, FromJid: WideString;
      Priority: Integer; const Nick, Direction, MsgType, Thread, Subject, Body,
      AdditionalXML, RawMsgXML: WideString); safecall;
    procedure Set_Body(const Value: WideString); safecall;
    procedure Set_Direction(const Value: WideString); safecall;
    procedure Set_FromJid(const Value: WideString); safecall;
    procedure Set_ID(const Value: WideString); safecall;
    procedure Set_MsgType(const Value: WideString); safecall;
    procedure Set_Nick(const Value: WideString); safecall;
    procedure Set_Subject(const Value: WideString); safecall;
    procedure Set_Thread(const Value: WideString); safecall;
    procedure Set_Timestamp(const Value: WideString); safecall;
    procedure Set_ToJid(const Value: WideString); safecall;
    procedure Set_AdditionalXML(const Value: WideString); safecall;
    function Get_RawMsgXML: WideString; safecall;
    procedure Set_RawMsgXML(const Value: WideString); safecall;
    function Get_Priority: Integer; safecall;
    procedure Set_Priority(Value: Integer); safecall;

  end;

const
    LOG_MESSAGE_DIRECTION_OUT = 'out';
    LOG_MESSAGE_DIRECTION_IN  = 'in';

implementation

uses
    XMLUtils, ComServ;

constructor TExodusMsg.Create(msg: TJabberMessage);
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
    _additionalXML := msg.XML;
    _rawXML := msg.Tag.xml;
    case msg.Priority of
        high: _priority := 0;
        medium: _priority := 1;
        low: _priority := 2;
        none: _priority := 3;
    end;
end;

function TExodusMsg.Get_Body: WideString;
begin
    Result := _body;
end;

function TExodusMsg.Get_Direction: WideString;
begin
    Result := _dir;
end;

function TExodusMsg.Get_FromJid: WideString;
begin
    Result := _from;
end;

function TExodusMsg.Get_ID: WideString;
begin
    Result := _id;
end;

function TExodusMsg.Get_MsgType: WideString;
begin
    Result := _type;
end;

function TExodusMsg.Get_Nick: WideString;
begin
    Result := _nick;
end;

function TExodusMsg.Get_Subject: WideString;
begin
    Result := _subject;
end;

function TExodusMsg.Get_Thread: WideString;
begin
    Result := _thread;
end;

function TExodusMsg.Get_Timestamp: WideString;
begin
    Result := _delay;
end;

function TExodusMsg.Get_ToJid: WideString;
begin
    Result := _to;
end;

function TExodusMsg.Get_AdditionalXML: WideString;
begin
    Result := _additionalXML;
end;

procedure TExodusMsg.FillMsg(const ID, Timestamp, ToJid,
  FromJid: WideString; Priority: Integer; const Nick, Direction, MsgType,
  Thread, Subject, Body, AdditionalXML, RawMsgXML: WideString);
begin
    _body := Body;
    _dir := Direction;
    _from := FromJid;
    _to := ToJid;
    _id := ID;
    _type := MsgType;
    _nick := Nick;
    _subject := Subject;
    _thread := Thread;
    _delay := Timestamp;
    _additionalXML := AdditionalXML;
    _rawXML := RawMsgXML;
    _priority := Priority;
end;        

procedure TExodusMsg.Set_Body(const Value: WideString);
begin
    _body := Value;
end;

procedure TExodusMsg.Set_Direction(const Value: WideString);
begin
    _dir := Value;
end;

procedure TExodusMsg.Set_FromJid(const Value: WideString);
begin
    _from := Value;
end;

procedure TExodusMsg.Set_ID(const Value: WideString);
begin
    _id := Value;
end;

procedure TExodusMsg.Set_MsgType(const Value: WideString);
begin
    _type := Value;
end;

procedure TExodusMsg.Set_Nick(const Value: WideString);
begin
    _nick := Value;
end;

procedure TExodusMsg.Set_Subject(const Value: WideString);
begin
    _subject := Value;
end;

procedure TExodusMsg.Set_Thread(const Value: WideString);
begin
    _thread := Value;
end;

procedure TExodusMsg.Set_Timestamp(const Value: WideString);
begin
    _delay := Value;
end;

procedure TExodusMsg.Set_ToJid(const Value: WideString);
begin
    _to := Value;
end;

procedure TExodusMsg.Set_AdditionalXML(const Value: WideString);
begin
    _additionalXML := Value;
end;

function TExodusMsg.Get_RawMsgXML: WideString;
begin
    Result := _rawXML;
end;

procedure TExodusMsg.Set_RawMsgXML(const Value: WideString);
begin
    _rawXML := Value;
end;

function TExodusMsg.Get_Priority: Integer;
begin
    Result := _priority;
end;

procedure TExodusMsg.Set_Priority(Value: Integer);
begin
    _priority := Value;
end;

initialization
  TAutoObjectFactory.Create(ComServer, TExodusMsg, Class_ExodusMsg,
    ciMultiInstance, tmApartment);
end.
