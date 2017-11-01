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
unit PrefMsg;


interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, PrefPanel, StdCtrls, TntStdCtrls, ExtCtrls, TntExtCtrls, ExGroupBox,
  TntForms, ExFrame, ExBrandPanel;

const
    S10N_PROMPT_ALL = 0;
    S10N_AUTO_ACCEPT_CONTACTS = 1;
    S10N_AUTO_ACCEPT_ALL = 2;
    S10N_AUTO_DENY_ALL = 3;
    
type
  TfrmPrefMsg = class(TfrmPrefPanel)
    pnlContainer: TExBrandPanel;
    gbSubscriptions: TExGroupBox;
    chkIncomingS10nAdd: TTntCheckBox;
    rbAcceptContacts: TTntRadioButton;
    rbAcceptAll: TTntRadioButton;
    rbDenyAll: TTntRadioButton;
    rbPromptAll: TTntRadioButton;
    pnlOtherPrefs: TExGroupBox;
    chkInviteAutoJoin: TTntCheckBox;
    chkBlockNonRoster: TTntCheckBox;
    pnlS10NOpts: TExBrandPanel;
    gbAdvancedPrefs: TExGroupBox;
    btnManageKeywords: TTntButton;
    procedure btnManageKeywordsClick(Sender: TObject);
  private
    { Private declarations }
  public
    procedure LoadPrefs(); override;
    procedure SavePrefs(); override;
  end;

implementation
{$WARN UNIT_PLATFORM OFF}
{$R *.dfm}
uses
    JabberUtils, ExUtils,  FileCtrl, Session, Unicode,
    PrefFile, PrefController, ManageKeywordsDlg;

procedure TfrmPrefMsg.btnManageKeywordsClick(Sender: TObject);
var
    tkw: TManageKeywordsDlg;
begin
    inherited;
    tkw := TManageKeywordsDlg.Create(Self);
    tkw.ShowModal();
    tkw.Free();
end;

procedure TfrmPrefMsg.LoadPrefs();
var
    s: TPrefState;
begin
    inherited;

    s := GetPrefState('s10n_auto_accept');
    pnlS10NOpts.Visible := (s <> psInvisible);
    pnlS10NOpts.enabled := (s <> psReadOnly);

    case (MainSession.prefs.getInt('s10n_auto_accept')) of
        S10N_AUTO_ACCEPT_CONTACTS: rbAcceptContacts.checked := true;
        S10N_AUTO_ACCEPT_ALL: rbAcceptAll.checked := true;
        S10N_AUTO_DENY_ALL: rbDenyAll.checked := true;
        else rbPromptAll.checked := true;
    end;

    s := getPrefState('keywords');
    btnManageKeywords.Visible := (s <> psInvisible);
    btnManageKeywords.Enabled := (s <> psReadOnly);

    pnlContainer.CaptureChildStates();
    pnlContainer.CheckAutoHide();
end;

procedure TfrmPrefMsg.SavePrefs();
var
    sval: widestring;
begin
    inherited;
    if (rbAcceptContacts.checked) then
        sval := '1'
    else if (rbAcceptAll.checked) then
        sval := '2'
    else if (rbDenyAll.checked) then
        sval := '3'
    else
        sval := '0';
    MainSession.Prefs.setString('s10n_auto_accept', sval);
end;

end.
