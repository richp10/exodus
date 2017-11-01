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
unit SelectItemAnyRoom;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, SelectItemAny, Menus, TntMenus, StdCtrls, TntStdCtrls, ExtCtrls,
  TntExtCtrls, ComCtrls, TntComCtrls, Unicode, ExCustomSeparatorBar;

type
    TListItemTracker = class
        public
        jid: widestring;
        item: TTntListItem;
    end;

    TfrmSelectItemAnyRoom = class(TfrmSelectItemAny)
        pnlJoinedRooms: TTntPanel;
        TntSplitter1: TTntSplitter;
        lblJoinedRooms: TTntLabel;
        lstJoinedRooms: TTntListView;
        procedure FormCreate(Sender: TObject);
        procedure FormDestroy(Sender: TObject);
        procedure lstJoinedRoomsChange(Sender: TObject; Item: TListItem;
      Change: TItemChange);
    procedure chkAnyClick(Sender: TObject);
    procedure lstJoinedRoomsClick(Sender: TObject);
    procedure lstJoinedRoomsResize(Sender: TObject);
    private
    { Private declarations }
        _trackinglist: TWidestringList;
        _lstJoinedRoomsDefaultColor: TColor;
    public
    { Public declarations }

    end;

function SelectUIDByTypeAnyRoom(title: Widestring = ''; ownerHWND: HWND = 0): Widestring;

var
  frmSelectItemAnyRoom: TfrmSelectItemAnyRoom;

implementation

uses
    Room,
    DisplayName,
    JabberID;

{$R *.dfm}

function SelectUIDByTypeAnyRoom(title: Widestring; ownerHWND: HWND): Widestring;
var
    selector: TfrmSelectItemAnyRoom;
begin
    Result := '';
    selector := TfrmSelectItemAnyRoom.Create(nil, 'room', ownerHWND);
    if (title <> '') then
        selector.Caption := title;

    if (selector.ShowModal = mrOk) then begin
        Result := selector.SelectedUID;
    end;

    selector.Free;
end;

procedure TfrmSelectItemAnyRoom.chkAnyClick(Sender: TObject);
begin
    inherited;

    if (chkAny.Checked) then begin
        _lstJoinedRoomsDefaultColor := lstJoinedRooms.Color;
        //lstJoinedRooms.Enabled := false;
        lstJoinedRooms.ParentColor := true;
    end
    else begin
        //lstJoinedRooms.Enabled := true;
        lstJoinedRooms.ParentColor := false;
        lstJoinedRooms.Color := _lstJoinedRoomsDefaultColor;
    end;
end;

procedure TfrmSelectItemAnyRoom.FormCreate(Sender: TObject);
var
    i: integer;
    item: TTntListItem;
    track: TListItemTracker;
begin
    inherited;

    _trackinglist := TWidestringList.Create();

    for i := 0 to room_list.Count - 1 do begin
        item := lstJoinedRooms.Items.Add();
        item.Caption := DisplayName.getDisplayNameCache().getDisplayName(room_list[i]);
        item.ImageIndex := TfrmRoom(room_list.Objects[i]).ImageIndex;

        track := TListItemTracker.Create();
        track.jid := room_list[i];
        track.item := item;
        _trackingList.AddObject(item.caption, track);
    end;
end;

procedure TfrmSelectItemAnyRoom.FormDestroy(Sender: TObject);
var
    track: TListItemTracker;
    i: integer;
begin
    for i := _trackinglist.Count - 1 downto 0 do begin
        track := TListItemTracker(_trackinglist.Objects[i]);
        track.Free();
        _trackinglist.Delete(i);
    end;
    _trackinglist.Free();

    inherited;
end;

procedure TfrmSelectItemAnyRoom.lstJoinedRoomsChange(Sender: TObject;
  Item: TListItem; Change: TItemChange);
var
    i: integer;
    track: TListItemTracker;
    jid: widestring;
    idx: integer;
begin
    if (chkAny.Checked) then begin
        Item.Selected := false;
        exit;
    end;

    if (_itemView <> nil) then begin
        _itemView.ClearSelection();
    end;

    // Have to loop through because _trackingList.Find()
    // seems to miss some items.
    idx := -1;
    for i := 0 to _trackingList.Count - 1 do
    begin
        if (_trackingList.Strings[i] = item.Caption) then
        begin
            idx := i;
            break;
        end;
    end;

    if (idx >= 0) then begin
        track := TListItemTracker(_trackinglist.Objects[idx]);
        jid := track.jid;
        txtJID.text := TJabberID.removeJEP106(jid);
        btnOK.Enabled := true;
    end
    else begin
        txtJID.text := '';
        btnOK.Enabled := false;
    end;
end;

procedure TfrmSelectItemAnyRoom.lstJoinedRoomsClick(Sender: TObject);
begin
    if (chkAny.Checked) then begin
        lstJoinedRooms.ClearSelection();
    end;
    inherited;
end;

procedure TfrmSelectItemAnyRoom.lstJoinedRoomsResize(Sender: TObject);
begin
    inherited;

    // Resize the hidden column to prevent the horizontal scroll bar
    // if the vertical scroll bar is shown.
    // If a user wishes to see all the text on a long room name,
    // the user can resize the window.
    lstJoinedRooms.Column[0].Width := lstJoinedRooms.ClientWidth - 20;
end;







end.
