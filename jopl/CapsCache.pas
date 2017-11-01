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
unit CapsCache;


interface
uses
    {$ifdef Exodus}
    TntClasses,
    {$endif}
    DiscoIdentity, Entity, JabberID, XMLTag, Unicode, Classes, SysUtils;

type
    TJabberCapsEntity = class(TJabberEntity)
    private
        _ver: Widestring;
        _hash: Widestring;
        _verified: Boolean;

    protected
        procedure _processDiscoInfo(const tag: TXMLTag); override;
        function CalculateHash(): Widestring;

        property Version: Widestring read _ver write _ver;
    public
        constructor Create(jid: TJabberID; node: Widestring; hash: Widestring = '');
        destructor Destroy(); override;

        property Hash: Widestring read _hash;
        property Verified: Boolean read _verified;
    end;

    TJabberSelfEntity = class(TJabberCapsEntity)
    private
        _js: TObject;
        
    protected
        constructor Create();
        
        procedure Update(send_pres: Boolean);

        procedure SessionCallback(event: string; tag: TXMLTag);
    public
        procedure SetSession(js: TObject);

        function AddIdentity(ident: TDiscoIdentity): Boolean; override;
        function RemoveIdentity(ident: TDiscoIdentity): Boolean; override;

        function AddFeature(feat: Widestring): Boolean; override;
        function RemoveFeature(feat: Widestring): Boolean; override;

        function AddForm(form: TXMLTag): Boolean; override;
        function RemoveForm(form: TXMLTag): Boolean; override;

        function AddToPresence(pres: TXMLTag): TXMLTag;
        function AddToDisco(q: TXMLTag): TXMLTag;
    end;
    
    TJabberCapsPending = class
    public
        capsid: Widestring;
        jids: TWidestringlist;
        constructor Create(cid: Widestring);
        destructor Destroy(); override;
    end;

    TJabberCapsCache = class
    private
        _xp: TXPLite;
        _xp_q: TXPLite;
        _js: TObject;
        _cache: TWidestringlist;
        _pending: TWidestringlist;
        _depResolver: TObject; //TSimpleDependancyHandler;

        procedure addPending(ejid, node, caps_jid: Widestring);
        procedure fireCaps(jid, capid: Widestring);

        procedure AddCached(e: TJabberCapsEntity);
        procedure OnDependancyReady(tag: TXMLTag);

    public
        constructor Create();
        destructor Destroy(); override;

        procedure SetSession(js: TObject);

        function find(capid: Widestring): TJabberCapsEntity;

        procedure Clear();
        procedure Save(filename: Widestring = '');
        procedure Load(filename: Widestring = '');

        procedure PresCallback(event: string; tag: TXMLTag);
        procedure SessionCallback(event: string; tag: TXMLTag);

        function toString(): widestring;
    end;

var
    jCapsCache: TJabberCapsCache;
    jSelfCaps: TJabberSelfEntity;

const
    capsFilename = 'capscache.xml';

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
implementation

uses
    PrefController, XMLParser, SecHash, IdCoderMIME,
    JabberUtils, EntityCache, JabberConst, Session, XMLUtils;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
constructor TJabberCapsPending.Create(cid: Widestring);
begin
    jids := TWidestringlist.Create();
    capsid := cid;
end;

{---------------------------------------}
destructor TJabberCapsPending.Destroy();
begin
    jids.Free();
end;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
constructor TJabberCapsCache.Create();
begin
    _cache := TWidestringlist.Create();
    _pending := TWidestringlist.Create();
    _xp := TXPLite.Create('/presence/c[@xmlns="' + XMLNS_CAPS + '"]');
    _xp_q := TXPLite.Create('/iq/query[@xmlns="' + XMLNS_DISCOINFO + '"]');
    _depResolver := nil;
end;

{---------------------------------------}
destructor TJabberCapsCache.Destroy();
begin
    FreeAndNil(jSelfCaps);

    _cache.Free();
    _pending.Free();
    _xp.Free();
    _xp_q.Free();
    _depResolver.Free();
    inherited;
end;

{---------------------------------------}
procedure TJabberCapsCache.SetSession(js: TObject);
begin
    _js := js;
    assert(js is TJabberSession);
    TJabberSession(js).RegisterCallback(PresCallback,
        '/packet/presence[@type!="error"]/c[@xmlns="' + XMLNS_CAPS + '"]');
    TJabberSession(js).RegisterCallback(SessionCallback, '/session');

    if (jSelfCaps = nil) then
        jSelfCaps := TJabberSelfEntity.Create();

    jSelfCaps.SetSession(js);

     _depResolver := TSimpleAuthResolver.create(OnDependancyReady, DEPMOD_LOGGED_IN);
end;

procedure TJabberCapsCache.OnDependancyReady(tag: TXMLTag);
begin
    Load();
    TAuthDependancyResolver.SignalReady(DEPMOD_CAPS_CACHE);
end;

{---------------------------------------}
procedure TJabberCapsCache.SessionCallback(event: string; tag: TXMLTag);
var
    i, idx: integer;
    p: TJabberCapsPending;
    key: Widestring;
    q: TXMLTag;
begin
    // Save when we get disconnected, and load when we get auth'd
    if (event = '/session/disconnected') then
    begin
        Save();
        jSelfCaps.Version := '';
    end
    else if ((event = '/session/entity/info') and (tag <> nil)) then begin
        // check to see if this is in our pending list
        q := tag.QueryXPTag(_xp_q);
        if (q = nil) then exit;

        // key into pending is from#node
        key := tag.getAttribute('from') + '#' + q.GetAttribute('node');
        idx := _pending.IndexOf(key);
        if (idx = -1) then exit;

        p := TJabberCapsPending(_pending.Objects[idx]);
        for i := 0 to p.jids.Count - 1 do
            fireCaps(p.jids[i], p.capsid);
        p.Free();
        _pending.Delete(idx);
    end;
end;

{---------------------------------------}
procedure TJabberCapsCache.addPending(ejid, node, caps_jid: Widestring);
var
    key: Widestring;
    p: TJabberCapsPending;
    idx: integer;
begin
    // key into pending is from#node
    key := ejid + '#' + node;
    idx := _pending.IndexOf(key);
    if (idx = -1) then begin
        p := TJabberCapsPending.Create(node);
        _pending.AddObject(key, p);
    end
    else
        p := TJabberCapsPending(_pending.Objects[idx]);

    idx := p.jids.IndexOf(caps_jid);
    if (idx = -1) then
        p.jids.Add(caps_jid);
end;

{---------------------------------------}
procedure TJabberCapsCache.Clear();
begin
    _cache.Clear();
    _pending.Clear();
end;

{---------------------------------------}
procedure TJabberCapsCache.Save(filename: Widestring = '');
var
    c, f, i: integer;
    di: TDiscoIdentity;
    e: TJabberCapsEntity;
    iq, q, cur, cache: TXMLTag;
    s: TWidestringlist;
begin
    if (_cache.Count = 0) then exit;

    cache := TXMLTag.Create('caps-cache');

    for c := 0 to _cache.Count - 1 do begin
        e := TJabberCapsEntity(_cache.Objects[c]);

        if ((not e.hasInfo) or (e.discoInfoError)) then continue;
        if ((not e.Verified) and not TJabberSession(_js).Prefs.getBool('brand_caps_cacheuntrusted')) then continue;

        iq := cache.AddTag('iq');
        iq.setAttribute('from', 'caps-cache');
        iq.setAttribute('capid', _cache[c]);
        if (e.Verified) then iq.setAttribute('hash', e.Hash);

        q := iq.AddTagNS('query', XMLNS_DISCOINFO);
        for i := 0 to e.IdentityCount - 1 do begin
            di := e.Identities[i];
            di.AddTag(q);
        end;

        for f := 0 to e.FeatureCount - 1 do begin
            cur := q.AddTag('feature');
            cur.setAttribute('var', e.Features[f]);
        end;

        for f := 0 to e.FormCount - 1 do begin
            q.addInsertedXML(e.Forms[f].XML);
        end;
    end;

    s := TWidestringlist.Create();
    s.Add(cache.xml);

    if (filename = '') then
        filename := getUserDir() + capsFilename;

    s.SaveToFile(filename);
    s.Free();

    cache.Free();
end;

{---------------------------------------}
procedure TJabberCapsCache.Load(filename: Widestring = '');
var
    e: TJabberEntity;
    i: integer;
    parser: TXMLTagParser;
    iq, cache: TXMLTag;
    iqs: TXMLTagList;
    capid, from, hash: Widestring;
    tjid: TJabberID;
begin
    parser := TXMLTagParser.Create();

    if (filename = '') then
        filename := getUserDir() + capsFilename;
    if (not FileExists(filename)) then exit;

    parser.ParseFile(filename);

    if (parser.Count = 0) then begin
        parser.Free();
        exit;
    end;

    cache := parser.popTag();
    assert(cache <> nil);

    iqs := cache.ChildTags();
    for i := 0 to iqs.Count - 1 do begin
        iq := iqs.Tags[i];
        capid := iq.GetAttribute('capid');
        hash := iq.getAttribute('hash');
        from := 'caps-cache';

        if ((capid = '') or (from = '')) then continue;
        if ((hash = '') and not TJabberSession(_js).Prefs.getBool('brand_caps_cacheuntrusted')) then continue;

        e := jEntityCache.getByJid(from, capid);
        if not (e is TJabberCapsEntity) then begin
            jEntityCache.Remove(e);
            e.Free();
            e := nil;
        end;
        if (e = nil) then begin
            tjid := TJabberID.Create(from);
            e := TJabberCapsEntity.Create(tjid, capid, hash);
            jEntityCache.Add(from, e);
            tjid.Free();
        end;
        e.LoadInfo(iq);
        AddCached(TJabberCapsEntity(e));
    end;

    iqs.Free();
    cache.Free();
    parser.Free();

end;

{---------------------------------------}
function TJabberCapsCache.find(capid: Widestring): TJabberCapsEntity;
var
    idx: integer;
begin
    Result := nil;
    idx := _cache.IndexOf(capid);
    if (idx >= 0) then
        Result := TJabberCapsEntity(_cache.Objects[idx]);
end;

{---------------------------------------}
procedure TJabberCapsCache.AddCached(e: TJabberCapsEntity);
var
    idx: Integer;
begin
    if (e = nil) then exit;

    idx := _cache.IndexOfObject(e);
    if (idx = -1) then
        _cache.AddObject(e.Node, e);
end;

{---------------------------------------}
procedure TJabberCapsCache.PresCallback(event: string; tag: TXMLTag);

    function getCache(capid, hash: Widestring; jid: TJabberID): TJabberCapsEntity;
    begin
        Result := find(capid);
        if (Result = nil) then begin
            // this is something new, query for it.
            //create caps-specific Entity object
            Result := TJabberCapsEntity.Create(jid, capid, hash);
            jEntityCache.Add(jid.full, Result);
            AddCached(Result);

            Result.getInfo(TJabberSession(_js));
        end;
    end;

    function checkInfo(cache: TJabberEntity; capid: Widestring; jid: TJabberID): boolean;
    begin
        Result := cache.hasInfo;
        if (not Result) then
            addPending(cache.Jid.full, capid, jid.full);
    end;

var
    has_info: boolean;
    i: integer;
    cache, e: TJabberEntity;
    c: TXMLTag;
    exts: Widestring;
    from: TJabberID;
    node, cid, capid, ver, hash: Widestring;
    ids: TWidestringlist;
    tjid: TJabberID;
begin
    if (event <> 'xml') then exit;

    // we get presence packets like this:
    {
    <presence from='pgvantek@aol.com'
        to='pmillard@corp.jabber.com/Jinx-pgm'
        type='subscribed'>
        <c  node='http://jabber.com/aim'
            ver='1.0.1.5'
            xmlns='http://jabber.org/protocol/caps'/>
        <priority>0</priority>
    </presence>

    OR like this:

    <presence from='pgvantek@aol.com'
        to='pmillard@corp.jabber.com/Jinx-pgm'
        type='subscribed'>
        <c  node='http://jabber.com/aim'
            ver='q1elkfdslvnq2ein2klvenl12//=='
            hash='sha-1'
            xmlns='http://jabber.org/protocol/caps'/>
        <priority>0</priority>
    </presence>
    }

    c := tag.QueryXPTag(_xp);
    assert(c <> nil);

    node := c.GetAttribute('node');
    ver := c.getAttribute('ver');
    hash := c.getAttribute('hash');
    capid := node + '#' + ver;
    cid := capid;

    from := TJabberID.Create(tag.getAttribute('from'));
    //make sure we aren't trying to query a conf server...
    e := jEntityCache.getByJid(from.domain);
    if (e = nil) or (not e.hasFeature(FEAT_GROUPCHAT)) then 
    begin
        e := jEntityCache.getByJid(from.full);
        if (e = nil) then begin
            tjid := TJabberID.Create(from);
            e := TJabberEntity.Create(tjid);
            jEntityCache.Add(from.full, e);
            tjid.Free();
        end;

        e.ClearReferences(); //refs will be rebuilt here

        cache := getCache(capid, hash, from);
        e.AddReference(cache);
        has_info := checkInfo(cache, cid, from);

        //TODO:  differentiate between 'ext' and 'hash' (one or the other)
        //NOTE:  we *might* trust persisting of this caps if hash is present
        //NOTE:  we *never* trust persisting if no hash
        exts := c.GetAttribute('ext');
        if (exts <> '') then begin
            ids := TWidestringlist.Create();
            split(exts, ids, ' ');
            for i := 0 to ids.count - 1 do begin
                capid := node + '#' + ids[i];
                cache := getCache(capid, '', from);
                has_info := (has_info and checkInfo(cache, capid, from));
                e.AddReference(cache);
            end;
            ids.Free();
        end;

        if (has_info) then
            fireCaps(from.full, cid);
    end;

    from.Free();
end;

{---------------------------------------}
procedure TJabberCapsCache.fireCaps(jid, capid: Widestring);
var
    caps: TXMLTag;
begin
    // we have all the info for this jid, send an event.
    caps := TXMLTag.Create('caps');
    caps.setAttribute('from', jid);
    caps.setAttribute('capid', capid);
    MainSession.FireEvent('/session/caps', caps);
    caps.Free();
end;

function TJabberCapsCache.toString(): widestring;
var
    c: integer;
begin
    Result := 'Caps Cache.' + #13#10 + 'Enity Count: ' + intToStr(_cache.Count) + #13#10 + 'Entities:' + #13#10;
    for c := 0 to _cache.Count - 1 do begin
        Result := Result + #13#10 + '***** Entity#' + IntToStr(c) + ' *****' + #13#10 + TJabberEntity(_cache.Objects[c]).toString();
    end;
end;

{--------------------------}
{--------------------------}
{--------------------------}
constructor TJabberCapsEntity.Create(jid: TJabberID; node: Widestring; hash: Widestring);
var
    idx: Integer;
begin
    inherited Create(jid, node, ent_disco);

    if (Pos('http://jm.jabber.com/caps#3', node) <> 0) then
    begin
        //JM fixup test only *remove*
        AddFeature(XMLNS_XHTMLIM);
    end;
    
    _hash := hash;
    if (hash <> '') then begin
        idx := Pos('#', node);
        if (idx <> 0) then
            _ver := Copy(node, idx + 1, Length(node));
    end;
end;

{--------------------------}
destructor TJabberCapsEntity.Destroy;
begin
    inherited;
end;

{--------------------------}
procedure TJabberCapsEntity._processDiscoInfo(const tag: TXMLTag);
begin
    inherited _processDiscoInfo(tag);

    //TODO:  process hash
    if not Verified and (Hash <> '') then begin
        _verified := CalculateHash() = _ver;
    end;
end;

function TJabberCapsEntity.CalculateHash(): Widestring;
    function EncodeForm(form: TXMLTag): Widestring;
    var
        fvar: Widestring;
        field: TXMLTag;
        fset: TXMLTagList;
        fsorted, vsorted: TWidestringList;
        idx, jdx: Integer;
    begin
        Result := '';

        fsorted := TWidestringList.Create();
        fsorted.Sorted := true;
        fsorted.Duplicates := dupAccept;

        vsorted := TWidestringList.Create();
        vsorted.Sorted := true;
        vsorted.Duplicates := dupAccept;

        //sort fields
        fset := form.QueryTags('field');
        for idx := 0 to fset.Count - 1 do begin
            field := fset[idx];
            fvar := field.getAttribute('var');
            if (fvar = 'FORM_TYPE') then
                Result := field.QueryXPData('value') + '<'
            else
                fsorted.AddObject(fvar, field);
        end;
        fset.Free();

        //process fields
        for idx := 0 to fsorted.Count - 1 do begin
            //sort values
            field := TXMLTag(fsorted.Objects[idx]);
            fset := field.QueryTags('value');
            for jdx := 0 to fset.Count - 1 do begin
                vsorted.Add(fset[jdx].Data);
            end;
            fset.Free();

            //process values
            Result := Result + fsorted[idx] + '<';
            for jdx := 0 to vsorted.Count - 1 do begin
                Result := Result + vsorted[jdx] + '<';
            end;
            vsorted.Clear();
        end;

        //Cleanup
        vsorted.Free();
        fsorted.Free();
    end;

    function GenHashSHA1(input: Widestring): Widestring;
    var
        sha1: TSecHash;
        b64: TIdEncoderMIME;
        tmp: String;
        idx: Integer;
        h: TByteDigest;
    begin
        tmp := UTF8Encode(input);

        sha1 := TSecHash.Create(nil);
        h := sha1.IntDigestToByteDigest(sha1.computeString(tmp));
        sha1.Free();

        tmp := '';
        for idx := 0 to 19 do tmp := tmp + Chr(h[idx]);
        b64 := TIdEncoderMIME.Create(nil);
        result := b64.encode(tmp);
        b64.Free();
    end;
var
    Str: Widestring;
    idx: Integer;

begin
    Str := '';

    //include identities
    for idx := 0 to IdentityCount - 1 do begin
        Str := Str + Identities[idx].Key + '<';
    end;

    //include features
    for idx := 0 to FeatureCount - 1 do begin
        Str := Str + Features[idx] + '<';
    end;

    //include forms
    for idx := 0 to FormCount - 1 do begin
        Str := Str + EncodeForm(Forms[idx]);
    end;

    if Hash = 'sha-1' then begin
        Result := GenHashSHA1(Str);
    end
    else begin
        Result := '';
    end;
end;

{--------------------------}
{--------------------------}
{--------------------------}
constructor TJabberSelfEntity.Create();
var
    tjid: TJabberID;
begin
    tjid := TJabberID.Create('self-caps');
    inherited Create(tjid, '', 'sha-1');
    tjid.Free();

    // no node or uri#ver

    addFeature(XMLNS_IQOOB);
    addFeature(XMLNS_TIME);
    addFeature(XMLNS_TIME_202);
    addFeature(XMLNS_VERSION);
    addFeature(XMLNS_LAST);
    addFeature(XMLNS_DISCOITEMS);
    addFeature(XMLNS_DISCOINFO);

    // Various core extensions
    addFeature(XMLNS_BM);
    addFeature(XMLNS_XDATA);
    addFeature(XMLNS_XEVENT);

    // MUC Stuff
    addFeature(XMLNS_MUC);
    addFeature(XMLNS_MUCUSER);
    addFeature(XMLNS_MUCOWNER);

    // File xfer
    addFeature(XMLNS_SI);
    addFeature(XMLNS_FTPROFILE);
    addFeature(XMLNS_BYTESTREAMS);

{$IFDEF DEPRICATED_PROTOCOL}
    addFeature(XMLNS_AGENTS);
    addFeature(XMLNS_BROWSE);
    addFeature(XMLNS_XCONFERENCE);
{$ENDIF}
end;

procedure TJabberSelfEntity.SetSession(js: TObject);
begin
    _js := js;

    TJabberSession(_js).RegisterCallback(SessionCallback, '/session');
end;

procedure TJabberSelfEntity.SessionCallback(event: string; tag: TXMLTag);
begin
    if (event = '/session/disconnected') then
        Version := '';
end;

{--------------------------}
procedure TJabberSelfEntity.Update(send_pres: Boolean);
var
    session: TJabberSession;
    ref: TJabberCapsEntity;
    uri: Widestring;
    capid: Widestring;
    tjid: TJabberID;
begin
    session := TJabberSession(_js);
    uri := session.Prefs.getString('client_caps_uri');

    //unlink old referene
    if (Version <> '') then begin
        capid := Self.Node;
        ref := jCapsCache.find(capid);
        if (ref <> nil) then ref.RemoveReference(Self);
    end;

    //make sure we have one identity
    if IdentityCount = 0 then begin
        AddIdentity(TDiscoIdentity.Create(
            'client',
            'pc',
            PrefController.getAppInfo.Caption + ' ' + GetAppVersion()));
    end;

    //recalulate hash
    Version := CalculateHash();
    Self.SetNode(uri + '#' + Version);

    //link new reference
    if (Version <> '') then begin
        capid := Self.Node;
        ref := jCapsCache.find(capid);
        if (ref = nil) then begin
            tjid := TJabberID.Create('caps-cache');
            ref := TJabberCapsEntity.Create(tjid, capid, Hash);
            tjid.Free();
            jCapsCache.AddCached(ref);
        end;
        ref.AddReference(Self);
    end;

    if (send_pres) then begin
        session.setPresence(session.Show, session.Status, session.Priority);
    end;
end;

{--------------------------}
function TJabberSelfEntity.AddIdentity(ident: TDiscoIdentity): Boolean;
begin
    Result := inherited AddIdentity(ident);
    if Result and (Version <> '') then Update(true);
end;
function TJabberSelfEntity.RemoveIdentity(ident: TDiscoIdentity): Boolean;
begin
    Result := inherited RemoveIdentity(ident);
    if Result and (Version <> '') then Update(true);
end;

function TJabberSelfEntity.AddFeature(feat: WideString): Boolean;
begin
    Result := inherited AddFeature(feat);
    if Result and (Version <> '') then Update(true);
end;
function TJabberSelfEntity.RemoveFeature(feat: WideString): Boolean;
begin
    Result := inherited RemoveFeature(feat);
    if Result and (Version <> '') then Update(true);
end;

function TJabberSelfEntity.AddForm(form: TXMLTag): Boolean;
begin
    Result := inherited AddForm(form);
    if Result and (Version <> '')then Update(true);
end;
function TJabberSelfEntity.RemoveForm(form: TXMLTag): Boolean;
begin
    Result := inherited RemoveForm(form);
    if Result and (Version <> '') then Update(true);
end;

function TJabberSelfEntity.AddToPresence(pres: TXMLTag): TXMLTag;
var
    uri: Widestring;
begin
    uri := TJabberSession(jCapsCache._js).Prefs.getString('client_caps_uri');
    if (Version = '') then Update(false);

    Result := pres.AddTagNS('c', XMLNS_CAPS);
    result.setAttribute('node', uri);
    result.setAttribute('ver', Version);
    result.setAttribute('hash', Hash);
end;
function TJabberSelfEntity.AddToDisco(q: TXMLTag): TXMLTag;
var
    idx: Integer;
    child: TXMLTag;
begin
    if (Version = '') then Update(false);

    Result := q;

    //add identities
    for idx := 0 to IdentityCount - 1 do begin
        Identities[idx].AddTag(q);
    end;

    //add features
    for idx := 0 to FeatureCount - 1 do begin
        child := q.AddTag('feature');
        child.setAttribute('var', Features[idx]);
    end;

    //add forms
    for idx := 0 to FormCount - 1 do begin
        child := Forms[idx];
        q.addInsertedXML(child.XML);
    end;
end;

initialization
    jCapsCache := TJabberCapsCache.Create();

finalization
    FreeAndNil(jCapsCache);

end.

