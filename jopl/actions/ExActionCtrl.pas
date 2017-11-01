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

unit ExActionCtrl;

interface

uses ActiveX, ExActions, ExActionMap, Classes, ComObj, Contnrs, Unicode, Exodus_TLB, StdVcl;

type TActionProxy = class(TObject)
private
    _itemtype: Widestring;
    _name: Widestring;
    _delegate: IExodusAction;
    _enabling: TWidestringList; //List of name/value pairs
    _disabling: TWidestringList; //List of name/value pairs

    function enabledContainsAll(actual: TWidestringList): Boolean;
    function disabledContainsAny(actual: TWidestringList): Boolean;
    procedure Set_Delegate(const act: IExodusAction);
public
    constructor Create(itemtype, actname: Widestring);
    destructor Destroy(); override;

    procedure addToEnabling(filter: Widestring);
    procedure addToDisabling(filter: Widestring);
    function applies(enabling, disabling: TWidestringList): Boolean;

    property ItemType: Widestring read _itemtype;
    property Name: Widestring read _name;
    property Action: IExodusAction read _delegate write Set_Delegate;
    property EnablingFilter: TWidestringList read _enabling;
    property DisablingFilter: TWidestringList read _disabling;
end;

type TFilteringItem = class(TObject)
private
    _key, _val: Widestring;

public
    constructor Create(item: Widestring); overload;
    constructor Create(key, val: Widestring); overload;
    destructor Destroy; override;

    property Key: Widestring read _key;
    property Value: Widestring read _val;

end;
type TFilteringSet = class(TObject)
private
    _itemcount: Integer;
    _enableHints, _disableHints: TWidestringList;
    _enableSet, _disableSet: TWidestringList;

public
    constructor Create(filters: TWidestringList = nil); overload;
    constructor Create(enableHints, disableHints: TWidestringList); overload;
    destructor Destroy; override;

    procedure update(item: IExodusItem);

    property ItemCount: Integer read _itemcount;
    property Enabling: TWidestringList read _enableSet;
    property Disabling: TWidestringList read _disableSet;
end;

type TPotentialActions = class(TObject)
private
    _itemtype: Widestring;
    _proxies: TWidestringList;
    _enableHints, _disableHints: TWidestringList;

    function GetProxyCount: Integer;
    function GetProxyAt(idx: Integer): TActionProxy;

public
    constructor Create(itemtype: Widestring);
    destructor Destroy; override;

    procedure updateProxy(proxy: TActionProxy);

    function GetProxyNamed(actname: Widestring): TActionProxy;

    property ItemType: Widestring read _itemtype;
    property ProxyCount: Integer read GetProxyCount;
    property Proxy[idx: Integer]: TActionProxy read GetProxyAt;

    property EnableHints: TWidestringList read _enableHints;
    property DisableHints: TWidestringList read _disableHints;
end;

type TExodusActionController = class(TAutoObject, IExodusActionController)
private
    _actions: TWidestringList;

    function lookupActionsFor(itemtype: Widestring; create: boolean): TPotentialActions;

public
    constructor Create;
    destructor Destroy; override;

    procedure registerAction(const itemtype: Widestring; const act: IExodusAction);
      safecall;
    procedure addEnableFilter(const ItemType, actname, filter: WideString);
      safecall;
    procedure addDisableFilter(const ItemType, actname, filter: WideString);
      safecall;
    function actionsForType(const itemtype: WideString): IExodusTypedActions;
      safecall;
    function buildActions(const items: IExodusItemList): IExodusActionMap;
      safecall;
end;

function GetActionController: IExodusActionController;

implementation

uses ComServ, Session, SysUtils;

var g_ActCtrl: IExodusActionController;

{
    TProxyAction implementation
}
Constructor TActionProxy.Create(itemtype, actname: Widestring);
begin
    inherited Create;

    _name := Copy(actname, 1, Length(actname));
    _itemtype := Copy(itemtype, 1, Length(itemtype));

    _enabling := TWidestringList.Create;
    _enabling.Duplicates := dupAccept;

    _disabling := TWidestringList.Create;
    _disabling.Duplicates := dupAccept;
end;

Destructor TActionProxy.Destroy;
var
    i: integer;
begin
    for i := 0 to _enabling.Count - 1 do
    begin
        TFilteringItem(_enabling.Objects[i]).Free();
    end;
    for i := 0 to _disabling.Count - 1 do
    begin
        TFilteringItem(_disabling.Objects[i]).Free();
    end;
    _enabling.Free;
    _disabling.Free;

    Action := nil;

    inherited;
end;

function TActionProxy.enabledContainsAll(actual: TWideStringList): Boolean;
var
    idx, jdx: Integer;
    eval, aval: TFilteringItem;
begin
    //Assume it does contain all
    Result := true;

    //make sure we're sorted (lookups are faster)
    if not _enabling.Sorted then _enabling.Sorted := true;
    if not actual.Sorted then actual.Sorted := true;

    for idx := 0 to _enabling.Count - 1 do begin
        eval := TFilteringItem(_enabling.Objects[idx]);

        jdx := actual.IndexOf(eval.Key);
        if (jdx <> -1) then begin
            aval := TFilteringItem(actual.Objects[jdx]);
            Result := (eval.Value = aval.Value);
        end;

        if not (Result) then exit;
    end;
end;
function TActionProxy.disabledContainsAny(actual: TWidestringList): Boolean;
var
    idx, jdx: Integer;
    eval, aval: TFilteringItem;
begin
    //Assume it doesn't contain any
    Result := false;

    //make sure we're sorted (lookups are faster)
    if not _disabling.Sorted then _disabling.Sorted := true;
    if not actual.Sorted then actual.Sorted := true;

    for idx := 0 to _disabling.Count - 1 do begin
        eval := TFilteringItem(_disabling.Objects[idx]);

        jdx := actual.IndexOf(eval.Key);
        if (jdx <> -1) then begin
            aval := TFilteringItem(actual.Objects[jdx]);
            Result := (eval.Value = aval.Value);
        end;

        if (Result) then exit;
    end;
end;

procedure TActionProxy.Set_Delegate(const act: IExodusAction);
begin
    if _delegate <> nil then
        _delegate._Release;

    _delegate := act;
    if _delegate <> nil then
        _delegate._AddRef;
end;

procedure TActionProxy.addToEnabling(filter: Widestring);
var
    fitem :TFilteringItem;
begin
    fitem := TFilteringItem.Create(filter);

    if _enabling.Sorted then
        _enabling.Sorted := false;
    _enabling.AddObject(fitem.Key, fitem);
    if fitem.Key = 'selection' then begin
        fitem := TFilteringItem.Create('global-selection', fitem.value);
        _enabling.AddObject(fitem.Key, fitem);
        fitem := TFilteringItem.Create('type-selection', fitem.value);
        _enabling.AddObject(fitem.Key, fitem);
    end;
end;
procedure TActionProxy.addToDisabling(filter: Widestring);
var
    fitem :TFilteringItem;
begin
    fitem := TFilteringItem.Create(filter);

    if _disabling.Sorted then
        _disabling.Sorted := false;

    _disabling.AddObject(fitem.Key, fitem);
    if fitem.Key = 'selection' then begin
        fitem := TFilteringItem.Create('global-selection', fitem.value);
        _disabling.AddObject(fitem.Key, fitem);
        fitem := TFilteringItem.Create('type-selection', fitem.value);
        _disabling.AddObject(fitem.Key, fitem);
    end;
end;

function TActionProxy.applies(enabling, disabling: TWideStringList): Boolean;
begin
    //Check for "Do I exist?"
    If (Action = nil) then begin
        Result := false;
        exit;
    end;

    //Check for "do or die"!
    If not Action.Enabled then begin
        Result := false;
        exit;
    end;

    //Check enabling (if any are present)
    Result := (_enabling.Count = 0) or enabledContainsAll(enabling);
    if not Result then exit;

    //Check disabling
    Result := (_disabling.Count = 0) or not disabledContainsAny(disabling);
    if not Result then exit;

    Result := true;
end;

{
    TFilteringItem implementation
}
constructor TFilteringItem.Create(item: WideString);
var
    place: Integer;

begin
    inherited Create;

    place := Pos('=', item);
    if (place > 0) then begin
        _key := Copy(item, 1, place-1);
        _val := Copy(item, place+1, Length(item));
    end else begin
        _key := item;
        _val := 'true';
    end;

    _key := StrLowerW(PWideChar(_key));
end;
constructor TFilteringItem.Create(key: WideString; val: WideString);
begin
    inherited Create;

    _key := StrLowerW(PWideChar(key));
    _val := val;
end;

destructor TFilteringItem.Destroy;
begin
    inherited Destroy;
end;
{
    TFilteringSet implementation
}
constructor TFilteringSet.Create(
        enableHints: TWideStringList;
        disableHints: TWideStringList);
begin
    _itemcount := 0;

    _enableSet := TWidestringList.Create;
    _enableHints := TWidestringList.Create;
    if (enableHints <> nil) and (enableHints.Count > 0) then
        _enableHints.Assign(enableHints);

    _disableSet := TWidestringList.Create;
    _disableHints := TWidestringList.Create;
    if (disableHints <> nil) and (disableHints.Count > 0) then
        _disableHints.Assign(disableHints);
end;
constructor TFilteringSet.Create(filters: TWideStringList);
var
    idx, jdx, loc: Integer;
    filter: TFilteringSet;
    fromList, toList: TWidestringList;
    fitem: TFilteringItem;
begin
    _itemcount := 0;

    _enableHints := TWidestringList.Create;
    _enableSet := TWidestringList.Create;

    _disableHints := TWidestringList.Create;
    _disableSet := TWidestringList.Create;

    if filters = nil then exit;

    //update hints
    for idx := 0 to filters.Count - 1 do begin
        filter := TFilteringSet(filters.Objects[idx]);

        toList := Self._disableHints;
        fromList := filter._disableHints;
        for jdx := 0 to fromList.Count - 1 do begin
            if (toList.IndexOf(fromList[jdx]) = -1) then
                toList.Add(fromList[jdx]);
        end;

        toList := Self._enableHints;
        fromList := filter._enableHints;
        for jdx := 0 to fromList.Count - 1 do begin
            if (toList.IndexOf(fromList[jdx]) = -1) then
                toList.Add(fromList[jdx]);
        end;
    end;

    //update sets
    for idx := 0 to filters.Count - 1 do begin
        filter := TFilteringSet(filters.Objects[idx]);

        //Update disable sets (unions)
        toList := Self._disableSet;
        fromList := filter._disableSet;
        for jdx := fromList.Count - 1 downto 1 do begin
            if _disableHints.IndexOf(fromList[jdx]) = -1 then
                continue;

            loc := toList.IndexOf(fromList[idx]);
            if (loc <> -1) then begin
                if TFilteringItem(toList.Objects[loc]).Value = TFilteringItem(fromList.Objects[jdx]).Value then
                    continue;
            end;

            fitem := TFilteringItem(fromList.Objects[jdx]);
            fitem := TFilteringItem.Create(fitem.Key, fitem.Value);

            toList.AddObject(fromList[jdx], fitem);
        end;

        //Update enable sets (intersection)
        toList := Self._enableSet;
        fromList := filter._enableSet;
        for jdx := fromList.Count - 1 downto 0 do begin
            if _enableHints.IndexOf(fromList[jdx]) = -1 then
                continue;

            loc := toList.IndexOf(fromList[jdx]);
            if (loc <> -1) then begin
                fitem := TFilteringItem(fromList.Objects[jdx]);
                if TFilteringItem(toList.Objects[loc]).Value <> fitem.Value then begin
                    fitem.Free;
                    toList.Delete(loc);
                    loc := _enableHints.IndexOf(fromList[jdx]);
                    if (loc <> -1) then _enableHints.Delete(loc);
                end;
            end else begin
                fitem := TFilteringItem(fromList.Objects[jdx]);
                fitem := TFilteringItem.Create(fitem.Key, fitem.Value);

                toList.AddObject(fromList[jdx], fitem);
            end;
        end;
    end;
end;
destructor TFilteringSet.Destroy;
var
    idx: Integer;
    fitem: TFilteringItem;
begin
    for idx := 0 to _enableHints.Count - 1 do begin
        _enableHints.Objects[idx] := nil;
    end;
    _enableHints.Free;

    for idx := 0 to _enableSet.Count - 1 do begin
        fitem := TFilteringItem(_enableSet.Objects[idx]);
        _enableSet.Objects[idx] := nil;
        fitem.Free;
    end;
    _enableSet.Free;

    for idx := 0 to _disableHints.Count - 1 do begin
        _disableHints.Objects[idx] := nil;
    end;
    _disableHints.Free;
    for idx := 0 to _disableSet.Count - 1 do begin
        fitem := TFilteringItem(_disableSet.Objects[idx]);
        _disableSet.Objects[idx] := nil;
        fitem.Free;
    end;
    _disableSet.Free;

    inherited Destroy;
end;

procedure TFilteringSet.update(item: IExodusItem);
var
    key, val: Widestring;
    idx, place: Integer;
    currItem, foundItem: TFilteringItem;

    function lookupKeyValue: Boolean;
    begin
        Result := true;

        if (key = 'selection') or (key = 'type-selection') or (key = 'global-selection') then
            Result := false     //ignore this hint (always present)
        else if (key = 'type') then
            val := item.Type_
        else if (key = 'active') then
            val := StrLowerW(PWideChar(BoolToStr(item.Active, true)))
        else if (key = 'visible') then
            val := StrLowerW(PWideChar(BoolToStr(item.Active, true)))
        else begin
            //TODO:  strip off "property." ?
            val := item.value[key];
        end;
    end;
begin
    Inc(_itemcount);

    //Update disabling (walk backwards, so we can remove things)
    for idx := _disableHints.Count - 1 downto 0 do begin
        key := _disableHints[idx];
        if not lookupKeyValue then continue;

        //don't care if it's already present...
        currItem := TFilteringItem.Create(key, val);
        _disableSet.AddObject(key, currItem);
    end;

    //Update enabling
    for idx := _enableHints.Count - 1 downto 0 do begin
        key := _enableHints[idx];
        if not lookupKeyValue then continue;

        //now we care if it's already there...
        place := _enableSet.IndexOf(key);
        if place = -1 then //brand-new!
            _enableSet.AddObject(key, TFilteringItem.Create(key, val))
        else begin
            foundItem := TFilteringItem(_enableSet.Objects[place]);
            if foundItem.Value <> val then begin
                //remove item and hint
                foundItem.Free;
                _enableSet.Delete(place);
                _enableHints.Delete(idx);
            end;
        end;
    end;
end;

{
    TPotentialActions implementation
}
constructor TPotentialActions.Create(itemtype: WideString);
begin
    inherited Create;

    _itemtype := Copy(itemtype, 1, Length(itemtype));
    _proxies := TWidestringList.Create;
    _enableHints := TWidestringList.Create;
    _disableHints := TWidestringList.Create;
end;

destructor TPotentialActions.Destroy;
var
    i: integer;
begin
    _enableHints.Free;
    _disableHints.Free;
    for i := 0 to _proxies.Count - 1 do
    begin
        TActionProxy(_proxies.Objects[i]).Free();
    end;
    _proxies.Free;

    inherited;
end;

function TPotentialActions.GetProxyCount;
begin
    Result := _proxies.Count;
end;
function TPotentialActions.GetProxyAt(idx: Integer): TActionProxy;
begin
    Result := TActionProxy(_proxies.Objects[idx]);
end;
function TPotentialActions.GetProxyNamed(actname: WideString): TActionProxy;
var
    idx: Integer;
begin
    idx := _proxies.IndexOf(actname);
    if (idx <> -1) then
        Result := TActionProxy(_proxies.Objects[idx])
    else
        Result := nil;
end;

procedure TPotentialActions.updateProxy(proxy: TActionProxy);
var
    idx: Integer;
    filter: TWidestringList;
    hint: Widestring;
begin
    //add if missing
    if (_proxies.IndexOf(proxy.Name) = -1) then
        _proxies.AddObject(proxy.Name, proxy);

    //update hints
    filter := proxy.EnablingFilter;
    for idx := 0 to filter.Count - 1 do begin
        hint := filter[idx];
        if (_enableHints.IndexOf(hint) = -1) then _enableHints.Add(hint);
    end;

    filter := proxy.DisablingFilter;
    for idx := 0 to filter.Count - 1 do begin
        hint := filter[idx];
        if (_disableHints.IndexOf(hint) = -1) then _disableHints.Add(hint);
    end;
end;

{
    TExodusActionController implementation
}
constructor TExodusActionController.Create;
begin
    inherited;

    _actions := TWidestringList.Create;
end;

destructor TExodusActionController.Destroy;
var
    i: integer;
begin
    for i := 0 to _actions.Count - 1 do
    begin
        TPotentialActions(_actions.Objects[i]).Free();
    end;
    _actions.Clear;
    _actions.Free;

    inherited;
end;

function TExodusActionController.lookupActionsFor(
        itemtype: WideString;
        create: Boolean): TPotentialActions;
var
    idx: Integer;
begin
    idx := _actions.IndexOf(itemtype);
    if (idx <> -1) then
        Result := TPotentialActions(_actions.Objects[idx])
    else if not create then
        Result := nil
    else begin
        Result := TPotentialActions.Create(itemtype);
        _actions.AddObject(itemtype, Result);
    end;
end;

procedure TExodusActionController.registerAction(
        const itemtype: WideString;
        const act: IExodusAction);
var
    list: TPotentialActions;
    proxy: TActionProxy;
begin
    //graceful fail
    if (act = nil) then exit;

    list := lookupActionsFor(itemtype, true);
    proxy := list.GetProxyNamed(act.name);
    if (proxy = nil) then proxy := TActionProxy.Create(itemtype, act.name);

    proxy.Action := act;
    list.updateProxy(proxy);
end;

procedure TExodusActionController.addEnableFilter(const ItemType, actname,
  filter: WideString);
var
    list: TPotentialActions;
    proxy: TActionProxy;
begin
    //graceful fail
    if (filter = '') then exit;

    //get appropriate potentials and proxy
    list := lookupActionsFor(itemtype, true);
    proxy := list.GetProxyNamed(actname);
    if (proxy = nil) then proxy := TActionProxy.Create(itemtype, actname);

    proxy.addToEnabling(filter);
    list.updateProxy(proxy);
end;
procedure TExodusActionController.addDisableFilter(const ItemType, actname,
  filter: WideString);
var
    list: TPotentialActions;
    proxy: TActionProxy;
begin
    //graceful fail
    if (filter = '') then exit;

    //get appropriate potentials and proxy
    list := lookupActionsFor(itemtype, true);
    proxy := list.GetProxyNamed(actname);
    if (proxy = nil) then proxy := TActionProxy.Create(itemtype, actname);

    proxy.addToDisabling(filter);
    list.updateProxy(proxy);
end;

function TExodusActionController.actionsForType(
  const itemtype: WideString): IExodusTypedActions;
var
    typedActs: TExodusTypedActions;
    potentials: TPotentialActions;
    idx: Integer;
    proxy: TActionProxy;
    act: IExodusAction;
begin
    typedActs := TExodusTypedActions.Create(itemtype);
    potentials := lookupActionsFor(itemtype, false);

    if (potentials <> nil) then begin
        for idx := 0 to potentials.ProxyCount - 1 do begin
            proxy := potentials.Proxy[idx];
            act := proxy.Action;

            if (act <> nil) and act.Enabled then
                typedActs.AddAction(act);
        end;
    end;

    Result := typedActs as IExodusTypedActions;
end;

type TActionBuildModeType = (abmNone, abmSingleOther, abmSingleGroup, abmMulti);
type TActionBuildInfo = class
public
    Enabling, Disabling: TWidestringList;
    AllInterests: TWidestringList;
    MainInterests: TFilteringSet;

    constructor Create();
    destructor Destroy(); override;
end;
constructor TActionBuildInfo.Create;
begin
    Enabling := TWidestringList.Create();
    Disabling := TWidestringList.Create();

    AllInterests := TWidestringList.Create();
    AllInterests.Sorted := true;
end;
destructor TActionBuildInfo.Destroy;
begin
    FreeAndNil(Enabling);
    FreeAndNil(Disabling);
    FreeAndNil(AllInterests);
    FreeAndNil(MainInterests);

    inherited;
end;


function TExodusActionController.buildActions(
    const items: IExodusItemList): IExodusActionMap;
var
    actmap: TExodusActionMap;
    info: TActionBuildInfo;
    mode: TActionBuildModeType;
    applied: TObjectList;
    idx: Integer;
    typedActs, mainActs: TExodusTypedActions;

    procedure _PopulateItemDescendants(
            group: Widestring;
            items: IExodusItemList);
    var
        subitems: IExodusItemList;
        subitem: IExodusItem;
        idx: Integer;
    begin
        subitems := MainSession.ItemController.GetGroupItems(group);
        for idx := 0 to subitems.Count - 1 do begin
            subitem := subitems.Item[idx];
            if subitem.Type_ = 'group' then
                _PopulateItemDescendants(subitem.UID, items)
            else if subitem.IsVisible then
                items.Add(subitem);
        end;
    end;
    function _DetermineMode(items: IExodusItemList): TActionBuildModeType;
    var
        idx, size: Integer;
    begin
        case items.Count of
            1: with items.Item[0] do begin
                if (Type_ <> 'group') then
                    Result := abmSingleOther
                else begin
                    Result := abmSingleGroup;

                    _PopulateItemDescendants(UID, items);
                end;
            end;
        else
            Result := abmMulti;
            size := items.Count;
            for idx := size - 1 downto 0 do begin
                with items.Item[idx] do begin
                    if Type_ = 'group' then
                        _PopulateItemDescendants(UID, items);
                end;
            end;
        end;
    end;
    function _DetermineFilters(items: IExodusItemList): TActionBuildInfo;
    var
        idx, jdx: Integer;
        item: IExodusItem;
        potentials: TPotentialActions;
        typedInterests: TFilteringSet;
    begin
        Result := TActionBuildInfo.Create();
        with Result do for idx := 0 to items.Count - 1 do begin
            item := items.Item[idx];

            potentials := lookupActionsFor(item.Type_, false);
            if (potentials <> nil) then begin
                jdx := allInterests.IndexOf(potentials.ItemType);
                if (jdx <> -1) then begin
                    typedInterests := TFilteringSet(allInterests.Objects[jdx]);
                end else begin
                    for jdx := 0 to potentials.EnableHints.Count - 1 do
                        enabling.Add(potentials.EnableHints[jdx]);
                    for jdx := 0 to potentials.DisableHints.Count - 1 do
                        disabling.Add(potentials.DisableHints[jdx]);
                    typedInterests := TFilteringSet.Create(
                            potentials.EnableHints,
                            potentials.DisableHints);
                    allInterests.AddObject(potentials.ItemType, typedInterests);
                end;

                typedInterests.update(item);
            end;
        end;
        Result.mainInterests := TFilteringSet.Create(Result.enabling, Result.disabling);
        for idx := 0 to items.Count - 1 do begin
            Result.mainInterests.update(item);
        end;
        case items.Count of
            1: begin
                Result.mainInterests.Disabling.AddObject('global-selection',
                        TFilteringItem.Create('global-selection','single'));
                Result.mainInterests.Enabling.AddObject('global-selection',
                        TFilteringItem.Create('global-selection','single'));
            end;
            else begin
                Result.mainInterests.Disabling.AddObject('global-selection',
                        TFilteringItem.Create('global-selection','multi'));
                Result.mainInterests.Enabling.AddObject('global-selection',
                        TFilteringItem.Create('global-selection','multi'));
            end;
        end;
    end;
    procedure _DetermineActionsForType(
            itemtype: Widestring;
            typedInterests: TFilteringSet;
            applied: TObjectList);
    var
        jdx: Integer;
        potentials: TPotentialActions;
        typedActs: TExodusTypedActions;
        proxy: TActionProxy;
    begin
        potentials := lookupActionsFor(itemtype, false);

        case typedInterests.ItemCount of
            1: begin
                typedInterests.Disabling.AddObject('type-selection',
                        TFilteringItem.Create('type-selection','single'));
                typedInterests.Enabling.AddObject('type-selection',
                        TFilteringItem.Create('type-selection','single'));
            end;
            else begin
                typedInterests.Disabling.AddObject('type-selection',
                        TFilteringItem.Create('type-selection','multi'));
                typedInterests.Enabling.AddObject('type-selection',
                        TFilteringItem.Create('type-selection','multi'));
            end;
        end;

        //make sure the list exists (so we don't accidentally get single-type main actions)
        typedActs := actmap.LookupTypedActions(itemtype, true);

        //add applicable typed actions to actionmap
        for jdx := 0 to potentials.ProxyCount - 1 do begin
            proxy := potentials.Proxy[jdx];

            if proxy.applies(typedInterests.Enabling, typedInterests.Disabling) then begin
                if (applied.IndexOf(proxy) = -1) then
                    applied.Add(proxy);
                typedActs.AddAction(proxy.Action);
            end;
        end;

        //add applicable "anytype" actions to actionmap
        potentials := lookupActionsFor('', true);
        for jdx := 0 to potentials.ProxyCount - 1 do begin
            proxy := potentials.Proxy[jdx];

            if proxy.applies(typedInterests.Enabling, typedInterests.Disabling) then begin
                if (applied.IndexOf(proxy) = -1) then
                    applied.Add(proxy);
                typedActs.AddAction(proxy.Action);
            end;
        end;

        //Free up typed interests now
        typedInterests.Free;
    end;
    procedure _BuildMainActions(info: TActionBuildInfo);
    var
        mainActs, typedActs: TExodusTypedActions;
        itemtype: Widestring;
        proxy: TActionProxy;
        idx, jdx: Integer;
    begin
        mainActs := actMap.LookupTypedActions('', true);
        with info do for idx := 0 to applied.Count - 1 do begin
            proxy := TActionProxy(applied[idx]);
            if not proxy.applies(mainInterests.Enabling, mainInterests.Disabling) then
                continue;

            for jdx := 0 to allInterests.Count - 1 do begin
                itemtype := allInterests[jdx];
                typedActs := actMap.LookupTypedActions(itemtype, false);
                if (typedActs.GetActionNamed(proxy.Name) <> proxy.Action) then begin
                    proxy := nil;
                    break;
                end;
            end;

            if (proxy <> nil) then
                mainActs.AddAction(proxy.Action);
        end;
    end;
    
begin
    actmap := TExodusActionMap.Create(items);
    Result := actmap as IExodusActionMap;

    mode := _DetermineMode(actmap.GetAllItems());
    if (mode = abmNone) then exit;
    
    info := _DetermineFilters(actmap.GetAllItems());

    //Find type-specific actions
    applied := TObjectList.Create();
    applied.OwnsObjects := false;
    with info do for idx := 0 to AllInterests.Count - 1 do begin
        _DetermineActionsForType(
                AllInterests[idx],
                TFilteringSet(AllInterests.Objects[idx]),
                applied);
    end;

    //Assemble main actions
    case mode of
        abmSingleOther: begin
            //(the only) type-specific actions are main actions
            typedActs := actmap.LookupTypedActions(actmap.Get_Item(0).Type_, true);

            //copy type-specific into main
            mainActs := actmap.LookupTypedActions('', true);
            mainActs.Clear();
            for idx := 0 to typedActs.Get_ActionCount() - 1 do
                mainActs.AddAction(typedActs.Get_Action(idx));
            for idx := 0 to typedActs.Get_ItemCount() - 1 do
                mainActs.Set_Item(idx, typedActs.Get_Item(idx));

            //remove type-specific actions
            actmap.DeleteTypedActions(typedActs);
        end;
        abmSingleGroup: begin
            //group actions are main actions
            typedActs := actmap.LookupTypedActions('group', true);

            //copy group actions into main
            mainActs := actmap.LookupTypedActions('', true);
            mainActs.Clear();
            for idx := 0 to typedActs.Get_ActionCount() - 1 do
                mainActs.AddAction(typedActs.Get_Action(idx));
            for idx := 0 to typedActs.Get_ItemCount() - 1 do
                mainActs.Set_Item(idx, typedActs.Get_Item(idx));

            //remove group actions
            actmap.DeleteTypedActions(typedActs);
        end;
        abmMulti: begin
            //main actions are an intersection of all type-specific actions
            //  (but are further filtered by selection=multi)
            _BuildMainActions(info);
        end;
    end;

    FreeAndNil(info);
    FreeAndNil(applied);
end;


function GetActionController: IExodusActionController;
begin
    if (g_ActCtrl = nil) then begin
        g_ActCtrl := TExodusActionController.Create;
        g_ActCtrl._AddRef;
    end;
    Result := g_actCtrl as IExodusActionController;
end;

initialization
    g_ActCtrl := nil;
    TAutoObjectFactory.Create(ComServer,
            TExodusActionController,
            CLASS_ExodusActionController,
            ciMultiInstance, tmApartment);


finalization
    // Cleanup memory
    if (g_ActCtrl <> nil) then g_ActCtrl._Release();
    

end.
