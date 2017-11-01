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
unit GrpManagement;


interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, TntStdCtrls, buttonFrame, ExForm, TntForms, ExFrame,
  Exodus_TLB;

type
  TGroupOperationType = (tgoAsk, tgoCopy, tgoMove);
  TfrmGrpManagement = class(TExForm)
    frameButtons1: TframeButtons;
    optMove: TTntRadioButton;
    optCopy: TTntRadioButton;
    lstGroups: TTntListBox;
    lblTitle: TTntLabel;
    procedure FormCreate(Sender: TObject);
    procedure frameButtons1btnOKClick(Sender: TObject);
    procedure frameButtons1btnCancelClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure optChangeGroupOpClick(Sender: TObject);
    procedure lstGroupsClick(Sender: TObject);
    procedure lstGroupsDblClick(Sender: TObject);
  private
    { Private declarations }
    _items: IExodusItemList;
    _op: TGroupOperationType;

    constructor Create(AOwner: TComponent; op: TGroupOperationType);

  public
    { Public declarations }
    procedure setItems(items: IExodusItemList);
  end;


function ShowGrpManagement(
        items: IExodusItemList;
        op: TGroupOperationType = tgoAsk): TfrmGrpManagement;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
implementation

{$R *.dfm}
uses
    ContactController, Session, JabberUtils, ExUtils,  GnuGetText, GroupParser;

{---------------------------------------}
function ShowGrpManagement(
        items: IExodusItemList;
        op: TGroupOperationType): TfrmGrpManagement;
begin
    Result := TfrmGrpManagement.Create(Application, op);
    Result.setItems(items);
    Result.Show;
end;

{---------------------------------------}
constructor TfrmGrpManagement.Create(AOwner: TComponent; op: TGroupOperationType);
begin
    _op := op;

    inherited Create(AOwner);
end;
{---------------------------------------}
procedure TfrmGrpManagement.FormCreate(Sender: TObject);
var
    idx: Integer;
    grps: IExodusItemList;
begin
    AssignUnicodeFont(Self);
    TranslateComponent(Self);
    grps := MainSession.ItemController.GetItemsByType('group');
    for idx := 0 to grps.Count - 1 do begin
        lstGroups.Items.Add(grps.Item[idx].UID);
    end;
    lstGroups.ItemIndex := lstGroups.Items.IndexOf(MainSession.Prefs.getString('roster_default'));

    //Display the right controls based on the operation...
    if (_op <> tgoAsk) then begin
        lblTitle.Visible := true;
        optCopy.Visible := false;
        optMove.Visible := false;

        if (_op = tgoCopy) then
            lblTitle.Caption := optCopy.Caption
        else if (_op = tgoMove) then
             lblTitle.Caption := optMove.Caption;
    end
    else begin
        if optCopy.Checked then
            _op := tgoCopy
        else if optMove.Checked then
            _op := tgoMove;
    end;
end;

{---------------------------------------}
procedure TfrmGrpManagement.setItems(items: IExodusItemList);
begin
    _items := items;
end;

{---------------------------------------}
procedure TfrmGrpManagement.frameButtons1btnOKClick(Sender: TObject);
var
    new_grp: Widestring;
    itemCtrl: IExodusItemController;
    idx: Integer;
begin
    Self.Close();

    if (lstGroups.ItemIndex = -1) then exit;
    if ((_items = nil) or (_items.Count <= 0)) then exit;

    itemCtrl := MainSession.ItemController;
    new_grp := lstGroups.Items[lstGroups.ItemIndex];

    for idx := 0 to _items.Count - 1 do begin
        case _op of
            tgoCopy: itemCtrl.CopyItem(_items.Item[idx].UID, new_grp);
            tgoMove: itemCtrl.MoveItem(_items.Item[idx].UID, '', new_grp);
        end;
    end;
end;

procedure TfrmGrpManagement.lstGroupsClick(Sender: TObject);
begin
    frameButtons1.btnOK.Enabled := (lstGroups.ItemIndex <> -1);
end;

procedure TfrmGrpManagement.lstGroupsDblClick(Sender: TObject);
begin
    if (frameButtons1.btnOK.Enabled) or (lstGroups.ItemIndex <> -1) then
        frameButtons1btnOKClick(Sender);
end;

procedure TfrmGrpManagement.optChangeGroupOpClick(Sender: TObject);
begin
  inherited;

  if (Sender = optMove) then
    _op := tgoMove
  else if (Sender = optCopy) then
    _op := tgoCopy;
end;

{---------------------------------------}
procedure TfrmGrpManagement.frameButtons1btnCancelClick(Sender: TObject);
begin
    Self.Close();
end;

{---------------------------------------}
procedure TfrmGrpManagement.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
    Action := caFree;
end;

{---------------------------------------}
procedure TfrmGrpManagement.FormDestroy(Sender: TObject);
begin
    if (_items <> nil) then _items := nil;
end;

end.
