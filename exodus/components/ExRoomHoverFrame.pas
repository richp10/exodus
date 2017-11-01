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
unit ExRoomHoverFrame;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, StdCtrls, ExtCtrls, ExFrame, ExGraphicButton, Exodus_TLB,
  ExBrandPanel, ExGroupBox, TntStdCtrls;

type
  TExRoomHoverFrame = class(TExFrame)
    imgRoom: TImage;
    RoomDisplayName: TTntLabel;
    lblSubject: TTntLabel;
    lblAffiliation: TTntLabel;
    lblParticipants: TTntLabel;
    chkAutoJoin: TCheckBox;
    btnDelete: TExGraphicButton;
    btnRename: TExGraphicButton;
    btnJoinTC: TExGraphicButton;
    Separator1: TExGroupBox;
    lblName: TTntLabel;
    Subject: TTntLabel;
    Affiliation: TTntLabel;
    Participants: TTntLabel;
    procedure TntFrameMouseEnter(Sender: TObject);
    procedure TntFrameMouseLeave(Sender: TObject);
    procedure imgRoomMouseEnter(Sender: TObject);
    procedure imgRoomMouseLeave(Sender: TObject);
    procedure btnDeleteMouseEnter(Sender: TObject);
    procedure btnDeleteMouseLeave(Sender: TObject);
    procedure btnJoinTCMouseEnter(Sender: TObject);
    procedure btnJoinTCMouseLeave(Sender: TObject);
    procedure btnRenameMouseEnter(Sender: TObject);
    procedure btnRenameMouseLeave(Sender: TObject);
    procedure chkAutoJoinMouseEnter(Sender: TObject);
    procedure chkAutoJoinMouseLeave(Sender: TObject);
    procedure lblAffiliationMouseLeave(Sender: TObject);
    procedure lblAffiliationMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure lblParticipantsMouseEnter(Sender: TObject);
    procedure lblParticipantsMouseLeave(Sender: TObject);
    procedure RoomDisplayNameMouseEnter(Sender: TObject);
    procedure RoomDisplayNameMouseLeave(Sender: TObject);
    procedure lblRoomUIDMouseLeave(Sender: TObject);
    procedure lblRoomUIDMouseEnter(Sender: TObject);
    procedure lblSubjectMouseEnter(Sender: TObject);
    procedure lblSubjectMouseLeave(Sender: TObject);
    procedure btnJoinTCClick(Sender: TObject);
    procedure chkAutoJoinClick(Sender: TObject);
    procedure btnRenameClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
  private
    { Private declarations }
    _TypedActs: IExodusTypedActions;
    _ActMap: IExodusActionMap;
    _Items: IExodusItemList;
    //
    procedure _BuildActions();
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    procedure InitControls(Item: IExodusItem);
  end;

implementation
uses ExItemHoverForm, COMExodusItemList, ExActionCtrl, Room, GnuGetText, TntSysUtils;
{$R *.dfm}

constructor TExRoomHoverFrame.Create(AOwner: TComponent);
begin
    inherited;
    _TypedActs := nil;
    _ActMap := nil;
    _Items := TExodusItemList.Create();

end;

procedure TExRoomHoverFrame.InitControls(Item: IExodusItem);
var
   Act: IExodusAction;
   Room: TfrmRoom;
begin
    _Items.Clear();
    _Items.Add(Item);
    _BuildActions();
    Room := FindRoom(Item.UID);
    if (Room <> nil) then
    begin
        Subject.Caption := Room.lblSubject.Caption;
        Subject.Hint := Room.lblSubject.Caption;
        Subject.ShowHint := true;
        Participants.Caption := IntToStr(Room.GetRoomRosterOnlineCount());
        Affiliation.Caption := Room.MyAffiliation;
    end
    else
    begin
        Subject.Caption := _('N/A');
        Participants.Caption := _('N/A');
        Affiliation.Caption := _('N/A');
    end;

    Act := IExodusAction(Pointer(chkAutoJoin.Tag));
    if (Act <> nil) then
    begin
        chkAutoJoin.OnClick := nil;
        chkAutoJoin.Checked := (Act.Name = '{000-exodus.googlecode.com}-010-unjoin-on-startup');
        //We do not want to invoke OnClick handler at this point
        chkAutoJoin.OnClick := chkAutoJoinClick;
    end;
    RoomDisplayName.Caption := Tnt_WideStringReplace(Item.Text, '&', '&&', [rfReplaceAll, rfIgnoreCase]);
    RoomDisplayName.Hint := Item.Text;
    RoomDisplayName.ShowHint := true;
    Separator1.Caption := '';
end;

procedure TExRoomHoverFrame._BuildActions();
var
    Item: IExodusItem;
    act: IExodusAction;
    AutoJoinValue: WideString;
begin
    Item := _Items.Item[0];
    _ActMap := GetActionController().buildActions(_Items);
    _TypedActs := _ActMap.GetActionsFor('');
    act := _TypedActs.GetActionNamed('{000-exodus.googlecode.com}-000-join-room');
    btnJoinTC.Tag := Integer(Pointer(act));
    btnJoinTC.Enabled := act <> nil;
    if (act <> nil) then btnJoinTC.Caption := act.Caption;
    btnJoinTC.Caption := '   ' + btnJoinTC.Caption;

    act := _TypedActs.GetActionNamed('{000-exodus.googlecode.com}-150-rename');
    btnRename.Tag := Integer(Pointer(act));
    btnRename.Enabled := act <> nil;
    if (act <> nil) then btnRename.Caption := act.Caption;
    btnRename.Caption := '   ' + btnRename.Caption;

    act := _TypedActs.GetActionNamed('{000-exodus.googlecode.com}-190-delete');
    btnDelete.Tag := Integer(Pointer(act));
    btnDelete.Enabled := act <> nil;
    if (act <> nil) then btnDelete.Caption := act.Caption;
    btnDelete.Caption := '   ' + btnDelete.Caption;
    try
       AutoJoinValue := Item.value['autojoin'];
    except
       act := nil;
    end;
    if (AutoJoinValue = 'false') then
        act := _TypedActs.GetActionNamed('{000-exodus.googlecode.com}-010-join-on-startup')
    else if (AutoJoinValue = 'true') then
        act := _TypedActs.GetActionNamed('{000-exodus.googlecode.com}-010-unjoin-on-startup');
    chkAutoJoin.Tag := Integer(Pointer(act));
    chkAutoJoin.Enabled := act <> nil;
end;

procedure TExRoomHoverFrame.TntFrameMouseEnter(Sender: TObject);
begin
    TExItemHoverForm(Parent).SetHover();
end;

procedure TExRoomHoverFrame.TntFrameMouseLeave(Sender: TObject);
begin
    TExItemHoverForm(Parent).CancelHover();
end;

procedure TExRoomHoverFrame.btnDeleteClick(Sender: TObject);
var
    act: IExodusAction;
begin
    act := IExodusAction(Pointer(TExGraphicButton(Sender).Tag));
    act.Execute(_Items);
end;

procedure TExRoomHoverFrame.btnDeleteMouseEnter(Sender: TObject);
begin
  inherited;
  TExItemHoverForm(Parent).SetHover();
end;

procedure TExRoomHoverFrame.btnDeleteMouseLeave(Sender: TObject);
begin
  inherited;
  TExItemHoverForm(Parent).CancelHover();
end;

procedure TExRoomHoverFrame.btnJoinTCClick(Sender: TObject);
var
    act: IExodusAction;
begin
    act := IExodusAction(Pointer(TExGraphicButton(Sender).Tag));
    act.Execute(_Items);
end;

procedure TExRoomHoverFrame.btnJoinTCMouseEnter(Sender: TObject);
begin
  inherited;
  TExItemHoverForm(Parent).SetHover();
end;

procedure TExRoomHoverFrame.btnJoinTCMouseLeave(Sender: TObject);
begin
  inherited;
  TExItemHoverForm(Parent).CancelHover();
end;

procedure TExRoomHoverFrame.btnRenameClick(Sender: TObject);
var
    act: IExodusAction;
begin
    act := IExodusAction(Pointer(TExGraphicButton(Sender).Tag));
    act.Execute(_Items);
end;

procedure TExRoomHoverFrame.btnRenameMouseEnter(Sender: TObject);
begin
  inherited;
  TExItemHoverForm(Parent).SetHover();
end;

procedure TExRoomHoverFrame.btnRenameMouseLeave(Sender: TObject);
begin
  inherited;
  TExItemHoverForm(Parent).CancelHover();
end;

procedure TExRoomHoverFrame.chkAutoJoinClick(Sender: TObject);
var
    act: IExodusAction;
begin
    act := IExodusAction(Pointer(chkAutoJoin.Tag));
    act.Execute(_Items);
    
    _BuildActions();

end;


procedure TExRoomHoverFrame.chkAutoJoinMouseEnter(Sender: TObject);
begin
  inherited;
  TExItemHoverForm(Parent).SetHover();
end;

procedure TExRoomHoverFrame.chkAutoJoinMouseLeave(Sender: TObject);
begin
  inherited;
  TExItemHoverForm(Parent).CancelHover();
end;

procedure TExRoomHoverFrame.imgRoomMouseEnter(Sender: TObject);
begin
  inherited;
  TExItemHoverForm(Parent).SetHover();
end;

procedure TExRoomHoverFrame.imgRoomMouseLeave(Sender: TObject);
begin
  inherited;
  TExItemHoverForm(Parent).CancelHover();
end;


procedure TExRoomHoverFrame.lblAffiliationMouseLeave(Sender: TObject);
begin
  inherited;
  TExItemHoverForm(Parent).SetHover();
end;

procedure TExRoomHoverFrame.lblAffiliationMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  TExItemHoverForm(Parent).CancelHover();
end;

procedure TExRoomHoverFrame.lblParticipantsMouseEnter(Sender: TObject);
begin
  inherited;
  TExItemHoverForm(Parent).CancelHover();
end;

procedure TExRoomHoverFrame.lblParticipantsMouseLeave(Sender: TObject);
begin
  inherited;
  TExItemHoverForm(Parent).CancelHover();
end;

procedure TExRoomHoverFrame.RoomDisplayNameMouseEnter(Sender: TObject);
begin
  inherited;
  TExItemHoverForm(Parent).SetHover();
end;

procedure TExRoomHoverFrame.RoomDisplayNameMouseLeave(Sender: TObject);
begin
  inherited;
  TExItemHoverForm(Parent).CancelHover();
end;

procedure TExRoomHoverFrame.lblRoomUIDMouseEnter(Sender: TObject);
begin
  inherited;
  TExItemHoverForm(Parent).SetHover();
end;

procedure TExRoomHoverFrame.lblRoomUIDMouseLeave(Sender: TObject);
begin
  inherited;
  TExItemHoverForm(Parent).CancelHover();
end;


procedure TExRoomHoverFrame.lblSubjectMouseEnter(Sender: TObject);
begin
  inherited;
  TExItemHoverForm(Parent).SetHover();
end;

procedure TExRoomHoverFrame.lblSubjectMouseLeave(Sender: TObject);
begin
  inherited;
  TExItemHoverForm(Parent).CancelHover();
end;

end.
