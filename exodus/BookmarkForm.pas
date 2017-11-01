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
unit BookmarkForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExForm, StdCtrls, TntStdCtrls, TntForms, ExFrame, buttonFrame, Unicode,
  StateForm;

type
  TBookMarkForm = class(TfrmState)
    NameLabel: TTntLabel;
    frameButtons1: TframeButtons;
    txtName: TTntEdit;
    cboGroup: TTntComboBox;
    GroupLabel: TTntLabel;
    procedure TntFormCreate(Sender: TObject);
    procedure cboGroupChange(Sender: TObject);
    procedure txtNameChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

//var
//  Form4: TForm4;

function ShowAddBookmark(var Value: WideString;
                          var Groups: TWideStringList) : Boolean;

implementation
uses Session, Exodus_TLB;
{$R *.dfm}

function ShowAddBookmark(var Value: WideString;
                         var Groups: TWideStringList) : Boolean;
var
   f: TBookMarkForm;
begin
   Result := false;
   f := TBookMarkForm.Create(Application);

   f.txtName.Text := Value;
   f.frameButtons1.btnOK.Enabled := true;
   if (f.ShowModal = mrOK) then
   begin
       Value :=  f.txtName.Text;
       Groups.Add(f.cboGroup.Text);
       Result := true;
   end;
end;

procedure TBookMarkForm.cboGroupChange(Sender: TObject);
begin
  inherited;
  if (WideTrim(cboGroup.Text)) <> '' then
      frameButtons1.btnOK.Enabled := true
  else
      frameButtons1.btnOK.Enabled := false;
end;

procedure TBookMarkForm.TntFormCreate(Sender: TObject);
var
    i: Integer;
    Items: IExodusItemList;
begin
    inherited;
    Items := MainSession.ItemController.GetItemsByType('group');
    for i := 0 to items.Count - 1 do begin
        cboGroup.Items.Add(items.Item[i].UID);
    end;
    cboGroup.Text := MainSession.Prefs.getString('roster_default');
end;

procedure TBookMarkForm.txtNameChange(Sender: TObject);
begin
  inherited;
  if (WideTrim(txtName.Text)) <> '' then
      frameButtons1.btnOK.Enabled := true
  else
      frameButtons1.btnOK.Enabled := false;
end;

end.
