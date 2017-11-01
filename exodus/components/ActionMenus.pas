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
unit ActionMenus;

interface

uses Classes, Menus, TntMenus, Exodus_TLB, Unicode;

type TExActionPopupMenu = class(TTntPopupMenu)
private
    _actCtrl: IExodusActionController;
    _actMap: IExodusActionMap;
    _targets: IExodusItemList;
    _splitIdx: Integer;
    _excludes: TWidestringList;

    procedure SetTargets(targets: IExodusItemList);
    procedure SetExcludes(excludes: TWidestringList);

    procedure rebuild;
    function createTypedMenu(actList: IExodusTypedActions; parent: TMenuItem; offset: Integer = -1): Integer;
    function createSubMenu(itemtype: Widestring; act: IExodusAction; parent: TMenuItem): Integer;

protected
    procedure HandleClick(Sender: TObject);

public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure Popup(X, Y: Integer); override;

    property Excludes: TWidestringList read _excludes write SetExcludes;
    property Targets: IExodusItemList read _targets write SetTargets;
    property ActionController: IExodusActionController read _actCtrl write _actCtrl;
end;

procedure Register;

implementation

uses SysUtils, TntComCtrls, gnugettext, Variants;

type TExActionMenuItem = class(TTntMenuItem)
private
    _itemtype: Widestring;
    _actname: Widestring;

public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    property ItemType: Widestring read _itemtype write _itemtype;
    property ActionName: Widestring read _actname write _actname;
end;

{

}
constructor TExActionMenuItem.Create(AOwner: TComponent);
begin
    inherited Create(AOwner);
end;
destructor TExActionMenuItem.Destroy;
begin
    inherited;
end;

{

}
constructor TExActionPopupMenu.Create(AOwner: TComponent);
begin
    inherited;

    _excludes := TWidestringList.Create();
end;
destructor TExActionPopupMenu.Destroy;
begin
    Targets := nil;

    inherited;
end;

procedure TExActionPopupMenu.SetTargets(targets: IExodusItemList);
begin
    if (targets <> _targets) then begin
        _actMap := nil;
        _targets := targets;
    end;
end;
procedure TExActionPopupMenu.SetExcludes(excludes: TWideStringList);
var
    idx: Integer;
begin
    if (excludes <> _excludes) then begin
        _excludes.Clear();

        if excludes = nil then exit;

        for idx := 0 to excludes.Count - 1 do
            _excludes.AddObject(excludes[idx], excludes.Objects[idx]);
    end;
end;

procedure TExActionPopupMenu.HandleClick(Sender: TObject);
begin
    if (_actMap = nil) then exit;

    try
        with TExActionMenuItem(sender) do begin
            _actMap.GetActionsFor(ItemType).execute(ActionName);
        end;
    except
        //blind catch because Delphi + COM == chaos
    end;
end;

procedure TExActionPopupMenu.rebuild;
var
    mainActs, typedActs: IExodusTypedActions;
    itemtype: Widestring;
    idx, miCount: Integer;
    mi: TTntMenuItem;
begin
    miCount := 0;

    //Clear out the old (but not the static items)
    if (_splitIdx > 0) then begin
        for idx := _splitIdx - 1 downto 0 do begin
            Items.Delete(idx);
        end;
    end;

    //Remember the main actions...
    mainActs := _actMap.GetActionsFor('');

    //build type-specific actions
    for idx := 0 to _actMap.TypedActionsCount - 1 do begin
        typedActs := _actMap.TypedActions[idx];
        itemtype := typedActs.ItemType;

        if (typedActs = mainActs) then continue;

        //TODO:  better item type captions!
        mi := TExActionMenuItem.Create(Items);
        mi.Caption := _(itemtype + 's');
        if (createTypedMenu(typedActs, mi, miCount) > 0) then begin
            Items.Insert(0, mi);
            Inc(miCount);
        end
        else begin
            mi.Free();
        end;
    end;

    //build main actions
    if (mainActs <> nil) and (mainActs.ActionCount > 0) then begin
        //check to see if we need a separator
        if (miCount > 0) then begin
            if not Items.Items[miCount - 1].IsLine then begin
                mi := TTntMenuItem.Create(Items);
                mi.Caption := '-';
                Items.Insert(miCount, mi);
                Inc(miCount);
            end;
        end;

        miCount := miCount + createTypedMenu(mainActs, Items, miCount);
    end;

    if (miCount <> Items.Count) then begin
        //add splitter between dynamic and static actions
        mi := TTntMenuItem.Create(Items);
        mi.Caption := '-';
        Items.Insert(miCount, mi);
    end;

    //Remember where we're at...
    _splitIdx := miCount;
end;

function TExActionPopupMenu.createTypedMenu(
        actList: IExodusTypedActions;
        parent: TMenuItem;
        offset: Integer): Integer;
var
    idx, amt: Integer;
    act: IExodusAction;
    mi: TExActionMenuItem;
begin
    if (offset < 0) then offset := 0;
    if (offset > parent.Count) then offset := parent.Count;
    amt := 0;

    for idx := 0 to actList.ActionCount - 1 do begin
        act := actlist.Action[idx];
        if Excludes.IndexOf(act.Name) <> -1 then continue;

        mi := TExActionMenuItem.Create(parent);
        mi.ItemType := actList.ItemType;
        mi.ActionName := act.Name;
        mi.Caption := act.Caption;
        mi.ImageIndex := act.ImageIndex;

        if createSubMenu(actList.ItemType, act, mi) = 0 then
            mi.OnClick := HandleClick;

        parent.Insert(offset + amt, mi);
        Inc(amt);
    end;

    Result := amt;
end;
function TExActionPopupMenu.createSubMenu(
        itemtype: Widestring;
        act: IExodusAction;
        parent: TMenuItem): Integer;
var
    idx, amt: Integer;
    subact: IExodusAction;
    mi: TExActionMenuItem;
begin
    amt := act.SubActionCount;
    Result := amt;

    for idx := 0 to amt - 1 do begin
        subact := act.SubAction[idx];
        mi := TExActionMenuItem.Create(parent);

        mi.ItemType := itemtype;
        mi.ActionName := subact.Name;
        mi.Caption := subact.Caption;
        mi.ImageIndex := subact.ImageIndex;

        if createSubMenu(itemtype, subact, mi) = 0 then
            mi.OnClick := HandleClick;

        parent.Add(mi);
    end;
end;

procedure TExActionPopupMenu.Popup(X: Integer; Y: Integer);
begin
    _actMap := ActionController.buildActions(Targets);
    rebuild;

    inherited Popup(X, Y);
end;

procedure Register;
begin
    RegisterComponents('Exodus Components', [TExActionPopupMenu]);
end;

end.
