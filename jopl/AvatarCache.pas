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
unit AvatarCache;



interface

uses
    Avatar, Session,
    Unicode, XMLTag,
    Types, SysUtils, Classes, XMLVCard, XMLVCardCache;

type
    TAvatarCacheEntry = class(TAvatar)

    end;
    TAvatarCache = class
    private
        _cache: TWidestringlist;
        _session: TJabberSession;
        _presCB: integer;
        _sessCB: integer;

        _xp: TXPLite;

        _log: TStringlist;

        procedure regCallbacks();

    protected
        procedure presCallback(event: string; tag: TXMLTag);
        procedure sessionCallback(event: string; tag: TXMLTag);
        procedure vcardCallback(jid: Widestring; vcard: TXMLVCard);

    public
        constructor Create();
        destructor  Destroy(); override;

        procedure Clear();
        procedure setSession(session: TJabberSession);
        procedure Save();
        procedure Load();
        
        function Add(jid: Widestring; a: TAvatar): integer;
        function Find(jid: Widestring): TAvatar;
        procedure Remove(a: TAvatar);

        procedure Log(tmps: string);
    end;

var
    Avatars: TAvatarCache;

implementation

uses JabberID, PrefController, XMLParser;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
constructor TAvatarCache.Create();
begin
    inherited Create;
    _cache := TWidestringlist.Create();
    _log := TStringlist.Create();

    _xp := TXPLite.Create('/presence/x[@xmlns="vcard-temp:x:update"]');
    _presCB := -1;
    _sessCB := -1;
end;

{---------------------------------------}
destructor  TAvatarCache.Destroy();
begin
    Clear();

    _cache.Free();
    _log.Free();

    _xp.Free();

    inherited;
end;

{---------------------------------------}
procedure TAvatarCache.Log(tmps: string);
begin
    //_log.Add(tmps);
    //_log.SaveToFile('c:\temp\avatars.txt');
end;

{---------------------------------------}
function TAvatarCache.Add(jid: Widestring; a: TAvatar): integer;
var
    o: TAvatar;
    i: integer;
begin
    i := _cache.IndexOf(jid);
    if (i <> -1) then begin
        o := TAvatar(_cache.Objects[i]);
        if (o <> a) then begin
            if (o is TAvatarCacheEntry) then o.Free();
            _cache.Objects[i] := a;
        end;
    end
    else begin
        i := _cache.AddObject(jid, a);
    end;

    Result := i;
end;

{---------------------------------------}
procedure TAvatarCache.Remove(a: TAvatar);
var
    idx: integer;
begin
    idx := _cache.IndexOfObject(a);
    if (idx >= 0) then
        _cache.Delete(idx);
end;

{---------------------------------------}
procedure TAvatarCache.Clear();
begin
    while (_cache.Count > 0) do begin
        if (_cache.Objects[0] is TAvatarCacheEntry) then
            TAvatarCacheEntry(_cache.Objects[0]).Free();
        _cache.Delete(0);
    end;
end;

{---------------------------------------}
function TAvatarCache.Find(jid: Widestring): TAvatar;
var
    vcard: TXMLVCard;
    i: integer;
begin
    i := _cache.IndexOf(jid);
    if (i >= 0) then
        Result := TAvatar(_cache.Objects[i])
    else begin
        vcard := GetVCardCache().VCards[jid];
        if (vcard <> nil) then
            Result := vcard.Picture
        else
            Result := nil;

        if (Result <> nil) then
            Add(jid, Result);
    end;
end;

{---------------------------------------}
procedure TAvatarCache.regCallbacks();
begin
    if (_presCB = -1) then begin
        _presCB := _session.RegisterCallback(presCallback,
            '/packet/presence/x[@xmlns="vcard-temp:x:update"]');
    end;
end;

{---------------------------------------}
procedure TAvatarCache.setSession(session: TJabberSession);
begin
    _session := session;
    _sessCB := _session.RegisterCallback(sessionCallback, '/session');
    regCallbacks();
    //Load();
end;

{---------------------------------------}
procedure TAvatarCache.presCallback(event: string; tag: TXMLTag);
var
    tmps: string;
    fetch, refresh: boolean;
    a: TAvatar;
    fjid: TJabberID;
    hash: Widestring;
    x: TXMLTag;
begin
    // we got an avatar enabled presence
    try
        fetch := false;
        fjid := TJabberID.Create(tag.getAttribute('from'));

        x := tag.QueryXPTag(_xp);

        if (x <> nil) then
            // iChat mode
            hash := x.GetBasicText('photo');

        // bail if we have no hash value
        hash := Trim(hash);
        if (hash = '') then exit;

        {$ifdef Exodus}
        tmps := 'AVATAR: ' + fjid.jid + ', HASH: ' + hash;
        Log(tmps);
        {$endif}

        a := find(fjid.jid);
        if (a <> nil) then begin
            if (not a.Pending) and (hash <> a.getHash()) then begin
                //existing avatar needs a refresh
                fetch := true;
                refresh := true;
            end;
        end;

        if (fetch) then begin
            GetVCardCache().find(fjid.jid, vcardCallback, refresh);
        end;
    finally
        fjid.Free();
    end;
end;

{---------------------------------------}
procedure TAvatarCache.sessionCallback(event: string; tag: TXMLTag);
begin
    if (event = '/session/disconnected') then
        Save()
    else if (event = '/session/prefs') then
        regCallbacks();
end;
{---------------------------------------}
procedure TAvatarCache.vcardCallback(jid: WideString; vcard: TXMLVCard);
var
    a: TAvatar;
begin
    if (vcard = nil) then exit;

    a := vcard.Picture;
    if (a = nil) then exit;

    Add(jid, a);
end;

{---------------------------------------}
procedure TAvatarCache.Load();
var
    tmps: string;
    a: TAvatarCacheEntry;
    i: integer;
    jid: Widestring;
    name, path, fn, hash: string;
    p: TXMLTagParser;
    root, t: TXMLTag;
    items: TXMLTagList;
begin
    path := getUserDir() + 'avatars';
    if (DirectoryExists(path) = false) then exit;

    fn := path + '\cache.xml';
    if (FileExists(fn)) then begin
        p := TXMLTagParser.Create();
        p.ParseFile(fn);
        root := p.popTag();
        if (root <> nil) then begin
            items := root.QueryTags('item');
            for i := 0 to items.Count - 1 do begin
                t := items[i];
                name := t.GetAttribute('name');
                jid := t.GetAttribute('jid');
                hash := t.GetAttribute('hash');
                if ((jid <> '') and (name <> '') and (FileExists(name))) then begin
                    a := TAvatarCacheEntry.Create();
                    a.LoadFromFile(name);
                    a.setHash(hash);
                    a.jid := jid;
                    Add(jid, a);
                    {$ifdef Exodus}
                    tmps := 'LOAD: ' + jid + ', HASH: ' + a.getHash();
                    Log(tmps);
                    {$endif}

                end;
            end;
            items.Free();
            root.Free();
        end;
        p.Free();
    end;
end;

{---------------------------------------}
procedure TAvatarCache.Save();
var
    i: integer;
    a: TAvatar;
    fn, path, name: string;
    root, t: TXMLTag;
    s: TWidestringlist;
begin
    path := getUserDir() + 'avatars';
    if (DirectoryExists(path) = false) then
        CreateDir(path);
    if (DirectoryExists(path) = false) then exit;

    fn := path + '\cache.xml';

    root := TXMLTag.Create('cache');
    for i := 0 to _cache.Count - 1 do begin
        a := TAvatar(_cache.Objects[i]);
        name := a.getHash();
        if (name = '') then begin
            Continue;
        end;

        name := path + '\' + name;
        a.SaveToFile(name);
        t := root.AddTag('item');
        t.setAttribute('name', name);
        t.setAttribute('jid', _cache[i]);
        t.setAttribute('hash', a.getHash());
    end;

    s := TWidestringlist.Create();
    s.Add(root.xml);
    s.SaveToFile(fn);
    s.Free();

    root.Free();
end;

initialization
    Avatars := TAvatarCache.Create();

finalization
    Avatars.Free();

end.
