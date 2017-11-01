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
unit fRosterTree;

interface

uses
    ContactController, Presence, Unicode,   
    Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
    ImgList, ComCtrls, ExFrame;

type
  TframeTreeRoster = class(TExFrame)
    treeRoster: TTreeView;
    procedure treeRosterCollapsed(Sender: TObject; Node: TTreeNode);
    procedure treeRosterExpanded(Sender: TObject; Node: TTreeNode);
    procedure treeRosterCustomDrawItem(Sender: TCustomTreeView;
      Node: TTreeNode; State: TCustomDrawState; var DefaultDraw: Boolean);
    procedure treeRosterMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    { Private declarations }
    //_cur_ritem: TJabberRosterItem;
    //_cur_grp: Widestring;

    _jid_nodes: TWideStringlist;
    _grp_nodes: TWideStringlist;

    _show_online: boolean;
    _show_native: boolean;
    _show_status: boolean;
    _status_color: TColor;
    _offline: TTreeNode;
    _fullRoster: boolean;

    _collapsed_grps: TWideStringList;

//    procedure RemoveEmptyGroups();
//    procedure RemoveGroupNode(node: TTreeNode);
//    function getNodeList(ritem: TJabberRosterItem): TList;
    function getNodeType(Node: TTreeNode): integer;
  public
    { Public declarations }
    procedure Initialize();
    procedure Cleanup();
    procedure DrawRoster(online_only: boolean; native_only: boolean = true);
    //procedure RemoveItemNodes(ritem: TJabberRosterItem);
    procedure ClearNodes();
    procedure ExpandNodes();
    //procedure RenderNode(ritem: TJabberRosterItem; p: TJabberPres);

    //function RenderGroup(grp_idx: integer): TTreeNode;
  end;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
implementation

{$R *.dfm}
uses
    RosterImages, XMLUtils, JabberUtils, ExUtils,  Jabber1, Session;

{---------------------------------------}
procedure TframeTreeRoster.Initialize();
begin
    _jid_nodes := TWideStringlist.Create();
    _collapsed_grps := TWideStringlist.Create();
    _grp_nodes := TWideStringlist.Create();

    _show_status := MainSession.Prefs.getBool('inline_status');
    _status_color := TColor(MainSession.Prefs.getInt('inline_color'));

    // get all the current coll'd grps.
    MainSession.Prefs.fillStringlist('col_groups', _collapsed_grps);
end;

{---------------------------------------}
procedure TframeTreeRoster.Cleanup();
begin
    ClearStringListObjects(_jid_nodes);
    ClearStringListObjects(_grp_nodes);

    _jid_nodes.Free();
    _grp_nodes.Free();
    _collapsed_grps.Free();
end;

{---------------------------------------}
procedure TframeTreeRoster.DrawRoster(online_only: boolean; native_only: boolean);
//var
//    i: integer;
//    ri: TJabberRosterItem;
//    p: TJabberPres;
begin
    // loop through all roster items and draw them
    _show_online := online_only;
    _show_native := native_only;

    _FullRoster := true;
    Self.ClearNodes();

    treeRoster.Images := RosterTreeImages.ImageList;

    treeRoster.Font.Name := MainSession.Prefs.getString('roster_font_name');
    treeRoster.Font.Size := MainSession.Prefs.getInt('roster_font_size');
    treeRoster.Font.Color := TColor(MainSession.Prefs.getInt('roster_font_color'));
    treeRoster.Font.Charset := MainSession.Prefs.getInt('roster_font_charset');

    if (treeRoster.Font.Charset = 0) then
        treeRoster.Font.Charset := 1;

    treeRoster.Color := TColor(MainSession.prefs.getInt('roster_bg'));
    treeRoster.Items.BeginUpdate;

    // re-render each item
   { TODO : Roster refactor } 
//    with MainSession.Roster do begin
//        for i := 0 to Count - 1 do begin
//            ri := TJabberRosterItem(Objects[i]);
//            p := MainSession.ppdb.FindPres(ri.JID.jid, '');
//            RenderNode(ri, p);
//        end;
//    end;

    _FullRoster := false;
    treeRoster.AlphaSort;
    treeRoster.Items.EndUpdate;
    Self.ExpandNodes();
    if (treeRoster.Items.Count > 0) then
        treeRoster.TopItem := treeRoster.Items[0];
end;
{ TODO : Roster refactor }
{---------------------------------------}
//function TframeTreeRoster.getNodeList(ritem: TJabberRosterItem): TList;
//var
//    jn_idx: integer;
//begin
//    // return a TList for this JID from the node_list list
//    jn_idx := _jid_nodes.indexOf(ritem.jid.full);
//    if (jn_idx < 0) then
//        Result := nil
//    else
//        Result := TList(_jid_nodes.objects[jn_idx]);
//end;
//
//{---------------------------------------}
//procedure TframeTreeRoster.RemoveItemNodes(ritem: TJabberRosterItem);
//var
//    n, p: TTreeNode;
//    node_list: TList;
//    i: integer;
//begin
//    // Remove the nodes for this item..
//    node_list := GetNodeList(ritem);
//    if node_list <> nil then begin
//        for i := node_list.count - 1 downto 0 do begin
//            n := TTreeNode(node_list[i]);
//            p := n.Parent;
//            n.Free;
//            if (p.Count <= 0) then
//                Self.RemoveGroupNode(p);
//            node_list.Delete(i);
//        end;
//    end;
//end;

{---------------------------------------}
procedure TframeTreeRoster.ClearNodes();
var
    i:          integer;
    node_list:  TList;
begin
    treeRoster.Items.BeginUpdate;

    // this clears the actual treeview
    treeRoster.Items.Clear;

    // wipe out pointers to the nodes in the lists
    for i := 0 to _grp_nodes.Count - 1 do
        _grp_nodes.Objects[i] := nil;

    for i := 0 to _jid_nodes.Count - 1 do begin
        node_list := TList(_jid_nodes.Objects[i]);
        node_list.Clear();
    end;

    _offline := nil;

    treeRoster.Items.EndUpdate;
end;

{---------------------------------------}
procedure TframeTreeRoster.ExpandNodes();
var
    i: integer;
    n: TTreeNode;
begin
    // expand all nodes except special nodes
    for i := 0 to treeRoster.Items.Count - 1 do begin
        n := treeRoster.Items[i];
        if ((n.Level = 0) and (n <> _offline)) then begin
            if (_collapsed_grps.IndexOf(n.Text) < 0) then
                n.Expand(true);
        end;
    end;
end;
{ TODO : Roster refactor }
{---------------------------------------}
//procedure TframeTreeRoster.RenderNode(ritem: TJabberRosterItem; p: TJabberPres);
//var
//    i, g, grp_idx: integer;
//    cur_grp, tmps: string;
//    cur_node, grp_node, n: TTreeNode;
//    node_list: TList;
//    tmp_grps: TWidestringlist;
//    show_offgrp: boolean;
//    exp_grpnode: boolean;
//begin
//    // Render a specific roster item, with the given presence info.
//
//    // First Cache some prefs
//    show_offgrp := MainSession.Prefs.getBool('roster_offline_group');
//
//    exp_grpnode := false;
//
//    {
//    OK, here we want to bail on some circumstances
//    if the roster item is NOT supposed to be shown
//    based on preferences, and the state of the roster
//    item, and the current presence info.
//    }
//
//    if (ritem.ask = 'subscribe') then begin
//        // allow these items to pass thru
//    end
//
//    else if (((_show_online) and (not show_offgrp)) and
//        ((p = nil) or (p.PresType = 'unavailable'))) then begin
//        // Only show online, and don't use the offline grp
//        // This person is not online, remove all nodes and bail
//        RemoveItemNodes(ritem);
//        exit;
//    end
//
//    else if ((_show_native) and (not ritem.IsNative)) then begin
//        RemoveItemNodes(ritem);
//        exit;
//    end
//
//    else if ((ritem.subscription = 'none') or
//        (ritem.subscription = '') or
//        (ritem.subscription = 'remove')) then begin
//        // We aren't subscribed to these people,
//        // or we are removing them from the roster
//        RemoveItemNodes(ritem);
//        exit;
//    end;
//
//    // Create a list to contain all nodes for this
//    // roster item, and assign it to the .Data property
//    // of the roster item object
//
//    // node_list := TList(ritem.Data);
//    node_list := Self.GetNodeList(ritem);
//    if node_list = nil then begin
//        node_list := TList.Create;
//        _jid_nodes.AddObject(ritem.jid.full, node_list);
//    end;
//
//    // Create a temporary list of grps that this
//    // contact should be in.
//    tmp_grps := TWidestringlist.Create;
//    if (((p = nil) or (p.PresType = 'unavailble')) and (show_offgrp)) then
//        // they are offline, and we want an offline grp
//        tmp_grps.Add('Offline')
//    else
//        // otherwise, assign the grps from the roster item
//        ritem.AssignGroups(tmp_grps);
//
//    // If they aren't in any grps, put them into the Unfiled grp
//    if tmp_grps.Count <= 0 then
//        tmp_grps.Add('Unfiled');
//
//    // Remove nodes that are in node_list but aren't in the grp list
//    // This takes care of changing grps, or going to the offline grp
//    for i := node_list.Count - 1 downto 0 do begin
//        cur_node := TTreeNode(node_list[i]);
//        grp_node := cur_node.Parent;
//        cur_grp := grp_node.Text;
//        if (tmp_grps.IndexOf(cur_grp) < 0) then begin
//            // nuke this old node
//            cur_node.Free;
//            node_list.Delete(i);
//        end;
//    end;
//
//    // determine the caption for the node
//    if (ritem.Text <> '') then
//        tmps := ritem.Text
//    else
//        tmps := ritem.jid.Full;
//
//    if (ritem.ask = 'subscribe') then
//        tmps := tmps + ' (Pending)';
//
//    if (_show_status) then begin
//        if (p <> nil) then begin
//            if (p.Status <> '') then
//                tmps := tmps + ' (' + p.Status + ')';
//        end;
//    end;
//
//
//    // For each grp in the temp. grp list,
//    // Make sure a node already exists, or create one.
//    for g := 0 to tmp_grps.Count - 1 do begin
//        cur_grp := tmp_grps[g];
//
//        {
//        The offline grp is special, we keep a pointer to
//        it at all times (if it exists).
//        }
//        if (cur_grp = 'Offline') then begin
//            if (_offline = nil) then begin
//                _offline := treeRoster.Items.AddChild(nil, 'Offline');
//                _offline.ImageIndex := RosterTreeImages.Find('closed_group');
//                _offline.SelectedIndex := _offline.ImageIndex;
//            end;
//            grp_node := _offline;
//        end
//        else begin
//            // Make sure the grp exists in _grp_nodes
//            grp_idx := _grp_nodes.IndexOf(cur_grp);
//            if (grp_idx < 0) then
//                grp_idx := _grp_nodes.Add(cur_grp);
//
//            // Make sure we have a node for this grp and keep
//            // a pointer to the node in the Roster's grp list
//            grp_node := TTreeNode(_grp_nodes.Objects[grp_idx]);
//            if (grp_node = nil) then begin
//                grp_node := RenderGroup(grp_idx);
//            end;
//        end;
//
//        // Expand any grps that are not supposed to be collapsed
//        if ((not _FullRoster) and
//            (grp_node <> _offline) and
//            (_collapsed_grps.IndexOf(grp_node.Text) < 0)) then
//            exp_grpnode := true;
//
//
//        // Now that we are sure we have a grp_node,
//        // check to see if this node exists under it
//        cur_node := nil;
//        for i := 0 to node_list.count - 1 do begin
//            n := TTreeNode(node_list[i]);
//            if n.HasAsParent(grp_node) then begin
//                cur_node := n;
//                break;
//            end;
//        end;
//
//        if cur_node = nil then begin
//            // add a node for this person under this group
//            cur_node := treeRoster.Items.AddChild(grp_node, tmps);
//            node_list.Add(cur_node);
//        end;
//
//        cur_node.Text := tmps;
//        cur_node.Data := ritem;
//        cur_node.ImageIndex := ritem.ImageIndex;
//
//        cur_node.SelectedIndex := cur_node.ImageIndex;
//        if (exp_grpnode) then grp_node.Expand(true);
//    end;
//
//    tmp_grps.Free();
//
//    {
//    If this isn't a full roster push,
//    Make sure the roster is alpha sorted, and
//    check for any empty groups
//    }
//    if not _FullRoster then begin
//        treeRoster.AlphaSort;
//        treeRoster.Refresh;
//        RemoveEmptyGroups();
//    end;
//
//end;

{---------------------------------------}
//function TframeTreeRoster.RenderGroup(grp_idx: integer): TTreeNode;
//var
//    grp_node: TTreeNode;
//    cur_grp: string;
//begin
//    // render this grp into the tree
//    cur_grp := _grp_nodes[grp_idx];
//    grp_node := treeRoster.Items.AddChild(nil, cur_grp);
//    _grp_nodes.Objects[grp_idx] := grp_node;
//    grp_node.ImageIndex := RosterTreeImages.Find('closed_group');
//    grp_node.SelectedIndex := grp_node.ImageIndex;
//    grp_node.Data := nil;
//    result := grp_node;
//end;

{---------------------------------------}
//procedure TframeTreeRoster.RemoveEmptyGroups();
//var
//    i: integer;
//    node: TTreeNode;
//begin
//    // scan for any empty grps
//    for i := _grp_nodes.Count - 1 downto 0 do begin
//        node := TTreeNode(_grp_nodes.Objects[i]);
//
//        if ((node <> nil) and (node.Count = 0)) then
//            RemoveGroupNode(node);
//    end;
//end;

{---------------------------------------}
//procedure TframeTreeRoster.RemoveGroupNode(node: TTreeNode);
//var
//    grp_idx: integer;
//    grp: string;
//begin
//    // remove the group node pointer from the list
//    grp := node.Text;
//    grp_idx := _grp_nodes.indexOfObject(node);
//    if (grp_idx >= 0) then
//        _grp_nodes.Objects[grp_idx] := nil;
//    node.Free();
//end;

{---------------------------------------}
procedure TframeTreeRoster.treeRosterCollapsed(Sender: TObject;
  Node: TTreeNode);
begin
    if (Node.Level = 0) then begin
        Node.ImageIndex := RosterTreeImages.Find('closed_group');
        Node.SelectedIndex := Node.ImageIndex;

        if (_collapsed_grps.IndexOf(Node.Text) < 0) then begin
            _collapsed_grps.Add(Node.Text);
        end;
    end;
end;

{---------------------------------------}
procedure TframeTreeRoster.treeRosterExpanded(Sender: TObject;
  Node: TTreeNode);
var
    i: integer;
begin
    if Node.Level = 0 then begin
        Node.ImageIndex := RosterTreeImages.Find('open_group');
        Node.SelectedIndex := Node.ImageIndex;
        repeat
            i := _collapsed_grps.IndexOf(node.Text);
            if (i >= 0) then begin
                _collapsed_grps.Delete(i);
            end;
        until (i < 0);
    end;
end;
{ TODO : Roster refactor }
{---------------------------------------}
function TframeTreeRoster.getNodeType(Node: TTreeNode): integer;
//var
//    n: TTreeNode;
begin
//    // return the type of node this is..
//    if (Node = nil) then
//        n := treeRoster.Selected
//    else
//        n := Node;
//
//    Result := node_none;
//    _cur_ritem := nil;
//    _cur_grp := '';
//
//    if (n = nil) then exit;
//
//    if ((n.Level = 0) or
//    ((treeRoster.SelectionCount > 1) and (node = nil))) then begin
//        Result := node_grp;
//        _cur_grp := n.Text;
//    end
//
//    else if (TObject(n.Data) is TJabberRosterItem) then begin
//        Result := node_ritem;
//        _cur_ritem := TJabberRosterItem(n.Data);
//    end;
    Result := node_ritem;
end;

{---------------------------------------}
procedure TframeTreeRoster.treeRosterCustomDrawItem(
  Sender: TCustomTreeView; Node: TTreeNode; State: TCustomDrawState;
  var DefaultDraw: Boolean);
var
    tw: integer;
    c1, c2: string;
    xRect: TRect;
    nRect: TRect;
    p: TJabberPres;
    main_color, stat_color: TColor;
begin
    // Try drawing the roster custom..
    DefaultDraw := true;
    if (Node.Level = 0) then
        treeRoster.Canvas.Font.Style := [fsBold]
    else begin
        // we are drawing some kind of node
        treeRoster.Canvas.Font.Style := [];
        case getNodeType(Node) of
        node_bm: DefaultDraw := true;
        node_ritem: begin
            // draw a roster item
            if (_show_status) then begin

                // determine the caption
{ TODO : Roster refactor }
//                if (_cur_ritem.Text <> '') then
//                    c1 := _cur_ritem.Text
//                else
//                    c1 := _cur_ritem.jid.Full;

//                if (_cur_ritem.ask = 'subscribe') then
//                    c1 := c1 + ' (Pending)';

                //p := MainSession.ppdb.FindPres(_cur_ritem.jid.jid, '');
                if (p <> nil) then begin
                    if (p.Status <> '') then
                        c2 := '(' + p.Status + ')';
                end;

                with treeRoster.Canvas do begin
                    TextFlags := ETO_OPAQUE;
                    tw := TextWidth(c1);
                    xRect := Node.DisplayRect(true);
                    xRect.Right := xRect.Left + tw + 8 + TextWidth(c2);
                    nRect := xRect;
                    nRect.Left := nRect.Left - (2*treeRoster.Indent);

                    if (cdsSelected in State) then begin
                        Font.Color := clHighlightText;
                        Brush.Color := clHighlight;
                        FillRect(xRect);
                    end
                    else begin
                        Font.Color := clWindowText;
                        Brush.Color := treeRoster.Color;
                        Brush.Style := bsSolid;
                        FillRect(xRect);
                    end;

                    // draw the image
                    treeRoster.Images.Draw(treeRoster.Canvas, nRect.Left + treeRoster.Indent,
                        nRect.Top, Node.ImageIndex);

                    // draw the text
                    if (cdsSelected in State) then begin
                        main_color := clHighlightText;
                        stat_color := main_color;
                    end
                    else begin
                        main_color := treeRoster.Font.Color;
                        stat_color := _status_color;
                end;

                    SetTextColor(treeRoster.Canvas.Handle, ColorToRGB(main_color));
                    TextOut(xRect.Left + 1, xRect.Top + 1, c1);
                    SetTextColor(treeRoster.Canvas.Handle, ColorToRGB(stat_color));
                    TextOut(xRect.Left + tw + 5, xRect.Top + 1, c2);

                    if (cdsSelected in State) then
                        // Draw the focus box.
                        treeRoster.Canvas.DrawFocusRect(xRect);
                end;

                DefaultDraw := false;
            end
            else
                DefaultDraw := true;
        end;
    end;

    end;
end;

{---------------------------------------}
procedure TframeTreeRoster.treeRosterMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
    n: TTreeNode;
begin
    // check to see if we're hitting a button
    n := treeRoster.GetNodeAt(X, Y);
    if n = nil then exit;
    if (n.Level <> 0) then exit;

    if (x < treeRoster.Images.Width + 5) then begin
        // clicking on a grp's widget
        if n.Expanded then
            n.Collapse(false)
        else
            n.Expand(false);
    end;
end;

end.
