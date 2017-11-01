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

unit ExActionMap;

interface

uses ActiveX, ComObj, Classes, Contnrs, ExActions, Unicode, Exodus_TLB;



type
    TExodusActionMap = class;
    TExodusTypedActions = class(TAutoIntfObject, IExodusTypedActions)
    private
        _owner: TExodusActionMap;
        _itemtype: Widestring;
        _items: IExodusItemList;
        _actions: TWidestringList;

        procedure Set_Owner(actmap: TExodusActionMap);
    protected
        function LookupAction(actname: Widestring; recurse: Boolean = false): IExodusAction;

        property Owner: TExodusActionMap read _owner write Set_Owner;
    public
        constructor Create(itemtype: Widestring);
        destructor Destroy; override;

        function Get_ItemType: Widestring; safecall;
        function Get_ItemCount: Integer; safecall;
        function Get_Item(idx: Integer): IExodusItem; safecall;
        procedure Set_Item(idx: Integer; item: IExodusItem);

        function Get_ActionCount: Integer; safecall;
        function Get_Action(idx: Integer): IExodusAction; safecall;
        function IndexOfAction(act: IExodusAction): Integer;
        procedure AddAction(act: IExodusAction);
        procedure RemoveAction(act: IExodusAction);
        procedure Clear(items: Boolean = true);

        function GetActionNamed(const name: Widestring): IExodusAction; safecall;
        procedure execute(const actname: Widestring); safecall;
    end;

    TExodusActionMap = class(TAutoIntfObject, IExodusActionMap)
    private
        _items: IExodusItemList;
        _allActs: TInterfaceList;
        _actLists: TWidestringList;

        procedure AddAction(act: IExodusAction);

    protected

    public
        constructor Create(items: IExodusItemList);
        destructor Destroy; override;

        function Get_ItemCount: Integer; safecall;
        function Get_Item(idx: Integer): IExodusItem; safecall;
        function GetAllItems(): IExodusItemList;

        function Get_TypedActionsCount: Integer; safecall;
        function Get_TypedActions(idx: Integer): IExodusTypedActions; safecall;
        function LookupTypedActions(itemtype: Widestring; create: Boolean): TExodusTypedActions;
        procedure DeleteTypedActions(actList: TExodusTypedActions);

        function GetActionsFor(const itemtype: Widestring): IExodusTypedActions; safecall;
        function GetActionNamed(const name: Widestring): IExodusAction; safecall;
    end;

implementation

uses SysUtils, ComServ, COMExodusItemList;

function findAction(act: IExodusAction; name: Widestring): IExodusAction;
var
    idx: Integer;
    subact: IExodusAction;
begin
    Result := nil;

    for idx := 0 to act.SubActionCount - 1 do begin
        subact := act.SubAction[idx];
        if (subact.Name = name) then
            Result := subact
        else
            Result := findAction(subact, name);

        if (Result <> nil) then
            exit;
    end
end;

{
    TExodusTypedActions implementation
}

constructor TExodusTypedActions.Create(itemtype: WideString);
begin
    inherited Create(ComServer.TypeLib, IID_IExodusTypedActions);

    _itemtype := itemtype;
    _items := TExodusItemList.Create as IExodusItemList;

    _actions := TWidestringList.Create;
    _actions.Sorted := true;
    _actions.Duplicates := dupIgnore;
end;

procedure TExodusTypedActions.Set_Owner(actmap: TExodusActionMap);
var
    idx: Integer;
    item: IExodusItem;
begin
    _owner := actmap;

    Clear();
    for idx := 0 to actmap.Get_ItemCount - 1 do begin
        item := actmap.Get_item(idx);
        if (_itemtype = '') or (_itemtype = item.Type_) then
            _items.Add(item);
    end;
end;
destructor TExodusTypedActions.Destroy;
begin
    Clear();
    _actions.Free;
    _items := nil;
    _owner := nil;

    inherited;
end;

function TExodusTypedActions.Get_ItemType: Widestring;
begin
    Result := _itemtype;
end;

function TExodusTypedActions.Get_ItemCount: Integer;
begin
    Result := _items.Count;
end;
function TExodusTypedActions.Get_Item(idx: Integer): IExodusItem;
begin
    Result := nil;
    if (idx < 0) or (idx >= _items.Count) then exit;

    Result := _items.Item[idx];
end;
procedure TExodusTypedActions.Set_Item(idx: Integer; item: IExodusItem);
begin
    if (idx < 0) or (idx > _items.Count) then exit
    else if (idx = _items.Count) then
        _items.Add(item)
    else
        _items.Item[idx] := item;
end;

function TExodusTypedActions.Get_ActionCount: Integer;
begin
    Result := _actions.Count;
end;
function TExodusTypedActions.Get_Action(idx: Integer): IExodusAction;
begin
    Result := nil;
    if (idx < 0) or (idx >= _actions.Count) then exit;

    Result := IExodusAction(Pointer(_actions.Objects[idx]));
end;
function TExodusTypedActions.IndexOfAction(act: IExodusAction): Integer;
begin
    Result := _actions.IndexOfObject(TObject(Pointer(act)));
end;
procedure TExodusTypedActions.AddAction(act: IExodusAction);
var
    idx: Integer;
    currRef: Pointer;
    nextRef: Pointer;
begin
    if act = nil then exit;

    nextRef := Pointer(act);
    idx := _actions.IndexOf(act.Name);
    if (idx <> -1) then begin
        currRef := Pointer(_actions.Objects[idx]);

        if (currRef = nextRef) then
            exit;       //already present, so do nothing!
        IExodusAction(currRef)._Release;
        _actions.Delete(idx);
    end;

    act._AddRef;
    _actions.AddObject(act.Name, TObject(Pointer(act)));
    if Owner <> nil then
        _owner.AddAction(act);
end;
procedure TExodusTypedActions.RemoveAction(act: IExodusAction);
var
    idx: Integer;
    currRef, prevRef: Pointer;
begin
    if act = nil then exit;

    currRef := Pointer(act);
    idx := _actions.IndexOf(act.Name);
    if (idx <> -1) then begin
        prevRef := Pointer(_actions.Objects[idx]);

        if (currRef = prevRef) then begin
            _actions.Delete(idx);
            act._Release;
        end;
    end;
end;
procedure TExodusTypedActions.Clear(items: Boolean);
var
    idx: Integer;
begin
    for idx := _actions.Count - 1 downto 0 do begin
        IExodusAction(Pointer(_actions.Objects[idx]))._Release;
        _actions.Delete(idx);
    end;
    if (items) then _items.Clear();
end;

function TExodusTypedActions.GetActionNamed(const name: WideString): IExodusAction;
begin
    Result := LookupAction(name, false);
end;
procedure TExodusTypedActions.execute(const actname: Widestring);
var
    act: IExodusAction;
begin
    act := LookupAction(actname, true);
    if (act = nil) then exit;

    act.execute(_items);
end;

function TExodusTypedActions.LookupAction(actname: WideString; recurse: Boolean): IExodusAction;
var
    idx: Integer;
begin
    Result := nil;

    idx := _actions.IndexOf(actname);
    if (idx <> -1) then
        Result := Get_Action(idx)
    else if (recurse) then begin
        for idx := 0 to _actions.Count - 1 do begin
            Result := findAction(Get_Action(idx), actname);
            if (Result <> nil) then exit;
        end;
    end;
end;

{
    TExodusActionMap implementation
}
constructor TExodusActionMap.Create(items: IExodusItemList);
begin
    inherited Create(ComServer.TypeLib, IID_IExodusActionMap);

    if (items = nil) then items := TExodusItemList.Create;

    _items := items;
    _allActs := TInterfaceList.Create;

    _actLists := TWidestringList.Create;
    _actLists.Sorted := true;
    _actLists.Duplicates := dupIgnore;
end;
destructor TExodusActionMap.Destroy;
var
    idx: Integer;
    actList: TExodusTypedActions;
begin
    for idx := _actLists.Count - 1 downto 0 do begin
        actList := TExodusTypedActions(_actLists.Objects[idx]);
        actList._Release;
    end;
    FreeAndNil(_actLists);

    _items := nil;
    _allActs := nil;

    inherited;
end;

function TExodusActionMap.Get_ItemCount: Integer;
begin
    Result := _items.Count;
end;
function TExodusActionMap.Get_Item(idx: Integer): IExodusItem;
begin
    if (idx < 0) or (idx >= _items.Count) then
        Result := nil
    else
        Result := _items.Item[idx];
end;
function TExodusActionMap.GetAllItems(): IExodusItemList;
begin
    Result := _items;
end;

function TExodusActionMap.Get_TypedActionsCount: Integer;
begin
    Result := _actLists.Count;
end;
function TExodusActionMap.Get_TypedActions(idx: Integer): IExodusTypedActions;
var
    actList: TExodusTypedActions;
begin
    Result := nil;
    if (idx < 0) or (idx > _actLists.Count) then exit;
    
    actList := TExodusTypedActions(_actLists.Objects[idx]);
    Result := actList as IExodusTypedActions;
end;
function TExodusActionMap.LookupTypedActions(
        itemtype: WideString;
        create: Boolean): TExodusTypedActions;
var
    idx: Integer;
begin
    Result := nil;
    idx := _actLists.IndexOf(itemtype);
    if (idx <> -1) then
        Result := TExodusTypedActions(_actLists.Objects[idx])
    else if create then begin
         Result := TExodusTypedActions.Create(itemtype);
         Result.Owner := Self;
         Result._AddRef;
         _actLists.AddObject(itemtype, Result);
    end;
end;
procedure TExodusActionMap.DeleteTypedActions(actList: TExodusTypedActions);
var
    idx: Integer;
begin
    idx := _actLists.IndexOfObject(actList);
    if (idx <> -1) then begin
        _actLists.Delete(idx);
        actList._Release;
    end;
end;

function TExodusActionMap.GetActionsFor(const itemtype: WideString): IExodusTypedActions;
var
    actList: TExodusTypedActions;
begin
    actList := LookupTypedActions(itemtype, false);
    if actList <> nil then
        Result := actList as IExodusTypedActions
    else
        Result := nil;
end;

function TExodusActionMap.GetActionNamed(const name: WideString): IExodusAction;
var
    idx: Integer;
begin
    for idx := 0 to _allActs.Count - 1 do begin
        Result := _allActs[idx] as IExodusAction;

        if (Result.Name = name) then exit;
        Result := nil;
    end;
end;

procedure TExodusActionMap.AddAction(act: IExodusAction);
var
    idx: Integer;
begin
    idx := _allActs.IndexOf(act);
    if (idx = -1) then
        _allActs.Add(act as IExodusAction);
end;

end.
