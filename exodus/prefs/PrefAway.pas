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
unit PrefAway;


interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, PrefPanel, StdCtrls, ComCtrls, TntStdCtrls, ExtCtrls,
  TntExtCtrls, ExNumericEdit, ExGroupBox, ExCheckGroupBox, TntForms, ExFrame,
  ExBrandPanel;

type
  TfrmPrefAway = class(TfrmPrefPanel)
    pnlContainer: TExBrandPanel;
    chkAutoAway: TExCheckGroupBox;
    pnlAwayTime: TExBrandPanel;
    lblAwayTime: TTntLabel;
    txtAwayTime: TExNumericEdit;
    chkAAReducePri: TTntCheckBox;
    chkAwayAutoResponse: TTntCheckBox;
    ExBrandPanel2: TExBrandPanel;
    lblAwayStatus: TTntLabel;
    txtAway: TTntEdit;
    chkAutoXA: TExCheckGroupBox;
    ExBrandPanel3: TExBrandPanel;
    lblXATime: TTntLabel;
    txtXATime: TExNumericEdit;
    ExBrandPanel4: TExBrandPanel;
    lblXAStatus: TTntLabel;
    txtXA: TTntEdit;
    chkAutoDisconnect: TExCheckGroupBox;
    lblDisconnectTime: TTntLabel;
    txtDisconnectTime: TExNumericEdit;
    chkAwayScreenSaver: TTntCheckBox;
    chkAwayFullScreen: TTntCheckBox;
    procedure chkAutoDisconnectCheckChanged(Sender: TObject);
    procedure chkAutoXACheckChanged(Sender: TObject);
    procedure chkAutoAwayCheckChanged(Sender: TObject);
  private
    _lastAutoXA: boolean;
    _lastAutoDisconnect: boolean;
  public
    { Public declarations }
    procedure LoadPrefs(); override;
    procedure SavePrefs();override;
  end;

var
  frmPrefAway: TfrmPrefAway;

implementation
{$R *.dfm}
uses
    Session, PrefFile, PrefController,
    Unicode;

procedure TfrmPrefAway.chkAutoDisconnectCheckChanged(Sender: TObject);
begin
    inherited;
    if (chkAutoAway.Checked) then
        _lastAutoDisconnect := chkAutoDisconnect.Checked;
end;

procedure TfrmPrefAway.chkAutoXACheckChanged(Sender: TObject);
begin
    inherited;
    if (chkAutoAway.Checked) then
        _lastAutoXA := chkAutoXA.Checked;
end;

procedure TfrmPrefAway.LoadPrefs();
begin
    inherited;

    //set the initial visible, enabled states of the check group boxes
    chkAutoAway.CanEnabled := (getPrefState('auto_away') <> psReadOnly);
    chkAutoXA.CanEnabled := (getPrefState('auto_xa') <> psReadOnly);
    chkAutoDisconnect.CanEnabled := (getPrefState('auto_disconnect') <> psReadOnly);

    pnlContainer.captureChildStates();
    pnlContainer.checkAutoHide();

    _lastAutoXA := chkAutoXA.Checked;
    _lastAutoDisconnect := chkAutoDisconnect.Checked;

    //fire the autoaway check click event to get initial states correct
    chkAutoAway.chkBoxClick(Self);
end;

procedure TfrmPrefAway.SavePrefs();
var
    tb1, tb2: boolean;
begin
    //make sure disabled xa and disconnect have the correct values before save
    tb1 := chkAutoXA.Checked;
    tb2 := chkAutoDisconnect.Checked;
    chkAutoXA.Checked := _lastAutoXA;
    chkAutoDisconnect.Checked := _lastAutoDisconnect;

    inherited;

    //and set them back (in case of apply)
    chkAutoXA.Checked := tb1;
    chkAutoDisconnect.Checked := tb2;

end;


procedure TfrmPrefAway.chkAutoAwayCheckChanged(Sender: TObject);
begin
    if (not chkAutoAway.Checked) then begin
        _lastAutoXA := chkAutoXA.Checked;
        _lastAutoDisconnect := chkAutoDisconnect.Checked;

        chkAutoXA.Checked := false;
        chkAutoDisconnect.Checked := false;
    end
    else begin
        chkAutoXA.Checked := _lastAutoXA;
        chkAutoDisconnect.Checked := _lastAutoDisconnect;
    end;

    Self.chkAutoXA.Enabled := chkAutoAway.Checked;
    Self.chkAutoDisconnect.Enabled := chkAutoAway.Checked;
end;

end.
