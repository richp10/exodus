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
unit Browser;

interface

uses
    Dockable, Entity, IQ, XMLTag, XMLUtils, Contnrs, Unicode,
    Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
    StdCtrls, ImgList, Buttons, ComCtrls, ExtCtrls, Menus, ToolWin, fListbox,
    fService, TntStdCtrls, TntComCtrls, TntExtCtrls, TntMenus;

type

  TfrmBrowse = class(TfrmDockable)
    Panel3: TTntPanel;
    ImageList1: TImageList;
    ImageList2: TImageList;
    Toolbar: TImageList;
    DisToolbar: TImageList;
    popHistory: TTntPopupMenu;
    popViewStyle: TTntPopupMenu;
    StatBar: TStatusBar;
    vwBrowse: TTntListView;
    popContext: TTntPopupMenu;
    List1: TTntMenuItem;
    SmallIcons1: TTntMenuItem;
    LargeIcons1: TTntMenuItem;
    Details1: TTntMenuItem;
    mJoinConf: TTntMenuItem;
    mRegister: TTntMenuItem;
    mSearch: TTntMenuItem;
    mVCard: TTntMenuItem;
    N1: TTntMenuItem;
    mBookmark: TTntMenuItem;
    mBrowseNew: TTntMenuItem;
    mBrowse: TTntMenuItem;
    pnlJid: TPanel;
    pnlJidID: TTntPanel;
    cboJID: TTntComboBox;
    btnGo: TSpeedButton;
    btnRefresh: TSpeedButton;
    pnlNode: TPanel;
    pnlNodeID: TTntPanel;
    cboNode: TTntComboBox;
    mAddContact: TTntMenuItem;
    mRunCommand: TTntMenuItem;
    TntLabel1: TTntLabel;
    TntLabel2: TTntLabel;
    pnlInfo: TTntPanel;
    lblIdentity: TTntLabel;
    Splitter1: TSplitter;
    lblFeatures: TTntLabel;
    lsFeatures: TTntListBox;
    vwInfo: TTntListView;
    pnlTop: TTntPanel;
    CoolBar1: TCoolBar;
    tlbToolBar: TToolBar;
    btnBack: TToolButton;
    btnFwd: TToolButton;
    ToolButton2: TToolButton;
    btnHome: TToolButton;
    ToolButton1: TToolButton;
    btnBookmark: TToolButton;
    ToolButton3: TToolButton;
    btnNode: TToolButton;
    btnInfo: TToolButton;
    mGetInfo: TTntMenuItem;
    procedure btnGoClick(Sender: TObject);
    procedure ResizeAddressBar(Sender: TObject);
    procedure cboJIDKeyPress(Sender: TObject; var Key: Char);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnBackClick(Sender: TObject);
    procedure btnFwdClick(Sender: TObject);
    procedure vwBrowseClick(Sender: TObject);
    procedure Details1Click(Sender: TObject);
    procedure btnHomeClick(Sender: TObject);
    procedure btnRefreshClick(Sender: TObject);
    procedure vwBrowseChange(Sender: TObject; Item: TListItem;
      Change: TItemChange);
    procedure mRegisterClick(Sender: TObject);
    procedure mBookmarkClick(Sender: TObject);
    procedure mVCardClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure mBrowseClick(Sender: TObject);
    procedure mBrowseNewClick(Sender: TObject);
    procedure mJoinConfClick(Sender: TObject);
    procedure mSearchClick(Sender: TObject);
    procedure vwBrowseData(Sender: TObject; Item: TListItem);
    procedure btnCloseClick(Sender: TObject);
    procedure vwBrowseResize(Sender: TObject);
    procedure vwBrowseColumnClick(Sender: TObject; Column: TListColumn);
    procedure FormDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure popContextPopup(Sender: TObject);
    procedure ToolButton3Click(Sender: TObject);
    procedure btnNodeClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure mRunCommandClick(Sender: TObject);
    procedure mAddContactClick(Sender: TObject);
    procedure mGetInfoClick(Sender: TObject);
    procedure vwInfoData(Sender: TObject; Item: TListItem);
    procedure btnInfoClick(Sender: TObject);
  private
    { Private declarations }
    _cur: integer;
    _history: TWidestringList;
    _node_hist: TWidestringlist;
    _iq: TJabberIQ;
    _blist: TList;
    _ilist: TList;
    _scb: integer;
    _ecb: integer;
    _ent: TJabberEntity;
    _node: boolean;
    _pendingInfo: boolean;

    procedure SessionCallback(event: string; tag: TXMLTag);
    procedure EntityCallback(event: string; tag:TXMLTag);
    procedure ShowItems();
    procedure ShowInfo(e: TJabberEntity);

    // Generic GUI stuff
    procedure SetupTitle(name, jid: Widestring);
    procedure StartList();
    procedure DoBrowse(jid: Widestring; refresh: boolean; node: Widestring = '');
    procedure PushJID(jid, node: Widestring);
    procedure StartBar();
    procedure StopBar();
    procedure ContextMenu(enabled: boolean);
    procedure NodeVisible(vis: Boolean);
    procedure ShowDiscoInfo();

  public
    { Public declarations }
    procedure GoJID(jid: Widestring; refresh: boolean; node: Widestring = '');
  end;

var
  frmBrowse: TfrmBrowse;

function ShowBrowser(jid: string = ''): TfrmBrowse;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
implementation
uses
    EntityCache, GnuGetText, CommandWizard, DiscoIdentity,
    JabberConst, JoinRoom, Room, ContactController, JabberID, 
    JabberUtils, ExUtils,  Session, JUD, Profile, RegForm, Jabber1,
    RosterImages;

const
    sInvalidJID = 'The Jabber ID you entered is invalid.';

{$R *.DFM}

var
    cur_sort: integer;
    sort_rev: boolean;


{---------------------------------------}
function ShowBrowser(jid: string = ''): TfrmBrowse;
begin
//    Result := TfrmBrowse.Create(Application);
    Application.CreateForm(TfrmBrowse, Result);
    Result.ShowDefault(true);

    if (jid = '') then
        Result.GoJID(MainSession.Server, false)
    else begin
        Result.GoJID(jid, true);
    end;
end;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
procedure TfrmBrowse.SetupTitle(name, jid: Widestring);
begin
    //lblTitle.Caption := title + ': ' + name;
    //lblHeader.Caption := title;
end;

{---------------------------------------}
procedure TfrmBrowse.StartList;
begin
    // The clears the list properly.
    _blist.Clear();
    vwBrowse.Items.Count := 0;
    vwBrowse.Items.Clear();
    pnlInfo.Visible := false;
    vwBrowse.Visible := true;
end;

{---------------------------------------}
procedure TfrmBrowse.DoBrowse(jid: Widestring; refresh: boolean; node: Widestring);
var
    tmp: TJabberID;
begin
    // Actually Browse to the JID entered in the address box
    if (not isValidJID(jid, true)) then begin
        if (not isValidJID(jid, false)) then begin
            MessageDlgW(_(sInvalidJID), mtError, [mbOK], 0);
            exit;
        end
        else begin
            tmp := TJabberID.Create(jid, false);
            jid := tmp.full;
            tmp.Free();
        end;
    end;

    StartList;
    StartBar;

    // do the browse query
    _ent := jEntityCache.getByJid(jid, node);
    if (_ent = nil) then
        _ent := jEntityCache.fetch(jid, MainSession, true, node)
    else if (refresh = false) then
        _ent := jEntityCache.fetch(jid, MainSession, true, node)
    else
        _ent.Refresh(MainSession);
end;

{---------------------------------------}
procedure TfrmBrowse.GoJID(jid: Widestring; refresh: boolean; node: Widestring);
var
  tjid: TJabberID;
begin
    tjid := TJabberID.Create(jid);
    cboJID.Text := tjid.GetDisplayFull();
    DoBrowse(jid, refresh, node);
    PushJID(jid, node);
    tjid.Free();
end;

{---------------------------------------}
procedure TfrmBrowse.PushJID(jid, node: Widestring);
var
    hi, lo, i: integer;
begin
    // Deal with the history list, and menu items
    if (_cur < _history.count) then begin
        // we aren't at the beginning..
        // clear the history stack from here.
        for i := _history.count - 1 downto _cur + 1 do
            _history.Delete(i);
        for i := _node_hist.count - 1 downto _cur + 1 do
            _node_hist.Delete(i);
    end;

    _history.Add(jid);
    _node_hist.Add(node);
    
    hi := _history.Count - 1;
    lo := hi - 10;
    if lo < 0 then lo := 0;
    cboJID.Items.Clear;
    cboNode.Items.Clear;
    for i := lo to hi do begin
        cboJID.Items.Add(_history[i]);
        cboNode.Items.Add(_node_hist[i]);
    end;
    _cur := _history.count;
    btnBack.Enabled := true;
end;

{---------------------------------------}
procedure TfrmBrowse.btnGoClick(Sender: TObject);
begin
    DoBrowse(cboJID.Text, false, cboNode.Text);
    PushJID(cboJID.Text, cboNode.Text);
end;

{---------------------------------------}
procedure TfrmBrowse.ResizeAddressBar(Sender: TObject);
begin
    cboJid.Width := pnlJID.Width - (pnlJidID.Width + btnGo.Width + btnRefresh.Width + 10);
    cboNode.Width := cboJid.Width;
    btnGo.Left := cboJid.Width + cboJid.Left + 1;
    btnRefresh.Left := btnGo.Width + btnGo.Left + 1;
    Coolbar1.Width := pnlTop.ClientWidth - 1;
end;

{---------------------------------------}
procedure TfrmBrowse.cboJIDKeyPress(Sender: TObject; var Key: Char);
begin
    // Do a a 'GO' if the <enter> key is hit
    if Key = Chr(13) then btnGoClick(Self);
end;

{---------------------------------------}
procedure TfrmBrowse.FormCreate(Sender: TObject);
begin
    // Create the History list
    inherited;
    
    AssignUnicodeFont(Self);
    TranslateComponent(Self);
    _History := TWidestringList.Create();
    _node_hist := TWidestringList.Create();
    _blist := TList.Create();
    _ilist := TList.Create();
    _iq := nil;
    _pendingInfo := false;
    cur_sort := -1;
    sort_rev := false;
    vwBrowse.ViewStyle := TViewStyle(MainSession.Prefs.getInt('browse_view'));
    _node := MainSession.Prefs.getBool('browse_node');
    NodeVisible(_node);

    // Branding
    mJoinConf.Visible := MainSession.Prefs.getBool('brand_muc');
    mBookmark.Visible := MainSession.Prefs.getBool('brand_muc');

    pnlInfo.Visible := false;
    pnlInfo.Align := alClient;

    _scb := MainSession.RegisterCallback(SessionCallback, '/session/disconnected');
    _ecb := MainSession.RegisterCallback(EntityCallback, '/session/entity');

    ImageIndex := RosterImages.RI_BROWSER_INDEX;
    _windowType := 'browser';
end;

{---------------------------------------}
procedure TfrmBrowse.FormDestroy(Sender: TObject);
begin
    // Free the History list
    if (_iq <> nil) then
        FreeAndNil(_iq);

    if (MainSession <> nil) then begin
        MainSession.UnRegisterCallback(_scb);
        MainSession.UnRegisterCallback(_ecb);
    end;

    _history.Free();
    _node_hist.Free();
    _blist.Clear();
    _blist.Free();
    _ilist.Clear();
    _ilist.Free();
end;

{---------------------------------------}
procedure TfrmBrowse.btnBackClick(Sender: TObject);
var
    jid: TJabberID;
begin
    // Browse to the last JID
    if (_cur >= _history.count) then
        _cur := _cur - 2
    else
        dec(_cur);

    if (_cur < 0) then begin
        _cur := 0;
        btnBack.Enabled := false;
        exit;
    end;

    jid := TJabberID.Create(_history[_cur]);
    btnFwd.Enabled := true;
    cboJID.Text := jid.getDisplayFull();
    jid.Free();
    cboNode.Text := _node_hist[_cur];
    DoBrowse(_history[_cur], false, _node_hist[_cur]);
    if _cur = 0 then btnBack.Enabled := false;
end;

{---------------------------------------}
procedure TfrmBrowse.btnFwdClick(Sender: TObject);
var
    jid: TJabberID;
begin
    // Browse to the next JID in the history
    inc(_cur);
    if (_cur >= _history.Count) then begin
        _cur := _History.Count;
        btnFwd.Enabled := false;
        exit;
    end;
    jid := TJabberID.Create(_history[_cur]);
    cboJID.Text := jid.GetDisplayFull();
    jid.Free();
    cboNode.Text := _node_hist[_cur];
    btnBack.Enabled := true;
    DoBrowse(_history[_cur], false, _node_hist[_cur]);
    if _cur = _history.Count then btnFwd.Enabled := false;
end;

{---------------------------------------}
procedure TfrmBrowse.vwBrowseClick(Sender: TObject);
var
    itm: TTntListItem;
    jid: TJabberID;
begin
    // Browse to this object
    itm := vwBrowse.Selected;
    if itm <> nil then begin
        jid := TJabberID.Create(itm.SubItems[0]);
        cboJID.Text := jid.getDisplayFull();
        jid.Free();
        cboNode.Text := itm.SubItems[2];
        btnGOClick(Self);
    end;
end;

{---------------------------------------}
procedure TfrmBrowse.Details1Click(Sender: TObject);
begin
    // Change the View
    if Sender = Details1 then begin
        vwBrowse.ViewStyle := vsReport;
    end
    else if Sender = LargeIcons1 then begin
        vwBrowse.ViewStyle := vsIcon;
    end
    else if Sender = SmallIcons1 then begin
        vwBrowse.ViewStyle := vsSmallIcon;
    end
    else if Sender = List1 then begin
        vwBrowse.ViewStyle := vsList;
    end;

    MainSession.Prefs.setInt('browse_view', integer(vwBrowse.ViewStyle));

end;

{---------------------------------------}
procedure TfrmBrowse.btnHomeClick(Sender: TObject);
begin
    // browse to the Jabber Server
    cboJID.Text := MainSession.Server;
    cboNode.Text := '';
    btnGOClick(btnHome);
    btnBack.Enabled := false;
    btnFwd.Enabled := false;
end;

{---------------------------------------}
procedure TfrmBrowse.btnRefreshClick(Sender: TObject);
begin
    // Refresh
    StartList;

    // re-browse to this JID..
    DoBrowse(cboJID.Text, true, cboNode.Text);
    PushJID(cboJID.Text, cboNode.Text);
end;

{---------------------------------------}
procedure TfrmBrowse.ContextMenu(enabled: boolean);
begin
    mBrowse.Enabled := enabled;
    mBrowseNew.Enabled := enabled;
    mBookmark.Enabled := enabled;

    mVCard.Enabled := enabled;
    mSearch.Enabled := enabled;
    mRegister.Enabled := enabled;
    mJoinConf.Enabled := enabled;
    mAddContact.Enabled := enabled;
end;

{---------------------------------------}
procedure TfrmBrowse.vwBrowseChange(Sender: TObject; Item: TListItem;
  Change: TItemChange);
var
    b: TJabberEntity;
begin
    // The selection has changed from one item to another
    if Item = nil then begin
        ContextMenu(false);
        exit;
    end;

    ContextMenu(true);

    b := TJabberEntity(_blist[Item.Index]);

    mSearch.Enabled := b.hasFeature(FEAT_SEARCH);
    mRegister.Enabled := b.hasFeature(FEAT_REGISTER);
    mRunCommand.Enabled := b.hasFeature(XMLNS_COMMANDS);

    // various conference namespaces
    if (b.hasFeature(XMLNS_CONFERENCE)) then mJoinConf.Enabled := true
    else if (b.hasFeature(FEAT_GROUPCHAT)) then mJoinConf.Enabled := true
    else if (b.hasFeature(XMLNS_MUC)) then mJoinConf.Enabled := true
    else if (b.hasFeature('gc-1.0')) then mJoinConf.Enabled := true
    else if (b.category = 'conference') then mJoinConf.Enabled := true
    else mJoinConf.Enabled := false;

    // contacts
    if (b.category = 'client') then mAddContact.Enabled := true
    else if (b.category = 'user') then mAddContact.Enabled := true
    else if ((b.category = 'directory') and (b.CatType = 'user')) then
        mAddContact.Enabled := true
    else mAddContact.Enabled := false;


end;

{---------------------------------------}
procedure TfrmBrowse.mRegisterClick(Sender: TObject);
var
    j: Widestring;
begin
    // Register to this Service
    if vwBrowse.Selected = nil then exit;
    j := vwBrowse.Selected.SubItems[0];
    StartServiceReg(j);
end;

{---------------------------------------}
procedure TfrmBrowse.mBookmarkClick(Sender: TObject);
var
    itm: TTntListItem;
begin
    itm := vwBrowse.Selected;
    if itm = nil then exit;
     { TODO : Roster refactor }
    //ShowBookmark(itm.SubItems[0], itm.Caption);
end;

{---------------------------------------}
procedure TfrmBrowse.mVCardClick(Sender: TObject);
var
    itm: TTntListItem;
    jid: Widestring;
begin
    // do some CTCP stuff
    itm := vwBrowse.Selected;
    if itm = nil then exit;

    jid := itm.SubItems[0];
    ShowProfile(itm.SubItems[0])
end;

{---------------------------------------}
procedure TfrmBrowse.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    if (_iq <> nil) then begin
        _iq.Free();
        _iq := nil;
    end;
    Action := caFree;
end;

{---------------------------------------}
procedure TfrmBrowse.mBrowseClick(Sender: TObject);
var
    itm: TTntListItem;
    jid: TJabberID;
begin
    // Browse to this JID
    itm := vwBrowse.Selected;
    if itm = nil then exit;

    jid := TJabberID.Create(itm.SubItems[0]);
    cboJID.Text := jid.GetDisplayFull();
    jid.Free();
    cboNode.Text := itm.SubItems[2];
    btnGoClick(Self);
end;

{---------------------------------------}
procedure TfrmBrowse.mBrowseNewClick(Sender: TObject);
var
    itm: TTntListItem;
begin
    // Browse to this JID
    itm := vwBrowse.Selected;
    if itm = nil then exit;

    GoJID(itm.SubItems[0], true);
end;

{---------------------------------------}
procedure TfrmBrowse.mJoinConfClick(Sender: TObject);
var
    itm: TTntListItem;
    tmpjid: TJabberID;
    cjid: Widestring;
begin
    // join conf. room
    cjid := '';
    itm := vwBrowse.Selected;
    cjid := itm.SubItems[0];

    tmpjid := TJabberID.Create(cjid);
    if (tmpjid.user = '') then
        StartJoinRoom(tmpjid, '', '')
    else
        StartRoom(cjid, '', '', True, False, True);
    tmpjid.Free();
end;

{---------------------------------------}
procedure TfrmBrowse.mSearchClick(Sender: TObject);
var
    itm: TTntListItem;
    j: Widestring;
begin
    // Search using this service.
    j := '';
    itm := vwBrowse.Selected;
    j := itm.SubItems[0];

    if (j <> '') then
        StartSearch(j);
end;

{---------------------------------------}
procedure TfrmBrowse.StartBar;
begin
    //
end;

{---------------------------------------}
procedure TfrmBrowse.StopBar;
begin
    //
end;

{---------------------------------------}
procedure TfrmBrowse.SessionCallback(event: string; tag: TXMLTag);
begin
    if (event = '/session/disconnected') then begin
        Self.Close();
    end;
end;

{---------------------------------------}
procedure TfrmBrowse.EntityCallback(event: string; tag:TXMLTag);
var
    tmps: Widestring;
    ce: TJabberEntity;
begin
    if (_ent = nil) then exit;
    if (tag = nil) then exit;

    tmps := tag.getAttribute('from');

    if (_ent.jid.full = tmps) then begin
        if (event = '/session/entity/items') then
            ShowItems()
        else begin // info

        if _pendingInfo then begin
            _pendingInfo := false;
            PushJid(_ent.Jid.full, _ent.Node);
            ShowDiscoInfo();
        end
        else begin
            ShowInfo(_ent);

            setupTitle(_ent.Name, _ent.Jid.full);
            StatBar.Panels[0].Text := IntToStr(_blist.Count) + ' ' + _('Objects');
            pnlInfo.Visible := false;
            vwBrowse.Visible := true;

            StopBar();
        end;

        end;
    end
    else if (event = '/session/entity/info') then begin
        // check to see if this is a child item of _ent
        ce := _ent.ItemByJid(tmps);
        if (ce <> nil) then
            ShowInfo(ce);
    end;
end;

{---------------------------------------}
procedure TfrmBrowse.ShowItems();
var
    i: integer;
begin
    // populate listview with empty items.
    _blist.Clear();
    for i := 0 to _ent.ItemCount - 1 do
        _blist.Add(_ent.Items[i]);

    // set the listview count
    vwBrowse.Items.Count := _blist.Count;
    StatBar.Panels[0].Text := IntToStr(_blist.Count) + _(' Objects');

    if _blist.Count = 0 then
        ShowDiscoInfo();
end;

{---------------------------------------}
procedure TfrmBrowse.ShowInfo(e: TJabberEntity);
var
    i: integer;
begin
    //
    e.tag := -1;
    if (e.category =  'service') then begin
        e.tag := 5;
    end
    else if (e.category =  'conference') then begin
        e.tag := 1;
    end
    else if (e.category =  'user') then begin
        e.tag := 0;
    end
    else if (e.category =  'application') then begin
        e.tag := 7;
    end
    else if (e.category =  'headline') then begin
        e.tag := 6;
    end
    else if (e.category =  'render') then begin
        e.tag := 2;
    end
    else if (e.category =  'keyword') then begin
        e.tag := 3;
    end
    else begin
        e.tag := 4;
    end;

    i := _blist.IndexOf(e);
    if (i >= 0) then
        vwBrowse.Invalidate();

end;

{---------------------------------------}
procedure TfrmBrowse.vwBrowseData(Sender: TObject; Item: TListItem);
var
    b: TJabberEntity;
begin
  inherited;
    with TTntListItem(Item) do begin
        if (index >= _blist.count) then exit;

        b := TJabberEntity(_blist[index]);
        if (b.name <> '') then
            caption := b.name
        else
            caption := b.jid.getDisplayFull();

        if (b.Tag = -1) then
            ImageIndex := 8
        else
            ImageIndex := b.tag;
        SubItems.Add(b.jid.full);
        SubItems.Add(b.catType);
        SubItems.Add(b.Node);
    end;
end;

{---------------------------------------}
procedure TfrmBrowse.btnCloseClick(Sender: TObject);
begin
  inherited;
    Self.Close;
end;

{---------------------------------------}
procedure TfrmBrowse.vwBrowseResize(Sender: TObject);
begin
  inherited;
    vwBrowse.Invalidate();
end;

{---------------------------------------}
{
function ItemCompare(Item1, Item2: Pointer): integer;
var
    j1, j2: TJabberEntity;
    s1, s2: Widestring;
begin
    // compare 2 items..
    if (cur_sort = -1) then begin
        Result := 0;
        exit;
    end;

    j1 := TJabberEntity(Item1);
    j2 := TJabberEntity(Item2);

    case (cur_sort) of
    0: begin
        s1 := j1.name;
        s2 := j2.name;
    end;
    1: begin
        s1 := j1.jid.full;
        s2 := j2.jid.full;
    end;
    2: begin
        s1 := j1.catType;
        s2 := j2.catType;
    end
    else begin
        Result := 0;
        exit;
    end;
    end;

    if (cur_dir) then
        Result := AnsiCompareText(s1, s2)
    else
        Result := AnsiCompareText(s2, s1);

end;
}

{---------------------------------------}
procedure TfrmBrowse.vwBrowseColumnClick(Sender: TObject;
  Column: TListColumn);
begin
  inherited;

  if (Column.Index = cur_sort) then
    sort_rev := not sort_rev
  else
    sort_rev := false;

  cur_sort := Column.Index;

  case cur_sort of
  0: begin
    if (sort_rev) then _blist.Sort(EntityNameCompareRev)
        else _blist.Sort(EntityNameCompare);
    end;
  1: begin
    if (sort_rev) then _blist.Sort(EntityJidCompareRev)
        else _blist.Sort(EntityJidCompare);
    end;
  2: begin
    if (sort_rev) then _blist.Sort(EntityCatCompareRev)
        else _blist.Sort(EntityCatCompare);
    end;
  end;
  vwBrowse.Refresh;
end;

{---------------------------------------}
procedure TfrmBrowse.FormDragOver(Sender, Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
begin
  inherited;
//    btnClose.Visible := Docked;
end;

{---------------------------------------}
procedure TfrmBrowse.popContextPopup(Sender: TObject);
begin
  inherited;
    // Check for valid actions..
    if ((vwBrowse.Selected = nil) or (not MainSession.Active)) then
        ContextMenu(false);
end;


{---------------------------------------}
procedure TfrmBrowse.ToolButton3Click(Sender: TObject);
var
    i: integer;
    ce: TJabberEntity;
begin
  inherited;
    // Get info for everything in _blist
    for i := 0 to _blist.count - 1 do begin
        ce := TJabberEntity(_blist[i]);
        if (not ce.hasInfo) then ce.getInfo(MainSession);
    end;
end;

{---------------------------------------}
procedure TfrmBrowse.btnNodeClick(Sender: TObject);
begin
    _node := not _node;
    NodeVisible(_node);
end;

{---------------------------------------}
procedure TfrmBrowse.NodeVisible(vis: Boolean);
begin
    btnNode.Down := _node;
    pnlNode.Visible := vis;
    MainSession.Prefs.setBool('browse_node', _node);
end;

{---------------------------------------}
procedure TfrmBrowse.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  inherited;
    _blist.Clear();
    vwBrowse.Items.Count := 0;
end;

{---------------------------------------}
procedure TfrmBrowse.mRunCommandClick(Sender: TObject);
var
    cjid: Widestring;
    itm: TTntListItem;
begin
  inherited;
    cjid := '';
    itm := vwBrowse.Selected;
    if (itm = nil) then exit;

    cjid := itm.SubItems[0];
    StartCommandWizard(cjid);
end;

{---------------------------------------}
procedure TfrmBrowse.mAddContactClick(Sender: TObject);
var
    cjid: Widestring;
    itm: TTntListItem;
begin
  inherited;
    // add this contact
    cjid := '';
    itm := vwBrowse.Selected;
    if (itm = nil) then exit;

    cjid := itm.SubItems[0];
    
end;

procedure TfrmBrowse.ShowDiscoInfo();
var
    i: integer;
begin
    lsFeatures.Clear();
    for i:=0 to _ent.FeatureCount-1 do begin
        lsFeatures.Items.Add(_ent.Features[i]);
    end;

    _ilist.Clear;
    for i:=0 to _ent.IdentityCount-1 do begin
        _ilist.Add(_ent.Identities[i]);
    end;
    vwInfo.Items.Count := _ilist.Count;

    pnlInfo.Visible := true;
    pnlInfo.Align := alClient;
end;

procedure TfrmBrowse.mGetInfoClick(Sender: TObject);
var
    itm: TTntListItem;
    node: WideString;
    jid: TJabberID;
begin
    inherited;

    itm := vwBrowse.Selected;
    if itm = nil then exit;

    jid := TJabberID.Create(itm.SubItems[0]);
    node := itm.SubItems[2];

    cboJID.Text := jid.getDisplayFull();
    cboNode.Text := node;

    _ent := jEntityCache.getByJid(jid.full, node);
    if (_ent = nil) then
        _ent := jEntityCache.fetch(jid.full, MainSession, true, node);
    if not _ent.hasInfo then begin
        _ent.getInfo(MainSession);
        _pendingInfo := true;
        exit;
    end;
        
    PushJID(jid.full, node);

    ShowDiscoInfo();
end;

procedure TfrmBrowse.vwInfoData(Sender: TObject; Item: TListItem);
var
    info: TDiscoIdentity;
begin
    with TTntListItem(Item) do begin
        if (index >= _ilist.count) then exit;

        info := TDiscoIdentity(_ilist[index]);
        caption := info.Name;

        SubItems.Add(info.Category);
        SubItems.Add(info.DiscoType);
    end;
end;

procedure TfrmBrowse.btnInfoClick(Sender: TObject);
begin
    PushJid(_ent.Jid.full, _ent.Node);
    ShowDiscoInfo();
end;

end.
