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
unit InputPassword;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, buttonFrame, StdCtrls, TntStdCtrls, ExForm, TntForms, ExFrame;

type
  TfrmInputPass = class(TExForm)
    Label1: TTntLabel;
    frameButtons1: TframeButtons;
    txtPassword: TTntEdit;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure txtPasswordOnChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    RequireInput: boolean;
  end;

function InputQueryW(const ACaption, APrompt: WideString; var Value: WideString; password:boolean = False; RequireInput: Boolean = True): Boolean;

implementation

uses
    JabberUtils, ExUtils,  GnuGetText;
{$R *.dfm}

function InputQueryW(const ACaption, APrompt: WideString; var Value: WideString; password:boolean = False; RequireInput: Boolean = True): Boolean;
var
    w, h: integer;
    r: TRect;
    pf: TfrmInputPass;
begin
    result := false;
    pf := TfrmInputPass.Create(Application);
    with pf do begin
        Caption := ACaption;

        r.top := Label1.Top;
        r.Left := Label1.Left;
        r.right := r.left + 1;
        r.Bottom := r.top + 1;

        DrawTextExW(pf.Canvas.Handle, PWideChar(APrompt), Length(APrompt), r,
            DT_CALCRECT, nil);

        w := r.Right - r.Left + 10;
        h := r.Bottom - r.Top + 10;

        Label1.SetBounds(r.Left, r.Top, w, h);
        txtPassword.Top := r.Bottom + 15;

        pf.ClientHeight := txtPassword.Top + txtPassword.Height + 60;
        w := w + 40;
        if (w > 265) then pf.ClientWidth := w;
        Label1.Caption := APrompt;
        txtPassword.Text := Value;
    end;

    AssignUnicodeFont(pf, 9);
    if (not password) then
        pf.txtPassword.PasswordChar := #0;

    if (RequireInput) then 
        pf.frameButtons1.btnOK.Enabled := false
    else
        pf.frameButtons1.btnOk.Enabled := true;

    pf.RequireInput := RequireInput;

    if (Value <> '') then pf.frameButtons1.btnOK.Enabled := true;    

    if (pf.ShowModal) = mrOK then begin
        Value := pf.txtPassword.Text;
        result := true;
    end;
    pf.Close();
end;

procedure TfrmInputPass.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
    Action := caFree;
end;

procedure TfrmInputPass.FormCreate(Sender: TObject);
begin
    RequireInput := true;
    TranslateComponent(Self);
end;

procedure TfrmInputPass.txtPasswordOnChange(Sender: TObject);
var
    txt: string;
begin
    if (RequireInput) then begin
        txt := Trim(txtPassword.Text);
        if (Length(txt) > 0) then
            frameButtons1.btnOK.Enabled := true
        else
            frameButtons1.btnOK.Enabled := false;
    end;
end;

end.
