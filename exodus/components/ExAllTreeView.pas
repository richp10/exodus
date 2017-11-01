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

unit ExAllTreeView;

interface

uses SysUtils, Classes, Controls, DropTarget, ExTreeView, Exodus_TLB, Types, TntMenus, ComCtrls;

type
  TTreeDragSelectionType = (tdstNone, tdstGroup, tdstOther);
  TExAllTreeView = class(TExTreeView)
  private
    _mnuCopy: TTntMenuItem;
    _mnuMove: TTntMenuItem;
    _mnuDelete: TTntMenuItem;

    _dropSupport: TExDropTarget;


  protected
    procedure DoContextPopup(MousePos: TPoint; var Handled: Boolean); override;
    procedure Expand(node: TTreeNode); override;
    procedure Collapse(node: TTreeNode); override;
    
    procedure _DragUpdate(Source: TExDropTarget; X, Y: Integer; var Action: TExDropActionType);
    procedure _DragExecute(Source: TExDropTarget; X, Y: Integer);

    procedure mnuMoveClick(Sender: TObject); virtual;
    procedure mnuCopyClick(Sender: TObject); virtual;
    procedure mnuDeleteClick(Sender: TObject); virtual;
    procedure SaveGroupsState(); override;

    function FilterItem(item: IExodusItem): Boolean; override;
    procedure _SetFilterType(filtertype: Widestring); override;
  public
    constructor Create(AOwner: TComponent; Session: TObject); override;

    procedure DragOver(Source: TObject;
            X, Y: Integer;
            state: TDragState;
            var accept: Boolean); override;
    procedure DragDrop(Source: TObject;
            X, Y: Integer); override;

  end;

implementation

uses ActionMenus, Graphics, ExActionCtrl, ExUtils, gnugettext, GrpManagement, Forms,
        Messages, COMExodusItem, COMExodusItemList, Session, TntComCtrls, Windows,
        ChatWin, Room, Jabber1, RosterImages;

const
    sConfirmDeleteCaption: Widestring = 'Delete Item(s)';
    sConfirmDeleteSingleTxt: Widestring = 'Are you sure you want to delete the item, %s?';
    sConfirmDeleteMultiTxt: Widestring = 'Are you sure you want to delete these %d items?';
    sWarnSingleNotDeletedTxt: Widestring = 'The group %s is not empty and could not be deleted.' + #13#10 + 'Make sure all items in the group are removed, then try again.';
    sWarnMultiNotDeletedTxt: Widestring = '%d groups are not empty and could not be deleted.' + #13#10 + 'Make sure all items in the groups areremoved, then try again.';

    SCROLL_MARGIN: Integer = 20;

{---------------------------------------}
constructor TExAllTreeView.Create(AOwner: TComponent; Session: TObject);
var
    popup: TExActionPopupMenu;
    mi: TTntMenuItem;
begin
    inherited Create(AOwner, Session);

    DragMode := dmAutomatic;

    popup := TExActionPopupMenu.Create(Self);
    popup.ActionController := GetActionController();
    popup.Excludes.Add('{000-exodus.googlecode.com}-190-delete');

    mi := TTntMenuItem.Create(popup.Items);
    mi.Caption := _('Move...');
    mi.OnClick := mnuMoveClick;
    popup.Items.Add(mi);
    _mnuMove := mi;

    mi := TTntMenuItem.Create(popup.Items);
    mi.Caption := _('Copy...');
    mi.OnClick := mnuCopyClick;
    popup.Items.Add(mi);
    _mnuCopy := mi;

    mi := TTntMenuItem.Create(popup.Items);
    mi.Caption := _('Delete');
    mi.OnClick := mnuDeleteClick;
    popup.Items.Add(mi);
    _mnuDelete := mi;

    PopupMenu := popup;
end;

procedure TExAllTreeView._SetFilterType(filtertype: Widestring);
var
    idx: Integer;
    popup: TExActionPopupMenu;
begin
    if filtertype = _Filter then exit;

    _Filter := filtertype;
    if (PopupMenu is TExActionPopupMenu) then begin
        popup := TExActionPopupMenu(PopupMenu);
        idx := popup.Excludes.IndexOf('{000-exodus.googlecode.com}-090-add-subgroup');
        if (_Filter <> '') then
            popup.Excludes.Add('{000-exodus.googlecode.com}-090-add-subgroup')
        else if (idx <> -1) then
             popup.Excludes.Delete(idx);
    end;
end;
procedure TExAllTreeView.DoContextPopup(MousePos: TPoint; var Handled: Boolean);
var
    actPM: TExActionPopupMenu;
    pt: TPoint;
begin
    if Assigned(PopupMenu) and PopupMenu.InheritsFrom(TExActionPopupMenu) then begin
        if (PopupMenu.Images = nil) then begin
            PopupMenu.Images := frmExodus.ImageList1;
        end;
        actPM := TExActionPopupMenu(PopupMenu);
        actPM.Targets := GetSelectedItems();
        _mnuCopy.Visible := (SelectionCount > 0);
        _mnuMove.Visible := (SelectionCount > 0);
        _mnuDelete.Visible := (SelectionCount > 0);

        if InvalidPoint(MousePos) then
            pt := Point(0,0)
        else
            pt := MousePos;

        pt := ClientToScreen(pt);
        actPM.Popup(pt.X, pt.Y);

        Handled := true;
    end;
end;
procedure TExAllTreeView.Expand(node: TTreeNode);
var
    item: IExodusItem;
begin
    inherited Expand(node);
    item := GetNodeItem(node);
    if (item = nil) or (item.Type_ <> 'group') then exit;

    OutputDebugMsg('node "' + node.Text + '" expanded');
    TJabberSession(Session).ItemController.GroupExpanded[item.UID] := true;
end;
procedure TExAllTreeView.Collapse(node: TTreeNode);
var
    itemCtrl: IExodusItemController;
    item: IExodusItem;
    subitems: IExodusItemList;
    idx: Integer;
begin
    if (node = nil) then exit;
    
    inherited Collapse(node);
    
    item := GetNodeItem(node);
    if (item = nil) or (item.Type_ <> 'group') then exit;

    OutputDebugMsg('node "' + item.UID + '" collapsed');
    itemCtrl := TJabberSession(Session).ItemController;
    itemCtrl.GroupExpanded[item.UID] := false;

    //Now collapse the subgroups
    subitems := itemCtrl.GetGroupItems(item.UID);
    for idx := 0 to subitems.Count - 1 do begin
        item := subitems.Item[idx];
        if (item.Type_ <> 'group') then continue;
        Collapse(_GetNodeByUID(item.UID, TTntTreeNode(node)));
    end;
end;

procedure TExAllTreeView.mnuMoveClick(Sender: TObject);
var
    items: IExodusItemList;
begin
    items := GetSelectedItems();
    ShowGrpManagement(items, tgoMove);
end;
procedure TExAllTreeView.mnuCopyClick(Sender: TObject);
var
    items: IExodusItemList;
begin
    items := GetSelectedItems();
    ShowGrpManagement(items, tgoCopy);
end;
procedure TExAllTreeView.mnuDeleteClick(Sender: TObject);
var
    ops: TList;
    path, msg: Widestring;
    idx, jdx, rst: Integer;
    itemCtrl: IExodusItemController;
    postitems, collateralitems: IExodusItemList;
    item: IExodusItem;
    node: TTntTreeNode;

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
    case SelectionCount of
        0: exit;
        1: msg := WideFormat(_(sConfirmDeleteSingleTxt), [Selections[0].Text]);
    else
        msg := WideFormat(_(sConfirmDeleteMultiTxt), [SelectionCount]);
    end;

    rst := MessageBoxW(Self.Handle,
            PWideChar(msg),
            PWideChar(_(sConfirmDeleteCaption)),
            MB_ICONQUESTION or MB_YESNO);
    if (rst <> IDYES) then exit;

    ops := TList.Create();
    for idx := 0 to SelectionCount - 1 do
        ops.Add(Pointer(Selections[idx]));

    //process non-groups
    itemCtrl := TJabberSession(Session).ItemController;
    postitems := TExodusItemList.Create();
    for idx := 0 to ops.Count - 1 do begin
        node := TTntTreeNode(ops[idx]);
        item := GetNodeItem(node);
        if (item = nil) then continue;

        if (item.Type_ = 'group') then
            postitems.Add(item)
        else begin
            if (item.GroupCount > 1) then begin
                //TODO:  remove from group (parent node)
                path := GetNodePath(node.Parent);
                item.RemoveGroup(path);
            end
            else begin
                //remove from existence!
                itemCtrl.RemoveItem(item.UID);
            end;
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
            1: msg := WideFormat(_(sWarnSingleNotDeletedTxt), [postitems.Item[0].Text]);
        else
            msg := WideFormat(_(sWarnMultiNotDeletedTxt), [postitems.Count]);
        end;
        MessageBoxW(Self.Handle,
            PWideChar(msg),
            PWideChar(_(sConfirmDeleteCaption)),
            MB_OK or MB_ICONWARNING);
    end;
end;

procedure TExAllTreeView.DragOver(
        Source: TObject;
        X: Integer; Y: Integer;
        state: TDragState;
        var accept: Boolean);
var
    scrollMsg:  TWMVScroll;
begin
    case state of
        dsDragLeave: begin
            Self.DragCursor := crDrag;
            exit;
        end;
        dsDragEnter: begin
            //(re-) initialize support
            _dropSupport.Free();
            _dropSupport := OpenDropTarget(Source, _DragUpdate, _DragExecute);
        end;
        dsDragMove: begin
        end;
    end;

    accept := (_dropSupport <> nil) and _dropSupport.Update(X, Y);

    if not accept then begin
        //TODO:  revert cursor??
        inherited DragOver(Source, X, Y, state, accept);
    end;

    if (state = dsDragMove) then begin
        //See if we need to scroll...
        if (Y < SCROLL_MARGIN) then begin
            scrollMsg.Msg := WM_VSCROLL;
            scrollMsg.ScrollCode := SB_LINEUP;
            scrollMsg.Pos := 0;
            Self.Dispatch(scrollMsg);
        end
        else if (Y > (ClientHeight - SCROLL_MARGIN)) then begin
            scrollMsg.Msg := WM_VSCROLL;
            scrollMsg.ScrollCode := SB_LINEDOWN;
            scrollMsg.Pos := 0;
            Self.Dispatch(scrollMsg);
        end;
    end;
end;
procedure TExAllTreeView.DragDrop(Source: TObject; X: Integer; Y: Integer);
begin
    if (_dropSupport <> nil) then _dropSupport.Execute(X, Y);
end;

procedure TExAllTreeView._DragUpdate(Source: TExDroptarget;
    X: Integer; Y: Integer;
    var Action: TExDropActionType);
var
    target: IExodusItem;
    valid: Boolean;
    kbstate: TKeyboardState;
begin
    target := GetNodeItem(GetNodeAt(X, Y));
    if (target = nil) then begin
        valid := Source.DragItems.Count = Source.DragItems.CountOfType('group');
    end
    else begin
        valid := true;
    end;

    if valid then begin
        GetKeyboardState(kbstate);
        if ((kbstate[VK_CONTROL] and 128) <> 0) then
            Action := datCopy
        else
            Action := datMove;
    end
    else
        Action := datNone;
end;
procedure TExAllTreeView._DragExecute(Source: TExDropTarget; X: Integer; Y: Integer);
var
    itemCtrl: IExodusItemController;
    target: IExodusItem;
    rootgrp: Widestring;
    idx: Integer;

    function FindGroupAt(X, Y: Integer): IExodusItem;
    var
        node: TTntTreeNode;
        item: IExodusItem;
    begin
        Result := nil;
        node := GetNodeAt(X, Y);
        while (Result = nil) and (node <> nil) do begin
            item := GetNodeItem(node);
            node := node.Parent;
            if (item <> nil) and (item.Type_ = 'group') then
                Result := item;
        end;
    end;
begin
    target := FindGroupAt(X, Y);
    if (target <> nil) then begin
        //move/copy to given group
        rootgrp := target.UID;
    end
    else begin
        //move/copy to root...
        rootgrp := '';
    end;

    itemCtrl := TJabberSession(Session).ItemController;
    for idx := 0 to Source.DragItems.Count - 1 do begin
        case Source.DropAction of
            datCopy: itemCtrl.CopyItem(Source.DragItems.Item[idx].UID, rootgrp);
            datMove: itemCtrl.MoveItem(Source.DragItems.Item[idx].UID, '', rootgrp);
        end;
    end;
end;

{---------------------------------------}
//Iterates thorugh all the nodes and saves exapanded state for group nodes.
procedure  TExAllTreeView.SaveGroupsState();
var
    i: Integer;
    item: IExodusItem;
    Name: WideString;
begin
    if (_Filter <> '') then exit;
    
    for i := 0 to Items.Count - 1 do
    begin
        item := GetNodeItem(Items[i]);
        if (item = nil) or (item.Type_ <> EI_TYPE_GROUP) then
            continue;
        Name := GetNodePath(Items[i]);
        TJabberSession(_js).ItemController.GroupExpanded[Name] := Items[i].Expanded;
    end;

    TJabberSession(_js).ItemController.SaveGroups();

end;

function TExAllTreeView.FilterItem(item: IExodusItem): Boolean;
begin
    Result := inherited FilterItem(item);

    if Result and (_Filter <> '') then
        Result := (_Filter = Item.Type_);

    if Result then
        Result := Item.IsVisible;
end;
end.
