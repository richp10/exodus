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
unit Presence;


interface

uses
    XMLTag, JabberID, Signals, Unicode,
    Contnrs, SysUtils, classes;

function DecodeShowDisplayValue(show: Widestring): Widestring;

type
    TJabberCustomPres = class
    private
        _pri: SmallInt;
        procedure setPri(value: SmallInt);
    public
        Status: WideString;
        Show: WideString;
        title: WideString;
        hotkey: WideString;

        procedure Parse(tag: TXMLTag);
        procedure FillTag(tag: TXMLTag);

        property Priority: SmallInt read _pri write setPri;
    end;

    TJabberPres = class(TXMLTag)
    private
        _toJID: TJabberID;
        _fromJID: TJabberID;
        _pri: SmallInt;
        _tag: TXMLTag;
        procedure setToJid(value: TJabberID);
        procedure setFromJid(value: TJabberID);
        procedure setPri(value: SmallInt);
    public
        PresType: WideString;
        Status: WideString;
        Show: WideString;
        error_code: WideString;

        constructor Create; override;
        destructor Destroy; override;

        function XML: Widestring; override;
        function isSubscription: boolean;
        procedure parse();

        property toJid: TJabberID read _toJID write setToJid;
        property fromJid: TJabberID read _fromJID write setFromJid;
        property Priority: SmallInt read _pri write setPri;
        property Tag: TXMLTag read _tag;
    end;

    TJabberPPDB = class;

    TPresenceEvent = procedure(event: string; tag: TXMLTag; p: TJabberPres) of object;
    TPresenceListener = class(TSignalListener)
    public
    end;

    TPresenceSignal = class(TSignal)
    public
        procedure Invoke(event: string; tag: TXMLTag; p: TJabberPres = nil); overload;
        function addListener(callback: TPresenceEvent): TPresenceListener; overload;
    end;

    TJabberPPDB = class(TWideStringList)
    private
        _js: TObject;
        _last_pres: TJabberPres;

        function FindPresSpec(sjid, resource: Widestring): TJabberPres;
        procedure AddPres(p: TJabberPres);
        function  GetPresList(sjid: WideString): TWideStringList;
        function  IsRoomPres(jid: WideString): Boolean;
    published
        procedure Callback(event: string; tag: TXMLTag);
    public
        constructor Create;
        destructor Destroy; override;

        procedure SetSession(js: TObject);
        procedure Clear; override;

        function FindPres(sjid, resource: WideString): TJabberPres;
        function NextPres(last: TJabberPres): TJabberPres;
        property LastPres: TJabberPres read _last_pres;
        procedure DeletePres(p: TJabberPres);
    end;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
implementation
uses
    {$ifdef linux}
    QDialogs,
    {$else}
    Dialogs,
    {$endif}
    Entity, EntityCache, Session, XMLStream, XMLUtils;

//Decode the basic XMPP presence <show> values as nicer strings for UI
//TODO: Support Internationalization
function DecodeShowDisplayValue(show: Widestring): Widestring;
begin
    if (show = '') then
      result := 'Available'
    else if (show = 'chat') then
      result := 'Free to Chat'
    else if (show = 'away') then
      result := 'Away'
    else if (show = 'xa') then
      result := 'Extended Away'
    else if (show = 'dnd') then
      result := 'Do not Disturb'
    else
      result := show;
end;

{---------------------------------------}
constructor TJabberPres.Create;
begin
    inherited;
    _toJID := TJabberID.Create('');
    _fromJID := TJabberID.Create('');
    PresType := '';
    Status := '';
    Show := '';
    Priority := 0;
    Self.name := 'presence';
    error_code := '';
end;

{---------------------------------------}
destructor TJabberPres.Destroy;
begin
    _toJID.Free();
    _fromJID.Free();
    inherited Destroy;
end;

{---------------------------------------}
procedure TJabberPres.setToJid(value: TJabberID);
begin
    _toJid.Free();
    _toJid := value;
end;

{---------------------------------------}
procedure TJabberPres.setFromJid(value: TJabberID);
begin
    _fromJid.Free();
    _fromJid := value;
end;

{---------------------------------------}
procedure TJabberPres.setPri(value: SmallInt);
begin
    if (value > 128) then
        _pri := 128
    else if (value < -128) then
        _pri := -128
    else
        _pri := value;
end;

{---------------------------------------}
function TJabberPres.xml: Widestring;
var
    x: TXMLTag;
begin
    if toJID.jid <> '' then
        setAttribute('to', toJID.full);

    if fromJID.jid <> '' then
        setAttribute('from', fromJID.jid);

    x := Self.GetFirstTag('status');
    if (x <> nil) then Self.RemoveTag(x);
    x := Self.GetFirstTag('show');
    if (x <> nil) then Self.RemoveTag(x);
    x := Self.GetFirstTag('priority');
    if (x <> nil) then Self.RemoveTag(x);

    if (Status <> '') then
        Self.AddBasicTag('status', Status);

    if Show <> '' then
        Self.AddBasicTag('show', Show);

    if PresType <> '' then
        setAttribute('type', PresType);

    if Priority >= 0 then
        Self.AddBasicTag('priority', IntToStr(priority));

    Result := inherited xml;
end;

{---------------------------------------}
function TJabberPres.isSubscription: boolean;
begin
    // is this a subscription packet
    Result :=   (PresType = 'subscribe') or
                (PresType = 'subscribed') or
                (PresType = 'unsubscribe') or
                (PresType = 'unsubscribed');
end;

{---------------------------------------}
procedure TJabberPres.parse();
var
    err_tag, pri_tag, stat_tag, show_tag: TXMLTag;
    f,t: WideString;
begin
    // parse the tag into the proper elements
    stat_tag := self.GetFirstTag('status');
    show_tag := self.GetFirstTag('show');
    pri_tag  := self.GetFirstTag('priority');
    PresType := self.GetAttribute('type');

    if stat_tag <> nil then
        Status := stat_tag.Data;
    if show_tag <> nil then
        Show := show_tag.Data;
    if pri_tag <> nil then
        Priority := SToInt(Trim(pri_tag.Data));

    f := self.GetAttribute('from');
    t := self.GetAttribute('to');
    if f <> '' then
        fromJID.ParseJID(f);
    if t <> '' then
        toJID.ParseJID(t);

    if (presType = 'error') then begin
        // get the error code.
        err_tag := self.GetFirstTag('error');
        if (err_tag <> nil) then
            error_code := err_tag.getAttribute('code');
    end;
end;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
procedure TJabberCustomPres.Parse(tag: TXMLTag);
begin
    // parse the tag
    title := tag.getAttribute('name');
    show := tag.getBasicText('show');
    status := tag.GetBasicText('status');
    priority := SafeInt(tag.GetBasicText('priority'));
    hotkey := tag.GetBasicText('hotkey');
end;

{---------------------------------------}
procedure TJabberCustomPres.FillTag(tag: TXMLTag);
begin
    // populate into a tag
    tag.ClearTags();
    tag.setAttribute('name', title);
    tag.AddBasicTag('show', show);
    tag.AddBasicTag('status', status);
    tag.AddBasicTag('priority', IntToStr(priority));
    tag.AddBasicTag('hotkey', hotkey);
end;

{---------------------------------------}
procedure TJabberCustomPres.setPri(value: SmallInt);
begin
    if (value > 128) then
        _pri := 128
    else if (value < -128) then
        _pri := -128
    else
        _pri := value;
end;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
constructor TJabberPPDB.Create;
begin
    //
    inherited;
end;

{---------------------------------------}
destructor TJabberPPDB.Destroy;
begin
    Self.Clear();
    inherited Destroy;
end;

{---------------------------------------}
procedure TJabberPPDB.Clear;
var
    i: integer;
begin
    // Clear ea. string list which is contained in our list
    for i := 0 to Count - 1 do begin
        if (Objects[i] is TWideStringList) then
            ClearStringListObjects(TWideStringList(Objects[i]));
        TObject(Objects[i]).Free();
    end;

    inherited Clear();
end;

{---------------------------------------}
procedure TJabberPPDB.SetSession(js: TObject);
begin
    _js := js;
    with TJabberSession(_js) do begin
        RegisterCallback(Callback, '/packet/presence');
    end;
end;

{---------------------------------------}
procedure TJabberPPDB.Callback(event: string; tag: TXMLTag);
var
    p, curp: TJabberPres;
    pi: integer;
    s: TJabberSession;
    e: TJabberEntity;
begin
    // we are getting a new pres packet
    curp := TJabberPres.Create(tag);
    curp.Parse();
    _last_pres := curp;
    pi := Self.IndexOf(curp.fromJID.jid);
    s := TJabberSession(_js);

    // Process the pres packet
    if curp.PresType = 'unavailable' then begin
        // remove this resource from the PPDB
        p := FindPres(curp.fromJID.jid, curp.fromJID.resource);
        if p <> nil then begin
            DeletePres(p);
            p := FindPres(curp.fromJid.jid, '');

            // Update the EntityCache if necessary
            e := jEntityCache.getByJid(curp.fromJid.jid);
            if (e <> nil) then
            begin
                jEntityCache.Remove(e);
                e.Free();
            end;
            e := jEntityCache.getByJid(curp.fromJid.full);
            if (e <> nil) then
            begin
                jEntityCache.Remove(e);
                e.Free();
            end;

            // if there are no more presence packets, they are offline.
            if (p = nil) then begin
                if (not IsRoomPres(curp.fromJid.full)) then
                    s.FireEvent('/presence/offline', tag, curp);
            end
            else
                s.FireEvent('/presence/unavailable', tag, curp);
        end;
        curp.Free();
    end

    else if curp.PresType = 'error' then begin
        // some kind of error presence
        if ((MainSession.Invisible) and (curp.error_code = '400') and
        (tag.GetAttribute('from') = '') ) then begin
            // could be some kind of invisible packet bouncing..
            MainSession.Invisible := false;
            MainSession.setPresence('', 'Available', MainSession.Priority);
        end

        else if ((curp.error_code = '502') or
        (curp.error_code = '500') or
        (curp.error_code = '504')) then begin
            // we are getting a pres. packet for some kind of
            // invalid roster item
            s.FireEvent('/session/error/presence', tag);
            s.FireEvent('/presence/error', tag, curp);
        end
        else
            s.FireEvent('/presence/error', tag, curp);

        curp.Free();
    end

    else if (curp.PresType = 'subscribe') or
        (curp.PresType = 'subscribed') or
        (curp.PresType = 'unsubscribe') or
        (curp.PresType = 'unsubscribed') then begin
        // do nothing... some kind of s10n request
        s.FireEvent('/presence/subscription', tag, curp);
        curp.Free();
    end

    else begin
        // some kind of available pres
        p := FindPresSpec(curp.fromJID.jid, curp.fromJID.resource);
        if p <> nil then begin
            // this already exists, nuke it and put it back in
            Deletepres(p);
        end;
        AddPres(curp);

        if pi < 0 then begin
            // this person was offline
            MainSession.FireEvent('/presence/online', tag, curp);
        end;

        s.FireEvent('/presence/available', tag, curp);
    end;
end;

{---------------------------------------}
//
// We need to know if unavailable presence received is for the room.
// Assume that if domain is in the entity cache, it is conference component
// of the server.
function  TJabberPPDB.IsRoomPres(jid: WideString): Boolean;
var
    tmp: TJabberID;
    e: TJabberEntity;
begin
    Result := false;
    tmp := TJabberID.Create(jid);
    e := jEntityCache.getByJid(tmp.domain, '');
    if ((e <> nil) and (e.hasFeature('groupchat'))) then
        Result := true;
    tmp.Free();
end;
{---------------------------------------}
procedure TJabberPPDB.AddPres(p: TJabberPres);
var
    pl: TWideStringList;
    insert, i: integer;
    cp: TJabberPres;
begin
    // Add the presence packet to the PPDB
    pl := GetPresList(p.fromJID.jid);
    if pl <> nil then begin
        // list already exists
        insert := -1;

        // scan for the correct insertion point
        for i := 0 to pl.Count - 1 do begin
            cp := TJabberPres(pl.Objects[i]);
            if (cp.priority <= p.priority) then begin
                insert := i;
                break;
            end;
        end;

        if (insert = -1) then
            pl.AddObject(p.fromJID.resource, p)
        else
            pl.InsertObject(insert, p.fromJID.resource, p);
    end
    else begin
        // Create a string list for this JID..
        // and add it to our own list
        pl := TWideStringList.Create;
        pl.AddObject(p.fromJID.Resource, p);

        Self.AddObject(WideLowerCase(p.fromJID.jid), pl);
    end;
end;

{---------------------------------------}
procedure TJabberPPDB.DeletePres(p: TJabberPres);
var
    i: integer;
    pl: TWideStringList;
begin
    // delete this presence packet
    pl := GetPresList(p.fromJID.jid);
    if pl <> nil then begin
        i := pl.indexOfObject(p);
        p.Free;
        if i >= 0 then
            pl.Delete(i);

        if pl.Count <= 0 then begin
            i := self.indexOfObject(pl);
            pl.Free;
            if i >= 0 then Delete(i);
        end;
    end;
end;

{---------------------------------------}
function TJabberPPDB.GetPresList(sjid: WideString): TWideStringList;
var
    pi: integer;
begin
    pi := indexOf(WideLowerCase(sjid));
    if pi >= 0 then
        Result := TWideStringList(Objects[pi])
    else
        Result := nil;
end;

{---------------------------------------}
function TJabberPPDB.FindPresSpec(sjid, resource: Widestring): TJabberPres;
var
    pl: TWideStringList;
    pi: integer;
begin
    // find the next or pri presence packet
    Result := nil;
    pl := GetPresList(sjid);
    if pl <> nil then begin
        pi := pl.indexOf(resource);
        if pi >= 0 then
            Result := TJabberPres(pl.Objects[pi]);
    end;
end;

{---------------------------------------}
function TJabberPPDB.FindPres(sjid, resource: WideString): TJabberPres;
var
    pl: TWideStringList;
    pi: integer;
begin
    // find the next or pri presence packet
    Result := nil;

    pl := GetPresList(sjid);
    if pl <> nil then begin
        if resource <> '' then begin
            pi := pl.indexOf(resource);
            if pi >= 0 then
                Result := TJabberPres(pl.Objects[pi]);
        end
        else begin
            if pl.Count > 0 then
                Result := TJabberPres(pl.Objects[0]);
        end;
    end;
end;

{---------------------------------------}
function TJabberPPDB.NextPres(last: TJabberPres): TJabberPres;
var
    pl: TWideStringList;
    i: integer;
begin
    // find the next pres for this person
    Result := nil;
    pl := GetPresList(last.fromJID.jid);
    if pl <> nil then begin
        i := pl.IndexOfObject(last);
        if i >= 0 then begin
            i := i + 1;
            if i < pl.Count then
                Result := TJabberPres(pl.Objects[i]);
        end;
    end;
end;

{---------------------------------------}
function TPresenceSignal.addListener(callback: TPresenceEvent): TPresenceListener;
var
    l: TPresenceListener;
begin
    //
    l := TPresenceListener.Create();
    l.callback := TMethod(callback);
    inherited addListener('', l);
    Result := l
end;

{---------------------------------------}
procedure TPresenceSignal.Invoke(event: string; tag: TXMLTag; p: TJabberPres);
var
    i: integer;
    l: TPresenceListener;
    cmp, e: string;
    sig: TPresenceEvent;
begin
    // dispatch this to all interested listeners
    cmp := Lowercase(Trim(event));
    inc(_invoking);
    for i := 0 to Self.Count - 1 do begin
        e := Strings[i];
        l := TPresenceListener(Objects[i]);
        sig := TPresenceEvent(l.callback);
        if (e <> '') then begin
            // check to see if the listener's string is a substring of the event
            if (Pos(e, cmp) >= 1) then begin
                try
                    sig(event, tag, p);
                except
                    on x: Exception do
                        Dispatcher.handleException(Self, x, l, event, tag);
                end;
            end;
        end
        else begin
            try
                sig(event, tag, p);
            except
                on x: Exception do
                    Dispatcher.handleException(Self, x, l, event, tag);
            end;
        end;
    end;
    dec(_invoking);

    if (change_list.Count > 0) and (_invoking = 0) then
        Self.processChangeList();

end;



end.

