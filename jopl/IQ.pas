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
unit IQ;


interface

uses
    XMLTag,
    Signals, 
    Session,
    {$ifdef Win32}
    ExtCtrls, Windows, StdVcl,
    {$else}
    QExtCtrls,
    {$endif}
    Classes, SysUtils;

const
    BRANDED_MIN_TIMEOUT = 'brand_minimum_iq_timeout';
    DEFAULT_TIMEOUT = 15;

    IQ_EVENT_TIMEOUT = 'timeout';
    IQ_EVENT_DISCONNECTED = '/session/disconnected';
    IQ_EVENT_XML = 'xml';

    IQ_ATTRIB_ELASPED_TIME = 'iq_elapsed_time';
type
    TJabberIQ = class(TXMLTag)
    private
        _id: Widestring;
        _js: TJabberSession;
        _Callback: TPacketEvent;
        _cbIndex: integer;
        _cbSession: integer;
        _timer: TTimer;
        _ticks: longint;
        _timeout: longint;
        _sent: boolean;
        _callbackFired: boolean;
        _cbClassname: string;
        _cbMethodname: string;
    protected
        procedure fireCallback(event: string; tag: TXMLTag = nil);virtual;
        procedure Timeout(Sender: TObject);virtual;
        procedure iqCallback(event: string; xml: TXMLTag);virtual;
        procedure disCallback(event: string; xml: TXMLTag);virtual;
    public
        Namespace: string;
        iqType: string;
        toJid: Widestring;
        qTag: TXMLTag;

        constructor Create(session: TJabberSession;
                           id: Widestring;
                           cb: TPacketEvent;
                           seconds: longint = -1); reintroduce; overload;

        constructor Create(session: TJabberSession;
                           id: Widestring;
                           seconds: longint = -1); reintroduce; overload;

        constructor Create(session: TJabberSession;
                           id: Widestring;
                           payload: TXMLTag;
                           cb: TPacketEvent;
                           seconds: longint = -1); reintroduce; overload;

        destructor Destroy; override;
        procedure Send; virtual;

        property ElapsedTime: longint read _ticks;
        property JabberSession: TJabberSession read _js;
end;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
implementation
uses
    Math,
    Debug;
var
    _computedMinTimeout: integer;

constructor TJabberIQ.Create(session: TJabberSession;
                             id: Widestring;
                             seconds: longint);
begin
    inherited Create();

    _cbIndex := -1;
    _cbSession := -1;

    _cbClassname :=  'UnknownClass';
    _cbMethodname := 'UnknownMethod';

    _js := session;
    Assert(_js <> nil); //bad developer! bad!
    _id := id;
    Assert(_id <> ''); //bad developer! bad!

    _timer := TTimer.Create(nil);
    _timer.Interval := 1000;
    _timer.Enabled := false;
    _timer.OnTimer := Timeout;
    _ticks := 0;
    _sent := false;
    _callbackFired := false;
    //see if a default has been set in the prefs
    if (_computedMinTimeout = -1) then
        _computedMinTimeout := Max(DEFAULT_TIMEOUT, session.Prefs.getInt(BRANDED_MIN_TIMEOUT));

    _timeout := Max(_computedMinTimeout, seconds);

    // manip the xml tag
    Self.Name := 'iq';
    qTag := Self.AddTag('query');
end;


{---------------------------------------}
constructor TJabberIQ.Create(session: TJabberSession;
                             id: Widestring;
                             cb: TPacketEvent;
                             seconds: longint);
var
    tM: TMethod absolute cb;
begin
    create(Session, id, seconds);
    _callback := cb;
    if (Assigned(_callback)) then
    begin
        _cbClassname := TObject(tm.Data).ClassName;
        _cbMethodname := TObject(tm.Data).MethodName(tm.code);
    end;
end;

{---------------------------------------}
constructor TJabberIQ.Create(session: TJabberSession;
                             id: Widestring;
                             payload: TXMLTag;
                             cb: TPacketEvent;
                             seconds: longint);
begin
    create(Session, id, cb, seconds);
    //remove default query tag and add payload
    RemoveTag(qTag);

    qTag := Self.AddTag(TXMLTag.Create(payload));
end;

{---------------------------------------}
destructor TJabberIQ.Destroy;
begin
    _timer.Free;
    _callback := nil;

    if (_cbIndex <> -1) then
        _js.UnRegisterCallback(_cbIndex);
    _cbIndex := -1;

    if (_cbSession <> -1) then
        _js.UnRegisterCallback(_cbSession);
    _cbSession := -1;

    _js := nil;
    inherited Destroy;
end;

{---------------------------------------}
procedure TJabberIQ.Send;
begin
    Assert(not _sent); //one use only
    _sent := true;
    // if we're not connected, just bail
    if ((_js.Stream = nil) or (_js.Active = false)) then
        fireCallback(IQ_EVENT_DISCONNECTED)
    else begin
        Self.setAttribute('id', _id);
        if (toJID <> '') then        
            Self.setAttribute('to', toJID);

        if iqType <> '' then
            Self.setAttribute('type', iqType);

        if (qTag <> nil) then        
            qTag.setAttribute('xmlns', Namespace);

        if (_js.xmlLang <> '') then
            self.setAttribute('xml:lang', _js.xmlLang);

        _cbSession := _js.RegisterCallback(disCallback, '/session/disconnected');
        _cbIndex := _js.RegisterCallback(iqCallback, '/packet/iq[@id="' + _id + '"]');

        _js.Stream.Send(Self.xml);

        _ticks := 0;
        _timer.Enabled := true;
    end;
end;

procedure TJabberIQ.fireCallback(event: string; tag: TXMLTag);
var
    msg: string;
begin
    //dbl fire could happen if /session/disconnected is fired as a side effect
    //of the callback itself. just bail if that happens
    if (_callbackFired) then exit;
    _callbackFired := true;

    _timer.Enabled := false;
    try
        try
            if (Assigned(_callback)) then
                _callback(event, tag);
        except
            on E:Exception do
            begin
                msg := 'TJabberIQ (to: ' + toJID + ', Elasped: ' +
                       intTostr(_ticks) + '), raised an exception attempting to callback: ' +
                       _cbClassname + '.' + _cbMethodName + '(' + event + ', ';
                if (tag = nil) then
                    msg := msg + '<NULL>'
                else msg := msg + tag.XML;
                msg := msg + '), (' + e.message + ')';
                //raise Exception.create(msg); //may replace this with a data/debug event
                debugmessage(msg);
            end;
        end;
    finally
        Self.Free();  //always destroy self after callback
    end;
end;

{---------------------------------------}
procedure TJabberIQ.Timeout(Sender: TObject);
begin
    // we got a timer event. check to see if we are still waiting
    inc(_ticks);
    _timer.Enabled := (_ticks < _timeout);

    if (not _timer.Enabled) then //done, timed out
        fireCallback(IQ_EVENT_TIMEOUT);
end;

{---------------------------------------}
procedure TJabberIQ.iqCallback(event: string; xml: TXMLTag);
begin
    // callback from _js, result or error
    xml.setAttribute(IQ_ATTRIB_ELASPED_TIME, IntToStr(_ticks));
    fireCallback(IQ_EVENT_XML, xml);
end;

procedure TJabberIQ.disCallback(event: string; xml: TXMLTag);
begin
    fireCallback(IQ_EVENT_DISCONNECTED);
end;


initialization
    _computedMinTimeout := -1;

end.

