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
unit RoomProperties;


interface

uses
    Exodus_TLB,
    Session,
    XMLTag,
    IQ,
    XMLVcard,
    ShellAPI,
    Windows,
    Messages,
    SysUtils,
    Classes,
    Graphics,
    Controls,
    Forms,
    Dialogs,
    buttonFrame,
    StdCtrls,
    CheckLst,
    ExtCtrls,
    ComCtrls,
    TntStdCtrls,
    JabberID,
    TntComCtrls,
    TntCheckLst,
    TntExtCtrls,
    ExtDlgs,
    ExForm,
    TntForms,
    ExFrame,
    ExBrandPanel,
    ExGroupBox,
    Grids,
    TntGrids,
    Room;

type
  TfrmRoomProperties = class(TExForm)
    frameButtons1: TframeButtons;
    Splitter1: TSplitter;
    TreeView1: TTntTreeView;
    PageControl1: TTntPageControl;
    TabSheet1: TTntTabSheet;
    pnlJID: TTntPanel;
    TntLabel4: TTntLabel;
    lblJID: TTntLabel;
    gbRoomProps: TExGroupBox;
    pnlSubject: TTntPanel;
    TntLabel1: TTntLabel;
    lblSubject: TTntLabel;
    pnlAffiliation: TTntPanel;
    TntLabel3: TTntLabel;
    lblAffiliation: TTntLabel;
    pnlRole: TTntPanel;
    TntLabel6: TTntLabel;
    lblRole: TTntLabel;
    pnlAutoJoin: TTntPanel;
    chkAutoJoin: TTntCheckBox;
    pnlOccupants: TTntPanel;
    TntLabel2: TTntLabel;
    lblOccupants: TTntLabel;
    pnlNick: TTntPanel;
    TntLabel5: TTntLabel;
    lblNickname: TTntLabel;
    TabSheet2: TTntTabSheet;
    gbConfiguration: TExGroupBox;
    pnlFeatureList: TTntPanel;
    lbConfiguration: TTntListBox;
    TntPanel1: TTntPanel;
    TntLabel7: TTntLabel;
    procedure FormCreate(Sender: TObject);
    procedure TreeView1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure frameButtons1btnCancelClick(Sender: TObject);
    procedure frameButtons1btnOKClick(Sender: TObject);
    procedure TreeView1Change(Sender: TObject; Node: TTreeNode);
    procedure chkAutoJoinClick(Sender: TObject);
  private
    { Private declarations }
    _origSubIdx: integer;
    _jid: TJabberID;
    _room: TfrmRoom;
  public
    { Public declarations }

    property room: TfrmRoom read _room write _room;
  end;

function ShowRoomProperties(jid: Widestring): TfrmRoomProperties;
procedure OnSessionStartRoomProperties(Session: TJabberSession);
procedure OnSessionEndRoomProperties();

const
    NOT_AVAILABLE_CAPTION = 'N/A';

implementation

{$R *.DFM}
uses
    JabberConst,
    JabberUtils,
    ExUtils,
    GnuGetText,
    DisplayName,
    Presence,
    ContactController,
    Unicode,
    Jabber1,
    Entity,
    EntityCache,
    ExActionCtrl,
    COMExodusItemList;

type
    {------------------------ TSessionListenerRoomProperties ------------------}
    TSessionListenerRoomProperties = class
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
    _openWindowList: TWideStringList;
    _sessionListener: TSessionListenerRoomProperties;

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
procedure OnSessionStartRoomProperties(Session: TJabberSession);
begin
    if (_sessionListener <> nil) then
    begin
        _sessionListener.free();
        _sessionListener := nil;
    end;
    if (Session <> nil) then
        _sessionListener := TSessionListenerRoomProperties.create(Session);
end;

{Session object is being destroyed. Still valid for this call but not after}
procedure OnSessionEndRoomProperties();
begin
    if (_sessionListener <> nil) then
    begin
        _sessionListener.free();
        _sessionListener := nil;
    end;
end;

procedure TSessionListenerRoomProperties.SetSession(JabberSession: TJabberSession);
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

procedure TSessionListenerRoomProperties.FireAuthenticated();
begin
end;

procedure TSessionListenerRoomProperties.FireDisconnected();
var
    i : integer;
begin
    for i := 0 to _openWindowList.Count - 1 do
        TForm(_openWindowList.Objects[i]).close();
end;

procedure TSessionListenerRoomProperties.SessionListener(event: string; tag: TXMLTag);
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

Constructor TSessionListenerRoomProperties.Create(JabberSession: TJabberSession);
begin
    _Authenticated := false;
    _ReceivedError := '';
    _SessionCB := -1;
    SetSession(JabberSession);
end;

Destructor TSessionListenerRoomProperties.Destroy();
begin
    SetSession(nil);
end;


{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
function ShowRoomProperties(jid: Widestring): TfrmRoomProperties;
var
    item: IExodusItem;
    f: TfrmRoomProperties;
    p: TJabberPres;
    tjid: TJabberID;
    i: integer;
    roomidx: integer;
    e: TJabberEntity;
begin
    tjid := TJabberID.create(jid);
    i := IndexOf(tjid.jid);
    if (i <> -1) then
    begin
        TForm(_openWindowList.Objects[i]).Show();
        tjid.free();
        exit;
    end;

    f := TfrmRoomProperties.Create(Application);
    _openWindowList.AddObject(tjid.jid, f);

    with f do begin
        room := nil;
        roomidx := room_list.IndexOf(tjid.jid);
        if (roomidx >= 0) then
        begin
            room := TfrmRoom(room_list.Objects[roomidx]);
        end;

        p := MainSession.ppdb.FindPres(tjid.jid, '');
        if (p <> nil) then
            _jid := TJabberID.Create(p.fromJID.full)
        else _jid := TJabberID.Create(tjid.jid);
        tjid.free();
        item := MainSession.ItemController.GetItem(_jid.jid);

        frameButtons1.btnCancel.Caption := _('Close');
        frameButtons1.btnCancel.Default := true;
        frameButtons1.btnOK.Visible := false;

        f.gbRoomProps.Caption := GetDisplayNameCache().getDisplayName(_jid) + _(' properties');
        f.gbConfiguration.Caption := GetDisplayNameCache().getDisplayName(_jid) + _(' configuration');

        lblJID.Caption := _jid.getDisplayJID();
        if (room <> nil) then
        begin
            lblSubject.Caption := room.Subject;
            lblAffiliation.Caption := room.MyAffiliation;
            lblRole.Caption := room.MyRole;
            lblOccupants.Caption := IntToStr(room.GetRoomRosterOnlineCount);
            lblNickname.Caption := room.mynick;
        end;

        if (item <> nil) then
        begin
            chkAutoJoin.Enabled := true;
            if (item.value['autojoin'] = 'true') then
            begin
                chkAutoJoin.Checked := true;
            end
            else begin
                chkAutoJoin.Checked := false;
            end;
        end;

        e := jEntityCache.getByJid(_jid.jid);
        if (e <> nil) then
        begin
            for i := 0 to e.FeatureCount - 1 do
            begin
                lbConfiguration.AddItem(e.Features[i], nil);
            end;
        end
        else begin
            lbConfiguration.AddItem(_(NOT_AVAILABLE_CAPTION), nil);
        end;

        TreeView1.Selected := TreeView1.Items[0];
        TreeView1.FullExpand();
        PageControl1.ActivePageIndex := 0;
    end;
    f.Show;
    Result := f;
end;

{---------------------------------------}
procedure TfrmRoomProperties.FormCreate(Sender: TObject);
var
    i: integer;
begin
    AssignUnicodeFont(Self);
    TranslateComponent(Self);

    lblSubject.Caption := _(NOT_AVAILABLE_CAPTION);
    lblAffiliation.Caption := _(NOT_AVAILABLE_CAPTION);
    lblRole.Caption := _(NOT_AVAILABLE_CAPTION);
    lblOccupants.Caption := _(NOT_AVAILABLE_CAPTION);
    lblNickname.Caption :=  _(NOT_AVAILABLE_CAPTION);
    chkAutoJoin.Enabled := false;
    chkAutoJoin.Checked := false;

    // make all the tabs invisible
    tabSheet1.TabVisible := false;
    tabSheet2.TabVisible := false;

    // Do this to ensure the nodes are properly translated.
    TreeView1.Items.Clear();
    TreeView1.Items.Add(nil, _('Basic'));
    TreeView1.Items.Add(nil, _('Configuration'));

    for i := 0 to TreeView1.Items.Count - 1 do
        TreeView1.Items[i].Expand(true);

    _origSubIdx := -1;
end;

{---------------------------------------}
procedure TfrmRoomProperties.TreeView1Click(Sender: TObject);
var
    i: integer;
begin
    // Goto this tabsheet
    i := TreeView1.Selected.AbsoluteIndex;
    PageControl1.ActivePageIndex := i;
end;

{---------------------------------------}
procedure TfrmRoomProperties.chkAutoJoinClick(Sender: TObject);
var
    item: IExodusItem;
    actionMap: IExodusActionMap;
    itemList: IExodusItemList;
    actions: IExodusTypedActions;
    act: IExodusAction;
begin
    inherited;
    if (chkAutoJoin.Enabled) then
    begin
        item := MainSession.ItemController.GetItem(_jid.jid);
        if (item <> nil) then
        begin
            itemList := TExodusItemList.Create();
            itemList.Add(item);
            actionMap := GetActionController().buildActions(itemList);
            actions := actionMap.GetActionsFor('');
            if (chkAutoJoin.Checked) then
            begin
                act := actions.GetActionNamed('{000-exodus.googlecode.com}-010-join-on-startup');
            end
            else begin
                act := actions.GetActionNamed('{000-exodus.googlecode.com}-010-unjoin-on-startup');
            end;
            if (act <> nil) then
            begin
                act.execute(itemlist);
            end;
        end;
    end;
end;

{---------------------------------------}
procedure TfrmRoomProperties.FormClose(Sender: TObject; var Action: TCloseAction);
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
procedure TfrmRoomProperties.frameButtons1btnCancelClick(Sender: TObject);
begin
    Self.Close;
end;

{---------------------------------------}
procedure TfrmRoomProperties.frameButtons1btnOKClick(Sender: TObject);
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
procedure TfrmRoomProperties.TreeView1Change(Sender: TObject; Node: TTreeNode);
begin
    Self.TreeView1Click(Self);
end;

// soley here to disallow a change in subscription state -
// a managed user is a happy user...
initialization
    _openWindowList := TWideStringList.create();
finalization
    _openWindowList.free();
    _openWindowList := nil;
end.
