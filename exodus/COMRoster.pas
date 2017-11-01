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
unit COMRoster;


{$WARN SYMBOL_PLATFORM OFF}

interface

uses
    Unicode, TntClasses, Menus, TntMenus,
    ComObj, ActiveX, Exodus_TLB, StdVcl, Classes, ExActions;

type

  TExodusRoster = class(TAutoObject, IExodusRoster, IExodusRoster2)
  protected
    { Protected declarations }
    function addItem(const JabberID: WideString): IExodusRosterItem; safecall;
    function Find(const JabberID: WideString): IExodusRosterItem; safecall;
    procedure Fetch; safecall;
    function Item(Index: Integer): IExodusRosterItem; safecall;
    function Count: Integer; safecall;
    function addGroup(const grp: WideString): IExodusRosterGroup; safecall;
    function Get_GroupsCount: Integer; safecall;
    function getGroup(const grp: WideString): IExodusRosterGroup; safecall;
    function Groups(Index: Integer): IExodusRosterGroup; safecall;
    function Items(Index: Integer): IExodusRosterItem; safecall;
    procedure removeGroup(const grp: IExodusRosterGroup); safecall;
    procedure removeItem(const Item: IExodusRosterItem); safecall;
    function AddContextMenuItem(const menuID, caption: WideString;
      const menuListener: IExodusMenuListener): WideString; safecall;
    function addContextMenu(const id: WideString): WordBool; safecall;
    procedure removeContextMenu(const id: WideString); safecall;
    procedure removeContextMenuItem(const menu_id, item_id: WideString);
      safecall;
    function Subscribe(const JabberID, nickname, Group: WideString;
      Subscribe: WordBool): IExodusRosterItem; safecall;

    // IExodusRoster2
    procedure EnableContextMenuItem(const menuID: WideString; const itemID: WideString;
                                    enable: WordBool); safecall;
    procedure ShowContextMenuItem(const menuID: WideString; const itemID: WideString;
                                  show: WordBool); safecall;
    procedure SetContextMenuItemCaption(const menuID: WideString; const itemID: WideString; 
                                        const caption: WideString); safecall;
    function GetContextMenuItemCaption(const menuID: WideString; const itemID: WideString): WideString; safecall;

  private
    _predefined_menus: TWidestringlist;
    _menus: TWidestringlist;
    _items: TWidestringList;
    _actions: TWidestringList;

    function mapMenuID(menuID: Widestring; var itemtype: Widestring): Boolean;
    procedure MenuClick(Sender: TObject);
  public
    constructor Create();
    destructor Destroy(); override;

    function findContextMenu(id: Widestring): TTntPopupMenu;
    procedure AddPredefinedMenu(name: Widestring; menu: TTntPopupMenu);
    procedure RemovePredefinedMenu(name: Widestring; menu: TTntPopupMenu);

  end;

  TExMenuListenerAction = class(TExBaseAction)
  private
    _listener: IExodusMenuListener;

  public
    constructor Create(name, caption: Widestring; listener: IExodusMenuListener);

    procedure execute(const items: IExodusItemList); override;
  end;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
implementation

uses
    XMLTag, StrUtils, SysUtils, XMLUtils, COMRosterGroup,
    COMRosterItem, ContactController, JabberID, Session,
    Jabber1, ComServ,RosterForm, ExActionCtrl;

{---------------------------------------}
constructor TExodusRoster.Create();
begin
    _predefined_menus := TWidestringlist.Create();
    _menus := TWidestringlist.Create();
    _items := TWidestringList.Create();
    _actions := TWidestringList.Create();
end;

{---------------------------------------}
destructor TExodusRoster.Destroy();
begin
    ClearStringListObjects(_predefined_menus);
    _predefined_menus.Clear();
    _predefined_menus.Free();
    
//JJF causing a GPF when clearing menu objects,
//commenting out for now
//    ClearStringListObjects(_menus);
    _menus.Clear();
    _menus.Free();

    ClearStringListObjects(_items);
    _items.Clear();
    _items.Free();

    ClearStringListObjects(_actions);
    _actions.Clear();
    _actions.Free();
end;

{---------------------------------------}
procedure TExodusRoster.AddPredefinedMenu(name: Widestring; menu: TTntPopupMenu);
var
    idx: integer;
begin
    // used to add the GUI defined menus from other parts of Exodus
    if (menu = nil) or
       (name = '') then exit;

    idx := _menus.IndexOf(name);
    if (idx >= 0) then exit;

    _predefined_menus.Add(name);
    _menus.AddObject(name, menu);
end;

{---------------------------------------}
procedure TExodusRoster.RemovePredefinedMenu(name: Widestring; menu: TTntPopupMenu);
var
    idx, predefined_idx: integer;
    i: Integer;
    temp_stringlist: TWidestringList;
    temp_string: string;
begin
    if (name = '') then exit;

    idx := _menus.IndexOf(name);
    if (idx >= 0) then begin
        // exists
        predefined_idx := _predefined_menus.IndexOf(name);
        if (predefined_idx >=0) then begin
            // is a predefined so we can remove

            // Make sure there are no items left on menu
            // Not doing this causes a crash if item is left on predefined
            // popup menu.
            temp_stringlist := TWidestringList.Create();
            for i := 0 to menu.items.Count - 1 do begin
                temp_string := LeftStr(menu.Items[i].Name, Length('pluginContext_item'));
                if (temp_string = 'pluginContext_item') then
                    temp_stringlist.Add(menu.Items[i].Name);
            end;
            if (temp_stringlist.Count > 0) then begin
                for i := 0 to temp_stringlist.Count - 1 do begin
                    Self.removeContextMenuItem(name, temp_stringlist.Strings[i]);
                end;
            end;
            temp_stringlist.Free();

            // do actual remove
            _predefined_menus.Delete(predefined_idx);
            _menus.Delete(idx);
        end;
    end;
end;

{---------------------------------------}
function TExodusRoster.addItem(
  const JabberID: WideString): IExodusRosterItem;
begin
    Result := Subscribe(JabberID, '', '', True);
end;

{---------------------------------------}
function TExodusRoster.Subscribe(const JabberID, nickname,
  Group: WideString; Subscribe: WordBool): IExodusRosterItem;
var
    item: IExodusItem;
begin
    item := MainSession.roster.AddItem(JabberID, nickname, Group, Subscribe);
    Result := TExodusRosterItem.Create(item);
end;

{---------------------------------------}
function TExodusRoster.Find(const JabberID: WideString): IExodusRosterItem;
var
    item: IExodusItem;
begin
    item := MainSession.ItemController.GetItem(JabberID);
    if (item <> nil) then
        result := TExodusRosterItem.Create(item)
    else
        Result := nil;
end;

{---------------------------------------}
procedure TExodusRoster.Fetch;
begin
    { TODO : Roster refactor }
    //MainSession.roster.Fetch();
end;

{---------------------------------------}
function TExodusRoster.Item(Index: Integer): IExodusRosterItem;
var
    contacts: IExodusItemList;
    item: IExodusItem;
begin
    contacts := MainSession.ItemController.GetItemsByType('contact');

    if (Index >= 0) and (Index < contacts.Count) then
        item := contacts.Item[index]
    else
        item := nil;

    if (item <> nil) then
        Result := TExodusRosterItem.Create(item)
    else
        Result := nil;
end;

{---------------------------------------}
function TExodusRoster.Count: Integer;
begin
   Result := MainSession.ItemController.GetItemsByType('contact').Count;
end;

{---------------------------------------}
function TExodusRoster.addGroup(const grp: WideString): IExodusRosterGroup;
var
    item: IExodusItem;
begin
    item := MainSession.ItemController.AddGroup(grp);
    Result := TExodusRosterGroup.Create(item);
end;

{---------------------------------------}
function TExodusRoster.Get_GroupsCount: Integer;
begin
    Result := MainSession.ItemController.GetItemsByType('group').Count;
end;

{---------------------------------------}
function TExodusRoster.getGroup(const grp: WideString): IExodusRosterGroup;
var
    item: IExodusItem;
begin
    item := MainSession.ItemController.GetItem(grp);
    if (item <> nil) and (item.Type_ = 'group') then
        Result := TExodusRosterGroup(item)
    else
        Result := nil;
end;

{---------------------------------------}
function TExodusRoster.Groups(Index: Integer): IExodusRosterGroup;
var
    items: IExodusItemList;
begin
    items := MainSession.ItemController.GetItemsByType('group');
    if (Index >= 0) and (Index < items.Count) then
        Result := TExodusRosterGroup.Create(items.Item[index])
    else
        Result := nil;
end;

{---------------------------------------}
function TExodusRoster.Items(Index: Integer): IExodusRosterItem;
begin
    Result := Item(Index);
end;

{---------------------------------------}
procedure TExodusRoster.removeGroup(const grp: IExodusRosterGroup);
var
    ctrl: IExodusItemController;
    found: IExodusItem;
begin
    ctrl := MainSession.ItemController;
    found := ctrl.GetItem(grp.FullName);
    if (found <> nil) and (found.Type_ = 'group') then
        ctrl.RemoveItem(found.UID);
end;

{---------------------------------------}
procedure TExodusRoster.removeItem(const Item: IExodusRosterItem);
begin
    MainSession.ItemController.RemoveItem(Item.JabberID);
end;

{---------------------------------------}
function TExodusRoster.addContextMenu(const id: WideString): WordBool;
begin
    //Custom context menus not supported
    Result := false;
end;
{---------------------------------------}
procedure TExodusRoster.removeContextMenu(const id: WideString);
begin
    //custom context menus not supported
end;

{---------------------------------------}
function TExodusRoster.AddContextMenuItem(const menuID, caption: WideString;
  const menuListener: IExodusMenuListener): WideString;
var
    actCtrl: IExodusActionController;
    typedActs: IExodusTypedActions;
    act: TExMenuListenerAction;
    itemtype: Widestring;
    midx: integer;
    menu: TTntPopupMenu;
    mi: TTntMenuItem;
    g: TGUID;
    guid: string;
begin
    Result := '';
    actCtrl := GetActionController();

    CreateGUID(g);
    guid := GUIDToString(g);
    guid := AnsiMidStr(guid, 2, length(guid) - 2);
    if not mapMenuID(menuID, itemtype) then begin
        midx := _menus.IndexOf(menuID);
        if (midx = -1) then exit;

        menu := TTntPopupMenu(_menus.Objects[midx]);

        guid := AnsiReplaceStr(guid, '-', '_');
        mi := TTntMenuItem.Create(menu);
        mi.Name := 'pluginContext_item_' + guid;
        mi.Caption := caption;
        mi.OnClick := Self.MenuClick;
        mi.Tag := Integer(menuListener);
        menu.Items.Add(mi);
        _items.AddObject(mi.Name, mi);

        Result := mi.Name;
    end
    else begin
        typedActs := actCtrl.actionsForType(itemtype);

        act := TExMenuListenerAction.Create(
            '{999-http://exodus.googlecode.com/plugins}' + guid,
            caption,
            menuListener);
        actCtrl.registerAction(itemtype, act);
        _actions.AddObject(itemtype + ':' + act.Get_Name(), act);

        Result := act.Get_Name();
    end;
end;
{---------------------------------------}
procedure TExodusRoster.removeContextMenuItem(const menu_id,
  item_id: WideString);
var
    idx: integer;
    menu: TTntPopupMenu;
    mi: TTntMenuitem;
    itemtype: Widestring;
begin

    if not mapMenuID(menu_id, itemtype) then begin
        idx := _menus.IndexOf(menu_id);
        if (idx = -1) then exit;

        menu := TTntPopupMenu(_menus.Objects[idx]);
        idx := _items.IndexOf(item_id);
        if (idx = -1) then exit;

        mi := TTntMenuItem(_items.Objects[idx]);
        _items.Delete(idx);

        idx := menu.Items.IndexOf(mi);
        if (idx <> -1) then menu.Items.Delete(idx);

        mi.Tag := 0;
        mi.Free();
    end
    else begin
        idx := _actions.IndexOf(itemtype + ':' + item_id);
        if (idx = -1) then exit;

        //TODO:  support removing actions from controller???
        TExMenuListenerAction(_actions.Objects[idx]).Enabled := false;
        _actions.Delete(idx);
    end;
end;

{---------------------------------------}
function TExodusRoster.findContextMenu(id: Widestring): TTntPopupMenu;
var
    idx: integer;
    menu: TTntPopupMenu;
begin
    Result := nil;
    idx := _menus.IndexOf(id);
    if (idx = -1) then exit;

    menu := TTntPopupMenu(_menus.Objects[idx]);
    Result := menu;
end;

{---------------------------------------}
procedure TExodusRoster.EnableContextMenuItem(const menuID: WideString; const itemID: WideString; enable: WordBool);
var
    idx: integer;
    item: TTntMenuitem;
    itemtype: Widestring;
    act: TExMenuListenerAction;
begin
    if not mapMenuID(menuID, itemtype) then begin
        idx := _menus.IndexOf(menuID);
        if (idx = -1) then exit;

        idx := _items.IndexOf(itemID);
        if (idx = -1) then exit;

        item := TTntMenuItem(_items.Objects[idx]);
        item.Enabled := enable;
    end else begin
        idx := _actions.IndexOf(itemtype + ':' + itemID);
        if (idx = -1) then exit;

        act := TExMenuListenerAction(_actions.Objects[idx]);
        act.Enabled := enable;
    end;
end;

{---------------------------------------}
procedure TExodusRoster.ShowContextMenuItem(const menuID: WideString; const itemID: WideString; show: WordBool);
var
    idx: integer;
    item: TTntMenuitem;
    itemtype: Widestring;
    act: TExMenuListenerAction;
begin
    if not mapMenuID(menuID, itemtype) then begin
        idx := _menus.IndexOf(menuID);
        if (idx = -1) then exit;

        idx := _items.IndexOf(itemID);
        if (idx = -1) then exit;

        item := TTntMenuItem(_items.Objects[idx]);
        item.Visible := show;
    end
    else begin
        idx := _actions.IndexOf(itemtype + ':' + itemID);
        if (idx = -1) then exit;

        act := TExMenuListenerAction(_actions.Objects[idx]);
        act.Enabled := show;
    end;
end;

{---------------------------------------}
procedure TExodusRoster.SetContextMenuItemCaption(const menuID: WideString; const itemID: WideString; const caption: WideString);
var
    i, idx: integer;
    menu: TTntPopupMenu;
    item: TTntMenuitem;
begin
    idx := _menus.IndexOf(menuID);
    if (idx = -1) then exit;

    menu := TTntPopupMenu(_menus.Objects[idx]);

    for i := 0 to menu.Items.Count - 1 do begin
        item := TTntMenuItem(menu.Items[i]);
        if (item.Name = itemID) then begin
            item.Caption := caption;
            exit;
        end;
    end;
end;

{---------------------------------------}
function TExodusRoster.GetContextMenuItemCaption(const menuID: WideString; const itemID: WideString): WideString;
var
    i, idx: integer;
    menu: TTntPopupMenu;
    item: TTntMenuitem;
begin
    idx := _menus.IndexOf(menuID);
    if (idx = -1) then exit;

    menu := TTntPopupMenu(_menus.Objects[idx]);

    for i := 0 to menu.Items.Count - 1 do begin
        item := TTntMenuItem(menu.Items[i]);
        if (item.Name = itemID) then begin
            Result := item.Caption;
            exit;
        end;
    end;
end;

function TExodusRoster.mapMenuID(menuID: WideString; var itemtype: Widestring): Boolean;
begin
    Result := true;
    itemtype := menuID;

    if (menuID = 'Roster') then
        itemtype := 'contact'
    else if (menuID = 'Group') then
        itemtype := 'group'
    else if (menuID = 'Bookmark') then
        itemtype := 'room'
    else if (menuID = 'Actions') then
        itemtype := ''
    else begin
        itemtype := '';
        Result := false;
    end;
end;

procedure TExodusRoster.MenuClick(Sender: TObject);
var
    mi: TTntMenuItem;
    resultset: TXMLTag;
begin
    if (_items.IndexOfObject(Sender) = -1) then exit;
    mi := TTntMenuItem(Sender);
    resultset := TXMLTag.Create('<selected_roster_list>');
    IExodusMenuListener(mi.Tag).OnMenuItemClick(mi.Name, resultset.XML);
    resultset.Free();
end;

constructor TExMenuListenerAction.Create(name: WideString; caption: WideString; listener: IExodusMenuListener);
begin
    inherited Create(name);
    set_Caption(caption);
    set_Enabled(true);

    _listener := listener;
end;

procedure TExMenuListenerAction.execute(const items: IExodusItemList);
var
    resultset: TXMLTag;
    idx, jdx: Integer;
    item: IExodusItem;
begin
    resultset := TXMLTag.Create('selected_roster_list');

    for idx := 0 to items.Count - 1 do begin
        item := items.Item[idx];
        with resultset.AddTag('item') do begin
            SetAttribute('jid', item.UID);
            SetAttribute('name', item.value['Name']);
            SetAttribute('subscription', item.value['Subscription']);
            SetAttribute('ask', item.value['Ask']);

            for jdx := 0 to item.GroupCount - 1 do
                AddBasicTag('group', item.Group[jdx]);
        end;
    end;
    _listener.OnMenuItemClick(Get_Name(), resultset.XML);

    resultset.Free();
end;

initialization
  TAutoObjectFactory.Create(ComServer, TExodusRoster, Class_ExodusRoster,
    ciMultiInstance, tmApartment);


end.
