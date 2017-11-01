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
{$A+,B-,C+,D+,E-,F-,G+,H+,I+,J-,K-,L+,M-,N+,O+,P+,Q-,R-,S-,T-,U-,V+,W+,X+,Y+,Z1}
{$MINSTACKSIZE $00004000}
{$MAXSTACKSIZE $00100000}
{$IMAGEBASE $00400000}
{$APPTYPE GUI}




{$ifdef VER150}
    {$define INDY9}
{$endif}

unit XMLHttpStream;

interface

uses
    XMLTag,
    XMLStream,
    PrefController,
    {$ifdef linux}
    QExtCtrls,
    {$else}
    ExtCtrls,
    {$endif}

    {$ifdef INDY9}
    IdHTTPHeaderInfo,
    IdCoderMime,
    {$else}
    IdCoder3To4,
    {$endif}

    Classes, SysUtils, IdException, SecHash,
    IdHTTP, SyncObjs;

type
    THttpThread = class;

    TXMLHttpStream = class(TXMLStream)
    private
        _thread:    THttpThread;
    protected
        procedure MsgHandler(var msg: TJabberMsg); message WM_JABBER;
        procedure SendXML(xml: Widestring); override;
    public
        constructor Create(root: string); override;
        destructor Destroy; override;

        procedure Connect(profile: TJabberProfile); override;

        procedure Disconnect; override;
        function  isSSLCapable(): boolean; override;
        procedure EnableSSL(); override;
        procedure EnableCompression(); override;
    end;

    THttpThread = class(TParseThread)
    private
        _profile : TJabberProfile;
        _poll_id: string;
        _poll_time: integer;
        _http: TIdHttp;
        _request: TStringlist;
        _strstream: TStringStream;
        _response: TStringStream;
        _lock: TCriticalSection;
        _event: TEvent;
        _hasher : TSecHash;
        {$ifdef INDY9}
        _encoder: TIdEncoderMIME;
        {$else}
        _encoder: TIdBase64Encoder;
        _cookie_list : TStringList;
        {$endif}

        _keys: array of string;
        _kcount: integer;

        procedure GenKeys();
        procedure DoPost();
    protected
        procedure Run; override;
    public
        constructor Create(strm: TXMLHttpStream; profile: TJabberProfile; root: string);
        destructor Destroy(); override;

        procedure Send(xml: WideString);
        procedure Disconnect(end_tag: string);
end;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
implementation
uses
    {$ifdef Win32}
    Registry, StrUtils,
    {$endif}
    {$ifdef INDY9}
    IdCookie,
    {$endif}
    Session,
    IdGlobal;

const
    MIN_TIME : integer = 250;
    INCREASE_FACTOR : single = 1.5;

{---------------------------------------}
constructor TXMLHttpStream.Create(root: string);
begin
    //
    inherited;
    _thread := nil;
end;

{---------------------------------------}
destructor TXMLHttpStream.Destroy;
begin
    //
    inherited;
end;

{---------------------------------------}
procedure TXMLHttpStream.Connect(profile: TJabberProfile);
begin
    // kick off the thread.

    // TODO: check to see if the thread will get freed when it stops
    _thread := THttpThread.Create(Self, profile, _root_tag);
    _thread.doMessageSync(WM_CONNECTED);
    _thread.Start();
end;

{---------------------------------------}
function TXMLHttpStream.isSSLCapable(): boolean;
begin
    Result := false;
end;

{---------------------------------------}
procedure TXMLHttpStream.EnableSSL();
begin
    // no-op..
    assert(false);
end;

procedure TXMLHttpStream.EnableCompression();
begin
    // no-op..
    assert(false);
end;

{---------------------------------------}
procedure TXMLHttpStream.SendXML(xml: Widestring);
begin
    if (_thread <> nil) then begin
        FireOnStreamData(true, xml);
        _thread.Send(xml);
    end;
end;

{---------------------------------------}
procedure TXMLHttpStream.Disconnect;
var
end_tag: string;
begin
end_tag := '</' + Self._root_tag + '>';
    FireOnStreamData(true, end_tag);
    _thread.Disconnect(end_tag);
    _thread.doMessageSync(WM_DISCONNECTED);

    // Note that the free will free itself.
end;

{---------------------------------------}
procedure TXMLHttpStream.MsgHandler(var msg: TJabberMsg);
var
    tag: TXMLTag;
begin
    //
    case msg.lparam of

        WM_XML: begin
            // We are getting XML data from the thread
            if _thread = nil then exit;

            tag := _thread.GetTag;
            if tag <> nil then
            begin
                fireOnPacketReceived(tag);
                tag.Free();
            end;
          end;

        WM_CONNECTED: begin
            // Socket is connected
            _active := true;
            FireOnStreamEvent('connected', nil);
        end;

        WM_DISCONNECTED: begin
            // Socket is disconnected
            _active := false;
            FireOnStreamEvent('disconnected', nil);
        end;
        WM_COMMERROR: begin
            // There was a COMM ERROR
            _active := false;
            FireOnStreamEvent('commerror', nil);
            FireOnStreamEvent('disconnected', nil);
        end;
    end;
end;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
constructor THttpThread.Create(strm: TXMLHttpStream; profile: TJabberProfile; root: string);
begin
    inherited Create(strm, root);

    _profile := profile;
    _poll_id := '0';
    _poll_time := MIN_TIME;
    _http := TIdHTTP.Create(nil);
    {$ifdef INDY9}
    _http.AllowCookies := true;
    _http.ProtocolVersion := pv1_1;
    _http.HTTPOptions := [hoKeepOrigProtocol];
    {$endif}
    MainSession.Prefs.setProxy(_http);
    
    _lock := TCriticalSection.Create();
    _event := TEvent.Create(nil, false, false, 'exodus_http_poll');
    _hasher := TSecHash.Create(nil);
    {$ifdef INDY9}
    _encoder := TIdEncoderMIME.Create(nil);
    {$else}
    _encoder := TIdBase64Encoder.Create(nil);
    _cookie_list := TStringList.Create();
    _cookie_list.Delimiter := ';';
    _cookie_list.QuoteChar := #0;
    {$endif}
    SetLength(_keys, _profile.NumPollKeys);
    GenKeys();

    _request := TStringlist.Create();
    _response := TStringstream.Create('');
    _strstream := TStringstream.Create('');
end;

{---------------------------------------}
destructor THttpThread.Destroy();
begin
   _lock.Free();
   _hasher.Free();
   _encoder.Free();
   _event.Free();
   {$ifndef INDY9}
   _cookie_list.Free();
   {$endif}
   _http.Free();
   _request.Free();
   _response.Free();
   _strstream.Free();
end;

procedure THttpThread.GenKeys;
var
    i, j : integer;
    seed : string;
    b: TByteDigest;
    ts : string;
begin
    for i := 1 to 21 do
        seed := seed + chr(random(95) + 32);

    _kcount := length(_keys) - 1;
    for i := 0 to _kcount do begin
        b := _hasher.IntDigestToByteDigest(_hasher.ComputeString(seed));
        ts := '';
        for j := 0 to 19 do
            ts := ts + chr(b[j]);
        {$ifdef INDY9}
        seed := _encoder.Encode(ts);
        _keys[i] := seed;
        {$else}
        _encoder.CodeString(ts);
        seed := _encoder.CompletedInput;
        Fetch(seed, ';');
        _keys[i] := seed;
        {$endif}
    end;
end;

{---------------------------------------}
procedure THttpThread.Send(xml: Widestring);
begin
    _lock.Acquire();
    _request.Add(UTF8Encode(xml));
    _lock.Release();
    _event.SetEvent();
end;

{---------------------------------------}
procedure THttpThread.DoPost();
var
    key : string;
begin
    // nuke whatever is currently in the stream
    _response.Size := 0;

    key := _poll_id + ';' + _keys[_kcount];
    dec(_kcount);
    if (_kcount < 0) then begin
        GenKeys();
        key := key + ';' + _keys[_kcount];
        dec(_kcount);
        Assert(_kcount <> 0);
    end;

        // _request.Insert(0, key + ',');
    _strstream.WriteString(key);
    _strstream.WriteString(',');
    _strstream.WriteString(_request.Text);
    try
        _lock.Acquire();
        _http.Post(_profile.URL, _strstream, _response);
        _strstream.Size := 0;
        _request.Clear();
        _lock.Release();
    except
        on E: Exception do begin
            if (not Self.Stopped) then begin
                doMessage(WM_COMMERROR);
                Self.Terminate();
            end;
            exit;
        end;
    end;
end;

{---------------------------------------}
procedure THttpThread.Run();
var
{$ifndef INDY9}
    new_cookie: string;
    i: integer;
{$else}
    cookie: TIdCookieRFC2109;
{$endif}
    r, pid: string;
begin
    // Bail if we're stopped.
    if ((Self.Stopped) or (Self.Suspended) or (Self.Terminated)) then
        exit;

    Self.DoPost();

    // parse the response stream
    if (_http.ResponseCode <> 200) then begin
        // HTTP error!
        doMessage(WM_COMMERROR);
        Self.Terminate();
        exit;
    end;

    pid := '';

    // Get the cookie values + parse them, looking for the ID
    {$ifdef INDY9}
    cookie := _http.CookieManager.CookieCollection.Cookie['ID', _http.URL.Host];
    if (cookie = nil) then begin
        // didn't get a valid cookie
        doMessage(WM_COMMERROR);
        Self.Terminate();
        exit;
    end;
    pid := cookie.Value;
    {$else}
    new_cookie := _http.Response.ExtraHeaders.Values['Set-Cookie'];
    _cookie_list.DelimitedText := new_cookie;
    for i := 0 to _cookie_list.Count - 1 do begin
        if (Pos('ID=', _cookie_list[i]) = 1) then begin
            pid := Copy(_cookie_list[i], 4, length(_cookie_list[i]));
            break;
        end;
    end;
    {$endif}

    if (_poll_id = '0') then begin
        _poll_id := pid;
    end;

    // compare the most recent pid with our stored poll_id
    // if ((pid = '') or AnsiEndsStr(':0', pid) or (pid <> _poll_id)) then begin
    if ((pid = '') or (Pos(':0', pid) = length(pid) - 1) or (pid <> _poll_id)) then begin
        // something really bad has happened!
        doMessage(WM_COMMERROR);
        Self.Terminate();
        exit;
    end;

    r := UTF8Decode(_response.DataString);
    if (r <> '') then begin
        Push(r);
        _poll_time := MIN_TIME;
    end
    else if (_poll_time <> _profile.Poll) then begin
        _poll_time := Trunc(_poll_time * INCREASE_FACTOR);
        if (_poll_time >= _profile.Poll) then
            _poll_time := _profile.Poll;
    end;

    _event.WaitFor(_poll_time);
end;

{---------------------------------------}
procedure THttpThread.Disconnect(end_tag: string);
begin
    // Yes, we analyzed to see if there is a race condition.
    // There's not.
    Stop();
    _event.SetEvent();
    if (end_tag <> '') then begin
        Send(end_tag);
        DoPost();
    end;

    // Free me.  Touch me.  Feel me.
    Terminate();
end;

end.
