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
unit toastsettings;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  ExForm,
  Dialogs, StdCtrls, TntStdCtrls, ExtCtrls, ExNumericEdit, TntForms, ExFrame,
  ExBrandPanel,
  PrefNotify,
  Session,
  ComCtrls;

type
  TToastSettings = class(TExForm)
    chkToastAlpha: TTntCheckBox;
    trkToastAlpha: TTrackBar;
    lblSliderTitle: TTntLabel;
    pnlAlphaSlider: TExBrandPanel;
    lblLess: TTntLabel;
    lblMore: TTntLabel;
    pnlToastDuration: TExBrandPanel;
    lblToastDuration: TTntLabel;
    txtToastDuration: TExNumericEdit;
    lblSeconds: TTntLabel;
    btnOK: TTntButton;
    btnCancel: TTntButton;
    procedure btnOKClick(Sender: TObject);
    procedure chkToastAlphaClick(Sender: TObject);
  private
    _origtoastAlpha: TNotifyInfo;
    _origtoastAlphaValue: TNotifyInfo;
    _origtoastDuration: TNotifyInfo;
  public
        procedure setPrefs(toastAlpha: TNotifyInfo; toastAlphaValue: TNotifyInfo; toastDuration: TNotifyInfo);
  end;

implementation

{$R *.dfm}

procedure TToastSettings.btnOKClick(Sender: TObject);
begin
  inherited;
  _origToastAlpha.BoolValue := chkToastAlpha.Checked;
  _origToastAlphaValue.IntValue := trkToastAlpha.Position;
  _origToastDuration.Value := txtToastDuration.Text;
end;

procedure TToastSettings.chkToastAlphaClick(Sender: TObject);
begin
    inherited;
    pnlAlphaSlider.Enabled := chkToastAlpha.Checked;
end;

procedure TToastSettings.setPrefs(toastAlpha: TNotifyInfo; toastAlphaValue: TNotifyInfo; toastDuration: TNotifyInfo);
var
    tval: integer;
begin
    _origtoastAlpha := toastAlpha;
    _origtoastAlphaValue := toastAlphaValue;
    _origtoastDuration := toastDuration;

    chkToastAlpha.Visible := toastAlpha.IsVisible;
    chkToastAlpha.Enabled := not toastAlpha.IsReadonly;
    chkToastAlpha.Checked := toastAlpha.BoolValue;

    pnlAlphaSlider.Visible := toastAlphaValue.IsVisible;
    pnlAlphaSlider.Enabled := not toastAlphaValue.IsReadonly;
    tval := toastAlphaValue.IntValue;
    if (tval > 255) then
        tval := 255;
    if (tval < 100) then
        tval := 100;
    trkToastAlpha.Position := tval;
    pnlAlphaSlider.captureChildStates(); //capture branded enabled state
    pnlAlphaSlider.Enabled := chkToastAlpha.Checked;

    pnlToastDuration.Visible := toastDuration.IsVisible;
    pnlToastDuration.Enabled := not toastDuration.IsReadOnly;
    tval := toastDuration.IntValue;
    if (tval > 15) then
        tval := 15;
    if (tval < 1) then
        tval := 1;
    txtToastDuration.Text := IntToStr(tval);
end;

end.
