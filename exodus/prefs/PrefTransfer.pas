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
unit PrefTransfer;


interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, PrefPanel, StdCtrls, TntStdCtrls, ExtCtrls, TntExtCtrls, TntForms,
  ExFrame, ExBrandPanel, ExGroupBox;

const
    xfer_socks = 0;
    xfer_proxy = 1;
    xfer_oob = 2;
    xfer_dav = 3;

type
  TfrmPrefTransfer = class(TfrmPrefPanel)
    lblXferPath: TTntLabel;
    txtXFerPath: TTntEdit;
    btnTransferBrowse: TTntButton;
    lblXferDefault: TTntLabel;
    grpPeer: TGroupBox;
    lblXferPort: TTntLabel;
    txtXferPort: TTntEdit;
    chkXferIP: TTntCheckBox;
    txtXferIP: TTntEdit;
    grpWebDav: TGroupBox;
    lblDavHost: TTntLabel;
    txtDavHost: TTntEdit;
    txtDavPort: TTntEdit;
    lblDavPort: TTntLabel;
    txtDavPath: TTntEdit;
    lblDavPath: TTntLabel;
    lblDavPath2: TTntLabel;
    lblDavUsername: TTntLabel;
    txtDavUsername: TTntEdit;
    txtDavPassword: TTntEdit;
    lblDavPassword: TTntLabel;
    lblDavHost2: TTntLabel;
    cboXferMode: TTntComboBox;
    grpProxy: TGroupBox;
    lbl65Proxy: TTntLabel;
    txt65Proxy: TTntEdit;
    lblXferMethod: TTntLabel;
    gbProxy: TExGroupBox;
    rbIE: TTntRadioButton;
    rbNone: TTntRadioButton;
    rbCustom: TTntRadioButton;
    pnlProxyInfo: TExBrandPanel;
    lblProxyHost: TTntLabel;
    lblProxyPort: TTntLabel;
    txtProxyHost: TTntEdit;
    txtProxyPort: TTntEdit;
    pnlAuthInfo: TExBrandPanel;
    lblProxyUsername: TTntLabel;
    lblProxyPassword: TTntLabel;
    chkProxyAuth: TTntCheckBox;
    txtProxyUsername: TTntEdit;
    txtProxyPassword: TTntEdit;
    procedure chkProxyAuthClick(Sender: TObject);
    procedure rbIEClick(Sender: TObject);
    procedure btnTransferBrowseClick(Sender: TObject);
    procedure chkXferIPClick(Sender: TObject);
    procedure lblXferDefaultClick(Sender: TObject);
    procedure cboXferModeChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure LoadPrefs(); override;
    procedure SavePrefs(); override;
  end;

var
    frmPrefTransfer: TfrmPrefTransfer;

const
    sPrefsXFerDir = 'Select download directory';
    sBadProxy = 'Your IE proxy settings won''t help, since you use an autoconfiguration script.  Please configure your proxy manually.';


implementation
{$WARN UNIT_PLATFORM OFF}
{$R *.dfm}
uses
    JabberUtils, PrefFile, Registry, GnuGetText, ExUtils,  Session, FileCtrl, PrefController;

procedure TfrmPrefTransfer.LoadPrefs();
var
    m: integer;
    pType: integer;
    s: TPrefState;
begin
    inherited;
    with MainSession.Prefs do begin
        m := xfer_socks;
        if (getBool('xfer_webdav')) then m := xfer_dav;
        if (getBool('xfer_proxy')) then m := xfer_proxy;
        if (getBool('xfer_oob')) then m := xfer_oob;
        cboXferMode.ItemIndex := m;
        cboXferModeChange(Self);
        ptype := MainSession.Prefs.getInt('http_proxy_approach');
        case (ptype) of
            http_proxy_ie: rbIE.Checked := true;
            http_proxy_none: rbNone.Checked := true;
            else rbCustom.Checked := true;
        end;

        s := getPrefState('http_proxy_approach');
        rbIe.Visible := (s <> psInvisible);
        rbIE.Enabled := (s <> psReadOnly);
        rbNone.Visible := (s <> psInvisible);
        rbNone.enabled := (s <> psReadOnly);
        rbCustom.Visible := (s <> psInvisible);
        rbCustom.Enabled := (s <> psReadOnly);
        pnlProxyInfo.Visible := (s <> psInvisible);
        pnlProxyInfo.Enabled := (s <> psReadOnly);
        pnlAuthInfo.Visible := (s <> psInvisible);
        pnlAuthInfo.Enabled := (s <> psReadOnly);

        rbIEClick(Self);

    end;
end;


procedure TfrmPrefTransfer.rbIEClick(Sender: TObject);
begin
  inherited;
    inherited;
    pnlProxyInfo.Enabled := rbCustom.Checked;
    pnlAuthInfo.Enabled := rbCustom.Checked;
    if (not rbCustom.Checked) then
        chkProxyAuth.Checked := false;
    chkProxyAuthClick(Self);
end;

procedure TfrmPrefTransfer.SavePrefs();
var
    m: integer;
    reg: TRegistry;
    ptype: integer;
begin
    inherited;
    with MainSession.Prefs do begin
        m := cboXferMode.ItemIndex;
        setBool('xfer_webdav', (m = xfer_dav));
        setBool('xfer_proxy', (m = xfer_proxy));
        setBool('xfer_oob', (m = xfer_oob));

    end;
    if (rbIE.Checked) then
        ptype := http_proxy_ie
    else if (rbNone.Checked) then
        ptype := http_proxy_none
    else
        ptype := http_proxy_custom;

    if (ptype = http_proxy_ie) then begin
        reg := TRegistry.Create();
        try
            reg.OpenKey('Software\Microsoft\Windows\CurrentVersion\Internet Settings', false);
            if (reg.ValueExists('AutoConfigURL')) then begin
                ptype := http_proxy_custom;
                rbCustom.Checked := true;
                rbIEClick(Self);
                txtProxyHost.SetFocus();
                MessageDlgW(_(sBadProxy), mtWarning, [mbOK], 0);
            end;
        finally
            reg.Free();
        end;
    end;
    MainSession.prefs.setInt('http_proxy_approach', ptype);

end;

procedure TfrmPrefTransfer.btnTransferBrowseClick(Sender: TObject);
var
    tmps: string;
begin
    tmps := txtXFerPath.Text;
    if SelectDirectory(sPrefsXFerDir, '', tmps) then
        txtXFerPath.Text := tmps;
end;

procedure TfrmPrefTransfer.chkProxyAuthClick(Sender: TObject);
begin
  inherited;
    lblProxyUsername.Enabled := chkProxyAuth.Checked;
    lblProxyPassword.Enabled := chkProxyAuth.Checked;
    txtProxyUsername.Enabled := chkProxyAuth.Checked;
    txtProxyPassword.Enabled := chkProxyAuth.Checked;
end;

procedure TfrmPrefTransfer.chkXferIPClick(Sender: TObject);
begin
  inherited;
    txtXferIP.Enabled := chkXferIP.Checked;
    if (not txtXferIP.Enabled) then txtXferIP.Text := '';
end;

procedure TfrmPrefTransfer.lblXferDefaultClick(Sender: TObject);
begin
  inherited;
    // reset everything to defaults..
    txtXFerPath.Text := getMyDocs() + getAppInfo().ID + '-Downloads';
    cboXferMode.ItemIndex := 0;
    cboXferModeChange(Self);
    txtXferPort.Text := '5280';
    chkXferIP.Checked := false;
    txtXferIP.Text := '';
    chkXferIPClick(Self);
end;

procedure TfrmPrefTransfer.cboXferModeChange(Sender: TObject);
var
    m: integer;
begin
  inherited;
    // change the grp visible based on itemindex.
    m := cboXferMode.ItemIndex;

    grpPeer.Enabled := (m = xfer_oob);
    grpPeer.Visible := (m = xfer_oob);

    grpWebDav.Enabled := (m = xfer_dav);
    grpWebDav.Visible := (m = xfer_dav);

    grpProxy.Enabled := (m = xfer_proxy);
    grpProxy.Visible := (m = xfer_proxy);
end;

procedure TfrmPrefTransfer.FormCreate(Sender: TObject);
begin
  inherited;
    AssignUnicodeURL(lblXferDefault.Font, 8);
end;

end.
