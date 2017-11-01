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
unit SelRoomOccupant;

interface

uses
  ComCtrls, 
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, fRosterTree, buttonFrame, Menus, StdCtrls, TntStdCtrls, ExtCtrls,
  TntMenus, JabberID, TntComCtrls, Jabber1, ExForm, TntForms, ExFrame;

type
  TfrmSelRoomOccupant = class(TExForm)
    frameButtons1: TframeButtons;
    Panel1: TPanel;
    Label1: TTntLabel;
    txtJID: TTntEdit;
    lstRoster: TTntListView;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure lstRosterCustomDrawItem(Sender: TCustomListView; Item: TListItem;
      State: TCustomDrawState; var DefaultDraw: Boolean);
    procedure lstRosterData(Sender: TObject; Item: TListItem);
    procedure lstRosterResize(Sender: TObject);
    procedure lstRosterChange(Sender: TObject; Item: TListItem;
      Change: TItemChange);
    procedure lstRosterDblClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    rlist: TList;

    function GetSelectedNick(): Widestring;
    procedure SetList(list: TList);
  end;

var
  frmSelRoomOccupant: TfrmSelRoomOccupant;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
implementation

{$R *.dfm}
uses
    GnuGetText, Session, ContactController, Room, ExUtils, RosterImages;

{---------------------------------------}
procedure TfrmSelRoomOccupant.FormCreate(Sender: TObject);
begin
    TranslateComponent(Self);
    lstRoster.Color := TColor(MainSession.Prefs.getInt('color_bg'));
    lstRoster.Font.Name := MainSession.Prefs.getString('roster_font_name');
    lstRoster.Font.Color := TColor(MainSession.Prefs.getInt('font_color'));
    lstRoster.Font.Size := MainSession.Prefs.getInt('roster_font_size');
    lstRoster.Font.Charset := MainSession.Prefs.getInt('roster_font_charset');
    if (lstRoster.Font.Charset = 0) then
        lstRoster.Font.Charset := DEFAULT_CHARSET;
end;

{---------------------------------------}
procedure TfrmSelRoomOccupant.FormDestroy(Sender: TObject);
begin
//    frameTreeRoster1.Cleanup();
end;

{---------------------------------------}
procedure TfrmSelRoomOccupant.SetList(list: TList);
var
    i: integer;
begin
    rlist := list;

    // Setup enough list items to match incoming list.
    for i := 0 to List.Count - 1 do
        lstRoster.Items.Add();

    lstRoster.Invalidate;
end;

{---------------------------------------}
function TfrmSelRoomOccupant.GetSelectedNick(): Widestring;
begin
    Result := txtJid.Text;
end;

procedure TfrmSelRoomOccupant.lstRosterChange(Sender: TObject; Item: TListItem;
  Change: TItemChange);
begin
    if (Item = nil) then exit;

    txtJid.Text := Item.Caption;
end;

procedure TfrmSelRoomOccupant.lstRosterCustomDrawItem(Sender: TCustomListView;
  Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
var
    rm: TRoomMember;
    xRect: TRect;
    nRect: TRect;
    main_color: TColor;
    moderator, visitor: boolean;
    c1: Widestring;
begin
  inherited;
    // Bold if they are a moderator.. gray if no voice
    DefaultDraw := true;

    rm := TRoomMember(rlist[Item.Index]);
    moderator := (rm.role = 'moderator');
    visitor := (rm.role = 'visitor');

    with lstRoster.Canvas do begin
        TextFlags := ETO_OPAQUE;
        xRect := Item.DisplayRect(drLabel);
        nRect := Item.DisplayRect(drBounds);

        // draw the selection box, or just the bg color
        if (cdsSelected in State) then begin
            Font.Color := clHighlightText;
            Brush.Color := clHighlight;
            FillRect(xRect);
        end
        else begin
            if (visitor) then
                Font.Color := clGrayText
            else
                Font.Color := lstRoster.Font.Color;
            Brush.Color := lstRoster.Color;
            Brush.Style := bsSolid;
            FillRect(xRect);
        end;

        // Bold moderators
        if (moderator) then
            Font.Style := [fsBold]
        else
            Font.Style := [];

        // draw the image
        frmExodus.ImageList1.Draw(lstRoster.Canvas,
            nRect.Left, nRect.Top, Item.ImageIndex);

        // draw the text
        if (cdsSelected in State) then begin
            main_color := clHighlightText;
            //stat_color := main_color;
        end
        else begin
            main_color := lstRoster.Canvas.Font.Color;
            //stat_color := clGrayText;
        end;

        c1 := rm.Nick;
        if (CanvasTextWidthW(lstRoster.Canvas, c1) > (xRect.Right - xRect.Left)) then begin
            // XXX: somehow truncate the nick
        end;

        SetTextColor(lstRoster.Canvas.Handle, ColorToRGB(main_color));
        CanvasTextOutW(lstRoster.Canvas, xRect.Left + 1,
            xRect.Top + 1, c1);

        if (cdsSelected in State) then
            // Draw the focus box.
            lstRoster.Canvas.DrawFocusRect(xRect);

        // make sure the control doesn't redraw this.
        DefaultDraw := false;
    end;
end;

{---------------------------------------}
procedure TfrmSelRoomOccupant.lstRosterData(Sender: TObject; Item: TListItem);
var
    rm: TRoomMember;
begin
  inherited;
    // get the data for this person..
    rm := TRoomMember(rlist[Item.Index]);
    TTntListItem(Item).Caption := rm.Nick;
    if (rm.show = _(sBlocked)) then item.ImageIndex := RosterTreeImages.Find('online_blocked')
    else if rm.show = 'away' then Item.ImageIndex := RosterTreeImages.Find('away')
    else if rm.show = 'xa' then Item.ImageIndex := RosterTreeImages.Find('xa')
    else if rm.show = 'dnd' then Item.ImageIndex := RosterTreeImages.Find('dnd')
    else if rm.show = 'chat' then Item.ImageIndex := RosterTreeImages.Find('chat')
    else Item.ImageIndex := RosterTreeImages.Find('available');

end;
procedure TfrmSelRoomOccupant.lstRosterDblClick(Sender: TObject);
var
    tmp_change: TItemChange;
begin
    if (lstRoster.Selected = nil) then exit;

    lstRosterChange(Self, lstRoster.Selected, tmp_change);

    Self.ModalResult := mrOK;
    Self.Hide();
end;

procedure TfrmSelRoomOccupant.lstRosterResize(Sender: TObject);
begin
    lstRoster.Column[0].Width := lstRoster.Width - 5;
end;

end.
