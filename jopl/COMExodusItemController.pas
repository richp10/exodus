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


unit COMExodusItemController;

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  ComObj, ActiveX, Exodus_TLB, StdVcl, Unicode, XMLTag, PrefFile, GroupParser, COMExodusItemWrapper,
  PLUGINCONTROLLib_TLB;

type
  {
    This class extends the item wrapper to actually create items, and retain
    the callback
  }
  TExodusItemRetainer = class(TExodusItemWrapper)
  private
    _Callback: IExodusItemCallback;

  public
    constructor Create(ctrl: IExodusItemController;
        Uid: WideString;
        Type_: WideString;
        cb: IExodusItemCallback);
    destructor Destroy(); override;

    property Callback: IExodusItemCallback read _Callback;
  end;
  TExodusItemController = class(TAutoObject, IExodusItemController)
  {
     This class implements IExodusItemController interface. IExodusItemController
     interface allows group and item management in the contact list.
  }
  protected
      procedure Set_GroupExpanded(const Group: WideString; Value: WordBool);
      safecall;
      function Get_GroupExpanded(const Group: WideString): WordBool; safecall;
      function Get_GroupExists(const Group: WideString): WordBool; safecall;
      function GetGroups: OleVariant; safecall;
      function SaveGroups: WordBool; safecall;
      function Get_GroupsLoaded: WordBool; safecall;
      procedure ClearItems; safecall;
      function GetItem(const UID: WideString): IExodusItem; safecall;
      function Get_GroupsCount: Integer; safecall;
      function Get_Item(Index: Integer): IExodusItem; safecall;
      function Get_ItemsCount: Integer; safecall;
    function GetGroupItems(const Group: WideString): IExodusItemList; safecall;
      function AddItemByUid(const UID, ItemType: WideString;
      const cb: IExodusItemCallback): IExodusItem; safecall;
      procedure CopyItem(const UID, GroupTo: WideString); safecall;
      procedure MoveItem(const UID, GroupFrom, GroupTo: WideString); safecall;
      procedure RemoveGroupMoveContent(const Group, groupTo: WideString); safecall;
      procedure RemoveItem(const Uid: WideString); safecall;
      procedure RemoveItemFromGroup(const UID, Group: WideString); safecall;
    function GetItemsByType(const Type_: WideString): IExodusItemList; safecall;
    function AddGroup(const grp: WideString): IExodusItem; safecall;
    function AddHover(const ItemType, GUID: WideString): IExodusHover; safecall;
    procedure RemoveHover(const ItemType: WideString); safecall;
    function GetHoverByType(const ItemType: WideString): IExodusHover; safecall;
  private
      _Items: TWideStringList;
      _JS: TObject;
      _GroupsCB: IExodusItemCallback;
      _SessionCB: Integer;
      _GroupsLoaded: Boolean;
      _ServerStorage: Boolean;
      _GroupParser : TGroupParser;
      _HoverControls: TWideStringList;
      _itemupdateCB: integer;
      _depResolver: TObject; //TSimpleDependancyHandler;

      procedure _OnDependancyReady(tag: TXMLTag);
      procedure _SessionCallback(Event: string; Tag: TXMLTag);
      procedure _GetGroups();
      procedure _ParseGroups(Event: string; Tag: TXMLTag);
      procedure _SendGroups();
      function  _GetItemRetainer(const UID: Widestring): TExodusItemRetainer;
      function  _AddGroup(const GroupUID: WideString): TExodusItemRetainer;
      function  _ApplyGroup(item: IExodusItem; GroupTo: Widestring; moving: Boolean = false): Boolean;
      procedure _ItemUpdateCallback(Event: string; Item: IExodusItem);
  public
      constructor Create(JS: TObject);
      destructor Destroy; override;
      //Properties

  end;

  TExodusGroupCallback = class(TAutoIntfObject, IExodusItemCallback)
  private
    _ctrl: TExodusItemController;

    constructor Create(ctrl: TExodusItemController);

  public
    destructor Destroy(); override;

    procedure ItemDeleted(const item: IExodusItem); safecall;
    procedure ItemGroupsChanged(const item: IExodusItem); safecall;
    procedure ItemUpdated(const Item: IExodusItem); safecall;
  end;

var
   xp_group : TXPLite;

implementation

uses ComServ, Classes,
     JabberConst, IQ, Session, {GroupInfo,} Variants, Contnrs,
     COMExodusItem, COMExodusItemList, COMExodusHover;


{---------------------------------------}
constructor TExodusItemRetainer.Create(
        ctrl: IExodusItemController;
        Uid: WideString;
        Type_: WideString;
        cb: IExodusItemCallback);
begin
    inherited Create(TExodusItem.Create(ctrl, uid, Type_, cb));
    _Callback := cb;
end;
destructor TExodusItemRetainer.Destroy;
begin
    _Callback := nil;

    inherited;
end;

{---------------------------------------}
constructor TExodusItemController.Create(JS: TObject);
begin
    inherited create();
    _Items := TWideStringList.Create();
    _Items.Duplicates := dupError;
    _JS := JS;
    _groupsLoaded := false;
    _SessionCB := TJabberSession(_JS).RegisterCallback(_SessionCallback, '/session');
    _ServerStorage := true;
    _GroupParser := TGroupParser.Create(_JS);
    _GroupsCB := TExodusGroupCallback.Create(Self);
    _HoverControls := TWideStringList.Create();
    _itemupdateCB := TJabberSession(_JS).RegisterCallback(_ItemUpdateCallback, '/item/update');
    _depResolver := TSimpleAuthResolver.create(_OnDependancyReady, DEPMOD_LOGGED_IN);
end;

{---------------------------------------}
destructor TExodusItemController.Destroy();
begin

    ClearItems();

    _Items.Free;
    _GroupParser.Free;

    _GroupsCB._Release();
    _GroupsCB := nil;

    while (_HoverControls.Count > 0) do
        _HoverControls.Delete(0);

    _HoverControls.Free;

    if (_itemupdateCB >= 0) then
    begin
        TJabberSession(_JS).UnRegisterCallback(_itemupdateCB);
    end;
    _depResolver.Free();
    inherited;
end;

procedure TExodusItemController._OnDependancyReady(tag: TXMLTag);
begin
   _GroupsLoaded := false;
   _GetGroups();
end;

{---------------------------------------}
procedure TExodusItemController._SessionCallback(Event: string; Tag: TXMLTag);
begin
    if Event = '/session/disconnecting' then begin
        _SendGroups();
    end
    else if Event = '/session/disconnected' then begin
        _GroupsLoaded := false;
        ClearItems();
    end;
end;

{---------------------------------------}
//Sends IQ to retrieves group related information
//from private storage on the server.
procedure TExodusItemController._GetGroups();
var
    IQ: TJabberIQ;
begin
    IQ := TJabberIQ.Create(TJabberSession(_JS), TJabberSession(_JS).generateID(), _ParseGroups, 180);
    with IQ do begin
        IQType := 'get';
        ToJid := '';
        Namespace := XMLNS_PRIVATE;
        with qtag.AddTag('storage') do
            setAttribute('xmlns', XMLNS_GROUPS);
        Send();
    end;
end;

{---------------------------------------}
//Parses xml containing group info received
//from private storage on the server.
procedure TExodusItemController._ParseGroups(Event: string; Tag: TXMLTag);
var
    i: Integer;
    Groups:TXMLTag;
    gTag: TXMLTag;
    Group: IExodusItem;
    tagList: TXMLTagList;
begin
    Group := nil;
    Groups := nil;
    TJabberSession(_JS).FireEvent('/item/begin', Group);

    if ((Event = 'xml') and (Tag.getAttribute('type') = 'result')) then
        Groups := Tag.QueryXPTag(xp_group)
    else
    begin
        if ((Event = 'xml') and (Tag.getAttribute('type') = 'error')) then
            _ServerStorage := false;
    end;

    if Groups <> nil then begin
        tagList := Groups.ChildTags;
        for i := 0 to Groups.ChildCount - 1 do
        begin
            //Add will checks for duplicates
            gTag := tagList[i];
            Group := AddGroup(gTag.Data);
            if (gTag.GetAttribute('expanded') <> '') then
                Group.Value['Expanded'] := gTag.GetAttribute('expanded')
            else
                Group.Value['Expanded'] := 'false';
        end;
        tagList.Free();
    end;

    _GroupsLoaded := true;
     if (TJabberSession(_js).RosterRefreshTimer.Enabled) then
        TJabberSession(_js).RosterRefreshTimer.Enabled := false;

    TJabberSession(_js).RosterRefreshTimer.Enabled := true;
    TAuthDependancyResolver.SignalReady(DEPMOD_GROUPS);
end;

{---------------------------------------}
// Sends IQ to save group information on the server.
procedure TExodusItemController._SendGroups();
var
    i: Integer;
    IQ, STag, GTag:TXMLTag;
begin
    IQ := TXMLTag.Create('iq');
    with IQ do begin
        setAttribute('type', 'set');
        setAttribute('id', TJabberSession(_js).generateID());
        with AddTag('query') do begin
            setAttribute('xmlns', XMLNS_PRIVATE);
            STag := AddTag('storage');
            STag.setAttribute('xmlns', XMLNS_GROUPS);
            for i := 0 to Get_ItemsCount - 1 do
            begin
                if (Get_Item(i).Type_ <> EI_TYPE_GROUP) then continue;

                //Group := TGroupInfo(_Groups.Objects[i]);
                GTag := TXMLTag.Create('group', Get_Item(i).UID);
                try
                   GTag.setAttribute('expanded', Get_Item(i).Value['Expanded']);
                except
                   GTag.setAttribute('expanded', 'true');
                end;
                STag.AddTag(GTag);
            end;
        end;
    end;
    TJabberSession(_JS).SendTag(IQ);
end;

{---------------------------------------}
function TExodusItemController.Get_GroupsCount: Integer;
var
    i: Integer;
begin
    Result := 0;
    for i := 0 to Get_ItemsCount - 1 do
    begin
        if (Get_Item(i).Type_ <> EI_TYPE_GROUP) then continue;
        Inc(Result);
    end;
end;

{---------------------------------------}
function TExodusItemController.Get_Item(Index: Integer): IExodusItem;
begin
    Result := TExodusItemRetainer(_Items.Objects[index]).ExodusItem;
end;

{---------------------------------------}
function TExodusItemController.get_ItemsCount: Integer;
begin
   Result := _Items.Count;
end;

{---------------------------------------}
function TExodusItemController.GetGroupItems(
  const Group: WideString): IExodusItemList;
var
    item: IExodusItem;
    idx: Integer;
begin
    Result := TExodusItemList.Create();
    for idx := 0 to _Items.Count - 1 do begin
        item := TExodusItemRetainer(_Items.Objects[idx]).ExodusItem;
        if (item.BelongsToGroup(Group)) then
            Result.Add(item);
    end;
end;

function TExodusItemController._GetItemRetainer(const UID: WideString): TExodusItemRetainer;
var
    idx: Integer;
begin
    idx := _Items.IndexOf(UID);
    if (idx <> -1) then
        Result := TExodusItemRetainer(_Items.Objects[idx])
    else
        Result := nil;
end;
function  TExodusItemController._AddGroup(const GroupUID: WideString): TExodusItemRetainer;
var
    i: Integer;
    SubGroup: TExodusItemRetainer;
    Groups: TWideStringList;
    GroupParent: WideString;
begin
    Result := _GetItemRetainer(GroupUID);
    if (Result <> nil) then exit;

    //Get nested groups
    Groups := _GroupParser.GetNestedGroups(GroupUID);
    //Add nested groups to the item list
    for i := 0 to Groups.Count - 1 do
    begin
        if (Get_GroupExists(Groups[i])) then continue;
        SubGroup := TExodusItemRetainer.Create(Self, Groups[i], EI_TYPE_GROUP, _GroupsCB);
        _Items.AddObject(Groups[i], SubGroup);
        SubGroup.ExodusItem.Text := _GroupParser.GetGroupName(SubGroup.ExodusItem.UID);
        GroupParent := _GroupParser.GetGroupParent(SubGroup.ExodusItem.UID);
        if (GroupParent <> '') then
            SubGroup.ExodusItem.AddGroup(GroupParent);
        if (i = Groups.Count - 1) then
            Result := SubGroup;
    end;

    if (Result = nil) then
        Result := _GetItemRetainer(GroupUID);

    Groups.Free;
    TJabberSession(_JS).FireEvent('/item/add', Result.ExodusItem);
    //If adding new groups and groups have
    //been loaded, need to save to the server's
    //private storage.
    if (_GroupsLoaded) then
    begin
        SaveGroups();
    end;
end;

{---------------------------------------}
function TExodusItemController._ApplyGroup(
        item: IExodusItem;
        GroupTo: WideString;
        moving: Boolean): Boolean;
var
    subgrp: Widestring;
    subitems: IExodusItemList;
    idx: Integer;
begin
    //Assume the copy will happen...
    Result := (GroupTo <> Item.UID);

    if Result then begin
        //Determine the destination
        if (_GroupParser.Separator <> '') then begin
            subgrp := _GroupParser.GetGroupName(Item.UID);
            Result := _GroupParser.GetGroupParent(Item.UID) <> GroupTo;
            if Result and (GroupTo <> '') then begin
                //Make this group a subgroup of Group...
                subgrp := GroupTo + _GroupParser.Separator + subgrp;
            end;
        end
        else begin
            //Copy this group's items into Group...
            subgrp := GroupTo;
        end;
    end;

    if Result then begin
        //Copy the items
        subitems := GetGroupItems(Item.UID);
        if subitems.Count = 0 then
            AddGroup(subgrp)
        else begin
            for idx := 0 to subitems.Count - 1 do begin
                if moving then
                    MoveItem(subitems.Item[idx].UID, item.UID, subgrp)
                else
                    CopyItem(subitems.Item[idx].UID, subgrp);
            end;
        end;

        //Update expanded-state??
        Set_GroupExpanded(subgrp, Get_GroupExpanded(Item.UID));

        //If moving, remove
        if moving then RemoveItem(item.UID);
    end;
end;

{---------------------------------------}
procedure TExodusItemController._ItemUpdateCallback(Event: string; Item: IExodusItem);
var
    cb: IExodusItemCallback;
    ItemWrapper: TExodusItemRetainer;
    idx: integer;
begin
    if (item = nil) then exit;
    
    idx := _Items.IndexOf(item.UID);
    if (Idx = -1) then exit;

    //notify callback
    ItemWrapper := TExodusItemRetainer(_Items.Objects[idx]);
    cb := ItemWrapper.Callback;
    if (cb <> nil) then cb.ItemUpdated(ItemWrapper.ExodusItem);
end;

{---------------------------------------}
function TExodusItemController.AddItemByUid(const UID, ItemType: WideString;
  const cb: IExodusItemCallback): IExodusItem;
var
    wrapper: TExodusItemRetainer;
begin
    //Check if item exists
    wrapper := _GetItemRetainer(UID);
    //If new item, create and append to the list
    if (wrapper = nil) then
    begin
       if (ItemType = EI_TYPE_GROUP) then
            wrapper := _AddGroup(UID)
       else
       begin
           wrapper := TExodusItemRetainer.Create(Self, Uid, ItemType, cb);
           _Items.AddObject(Uid, wrapper);
       end;
    end;

    //Return interface
    Result := wrapper.ExodusItem;
end;

{---------------------------------------}
procedure TExodusItemController.CopyItem(const UID, GroupTo: WideString);
var
    Wrapper: TExodusItemRetainer;
    Item: IExodusItem;
begin
    //Check if item exists
    Wrapper := _GetItemRetainer(UID);
    if (Wrapper = nil) then exit;

    Item := Wrapper.ExodusItem;
    if (Item.Type_ = EI_TYPE_GROUP) then begin
        _ApplyGroup(Item, GroupTo);
    end
    else begin
        //Copy item from one group to another, or in other words,
        //add group to the item's group list.
        Item.AddGroup(GroupTo);
    end;
end;

{---------------------------------------}
procedure TExodusItemController.MoveItem(const UID, GroupFrom,
  GroupTo: WideString);
var
    Wrapper: TExodusItemRetainer;
    Item: IExodusItem;
begin
    //Check if item exists
    Wrapper := _GetItemRetainer(UID);
    if (Wrapper = nil) then exit;

    Item := Wrapper.ExodusItem;
    if (Item.Type_ = EI_TYPE_GROUP) then begin
        _ApplyGroup(Item, GroupTo, true);
    end
    else begin
        //Move item from one group to another, or in other words,
        //add GroupFrom to, and remove GroupTo from, the item's group list.
        item.MoveGroup(GroupFrom, GroupTo);
    end;
end;

{---------------------------------------}
procedure TExodusItemController.RemoveGroupMoveContent(const Group,
  groupTo: WideString);
var
    Items: IExodusItemList;
    Item: IExodusItem;
    i: Integer;
begin
    //Get list of items in the group
    Items := GetGroupItems(Group);
    for i := 0 to Items.Count do
    begin
       //Iterate through the list and move each item to the new group
       Item := Items.Item[i];
       if (Item <> nil) then
           Item.MoveGroup(Group, GroupTo);
    end;
end;

{---------------------------------------}
procedure TExodusItemController.RemoveItem(const Uid: WideString);
var
    ItemWrapper: TExodusItemRetainer;
    cb: IExodusItemCallback;
    subItems: IExodusItemList;
    Idx: Integer;
begin
    //Check if item exists
    Idx := _Items.IndexOf(Uid);
    if (Idx = -1) then exit;

    //Reference and delete from list
    ItemWrapper := TExodusItemRetainer(_Items.Objects[idx]);
    _Items.Delete(Idx);

    if (ItemWrapper.ExodusItem.Type_ = EI_TYPE_GROUP) then begin
        //remove all of the group's items...
        subItems := GetGroupItems(ItemWrapper.ExodusItem.UID);
        for idx := 0 to subItems.Count - 1 do begin
            if (subItems.Item[idx].Type_ = EI_TYPE_GROUP) then
                RemoveItem(subItems.Item[idx].UID)
            else
                subItems.Item[idx].RemoveGroup(ItemWrapper.ExodusItem.UID);
        end;
    end;

    //notify callback
    cb := ItemWrapper.Callback;
    if (cb <> nil) then cb.ItemDeleted(ItemWrapper.ExodusItem);

    //fire event
    TJabberSession(_JS).FireEvent('/item/remove', ItemWrapper.ExodusItem);

    //then finally, we delete
    ItemWrapper.Free();
end;

{---------------------------------------}
procedure TExodusItemController.RemoveItemFromGroup(const UID,
  Group: WideString);
var
    Item: IExodusItem;
    Idx: Integer;
begin
    //Check if item exists
    Idx := _Items.IndexOf(Uid);
    if (Idx < 0) then exit;
    //Remove item from the list, call remove for the item
    Item := TExodusItemRetainer(_Items.Objects[Idx]).ExodusItem;
    Item.RemoveGroup(Group);
end;


{---------------------------------------}
function TExodusItemController.GetItem(const UID: WideString): IExodusItem;
var
    Idx: Integer;
begin
    Result := nil;
    Idx := _Items.IndexOf(Uid);
    if (Idx = -1) then exit;
    Result := TExodusItemRetainer(_Items.Objects[Idx]).ExodusItem;
end;


{---------------------------------------}
procedure TExodusItemController.ClearItems;
var
    Item: TExodusItemRetainer;
begin
    while _Items.Count > 0 do
    begin
        Item :=  TExodusItemRetainer(_Items.Objects[0]);
        _Items.Delete(0);
        Item.Free();
    end;
end;


function TExodusItemController.Get_GroupsLoaded: WordBool;
begin
   Result := _GroupsLoaded;
end;


function TExodusItemController.SaveGroups: WordBool;
begin
   if (_ServerStorage) then
       _SendGroups();
//   else
//   begin
//       Groups := TXMLTag.Create('local-groups');
//       for i := 0 to _Groups.Count - 1 do
//       begin
//           Group := TGroupInfo(_Groups.Objects[i]);
//           GTag := TXMLTag.Create('group', Group.Name);
//           if (Group.Expanded) then
//               Expanded := 'true'
//           else
//               Expanded := 'false';
//           GTag.setAttribute('expanded', Expanded);
//           Groups.AddTag(GTag);
//       end;
//       TJabberSession(_js).Prefs.SaveGroups(Groups);
//   end;

end;

function TExodusItemController.GetGroups: OleVariant;
var
    Groups : Variant;
    i: Integer;
begin
    Groups := VarArrayCreate([0,Get_GroupsCount], varOleStr);

    for i := 0 to Get_ItemsCount - 1 do
    begin
        if (Get_Item(i).Type_ <> EI_TYPE_GROUP) then continue;

        VarArrayPut(Groups, Get_Item(i).UID, i);
    end;

    Result := Groups;
end;

function TExodusItemController.Get_GroupExists(
  const Group: WideString): WordBool;
begin
    Result := false;
    if (_Items.IndexOf(Group) > -1) then
       Result := true;
end;

function TExodusItemController.Get_GroupExpanded(
  const Group: WideString): WordBool;
var
    Idx: Integer;
begin
    Result := false;
    Idx := _Items.IndexOf(Group);
    if (Idx = -1) then exit;
    try
       if (Get_Item(Idx).value['Expanded'] = 'true') then
           Result := true;
    except

    end;
end;

procedure TExodusItemController.Set_GroupExpanded(const Group: WideString;
  Value: WordBool);
var
    Wrapper: TExodusItemRetainer;
    state: Widestring;
    path: TWidestringList;
    idx: Integer;

    procedure ModifyGroupExpanded(retainer: TExodusItemRetainer);
    var
        item: IExodusItem;
    begin
        if (retainer = nil) then exit;
        item := retainer.ExodusItem;
        if (item = nil) then exit;
        
        try
            if (item.value['Expanded'] <> state) then begin
                item.value['Expanded'] := state;
            end;
        except
        end;
    end;
begin
    Wrapper := _GetItemRetainer(Group);
    if (Wrapper = nil) then exit;

    if not Value then
        state := 'false'
    else begin
        state := 'true';

        //make sure parent(s) are expanded as well
        path := _GroupParser.GetNestedGroups(Group);
        for idx := 0 to path.Count - 1 do begin
            ModifyGroupExpanded(_GetItemRetainer(path[idx]));
        end;
        path.Free();
    end;

    ModifyGroupExpanded(Wrapper);
end;

function TExodusItemController.GetItemsByType(
  const Type_: WideString): IExodusItemList;
var
    item: IExodusItem;
    idx: Integer;
begin
    Result := TExodusItemList.Create();
    for idx := 0 to _Items.Count - 1 do begin
        item := TExodusItemRetainer(_Items.Objects[idx]).ExodusItem;
        if (item.Type_ = Type_) then
            Result.Add(item);
    end;
end;

function TExodusItemController.AddGroup(const grp: WideString): IExodusItem;
begin
    Result := _AddGroup(grp).ExodusItem;
end;

function TExodusItemController.AddHover(const ItemType,
  GUID: WideString): IExodusHover;
var
    Hover: TCOMExodusHover;
    Idx: Integer;
begin
    Hover := TCOMExodusHover.Create(ItemType, GUID);
    Idx := _HoverControls.Add(ItemType);
    _HoverControls.Objects[Idx] := Hover; 
    Result := Hover;
end;


procedure TExodusItemController.RemoveHover(const ItemType: WideString);
var
    Idx: Integer;
    Hover: TCOMExodusHover;
begin
    Idx := _HoverControls.IndexOf(ItemType);
    if (Idx > -1) then
    begin
        Hover := TComExodusHover(_HoverControls.Objects[Idx]);
        _HoverControls.Delete(Idx);
        Hover.Free();
    end;
end;

constructor TExodusGroupCallback.Create(ctrl: TExodusItemController);
begin
    inherited Create(ComServer.TypeLib, IID_IExodusItemCallback);

    _ctrl := ctrl;

    _AddRef();
end;
destructor TExodusGroupCallback.Destroy;
begin
    inherited;
end;

procedure TExodusGroupCallback.ItemDeleted(const item: IExodusItem);
begin
    if not _ctrl._GroupsLoaded then exit;

    _ctrl._SendGroups();
end;
procedure TExodusGroupCallback.ItemGroupsChanged(const item: IExodusItem);
begin
    if not _ctrl._GroupsLoaded then exit;

    _ctrl._SendGroups();
    TJabberSession(_ctrl._JS).FireEvent('/item/update', item);
end;

procedure TExodusGroupCallback.ItemUpdated(const Item: IExodusItem);
begin
    // no-op
end;

function TExodusItemController.GetHoverByType(
  const ItemType: WideString): IExodusHover;
var
    Idx: Integer;
begin
    Result := nil;
    Idx := _HoverControls.IndexOf(ItemType);
    if (Idx > -1) then
        Result := TCOMExodusHover(_HoverControls.Objects[Idx]);
end;


initialization
  TAutoObjectFactory.Create(ComServer, TExodusItemController, Class_ExodusItemController,
    ciMultiInstance, tmApartment);

  xp_group := TXPLite.Create('//storage[@xmlns="' + XMLNS_GROUPS + '"]');

finalization
  xp_group.Free();


end.
