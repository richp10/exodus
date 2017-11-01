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
unit XMLVCardCache;


interface

uses XMLVCard, XMLTag, Unicode, SysUtils, Classes;

type
  TXMLVCardEvent = procedure(UID: Widestring; vcard: TXMLVCard) of object;

  TXMLVCardCache = class;
  TXMLVCardCacheStatus = (vpsRefresh, vpsError, vpsOK);
  TXMLVCardCacheEntry = class(TXMLVCard)
  private
    _owner: TXMLVCardCache;
    _stored: Boolean;
    _jid: Widestring;
    _callbacks: TList;
    _iq: TObject;       //avoiding Session circular reference

    _status: TXMLVCardCacheStatus;

    procedure ResultCallback(event: string; tag: TXMLTag);
    procedure AddCallback(cb: TXMLVCardEvent; persist: Boolean = false);

    function CheckValidity(): Boolean;

    procedure Save();
    procedure Delete();
  public
    constructor Create(cache: TXMLVCardCache; jid: Widestring);
    destructor Destroy(); override;

    function Parse(tag: TXMLTag): Boolean; override;
    function Load(tag: TXMLTag; saved: Boolean = true): Boolean;

    property Jid: Widestring read _jid;
    property Status: TXMLVCardCacheStatus read _status;
    property IsValid: Boolean read CheckValidity;

  end;

  TXMLVCardCache = class
  private
    _cache: TWidestringList;
    _js: TObject;
    _sessionCB: Integer;
    _timeout: Integer;
    _ttl: Double;

    procedure FireUpdate(tag: TXMLTag);

  protected
    procedure SessionCallback(event: string; tag: TXMLTag); virtual;

    procedure Load(cache: TWidestringList); virtual;
    procedure SaveEntry(vcard: TXMLVCardCacheEntry); virtual;
    procedure DeleteEntry(vcard: TXMLVCardCacheEntry); virtual;

    function ObtainEntry(jid: Widestring; create: Boolean; var pending: TXMLVCardCacheEntry): Boolean;
    function GetVCard(jid: Widestring): TXMLVCard;

  public
    constructor Create(js: TObject); virtual;
    destructor Destroy(); override;

    procedure find(jid: Widestring; cb: TXMLVCardEvent; refresh: Boolean = false);
    property VCards[Index: Widestring]: TXMLVCard read GetVCard;

    property Timeout: Integer read _timeout write _timeout;
    property TimeToLive: Double read _ttl write _ttl;
  end;


function GetVCardCache(): TXMLVCardCache;
procedure SetVCardCache(cache: TXMLVCardCache);

const
    DEPMOD_VCARD_CACHE: Widestring = 'vcard-cache';

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
implementation

uses ExSession, Exodus_TLB, ComObj,
    IQ, PrefController, Session, Signals, SqlUtils, XMLParser, XMLUtils;

var
    gVCardCache: TXMLVCardCache;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
function GetVCardCache(): TXMLVCardCache;
begin
    Result := gVCardCache;
end;
{---------------------------------------}
procedure SetVCardCache(cache: TXMLVCardCache);
begin
    if (gVCardCache <> nil) then begin
        gVCardCache.Free();
    end;

    gVCardCache := cache;
end;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
constructor TXMLVCardCache.Create(js: TObject);
var
    session: TJabberSession;
begin
    _js := js;

    Assert(_js is TJabberSession);

    session := TJabberSession(_js);
    _sessionCB := session.RegisterCallback(SessionCallback, '/session');
    _timeout := session.Prefs.getInt('vcard_iq_timeout');
    _ttl := session.Prefs.getInt('vcard_cache_ttl');
    
    _cache := TWidestringList.Create();
    Load(_cache);
end;

{---------------------------------------}
destructor TXMLVCardCache.Destroy();
var
    idx: Integer;
begin
    for idx := 0 to _cache.Count - 1 do begin
        TXMLVCardCacheEntry(_cache.Objects[idx]).Free();
    end;
    _cache.Clear();
    FreeAndNil(_cache);

    if (_js <> nil) then begin
        if (_sessionCB <> -1) then TJabberSession(_js).UnRegisterCallback(_sessionCB);
    end;
end;

{---------------------------------------}
procedure TXMLVCardCache.Load(cache: TWidestringList);
begin

end;
{---------------------------------------}
procedure TXMLVCardCache.SaveEntry(vcard: TXMLVCardCacheEntry);
begin
end;
{---------------------------------------}
procedure TXMLVCardCache.DeleteEntry(vcard: TXMLVCardCacheEntry);
begin
end;

{---------------------------------------}
procedure TXMLVCardCache.SessionCallback(event: string; tag: TXMLTag);
var
    idx: Integer;
    pending: TXMLVCardCacheEntry;
begin
    if (event = '/session/disconnected') then begin
        //clear out error-ed vcards, so we can refresh them
         for idx := _cache.Count - 1 downto 0 do begin
            pending := TXMLVCardCacheEntry(_cache.Objects[idx]);
            if pending.Status <> vpsError then continue;
            
            pending.Free();
            _cache.Delete(idx);
         end;
    end;
end;
{---------------------------------------}
procedure TXMLVCardCache.FireUpdate(tag: TXMLTag);
begin
    TJabberSession(_js).FireEvent('/session/vcard/update', tag);
end;

{---------------------------------------}
function TXMLVCardCache.ObtainEntry(
        jid: WideString;
        create: Boolean;
        var pending: TXMLVCardCacheEntry): Boolean;
var
    idx: Integer;
begin
    idx := _cache.IndexOf(jid);
    pending := nil;
    Result := false;
    if (idx <> -1) then begin
        pending := TXMLVCardCacheEntry(_cache.Objects[idx]);
    end
    else if create then begin
        pending := TXMLVCardCacheEntry.Create(Self, jid);
        _cache.AddObject(jid, pending);
        Result := true;
    end;
end;

{---------------------------------------}
function TXMLVCardCache.GetVCard(jid: WideString): TXMLVCard;
var
    pending: TXMLVCardCacheEntry;
begin
    ObtainEntry(jid, false, pending);
    if (pending <> nil) and (not pending.IsValid) then
        pending := nil;
        
    result := pending;
end;


{---------------------------------------}
procedure TXMLVCardCache.find(jid: WideString; cb: TXMLVCardEvent; refresh: Boolean);
var
    pending: TXMLVCardCacheEntry;
begin
    //check the cache
    if ObtainEntry(jid, true, pending) then
        refresh := true     //new pending == refresh
    else if (pending.Status = vpsRefresh) then
        refresh := true;    //stale == refresh

    if (refresh) then begin
        //do (first or another) vcard request, fire callback later
        pending._status := vpsRefresh;
        pending.AddCallback(cb);
    end
    else if Assigned(cb) then begin
        //cached result, fire callback now
        if pending.IsValid then
            cb(jid, pending)
        else
            cb(jid, nil);
    end;
end;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
type
    PXMLVCardEventCallback = ^TXMLVCardEventCallback;
    TXMLVCardEventCallback = record
        Callback: TXMLVCardEvent;
        Persist: Boolean;
    end;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
constructor TXMLVCardCacheEntry.Create(cache: TXMLVCardCache; jid: WideString);
begin
    inherited Create();

    _owner := cache;
    _jid := jid;
    _callbacks := TList.Create();
    _iq := nil;
    _status := vpsRefresh;
end;

{---------------------------------------}
destructor TXMLVCardCacheEntry.Destroy;
begin
    while (_callbacks.Count > 0) do begin
        Dispose(_callbacks[0]);
        _callbacks.Delete(0);
    end;

    FreeAndNil(_callbacks);
    _iq := nil;
    Picture := nil;

    inherited;
end;

{---------------------------------------}
function TXMLVCardCacheEntry.Parse(tag: TXMLTag): Boolean;
begin
    Result := inherited Parse(tag);

    if not Result then
        _status := vpsError
    else begin
        _status := vpsOK;
        TimeStamp := Now();
    end;
end;

{---------------------------------------}
function TXMLVCardCacheEntry.Load(tag: TXMLTag; saved: Boolean): Boolean;
begin
    Result := Parse(tag);

    if Result then begin
        if (not saved) then
            Save()
        else
            _stored := true;
    end;
end;

{---------------------------------------}
procedure TXMLVCardCacheEntry.Save();
begin
    if _stored then exit;

    _owner.SaveEntry(Self);
    _stored := true;
end;
{---------------------------------------}
procedure TXMLVCardCacheEntry.Delete();
begin
    if not _stored then exit;

    _owner.DeleteEntry(Self);
    _stored := false;
end;

{---------------------------------------}
function TXMLVCardCacheEntry.CheckValidity(): Boolean;
begin
    if (_status = vpsOK) then begin
        //double-check TTL here
        if (Now() - _owner.TimeToLive) > Self.TimeStamp then
            _status := vpsRefresh;
    end;

    Result := (_status = vpsOK);
    if not Result then Delete();
end;

{---------------------------------------}
procedure TXMLVCardCacheEntry.ResultCallback(event: string; tag: TXMLTag);
var
    vcard: TXMLVCard;
    cb: PXMLVCardEventCallback;
    idx: Integer;
begin
    vcard := nil;
    _iq := nil;
    if (event = 'xml') then begin
        if (tag.GetAttribute('type') = 'result') then begin
            Parse(tag);
            Save();
            _status := vpsOK;
            vcard := Self;
        end
        else begin
            Delete();
            _status := vpsError;
        end;
    end
    else if (event = 'timeout') then begin
        Delete();
        _status := vpsRefresh;
    end
    else begin
        //shouldn't happen, but...
        exit;
    end;

    for idx := _callbacks.Count - 1 downto 0 do begin
        cb := PXMLVCardEventCallback(_callbacks[idx]);

        try
            cb^.Callback(_jid, vcard);
        except
            //TODO:  loggit
        end;

        if (not cb^.Persist) then begin
            _callbacks.Delete(idx);
            Dispose(cb);
        end;
    end;

    if (vcard <> nil) then begin
        _owner.FireUpdate(tag);
    end;
end;

{---------------------------------------}
procedure TXMLVCardCacheEntry.AddCallback(cb: TXMLVCardEvent; persist: Boolean);
var
    session: TJabberSession;
    iq: TJabberIQ;
    cbe: PXMLVCardEventCallback;
begin
    if Assigned(cb) then begin
        new(cbe);
        cbe^.Callback := cb;
        cbe^.Persist := persist;
        _callbacks.Add(cbe);
    end;

    if (_status = vpsRefresh) and (_iq = nil) then begin
        session := TJabberSession(_owner._js);
        iq := TJabberIQ.Create(
                session,
                session.generateID,
                ResultCallback,
                _owner.Timeout);
        iq.Namespace := 'vcard-temp';
        iq.iqType := 'get';
        iq.qTag.Name := 'vCard';
        iq.toJid := _jid;
        _iq := iq;

        iq.Send();
    end;
end;

initialization
    gVCardCache := nil;

finalization
    gVCardCache.Free();
    gVCardCache := nil;

end.
