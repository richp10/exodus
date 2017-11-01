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
unit Roster;


interface

uses
    {$ifdef Exodus}
    TntClasses,
    {$endif}
    NodeItem, JabberID, Presence, Signals, Unicode, XMLTag,
    SysUtils, Classes, Windows;

type

    TRosterEvent = procedure(event: string; tag: TXMLTag; ritem: TJabberRosterItem) of object;
    TRosterListener = class(TPacketListener)
    public
    end;

    TRosterSignal = class(TPacketSignal)
    public
        procedure Invoke(event: string; tag: TXMLTag; ritem: TJabberRosterItem = nil); overload;
        function addListener(callback: TRosterEvent; xplite: Widestring): TRosterListener; overload;
    end;

    TJabberRoster = class(TWideStringList)
    private
        _js: TObject;
        _groups: TWidestringlist;
        _pres_cb: integer;

        _ico_blockoffline: integer;
        _ico_blocked: integer;
        _ico_unknown: integer;

        procedure ParseFullRoster(event: String; tag: TXMLTag);
        procedure Callback(event: String; tag: TXMLTag);
        procedure UpdateCallback(event: String; tag: TXMLTag; ritem: TJabberRosterItem);
        procedure RemoveCallback(event: String; tag: TXMLTag; ritem: TJabberRosterItem);
        procedure presCallback(event: String; tag: TXMLTag; pres: TJabberPres);
        procedure PrefsCallback(event: String; tag: TXMLTag);

        procedure checkGroups(ri: TJabberRosterItem);

        function  checkGroup(grp: Widestring): TJabberGroup;
        function  getNumGroups: integer;
        function  getGroupIndex(idx: integer): TJabberGroup;

        function getItem(index: integer): TJabberRosterItem;

        function setupOfflineGrp(): TJabberGroup;
        function setupUnfiledGrp(): TJabberGroup;
        function setupMyResourcesGrp(): TJabberGroup;

        procedure cacheIcons();

    public
        ActiveItem: TJabberRosterItem;
        
        constructor Create;
        destructor Destroy; override;

        procedure Clear; override;

        procedure SetSession(js: TObject);
        procedure Fetch;
        procedure parseItem(ri: TJabberRosterItem; tag: TXMLTag);

        function newItem(jid: Widestring): TJabberRosterItem;
        procedure AddItem(jid: Widestring; ri: TJabberRosterItem); overload;
        procedure AddItem(sjid, nickname, group: Widestring; subscribe: boolean); overload;
        procedure RemoveItem(jid: Widestring);

        function Find(sjid: Widestring): TJabberRosterItem; reintroduce; overload;

        function addGroup(grp: Widestring): TJabberGroup;
        function getGroup(grp: Widestring): TJabberGroup;
        procedure removeGroup(grp: TJabberGroup);

        function getGroupItems(grp: Widestring; online: boolean): TList;

        procedure AssignGroups(l: TWidestringlist); overload;
        {$ifdef Exodus}
        procedure AssignGroups(tnt: TTntStrings); overload;
        {$endif}

        property GroupsCount: integer read getNumGroups;
        property Groups[index: integer]: TJabberGroup read getGroupIndex;
        property Items[index: integer]: TJabberRosterItem read getItem;
    end;

    TRosterAddItem = class
    private
        jid: Widestring;
        grp: Widestring;
        nick: Widestring;
        do_subscribe: boolean;

        procedure AddCallback(event: String; tag: TXMLTag);
    public
        constructor Create(sjid, nickname, group: Widestring; subscribe: boolean);
    end;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
implementation
uses
    DisplayName,
    RosterImages, GnuGetText, JabberConst, iq, s10n, XMLUtils, Session, EntityCache;

const
    sGrpBookmarks = 'Bookmarks';
    sGrpOffline = 'Offline';
    sGrpUnfiled = 'Unfiled';
    sGrpOnline = 'Available';
    sGrpAway = 'Away';
    sGrpXA = 'Ext. Away';
    sGrpDND = 'Do Not Disturb';
    sGrpMyResources = 'My Resources';

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
constructor TJabberRoster.Create;
begin
    inherited;
    _groups := TWidestringlist.Create();
    _groups.CaseSensitive := true;
end;

{---------------------------------------}
destructor TJabberRoster.Destroy;
begin
    ClearStringListObjects(_groups);
    _groups.Free();

    inherited Destroy;
end;

{---------------------------------------}
procedure TJabberRoster.Clear;
begin
    // Free all the roster items.
    ClearStringListObjects(Self);
    ClearStringListObjects(_groups);

    _groups.Clear();

    inherited Clear();
end;

{---------------------------------------}
function TJabberRoster.getItem(index: integer): TJabberRosterItem;
begin
    // return a specific TJabberRosterItem from the Objects list
    if ((index < 0) or (index >= Self.Count)) then
        Result := nil
    else
        Result := TJabberRosterItem(Self.Objects[index]);
end;

{---------------------------------------}
procedure TJabberRoster.SetSession(js: TObject);
begin
    _js := js;
    with TJabberSession(_js) do begin
        RegisterCallback(Callback, '/packet/iq/query[@xmlns="jabber:iq:roster"]');
        RegisterCallback(UpdateCallback, '/roster/update/item[@xmlns="jabber:iq:roster"]');
        RegisterCallback(RemoveCallback, '/roster/remove/item[@xmlns="jabber:iq:roster"]');
        RegisterCallback(PrefsCallback, '/session/prefs');
        _pres_cb := RegisterCallback(presCallback);
    end;
end;

{---------------------------------------}
function TJabberRoster.setupUnfiledGrp(): TJabberGroup;
var
    go: TJabberGroup;
begin
    go := addGroup(_('Unfiled'));
    go.KeepEmpty := false;
    go.SortPriority := 500;
    go.ShowPresence := false;
    go.DragTarget := false;
    go.DragSource := true;
    go.AutoExpand := true;
    Result := go;
end;


{---------------------------------------}
function TJabberRoster.setupOfflineGrp(): TJabberGroup;
var
    go: TJabberGroup;
begin
    go := addGroup(_('Offline'));
    go.KeepEmpty := true;
    go.SortPriority := 500;
    go.ShowPresence := false;
    go.DragTarget := false;
    go.DragSource := false;
    go.AutoExpand := false;
    Result := go;
end;

{---------------------------------------}
function TJabberRoster.setupMyResourcesGrp(): TJabberGroup;
var
    go: TJabberGroup;
begin
    go := addGroup(_('My Resources'));
    go.KeepEmpty := false;
    go.SortPriority := 750;
    go.ShowPresence := false;
    go.DragTarget := false;
    go.DragSource := false;
    go.AutoExpand := true;
    Result := go;
end;

{---------------------------------------}
procedure TJabberRoster.cacheIcons();
begin
    _ico_blockoffline := RosterTreeImages.Find('offline_blocked');
    _ico_blocked := RosterTreeImages.Find('online_blocked');
    _ico_unknown := RosterTreeImages.Find('unknown');
end;

{---------------------------------------}
procedure TJabberRoster.PrefsCallback(event: String; tag: TXMLTag);
var
    offline_grp: boolean;
    go: TJabberGroup;
begin
    // setup the offline group
    cacheIcons();
    
    offline_grp := TJabberSession(_js).Prefs.getBool('roster_offline_group');
    go := getGroup(_('Offline'));
    if ((offline_grp) and (go = nil)) then begin
        setupOfflineGrp();
    end
    else if ((not offline_grp) and (go <> nil)) then
        removeGroup(go);
end;

{---------------------------------------}
procedure TJabberRoster.Fetch;
var
    js: TJabberSession;
    f_iq: TJabberIQ;
begin
    cacheIcons();

    setupUnfiledGrp();
    if (MainSession.Prefs.getBool('roster_offline_group')) then
        setupOfflineGrp();

    js := TJabberSession(_js);
    f_iq := TJabberIQ.Create(js, js.generateID(), ParseFullRoster, 600);
    with f_iq do begin
        iqType := 'get';
        toJID := '';
        Namespace := XMLNS_ROSTER;
        Send();
    end;
end;

{---------------------------------------}
procedure TJabberRoster.parseItem(ri: TJabberRosterItem; tag: TXMLTag);
var
    grps: TXMLTagList;
    g: integer;
    tmp_grp: Widestring;
begin
    ri.IsContact := true;
    ri.Action := '/session/gui/contact';

    ri.Tag := TXMLTag.Create(tag);
    ri.Tag.setAttribute('xmlns', XMLNS_ROSTER);
    ri.Text := tag.GetAttribute('name');

    // if there is no nickname, just use the user portion of the jid
    if (ri.Text = '') then
        if (ri.Subscription <> '') then
            ri.Text := DisplayName.getDisplayNameCache().getDisplayName(ri.Jid)
        else ri.Text := ri.Jid.userDisplay;

    ri.ClearGroups();    
    grps := tag.QueryXPTags('/item/group');
    for g := 0 to grps.Count - 1 do begin
        tmp_grp := Trim(TXMLTag(grps[g]).Data);
        if (tmp_grp <> '') then
            ri.AddGroup(tmp_grp);
    end;
    grps.Free();
    ri.SetCleanGroups();
    if (ri.Tooltip = '') then
        ri.Tooltip := ri.jid.getDisplayFull() + ': ' + _('Offline')
end;


{---------------------------------------}
procedure TJabberRoster.Callback(event: String; tag: TXMLTag);
var
    q: TXMLTag;
    ritems: TXMLTagList;
    ri: TJabberRosterItem;
    idx, i: integer;
    tmp_jid: TJabberID;
    iq_type, j: Widestring;
    s: TJabberSession;
    pr: TJabberPres;
    pres_found: Boolean;
begin
    // callback from the session
    s := TJabberSession(_js);

    // this is some kind of roster push
    iq_type := tag.GetAttribute('type');
    if (iq_type <> 'set') then exit;

    // a roster push
    q := tag.GetFirstTag('query');
    if q = nil then exit;
    ritems := q.QueryTags('item');

    for i := 0 to ritems.Count - 1 do begin
        tmp_jid := TJabberID.Create(ritems[i].getAttribute('jid'));
        j := tmp_jid.full;
        tmp_jid.Free();
        ri := Self.Find(j);

        if ri = nil then begin
            ri := TJabberRosterItem.Create(j);
            Self.AddObject(j, ri);
        end;
        parseItem(ri, ritems[i]);
        checkGroups(ri);
        s.FireEvent('/roster/item', tag, ri);
        if (ri.subscription = 'remove') then begin
            idx := Self.indexOfObject(ri);
            ri.Free;
            Self.Delete(idx);
            //Remove presence from PPDB for all resources
            tmp_jid := TJabberID.Create(ritems[i].getAttribute('jid'));
            pres_found := true;
            while (pres_found) do begin
              pr := s.ppdb.FindPres(tmp_jid.full, '');
              if (pr <> nil) then
                 s.ppdb.DeletePres(pr)
              else
                 pres_found := false;
            end;
            jEntityCache.RemoveJid(tmp_jid.jid);
            jEntityCache.RemoveJid(tmp_jid.full);
        end;
    end;

    ritems.Free();
end;

{---------------------------------------}
procedure TJabberRoster.UpdateCallback(event: String; tag: TXMLTag; ritem: TJabberRosterItem);
var
    ri: TJabberRosterItem;
    tagitem, item, iq: TXMLTag;
    g: integer;
begin
    // update this roster item if it's a jabber:iq:roster item
    tagitem := tag.GetFirstTag('item');
    ri := Self.Find(tagitem.GetAttribute('jid'));
    if (ri = nil) then exit;

    // make sure it's the same one passed to us in the event
    assert(ri = ritem);

    iq := TXMLTag.Create('iq');
    iq.setAttribute('type', 'set');
    iq.setAttribute('id', TJabberSession(_js).generateID());
    with iq.AddTag('query') do begin
        setAttribute('xmlns', XMLNS_ROSTER);
        item := AddTag('item');
        item.setAttribute('jid', ri.Jid.full);
        item.setAttribute('name', ri.Text);

        // add in groups
        if (ri.AreGroupsDirty) then begin
            for g := 0 to ri.DirtyGroupCount - 1 do
                item.AddBasicTag('group', ri.DirtyGroup[g]);
        end
        else begin
            for g := 0 to ri.GroupCount - 1 do
                item.AddBasicTag('group', ri.Group[g]);
        end;
    end;
    TJabberSession(_js).SendTag(iq);
end;

{---------------------------------------}
procedure TJabberRoster.RemoveCallback(event: String; tag: TXMLTag; ritem: TJabberRosterItem);
var
    ri: TJabberRosterItem;
    tagitem, item, iq: TXMLTag;
begin
    tagitem := tag.GetFirstTag('item');
    ri := Self.Find(tagitem.GetAttribute('jid'));
    if (ri = nil) then exit;

    // make sure it's the same one passed to us in the event
    assert(ri = ritem);

    iq := TXMLTag.Create('iq');
    iq.setAttribute('type', 'set');
    iq.setAttribute('id', TJabberSession(_js).generateID());
    with iq.AddTag('query') do begin
        setAttribute('xmlns', XMLNS_ROSTER);
        item := AddTag('item');
        item.setAttribute('jid', ri.Jid.full);
        item.setAttribute('subscription', 'remove');
    end;
    TJabberSession(_js).SendTag(iq);
end;

{---------------------------------------}
procedure TJabberRoster.presCallback(event: String; tag: TXMLTag; pres: TJabberPres);
var
    is_me: boolean;
    ri: TJabberRosterItem;
    unf, go: TJabberGroup;
    i, idx: integer;
    jid, tmps, cur_grp: Widestring;
    is_blocked: boolean;
    p: TJabberPres;
begin
    // we are getting /preseence events
    if ((event = '/presence/error') or (event = '/presence/subscription')) then
        exit;

    is_me := false;
    jid := pres.fromJid.jid;

    if (jid = TJabberSession(_js).BareJid) then begin
        // this is one of my resources
        is_me := true;

        // check for the My Resources group
        if (pres.PresType <> 'unavailable') then begin
            setupMyResourcesGrp();
        end;

        ri := Self.Find(pres.fromJid.full);
        if (ri = nil) then begin
            ri := TJabberRosterItem.Create(pres.fromJid.full);
            ri.IsContact := true;
            ri.Text := pres.fromJid.resource;
            ri.Status := pres.Status;
            ri.Action := '/session/gui/contact';
            ri.Tooltip := pres.fromJid.getDisplayFull();
            ri.AddGroup(_('My Resources'));
            ri.SetCleanGroups();

            ri.Tag := TXMLTag.Create('item');
            ri.Tag.setAttribute('jid', pres.fromJid.full);
            ri.Tag.setAttribute('subscription', 'both');
            ri.Tag.setAttribute('name', pres.fromJid.Resource);

            // add this item to the roster
            TJabberSession(_js).Roster.AddItem(pres.fromJid.full, ri);
        end;
    end
    else begin
        // this should always work for normal items
        ri := Self.Find(jid);

        // if we can't find the item based on bare jid, check the full jid.
        // NB: this should catch most of the transport madness.
        if (ri = nil) then begin
            jid := pres.fromJid.full;
            ri := Self.Find(jid);
        end;

        // if we still don't have a roster item,
        // and we have no username portion of the JID, then
        // check for jid/registered for more transport madness
        if ((ri = nil) and (pres.fromJid.user = '') and (pres.fromJid.resource = '')) then begin
            jid := pres.fromJid.domain + '/registered';
            ri := Self.Find(jid);
        end;
    end;

    if (ri = nil) then exit;
    if (not ri.IsContact) then exit;

    if ((event = '/presence/online') or (event = '/presence/offline')) then begin
        // this JID is coming online... inc group counters

        // special case for unfiled
        if (ri.GroupCount = 0) then begin
            unf := getGroup(_('Unfiled'));
            assert(unf <> nil);
            unf.setPresence(ri.jid.jid, pres);
        end;

        // iterate over all groups for this user.
        for i := 0 to ri.GroupCount - 1 do begin
            cur_grp := ri.Group[i];
            idx := _groups.IndexOf(cur_grp);
            if (idx >= 0) then begin
                go := TJabberGroup(_groups.Objects[idx]);
                if (go.ShowPresence) then
                    go.setPresence(ri.jid, pres);
            end;
        end;
    end;

    // is this contact blocked?
    is_blocked := TJabberSession(_js).isBlocked(ri.jid);

    // update tooltips for this roster item when presence changes
    p := TJabberSession(_js).ppdb.FindPres(ri.JID.jid, '');

    // if the primary resource is -1, then make believe they aren't online
    if ((p <> nil) and (p.priority < 0)) then p := nil;

    // setup the image
    if ((is_me) and
        ((p = nil) or
         (event = '/presence/offline') or
         (event = '/presence/unavailable'))) then begin
        // this resource isn't online anymore... remove it
        ri.Removed := true;
    end
    else if ((is_blocked) and (p = nil)) then begin
        //ri.ImageIndex := _ico_blockoffline
        ri.ImageIndex := RosterTreeImages.Find(ri.ImagePrefix + 'offline_blocked');
    end
    else if (is_blocked) then begin
        //ri.ImageIndex := _ico_blocked
        ri.ImageIndex := RosterTreeImages.Find(ri.ImagePrefix + 'online_blocked');
    end
    else if (ri.ask = 'subscribe') then
        ri.ImageIndex := _ico_Unknown
    else if p = nil then
        ri.setPresenceImage('offline')
    else begin
        if (is_me) then
            // Show the provided presence
            ri.setPresenceImage(pres.Show)
        else
            // Show the PPDB presence
            ri.setPresenceImage(p.show);
    end;

    // Gen Tooltip
    if (is_me) then begin
        // This is another of my resources presences.
        // We do not want to build up a tooltip with multiple
        // entries as there are problems propigating changes.
        // Just make tool tip jid: presence for this resource
        if (pres <> nil) then begin
            if (pres.Status <> '') then
                ri.Tooltip := pres.fromJid.getDisplayFull() + ': ' + pres.Status
            else
                ri.Tooltip := pres.fromJid.getDisplayFull() + ': ' + DecodeShowDisplayValue(pres.show);
        end
        else
            ri.Tooltip := '';
    end
    else begin
        // Not one of my presences, so build up tooltip with all presences for JID.
        if (p = nil) then
            ri.Tooltip := ri.jid.getDisplayFull() + ': ' + _('Offline')
        else begin
            // Compile a list of jid: status for each resource
            tmps := '';
            while (p <> nil) do begin
                if (tmps <> '') then tmps := tmps + ''#13#10;
                if (p.Status = '') then
                  tmps := tmps + p.fromJid.getDisplayFull() + ': ' + DecodeShowDisplayValue(p.show)
                else
                  tmps := tmps + p.fromJid.getDisplayFull() + ': ' + p.Status;
                p := TJabberSession(_js).ppdb.NextPres(p);
            end;
            ri.Tooltip := tmps;
        end;
    end;

    // notify the window that this item needs to be updated
    TJabberSession(_js).FireEvent('/roster/item', tag, ri);

    // If this is my resource and it went offline, then
    // get rid of the item in Self's list or we will never
    // see it again.
    if (is_me and ri.Removed) then
        Self.RemoveItem(ri.Jid.full);
end;

{---------------------------------------}
procedure TJabberRoster.AssignGroups(l: TWidestringlist);
var
    t, c: Widestring;
    i: integer;
begin
    l.Clear();
    t := TJabberSession(_js).Prefs.getString('roster_transport_grp');
    for i := 0 to _groups.Count - 1 do begin
        c := _groups[i];
        if ((c <> sGrpBookmarks) and
            (c <> sGrpUnfiled) and
            (c <> sGrpOffline) and
            (c <> sGrpMyResources) and
            (c <> t)) then
            l.Add(c);
    end;
end;

{---------------------------------------}
{$ifdef Exodus}
procedure TJabberRoster.AssignGroups(tnt: TTntStrings);
var
    t, c: Widestring;
    i: integer;
begin
    tnt.Clear();
    t := TJabberSession(_js).Prefs.getString('roster_transport_grp');
    for i := 0 to _groups.Count - 1 do begin
        c := _groups[i];
        if ((c <> sGrpBookmarks) and
            (c <> sGrpUnfiled) and
            (c <> sGrpOffline) and
            (c <> sGrpMyResources) and
            (c <> t)) then
            tnt.Add(c);
    end;
end;
{$endif}

{---------------------------------------}
procedure TJabberRoster.checkGroups(ri: TJabberRosterItem);
var
    n, nl, i: integer;
    gidx, jidx: boolean;
    unf, go: TJabberGroup;
    path, cur_grp: Widestring;
    p: TJabberPres;
begin
    // make sure _groups is populated.
    p := TJabberSession(_js).ppdb.FindPres(ri.jid.jid, '');

    // Make sure we have all groups that this contact is in.
    for i := 0 to ri.GroupCount - 1 do begin
        cur_grp := ri.Group[i];
        go := checkGroup(cur_grp);
        nl := go.NestLevel;
        if (nl > 1) then begin
            path := '';
            for n := 0 to nl-1 do begin
                if (path <> '') then
                    path := path +
                        TJabberSession(_js).prefs.getString('group_seperator');
                path := path + go.Parts[n];
                checkGroup(path);
            end;
        end;
    end;

    // If this ritem is in unfiled, and they shouldn't be, remove them.
    // If they need to be in unfiled, but aren't, add them

    unf := getGroup(_('Unfiled'));
    if (unf = nil) then begin
        unf := setupUnfiledGrp();
        assert(unf <> nil);
    end;

    jidx := unf.inGroup(ri.jid);
    if ((ri.GroupCount > 0) and (jidx)) then
        unf.removeJid(ri.jid)
    else if ((ri.GroupCount = 0) and (not jidx)) then begin
        unf.addJid(ri.jid);
        unf.setPresence(ri.jid, p);
    end;

    // Iterate all grps, either remove this jid from that grp
    // Or add it, depending on the ritem.Groups property.
    for i := 0 to _groups.Count - 1 do begin
        go := TJabberGroup(_groups.Objects[i]);
        gidx := ri.IsInGroup(go.FullName);
        jidx := go.inGroup(ri.jid);

        if ((jidx) and (not gidx)) then
            // they are in the TJabberGroup but shouldn't be.
            go.removeJid(ri.jid)
        else if ((not jidx) and (gidx)) then begin
            // they aren't in the TJabberGroup but should be.
            go.AddJid(ri.jid);
        end;

        // Make sure this grp has updated presence
        if (gidx) then
            go.setPresence(ri.jid.jid, p);
    end;
end;

{---------------------------------------}
function TJabberRoster.checkGroup(grp: Widestring): TJabberGroup;
var
    i: integer;
    p, go: TJabberGroup;
    path: Widestring;
begin
    i := _groups.IndexOf(grp);
    if (i = -1) then begin
        go := TJabberGroup.Create(grp);
        _groups.AddObject(grp, go);

        // if this new grp should be nested, do the right thing..
        if (go.NestLevel > 1) then begin
            path := '';
            for i := 0 to go.NestLevel - 2 do begin
                if (path <> '') then path := path + '/';
                path := path + go.Parts[i];
            end;
            p := getGroup(path);
            if (p = nil) then p := addGroup(path);
            if (p.getGroup(go.FullName) = nil) then p.addGroup(go);
        end;

    end
    else
        go := TJabberGroup(_groups.Objects[i]);

    Result := go;
end;

{---------------------------------------}
function TJabberRoster.getNumGroups: integer;
begin
    Result := _groups.Count;
end;

{---------------------------------------}
function  TJabberRoster.getGroupIndex(idx: integer): TJabberGroup;
begin
    if (idx >= _groups.Count) then
        Result := nil
    else
        Result := TJabberGroup(_groups.Objects[idx]);
end;

{---------------------------------------}
function TJabberRoster.Find(sjid: Widestring): TJabberRosterItem;
var
    i: integer;
begin
    i := indexOf(WideLowerCase(sjid));
    if (i >= 0) and (i < Count) then
        Result := TJabberRosterItem(Objects[i])
    else
        Result := nil;
end;

{---------------------------------------}
function TJabberRoster.getGroup(grp: Widestring): TJabberGroup;
var
    i: integer;
begin
    i := _groups.indexOf(grp);
    if (i >= 0) then
        Result := TJabberGroup(_groups.Objects[i])
    else
        Result := nil;
end;

{---------------------------------------}
function TJabberRoster.addGroup(grp: Widestring): TJabberGroup;
begin
    Result := checkGroup(grp);
end;

{---------------------------------------}
procedure TJabberRoster.removeGroup(grp: TJabberGroup);
var
    i: integer;
begin
    i := _groups.IndexOfObject(grp);
    if (i = -1) then exit;

    _groups.Delete(i);
    grp.Free();
end;

{---------------------------------------}
function TJabberRoster.GetGroupItems(grp: Widestring; online: boolean): TList;
var
    i: integer;
    go: TJabberGroup;
begin
    Result := TList.Create();
    i := _groups.indexOf(grp);
    if (i = -1) then exit;
    go := TJabberGroup(_groups.Objects[i]);
    go.getRosterItems(Result, online);
end;

function TJabberRoster.newItem(jid: Widestring): TJabberRosterItem;
begin
    Result := TJabberRosterItem.Create(jid);
    Self.AddObject(jid, Result);
end;

{---------------------------------------}
procedure TJabberRoster.AddItem(jid: Widestring; ri: TJabberRosterItem);
begin
    Self.AddObject(jid, ri);
    checkGroups(ri);
    TJabberSession(_js).FireEvent('/roster/item', ri.tag, ri);
end;

{---------------------------------------}
procedure TJabberRoster.AddItem(sjid, nickname, group: Widestring; subscribe: boolean);
var
    ritem: TJabberRosterItem;
begin
    // send a iq-set
    ritem := Self.Find(sjid);
    if (ritem <> nil) then begin
        if ((ritem.subscription = 'to') or (ritem.subscription = 'both')) then begin
            ritem.AddGroup(group);
            ritem.Update();
            exit;
        end;
    end;
    TRosterAddItem.Create(sjid, nickname, group, subscribe);
end;

{---------------------------------------}
procedure TJabberRoster.RemoveItem(jid: Widestring);
var
    ri: TJabberRosterItem;
    i: integer;
begin
    i := Self.IndexOf(jid);
    if (i >= 0) then begin
        ri := TJabberRosterItem(Objects[i]);
        ri.Free();
        Self.Delete(i);
    end;
end;

{---------------------------------------}
procedure TJabberRoster.ParseFullRoster(event: string; tag: TXMLTag);
var
    rt, ct, etag: TXMLTag;
    ritems: TXMLTagList;
    idx, i: integer;
    ri: TJabberRosterItem;
    s: TJabberSession;
    tmp_jid: TJabberID;
begin
    // parse the full roster push

    // Don't clear out the list.. we may have gotten roster pushes
    // in before this from mod_groups or something similar.

    s := TJabberSession(_js);

    if (event <> 'xml') then begin
        // timeout!
        if (s.Stream <> nil) then Self.Fetch();
    end

    else if (tag.GetAttribute('type') = 'error') then begin
        // some kind of roster fetch error
        etag := tag.GetFirstTag('error');
        if (etag <> nil) then begin
            if (etag.GetAttribute('code') = '404') then begin
                Self.Fetch();
                exit;
            end;
        end;

        // this will happen if people are not using
        // mod_roster, but using mod_groups or something
        // similar
        rt := TXMLTag.Create('start');
        s.FireEvent('/roster/start', rt, TJabberRosterItem(nil));
        rt.Free();

        rt := TXMLTag.Create('end');
        s.FireEvent('/roster/end', rt, TJabberRosterItem(nil));
        rt.Free();
        
        exit;
    end

    else begin
        // fire off the start event..
        // then cycle thru all the item tags
        rt := TXMLTag.Create('start');
        s.FireEvent('/roster/start', rt, TJabberRosterItem(nil));
        rt.Free();

        ritems := tag.QueryXPTags('/iq/query/item');
        for i := 0 to ritems.Count - 1 do begin
            ct := ritems.Tags[i];
            tmp_jid := TJabberID.Create(ct.GetAttribute('jid'));
            idx := Self.IndexOf(tmp_jid.full);
            if (idx = -1) then
                ri := TJabberRosterItem.Create(tmp_jid.full)
            else
                ri := TJabberRosterItem(Self.Objects[idx]);
            tmp_jid.Free();
            parseItem(ri, ct);
            checkGroups(ri);
            if (idx = -1) then
                AddObject(WideLowerCase(ri.jid.Full), ri);
            s.FireEvent('/roster/item', ritems.Tags[i], ri);
        end;

        ritems.Free();

        rt := TXMLTag.Create('end');
        s.FireEvent('/roster/end', rt, TJabberRosterItem(nil));
        rt.Free();
    end;
end;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
constructor TRosterAddItem.Create(sjid, nickname, group: Widestring; subscribe: boolean);
var
    iq: TJabberIQ;
begin
    inherited Create();

    jid := sjid;
    nick := nickname;
    grp := group;
    do_subscribe := subscribe;

    iq := TJabberIQ.Create(MainSession, MainSession.generateID, Self.AddCallback);
    with iq do begin
        Namespace := XMLNS_ROSTER;
        iqType := 'set';
        with qTag.AddTag('item') do begin
            setAttribute('jid', jid);
            setAttribute('name', nick);
            if (group <> '') then
                AddBasicTag('group', grp);
        end;
    end;
    iq.Send;
end;

{---------------------------------------}
procedure TRosterAddItem.AddCallback(event: String; tag: TXMLTag);
var
    iq_type: Widestring;
begin
    // callback for the roster add.
    if (tag <> nil) then begin
        iq_type := tag.getAttribute('type');
        if (((iq_type = 'set') or (iq_type = 'result')) and (do_subscribe)) then
            SendSubscribe(jid, MainSession);
    end;

    Self.Free();
end;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
function TRosterSignal.addListener(callback: TRosterEvent; xplite: Widestring): TRosterListener;
var
    l: TRosterListener;
    xps: Widestring;
begin
    l := TRosterListener.Create();
    l.callback := TMethod(callback);

    xps := Copy(xplite, _len_event + 1, length(xplite) - _len_event);
    l.xp.Parse(xps);

    inherited addListener(xplite, l);
    Result := l;
end;

{---------------------------------------}
procedure TRosterSignal.Invoke(event: string; tag: TXMLTag; ritem: TJabberRosterItem = nil);
var
    i: integer;
    rl: TRosterListener;
    xp: TXPLite;
    re: TRosterEvent;
begin
    // dispatch this to all interested listeners
    // This is almost identical to TPacketSignal.Invoke()
    inc(_invoking);
    for i := 0 to Self.Count - 1 do begin
        rl := TRosterListener(Self.Objects[i]);
        xp := rl.XPLite;
        if xp.Compare(tag) then begin
            re := TRosterEvent(rl.Callback);
            try
                re(event, tag, ritem);
            except
                on e: Exception do
                    Dispatcher.handleException(Self, e, rl, event, tag);
            end;
        end;
    end;
    dec(_invoking);

    if (change_list.Count > 0) and (_invoking = 0) then
        Self.processChangeList();


    (*
    cmp := Lowercase(Trim(event));
    inc(_invoking);
    for i := 0 to Self.Count - 1 do begin
        e := Strings[i];
        l := TRosterListener(Objects[i]);
        sig := TRosterEvent(l.callback);
        if (e <> '') then begin
            // check to see if the listener's string is a substring of the event
            if (Pos(e, cmp) >= 1) then begin
                try
                    sig(event, tag, ritem);
                except
                    on x: Exception do
                        Dispatcher.handleException(Self, x, l, event, tag);
                end;
            end;
        end
        else begin
            try
                sig(event, tag, ritem);
            except
                on x: Exception do
                    Dispatcher.handleException(Self, x, l, event, tag);
            end;
        end;
    end;
    dec(_invoking);

    if (change_list.Count > 0) and (_invoking = 0) then
        Self.processChangeList();
    *)

end;

end.

