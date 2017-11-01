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

unit ExTreeView;

interface

uses
  SysUtils, Classes, Controls, TntComCtrls, XMLTag, Exodus_TLB,
  COMExodusItemWrapper, GroupParser, Types, ComCtrls, Contnrs, Messages, Unicode;

type

  TExTreeView = class(TTntTreeView, IExodusItemSelection)
  private
      { Private declarations }
      _SessionCB: Integer;
      _RosterCB: Integer;
      _DataCB: Integer;
      _GroupParser: TGroupParser;
      _StatusColor: Integer;
      _TotalsColor: Integer;
      _InactiveColor: Integer;
      _ShowGroupTotals: Boolean;
      _ShowStatus: Boolean;
      _CurrentNode: TTntTreeNode;
      _GroupSeparator: WideChar;
      _TabIndex: Integer;
      _LastHintNode: TTntTreeNode;
      _LastMouseMovePoint: TPoint;
      _AllowDefaultSelection: Boolean;
      _BatchUpdate: Boolean;
      _OldProc: TWndMethod;

      //Methods
      procedure _RosterCallback(Event: string; Item: IExodusItem);
      procedure _SessionCallback(Event: string; Tag: TXMLTag);
      procedure _GroupCallback(Event: string; Tag: TXMLTag; Data: WideString);

      function _GetWrapperByNode(Node: TTreeNode): TExodusItemWrapper;
      procedure WMKillFocus(var Message: TWMSetFocus); message WM_KILLFOCUS;
      function _MovingTowardsHover(X,Y: Integer) :Boolean;
      procedure _DeleteNode(node: TTreeNode);
      procedure _NewWndProc(var Msg: TMessage);
  protected
       _JS: TObject;
       _Filter: WideString;
      { Protected declarations }
      function _GetNodeByUID(UID: WideString; Cntr: TTreeNode = nil) : TTntTreeNode;
      
      function  GetItemNodes(Uid: WideString) : TObjectList; virtual;
      procedure UpdateItemNodes(Item: IExodusItem); virtual;
      function AddItemNode(Item: IExodusItem; Group: Widestring): TTntTreeNode; virtual;
      procedure UpdateItemNode(Node: TTntTreeNode); virtual;
      function  GetActiveCounts(Node: TTntTreeNode): Integer; virtual;
      function  GetLeavesCounts(Node: TTntTreeNode): Integer; virtual;
      function  GetContactCounts(Node: TTntTreeNode): Integer; virtual;
      procedure SaveGroupsState(); virtual;
      procedure RestoreGroupsState(); virtual;
      procedure CustomDrawItem(Sender: TCustomTreeView;
                               Node: TTreeNode;
                               State: TCustomDrawState;
                               var DefaultDraw: Boolean); virtual;
      procedure DrawNodeText(Node: TTntTreeNode;
                             State: TCustomDrawState;
                             Text, ExtendedText: Widestring);  virtual;
      procedure Editing(Sender: TObject; Node: TTreeNode; var AllowEdit: Boolean);
      function  FilterItem(Item: IExodusItem): Boolean; virtual;
      procedure Changing(Sender: TObject; Node: TTreeNode; var AllowChange: Boolean);
      procedure _SetFilterType(filtertype: Widestring); virtual;
      property CurrentNode: TTntTreeNode read _CurrentNode write _CurrentNode;

  public
      { Public declarations }
      constructor Create(AOwner: TComponent; Session: TObject); virtual;
      procedure CreateParams(var Params: TCreateParams); override;
      destructor Destroy(); override;
      procedure MouseDown(Button: TMouseButton;
                          Shift: TShiftState; X, Y: Integer);  override;
      procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
      procedure MouseLeave(Sender: TObject);
      procedure DblClick(); override;

      function  GetNodePath(Node: TTntTreeNode): WideString; virtual;
      function  GetSubgroups(Group: WideString): TWideStringList; virtual;
      function  GetSelectedItems(): IExodusItemList; virtual; safecall;
      procedure ActivateHover(); virtual;
      function GetNodeItem(node: TTreeNode): IExodusItem;

      //Properties
      property Session: TObject read _JS write _JS;
      procedure SetFontsAndColors();

      procedure Clear();
      procedure Refresh();
      procedure KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
      //Properties
      property TabIndex: Integer read _TabIndex write _TabIndex;
      property Filter: Widestring read _Filter write _SetFilterType;
  end;

const
    X_OF_Y_ONLINE = '(%s of %s online)';

//procedure Register;

implementation
uses Session, Graphics, Windows, ExUtils, CommCtrl, Jabber1,
     RosterImages, JabberID, ContactController, COMExodusItem, COMExodusItemList,
     ChatWin, {GroupInfo,} Room, Forms,
     ActionMenus, ExActionCtrl, TntMenus,
     gnugettext, RosterForm, ExItemHoverForm,
     COMExodusItemController;


procedure TExTreeView.CreateParams(var Params: TCreateParams);
begin
    inherited CreateParams(Params);
    Params.Style := Params.Style or $8000;
end;

{---------------------------------------}
constructor TExTreeView.Create(AOwner: TComponent; Session: TObject);
begin
    inherited Create(AOwner);

    Align := alClient;
    Anchors := [akLeft, akTop, akRight, akBottom];
    BorderStyle := bsNone;
    ShowButtons := true;    //buttons are owner-drawn (at least on XP)
    ShowLines := false;
    AutoExpand := false;
    HideSelection := false;
    MultiSelect := true;
    MultiSelectStyle := [msControlSelect, msShiftSelect, msVisibleOnly];
    RowSelect := true;
    SortType := stText;
    OnCustomDrawItem := CustomDrawItem;
    OnMouseLeave := MouseLeave;
    OnEditing := Editing;
    OnChanging := Changing;
    _JS :=  TJabberSession(Session);
    _RosterCB := TJabberSession(_JS).RegisterCallback(_RosterCallback, '/item');
    _SessionCB := TJabberSession(_JS).RegisterCallback(_SessionCallback, '/session');
    _DataCB := TJabberSession(_JS).RegisterCallback(_GroupCallback);
    _GroupSeparator := PWideChar(TJabberSession(_JS).Prefs.getString('group_seperator'))^;

    _GroupParser := TGroupParser.Create(_JS);
    _TotalsColor := TColor(RGB(130,143,154 ));
    _InactiveColor := TColor(RGB(130,143,154 ));
    Perform(TVM_SETITEMHEIGHT, -1, 0);
    _CurrentNode := nil;
    _TabIndex := -1;
    _LastHintNode := nil;
    ToolTips := false;
    _AllowDefaultSelection := false;
    _OldProc := Self.WindowProc;
    Self.WindowProc := _NewWndProc;
    Self.OnKeyDown := KeyDown;
end;

{---------------------------------------}
destructor TExTreeView.Destroy();
begin
    with TJabberSession(_js) do begin
        UnregisterCallback(_SessionCB);
        UnregisterCallback(_RosterCB);
        UnregisterCallback(_DataCB);
    end;
    Clear();

   _GroupParser.Free;
    Self.WindowProc := _OldProc;
   _OldProc := nil;
   inherited;
end;

{---------------------------------------}
procedure TExTreeView.SetFontsAndColors();
begin
    //Initialize fonts and colors
    _StatusColor := TColor(TJabberSession(_JS).Prefs.getInt('inline_color'));
    Color := TColor(TJabberSession(_JS).prefs.getInt('roster_bg'));
    Font.Name := TJabberSession(_JS).prefs.getString('roster_font_name');
    Font.Size := TJabberSession(_JS).prefs.getInt('roster_font_size');
    Font.Color := TColor(TJabberSession(_JS).prefs.getInt('roster_font_color'));
    Font.Charset := TJabberSession(_JS).prefs.getInt('roster_font_charset');
    Font.Style := [];
    if (TJabberSession(_JS).prefs.getBool('font_bold')) then
        Font.Style := Font.Style + [fsBold];
    if (TJabberSession(_JS).prefs.getBool('font_italic')) then
        Font.Style := Font.Style + [fsItalic];
    if (TJabberSession(_JS).prefs.getBool('font_underline')) then
        Font.Style := Font.Style + [fsUnderline];
    _ShowGroupTotals := TJabberSession(_JS).prefs.getBool('roster_groupcounts');
    _ShowStatus := TJabberSession(_JS).prefs.getBool('inline_status');
end;

{---------------------------------------}
procedure TExTreeView._RosterCallback(Event: string; Item: IExodusItem);
begin
  if Event = '/item/begin' then begin
      Self.Items.BeginUpdate;
      _BatchUpdate := true;
      exit;
  end;
  if event = '/item/end' then begin
     Self.Items.EndUpdate;
     _BatchUpdate := false;
     Invalidate;
     Update;
     exit;
  end;

  if (item = nil) then
      exit;

  if (Event = '/item/add') or (Event = '/item/update') or (event = '/item/remove') then begin
     UpdateItemNodes(Item);
     exit;
  end;


end;

{---------------------------------------}
procedure TExTreeView._SessionCallback(Event: string; Tag: TXMLTag);
begin
    //Force repaing if prefs have changed.
    if Event = '/session/prefs' then
    begin
        SetFontsAndColors();
        Invalidate();
    end
    else if (Event = '/session/disconnecting') then
    begin
         //SaveGroupsState();
    end
    else if (Event = '/session/disconnected') then begin
        //clear all nodes...
        Clear();
    end;
end;

{---------------------------------------}
procedure TExTreeView._GroupCallback(Event: string; Tag: TXMLTag; Data: WideString);
begin
    if Event = '/data/item/group/save' then
        SaveGroupsState()
    else
        if Event = '/data/item/group/restore' then
            RestoreGroupsState();

end;


function TExTreeView.AddItemNode(Item: IExodusItem; Group: Widestring): TTntTreeNode;
var
    ctrl: IExodusItemController;
    pNode: TTntTreeNode;
    wrapper: TExodusItemWrapper;
begin
    ctrl := TJabberSession(_JS).ItemController;

    if (Group = '') then
        //This IS a "top-level" node
        pNode := nil
    else begin
        //This is NOT a "top-level" node
        pNode := AddItemNode(
                ctrl.GetItem(Group),
                _GroupParser.GetGroupParent(Group));
    end;

    Result := _GetNodeByUID(item.UID, pNode);
    if (Result <> nil) then begin
        //already exists, so we'll just try to update
        UpdateItemNode(Result);
        exit;
    end;

    //Actually create the node...
    wrapper := TExodusItemWrapper.Create(Item);
    Result := Items.AddNode(Result, pNode, Item.Text, wrapper, naAddChild);

    if not _BatchUpdate and (pNode <> nil) then begin
        //Check to see if parent needs expanding
        Item := GetNodeItem(pNode);
        if (Item <> nil) and (Item.Type_ = EI_TYPE_GROUP) then begin
            //Check to see if parent needs expanding
            if ctrl.GroupExpanded[Item.UID] then begin
                pNode.Expand(false);
            end;
        end;
    end;
end;

{---------------------------------------}
//Returns a list of nodes for the given uid.
function TExTreeView.GetItemNodes(Uid: WideString) : TObjectList;
var
    i:Integer;
    Item: IExodusItem;
    node: TTntTreeNode;
begin
    Result := TObjectList.Create();
    Result.OwnsObjects := false;
    for i := 0 to Items.Count - 1 do begin
        node := Items[i];
        Item := GetNodeItem(node);
        if (Item <> nil) and (Item.Uid = Uid) then
          Result.Add(node);
    end;
end;

{---------------------------------------}
procedure TExTreeView.Clear();
begin
    while (Items.Count > 0) do
        _DeleteNode(Items[0]);
end;
{---------------------------------------}
procedure TExTreeView._DeleteNode(node: TTreeNode);
var
    idx: Integer;
begin
    if (node = nil) then exit;

    //(Recursively) delete children
    for idx := node.Count - 1 downto 0 do begin
        _DeleteNode(node.Item[idx]);
    end;

    //clear current node if being deleted!
    if (CurrentNode = node) then CurrentNode := nil;

    //Now delete this node
    _GetWrapperByNode(node).Free();
    node.Delete();
end;

//Perform repainting for all the nodes for the given item.
procedure TExTreeView.UpdateItemNodes(Item: IExodusItem);
var
    ctrl: IExodusItemController;
    Nodes: TObjectList;
    paths: TWidestringList;
    grp: Widestring;
    node, pNode: TTntTreeNode;
    idx, pos: Integer;

begin
    if (Item = nil) then exit;

    ctrl := TJabberSession(_JS).ItemController;

    //build paths for known nodes
    Nodes := GetItemNodes(Item.Uid);
    paths := TWidestringList.Create();
    for idx := 0 to Nodes.Count - 1 do begin
        node := TTntTreeNode(Nodes[idx]);
        grp := GetNodePath(node.Parent);
        paths.AddObject(grp, node);
    end;
    Nodes.Free();

    //walk item groups, looking for parents
    if (ctrl.GetItem(Item.UID) <> nil) and FilterItem(Item) then begin
        for idx := 0 to item.GroupCount do begin
            if (idx <> 0) then
                grp := item.Group[idx - 1]
            else if item.GroupCount = 0 then
                grp := ''
            else
                continue;
            pos := paths.IndexOf(grp);
            if (pos <> -1) then begin
                //A known node
                node := TTntTreeNode(paths.Objects[pos]);
                paths.Delete(pos);
                UpdateItemNode(node);
            end
            else begin
                //A new node!
                AddItemNode(Item, grp);
            end;
        end;
    end;

    //walk remaining nodes, removing them
    for idx := 0 to paths.Count - 1 do begin
        node := TTntTreeNode(paths.Objects[idx]);
        pNode := node.Parent;

        _DeleteNode(node);
        while (pNode <> nil) do begin
            node := pNode;
            pNode := Node.Parent;
            if (node.Count = 0) and not FilterItem(_GetWrapperByNode(node).ExodusItem) then begin
                _DeleteNode(Node);
            end
            else begin
                UpdateItemNode(node);
                pNode := nil;
            end;
        end;
    end;
    paths.Free();
end;

{---------------------------------------}
//Repaint given node and all it's ancestors.
procedure TExTreeView.UpdateItemNode(Node: TTntTreeNode);
var
    Rect: TRect;
    ctrl: IExodusItemController;
begin
    ctrl := TJabberSession(_JS).ItemController;

    while (Node <> nil) do begin
        //TOOD:  Possible optimization = -- invalidate union of visited rects
        Rect := Node.DisplayRect(false);
        InvalidateRect(Handle, @Rect, true);
        //Update all ancestors for the node if showing totals
        Node := Node.Parent;
    end;
end;

{---------------------------------------}
//This recursive function counts totals
//for active items in the given group node.
function  TExTreeView.GetActiveCounts(Node: TTntTreeNode): Integer;
var
    Child: TTntTreeNode;
    Item: IExodusItem;
begin
    Item := GetNodeItem(Node);
    if (Item = nil) then exit;

    if (Item.Type_ <> EI_TYPE_GROUP) then
    begin
        // If it is a leaf, end recursion.
        // We only want Contacts in count.
        if ((item.Active) and
            (Item.Type_ = EI_TYPE_CONTACT)) then
            Result := 1
        else
            Result := 0;
        exit;
    end;

    //Iterate through children and accumulate
    //totals for active for each child.
    Result := 0;
    Child := Node.GetFirstChild();
    while (Child <> nil) do
    begin
        //The following statement takes care of nested group totals.
        Result := Result + GetActiveCounts(Child);
        Child := Node.GetNextChild(Child);
    end;
end;

{---------------------------------------}
//This recursive function counts totals
//for total number of items in the given group node.
function  TExTreeView.GetLeavesCounts(Node: TTntTreeNode): Integer;
var
    Child: TTntTreeNode;
    Item: IExodusItem;
begin
    Item := GetNodeItem(node);
    if (Item = nil) then exit;

    if (Item.Type_ <> EI_TYPE_GROUP) then
    //If it is a leaf, end recursion.
    begin
        Result := 1;
        exit;
    end;

    //Iterate through children and accumulate
    //totals for each child.
    Result := 0;
    Child := node.GetFirstChild();
    while (child <> nil) do
    begin
        //The following statement takes care of nested group totals.
        Result := Result + GetLeavesCounts(Child);
        Child := Node.GetNextChild(child);
    end;
end;

{---------------------------------------}
//This recursive function counts totals
//for total number of contact items in the given group.
function  TExTreeView.GetContactCounts(Node: TTntTreeNode): Integer;
var
    Child: TTntTreeNode;
    Item: IExodusItem;
    itemlist: IExodusItemList;
    i: integer;
begin
    // This is an inefficient count routine as it recurses
    // into nodes that are not groups.
    // But, we are dealing with 2 different Trees and this
    // is easier then going back and forth from IExodusItems
    // and TTntTreeNodes.
    Result := 0;
    Item := GetNodeItem(node);
    if (Item = nil) then exit;

    // Count up children that are contacts
    if (Item.Type_ = EI_TYPE_GROUP) then
    begin
        itemlist := TJabberSession(_JS).ItemController.GetGroupItems(Item.UID);
        for i := 0 to itemlist.Count - 1 do
        begin
            if (itemlist.Item[i].Type_ = EI_TYPE_CONTACT) then
            begin
                // This subitem is a contact so include in count
                Inc(Result);
            end
        end;

        itemlist := nil; // free
    end;

    //Iterate through children and accumulate
    //totals for each child.
    Child := node.GetFirstChild();
    while (child <> nil) do
    begin
        //The following statement takes care of nested group totals.
        Result := Result + GetContactCounts(Child);
        Child := Node.GetNextChild(child);
    end;
end;

{---------------------------------------}
//This recursive function returns full group name path for the nested groups
function  TExTreeView.GetNodePath(Node: TTntTreeNode): WideString;
var
    item: IExodusItem;
begin
    Result := '';

    if (Node = nil) then exit;

    item := GetNodeItem(Node);
    if (item = nil) then exit;

    if (item.Type_ <> EI_TYPE_GROUP) and (Node.Parent <> nil) then
        Result := GetNodePath(Node.Parent) + _GroupSeparator + item.UID
    else
        Result := item.UID;
end;

{---------------------------------------}
//Returns the list of immediate subgroups
function  TExTreeView.GetSubgroups(Group: WideString): TWideStringList;
var
   Subgroups: TWideStringList;
   GroupNode, ChildNode: TTntTreeNode;
   Item: IExodusItem;
begin
   Subgroups := TWideStringList.Create();
   Result := Subgroups;
   GroupNode := _GetNodeByUID(Group);
   if (GroupNode = nil) then
       exit;
   Item := GetNodeItem(GroupNode);
   if (Item = nil) or (Item.Type_ <> EI_TYPE_GROUP) then
       exit;
   ChildNode := GroupNode.GetFirstChild();
   while (ChildNode <> nil) do
   begin
      Item := GetNodeItem(ChildNode);
      if (Item = nil) then
          continue;
      if (Item.Type_ = EI_TYPE_GROUP) then
          Subgroups.Add(ChildNode.Text);

      ChildNode := GroupNode.GetNextChild(ChildNode);
   end;
end;

{---------------------------------------}
//Iterates thorugh all the nodes and saves exapanded state for group nodes.
procedure  TExTreeView.SaveGroupsState();
begin

end;

{---------------------------------------}
//Iterates thorugh all the nodes and restores expanded/collapsed state for the group.
procedure  TExTreeView.RestoreGroupsState();
var
    Item: IExodusItem;
    Expanded: Boolean;
    Name: WideString;
    i: Integer;
begin
     for i := 0 to Items.Count - 1 do
     begin
       Item := GetNodeItem(Items[i]);
       if (Item = nil) or (Item.Type_ <> EI_TYPE_GROUP) then continue;
       Name := Item.UID;
       Expanded := TJabberSession(_js).ItemController.GroupExpanded[Name];
       if (Expanded) then
          Items[i].Expand(false)
       else
           Items[i].Collapse(false);
    end;
end;

{---------------------------------------}
//This function figures out all the pieces
//to perform custom drawing for the individual node.
procedure TExTreeView.CustomDrawItem(Sender: TCustomTreeView;
                                     Node: TTreeNode;
                                     State: TCustomDrawState;
                                     var DefaultDraw: Boolean);
var
    Text, ExtendedText: WideString;
    IsGroup: Boolean;
    Item: IExodusItem;
    activeCount, contactCount: Widestring;
begin
    // Perform initialization
    if (Node = nil) then exit;
    if (not Node.IsVisible) then exit;

    Item := GetNodeItem(Node);
    if (Item = nil) then exit;

    DefaultDraw := false;
    Text := '';
    ExtendedText := '';

    if (Item.Type_ = EI_TYPE_GROUP) then
        IsGroup := true
    else
        IsGroup := false;

   if (IsGroup) then begin
       //Set extended text for totals for the groups, if required.
       Text := TTntTreeNode(Node).Text;
       if (_ShowGroupTotals) then
       begin
          if ((Filter = '') or (Filter = EI_TYPE_CONTACT)) then
          begin
              activeCount := IntToStr(GetActiveCounts(TTntTreeNode(Node)));
              contactCount := IntToStr(GetContactCounts(TTntTreeNode(Node)));
              ExtendedText := Format(_(X_OF_Y_ONLINE), [activeCount, contactCount]);
          end;
       end;
   end
   else if (Item <> nil) then begin
       //Set extended text for status for the node, if required.
       Text := Item.Text;
       if (_ShowStatus) then
           if (WideTrim(Item.ExtendedText) <> '') then
               ExtendedText := ' - ' + Item.ExtendedText;
   end;

    DrawNodeText(TTntTreeNode(Node), State, Text, ExtendedText);
end;

{---------------------------------------}
//Performs drawing of text and images for the given node.
procedure TExTreeView.DrawNodeText(Node: TTntTreeNode; State: TCustomDrawState;
    Text, ExtendedText: Widestring);
var
    RightEdge, MaxRight, Arrow, Folder, TextWidth: integer;
    ImgRect, TxtRect, NodeRect, NodeFullRow: TRect;
    MainColor, StatColor, TotalsColor, InactiveColor: TColor;
    IsGroup: boolean;
    Item: IExodusItem;

begin
    //Save string width and height for the node text
    TextWidth := CanvasTextWidthW(Canvas, Text);
    //Set group flag based on presence of data attached.
    Item := GetNodeItem(Node);
    if (Item = nil) then exit;

    if (Item.Type_ = EI_TYPE_GROUP) then
       IsGroup := true
    else
    begin
       IsGroup := false;
    end;

    //Get default rectangle for the node
    NodeRect := Node.DisplayRect(true);
    NodeFullRow := NodeRect;
    NodeFullRow.Left := 0;
    NodeFullRow.Right := ClientWidth - 2;
    Canvas.Font.Color := Font.Color;
    Canvas.Brush.Color := Color;
    Canvas.FillRect(NodeFullRow);
    //Shift to the right to support two group icons for all groups
    NodeRect.Left := NodeRect.Left + Indent;
    NodeRect.Right := NodeRect.Right + Indent;
    TxtRect := NodeRect;
    ImgRect := NodeRect;
    RightEdge := nodeRect.Left + TextWidth + 2 + CanvasTextWidthW(Canvas, (ExtendedText + ' '));
    MaxRight := ClientWidth - 2;

    // make sure our rect isn't bigger than the treeview
    if (RightEdge >= MaxRight) then
        TxtRect.Right := MaxRight
    else
        TxtRect.Right := RightEdge;

    ImgRect.Left := ImgRect.Left - (2*Indent);

    Canvas.Font.Style := Self.Font.Style;
    // if selected, draw a solid rect
    if (cdsSelected in State) then
    begin
        Canvas.Font.Color := clHighlightText;
        Canvas.Brush.Color := clHighlight;
        Canvas.FillRect(TxtRect);
    end;

    if (IsGroup) then
    begin
        // this is a group
        if (Node.Expanded) and (Node.Count > 0) then
        begin
            Arrow := RosterTreeImages.Find(RI_OPENGROUP_KEY);
            Folder := RosterTreeImages.Find(RI_FOLDER_OPEN_KEY);
        end
        else
        begin
            Arrow := RosterTreeImages.Find(RI_CLOSEDGROUP_KEY);
            Folder := RosterTreeImages.Find(RI_FOLDER_CLOSED_KEY);
        end;
        //Groups have two images
        //Draw > image
        frmExodus.ImageList1.Draw(Canvas,
                                  ImgRect.Left,
                                  ImgRect.Top, Arrow);
        //Move to the second image drawing
        ImgRect.Left := ImgRect.Left + Indent;
        //Draw second image
        frmExodus.ImageList1.Draw(Canvas,
                                  ImgRect.Left,
                                  ImgRect.Top, Folder);
    end
    else
        //Draw image for the item
        frmExodus.ImageList1.Draw(Canvas,
                                  ImgRect.Left + Indent,
                                  ImgRect.Top, Item.ImageIndex);


    // draw the text
    if (cdsSelected in State) then
    begin
        // Draw the focus box.
        Canvas.DrawFocusRect(TxtRect);
        MainColor := clHighlightText;
        StatColor := MainColor;
        TotalsColor := MainColor;
        InactiveColor := MainColor;
    end
    else
    begin
        MainColor := Canvas.Font.Color;
        StatColor := _StatusColor;
        TotalsColor := _TotalsColor;
        InactiveColor := _InactiveColor;
    end;

    //Figure out color for the node.
    if (IsGroup) then
       SetTextColor(Canvas.Handle, ColorToRGB(MainColor))
    else
       if (Item.Active) then
           SetTextColor(Canvas.Handle, ColorToRGB(MainColor))
       else
           SetTextColor(Canvas.Handle, ColorToRGB(InactiveColor));

    //Draw basic node text
    CanvasTextOutW(Canvas, TxtRect.Left + 1,  TxtRect.Top, Text, MaxRight);

    //Draw additional node text, if required.
    if (ExtendedText <> '') then begin
        if (IsGroup) then
            SetTextColor(Canvas.Handle, ColorToRGB(TotalsColor))
        else
            SetTextColor(Canvas.Handle, ColorToRGB(StatColor));

        CanvasTextOutW(Canvas, txtRect.Left + TextWidth + 4, TxtRect.Top, ExtendedText, MaxRight);
    end;

end;

procedure TExTreeView.MouseDown(Button: TMouseButton;
                                Shift: TShiftState; X, Y: Integer);
var
  node: TTntTreeNode;
  hits: THitTests;
begin
    inherited;
    _AllowDefaultSelection := true;
    // check to see if we're hitting a button
    node := GetNodeAt(X, Y);
    CurrentNode := node;
    if (node = nil) then begin
        Selected := nil;
        exit;
    end;
    hits := GetHitTestInfoAt(X, Y);
    if ((htOnButton in hits) or (htOnIndent in hits)) then begin
        Selected := nil;
        exit;
    end;

    // if we have a legit node.... make sure it's selected..
    if not (ssShift in Shift) and not (ssCtrl in Shift) then begin
        if (Selected <> node) then
            Select(node, Shift);
    end;

end;

procedure TExTreeView.MouseMove(Shift: TShiftState; X, Y: Integer);
begin
    //Work around problem with MouseMove event firing infinite number of times
    //even if mouse has stopped moving.
    inherited;
    if ((_LastMouseMovePoint.X = X) and (_LastMouseMovePoint.Y = Y)) then
        exit;

    if (GetRosterWindow().HoverWindow.Visible) then
        ActivateHover();

    _LastMouseMovePoint.X := X;
    _LastMouseMovePoint.Y := Y;

end;

{---------------------------------------}
procedure TExTreeView.MouseLeave(Sender: TObject);
begin
    _LastHintNode := nil;
    GetRosterWindow().HoverWindow.CancelHover();
end;

procedure TExTreeView.DblClick();
var
    Item: IExodusItem;
    actName: Widestring;
    itemList: IExodusItemList;
    typedActs: IExodusTypedActions;
    act: IExodusAction;
begin
    OutputDebugMsg('tree double-click event!');
    //inherited;

    try
        Item := GetNodeItem(CurrentNode);
    except
        Item := nil;
        OutputDebugMsg('!!!!!! bad current node reference !!!!!!');
    end;
    if (Item = nil) then exit;

    actName := Item.value['defaultaction'];
    if (actName <> '') then begin
        typedActs := GetActionController().actionsForType(Item.Type_);

        if (typedActs <> nil) then
            act := typedActs.GetActionNamed(actName)
        else
            act := nil;

        if (act <> nil) then begin
            try
                itemList := TExodusItemList.Create();
                itemList.Add(item);
                act.execute(itemList);
            except
                OutputDebugMsg('!!!!!! could not execute "' + actName + '" !!!!!!');
            end;
        end;
    end;
end;

procedure TExTreeView.Changing(Sender: TObject; Node: TTreeNode; var AllowChange: Boolean);
begin
    //Base class for the tree control performs selection of the first node on getting focus.
    //According to the requirements, if not selection has been previously
    //performed, it should stay this way when tree control is getting focus.
    if (not _AllowDefaultSelection) then
       AllowChange := false
    else
       AllowChange := true;
end;

{---------------------------------------}
procedure TExTreeView._SetFilterType(filtertype: Widestring);
begin

end;

{---------------------------------------}
procedure TExTreeView.Editing(Sender: TObject; Node: TTreeNode; var AllowEdit: Boolean);
begin
     AllowEdit := false;
end;

{---------------------------------------}
function  TExTreeView.FilterItem(Item: IExodusItem): Boolean;
begin
    Result := (item <> nil);
end;

function TExTreeView._GetWrapperByNode(Node: TTreeNode): TExodusItemWrapper;
begin
    Result := nil;

    if (Node = nil) then exit;
    if (Node.Data = nil) then exit;

    Result := TExodusItemWrapper(Node.Data);
end;
function TExTreeView._GetNodeByUID(
        UID: WideString;
        Cntr: TTreeNode) : TTntTreeNode;
var
    n: TTntTreeNode;
    item: IExodusItem;
    i: Integer;
begin
    for i := 0 to Items.Count - 1 do begin
        n := Items[i];
        item := GetNodeItem(n);
        if (item <> nil) and (item.UID = UID) and ((Cntr = nil) or (Cntr = n.Parent)) then begin
            Result := n;
            exit;
        end;
    end;
    
    Result := nil;
end;


function TExTreeView.GetSelectedItems(): IExodusItemList;
var
    idx: Integer;
    item: IExodusItem;
begin
    Result := TExodusItemList.Create() as IExodusItemList;

    for idx := 0 to SelectionCount - 1 do begin
        item := GetNodeItem(Selections[idx]);
        if (item = nil) then continue;
        
        Result.Add(item);
    end;
end;

procedure TExTreeView.ActivateHover();
var
    Point: TPoint;
    ClientPoint, ScreenPointUpperLeft: TPoint;
    Node: TTntTreeNode;
    NodeRect: TRect;
    Item: IExodusItem;
begin
    GetCursorPos(Point);

    ClientPoint := Self.ScreenToClient(Point);
    Node := GetNodeAt(ClientPoint.X, ClientPoint.Y);
    if (Node = nil) then exit;
    Item := GetNodeItem(Node);
    if (Item = nil) then exit;
    if (_LastHintNode = Node) then exit;


    if ((_LastHintNode <> nil) and (GetRosterWindow().HoverWindow.Visible)) then
        if (_MovingTowardsHover(Point.X, Point.Y)) then exit;

    _LastHintNode := Node;

    NodeRect := Node.DisplayRect(false);
    ScreenPointUpperLeft.x := NodeRect.Left;
    ScreenPointUpperLeft.y := NodeRect.Top;

    GetRosterWindow().HoverWindow.ActivateHover(ClientToScreen(ScreenPointUpperLeft), Item);
end;

function TExTreeView.GetNodeItem(node: TTreeNode): IExodusItem;
var
    wrapper: TExodusItemWrapper;
begin
    wrapper := _GetWrapperByNode(node);
    if wrapper <> nil then
        Result := wrapper.ExodusItem
    else
        Result := nil;
end;

procedure TExTreeView.Refresh;
var
    itemCtrl: IExodusItemController;
    item: IExodusItem;
    idx: Integer;
begin
    Clear();

    //TODO:  make this use a local variable??
    itemCtrl := TJabberSession(_JS).ItemController;
    for idx := 0 to itemCtrl.ItemsCount - 1 do begin
        item := itemCtrl.Item[idx];

        if not FilterItem(item) then continue;

        UpdateItemNodes(item);
    end;
end;


procedure TExTreeView.WMKillFocus(var Message: TWMSetFocus);
begin
   OutputDebugMsg('Kill Focus');
   _AllowDefaultSelection := (Selected <> nil);
end;

function TExTreeView._MovingTowardsHover(X,Y: Integer) :Boolean;
var
  LastMouseMovePoint, IntersectionPoint: TPoint;
  RightBorder, UpperBorder, LowerBorder: Integer;
  A, B: Single;
begin
   Result := false;
   LastMouseMovePoint := ClientToScreen(_LastMouseMovePoint);
   if (LastMouseMovePoint.X = X) then exit;
   A := (Y - LastMouseMovePoint.Y)/(X - LastMouseMovePoint.X);
   B := Y - A*X;
   RightBorder := ClientToScreen(Self.BoundsRect.BottomRight).X;
   UpperBorder := ClientToScreen(Self.BoundsRect.TopLeft).Y;
   LowerBorder := ClientToScreen(Self.BoundsRect.BottomRight).Y;
   IntersectionPoint.X := RightBorder;
   IntersectionPoint.Y := Trunc(A*IntersectionPoint.X + B);
   if ((IntersectionPoint.Y >= UpperBorder) and (IntersectionPoint.Y <= LowerBorder)) then
        Result := true;
   
end;

{---------------------------------------}
procedure TExTreeView._NewWndProc(var Msg: TMessage);
begin
    if(Msg.Msg=TVM_HITTEST) then
    begin
       _OldProc(Msg);
        if (PTVHitTestInfo(Msg.LParam)^.hItem <> nil) then
        begin
           if (PTVHitTestInfo(Msg.LParam)^.flags = TVHT_ONITEM) then exit;
           if (
               (PTVHitTestInfo(Msg.LParam)^.flags = TVHT_ONITEMBUTTON) or
               (PTVHitTestInfo(Msg.LParam)^.flags = TVHT_ONITEMICON) or
               //(PTVHitTestInfo(Msg.LParam)^.flags = TVHT_ONITEMINDENT) or
               (PTVHitTestInfo(Msg.LParam)^.flags = TVHT_ONITEMLABEL) or
               (PTVHitTestInfo(Msg.LParam)^.flags = TVHT_ONITEMRIGHT) or
               (PTVHitTestInfo(Msg.LParam)^.flags = TVHT_ONITEMSTATEICON)
               ) then
           begin
               PTVHitTestInfo(Msg.LParam)^.flags := TVHT_ONITEM;
               OutputDebugString(PChar('Item hit test'));
               exit;
           end;
        end;
        Msg.Result := 1;
        exit;
    end;

    _OldProc(Msg);

end;

procedure TExTreeView.KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
    if (Key = VK_RETURN) then
    begin
       if (SelectionCount > 1) then exit;
       CurrentNode := Selected;
       DblClick();
    end;
end;

end.
