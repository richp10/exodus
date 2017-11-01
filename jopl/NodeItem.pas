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
unit NodeItem;


interface
uses
    TntMenus, 
    Presence, JabberID, Unicode, XMLTag, SysUtils, Classes;

type
    TJabberNodeType = (node_group, node_contact, node_custom);

    TJabberNodeItem = class
    public
        function getText(): Widestring; virtual; abstract; 
    end;

    TJabberGroup = class(TJabberNodeItem)
    private
        _online: integer;           // # of users online
        _full: Widestring;          // full name of grp: a/b/c
        _parts: TWidestringlist;    // parts of the group name, parsed on a delim.
        _jids: TWidestringlist;     // jids of the people in this grp.

        _grps: TWidestringlist;     // nested grps inside this one
        _parent: TJabberGroup;      // our parent grp

        function getNestLevel: integer;
        function getTotal: integer;
        function indexOfJid(jid: TJabberID): integer;
        function getNestIndex(idx: integer): Widestring;

        procedure incOnline(val: integer);

        procedure setPresence(i: integer; p: TJabberPres); overload;
    public
        Data: TObject;              // Linked to a GUI element for this grp.

        // New stuff for groups
        Action: Widestring;
        KeepEmpty: boolean;         // Keep around this empty group?
        SortPriority: integer;      // pri for this group
        ShowPresence: boolean;      // show presence based counts
        DragTarget: boolean;        // Can items be dragged INTO this group?
        DragSource: boolean;        // Can items be dragged FROM this group?
        AutoExpand: boolean;

        constructor create(name: Widestring);
        destructor Destroy; override;

        function getText(): Widestring; override;

        // Normal group stuff
        procedure AddJid(jid: Widestring); overload;
        procedure AddJid(jid: TJabberID); overload;
        procedure removeJid(jid: Widestring); overload;
        procedure removeJid(jid: TJabberID); overload;

        function inGroup(jid: Widestring): boolean; overload;
        function inGroup(jid: TJabberID): boolean; overload;
        function isEmpty(): boolean;

        // nested grp stuff
        function getGroup(name: Widestring): TJabberGroup;
        procedure addGroup(child: TJabberGroup);
        procedure removeGroup(child: TJabberGroup);

        procedure setPresence(jid: TJabberID; p: TJabberPres); overload;
        procedure setPresence(jid: Widestring; p: TJabberPres); overload;

        procedure getRosterItems(l: TList; online: boolean; observer: boolean = true);

        property NestLevel: integer read getNestLevel;
        property Online: integer read _online;
        property Total: integer read getTotal;

        property FullName: Widestring read _full;
        property Parts[index: integer]: Widestring read getNestIndex;
        property Parent: TJabberGroup read _parent;
    end;

    TRosterItemAction = (RIA_NONE, RIA_OFFLINE, RIA_ONLINE);

    TJabberRosterItem = class(TJabberNodeItem)
    private
        _jid: TJabberID;
        _data: TObject;
        _grps: TWidestringlist;
        _dirty_grps: TWidestringlist;

        _tag: TXMLTag;

        // image handling stuff
        _img_prefix: Widestring;
        _last_show: Widestring;

        function getGroupIndex(idx: integer): Widestring;
        function getDirtyIndex(idx: integer): Widestring;
        procedure setupDirty();
        procedure setTag(new_tag: TXMLTag);
        procedure setImagePrefix(prefix: Widestring);

    public
        // new bits for roster items
        IsContact: boolean;
        Text: Widestring;
        Status: Widestring;
        Tooltip: Widestring;
        Action: Widestring;     // dbl-click action
        ImageIndex: integer;
        Removed: boolean;
        InlineEdit: boolean;
        CustomContext: TTntPopupMenu;
        IsNative: boolean;
        CanOffline: boolean;

        constructor Create(id: Widestring); overload;
        destructor Destroy; override;

        function IsOnline: boolean;
        function getText(): Widestring; override;

        // backwards compatibility for <item> tag lookups
        function Ask(): Widestring;
        function Subscription(): Widestring;

        procedure Remove;
        procedure Update;

        // Presence based image stuff
        procedure setPresenceImage(show: Widestring);
        function getPresenceImage(show: Widestring): integer;

        // Group management stuff
        function IsInGroup(grp: Widestring): boolean;
        function GroupCount: integer;
        function DirtyGroupCount: integer;
        function AreGroupsDirty: boolean;

        procedure ClearGroups();
        procedure SetCleanGroups();
        procedure AddGroup(new_grp: Widestring);
        procedure DelGroup(old_grp: Widestring);

        procedure AssignGroups(new_list: TWidestringlist);

        property Group[index: integer]: Widestring read getGroupIndex;
        property DirtyGroup[index: integer]: Widestring read getDirtyIndex;

        // Properties
        property Jid: TJabberID read _jid;
        property Data: TObject read _data write _data;

        property Tag: TxMLTag read _tag write setTag;
        property ImagePrefix: Widestring read _img_prefix write setImagePrefix;
    end;

    function NodeTypeLevel(node: TObject): integer;

implementation
uses
    RosterImages, JabberConst, Session, XMLUtils;

const
    DEFAULT_SORT = 100;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
constructor TJabberGroup.Create(name: Widestring);
var
    slen, l, s, i: integer;
    sep, p: Widestring;
begin
    //
    _online := 0;
    _full := name;
    _parts := TWidestringlist.Create();
    _parts.CaseSensitive := true;
    _jids := TWidestringlist.Create();

    _grps := TWidestringlist.Create();
    _grps.CaseSensitive := true;

    Data := nil;
    AutoExpand := true;
    DragSource := true;
    DragTarget := true;
    ShowPresence := true;
    SortPriority := DEFAULT_SORT;

    // actually parse for nested groups
    if ((MainSession <> nil) and
        MainSession.prefs.getBool('nested_groups') and
        MainSession.prefs.getBool('branding_nested_subgroup')) then begin
        l := Length(name);
        s := 1;
        sep := MainSession.prefs.getString('group_seperator');
        slen := Length(sep);
        
        for i := 1 to Length(name) do begin
            if (Copy(name, i, slen) = sep) then begin
                p := Copy(name, s, (i - s));
                _parts.Add(p);
                s := i + slen;
            end;
        end;

        // This should take care of the remainder.
        if (s <= l) then begin
            p := Copy(name, s, l - s + slen);
            _parts.Add(p);
        end;
    end
    else
        _parts.Add(name);

end;

{---------------------------------------}
destructor TJabberGroup.Destroy();
begin
    FreeAndNil(_parts);
    FreeAndNil(_jids);
    FreeAndNil(_grps);
end;

{---------------------------------------}
function TJabberGroup.getTotal: integer;
var
    i, ret: integer;
begin
    ret := _jids.Count;
    for i := 0 to _grps.Count - 1 do
        ret := ret + TJabberGroup(_grps.Objects[i]).Total;
    Result := ret;
end;

{---------------------------------------}
function TJabberGroup.isEmpty(): boolean;
begin
    Result := ((_jids.Count = 0) and (_grps.Count = 0));
end;

{---------------------------------------}
procedure TJabberGroup.incOnline(val: integer);
begin
    _online := _online + val;
    if (_parent <> nil) then
        _parent.incOnline(val);
end;

{---------------------------------------}
function TJabberGroup.getNestIndex(idx: integer): Widestring;
begin
    if (idx >= _parts.Count) then
        Result := ''
    else
        Result := _parts[idx];
end;

{---------------------------------------}
function TJabberGroup.getNestLevel: integer;
begin
    Result := _parts.Count;
end;

{---------------------------------------}
function TJabberGroup.GetText(): Widestring;
begin
    Result := _parts[_parts.Count - 1];
end;

{---------------------------------------}
function TJabberGroup.indexOfJid(jid: TJabberID): integer;
begin
    Result := _jids.IndexOf(jid.jid);
    if (Result = -1) then
        Result := _jids.IndexOf(jid.full);
end;

{---------------------------------------}
procedure TJabberGroup.AddJid(jid: Widestring);
begin
    if (_jids.indexOf(jid) = -1) then
        _jids.Add(jid);
end;

{---------------------------------------}
procedure TJabberGroup.AddJid(jid: TJabberID);
begin
    if (_jids.indexOf(jid.jid) = -1) then
        _jids.Add(jid.jid);
end;

{---------------------------------------}
procedure TJabberGroup.removeJid(jid: Widestring);
var
    i: integer;
begin
    i := _jids.IndexOf(jid);
    if (i >= 0) then begin
        if (_jids.Objects[i] <> nil) then incOnline(-1);
        _jids.Delete(i);
    end;
end;

{---------------------------------------}
procedure TJabberGroup.removeJid(jid: TJabberID);
var
    i: integer;
begin
    i := indexOfJid(jid);
    if (i >= 0) then begin
        if (_jids.Objects[i] <> nil) then incOnline(-1);
        _jids.Delete(i);
    end;
end;

{---------------------------------------}
function TJabberGroup.inGroup(jid: Widestring): boolean;
begin
    Result := (_jids.indexOf(jid) >= 0);
end;

{---------------------------------------}
function TJabberGroup.inGroup(jid: TJabberID): boolean;
begin
    Result := (indexOfJid(jid) >= 0);
end;

{---------------------------------------}
procedure TJabberGroup.setPresence(jid: TJabberID; p: TJabberPres);
var
    i: integer;
begin
    i := indexOfJid(jid);
    setPresence(i, p);
end;

{---------------------------------------}
procedure TJabberGroup.setPresence(jid: Widestring; p: TJabberPres);
var
    i: integer;
begin
    i := _jids.indexOf(jid);
    setPresence(i, p);
end;

{---------------------------------------}
procedure TJabberGroup.setPresence(i: integer; p: TJabberPres);
var
    o: TObject;
begin
    if (i = -1) then exit;

    // o is the old object, p is the new one.
    // if o != NULL, and p == NULL, then the user went offline.
    // if o == NULL, and p != NULL, then the user came online.

    o := TObject(_jids.Objects[i]);
    if (o <> nil) and ((p = nil) or (p.PresType = 'unavailable')) then
        incOnline(-1)
    else if (o = nil) and (p <> nil) then
        incOnline(+1);

    if ((p <> nil) and (p.PresType = 'unavailable')) then
        _jids.Objects[i] := nil
    else
        _jids.Objects[i] := p;
end;

{---------------------------------------}
procedure TJabberGroup.getRosterItems(l: TList; online: boolean; observer: boolean = true);
var
    ri: TJabberRosterItem;
    i: integer;
begin
    for i := 0 to _jids.Count - 1 do begin
        ri := MainSession.Roster.Find(_jids[i]);

        if (ri <> nil) and (not ((not observer) and (ri.Subscription() <> 'both'))) then
            if ((online = false) or (_jids.Objects[i] <> nil)) then
                l.Add(ri);
    end;

    // add all contacts in my sub-grps
    for i := 0 to _grps.Count - 1 do
        TJabberGroup(_grps.Objects[i]).getRosterItems(l, online, observer);

end;

{---------------------------------------}
procedure TJabberGroup.AddGroup(child: TJabberGroup);
var
    i: integer;
begin
    i := _grps.indexOf(child.getText());
    if (i = -1) then
        _grps.AddObject(child.fullname, child)
    else
        _grps.Objects[i] := child;

    child._parent := Self;
end;

{---------------------------------------}
function TJabberGroup.getGroup(name: Widestring): TJabberGroup;
var
    i: integer;
begin
    i := _grps.indexOf(name);
    if (i = -1) then
        Result := nil
    else
        Result := TJabberGroup(_grps.Objects[i]);
end;

{---------------------------------------}
procedure TJabberGroup.removeGroup(child: TJabberGroup);
var
    i: integer;
begin
    i := _grps.indexOf(child.getText());
    if (i >= 0) then
        _grps.Delete(i);
end;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
constructor TJabberRosterItem.Create(id: Widestring);
begin
    inherited Create();
    _grps := TWideStringList.Create;
    _grps.CaseSensitive := true;
    _jid := TJabberID.Create(id);
    _data := nil;
    _dirty_grps := nil;
    _last_show := 'offline';

    IsNative := true;
    CanOffline := true;
    InlineEdit := false;
    Removed := false;                             

    // initialize to default icons
    // TODO: get default icon set prefix from prefs
    setImagePrefix('');
end;

{---------------------------------------}
destructor TJabberRosterItem.Destroy;
begin
    if (_dirty_grps <> nil) then
        FreeAndNil(_dirty_grps);

    if (_data <> nil) then
        TObject(_data).Free();

    FreeAndNil(_grps);
    FreeAndNil(_jid);
    FreeAndNil(_tag);

    inherited Destroy;
end;

{---------------------------------------}
function TJabberRosterItem.getText(): Widestring;
begin
    Result := Text;
end;

{---------------------------------------}
procedure TJabberRosterItem.Update;
var
    update: TXMLTag;
begin
    // this get fired by the GUI layers when the item has changed
    update := TXMLTag.Create('update');
    update.AddTag(TXMLTag.Create(tag));
    MainSession.FireEvent('/roster/item', update, self);
    update.Free();
end;

{---------------------------------------}
procedure TJabberRosterItem.remove;
var
    remove: TXMLTag;
begin
    // this get fired by the GUI layers when the item has been removed
    // remove this roster item from my roster;
    remove := TXMLTag.Create('remove');
    remove.AddTag(TXMLTag.Create(tag));
    MainSession.FireEvent('/roster/remove', remove, self);
    remove.Free();
end;

{---------------------------------------}
function TJabberRosterItem.IsOnline: boolean;
begin
    Result := (MainSession.ppdb.FindPres(Self.jid.jid, '') <> nil);
end;

{---------------------------------------}
function TJabberRosterItem.Ask(): Widestring;
begin
    Result := Tag.GetAttribute('ask');
end;

{---------------------------------------}
function TJabberRosterItem.Subscription(): Widestring;
begin
    Result := Tag.GetAttribute('subscription');
    if (Result = 'none') then Result := '';
end;

{---------------------------------------}
procedure TJabberRosterItem.setupDirty();
var
    i: integer;
begin
    if (_dirty_grps <> nil) then exit;

    _dirty_grps := TWidestringlist.Create();
    for i := 0 to _grps.count - 1 do
        _dirty_grps.Add(_grps[i]);
end;

{---------------------------------------}
procedure TJabberRosterItem.SetCleanGroups();
var
    i: integer;
begin
    if (_dirty_grps = nil) then exit;

    _grps.Clear();
    for i := 0 to _dirty_grps.Count - 1 do
        _grps.Add(_dirty_grps[i]);
    FreeAndNil(_dirty_grps);
end;

{---------------------------------------}
procedure TJabberRosterItem.setTag(new_tag: TXMLTag);
begin
    if (_tag = new_tag) then
        exit;
    if (_tag <> nil) then
        _tag.Free();
    _tag := new_tag;
end;

{---------------------------------------}
procedure TJabberRosterItem.setImagePrefix(prefix: Widestring);
begin
    // set the prefix and upate imageindex
    _img_prefix := prefix;
    setPresenceImage(_last_show);
end;

{---------------------------------------}
procedure TJabberRosterItem.setPresenceImage(show: Widestring);
begin
    _last_show := show;
    ImageIndex := getPresenceImage(show);
end;

function getPresenceImageFromPrefix(show: Widestring; prefix: widestring): integer;
begin
    if (show = 'offline') then
        Result := RosterTreeImages.Find(prefix + 'offline')
    else if (show = 'away') then
        Result := RosterTreeImages.Find(prefix + 'away')
    else if (show = 'xa') then
        Result := RosterTreeImages.Find(prefix + 'xa')
    else if (show = 'dnd') then
        Result := RosterTreeImages.Find(prefix + 'dnd')
    else if (show = 'chat') then
        Result := RosterTreeImages.Find(prefix + 'chat')
    else if (show = 'pending') then
        Result := RosterTreeImages.Find(prefix + 'pending')
    else if (show = 'online_blocked') then
        Result := RosterTreeImages.Find(prefix + 'online_blocked')
    else if (show = 'offline_blocked') then
        Result := RosterTreeImages.Find(prefix + 'offline_blocked')
    else if (show = 'observer') then
        Result := RosterTreeImages.Find(prefix + 'observer')
    else
        Result := RosterTreeImages.Find(prefix + 'available');

    if ((Result = -1) and (prefix <> '')) then
        Result := getPresenceImageFromPrefix(show, ''); //try again with no prefix
end;
{---------------------------------------}
function TJabberRosterItem.getPresenceImage(show: Widestring): integer;
begin
    Result :=  getPresenceImageFromPrefix(show, _img_prefix);
end;

{---------------------------------------}
function TJabberRosterItem.IsInGroup(grp: Widestring): boolean;
begin
    Result := (_grps.IndexOf(grp) >= 0);
end;

{---------------------------------------}
function TJabberRosterItem.GroupCount: integer;
begin
    Result := _grps.Count;
end;

{---------------------------------------}
function TJabberRosterItem.DirtyGroupCount: integer;
begin
    if (_dirty_grps = nil) then
        Result := 0
    else
        Result := _dirty_grps.Count
end;

{---------------------------------------}
procedure TJabberRosterItem.ClearGroups;
begin
    setupDirty();
    _dirty_grps.Clear();
end;

{---------------------------------------}
procedure TJabberRosterItem.AddGroup(new_grp: Widestring);
begin
    setupDirty();
    _dirty_grps.Add(new_grp);
end;

{---------------------------------------}
procedure TJabberRosterItem.DelGroup(old_grp: Widestring);
var
    idx: integer;
begin
    setupDirty();
    idx := _dirty_grps.IndexOf(old_grp);
    if (idx >= 0) then
        _dirty_grps.Delete(idx);
end;

{---------------------------------------}
function TJabberRosterItem.getGroupIndex(idx: integer): Widestring;
begin
    if ((idx >= 0) and (idx < _grps.Count)) then
        Result := _grps[idx]
    else
        Result := '';
end;

{---------------------------------------}
function TJabberRosterItem.getDirtyIndex(idx: integer): Widestring;
begin
    if (_dirty_grps = nil) then
        Result := ''
    else if ((idx >= 0) and (idx < _dirty_grps.Count)) then
        Result := _dirty_grps[idx]
    else
        Result := '';
end;

{---------------------------------------}
function TJabberRosterItem.AreGroupsDirty: boolean;
var
    i: integer;
begin
    if (_dirty_grps = nil) then begin
        Result := false;
        exit;
    end;

    if (_dirty_grps.Count <> _grps.Count) then begin
        Result := true;
        exit;
    end;

    // if we get this far, then the 2 lists have the same # of items
    // make sure all items are in both lists
    for i := 0 to _grps.Count - 1 do begin
        if (_dirty_grps.IndexOf(_grps[i]) = -1) then begin
            Result := true;
            exit;
        end;
    end;


    // if they are the same, kill _dirty_grps
    FreeAndNil(_dirty_grps);

    Result := false;
end;

{---------------------------------------}
procedure TJabberRosterItem.AssignGroups(new_list: TWidestringlist);
var
    i: integer;
begin
    new_list.Clear();
    for i := 0 to _grps.Count - 1 do
        new_list.Add(_grps[i]);
end;

{---------------------------------------}
function NodeTypeLevel(node: TObject): integer;
var
    ret : integer;
begin
    ret := 0;
    if (node is TJabberNodeItem) then begin
        if (node is TJabberRosterItem) then
            ret := 1
        else if (node is TJabberGroup) then
            ret := 2
        else // in case of future expansion
            ret := 5;
    end;
    NodeTypeLevel := ret;
end;

end.
