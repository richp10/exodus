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
unit NewUser;


interface

uses
    IQ, XMLTag, Unicode,  
    Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
    Dialogs, Wizard, ComCtrls, ExtCtrls, StdCtrls, TntStdCtrls, TntExtCtrls,
    fXData, TntForms, ExFrame;

const
    WM_NUS_CONNECT = WM_USER + 5400;
    CONNECT_ATTEMPTS = 3;

type
  TNewUserState = (nus_init, nus_list, nus_disconnect, nus_connect, nus_user,
        nus_get, nus_xdata, nus_reg, nus_set, nus_auth,
        nus_error, nus_finish);

  TfrmNewUser = class(TfrmWizard)
    TntLabel1: TTntLabel;
    cboServer: TTntComboBox;
    tbsWait: TTabSheet;
    lblWait: TTntLabel;
    aniWait: TAnimate;
    tbsXData: TTabSheet;
    xData: TframeXData;
    tbsReg: TTabSheet;
    tbsFinish: TTabSheet;
    lblBad: TTntLabel;
    lblOK: TTntLabel;
    tbsUser: TTabSheet;
    lblUsername: TTntLabel;
    txtUsername: TTntEdit;
    lblPassword: TTntLabel;
    txtPassword: TTntEdit;
    optServer: TTntRadioButton;
    optPublic: TTntRadioButton;
    optNewAccount: TTntRadioButton;
    optExistingAccount: TTntRadioButton;
    procedure FormCreate(Sender: TObject);
    procedure btnNextClick(Sender: TObject);
    procedure btnBackClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure optExistingAccountClick(Sender: TObject);
  private
    { Private declarations }
    _state: TNewUserState;
    _server: Widestring;
    _username: Widestring;
    _password: Widestring;
    _iq: TJabberIQ;
    _have_public_servers: boolean;
    _session_cb: integer;

    _fields: boolean;
    _xdata: boolean;
    _key: Widestring;

    _errCode: integer;

    _connect_attempts: integer;

    procedure _runState();
    procedure _fetchServers();
    procedure _wait();
    procedure _doneWait();
  published
    procedure SessionCallback(event: string; tag: TXMLTag);
    procedure RegGetCallback(event: string; tag: TXMLTag);
    procedure RegSetCallback(event: string; tag: TXMLTag);

  protected
    procedure WMConnect(var msg: TMessage); message WM_NUS_CONNECT;

  public
    { Public declarations }
  end;

var
  frmNewUser: TfrmNewUser;

function ShowNewUserWizard(): integer;

implementation
{$R *.dfm}
uses
    GnuGetText, fTopLabel, JabberConst, Jabber1, LoginWindow,   
    WebGet, XMLParser, PrefController, Session, ExUtils;

const
    gGenericErr = 'Your Registration to this service has failed! Press Back and verify that all of the parameters have been filled in correctly. Press Cancel to close this wizard.';
    g409Err     = 'Your Registration to this service had failed because this username already exists! Press Back and choose a new username.';
{---------------------------------------}
function ShowNewUserWizard(): integer;
begin
    frmNewUser := TfrmNewUser.Create(nil);
    Result := frmNewUser.ShowModal();
end;

{---------------------------------------}
procedure TfrmNewUser.FormCreate(Sender: TObject);
var
    i: integer;
    list: TWidestringlist;
begin
  inherited;
    // Setup the form
    AssignUnicodeFont(Self, 9);

    _state := nus_init;
    _have_public_servers := false;
    _iq := nil;
    _fields := false;
    _xdata := false;
    _key := '';

    TabSheet1.TabVisible := false;
    tbsUser.TabVisible := false;
    tbsWait.TabVisible := false;
    tbsXData.TabVisible := false;
    tbsReg.TabVisible := false;
    tbsFinish.TabVisible := false;

    btnBack.Enabled := false;
    btnCancel.Enabled := true;
    Tabs.ActivePage := TabSheet1;

    // the default list is brandable
    list := TWideStringList.Create();
    MainSession.Prefs.fillStringList('brand_profile_server_list', list);
    if (list.Count > 0) then begin
        cboServer.Items.Clear();
        for i := 0 to list.Count - 1 do
            cboServer.Items.Add(list[i]);
    end;

    // auto-select the first thing in the list
    if (cboServer.Items.Count > 0) then
        cboServer.ItemIndex := 0;

    _session_cb := MainSession.RegisterCallback(Self.SessionCallback, '/session');
end;

{---------------------------------------}
procedure TfrmNewUser.btnNextClick(Sender: TObject);
begin
  inherited;
    // goto the next state
    case _state of
    nus_init: begin
        if (optServer.Checked) then
            _state := nus_connect
        else
            _state := nus_list;
        _runState();
    end;
    nus_user: begin
        if (optExistingAccount.Checked) then begin
             with MainSession.Profile do begin
                Username := txtUsername.Text;
                Password := txtPassword.Text;
                Resource := resourceName;
                SavePasswd := true;
                NewAccount := false;
              end;
            _state := nus_auth;
            _runState();
        end
        else begin
            _state := nus_get;
            _runState();
        end;
    end;
    nus_xdata: begin
        _state := nus_set;
        _runState();
    end;
    nus_reg: begin
        _state := nus_set;
        _runState();
    end;
    nus_finish: begin
        Self.ModalResult := mrOK;
        //Self.Close();
    end;
    nus_error: begin
        Self.ModalResult := mrCancel;
        //Self.Close();
    end;
    end;
end;

{---------------------------------------}
procedure TfrmNewUser.btnBackClick(Sender: TObject);
begin
  inherited;
    case _state of
    nus_xdata, nus_reg: begin
        _state := nus_user;
        _runState();
    end;
    nus_user: begin
        _state := nus_init;
        _runState();
    end;
    nus_error: begin
        _errCode := 0;
        btnNext.Enabled := true;
        btnNext.Caption := _('Next >');
        if (MainSession.Active) then begin
            // we at least connected
            if (optExistingAccount.Checked) then
                _state := nus_user
            else if (_xdata) then
                _state := nus_xdata
            else
                _state := nus_reg;
        end
        else
            _state := nus_init;
        _runState();
    end;

    end;
end;

{---------------------------------------}
procedure TfrmNewUser.btnCancelClick(Sender: TObject);
begin
  inherited;
    if (_iq <> nil) then
        FreeAndNil(_iq);

    if ((MainSession.Active) and (not MainSession.Authenticated)) then
        MainSession.Disconnect();

    MainSession.NoAuth := false;
    Self.Close();
end;

{---------------------------------------}
procedure TfrmNewUser._fetchServers();
var
    slist: string;
    parser: TXMLTagParser;
    q: TXMLTag;
    items: TXMLTagList;
    i: integer;
begin
    slist := ExWebDownload(_('New User Wizard'), 'http://www.jabber.org/servers.xml');
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
procedure TfrmNewUser.WMConnect(var msg: TMessage);
begin
    // try to connect
    inc(_connect_attempts);
    if (_connect_attempts > CONNECT_ATTEMPTS) then begin
        _state := nus_error;
        _runState();
    end
    else begin
        _state := nus_connect;
        MainSession.Connect();
    end;
end;

{---------------------------------------}
procedure TfrmNewUser.SessionCallback(event: string; tag: TXMLTag);
begin
    //
    if (_state = nus_disconnect) then begin
        if (event = '/session/commerror') then
            // ignore
        else if (event = '/session/disconnected') then
            // we can't just call connect from a disconnect handler.
            // it causes threading issues
            PostMessage(Self.Handle, WM_NUS_CONNECT, 0, 0);
    end
    else if (_state = nus_connect) then begin
        if (event = '/session/disconnected') then 
            PostMessage(Self.Handle, WM_NUS_CONNECT, 0, 0)
        else if (event = '/session/connected') then
            _state := nus_user
        else if (event = '/session/commerror') then
            _state := nus_error;

        if (_state <> nus_connect) then
            _runState();
    end
    else if (_state = nus_auth) then begin
        if (event = '/session/authenticated') then
            // XXX: add in new stages for vcard/profile info
            _state := nus_finish
        else if (event = '/session/error/auth') then
            _state := nus_error;

        if (_state <> nus_auth) then
            _runState();
    end;
end;

{---------------------------------------}
procedure TfrmNewUser.RegGetCallback(event: string; tag: TXMLTag);
var
    q, x: TXMLTag;
    f: TXMLTagList;
    idx: integer;
begin
    assert(_state = nus_get);
    _doneWait();
    _iq := nil;

    if (event <> 'xml') or (tag.GetAttribute('type') <> 'result') then begin
        _state := nus_error;
        _runState();
        exit;
    end;

    // build up the fields or x-data form
    q := tag.QueryXPTag('/iq/query[@xmlns="jabber:iq:register"]');
    x := q.QueryXPTag('/query/x[@xmlns="jabber:x:data"]');
    if (x <> nil) then begin
        _state := nus_xdata;
        _xdata := true;
        xData.Render(x);
        Tabs.ActivePage := tbsXData;
        btnBack.Enabled := true;
    end
    else begin
        _state := nus_reg;
        f := q.ChildTags();
        if (f.Count > 0) then begin
            _fields := true;
            // Form may have been rendered before - remove it
            for idx := 0 to (tbsReg.ControlCount-1) do
                begin
                    tbsReg.Controls[idx].Destroy;
                end;
            RenderTopFields(tbsReg, f, _key);
        end;
        Tabs.ActivePage := tbsReg;
        btnBack.Enabled := true;
    end;
end;

{---------------------------------------}
procedure TfrmNewUser.RegSetCallback(event: string; tag: TXMLTag);
var
    errTag: TXMLTag;
begin
    assert(_state = nus_set);
    _doneWait();
    _iq := nil;

    if (event <> 'xml') or (tag.GetAttribute('type') <> 'result') then begin
        // XXX: display more info about error?
        errTag := tag.GetFirstTag('error');
        if (errTag <> nil) then
            _errCode := StrToIntDef(errTag.GetAttribute('code'), 0);
        _state := nus_error;
    end
    else
        _state := nus_auth;

    _runState();
end;

{---------------------------------------}
procedure TfrmNewUser._wait();
begin
    Tabs.ActivePage := tbsWait;
    aniWait.Active := true;
    btnBack.Enabled := false;
    btnCancel.Enabled := true;
end;

{---------------------------------------}
procedure TfrmNewUser._doneWait();
begin
    aniWait.Active := false;
    btnCancel.Enabled := true;
end;

{---------------------------------------}
procedure TfrmNewUser._runState();
var
    x: TXMLTag;
begin
    // run each state
    case _state of
    nus_init: begin
        Tabs.ActivePage := TabSheet1;
        btnBack.Enabled := false;
        btnCancel.Enabled := true;
    end;
    nus_list: begin
        // fetch the list of public servers
        _wait();
        _fetchServers();
        _doneWait();
        _state := nus_init;
        _have_public_servers := true;
        optPublic.Enabled := false;
        optServer.Checked := true;
        _runState();
    end;
    nus_connect: begin
        // try and connect to this server

        // XXX: DO SRV lookups here??
        _connect_attempts := 0;
        _server := cboServer.Text;
        MainSession.NoAuth := true;
        with MainSession.Profile do begin
            Port := 5222;
            ssl := 0;
            Server := _server;
            Host := _server;
            ResolvedIP := _server;
            ResolvedPort := 5222;
        end;
        MainSession.Prefs.SaveProfiles();
        _wait();
        if (MainSession.Active) then begin
            _state := nus_disconnect;
            MainSession.Disconnect();
        end
        else
            MainSession.Connect();
    end;
    nus_user: begin
        Tabs.ActivePage := tbsUser;
        btnBack.Enabled := true;
    end;
    nus_get: begin
        // send the iq-reg-get
        _wait();
        _state := nus_get;
        _iq := TJabberIQ.Create(MainSession, MainSession.generateID(),
            RegGetCallback, 30);
        _iq.Namespace := XMLNS_REGISTER;
        _iq.iqType := 'get';
        _iq.Send();
    end;
    nus_xdata: begin
        Tabs.ActivePage := tbsXData;
        btnBack.Enabled := true;
    end;
    nus_reg: begin
        Tabs.ActivePage := tbsReg;
        btnBack.Enabled := true;
    end;
    nus_set: begin
        // send the iq-set request
        _wait();
        _iq := TJabberIQ.Create(MainSession, MainSession.generateID(),
            RegSetCallback, 30);
        _iq.Namespace := XMLNS_REGISTER;
        _iq.iqType := 'set';

        if (_xdata) then begin
            // get the xdata fields
            _username := xData.getUsername();
            _password := xData.getPassword();
            x := xData.submit();
            _iq.qTag.AddTag(x);
        end
        else begin
            // get the tbsReg fields
            _username := getTopFieldsUsername(tbsReg);
            _password := getTopFieldsPassword(tbsReg);
            PopulateTopFields(tbsReg, _iq.qTag);
        end;
        
        with MainSession.Profile do begin
            Username := _username;
            password := _password;
            Resource :=  resourceName;
            SavePasswd := true;
            NewAccount := true;
        end;
               
        _iq.Send();
    end;

    nus_auth: begin
        // authenticate the user
        _wait();

        with MainSession.Profile do begin
            NewAccount := false;
        end;

        MainSession.Prefs.SaveProfiles();        
        MainSession.AuthAgent.StartAuthentication();
    end;

    nus_finish: begin
        lblOK.Visible := true;
        lblBad.Visible := false;
        Tabs.ActivePage := tbsFinish;
        btnNext.Caption := _('Finish');
        btnBack.Enabled := false;
        btnCancel.Enabled := false;
    end;

    nus_error: begin
        lblOK.Visible := false;
        if (_errCode = 409) then
          lblBad.Caption := _(g409Err)
        else
          lblBad.Caption := _(gGenericErr);
        lblBad.Visible := true;
        Tabs.ActivePage := tbsFinish;
        btnNext.Caption := _('Finish');
        btnNext.Enabled := false;
        btnBack.Enabled := true;

        // make sure we don't try to reconnect underneath the hood:
        frmExodus.CancelConnect();
        frmExodus.timReconnect.Enabled := false;
        GetLoginWindow().ToggleGUI(lgsDisconnected);
    end;

    end;
end;

{---------------------------------------}
procedure TfrmNewUser.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;
    MainSession.UnregisterCallback(_session_cb);

    // make sure we cancel any outstanding queries..
    if (_iq <> nil) then
        FreeAndNil(_iq);
    Action := caFree;
    MainSession.NoAuth := false;
end;

{---------------------------------------}
procedure TfrmNewUser.optExistingAccountClick(Sender: TObject);
begin
  inherited;
    if (optNewAccount.Checked) then begin
        lblUsername.Visible := false;
        lblPassword.Visible := false;
        txtUsername.Visible := false;
        txtPassword.Visible := false;
    end
    else begin
        lblUsername.Visible := true;
        lblPassword.Visible := true;
        txtUsername.Visible := true;
        txtPassword.Visible := true;
        lblUsername.Caption := _('Enter your username:');
        lblPassword.Caption := _('Enter your password:');
    end;
end;

end.
