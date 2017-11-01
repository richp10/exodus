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
unit Entity;


interface
uses
    IQ, DiscoIdentity, JabberID, XMLTag, Signals, Session, Unicode,
    Classes, SysUtils;

const

    // browse stuff
    FEAT_SEARCH         = 'jabber:iq:search';
    FEAT_REGISTER       = 'jabber:iq:register';
    FEAT_GROUPCHAT      = 'groupchat';
    FEAT_PRIVATE        = 'private';
    FEAT_PUBLIC         = 'gc-public';
    FEAT_JUD            = 'jud';
    FEAT_GATEWAY        = 'gateway';
    FEAT_AIM            = 'aim';
    FEAT_ICQ            = 'icq';
    FEAT_YAHOO          = 'yahoo';
    FEAT_MSN            = 'msn';
    FEAT_PROXY          = 'proxy';
    FEAT_BYTESTREAMS    = 'bytestreams';

    WALK_LIMIT          = 20;   // max # of items to do disco#info on
    WALK_MAX_TIMEOUT    = 30;   // max # of seconds for iq timeouts.

    UITHREAD_MAX_ITEMS  = 50;   //handle iq results with 50 or less items on the
                                //UI thread, spin off to another for more.
                                //don't dog the ui thread!

    BRANDED_ENABLE_FALLBACK = 'brand_enable_iq_fallbacks';
type

    TJabberEntityType = (ent_unknown, ent_disco, ent_browse, ent_cached_disco);

    // This class is designed to gather information about a host.
    // It first tries disco, then falls back on browse, and finally agents.
    TJabberEntity = class
    private
        _parent: TJabberEntity;
        _jid: TJabberID;
        _node: Widestring;
        _name: Widestring;
        _feats: TWidestringlist;
        _type: TJabberEntityType;
        _refs: TList;

        _has_info: Boolean;             // do we need to do a disco#info?
        _disco_info_error: Boolean;     // Was the disco#info a type="error"
        _has_items: boolean;            // do we have children?
        _items: TWidestringlist;        // our children
        _idents: TWidestringlist;       // our Identities
        _forms: TWidestringList;        // our extended info forms
        _iq: TJabberIQ;
        _lastInfoIQResult: TXMLTag;     //last disco#info iq result, full packet
        
        _cat: Widestring;
        _cat_type: Widestring;

        _use_limit: boolean;
        _timeout: integer;
        _fallback: boolean;
        _stopWalk: boolean; //flag to stop walk after getting second level items

        function _getReference(i: integer): TJabberEntity;
        function _getReferenceCount: integer;

        function _getFeature(i: integer): Widestring;
        function _getFeatureCount: integer;

        function _getItem(i: integer): TJabberEntity;
        function _getItemCount: integer;

        function _getIdentity(i: integer): TDiscoIdentity;
        function _getIdentityCount: integer;

        function _getForm(i: Integer): TXMLTag;
        function _getFormCount: Integer;

        procedure _discoInfo(js: TJabberSession; callback: TSignalEvent);
        procedure _discoItems(js: TJabberSession; callback: TSignalEvent);

        procedure _processDiscoItems(tag: TXMLTag; parent: TJabberEntity; out newItems: TWidestringList; itemLimit: integer = -1);

        procedure _finishWalk(jso: TObject; newItems: TWidestringList);
        procedure _finishDiscoItems(jso: TObject; tag: TXMLTag; newItems: TWidestringList);

        procedure _startIQBrowse(jso: TObject);
        procedure _processBrowse(tag: TXMLTag);
        procedure _processBrowseItem(item: TXMLTag);
        procedure _finishBrowse(jso: TObject);

        procedure _fireOnEntityInfo(jso: TObject; tag: TXMLTag);overload;
        procedure _fireOnEntityInfo(jso: TObject; jid: TJabberID);overload;
        procedure _fireOnEntityItems(jso: TObject; tag: TXMLTag);overload;
        procedure _fireOnEntityItems(jso: TObject; jid: TJabberID);overload;

        //callbacks from children when disco are completed during a walk
        procedure _childDiscoWalkFinished(jso: TObject; child: TJabberEntity);
    protected
        procedure SetNode(node: Widestring);

        function AddIdentity(ident: TDiscoIdentity): Boolean; virtual;
        function RemoveIdentity(ident: TDiscoIdentity): Boolean; virtual;

        function AddFeature(feat: Widestring): Boolean; virtual;
        function RemoveFeature(feat: Widestring): Boolean; virtual;

        function AddForm(form: TXMLTag): Boolean; virtual;
        function RemoveForm(form: TXMLTag): Boolean; virtual;

        procedure _processDiscoInfo(const tag: TXMLTag); virtual;

        procedure ItemsCallback(event: string; tag: TXMLTag);
        procedure InfoCallback(event: string; tag: TXMLTag);

        procedure BrowseCallback(event: string; tag: TXMLTag);

        procedure WalkInfoCallback(event: string; tag: TXMLTag);
        procedure WalkItemsCallback(event: string; tag: TXMLTag);

        property ReferenceCount: Integer read _getReferenceCount;
        property References[Index: Integer]: TJabberEntity read _getReference;
    public
        Tag: integer;
        Data: TObject;

        constructor Create(jid: TJabberID; node: Widestring = ''; etype: TJabberEntityType = ent_unknown);
        destructor Destroy; override;

        procedure getInfo(js: TJabberSession);
        procedure getItems(js: TJabberSession);
        procedure discoWalk(js: TJabberSession; items_limit: boolean = true;
            timeout: integer = 10);
        procedure refresh(js: TJabberSession);
        procedure refreshInfo(js: TJabberSession);
        procedure LoadInfo(tag: TXMLTag);

        procedure AddReference(e: TJabberEntity);
        procedure RemoveReference(e: TJabberEntity);
        procedure ClearReferences();

        function hasIdentity(category, disco_type: Widestring; lang: Widestring = ''): boolean;
        function hasFeature(f: Widestring; allowCached: boolean = false): boolean;
        function hasForm(f: Widestring): boolean;

        function ItemByJid(jid: Widestring; node: Widestring = ''): TJabberEntity;
        function getItemByFeature(f: Widestring): TJabberEntity;

        property Parent: TJabberEntity read _parent;
        property Jid: TJabberID read _jid;
        property Node: Widestring read _node;
        property entityType: TJabberEntityType read _type;
        property Category: Widestring read _cat;
        property CatType: Widestring read _cat_type;
        property Name: Widestring read _name;

        function toString(): WideString;

        property hasItems: boolean read _has_items;
        property hasInfo: boolean read _has_info;
        property discoInfoError: boolean read _disco_info_error;

        property FeatureCount: Integer read _getFeatureCount;
        property Features[Index: integer]: Widestring read _getFeature;

        property ItemCount: Integer read _getItemCount;
        property Items[Index: integer]: TJabberEntity read _getItem;

        property IdentityCount: Integer read _getIdentityCount;
        property Identities[Index: integer]: TDiscoIdentity read _getIdentity;

        property FormCount: Integer read _getFormCount;
        property Forms[Index: Integer]: TXMLTag read _getForm;

        property fallbackProtocols: boolean read _fallback write _fallback;
        property timeout: integer read _timeout write _timeout;

    end;

    TJabberEntityProcess = class(TThread)
    public
        jso: TObject;
        tag: TXMLTag;
        e: TJabberEntity;
        ptype: integer;
        newItems: TWidestringList;
    private
        procedure FinishDiscoItems();
        procedure FinishWalk();
        procedure FinishBrowse();
    protected
        procedure Execute(); override;
    end;


implementation
uses
    Windows,
    EntityCache, JabberConst, XMLUtils, Debug;

const
    ProcDisco = 0;
    ProcBrowse = 1;
    ProcWalk = 2;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
procedure TJabberEntityProcess.Execute();
begin
    if (ptype = ProcDisco) then begin
        e._processDiscoItems(tag, e, newItems);
        Synchronize(FinishDiscoItems);
    end
    else if (ptype = ProcBrowse) then begin
        e._processBrowse(tag);
        Synchronize(FinishBrowse);
    end
    else if (ptype = ProcWalk) then begin
        if (tag <> nil) then
            e._processDiscoitems(tag, e, newItems);
        Synchronize(FinishWalk);
    end;
    tag.Free();
end;


{---------------------------------------}
procedure TJabberEntityProcess.FinishDiscoItems();
begin
    e._finishDiscoItems(jso, tag, newItems);
end;

{---------------------------------------}
procedure TJabberEntityProcess.FinishWalk();
begin
    e._finishWalk(jso, newItems);
end;

{---------------------------------------}
procedure TJabberEntityProcess.FinishBrowse();
begin
    e._finishBrowse(jso);
end;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
constructor TJabberEntity.Create(jid: TJabberID; node: Widestring; etype: TJabberEntityType);
begin

    _parent := nil;
    _jid := TJabberID.create(jid);
    _node := '';
    _name := '';
    _refs := TList.Create();
    _lastInfoIQResult := nil;
    _type := etype;
    _has_info := false;
    _disco_info_error := false;
    _has_items := false;

    _items := TWidestringlist.Create();
    _items.Sorted := false;

    _idents := TWidestringlist.Create();
    _idents.Sorted := true;

    _feats := TWidestringlist.Create();
    _feats.Sorted := true;

    _forms := TWidestringList.Create();
    _forms.Sorted := true;

    _timeout := 10;
    _node := node;
    _fallback := true;

    Tag := -1;
    Data := nil;
end;

{---------------------------------------}
destructor TJabberEntity.Destroy;
begin
    if (_iq <> nil) then _iq.Free();
    _iq := nil;

    jEntityCache.Remove(Self);
    ClearStringListObjects(_items);
    _items.Clear();
    ClearStringListObjects(_idents);
    _idents.Clear();
    _idents.Free();
    ClearStringListObjects(_forms);
    _forms.Clear();
    _forms.Free();
    _feats.Clear();
    if (_lastInfoIQResult <> nil) then
        _lastInfoIQResult.free();
    FreeAndNil(_items);
    FreeAndNil(_feats);
    _jid.Free();
    _refs.Clear();
    _refs.Free();
end;

{---------------------------------------}
function TJabberEntity._getReferenceCount: Integer;
begin
    Result := _refs.Count;
end;

{---------------------------------------}
function TJabberEntity._getReference(i: Integer): TJabberEntity;
begin
    if (i > -1) and (i < _refs.Count) then
        result := TJabberEntity(_refs[i])
    else
        Result := nil;
end;

{---------------------------------------}
function TJabberEntity._getFeature(i: integer): Widestring;
begin
    if (i < _feats.Count) then
        Result := _feats[i]
    else
        Result := '';
end;

{---------------------------------------}
function TJabberEntity.hasFeature(f: Widestring; allowCached: boolean): boolean;
var
    i: integer;
    r: TJabberEntity;
begin
    //Don't handle top level caps cached entities, they have no valid JID.
    if ((_type = ent_cached_disco) and (not allowCached)) then
        Result := false
    else begin
        Result := (_feats.IndexOf(f) >= 0);
        if (not Result) then begin
            // if we didn't find it directly, check our references
            for i := 0 to _refs.Count - 1 do begin
                r := TJabberEntity(_refs[i]);
                //go ahead and check caps cache entities here
                //they are a child of a jid only entity
                Result := r.hasFeature(f, true);
                if (Result) then begin
                    break;
                end;
            end;

            // if we STILL didn't find it, pretend we did for certain ones...
            if (f = FEAT_GROUPCHAT) then
                Result := hasFeature('gc-1.0') or hasFeature(XMLNS_MUC) or hasFeature('conference');
        end;
    end;
end;

{---------------------------------------}
function TJabberEntity.hasIdentity(category, disco_type, lang: Widestring): boolean;
var
    di: TDiscoIdentity;
    i: integer;
    r: TJabberEntity;
begin
    // check our own idents first
    Result := false;

    for i := 0 to _idents.Count - 1 do begin
        di := TDiscoIdentity(_idents.Objects[i]);
        
        if ((di.Category <> category) or (di.DiscoType <> disco_type)) then continue;
        if (lang <> '') and (di.Language <> lang) then continue;

        Result := true;
        exit;
    end;

    // check the idents of our regs
    for i := 0 to _refs.Count - 1 do begin
        r := TJabberEntity(_refs[i]);
        Result := r.hasIdentity(category, disco_type, lang);
        if (Result) then exit;
    end;
end;

{---------------------------------------}
function TJabberEntity.hasForm(f: WideString): boolean;
var
    idx: Integer;
begin
    idx := _forms.IndexOf(f);
    if (idx <> -1) then begin
        Result := true;
        exit;
    end;

    //check references
    for idx := 0 to _refs.Count - 1 do begin
        Result := TJabberEntity(_refs[idx]).hasForm(f);
        if Result then exit;
    end;
end;

{---------------------------------------}
function TJabberEntity._getFeatureCount: integer;
begin
    Result := _feats.Count;
end;

{---------------------------------------}
function TJabberEntity._getItem(i: integer): TJabberEntity;
begin
    if (i < _items.Count) then
        Result := TJabberEntity(_items.Objects[i])
    else
        Result := nil;
end;


{---------------------------------------}
function TJabberEntity._getIdentityCount: integer;
begin
    Result := _idents.Count;
end;

{---------------------------------------}
function TJabberEntity._getIdentity(i: integer): TDiscoIdentity;
begin
    if (i < _idents.Count) then
        Result := TDiscoIdentity(_idents.Objects[i])
    else
        Result := nil;
end;

function TJabberEntity._getFormCount(): Integer;
begin
    Result := _forms.Count;
end;
function TJabberEntity._getForm(i: Integer): TXMLTag;
begin
    if (i > -1) and (i < _forms.Count) then
        Result := TXMLTag(_forms.Objects[i])
    else
        Result := nil;
end;

{---------------------------------------}
function TJabberEntity.ItemByJid(jid: Widestring; node: Widestring): TJabberEntity;
var
    id: Widestring;
    i: integer;
begin
    if (node <> '') then
        id := node + ':' + jid
    else
        id := jid;

    i := _items.IndexOf(id);
    if (i >= 0) then
        Result := TJabberEntity(_items.Objects[i])
    else
        Result := nil;
end;

{---------------------------------------}
function TJabberEntity.getItemByFeature(f: Widestring): TJabberEntity;
var
    c: TJabberEntity;
    i: integer;
begin
    Result := nil;
    for i := 0 to _items.Count - 1 do begin
        c := TJabberEntity(_items.Objects[i]);
        if (c.hasFeature(f)) then begin
            Result := c;
            exit;
        end;
    end;
end;

{---------------------------------------}
function TJabberEntity._getItemCount: integer;
begin
    Result := _items.Count;
end;

{---------------------------------------}
procedure TJabberEntity._discoInfo(js: TJabberSession; callback: TSignalEvent);
begin
    if (_iq <> nil) then exit;

    // Dispatch a disco#info query
    _has_info := false; //no info till iq is back
    _disco_info_error := false;
    _type := ent_unknown;

    _feats.Clear();
    if (_lastInfoIQResult <> nil) then
        _lastInfoIQResult.free();
    _lastInfoIQResult := nil;
    ClearStringListObjects(_idents);
    _idents.Clear();

    _iq := TJabberIQ.Create(js, js.generateID(), callback, _timeout);
    _iq.toJid := _jid.full;
    _iq.Namespace := XMLNS_DISCOINFO;
    _iq.iqType := 'get';

    if (_node <> '') then
        _iq.qTag.setAttribute('node', _node);

    _iq.Send();
end;

{---------------------------------------}
procedure TJabberEntity.getInfo(js: TJabberSession);
begin
    if (_iq <> nil) then exit;

    if ((_has_info) or (_type = ent_browse)) then
        _fireOnEntityInfo(js, _jid)
    else
        _discoInfo(js, InfoCallback);
end;

{---------------------------------------}
procedure TJabberEntity._discoItems(js: TJabberSession; callback: TSignalEvent);
begin
    // Dispatch a disco#items query
    _has_items := false;
    _iq := TJabberIQ.Create(js, js.generateID(), callback, _timeout);
    _iq.toJid := _jid.full;
    _iq.Namespace := XMLNS_DISCOITEMS;
    _iq.iqType := 'get';

    if (_node <> '') then
        _iq.qTag.setAttribute('node', _node);

    _iq.Send();
end;

{---------------------------------------}
procedure TJabberEntity.getItems(js: TJabberSession);
begin
    if (_iq <> nil) then exit;

    if ((_has_items) or (_type = ent_browse)) then
        _fireOnEntityItems(js, _jid)
    else
        _discoItems(js, ItemsCallback);
end;

{---------------------------------------}
procedure TJabberEntity.ItemsCallback(event: string; tag: TXMLTag);
var
    pt: TJabberEntityProcess;
    js: TJabberSession;
    ttag, temptag: TXMLTag;
    newItems: TWidestringlist;
begin
    //event may be 'xml', '/session/disconnected', 'timeout'
    assert(_iq <> nil);
    js := _iq.JabberSession;
    _iq := nil;

    //guarenteed to have a tag if event = xml
    if (event <> IQ_EVENT_XML) or (tag.getAttribute('type') = 'error') then
    begin
        if (_fallback and js.Prefs.getBool(BRANDED_ENABLE_FALLBACK)) then
            _startIQBrowse(js)
        else begin
            _has_items := true;
            _disco_info_error := (event = IQ_EVENT_XML);
            if (_disco_info_error) then
                _fireOnEntityItems(js, tag) //fire error tag
            else _fireOnEntityItems(js, _jid);
        end;
    end
    else begin
        //check our child count, spin item processing onto another thread if needed
        ttag := tag.QueryXPTag('/iq/query[@xmlns="' + XMLNS_DISCOITEMS + '"]');
        if ((ttag <> nil) and (ttag.ChildCount > UITHREAD_MAX_ITEMS)) then
        begin
            temptag := TXMLTag.Create(tag);
            pt := TJabberEntityProcess.Create(true);
            pt.jso := js;
            pt.tag := temptag;
            pt.ptype := ProcDisco;
            pt.e := Self;
            pt.FreeOnTerminate := true;
            pt.Resume();
        end
        else begin
            _has_items := true;
            if (ttag = nil) or (ttag.ChildCount = 0) then
                newItems := TWidestringlist.create() //clear item list
            else
                _processDiscoItems(tag, Self, newItems);
            _finishDiscoItems(js, tag, newitems);
        end;
    end;
end;

{---------------------------------------}
procedure TJabberEntity._finishDiscoItems(jso: TObject; tag: TXMLTag; newItems: TWidestringlist);
var
    i: integer;
begin
    //don't free objects as they are refreneced i the cache
    ClearStringListObjects(_items); //frees entities from cache
    _items.free();

    _items := newItems;
    //add items to cache, on the UI thread but jEntityCache is not thread safe so there ya go
    for i := 0 to newItems.Count - 1 do
        jEntityCache.Add(TJabberEntity(newItems.Objects[i])._jid, TJabberEntity(newItems.Objects[i]));

    _fireOnEntityItems(jso, _jid);
end;

{---------------------------------------}
procedure TJabberEntity._finishBrowse(jso: TObject);
var
    i: integer;
    js: TJabberSession;
    ce: TJabberEntity;
begin
    // send events for this entity
    js := TJabberSession(jso);
    getInfo(js);
    getItems(js);

    // Send info for each child
    for i := 0 to _items.Count - 1 do begin
        ce := TJabberEntity(_items.Objects[i]);
        _fireOnEntityInfo(jso, ce.jid);
    end;
end;

{---------------------------------------}
procedure TJabberEntity.InfoCallback(event: string; tag: TXMLTag);
var
    js: TJabberSession;
begin
    // if disco didn't so much workout, try browse next
    assert(_iq <> nil);
    js := _iq.JabberSession;
    _iq := nil;

    // if we're not connected anymore, just bail.
    if (js.Active = false) then exit;

    if (event <> IQ_EVENT_XML) or (tag.GetAttribute('type') = 'error') then
    begin
        if (_fallback and js.Prefs.getBool(BRANDED_ENABLE_FALLBACK)) then
            _startIQBrowse(js)
        else begin
            _has_info := true;
            _disco_info_error := (event = IQ_EVENT_XML);
            if (_disco_info_error) then
                _fireOnEntityInfo(js, tag) //fire error tag
            else
                _fireOnEntityInfo(js, _jid)
        end;
    end
    else begin
        _processDiscoInfo(tag);
        _fireOnEntityInfo(js, tag);
    end;
end;

{---------------------------------------}
procedure TJabberEntity.discoWalk(js: TJabberSession; items_limit: boolean;
    timeout: integer);
begin
    // Get Items, then get info for each one.
    if (_iq <> nil) then exit;//JJF this is probably not correct

    _use_limit := items_limit;
    _timeout := timeout;
    _discoInfo(js, WalkInfoCallback);
end;

{---------------------------------------}
procedure TJabberEntity.refresh(js: TJabberSession);
begin
    if ((_iq <> nil) or (_type = ent_cached_disco)) then exit;
    _stopWalk := false;
    _has_items := false;

    ClearStringListObjects(_items);
    _items.Clear();

    _discoInfo(js, WalkInfoCallback);
end;

procedure TJabberEntity.refreshInfo(js: TJabberSession);
begin
    if ((_iq <> nil) or (_type = ent_cached_disco)) then exit;
    _stopWalk := false;
    _has_items := true;

    //ClearStringListObjects(_items);
    //_items.Clear();
    _discoInfo(js, WalkInfoCallback);
end;

{---------------------------------------}
procedure TJabberEntity.LoadInfo(tag: TXMLTag);
begin
    _processDiscoInfo(tag);
end;

{---------------------------------------}
procedure TJabberEntity.AddReference(e: TJabberEntity);
var
    idx: integer;
begin
    idx := _refs.IndexOf(e);
    if (idx = -1) then
        _refs.Add(e);
end;

{---------------------------------------}
procedure TJabberEntity.RemoveReference(e: TJabberEntity);
var
    idx: integer;
begin
    idx := _refs.IndexOf(e);
    if (idx >= 0) then
        _refs.Delete(idx);
end;

{---------------------------------------}
procedure TJabberEntity.ClearReferences();
begin
    _refs.Clear();
end;

{---------------------------------------}
procedure TJabberEntity._processDiscoInfo(const tag: TXMLTag);
var
    id, q: TXMLTag;
    fset: TXMLTagList;
    i: integer;
begin
    {
    We get back something like:
        <iq
            type='result'
            from='plays.shakespeare.lit'
            to='romeo@montague.net/orchard'
            id='info1'>
          <query xmlns='http://jabber.org/protocol/disco#info'>
            <identity
                category='conference'
                type='text'
                name='Play-Specific Chatrooms'/>
            <identity
                category='directory'
                type='room'
                name='Play-Specific Chatrooms'/>
            <feature var='gc-1.0'/>
            <feature var='http://jabber.org/protocol/muc'/>
            <feature var='jabber:iq:register'/>
            <feature var='jabber:iq:search'/>
            <feature var='jabber:iq:time'/>
            <feature var='jabber:iq:version'/>
          </query>
        </iq>
    }
    if (_type <> ent_cached_disco) then
        _type := ent_disco;

    _has_info := true;
    _disco_info_error := false;

    _feats.Clear();
    _idents.Clear();
    if (_lastInfoIQResult <> nil) then
        _lastInfoIQResult.free();
    _lastInfoIQResult := nil;
    q := tag.GetFirstTag('query');
    if (q = nil) then exit;

    // process identities
    // XXX: Is this what to do w/ the other <identity> elements?
    fset := q.QueryTags('identity');
    for i := 0 to fset.count - 1 do
    begin
        id := fset[i];
        AddIdentity(TDiscoIdentity.Create(id));
    end;
    fset.Free();

    // process features
    fset := q.QueryTags('feature');
    for i := 0 to fset.count - 1 do
        AddFeature(fset[i].GetAttribute('var'));
    fset.Free();

    // process forms
    fset := q.QueryTags('x');
    for i := 0 to fset.Count - 1 do
    begin
        id := fset[i];
        if (id.GetAttribute('xmlns') <> 'jabber:x:data') then continue;
        AddForm(id);
    end;
    fset.Free();

    _lastInfoIQResult := TXMLTag.create(tag);
end;
{---------------------------------------}
{
procedure TJabberEntity._processLegacyFeatures();
begin
    // check for some legacy stuff..
    AddFeature(FEAT_SEARCH);
    AddFeature(FEAT_REGISTER);
    if ((_feats.IndexOf(XMLNS_MUC) <> -1) or (_feats.IndexOf('gc-1.0') <> -1) or (_cat = 'conference')) then
        AddFeature(FEAT_GROUPCHAT);

    // this is for transports.
    if  ((_cat_type = FEAT_AIM) or (_cat_type = FEAT_MSN) or
         (_cat_type = FEAT_ICQ) or (_cat_type = FEAT_YAHOO) or
         (_feats.IndexOf('jabber:iq:gateway') <> -1)) then
        AddFeature(_cat_type);
end;
}
{---------------------------------------}
procedure TJabberEntity._processDiscoItems(tag: TXMLTag;
                                           parent: TJabberEntity;
                                           out newItems: TWidestringList;
                                           itemLimit: integer);
var
    iset: TXMLTagList;
    i, count: integer;
    id, nid: Widestring;
    cj: TJabberID;
    ce: TJabberEntity;
    tjid: TJabberID;
begin
    {
    <iq
        type='result'
        from='catalog.shakespeare.lit'
        to='romeo@montague.net/orchard'
        id='items2'>
      <query xmlns='http://jabber.org/protocol/disco#items'>
        <item
            jid='catalog.shakespeare.lit'
            node='books'
            name='Books by and about Shakespeare'/>
        <item
            jid='catalog.shakespeare.lit'
            node='clothing'
            name='Show off your literary taste'/>
        <item
            jid='catalog.shakespeare.lit'
            node='music'
            name='Music from the time of Shakespeare'/>
      </query>
    </iq>
    }

    _has_items := true;
    newItems := TWidestringList.create();
    iset := tag.QueryXPTags('/iq/query[@xmlns="' + XMLNS_DISCOITEMS + '"]/item');
    count := iset.Count;
    if (itemLimit <> -1) and (count > itemLimit)  then
        count := itemLimit;

    for i := 0 to count - 1 do
    begin
        nid := iset[i].getAttribute('node');

        cj := TJabberID.Create(iset[i].getAttribute('jid'));
        id := cj.full;
        if (nid <> '') then
            id := nid + ':' + id;

        if (newitems.indexOf(id) = -1) then
        begin
            tjid := TJabberID.create(cj);
            ce := TJabberEntity.Create(tjid); //entity owns jid
            ce._parent := parent;
            ce._name := iset[i].getAttribute('name');
            ce._node := nid;
            newItems.AddObject(cj.full, ce);
            tjid.Free();
        end;  //ignore dups
        cj.Free();
    end;
    iset.Free();
end;


{---------------------------------------}
procedure TJabberEntity.WalkInfoCallback(event: string; tag: TXMLTag);
var
    js: TJabberSession;
begin
    // if disco didn't so much workout, try browse next
    assert(_iq <> nil);
    js := _iq.JabberSession;
    _iq := nil;

    // if we're not connected anymore, just bail.
    if (js.Active = false) then exit;

    _has_info:= true;
    if (event <> IQ_EVENT_XML) or (tag.GetAttribute('type') = 'error') then
    begin
        //no browse during walk, disco only!
        //handle error by pretending we finished normally
        _has_items := true;
        _disco_info_error := (event = IQ_EVENT_XML);
        //done recursing
        _fireOnEntityInfo(js, _jid);
        _fireOnEntityItems(js, _jid);
        if (_parent <> nil) then
            _parent._childDiscoWalkFinished(js, Self);
    end
    else begin
        // we got disco#info back! sweet.
        _processDiscoInfo(tag);
        if (_stopWalk) then
        begin
            _fireOnEntityInfo(js, tag);

            if (_parent <> nil) then begin
                _parent._childDiscoWalkFinished(js, Self);
            end;
        end
        else
            // We got info back... so lets get our items..
            _discoItems(js, WalkItemsCallback);
    end;
end;

{---------------------------------------}
procedure TJabberEntity.WalkItemsCallback(event: string; tag: TXMLTag);
var
    pt: TJabberEntityProcess;
    js: TJabberSession;
    newItems: TWidestringList;
    ttag: TXMLtag;
begin
    assert(_iq <> nil);
    js := _iq.JabberSession;
    _iq := nil;

    // if we're not connected anymore, just bail.
    if (js.Active = false) then exit;

    newItems := nil;

    if (tag.getAttribute('type') = 'error') then
        // Hrmpf.. we got info back, but no items?
        newItems := TWidestringList.create()
    else begin
        ttag := tag.QueryXPTag('/iq/query[@xmlns="' + XMLNS_DISCOITEMS + '"]');
        //limit items to UITHREAD_MAX_ITEMS during disco walk
        if (_use_limit) or (ttag = nil) or (ttag.ChildCount <= UITHREAD_MAX_ITEMS) then
            _processDiscoItems(tag, Self, newItems, UITHREAD_MAX_ITEMS);
    end;

    if (newItems <> nil) then
        _finishWalk(js, newItems)
    else begin
        ttag := TXMLTag.Create(tag);
        pt := TJabberEntityProcess.Create(true);
        pt.jso := js;
        pt.tag := ttag;
        pt.ptype := ProcWalk;
        pt.e := Self;
        pt.FreeOnTerminate := true;
        pt.Resume();
    end;
end;

{---------------------------------------}
procedure TJabberEntity._finishWalk(jso: TObject; newItems: TWidestringList);
var
    i: integer;
    js: TJabberSession;
begin
    js := TJabberSession(jso);
    ClearStringListObjects(_items); //frees entities from cache
    _items.free();

    _items := newItems;

    //set _has_items, based on whether or not there are children to walk
    //an entity does not have items until all of its children are done
    //with their walk.
    _has_items := (_items.Count = 0); //will be reset when children fire _childItemsWalkFinished

    //add items to cache, on the UI thread but jEntityCache is not thread safe so there ya go
    for i := 0 to _items.Count - 1 do
    begin
        TJabberEntity(_items.Objects[i])._stopWalk := true;
        jEntityCache.Add(TJabberEntity(_items.Objects[i])._jid, TJabberEntity(_items.Objects[i]));
        TJabberEntity(_items.Objects[i])._discoInfo(js, TJabberEntity(_items.Objects[i]).WalkInfoCallback);
    end;

    if (_has_items) then //entity done with walk
    begin
        if (_lastInfoIQResult <> nil) then
            _fireOnEntityInfo(js, _lastInfoIQResult)
        else
            _fireOnEntityInfo(js, _jid);

        _fireOnEntityItems(js, _jid);
        if (_parent <> nil) then
            _parent._childDiscoWalkFinished(js, Self);
    end;
end;

{---------------------------------------}
procedure TJabberEntity._processBrowseItem(item: TXMLTag);
var
    nss: TXMLTagList;
    n: integer;
begin
    _name := item.getAttribute('name');
    _cat := item.getAttribute('category');
    _cat_type := item.getAttribute('type');
    if ((_cat = '') and (item.Name <> 'item')) then
        _cat := item.Name;

    // this item can have ns elements.. *sigh*
    _feats.Clear();
    if (_lastInfoIQResult <> nil) then
        _lastInfoIQResult.free();
    _lastInfoIQResult := nil;

    nss := item.QueryTags('ns');
    for n := 0 to nss.Count - 1 do
        AddFeature(nss[n].Data);
    nss.Free();

    // we have the info about this object..
    _has_info := true;
    _disco_info_error := false;

    // but not it's children
    _has_items := false;
end;

{---------------------------------------}
procedure TJabberEntity.BrowseCallback(event: string; tag: TXMLTag);
var
    pt: TJabberEntityProcess;
    js: TJabberSession;
    ttag: TXMLTag;
begin
    assert(_iq <> nil);
    js := _iq.JabberSession;
    _iq := nil;

    // if we're not connected anymore, just bail.
    if (event <> IQ_EVENT_XML) or (tag.GetAttribute('type') = 'error') then
    begin
        _has_info := true;
        _disco_info_error := (event = IQ_EVENT_XML);
        if (_disco_info_error) then
            _fireOnEntityInfo(js, tag)
        else
            _fireOnEntityInfo(js, _jid);
    end
    else begin
        ttag := TXMLTag.Create(tag);
        pt := TJabberEntityProcess.Create(true);
        pt.jso := js;
        pt.tag := ttag;
        pt.ptype := ProcBrowse;
        pt.e := Self;
        pt.FreeOnTerminate := true;
        pt.Resume();
    end;
end;

{---------------------------------------}
procedure TJabberEntity._processBrowse(tag: TXMLTag);
var
    i: integer;
    q: TXMLTag;
    clist: TXMLTagList;
    tmps: Widestring;
    ce: TJabberEntity;
begin
    // we got browse back
    _type := ent_browse;
    _has_info := true;
    _disco_info_error := false;
    _has_items := true;

    // process results
    clist := tag.ChildTags();
    if (clist.Count > 0) then
    begin
        q := clist[0];
        clist.Free();

        clist := q.ChildTags();

        // process our own info
        ClearStringListObjects(_items);
        _items.Clear();
        _processBrowseItem(q);

        _has_info := true;
        _disco_info_error := false;
        _has_items := true;


        // Get our children
        for i := 0 to clist.Count - 1 do
        begin
            if (clist[i].Name <> 'ns') then
            begin
                // this is a child
                tmps := clist[i].GetAttribute('jid');
                if (_items.IndexOf(tmps) = -1) then
                begin
                    ce := TJabberEntity.Create(TJabberID.Create(tmps)); //entity owns jid
                    ce._parent := Self;
                    ce._processBrowseItem(clist[i]);
                    jEntityCache.Add(tmps, ce);
                    _items.AddObject(tmps, ce);
                end; //ignore dups
            end;
        end;
        clist.Free();
    end;
end;

procedure TJabberEntity._fireOnEntityInfo(jso: TObject; jid: TJabberID);
var
    ttag: TXMLTag;
begin
    ttag := TXMLTag.create('entity');
    ttag.setAttribute('from', jid.full);
    _fireOnEntityInfo(jso, ttag);
    ttag.free();
end;

procedure TJabberEntity._fireOnEntityInfo(jso: TObject; tag: TXMLTag);
begin
    TJabberSession(jso).FireEvent('/session/entity/info', tag);
end;

procedure TJabberEntity._fireOnEntityItems(jso: TObject; jid: TJabberID);
var
    ttag: TXMLTag;
begin
    ttag := TXMLTag.create('entity');
    ttag.setAttribute('from', jid.full);
    _fireOnEntityItems(jso, ttag);
    ttag.free();
end;

procedure TJabberEntity._fireOnEntityItems(jso: TObject; tag: TXMLTag);
begin
    TJabberSession(jso).FireEvent('/session/entity/items', tag);
end;

procedure TJabberEntity._startIQBrowse(jso: TObject);
begin
    _iq := TJabberIQ.Create(TJabberSession(jso),
                            TJabberSession(jso).generateID(),
                            Self.BrowseCallback,
                            _timeout);
    _iq.toJid := _jid.full;
    _iq.Namespace := XMLNS_BROWSE;
    _iq.iqType := 'get';
    _iq.Send();
end;

procedure TJabberEntity._childDiscoWalkFinished(jso: TObject; child: TJabberEntity);
var
    i : integer;
begin
    //see if all children have info
    for i := 0 to _items.Count - 1 do
        if (not TJabberEntity(_items.Objects[i]).hasInfo) then
            break;
    if (i = _items.Count) then
    begin
        if (_lastInfoIQResult <> nil) then
            _fireOnEntityInfo(jso, _lastInfoIQResult)
        else
            _fireOnEntityInfo(jso, _jid);
        _fireOnEntityItems(jso, _jid);

        if (_parent <> nil) then begin
            _parent._childDiscoWalkFinished(jso, Self);
        end;
    end;
end;

function TJabberEntity.toString(): WideString;
var
    i: integer;
    di: TDiscoIdentity;
    tstr: widestring;
begin
    tstr := _node;
    if (tstr = '') then
        tstr := '<NULL>';
    if (JID = nil) then
        tstr := 'JID: <NULL>, NODE: ' + tstr
    else
        tstr := 'JID: ' + JID.full + ', NODE: ' + tstr;

    Result := tstr + #13#10;
    if (hasInfo) then begin
        Result := Result + 'Identity Count: ' + IntToStr(IdentityCount) + #13#10;
        Result := Result + 'Identities:' + #13#10;
        for i := 0 to IdentityCount - 1 do begin
            di := Identities[i];
            Result := Result + '  Category: ' + di.Category + ', Type: ' + di.DiscoType + #13#10;
        end;
        Result := Result + 'Feature Count: ' + IntToStr(FeatureCount) + #13#10;
        Result := Result + 'Features:' + #13#10;
        for i := 0 to FeatureCount - 1 do begin
            Result := Result + '  ' + Features[i] + #13#10;
        end;
    end
    else begin
        Result := Result + 'No DISCO#INFO' + #13#10;
    end;
    //references
    Result := Result + 'Reference Count: ' + intToStr(_refs.count) + #13#10;
    for i := 0 to _refs.Count - 1 do  begin
        tstr := TJabberEntity(_refs[i]).Node;
        if (tstr = '') then
            tstr := '<NULL>';
        tstr := 'JID:' + TJabberEntity(_refs[i]).Jid.full + ':NODE:' + tstr;
        Result := Result + '  Reference#' + inttoStr(i) +  ' DiscoID: ' + tstr + #13#10;
    end;
end;

procedure TJabberEntity.SetNode(node: WideString);
begin
    _node := node;
end;

function TJabberEntity.AddIdentity(ident: TDiscoIdentity): Boolean;
begin
    Result := (ident <> nil) and (_idents.IndexOf(ident.Key) = -1);
    if Result then begin
        _idents.AddObject(ident.Key, ident);

        if (_idents.Count = 1) then begin
            _cat := ident.Category;
            _cat_type := ident.DiscoType;
            _name := ident.Name;
        end;
    end;
end;
function TJabberEntity.RemoveIdentity(ident: TDiscoIdentity): Boolean;
var
    idx: Integer;
begin
    Result := false;
    if (ident = nil) then exit;
    
    idx := _idents.IndexOf(ident.Key);
    if (idx = -1) then exit;

    _idents.Delete(idx);
    Result := true;
end;

function TJabberEntity.AddFeature(feat: WideString): Boolean;
begin
    Result := (feat <> '') and (_feats.IndexOf(feat) = -1);
    if Result then begin
        _feats.Add(feat);
    end;
end;

function TJabberEntity.RemoveFeature(feat: WideString): Boolean;
var
    idx: Integer;
begin
    idx := _feats.IndexOf(feat);
    Result := (idx <> -1);
    if Result then begin
        _feats.Delete(idx);
    end;
end;


function FormKey(form: TXMLTag): Widestring;
begin
    Result := '';
    if (form = nil) then exit;

    Result := form.QueryXPData('field[@var="FORM_TYPE"]/value');
end;

function TJabberEntity.AddForm(form: TXMLTag): Boolean;
var
    key: Widestring;
begin
    key := FormKey(form);
    Result := (form <> nil) and (_forms.IndexOf(key) = -1);
    if Result then begin
        _forms.AddObject(key, TXMLTag.Create(form));
    end;
end;
function TJabberEntity.RemoveForm(form: TXMLTag): Boolean;
var
    key: Widestring;
    idx: Integer;
begin
    key := FormKey(form);
    idx := _forms.IndexOf(key);
    Result := (form <> nil) and (_forms.IndexOf(key) <> -1);
    if Result then begin
        _forms.Delete(idx);
    end;
end;

end.
