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
unit PrefRoster;


interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, PrefPanel, StdCtrls, TntComCtrls, TntStdCtrls, ExtCtrls, TntExtCtrls, ExGroupBox,
  Buttons, TntButtons, TntForms,
  Unicode,
  ExFrame, ExBrandPanel, ExNUmericEdit, ComCtrls;

type
  TfrmPrefRoster = class(TfrmPrefPanel)
    ExGroupBox1: TExBrandPanel;
    pnlRosterPrefs: TExBrandPanel;
    chkInlineStatus: TTntCheckBox;
    chkUseProfileDN: TTntCheckBox;
    chkHideBlocked: TTntCheckBox;
    chkGroupCounts: TTntCheckBox;
    pnlManageBtn: TExBrandPanel;
    btnManageBlocked: TTntButton;
    grpAdvanced: TExGroupBox;
    gbDepricated: TExGroupBox;
    chkSort: TTntCheckBox;
    chkOfflineGrp: TTntCheckBox;
    pnlMinStatus: TExBrandPanel;
    lblFilter: TTntLabel;
    cboVisible: TTntComboBox;
    pnlGatewayGroup: TExBrandPanel;
    lblGatewayGrp: TTntLabel;
    txtGatewayGrp: TTntComboBox;
    chkPresErrors: TTntCheckBox;
    chkShowUnsubs: TTntCheckBox;
    chkRosterUnicode: TTntCheckBox;
    chkRosterAvatars: TTntCheckBox;
    pnlDblClickAction: TExBrandPanel;
    lblDblClick: TTntLabel;
    cboDblClick: TTntComboBox;
    pnlGroupSeparator: TExBrandPanel;
    lblGrpSeparator: TTntLabel;
    txtGrpSeparator: TTntEdit;
    pnlDefaultNIck: TExBrandPanel;
    lblDefaultNick: TTntLabel;
    txtDefaultNick: TTntEdit;
    pnlStatusColor: TExBrandPanel;
    lblStatusColor: TTntLabel;
    cboStatusColor: TColorBox;
    pnlDNFields: TExBrandPanel;
    lblDNProfileMap: TTntLabel;
    txtDNProfileMap: TTntEdit;
    pnlDefaultGroup: TExBrandPanel;
    lblDefaultGrp: TTntLabel;
    txtDefaultGrp: TTntComboBox;
    pnlAlpha: TExBrandPanel;
    chkRosterAlpha: TTntCheckBox;
    trkRosterAlpha: TTrackBar;
    txtRosterAlpha: TExNumericEdit;
    chkCollapsed: TTntCheckBox;
    chkNestedGrps: TTntCheckBox;
    chkShowPending: TTntCheckBox;
    chkHover: TTntCheckBox;
    chkObservers: TTntCheckBox;
    procedure TntFormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnManageBlockedClick(Sender: TObject);
    procedure txtRosterAlphaChange(Sender: TObject);
    procedure trkRosterAlphaChange(Sender: TObject);
    procedure chkRosterAlphaClick(Sender: TObject);
  private
    _blockedContacts: TWideStringList;
  public
    { Public declarations }
    procedure LoadPrefs(); override;
    procedure SavePrefs(); override;
  end;

//var
//  frmPrefRoster: TfrmPrefRoster;

implementation

{$R *.dfm}

uses
    JabberUtils, ExUtils,  Session,
    PrefFile, PrefController,
    ManageBlockDlg, Exodus_TLB;

procedure TfrmPrefRoster.btnManageBlockedClick(Sender: TObject);
var
    bdlg: TManageBlockDlg;
begin
    inherited;
    bdlg := TManageBlockDlg.Create(Self);
    bdlg.setBlockers(_blockedContacts);
    if (bdlg.ShowModal = mrOK) then
        bdlg.getBlockers(_blockedContacts);
    bdlg.Free();
end;

procedure TfrmPrefRoster.chkRosterAlphaClick(Sender: TObject);
begin
  inherited;
  trkRosterAlpha.Enabled := chkRosterAlpha.Checked;
  txtRosterAlpha.Enabled := chkRosterAlpha.Checked;
end;

procedure TfrmPrefRoster.FormCreate(Sender: TObject);
begin
    _blockedContacts := TWideStringList.Create();
    inherited;

end;

procedure TfrmPrefRoster.LoadPrefs();
var
    gs: TWidestringList;
    Items: IExodusItemList;
    i: Integer;
begin
    inherited;
    //blocked contacts
    MainSession.prefs.fillStringlist('blockers', _blockedContacts);

    // populate grp drop-downs.
    gs := TWidestringList.Create();

    Items := MainSession.ItemController.GetItemsByType('group');
    for i := 0 to items.Count - 1 do
        gs.Add(items.Item[i].UID);

    gs.Sorted := true;
    gs.Sort();

    AssignTntStrings(gs, txtDefaultGrp.Items);


  //populate gateway group cbo
    if (gs.IndexOf(txtGatewayGrp.Text) = -1) then
        gs.Add(txtGatewayGrp.Text);
    gs.Sort();
    AssignTntStrings(gs, txtGatewayGrp.Items);
    gs.Free();

    trkRosterAlpha.Visible := chkRosterAlpha.Visible;
    txtRosterAlpha.Visible := chkRosterAlpha.Visible;
    if (chkRosterAlpha.Visible) then
      chkRosterAlphaClick(Self);

    //disable/hide based on brand
    if (not MainSession.Prefs.getBool('brand_allow_blocking_jids')) then begin
        chkHideBlocked.Enabled := false;
        chkHideBlocked.visible := false;
        btnManageBlocked.Visible := false;
    end;
        //hide nick panel if branded locked down or if pref is locked down
    if (MainSession.Prefs.GetBool('brand_prevent_change_nick')) then begin
        lblDefaultNick.Visible := false;
        txtDefaultNick.Visible := false;
    end;

    if (not MainSession.Prefs.getBool('branding_nested_subgroup')) then begin
        txtGrpSeparator.Visible := false;
        chkNestedGrps.Visible := false;
        lblGrpSeparator.Visible := false;

        chkNestedGrps.Checked := false;
    end;

    ExGroupBox1.checkAutoHide();
end;

procedure TfrmPrefRoster.SavePrefs();
begin
    inherited;
        
    MainSession.prefs.setStringlist('blockers', _blockedContacts);
    // XXX: save nested group separator per JEP-48
end;

procedure TfrmPrefRoster.TntFormDestroy(Sender: TObject);
begin
    inherited;
    _blockedContacts.Free();
end;

procedure TfrmPrefRoster.trkRosterAlphaChange(Sender: TObject);
begin
    inherited;
    txtRosterAlpha.Text := IntToStr(trkRosterAlpha.Position);
end;

procedure TfrmPrefRoster.txtRosterAlphaChange(Sender: TObject);
begin
    inherited;
    try
        trkRosterAlpha.Position := StrToInt(txtRosterAlpha.Text);
    except
    end;
end;

end.
