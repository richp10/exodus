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
unit ConnDetails;


interface

uses
    PrefController,
    Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
    Dialogs, buttonFrame, ComCtrls, StdCtrls, ExtCtrls, TntStdCtrls,
    TntComCtrls, TntExtCtrls, TntForms, ExNumericEdit, TntWindows, JclMime, IdCoderMIME,
	CertSelector, JwaCryptUIApi, JwaWinCrypt, PrefFile, ExForm,
  ExGraphicButton, Buttons, TntButtons, ExGroupBox, ExGradientPanel, ExFrame,
  ExBrandPanel, ExCheckGroupBox;

type
  TOptionSelection = class(TObject)
    private
      _options: Array of TTntRadioButton;
      _selected: Integer;

      function GetSize() : Integer;
      procedure SetSelected(sel : Integer);

    public
      constructor Create(opts: Array of TTntRadioButton);

      property Selected : Integer read _selected write SetSelected default -1;
      property Size : Integer read GetSize;

      procedure Select(Target : TTntRadioButton);
  end;

type
  TfrmConnDetails = class(TExForm)
    PageControl1: TTntPageControl;
    tbsAcctDetails: TTntTabSheet;
    tbsConnection: TTntTabSheet;
    tbsProxy: TTntTabSheet;
    tbsHttpPolling: TTntTabSheet;
    tbsAdvanced: TTntTabSheet;
    lblNote: TTntLabel;
    Panel2: TPanel;
    Panel1: TPanel;
    btnOK: TTntButton;
    btnCancel: TTntButton;
    ExGradientPanel1: TExGradientPanel;
    Panel5: TPanel;
    pnlTabs: TExBrandPanel;
    imgConnection: TExGraphicButton;
    imgProxy: TExGraphicButton;
    imgHttpPolling: TExGraphicButton;
    imgAdvanced: TExGraphicButton;
    imgAcctDetails: TExGraphicButton;
    pnlAccountDetails: TExBrandPanel;
    btnRename: TTntButton;
    chkSavePasswd: TTntCheckBox;
    chkRegister: TTntCheckBox;
    pnlPassword: TExBrandPanel;
    lblPassword: TTntLabel;
    txtPassword: TTntEdit;
    pnlServer: TExBrandPanel;
    lblServer: TTntLabel;
    cboServer: TTntComboBox;
    pnlUsername: TExBrandPanel;
    lblUsername: TTntLabel;
    txtUsername: TTntEdit;
    lblServerList: TTntLabel;
    pnlConnection: TExBrandPanel;
    pnlSRV: TExBrandPanel;
    optSRVManual: TTntRadioButton;
    optSRVAuto: TTntRadioButton;
    pnlManualDetails: TExBrandPanel;
    pnlHost: TExBrandPanel;
    Label4: TTntLabel;
    txtHost: TTntEdit;
    pnlPort: TExBrandPanel;
    Label7: TTntLabel;
    txtPort: TTntEdit;
    pnlSSL: TExGroupBox;
    optSSLoptional: TTntRadioButton;
    optSSLrequired: TTntRadioButton;
    optSSLlegacy: TTntRadioButton;
    pnlPolling: TExCheckGroupBox;
    pnlURL: TExBrandPanel;
    Label1: TTntLabel;
    txtURL: TTntEdit;
    pnlTime: TExBrandPanel;
    Label2: TTntLabel;
    Label5: TTntLabel;
    txtTime: TExNumericEdit;
    pnlKeys: TExBrandPanel;
    Label9: TTntLabel;
    txtKeys: TExNumericEdit;
    pnlProxy: TExBrandPanel;
    pnlSocksType: TExBrandPanel;
    lblSocksType: TTntLabel;
    cboSocksType: TTntComboBox;
    pnlSocksHost: TExBrandPanel;
    lblSocksHost: TTntLabel;
    txtSocksHost: TTntEdit;
    pnlSocksPort: TExBrandPanel;
    lblSocksPort: TTntLabel;
    txtSocksPort: TTntEdit;
    pnlSocksAuth: TExCheckGroupBox;
    pnlSocksUsername: TExBrandPanel;
    lblSocksUsername: TTntLabel;
    txtSocksUsername: TTntEdit;
    pnlSocksPassword: TExBrandPanel;
    lblSocksPassword: TTntLabel;
    txtSocksPassword: TTntEdit;
    pnlAdvanced: TExBrandPanel;
    pnlResource: TExBrandPanel;
    Label12: TTntLabel;
    cboResource: TTntComboBox;
    pnlRealm: TExBrandPanel;
    TntLabel2: TTntLabel;
    txtRealm: TTntEdit;
    pnlPriority: TExBrandPanel;
    Label6: TTntLabel;
    txtPriority: TExNumericEdit;
    pnlKerberos: TExCheckGroupBox;
    chkWinLogin: TTntCheckBox;
    pnlx509Auth: TExCheckGroupBox;
    pnlx509Cert: TExBrandPanel;
    btnx509browse: TTntButton;
    txtx509: TTntEdit;
    procedure frameButtons1btnOKClick(Sender: TObject);
    procedure cboSocksTypeChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure txtUsernameKeyPress(Sender: TObject; var Key: Char);
    procedure lblServerListClick(Sender: TObject);
    procedure optSSLClick(Sender: TObject);
    procedure SRVOptionClick(Sender: TObject);
    procedure chkWinLoginClick(Sender: TObject);
    procedure btnRenameClick(Sender: TObject);
    procedure chkSavePasswdClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
	procedure chkCert(Sender: TObject);
    procedure btnx509browseClick(Sender: TObject);
    procedure chkx509Click(Sender: TObject);
    procedure selectPage(Sender: TObject);
  private
    { Private declarations }
    _profile: TJabberProfile;
    _Canceled: boolean;
    _cur_tab: TExGraphicButton;

    _sslOpts: TOptionSelection;

    _sslCertKey: string;

    function findEnabledPage(): TExGraphicButton;
    function FNStringGetOperatingSystemVersionMicrosoftWindowsS: string;
    function getCertFriendlyName(): string;
    function reallyGetCertFriendlyName(cert: PCCERT_CONTEXT): string;
    procedure RestoreSocket(profile: TJabberProfile);
    procedure SaveSocket(profile: TJabberProfile);
    procedure RestoreHttp(profile: TJabberProfile);
    procedure SaveHttp(profile: TJabberProfile);
    procedure RestoreProfile(profile: TJabberProfile);
    procedure SaveProfile(profile: TJabberProfile);
    procedure RestoreConn(profile: TJabberProfile);
    procedure SaveConn(profile: TJabberProfile);
    function updateProfile(): boolean;
    function encodeCertKey(keyLength: Cardinal; key: Pointer): string;
    procedure decodeCertKey(var key: Pointer; var decodedLength: Cardinal; encodedString: string);
    procedure brandControl(ctrl: TControl);
    procedure brandPage(page: TExGraphicButton);

    function checkVisibility(ctrl: TControl): boolean;
    function updatePages(): Integer;

   end;

var
  frmConnDetails: TfrmConnDetails;

function ShowConnDetails(p: TJabberProfile): integer;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
implementation

{$R *.dfm}

uses
    ExSession, Stringprep, InputPassword, 
    JabberUtils, ExUtils,  GnuGetText, JabberID, Unicode, Session, WebGet, XMLTag, XMLParser,
    Registry, StrUtils, IdCoder;

const
    sSmallKeys = 'Must have a larger number of poll keys.';
    sConnDetails = '%s Details';
    sProfileInvalidJid = 'The Jabber ID you entered (username@server/resource) is invalid. Please enter a valid username, server, and resource.';
    sProfileInvalidUsername = 'The username you entered is invalid. Please re-enter a valid username.';
    sProfileInvalidServer = 'The server you entered is invalid. Please re-enter a valid server.';
    sProfileInvalidResource = 'The resource you entered is invalid. Please re-enter a valid resource.';
    sProfileResourcePassMatch = 'The resource you have provided matches your password.  Please re-enter a valid resource.';
    sResourceWork = 'Work';
    sResourceHome = 'Home';
    sDownloadServers = 'Download the public server list from jabber.org? (Requires an internet connection).';
    sDownloadCaption = 'Downloading public server list';
    sNoSSL = 'This profile is currently to use SSL, however, your system does not have the required libraries to use SSL. Turning SSL OFF.';
    sMissingX509Cert = 'Please specify a certificate for x.509 authentication';
    sDefaultProfileName = 'Default Profile';

{---------------------------------------}
function ShowConnDetails(p: TJabberProfile): integer;
var
    f: TfrmConnDetails;
begin
    //
    f := TfrmConnDetails.Create(nil);

    if ((MainSession.Prefs.Profiles.Count = 1) and
        (p.Name = sDefaultProfileName) and
        (p.Username = '') and
        (p.Server = '') and
        (p.password = '')) then begin
        // Fairly Sure this is the first run of application
        // So disable connect button.
    end;


    with f do begin
        _profile := p;
        f.Caption := WideFormat(_(sConnDetails), [p.Name]);
        RestoreProfile(p);
        RestoreConn(p);
        RestoreHttp(p);
        RestoreSocket(p);
    end;

    if (f.updatePages() <> 0) then
        result := f.ShowModal()
    else
        result := mrNone;
    f.Free();
end;

{---------------------------------------}
function TfrmConnDetails.updateProfile(): boolean;
var
    username, domain, resource, jid: Widestring;
    tj: TJabberID;
begin
    Result := true;
    if pnlx509Auth.Checked then begin
        //"Validate" certificate
        if (_sslCertKey = '') then begin
            MessageDlgW(_(sMissingX509Cert), mtError, [mbOK], 0);
            Result := false;
            exit;
        end;
    end
    else begin
        // Validate the JID parts
        if (not chkWinLogin.Checked) then begin
            username := TJabberID.applyJEP106(txtUsername.Text);
            username := xmpp_nodeprep(username);
            if (username = '') then begin
                MessageDlgW(_(sProfileInvalidUsername), mtError, [mbOK], 0);
                Result := false;
                exit;
            end;
        end
        else begin
            username := '';
        end;

        domain := cboServer.Text;
        domain := xmpp_nameprep(domain);
        if (domain = '') then begin
            MessageDlgW(_(sProfileInvalidServer), mtError, [mbOK], 0);
            Result := false;
            exit;
        end;

        resource := cboResource.Text;
        resource := xmpp_resourceprep(resource);
        if (resource = '') then begin
            MessageDlgW(_(sProfileInvalidResource), mtError, [mbOK], 0);
            Result := false;
            exit;
        end;

        //Construct full-jid string
        if (username <> '') then
            jid := username + '@' + domain
        else
            jid := domain;

        if (resource <> '') then
            jid  := jid + '/' + resource;
            
        tj := TJabberID.Create(jid);

        if (not chkWinLogin.Checked) and (tj.user = '') then begin
            MessageDlgW(_(sProfileInvalidUsername), mtError, [mbOK], 0);
            Result := false;
        end;

        tj.Free();
        if not Result then
            exit;
    end;

    // save the info...
    SaveProfile(_profile);
    SaveConn(_profile);

    if _profile.ConnectionType = conn_normal then
        SaveSocket(_profile)
    else
        SaveHttp(_profile);

    MainSession.Prefs.SaveProfiles();
    //MainSession.Prefs.LoadProfiles();
end;

function TfrmConnDetails.encodeCertKey(keyLength: Cardinal; key: Pointer): string;
var
  encoder: TIdEncoderMime;
  tmp: string;
begin
  encoder := TIdEncoderMIME.Create(nil);
  try
    SetString(tmp, PChar(key), keyLength);
    Result := encoder.EncodeString(tmp);
  finally
    encoder.Free;
  end;
end;


procedure TfrmConnDetails.decodeCertKey(var key: Pointer; var decodedLength: Cardinal; encodedString: string);
var
  decodedString: string;
  decoder: TIdDecoderMIME;
begin
  decoder := TIdDecoderMIME.Create(nil);
  try
    decodedString := decoder.DecodeToString(encodedString);
    decodedLength := Length(decodedString);
    key := AllocMem(decodedLength);
    Move(Pointer(decodedString)^, key^, decodedLength);
  finally
    decoder.Free;
  end;
end;

{---------------------------------------}
procedure TfrmConnDetails.frameButtons1btnOKClick(Sender: TObject);
begin
    // Check that resource does not match password
    if ((pnlx509auth.Checked) and
        (Trim(txtx509.Text) = ''))  then begin
        MessageDlgW(_(sMissingX509Cert), mtError, [mbOK], 0);
        ModalResult := mrNone;
        exit
    end;

    if (cboResource.Text <> '') and (txtPassword.Text <> '') and (cboResource.Text = txtPassword.Text) then begin
        MessageDlgW(_(sProfileResourcePassMatch), mtError, [mbOK], 0);
        ModalResult := mrNone;
        exit;
    end;

    if updateProfile() then
        ModalResult := mrOK
    else
        Modalresult := mrNone;
end;

{---------------------------------------}
procedure TfrmConnDetails.chkSavePasswdClick(Sender: TObject);
begin
      if (not chkSavePasswd.Checked) then begin
          txtPassword.Text := '';
          MainSession.Prefs.setBool('autologin', false);
      end;
end;

{---------------------------------------}
procedure TfrmConnDetails.cboSocksTypeChange(Sender: TObject);
var
    auth: boolean;
begin
    if (cboSocksType.ItemIndex = proxy_none) or
       (cboSocksType.ItemIndex = proxy_http) then begin
        pnlSocksHost.Enabled := false;
        pnlSocksPort.Enabled := false;
        pnlSocksAuth.Enabled := false;
        pnlSocksAuth.Checked := false;
    end
    else begin
        pnlSocksHost.Enabled := true;
        pnlSocksPort.Enabled := true;

        auth := pnlSocksAuth.Checked;
        pnlSocksAuth.Enabled := true;
        pnlSocksAuth.Checked := auth;
    end;
end;

{---------------------------------------}
procedure TfrmConnDetails.RestoreSocket(profile: TJabberProfile);
begin
    with profile do begin
        cboSocksType.ItemIndex := SocksType;
        cboSocksTypeChange(cboSocksType);
        txtSocksHost.Text := SocksHost;
        txtSocksPort.Text := IntToStr(SocksPort);
        pnlSocksAuth.Checked := SocksAuth;
        txtSocksUsername.Text := SocksUsername;
        txtSocksPassword.Text := SocksPassword;
    end;
end;

{---------------------------------------}
procedure TfrmConnDetails.SaveSocket(profile: TJabberProfile);
begin
    with profile do begin
        Host := txtHost.Text;
        Port := StrToIntDef(txtPort.Text, 5222);
        ssl := _sslOpts.Selected;
        //ssl := optSSL.ItemIndex;

        SocksType := cboSocksType.ItemIndex;
        SocksHost := txtSocksHost.Text;
        SocksPort := StrToIntDef(txtSocksPort.Text, 0);
        SocksAuth := pnlSocksAuth.Checked;
        SocksUsername := txtSocksUsername.Text;
        SocksPassword := txtSocksPassword.Text;
    end;
end;

{---------------------------------------}
procedure TfrmConnDetails.chkx509Click(Sender: TObject);
begin
    // Enable/Disable Controls
    pnlPassword.Enabled := not pnlx509Auth.Checked;
    pnlSSL.Enabled := not pnlx509Auth.Checked;
    pnlRealm.Enabled := not pnlx509Auth.Checked;
    brandControl(chkRegister);
    if chkRegister.Visible and chkRegister.Enabled then
        chkRegister.Enabled := not pnlx509Auth.Checked;
    brandControl(chkSavePasswd);
    if chkSavePasswd.Visible and chkSavePasswd.Enabled then
      chkSavePasswd.Enabled := not pnlx509Auth.Checked;

    if (pnlx509Auth.Checked) then begin
        _sslOpts.Selected := 0;
        //optssl.ItemIndex := 0;
        chkRegister.Checked := false;
        chkSavePasswd.Checked := false;
        txtPassword.Text := '';
        txtRealm.Text := '';
    end
    else begin
        // Clear the x509 data
        _sslCertKey := '';
        txtx509.Text := '';
        chkCert(nil);
    end;
end;

procedure TfrmConnDetails.RestoreProfile(profile: TJabberProfile);
begin
    with profile do begin
        // populate the fields
        txtUsername.Text := profile.getJabberID().userDisplay;
        cboServer.Text := profile.getJabberID().domain;
        cboResource.Text := Resource;
        if (SavePasswd) then
            txtPassword.Text := Password;
        txtRealm.Text := SASLRealm;
        chkSavePasswd.Checked := SavePasswd;
        chkRegister.Checked := NewAccount;
        chkWinLogin.Checked := WinLogin;
        pnlKerberos.Checked := KerbAuth;
        pnlx509Auth.Checked := x509Auth;
    end;
end;

{---------------------------------------}
procedure TfrmConnDetails.SaveProfile(profile: TJabberProfile);
begin
    with Profile do begin
        // Update the profile
        Server := cboServer.Text;
        Username := TJabberID.applyJEP106(txtUsername.Text);
        SavePasswd := chkSavePasswd.Checked;
        if (not SavePasswd) then
            password := ''
        else
        password := txtPassword.Text;
        resource := cboResource.Text;
        SASLRealm := txtRealm.Text;
        NewAccount := chkRegister.Checked;
        WinLogin := chkWinLogin.Checked;
        KerbAuth := pnlKerberos.Checked;
        x509Auth := pnlx509Auth.Checked;
    end;
end;

{---------------------------------------}
procedure TfrmConnDetails.RestoreConn(profile: TJabberProfile);
begin
    with profile do begin
        optSRVAuto.Checked := srv;
        optSRVManual.Checked := not srv;
        txtHost.Text := Host;
        txtPort.Text := IntToStr(Port);
        if (not pnlSRV.Visible) and srv then
            pnlManualDetails.Visible := false;

        if ((ExStartup.ssl_ok = false) and (ssl = ssl_port)) then begin
            MessageDlgW(_(sNoSSL), mtError, [mbOK], 0);
            ssl := ssl_tls;
        end;
        _sslOpts.Selected := ssl;
        pnlPolling.Checked := (ConnectionType = conn_http);
        txtPriority.Text := IntToStr(Priority);
		txtx509.Text := getCertFriendlyName;
    end;
    //pnlConnection.initializeChildStates();

    chkCert(nil);
end;

{---------------------------------------}
procedure TfrmConnDetails.SaveConn(profile: TJabberProfile);
begin
    with profile do begin
        srv := optSRVAuto.Checked;
        Host := txtHost.Text;
        Port := StrToIntDef(txtPort.Text, 5222);
        ssl := _sslOpts.Selected;
        //ssl := optSSL.ItemIndex;

        if (pnlPolling.Checked) then
            ConnectionType := conn_http
        else
            ConnectionType := conn_normal;

        Priority := StrToInt(txtPriority.Text);

        if (pnlx509Auth.Checked) then
            SSL_Cert := _sslCertKey
        else
            SSL_Cert := '';
    end;
end;

{---------------------------------------}
procedure TfrmConnDetails.RestoreHttp(profile: TJabberProfile);
begin
    with profile do begin
        pnlPolling.Checked := (ConnectionType = conn_http);
        txtURL.Text := URL;
        txtTime.Text := FloatToStr(Poll / 1000.0);
        txtKeys.Text := IntToStr(NumPollKeys);
    end;
end;

{---------------------------------------}
procedure TfrmConnDetails.SaveHttp(profile: TJabberProfile);
begin
    with profile do begin
        URL := txtURL.Text;
        Poll := Trunc(strToFloatDef(txtTime.Text, 30) * 1000);
        NumPollKeys := StrToInt(txtKeys.Text);
        if (NumPollKeys < 2) then begin
            NumPollKeys := 256;
            txtKeys.Text := '256';
            MessageDlgW(_(sSmallKeys), mtWarning, [mbOK], 0);
        end;

    end;
end;

{---------------------------------------}
procedure TfrmConnDetails.FormCreate(Sender: TObject);
var
    list : TWideStrings;
    i : integer;
begin
    AssignUnicodeFont(Self, 8);
    TranslateComponent(Self);

    URLLabel(lblServerList);

    //MainSession.Prefs.RestorePosition(Self, false);
    _cur_tab := nil;

    //Setup account details page
    imgAcctDetails.Target := tbsAcctDetails;

    brandControl(pnlUsername);
    brandControl(pnlServer);
    brandControl(pnlPassword);
    brandControl(chkSavePasswd);
    brandControl(chkRegister);
    list := TWideStringList.Create();
    MainSession.Prefs.fillStringList('brand_profile_server_list', list);
    if (list.Count > 0) then begin
        cboServer.Items.Clear();
        for i := 0 to list.Count - 1 do
            cboServer.Items.Add(list[i]);
    end;
    if (MainSession.Prefs.getBool('brand_profile_show_download_public_servers')) then
        lblServerList.Visible := true
    else
        lblServerList.Visible := false;
    if (MainSession.Prefs.getBool('brand_profile_allow_rename')) then
        btnRename.Visible := true
    else
        btnRename.Visible := false;

    //Setup connection page
    imgConnection.Target := tbsConnection;
    if (not ExStartup.ssl_ok) then
        ExStartup.ssl_ok := checkSSL();
    _sslOpts := TOptionSelection.Create([optSSLoptional, optSSLrequired, optSSLlegacy]);
    brandControl(pnlSRV);
    brandControl(pnlHost);
    brandControl(pnlPort);
    brandControl(pnlSSL);
    if (MainSession.Prefs.getBool('brand_profile_allow_ssl_port')) then
        optSSLlegacy.Visible := true
    else
        optSSLlegacy.Visible := false;

    //Setup proxy page
    imgProxy.Target := tbsProxy;
    brandControl(pnlSocksType);
    brandControl(pnlSocksHost);
    brandControl(pnlSocksPort);
    brandControl(pnlSocksUsername);
    brandControl(pnlSocksPassword);
    pnlSocksAuth.captureChildStates();
    brandControl(pnlSocksAuth);

    //Setup HTTP-Polling page
    imgHttpPolling.Target := tbsHttpPolling;
    brandControl(pnlURL);
    brandControl(pnlTime);
    brandControl(pnlKeys);
    pnlPolling.captureChildStates();
    brandControl(pnlPolling);

    //Setup Advanced page
    imgAdvanced.Target := tbsAdvanced;
    MainSession.Prefs.fillStringList('brand_profile_resource_list', list);
    if (list.Count > 0) then begin
        cboResource.Clear();
        for i := 0 to list.Count - 1 do
            cboResource.Items.Add(list[i]);
    end
    else begin
        cboResource.Items.Add(_(sResourceHome));
        cboResource.Items.Add(_(sResourceWork));
        cboResource.Items.Add(_(resourceName));
    end;
    list.Free();
    brandControl(pnlResource);
    brandControl(pnlRealm);
    brandControl(pnlPriority);

    brandControl(chkWinLogin);
    pnlKerberos.captureChildStates();
    brandControl(pnlKerberos);

    brandControl(pnlx509Cert);
    pnlx509Auth.captureChildStates();
    brandControl(pnlx509Auth);

    _Canceled := false;
end;

{---------------------------------------}
procedure TfrmConnDetails.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
    //MainSession.Prefs.SavePosition(Self);
    Action := caFree;
end;

procedure TfrmConnDetails.FormShow(Sender: TObject);
begin
    //select and display the appropriate page
    selectPage(_cur_tab);
end;

{---------------------------------------}
procedure TfrmConnDetails.txtUsernameKeyPress(Sender: TObject;
  var Key: Char);
//var
//    uh, r, jid: Widestring;
begin
    // always allow people to fix mistakes :)
    if (Key = #8) then exit;
                                   {
    // check to make sure JID is valid
    uh := cboJabberID.Text;
    r := cboResource.Text;

    if (Sender = cboJabberID) then uh := uh + Key
    else if (Sender = cboResource) then r := r + Key;

    jid := uh + '/' + r;
    if (not isValidJid(jid)) then
        Key := #0;
        }
end;

{---------------------------------------}
procedure TfrmConnDetails.lblServerListClick(Sender: TObject);
var
    slist: string;
    parser: TXMLTagParser;
    q: TXMLTag;
    items: TXMLTagList;
    i: integer;
begin
    if (MessageDlgW(_(sDownloadServers), mtConfirmation, [mbYes, mbNo], 0) = mrNo) then
        exit;

    btnOK.Enabled := false;

    slist := ExWebDownload(_(sDownloadCaption), 'http://jabber.org/servers.xml');

    btnOK.Enabled := true;

    if (slist = '') then exit;

    parser := TXMLTagParser.Create();
    parser.ParseString(slist, '');
    if (parser.Count > 0) then begin
        q := parser.popTag();
        items := q.QueryTags('item');
        if (items.Count > 0) then
            cboServer.Items.Clear();
        for i := 0 to items.Count - 1 do
            cboServer.Items.Add(items[i].getAttribute('jid'));
        items.Free();
        q.Free();
    end;
    parser.Free();
end;

{---------------------------------------}
procedure TfrmConnDetails.btnCancelClick(Sender: TObject);
begin
    _Canceled := true;
end;

{---------------------------------------}
procedure TfrmConnDetails.optSSLClick(Sender: TObject);
begin
    _sslOpts.Select(TTntRadioButton(Sender));

    //if (optSSL.ItemIndex = ssl_port) then begin
    if (_sslOpts.Selected = ssl_port) then begin
        if (txtPort.Text = '5222') then
            txtPort.Text := '5223';
    end
    else begin
        if (txtPort.Text = '5223') then
            txtPort.Text := '5222';
    end;
end;

{---------------------------------------}
procedure TfrmConnDetails.SRVOptionClick(Sender: TObject);
begin
   pnlManualDetails.Enabled := not optSRVAuto.Checked;
   pnlManualDetails.Invalidate();
end;

{---------------------------------------}
procedure TfrmConnDetails.chkWinLoginClick(Sender: TObject);
begin
    if pnlKerberos.Checked then begin
        chkWinLogin.Enabled := true;
        pnlx509Auth.Enabled := false;
        pnlx509Auth.checked := false
    end
    else begin
        chkWinLogin.Enabled := false;
        chkWinLogin.Checked := false;
        pnlx509Auth.Enabled := true;
    end;

    if chkWinLogin.Checked then begin
        pnlUsername.Enabled := false;
        pnlServer.Enabled := false;
        pnlPassword.Enabled := false;
        chkRegister.Checked := false;
        chkRegister.Enabled := false;
        chkSavePasswd.Enabled := false;
        lblServerList.Enabled := false;
        //pnlRealm.Enabled := false;
     end
    else begin
        pnlUsername.Enabled := true;
        pnlServer.Enabled := true;
        pnlPassword.Enabled := true;
        brandControl(chkRegister);
        brandControl(chkSavePasswd);
        lblServerList.Enabled := true;
        //pnlRealm.Enabled := true;
    end;

    {
    if not pnlPassword.Enabled then
        txtPassword.Text := '';
    }

end;

{---------------------------------------}
procedure TfrmConnDetails.btnRenameClick(Sender: TObject);
var
    new: Widestring;
begin
    // rename this profile
    new := _profile.Name;
    if (InputQueryW(_('Rename Profile'), _('New Profile Name:'), new)) then begin
        _profile.Name := new;
        Self.Caption := WideFormat(_(sConnDetails), [new]);
    end;
end;


{---------------------------------------}
procedure TfrmConnDetails.btnx509browseClick(Sender: TObject);
var
    m_hCertStore: HCERTSTORE;
    m_pCertContext: PCCERT_CONTEXT;
    sMy: LPCWSTR;
    keyLength: DWORD;
    key: Pointer;
begin
    sMy := 'MY';
    m_hCertStore := CertOpenStore(CERT_STORE_PROV_SYSTEM_W, 0, 0,
      CERT_SYSTEM_STORE_CURRENT_USER, sMy);
    if (m_hCertStore <> nil) then begin
      if (FNStringGetOperatingSystemVersionMicrosoftWindowsS = 'Windows 2000') then begin
        m_pCertContext := CertSelector.getSelectedCertificate(Self);
      end
      else begin
        m_pCertContext := CryptUIDlgSelectCertificateFromStore(m_hCertStore,
          self.Handle, nil, nil, CRYPTUI_SELECT_LOCATION_COLUMN, 0, nil);
      end;

      if (m_pCertContext<>nil) then begin
        //Set the SSL cert textbox to the cert's friendly name
        txtx509.Text := reallyGetCertFriendlyName(m_pCertContext);

        // Save Certificate ID.
        CertGetCertificateContextProperty(m_pCertContext,
          CERT_KEY_IDENTIFIER_PROP_ID, nil, keyLength);
        key := AllocMem(keyLength);
        try
          CertGetCertificateContextProperty(m_pCertContext,
            CERT_KEY_IDENTIFIER_PROP_ID, key, keyLength);

          _sslCertKey := encodeCertKey(keyLength, key);
        finally
          FreeMem(key, keyLength);
        end;

        CertFreeCertificateContext(m_pCertContext);
      end;

      CertCloseStore(m_hCertStore, 0);
    end;

    chkCert(nil);
end;

{---------------------------------------}
function TfrmConnDetails.FNStringGetOperatingSystemVersionMicrosoftWindowsS:
string;
 var s : string;
 begin
  s := 'Windows version unknown';
  case Win32Platform of
   VER_PLATFORM_WIN32s :
    begin
     s := 'Windows 32 bits';
    end;
   VER_PLATFORM_WIN32_WINDOWS :
    case Win32MinorVersion of
     0:
      if ( Win32BuildNumber < 1000 ) then begin
       s := 'Windows 95';
      end
      else if ( Win32BuildNumber = 1111 ) then begin
       s := 'Windows 95 b';
      end
      else if ( Win32BuildNumber > 1111 ) then begin
       s := 'Windows 95c';
      end;
     10:
      if ( Win32BuildNumber < 2000 ) then begin
       s := 'Windows 98';
      end
      else if ( Win32BuildNumber > 2000 ) then begin
       s := 'Windows 98 second edition';
      end;
     90:
      begin
       //s := FNStringGetOperatingSystemVersionMicrosoftWindowsMeS;
      end;
    end;
   VER_PLATFORM_WIN32_NT :
    if ( ( Win32MinorVersion = 2 ) and ( Win32MajorVersion = 5 ) ) then begin
      s := 'Windows 2003'; // server
      // buildnumber=3790
    end
    else if ( ( Win32MinorVersion = 1 ) and ( Win32MajorVersion = 5 ) ) then begin
      s := 'Windows XP'; // home + professional
      // buildnumber=2600
    end
    else if ( Win32MajorVersion = 4 ) then begin
     s := 'Windows NT'; // workstation + server
    end
    else if ( Win32MajorVersion = 5 ) then begin
      s := 'Windows 2000' // workstation + server
      // buildnumber=2195
    end;
 end;
 result := s;
end;

{---------------------------------------}
function TfrmConnDetails.reallyGetCertFriendlyName(cert: PCCERT_CONTEXT): string;
var
  namePtr: PAnsiChar;
  nameLength: Integer;
  name: array[0..256] of Char;
begin
  name := '';
  nameLength := 128;
  namePtr := Addr(name);

  CertGetNameString(cert,
    CERT_NAME_FRIENDLY_DISPLAY_TYPE,
    0, nil, namePtr, nameLength);

  Result := string(namePtr);
end;

{---------------------------------------}
function TfrmConnDetails.getCertFriendlyName(): string;
var
  m_hCertStore: HCERTSTORE;
  sMy: LPCWSTR;
  testCert: PCCERT_CONTEXT;
  keyBlob: CRYPT_HASH_BLOB;
  key: Pointer;
  keyLength: DWORD;
begin
  if (_sslCertKey = '') then begin
    if ((_profile.x509Auth) and
        (_profile.SSL_Cert <> '')) then begin
        _sslCertKey := _profile.SSL_Cert;
    end
    else begin
        Result := '';
        Exit;
    end;
  end;

  sMy := 'MY';
  m_hCertStore := CertOpenStore(CERT_STORE_PROV_SYSTEM_W, 0, 0,
    CERT_SYSTEM_STORE_CURRENT_USER, sMy);
  if (m_hCertStore <> nil) then begin
    // Decode the certificate id and get the certificate.
    decodeCertKey(key, keyLength, _sslCertKey);
    try
      keyBlob.cbData := keyLength;
      keyBlob.pbData := key;
      testCert := CertFindCertificateInStore(m_hCertStore, X509_ASN_ENCODING, 0,
        CERT_FIND_KEY_IDENTIFIER, @keyBlob, nil);
    finally
      FreeMem(key, keyLength);
    end;

    if (testCert <> nil) then begin
      Result := reallyGetCertFriendlyName(testCert);
    end
    else begin
      _sslCertKey := '';
      Result := '';
    end;

    if (testCert <> nil) then begin
      CertFreeCertificateContext(testCert);
    end;

    CertCloseStore(m_hCertStore, 0);
  end;
end;

{---------------------------------------}
procedure TfrmConnDetails.chkCert(Sender: TObject);
var
  certSelected: Boolean;
  ps : TPrefState;
begin
    certSelected := (_sslCertKey <> '');
    txtPassword.Enabled := not certSelected;
    txtPassword.ReadOnly := certSelected;
    ps := PrefController.getPrefState('brand_profile_register');
    if ( (ps <> psInvisible) and (ps <> psReadOnly) ) then
      chkRegister.Enabled := not certSelected;
    //chkWinLogin.Enabled := not certSelected;
    pnlKerberos.Enabled := not certSelected;
    //pnlRealm.Enabled := not certSelected;
    brandControl(chkSavePasswd);
    chkSavePasswd.Enabled := not certSelected;
    brandControl(chkRegister);
    chkRegister.Enabled := not certSelected;

    if certSelected then
        chkRegister.Checked := false;

    if not pnlPassword.Enabled then
        txtPassword.Text := ''
end;

procedure TfrmConnDetails.selectPage(Sender: TObject);
var
  lblNew: TExGraphicButton;
  tab: TTntTabSheet;
begin
  lblNew := TExGraphicButton(Sender);
  //Default to Account Details
  if lblNew = nil then lblNew := findEnabledPage();

  //Unselect old label
  if (_cur_tab <> nil) then begin
    _cur_tab.Selected := false;
  end;

  //Remember and select new label
  _cur_tab := lblNew;
  _cur_tab.Selected := true;

  //Display new tab
  if (_cur_tab.Target <> nil) then begin
    if PageControl1.Visible then
      PageControl1.Visible := false;
    tab := TTntTabSheet(_cur_tab.Target);
    tab.Visible := true;
    tab.BringToFront();
  end;

  //Make sure page control is visible!
  if (not PageControl1.Visible) then
    PageControl1.Visible := true;
  PageControl1.BringToFront();

end;

constructor TOptionSelection.Create(opts : Array of TTntRadioButton);
var
  len: Integer;
  idx: Integer;
begin
  len := Length(opts);
  SetLength(_options, len);
  for idx := 0 to len - 1 do
    _options[idx] := opts[idx];

  _selected := -1;
end;

function TOptionSelection.GetSize;
begin
  Result := Length(_options);
end;
procedure TOptionSelection.SetSelected(sel: Integer);
var
  oldSel: Integer;
begin
  oldSel := _selected;

  if sel < -1 then
    raise Exception.Create('selection less than 0')
  else if sel > Size then
    raise Exception.Create('selection greater than length')
  else if sel <> oldSel then begin
    _selected := sel;
    
    if oldSel > -1 then
      _options[oldSel].Checked := False;
    if sel > -1 then
      _options[sel].Checked := True;
  end;

end;

procedure TOptionSelection.Select(Target: TTntRadioButton);
var
  idx: Integer;
  found: Integer;
begin
  found := -1;
  for idx := 0 to Size - 1 do begin
    if _options[idx] = target then found := idx;
  end;

  Selected := found;
end;

procedure TfrmConnDetails.brandControl(ctrl: TControl);
var
    pref: WideString;
    ps: TPrefState;
begin
    pref := MainSession.prefs.getPref(ctrl.Name);
    if (pref <> '') then begin
        ps := PrefController.getPrefState(pref);
            if (ps <> psInvisible) then begin
                ctrl.Visible := true;
                if ps = psReadOnly then begin
                    if  (ctrl is TExBrandPanel) then
                        TExBrandPanel(ctrl).CanEnabled := false;
                    ctrl.Enabled := false;
                end
                else
                    ctrl.Enabled := true;
            end
            else begin
                if  (ctrl is TExBrandPanel) then
                    TExBrandPanel(ctrl).CanShow := false;
                ctrl.Visible := false;
            end;
    end;
end;

procedure TfrmConnDetails.brandPage(page: TExGraphicButton);
var
    pref: WideString;
    show: Boolean;
    tab: TTntTabSheet;
    idx: Integer;
begin
    pref := MainSession.prefs.getPref(page.Name);
    if (pref <> '') then
        show := MainSession.Prefs.getBool(pref)
    else
        show := true;
    
    tab := TTntTabSheet(page.Target);
    if show and (tab <> nil) then begin
        show := false;
        for idx := 0 to tab.ControlCount - 1 do begin
            show := show or checkVisibility(tab.Controls[idx]);
        end;
    end;

    page.Visible := show;
end;

function TfrmConnDetails.checkVisibility(ctrl: TControl): boolean;
var
    win: TWinControl;
    idx: integer;
begin
    Result := ctrl.Visible;

    if Result and (ctrl is TWinControl) then begin
        win := TWinControl(ctrl);
        Result := false;
        for idx := 0 to win.ControlCount - 1 do begin
            Result := Result or checkVisibility(win.Controls[idx]);
        end;
    end;
end;

function TfrmConnDetails.findEnabledPage(): TExGraphicButton;
var
    curr: TExGraphicButton;
begin
    result := nil;
    curr := nil;

    repeat
        if (curr = nil) then
            curr := imgAcctDetails
        else if (curr = imgAcctDetails) then
            curr := imgConnection
        else if (curr = imgConnection) then
            curr := imgProxy
        else if (curr = imgProxy) then
            curr := imgHttpPolling
        else if (curr = imgHttpPolling) then
            curr := imgAdvanced
        else
            curr := nil;
             
        if (curr <> nil) and (curr.Visible) then begin
            result := curr;
        end;


    until (result <> nil) or (curr = nil);
end;

function TfrmConnDetails.updatePages(): Integer;
begin
    result := 0;

    brandPage(imgAcctDetails);
    if (imgAcctDetails.Visible) then result := result + 1;

    brandPage(imgConnection);
    if (imgConnection.Visible) then result := result + 1;

    brandPage(imgProxy);
    if (imgProxy.Visible) then result := result + 1;

    brandPage(imgHttpPolling);
    if (imgHttpPolling.Visible) then result := result + 1;

    brandPage(imgAdvanced);
    if (imgAdvanced.Visible) then result := result + 1;
end;

end.
