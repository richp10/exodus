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
unit Bookmarks;


interface
uses
    {$ifdef Exodus}
    TntClasses,
    {$endif}
    Menus, TntMenus, 
    NodeItem, Signals, Unicode, XMLTag, SysUtils, Classes;

type

    TBookmarkManager = class(TWidestringlist)
    private
        _xdb_bm: boolean;
        _js: TObject;
        _menu: TTntPopupMenu;
    published
        procedure SessionCallback(event: string; tag: TXMLTag);
        procedure UpdateCallback(event: string; tag: TXMLTag; ri: TJabberRosterItem);
        procedure bmCallback(event: string; tag: TXMLTag);

        procedure MenuClick(Sender: TObject);

    public
        constructor Create();
        destructor  Destroy(); override;

        procedure setSession(js: TObject);
        procedure Fetch();

        procedure SaveBookmarks();

        procedure AddBookmark(sjid, name, nick: Widestring; auto_join, use_reg_nick: boolean);
        procedure RemoveBookmark(sjid: Widestring);
        function  FindBookmark(sjid: Widestring): TXMLTag;
        procedure parseItem(tag: TXMLTag; ri: TJabberRosterItem);

    end;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
implementation
uses
    XMLUtils, 
    RosterImages, GnuGetText, Session, Roster, JabberConst, IQ, JabberID;

{---------------------------------------}
constructor TBookmarkManager.Create();
var
    mi: TTntMenuItem;
begin
    //
    inherited Create();
    _xdb_bm := true;
    _readyTag := nil;
    
    _menu := TTntPopupMenu.Create(nil);
    _menu.Name := 'mnuBookmarksContext';
    _menu.AutoHotkeys := maManual;
    _menu.AutoPopup := true;

    mi := TTntMenuItem.Create(_menu);
    mi.Name := 'mnuJoinRoom';
    mi.Caption := _('Join Conference Room');
    mi.OnClick := Self.MenuClick;
    _menu.Items.Add(mi);

    mi := TTntMenuItem.Create(_menu);
    mi.Name := 'mnuRemoveRoom';
    mi.Caption := _('Remove');
    mi.OnClick := Self.MenuClick;
    _menu.Items.Add(mi);

    mi := TTntMenuItem.Create(_menu);
    mi.Name := 'mnuRenameRoom';
    mi.Caption := _('Rename...');
    mi.OnClick := Self.MenuClick;
    _menu.Items.Add(mi);

    mi := TTntMenuItem.Create(_menu);
    mi.Name := 'mnuProperties';
    mi.Caption := _('Properties...');
    mi.OnClick := Self.MenuClick;
    _menu.Items.Add(mi);
end;

{---------------------------------------}
destructor TBookmarkManager.Destroy();
begin
    inherited Destroy();
end;

{---------------------------------------}
procedure TBookmarkManager.MenuClick(Sender: TObject);
var
    ri: TJabberRosterItem;
    mi: TTntMenuItem;
begin
    if (Sender is TTntMenuItem) then
        mi := TTntMenuItem(Sender)
    else
        exit;

    ri := MainSession.roster.ActiveItem;
    if (ri = nil) then exit;

    if (mi.Name = 'mnuJoinRoom') then
        MainSession.FireEvent('/session/gui/conference', ri.tag)
    else if (mi.Name = 'mnuRemoveRoom') then
        RemoveBookmark(ri.Jid.jid)
    else if (mi.Name = 'mnuProperties') then
        MainSession.FireEvent('/session/gui/conference-props', ri.tag)
    else if (mi.Name = 'mnuRenameRoom') then
        MainSession.FireEvent('/session/gui/conference-props-rename', ri.tag);
end;

{---------------------------------------}
procedure TBookmarkManager.setSession(js: TObject);
begin
    _js := js;
    with TJabberSession(js) do begin
        RegisterCallback(Self.SessionCallback, '/session');
        RegisterCallback(Self.UpdateCallback,
            '/roster/update/item[@xmlns="' + XMLNS_BM + '"]');
        //XXX: Register for /roster/remove/item@[xmlns=XMLNS_BM] too
    end;
end;

{---------------------------------------}
procedure TBookmarkManager.UpdateCallback(event: string; tag: TXMLTag; ri: TJabberRosterItem);
begin
    ri.tag.setAttribute('name', ri.Text);
    SaveBookmarks();
end;

{---------------------------------------}
procedure TBookmarkManager.SessionCallback(event: string; tag: TXMLTag);
begin
    if (event = DEPENDANCY_READY_SESSION_EVENT) then begin
        _readyTag := tag;
        Fetch();
    end
    else if (event = '/session/disconnected') then begin
        // note that the tags will be cleaned up by the roster items.
        Clear();
        _readyTag := nil;
    end;
end;

{---------------------------------------}
procedure TBookmarkManager.Fetch();
var
    s: TJabberSession;
    iq: TJabberIQ;
    go: TJabberGroup;
begin
    // setup the Bookmarks group first
    go := MainSession.roster.getGroup(_('Bookmarks'));
    if (go = nil) then
        go := MainSession.roster.addGroup(_('Bookmarks'));
    go.SortPriority := 50;
    go.ShowPresence := false;
    go.KeepEmpty := false;
    go.DragTarget := false;
    go.DragSource := false;

    s := TJabberSession(_js);
    iq := TJabberIQ.Create(s, s.generateID(), bmCallback, 180);
    with iq do begin
        iqType := 'get';
        toJid := '';
        Namespace := XMLNS_PRIVATE;
        with qtag.AddTag('storage') do
            setAttribute('xmlns', XMLNS_BM);
        Send();
    end;
end;

{---------------------------------------}
procedure TBookmarkManager.parseItem(tag: TXMLTag; ri: TJabberRosterItem);
var
    jid: TJabberID;
    tstr : WideString;
begin
    jid := TJabberID.Create(tag.GetAttribute('jid'));
    ri.IsContact := false;
    tstr := tag.getAttribute('name');
    //hi, hack here. Some clients are sendig the node protions of jids as names
    //without unescaping special characters first. Play with the name a bit
    //and see if it is a jid node.
    if (tstr = jid.user) then
        tstr := jid.userDisplay;
    ri.Text := tstr;

    ri.Status := '';
    ri.Tooltip := jid.getDisplayJID();
    ri.Action := '/session/gui/conference';
    ri.Tag := tag;
    tag.setAttribute('xmlns', XMLNS_BM);

    ri.AddGroup(_('Bookmarks'));
    ri.SetCleanGroups();

    ri.ImageIndex := RosterTreeImages.Find('conference');
    ri.InlineEdit := false;

    // setup right click opts for bookmarks
    ri.CustomContext := _menu;

    jid.Free();
end;

{---------------------------------------}
procedure TBookmarkManager.bmCallback(event: string; tag: TXMLTag);
var
    bms: TXMLTagList;
    i, idx: integer;
    bm, p, stag: TXMLTag;
    jid: Widestring;
    ri: TJabberRosterItem;
begin
    // get all of the bm's
    bms := nil;
    if ((event = 'xml') and (tag.getAttribute('type') = 'result')) then begin
        // we got a response..
        {
        <iq type="set" id="jcl_4">
            <query xmlns="jabber:iq:private">
                <storage xmlns="storage:bookmarks">
                    <conference name='Council of Oberon'
                                  autojoin='true'
                                  jid='council@conference.underhill.org'>
                        <nick>Puck</nick>
                        <password>titania</password>
                    </conference>
                </storage>
        </query></iq>
        }
        stag := tag.QueryXPTag('/iq/query/storage');
        if (stag <> nil) then
            bms := stag.ChildTags();
    end
    else if ((event = 'xml') and (tag.getAttribute('type') = 'error')) then begin
        // XDB prolly doesn't support remote storage. Get bm's from prefs
        _xdb_bm := false;
        p := MainSession.Prefs.LoadBookmarks();
        if (p <> nil) then
            bms := p.ChildTags();
    end;

    if (bms <> nil) then begin
        for i := 0 to bms.count -1  do begin
            if (bms[i].Name = 'conference') then begin
                jid := WideLowerCase(bms[i].GetAttribute('jid'));
                idx := Self.Indexof(jid);
                if (idx >= 0) then begin
                    // remove the existing bm
                    Self.RemoveBookmark(jid);
                end;
                bm := TXMLTag.Create(bms[i]);
                Self.AddObject(jid, bm);

                ri := TJabberRosterItem.Create(jid);
                parseItem(bm, ri);
                MainSession.Roster.AddItem(jid, ri);

                // Fire an event to join the room
                if (bm.GetAttribute('autojoin') = 'true') then
                    MainSession.FireEvent('/session/gui/conference', bm);
            end;
        end;

        bms.Free();
    end;
    if (_readyTag <> nil) then
        Mainsession.fireEvent(DEPENDANCY_READY_EVENT + DEPENDANCY_BOOKMARKS, _readyTag);
    _readyTag := nil;
end;

{---------------------------------------}
procedure TBookmarkManager.SaveBookmarks();
var
    s: TJabberSession;
    stag, iq: TXMLTag;
    i: integer;
begin
    // save bookmarks to jabber:iq:private
    s := TJabberSession(_js);

    if (_xdb_bm) then begin
        iq := TXMLTag.Create('iq');
        with iq do begin
            setAttribute('type', 'set');
            setAttribute('id', s.generateID());
            with AddTag('query') do begin
                setAttribute('xmlns', XMLNS_PRIVATE);
                stag := AddTag('storage');
                stag.setAttribute('xmlns', XMLNS_BM);
                for i := 0 to Count - 1 do
                    stag.AddTag(TXMLTag.Create(TXMLTag(Objects[i])))
            end;
        end;
        s.SendTag(iq);
    end
    else begin
        // bookmarks from prefs
        stag := TXMLTag.Create('local-bookmarks');
        for i := 0 to Count - 1 do
            stag.AddTag(TXMLTag.Create(TXMLTag(Objects[i])));
        s.Prefs.SaveBookmarks(stag);
    end;
end;

{---------------------------------------}
procedure TBookmarkManager.AddBookmark(sjid, name, nick: Widestring; auto_join, use_reg_nick: boolean);
var
    bm: TXMLTag;
    ri: TJabberRosterItem;
    i:  Integer;
begin
    {
    <conference name='Council of Oberon'
                  autojoin='true'
                  jid='council@conference.underhill.org'>
        <nick>Puck</nick>
        <password>titania</password>
    </conference>
    }
    // Only need one bookmark to a given item
    if (self.Find(sjid, i)) then
        Exit;

    bm := TXMLTag.Create('conference');
    bm.setAttribute('xmlns', XMLNS_BM);
    bm.setAttribute('jid', sjid);
    bm.setAttribute('name', name);
    if (auto_join) then
        bm.setAttribute('autojoin', 'true')
    else
        bm.setAttribute('autojoin', 'false');

    if (use_reg_nick) then
        bm.setAttribute('reg_nick', 'true')
    else
        bm.setAttribute('reg_nick', 'false');

    bm.AddBasicTag('nick', nick);

    AddObject(sjid, bm);
    ri := TJabberRosterItem.Create(sjid);
    parseItem(bm, ri);
    TJabberSession(_js).roster.AddItem(sjid, ri);

    SaveBookmarks();
end;

{---------------------------------------}
procedure TBookmarkManager.RemoveBookmark(sjid: Widestring);
var
    remove, bm: TXMLTag;
    i: integer;
    ri: TJabberRosterItem;
begin
    // remove a bm from the list
    i := IndexOf(sjid);
    if ((i >= 0) and (i < Count)) then begin
        ri := TJabberSession(_js).roster.Find(sjid);

        bm := TXMLTag(Objects[i]);
        remove := TXMLTag.Create('remove');
        remove.AddTag(TXMLTag.Create(bm));

        TJabberSession(_js).FireEvent('/roster/remove', remove, ri);
        Objects[i] := nil;
        Delete(i);
        remove.Free();
        
        SaveBookmarks();
    end;
end;

{---------------------------------------}
function TBookmarkManager.FindBookmark(sjid: Widestring): TXMLTag;
var
    i: integer;
begin
    i := IndexOf(sjid);
    if (i >= 0) then
        Result := TXMLTag(Objects[i])
    else
        Result := nil;
end;


end.
