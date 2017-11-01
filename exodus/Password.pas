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
unit Password;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls, 
  Buttons, buttonFrame, TntStdCtrls, StrUtils, Dialogs, Session, ExForm,
  TntForms, ExFrame;

type
  TfrmPassword = class(TExForm)
    Label1: TTntLabel;
    txtOldPassword: TTntEdit;
    frameButtons1: TframeButtons;
    Label2: TTntLabel;
    txtNewPassword: TTntEdit;
    Label3: TTntLabel;
    txtConfirmPassword: TTntEdit;
    procedure FormCreate(Sender: TObject);
    function  validateInput(): boolean;
    procedure OnChangeText(Sender: TObject);
    procedure frmOnCloseQuery(Sender: TObject; var CanClose: Boolean);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmPassword: TfrmPassword;

  const
    sPasswordOldError = 'Old password is incorrect.';
    sPasswordNewError = 'New password does not match.';

implementation

{$R *.dfm}
uses
    JabberUtils, ExUtils,  GnuGetText;

procedure TfrmPassword.FormCreate(Sender: TObject);
begin
    AssignUnicodeFont(Self);
    TranslateComponent(Self);
    frameButtons1.btnOK.Enabled := false;
end;

procedure TfrmPassword.frmOnCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
    if (ModalResult = mrOK) then
        CanClose := validateInput()
    else
        CanClose := true;
end;

procedure TfrmPassword.OnChangeText(Sender: TObject);
begin
    if ((txtOldPassword.Text <> '') and
        (txtNewPassword.Text <> '') and
        (txtConfirmPassword.Text <> '')) then
      frameButtons1.btnOK.Enabled := true
    else
      frameButtons1.btnOK.Enabled := false;
end;

function TfrmPassword.validateInput(): boolean;
begin
    Result := false;
    if (txtOldPassword.Text <> MainSession.Password) then begin
        MessageDlgW(_(sPasswordOldError), mtError, [mbOK], 0);
        Exit;
    end;
    if (txtNewPassword.Text <> txtConfirmPassword.Text) then begin
        MessageDlgW(_(sPasswordNewError), mtError, [mbOK], 0);
        Exit;
    end;
    Result := true;
end;

end.

