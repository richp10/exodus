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
unit CommonActions;

interface

uses Exodus_TLB, ExActions;

type
    TRenameItemAction = class(TExBaseAction)
    private
        constructor Create();

    public
        destructor Destroy(); override;

        procedure execute(const items: IExodusItemList); override;

    end;

    TDeleteItemAction = class(TExBaseAction)
    private
        constructor Create();

    public
        destructor Destroy(); override;

        procedure execute(const items: IExodusItemList); override;
    end;

implementation

uses COMExodusItemList, DisplayName, ExActionCtrl, Forms, gnugettext,
        GroupParser, InputPassword, Session, SysUtils, Windows;

const
    sRenameTitle: Widestring = 'Rename %s';
    sRenameText: Widestring = 'New name for this %s: ';

    sDeleteConfirmTitle: Widestring = 'Globally Delete Item(s)';
    sDeleteConfirmSingleText: Widestring = 'Are you sure you want to delete "%s" completely from your contact list?' +
            #13#10 + #13#10 +
            'NOTE: This action will remove all references of this item from all groups in your contact list.';
    sDeleteConfirmMultiText: Widestring = 'Are you sure you want to delete these %d items completely from your contact list?' +
            #13#10 + #13#10 +
            'NOTE: This action will remove all references of these items from all groups in your contact list.';
    sDeleteWarnFailedSingleTxt: Widestring = 'The group "%s" is not empty and could not be deleted.' +
            #13#10 + 'Make sure all items in the group are removed, then try again.';
    sDeleteWarnFailedMultiTxt: Widestring = '%d groups are not empty and could not be deleted.' +
            #13#10 + 'Make sure all items in the groups areremoved, then try again.';

constructor TRenameItemAction.Create();
begin
    inherited Create('{000-exodus.googlecode.com}-150-rename');

    Set_Caption(_('Rename...'));
    Set_Enabled(true);
end;
destructor TRenameItemAction.Destroy;
begin
    inherited;
end;

procedure TRenameItemAction.execute(const items: IExodusItemList);
var
    parser: TGroupParser;
    dnc: TDisplayNameCache;
    idx: Integer;
    itemCtrl: IExodusItemController;
    subitems: IExodusItemList;
    item: IExodusItem;
    name, path: Widestring;
begin
    if items.Count <> 1 then exit;

    item := items.Item[0];
    if (item.Type_ = 'group') then begin
        //This is effectively a group move
        parser := TGroupParser.Create(MainSession);
        name := parser.GetGroupName(item.UID);

        if not InputQueryW(
                WideFormat(_(sRenameTitle), [item.Type_]),
                WideFormat(_(sRenameText), [item.Type_]),
                name) then
            exit;

        path := parser.GetGroupParent(item.UID);
        if (path <> '') then
            path := path + parser.Separator + name
        else
            path := name;
        itemCtrl := MainSession.ItemController;

        //add group explicitly
        itemCtrl.AddGroup(path);

        //move subitems to new group
        subitems := itemCtrl.GetGroupItems(item.UID);
        for idx := 0 to subitems.Count - 1 do begin
            itemCtrl.MoveItem(subitems.Item[idx].UID, item.UID, path);
        end;
        itemCtrl.GroupExpanded[path] := itemCtrl.GroupExpanded[item.UID];

        //delete group
        itemCtrl.RemoveItem(item.UID);

        //let everyone know about the path should be expanded!
        item := itemCtrl.GetItem(path);
        MainSession.FireEvent('/data/item/group/restore', nil, '');
    end
    else begin
        //This updates the displayname cache
        name := item.value['Name'];

        if not InputQueryW(
                WideFormat(_(sRenameTitle), [item.Type_]),
                WideFormat(_(sRenameText), [item.Type_]),
                name) then
            exit;

        dnc := getDisplayNameCache();
            
        item.value['Name'] := name;
        dnc.UpdateDisplayName(item);
        MainSession.FireEvent('/item/update', item);
    end;
end;

constructor TDeleteItemAction.Create;
begin
    inherited Create('{000-exodus.googlecode.com}-190-delete');

    set_Caption(_('Delete Globally'));
    set_Enabled(true);
end;
destructor TDeleteItemAction.Destroy;
begin
    inherited;
end;

procedure TDeleteItemAction.execute(const items: IExodusItemList);
var
    msg: Widestring;
    idx, jdx, rst: Integer;
    itemCtrl: IExodusItemController;
    postitems, collateralitems: IExodusItemList;
    item: IExodusItem;

    function EmptyGroup(gpath: Widestring): Boolean;
    var
        idx: Integer;
        subitems: IExodusItemList;
    begin
        Result := true;
        subitems := itemCtrl.GetGroupItems(gpath);
        for idx := 0 to subitems.Count - 1 do begin
            if (subitems.Item[idx].Type_ = 'group') then
                Result := EmptyGroup(subitems.Item[idx].UID)
            else
                Result := false;

            if not Result then exit;
        end;
    end;
begin
    //confirm
    if (items = nil) or (items.Count = 0) then exit;

    if (items.Count = 1) then
        msg := WideFormat(_(sDeleteConfirmSingleText), [items.Item[0].Text])
    else
        msg := WideFormat(_(sDeleteConfirmMultiText), [items.Count]);

    rst := MessageBoxW(Application.Handle,
            PWideChar(msg),
            PWideChar(_(sDeleteConfirmTitle)),
            MB_ICONWARNING or MB_YESNO);
    if (rst <> IDYES) then exit;

    //process non-groups
    itemCtrl := MainSession.ItemController;
    postitems := TExodusItemList.Create();
    for idx := 0 to items.Count - 1 do begin
        item := items.Item[idx];
        if (item.Type_ = 'group') then
            postitems.Add(item)
        else begin
            //remove from existence!
            itemCtrl.RemoveItem(item.UID);
        end;
    end;

    //process groups
    collateralitems := TExodusItemList.Create();
    for idx := postitems.Count - 1 downto 0 do begin
        collateralitems.Clear();
        item := postitems.Item[idx];

        //validate target is empty
        if not EmptyGroup(item.UID) then continue;

        //delete collateral groups
        for jdx := 0 to collateralitems.Count - 1 do begin
            itemCtrl.RemoveItem(collateralitems.Item[idx].UID);
        end;

        //delete target group
        postitems.Delete(idx);
        itemCtrl.RemoveItem(item.UID);
    end;

    //alert
    if postitems.Count > 0 then begin
        case postitems.Count of
            1: msg := WideFormat(_(sDeleteWarnFailedSingleTxt), [postitems.Item[0].Text]);
        else
            msg := WideFormat(_(sDeleteWarnFailedMultiTxt), [postitems.Count]);
        end;
        MessageBoxW(Application.Handle,
            PWideChar(msg),
            PWideChar(_(sDeleteConfirmTitle)),
            MB_ICONWARNING or MB_OK);
    end;
end;

procedure RegisterActions();
var
    actCtrl: IExodusActionController;
    act: IExodusAction;
begin
    actCtrl := GetActionController();

    act := TRenameItemAction.Create();
    actCtrl.registerAction('', act);
    actCtrl.addEnableFilter('', act.Name, 'selection=single');

    act := TDeleteItemAction.Create();
    actCtrl.registerAction('', act);
    actCtrl.addEnableFilter('', act.Name, 'selection=single');
    //actCtrl.addDisableFilter('', act.Name, 'type=group');
end;

initialization
    RegisterActions();

end.
