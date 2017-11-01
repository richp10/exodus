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
unit Profile;


interface

uses
    Exodus_TLB,
    Session, 
    XMLTag, IQ, XMLVcard, XMLVCardCache,
    ShellAPI,
    Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
    buttonFrame, StdCtrls, CheckLst, ExtCtrls, ComCtrls, TntStdCtrls, JabberID,
    TntComCtrls, TntCheckLst, TntExtCtrls, ExtDlgs, ExForm, TntForms, ExFrame,
  ExBrandPanel, ExGroupBox, Grids, TntGrids;

type
  TfrmProfile = class(TExForm)
    frameButtons1: TframeButtons;
    Splitter1: TSplitter;
    TreeView1: TTntTreeView;
    PageControl1: TTntPageControl;
    TabSheet1: TTntTabSheet;
    aniProfile: TAnimate;
    TntPanel1: TTntPanel;
    TntLabel4: TTntLabel;
    lblJID: TTntLabel;
    TntPanel2: TTntPanel;
    ExGroupBox1: TExGroupBox;
    Label7: TTntLabel;
    Label4: TTntLabel;
    Label5: TTntLabel;
    lblEmail: TTntLabel;
    txtFirst: TTntEdit;
    txtMiddle: TTntEdit;
    txtLast: TTntEdit;
    txtPriEmail: TTntEdit;
    TntPanel4: TTntPanel;
    Label2: TTntLabel;
    txtNick: TTntEdit;
    TabSheet3: TTntTabSheet;
    lblURL: TTntLabel;
    Label12: TTntLabel;
    Label6: TTntLabel;
    Label28: TTntLabel;
    Label8: TTntLabel;
    Label9: TTntLabel;
    Label3: TTntLabel;
    txtWeb: TTntEdit;
    cboOcc: TTntComboBox;
    txtBDay: TTntEdit;
    txtHomeVoice: TTntEdit;
    txtHomeFax: TTntEdit;
    memDesc: TTntMemo;
    TabSheet4: TTntTabSheet;
    Label13: TTntLabel;
    Label21: TTntLabel;
    Label29: TTntLabel;
    Label30: TTntLabel;
    Label31: TTntLabel;
    Label32: TTntLabel;
    txtHomeState: TTntEdit;
    txtHomeZip: TTntEdit;
    txtHomeCity: TTntEdit;
    txtHomeStreet2: TTntEdit;
    txtHomeStreet1: TTntEdit;
    txtHomeCountry: TTntComboBox;
    TabSheet5: TTntTabSheet;
    Label22: TTntLabel;
    Label23: TTntLabel;
    Label24: TTntLabel;
    Label19: TTntLabel;
    Label20: TTntLabel;
    txtOrgName: TTntEdit;
    txtOrgUnit: TTntEdit;
    txtOrgTitle: TTntEdit;
    txtWorkVoice: TTntEdit;
    txtWorkFax: TTntEdit;
    TabSheet6: TTntTabSheet;
    Label15: TTntLabel;
    Label16: TTntLabel;
    Label17: TTntLabel;
    Label18: TTntLabel;
    Label26: TTntLabel;
    Label14: TTntLabel;
    txtWorkState: TTntEdit;
    txtWorkZip: TTntEdit;
    txtWorkCity: TTntEdit;
    txtWorkStreet2: TTntEdit;
    txtWorkStreet1: TTntEdit;
    txtWorkCountry: TTntComboBox;
    btnChangeNick: TTntButton;
    picBox: TPaintBox;
    TntLabel1: TTntLabel;
    gridResources: TTntStringGrid;
    lblSubState: TTntLabel;
    gbUserProps: TExGroupBox;
    pnlAllResources: TTntPanel;
    procedure FormCreate(Sender: TObject);
    procedure TreeView1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure frameButtons1btnCancelClick(Sender: TObject);
    procedure frameButtons1btnOKClick(Sender: TObject);
    procedure TreeView1Change(Sender: TObject; Node: TTreeNode);
    procedure lblEmailClick(Sender: TObject);
    procedure btnUpdateNickClick(Sender: TObject);
    procedure picBoxPaint(Sender: TObject);
  private
    { Private declarations }
    //iq: TJabberIQ;
    _vcard: TXMLVCard;
    _origSubIdx: integer;
    _jid: TJabberID;
    _isMe: boolean;
  public
    { Public declarations }
    procedure vcard(jid: Widestring; vcard: TXMLVCard); overload;
  end;

function ShowProfile(jid: Widestring): TfrmProfile;
procedure OnSessionStartProfile(Session: TJabberSession);
procedure OnSessionEndProfile();

implementation

{$R *.DFM}
uses
    JabberConst, JabberUtils, ExUtils,  GnuGetText, DisplayName,
    Presence, ContactController, Unicode, Jabber1, Entity, EntityCache;

const
    sSUB_NONE = 'You can not see each others presence.';
    sSUB_TO = 'Contact can see your presence, you can not see their''s.';
    sSUB_FROM = 'You can see contact''s presence, they can not see yours.';
    sSUB_BOTH = 'You can see contact''s presence, they can see yours.';

type
    TVerResponder = class
        _pForm: TfrmProfile;
        _jid: TJabberID;
    public
        procedure CTCPCallback(event: string; tag: TXMLTag);

        procedure fetchVersion(f: TfrmProfile; j: TJabberID);
    end;
    {------------------------ TSessionListener --------------------------------}
    TSessionListener = class
    private
        _Session: TJabberSession;

        _ReceivedError: WideString;
        _Authenticated: Boolean;

        _SessionCB: integer;
    protected
        procedure SetSession(JabberSession: TJabberSession);virtual;
        procedure FireAuthenticated(); virtual;
        procedure FireDisconnected(); virtual;
    public
        Constructor Create(JabberSession: TJabberSession);
        Destructor Destroy(); override;

        procedure SessionListener(event: string; tag: TXMLTag);

        property Session: TJabberSession read _Session write SetSession;
    end;

var
    _responderList: TWideStringList;
    _openWindowList: TWideStringList;
    _sessionListener: TSessionListener;

function IndexOf(jid: widestring): integer;
var
    i: integer;
begin
    for I := 0 to _openWindowList.Count - 1 do
        if (_openWindowList[i] = jid) then
        begin
            Result := i;
            exit;
        end;
    Result := -1;
end;

{Event fired indicating session object is created and ready}
procedure OnSessionStartProfile(Session: TJabberSession);
begin
    if (_sessionListener <> nil) then
    begin
        _sessionListener.free();
        _sessionListener := nil;
    end;
    if (Session <> nil) then
        _sessionListener := TSessionListener.create(Session);
end;

{Session object is being destroyed. Still valid for this call but not after}
procedure OnSessionEndProfile();
begin
    if (_sessionListener <> nil) then
    begin
        _sessionListener.free();
        _sessionListener := nil;
    end;
end;

procedure TSessionListener.SetSession(JabberSession: TJabberSession);
begin
    if (_Session <> nil) then
    begin
        if (_SessionCB <> -1) then        begin
            _Session.UnRegisterCallback(_SessionCB);
            _SessionCB := -1;
        end;
    end;
    _Session := JabberSession;
    if (_Session <> nil) then
    begin
        _SessionCB := _Session.RegisterCallback(SessionListener, '/session');
        _Authenticated := _Session.Authenticated;
    end;
end;

procedure TSessionListener.FireAuthenticated();
begin
end;

procedure TSessionListener.FireDisconnected();
var
    i : integer;
begin
    for i := 0 to _openWindowList.Count - 1 do
        TForm(_openWindowList.Objects[i]).close();
end;

procedure TSessionListener.SessionListener(event: string; tag: TXMLTag);
begin
    if (event = '/session/authenticated') then
    begin
        _Authenticated := true;
        _ReceivedError := '';
        FireAuthenticated();
    end
    else if ((event = '/session/disconnected') and _Authenticated) then
    begin
        FireDisconnected();
        _Authenticated := false;
    end
    else if (event = '/session/commerror') then
    begin
        _ReceivedError := 'Comm Error';
    end;
end;

Constructor TSessionListener.Create(JabberSession: TJabberSession);
begin
    _Authenticated := false;
    _ReceivedError := '';
    _SessionCB := -1;
    SetSession(JabberSession);
end;

Destructor TSessionListener.Destroy();
begin
    SetSession(nil);
end;

procedure TVerResponder.FetchVersion(f: TfrmProfile; j: TJabberID);
var
    p: TJabberPres;
begin
    //if j is not full, get the primary from ppdb
    if (j.resource = '') then
    begin
        // get some CTCP query sent out
        p := MainSession.ppdb.FindPres(j.jid, '');
        if p = nil then
            exit; //offline, no version

        _jid := TJabberID.create(p.fromJID.full);
    end
    else _jid := TJabberID.create(j);
    _pForm := f;
    _responderList.AddObject(_jid.full, Self);
    ExUtils.jabberSendCTCP(_jid.full, XMLNS_VERSION, Self.CTCPCallback);
end;

procedure TVerResponder.CTCPCallback(event: string; tag: TXMLTag);
var
    i : integer;
    ttag : TXMLTag;
    tstr: wideString;
    qtype: widestring;
begin
{
<iq from='rynok@jabber.com/Jabber Instant Messenger'
        to='pgmillard@jabber.org/workage'
        type='result'>
    <query xmlns='jabber:iq:version'>
        <name>Jabber Instant Messenger</name>
        <version>1.10.0.7</version>
        <os>NT 5.0</os>
    </query>
</iq>
}
    //update labels on associated form
    ttag := nil;
    qtype := 'error';
    if (tag <> nil) then
    begin
        ttag := tag.GetFirstTag('query');
        qtype := tag.getAttribute('type');
    end;

    if ((_pForm <> nil) and (ttag <> nil) and (qtype = 'result')) then
    begin
        for i := 0 to _pForm.gridResources.RowCount - 1 do
        begin
            if (_pForm.gridResources.Cells[0,i] = _jid.resource) then
            begin
                tstr := ttag.GetBasicText('name') + ', version: ' + ttag.GetBasicText('version');
                _pForm.gridResources.Cells[1,i] := tstr;
                break;
            end;
        end;
    end;
    i := _responderList.indexOf(_jid.full);
    if (i <> -1) then //?!
        _responderList.Delete(i);
    _jid.Free();
    Self.Free();
end;

procedure ResponderListRemoveForm(f: TfrmProfile);
var
    i: integer;
    oneRes: TVerResponder;
begin
    for i := 0 to _responderList.Count -1 do
    begin
        oneRes := TVErResponder(_responderList.Objects[1]);
        if (oneRes._pForm = f) then
            oneRes._pForm := nil;
    end;
end;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
function ShowProfile(jid: Widestring): TfrmProfile;
var
    tstr: Widestring;
    item: IExodusItem;
    f: TfrmProfile;
    p: TJabberPres;
    tjid: TJabberID;
    i: integer;
begin
    tjid := TJabberID.create(jid);
    i := INdexOf(tjid.jid);
    if (i <> -1) then
    begin
        TForm(_openWindowList.Objects[i]).Show();
        tjid.free();
        exit;
    end;

    f := TfrmProfile.Create(Application);
    _openWindowList.AddObject(tjid.jid, f);

    with f do begin
        p := MainSession.ppdb.FindPres(tjid.jid, '');
        if (p <> nil) then
            _jid := TJabberID.Create(p.fromJID.full)
        else _jid := TJabberID.Create(tjid.jid);
        tjid.free();
        _isMe := (_jid.jid = MainSession.Profile.getJabberID().jid); //bare jids match

        frameButtons1.btnOK.visible := _isME;
        if (not _isME) then begin
            frameButtons1.btnCancel.Caption := _('Close');
            frameButtons1.btnCancel.Default := true;
        end;

        f.gbUserProps.Caption := GetDisplayNameCache().getDisplayName(_jid) + ' properties';

        lblJID.Caption := _jid.getDisplayJID();
        txtNick.Text := GetDisplayNameCache().getDisplayName(_jid);

        item := MainSession.ItemController.GetItem(_jid.jid);
        if Item <> nil then
            tstr := Item.value['subscription']
        else
            tstr := '';

        if (tstr = 'from') then
            lblSubState.caption := _(sSUB_FROM)
        else if (tstr = 'to') then
            lblSubState.caption := _(sSUB_TO)
        else if (tstr = 'both') then
            lblSubState.caption := _(sSUB_BOTH)
        else
            lblSubState.caption := _(sSUB_NONE);

        gridResources.FixedRows := 1;
        gridResources.RowCount := 2;
        gridResources.Cells[0,0] := _('Resource');
        gridResources.Cells[1,0] := _('Client information');

        while p <> nil do begin
            gridResources.cells[0, gridResources.RowCount -1] := p.fromJID.resource;
            gridResources.Cells[1, gridResources.RowCount -1] := _('Not available');
            gridResources.RowCount := gridResources.RowCount + 1;
            TVerResponder.Create().fetchVersion(f, p.fromJID);
            p := MainSession.ppdb.NextPres(p)
        end;
        gridResources.RowCount := gridResources.RowCount - 1;
        gridResources.Height := (gridResources.RowCount * gridResources.DefaultRowHeight) + 6;
        if (gridResources.Height < 100) then //designed height
            pnlAllResources.Height := gridResources.Height;

        TreeView1.Selected := TreeView1.Items[0];
        TreeView1.FullExpand();
        PageControl1.ActivePageIndex := 0;
    end;
    f.Show;
    f.aniProfile.Visible := true;
    f.aniProfile.Active := true;
    GetVCardCache().find(f._jid.jid, f.vcard);
    
    Result := f;
end;

{---------------------------------------}
procedure TfrmProfile.vcard(jid: Widestring; vcard: TXMLVCard);
begin
    aniProfile.Visible := false;
    aniProfile.Active := false;

    _vcard := vcard;
    if (_vcard = nil) then exit;
    
    with _vcard do begin
        txtFirst.Text := GivenName;
        txtMiddle.Text := MiddleName;
        txtLast.Text := FamilyName;
        txtPriEmail.Text := email;
        txtWeb.Text := url;
        cboOcc.Text := role;
        txtBday.Text := bday;

        txtWorkVoice.Text := WorkPhone.number;
        txtWorkFax.Text := WorkFax.number;
        txtHomeVoice.Text := HomePhone.number;
        txtHomeFax.Text := HomeFax.number;

        with work do begin
            txtWorkStreet1.Text := Street;
            txtWorkStreet2.Text := ExtAdr;
            txtWorkCity.Text := Locality;
            txtWorkState.Text := Region;
            txtWorkZip.Text := PCode;
            txtWorkCountry.Text := Country;
        end;

        with Home do begin
            txtHomeStreet1.Text := Street;
            txtHomeStreet2.Text := ExtAdr;
            txtHomeCity.Text := Locality;
            txtHomeState.Text := Region;
            txtHomeZip.Text := PCode;
            txtHomeCountry.Text := Country;
        end;

        txtOrgName.Text := OrgName;
        txtOrgUnit.Text := OrgUnit;
        txtOrgTitle.Text := OrgTitle;
        memDesc.Lines.Text := Desc;

        if (Picture <> nil) then begin
            Picture.Draw(picBox.Canvas, picBox.ClientRect);
        end;
    end;
end;

{---------------------------------------}
procedure TfrmProfile.FormCreate(Sender: TObject);
var
    i: integer;
    n: TTntTreeNode;
begin
    AssignUnicodeFont(Self);
    TranslateComponent(Self);

    URLLabel(lblEmail);
    URLLabel(lblURL);

    // make all the tabs invisible
    tabSheet1.TabVisible := false;
    tabSheet3.TabVisible := false;
    tabSheet4.TabVisible := false;
    tabSheet5.TabVisible := false;
    tabSheet6.TabVisible := false;

    // Do this to ensure the nodes are properly translated.
    TreeView1.Items.Clear();
    TreeView1.Items.Add(nil, _('Basic'));
    n := TreeView1.Items.AddChild(nil, _('Personal Information'));
    TreeView1.Items.AddChild(n, _('Address'));
    n := TreeView1.Items.AddChild(nil, _('Work Information'));
    TreeView1.Items.AddChild(n, _('Address'));

    for i := 0 to TreeView1.Items.Count - 1 do
        TreeView1.Items[i].Expand(true);

    _origSubIdx := -1;
end;

{---------------------------------------}
procedure TfrmProfile.TreeView1Click(Sender: TObject);
var
    i: integer;
begin
    // Goto this tabsheet
    i := TreeView1.Selected.AbsoluteIndex;
    PageControl1.ActivePageIndex := i;
end;

{---------------------------------------}
procedure TfrmProfile.FormClose(Sender: TObject; var Action: TCloseAction);
var
    i: integer;
begin
//    MainSession.Prefs.SavePosition(Self);
    i := IndexOf(_jid.jid);
    if (i <> -1) then
        _openWindowList.Delete(i);
    if (_jid <> nil) then
        _jid.free();
    Action := caFree;
end;

{---------------------------------------}
procedure TfrmProfile.frameButtons1btnCancelClick(Sender: TObject);
begin
    Self.Close;
end;

{---------------------------------------}
procedure TfrmProfile.frameButtons1btnOKClick(Sender: TObject);
//var
//    ritem: TJabberRosterItem;
//    changed: boolean;
//    i: integer;
begin
    // if the nick has changed then change the roster item
{ TODO : Roster refactor }    
//    ritem := MainSession.roster.Find(txtJID.Text);
//    changed := false;
//
//    if (ritem <> nil) then begin
//
//        if (ritem.Text <> txtNick.Text) then begin
//            ritem.Text := txtNick.Text;
//            changed := true;
//        end;
//
//        // just clear the grps, and add all the selected ones
//        ritem.ClearGroups();
//        for i := 0 to GrpListBox.Items.Count - 1 do begin
//            if GrpListBox.Checked[i] then
//                ritem.AddGroup(grpListBox.Items[i]);
//        end;
//
//        if ((changed) or (ritem.AreGroupsDirty())) then
//            ritem.update();
//    end;
    Self.Close;
end;

{---------------------------------------}
procedure TfrmProfile.TreeView1Change(Sender: TObject; Node: TTreeNode);
begin
    Self.TreeView1Click(Self);
end;

{---------------------------------------}
procedure TfrmProfile.lblEmailClick(Sender: TObject);
var
    url: string;
begin
    // launch a mailto link..
    if (Sender = lblURL) then
        url := txtWeb.Text
    else
        url := 'mailto:' + txtPriEmail.Text;
    ShellExecute(Application.Handle, 'open', PChar(url), '', '', SW_SHOW);
end;

{---------------------------------------}
procedure TfrmProfile.btnUpdateNickClick(Sender: TObject);
var
    i: boolean;
begin
    txtNick.Text := GetDisplayNameCache().getProfileDisplayName(_jid, i)
end;

procedure TfrmProfile.picBoxPaint(Sender: TObject);
begin
    if (_vcard = nil) or (_vcard.picture = nil) then exit;
    _vcard.picture.Draw(picBox.Canvas, picBox.ClientRect);
end;

// soley here to disallow a change in subscription state -
// a managed user is a happy user...
initialization
    _responderList := TWideStringList.create();
    _openWindowList := TWideStringList.create();
finalization
    _responderList.free();
    _responderList := nil;
    _openWindowList.free();
    _openWindowList := nil;
end.
