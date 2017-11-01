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
unit JoinRoom;


interface

uses
    JabberID, XMLTag, Unicode, Entity,
    Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
    Dialogs, Wizard, ComCtrls, TntComCtrls, StdCtrls, TntStdCtrls, ExtCtrls,
    TntExtCtrls;

type
  TfrmJoinRoom = class(TfrmWizard)
    Label2: TTntLabel;
    Label1: TTntLabel;
    lblPassword: TTntLabel;
    Label3: TTntLabel;
    txtServer: TTntComboBox;
    txtRoom: TTntEdit;
    txtPassword: TTntEdit;
    txtNick: TTntEdit;
    optSpecify: TTntRadioButton;
    optBrowse: TTntRadioButton;
    TabSheet2: TTabSheet;
    lstRooms: TTntListView;
    Panel2: TPanel;
    lblFetch: TTntLabel;
    txtServerFilter: TTntComboBox;
    btnFetch: TTntButton;
    chkDefaultConfig: TTntCheckBox;
    TntLabel1: TTntLabel;
    Bevel3: TBevel;
    aniWait: TAnimate;
    chkUseRegisteredNickname: TTntCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnNextClick(Sender: TObject);
    procedure btnFetchClick(Sender: TObject);
    procedure btnBackClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure optSpecifyClick(Sender: TObject);
    procedure txtServerFilterKeyPress(Sender: TObject; var Key: Char);
    procedure lstRoomsChange(Sender: TObject; Item: TListItem;
      Change: TItemChange);
    procedure lstRoomsDblClick(Sender: TObject);
    procedure txtServerFilterSelect(Sender: TObject);
    procedure lstRoomsData(Sender: TObject; Item: TListItem);
    procedure lstRoomsColumnClick(Sender: TObject; Column: TListColumn);
    //procedure txtServerFilterChange(Sender: TObject);
    procedure lstRoomsDataFind(Sender: TObject; Find: TItemFind;
      const FindString: WideString; const FindPosition: TPoint;
      FindData: Pointer; StartIndex: Integer; Direction: TSearchDirection;
      Wrap: Boolean; var Index: Integer);
    procedure lstRoomsKeyPress(Sender: TObject; var Key: Char);
    procedure txtNickChange(Sender: TObject);
    procedure txtServerChange(Sender: TObject);
    procedure txtRoomChange(Sender: TObject);
  private
    { Private declarations }
    _cb: integer;
    _disconcb: integer;
    _all: TList;
    _filter: TList;
    _cur: TList;
    _cur_sort: integer;
    _asc: boolean;
    _wait: TWidestringlist;

    procedure _fetch(jid: Widestring);
    procedure _addRoomJid(ce: TJabberEntity);
    procedure _processFilter();
    procedure _enableNext();
  published
    procedure EntityCallback(event: string; tag: TXMLTag);
    procedure DisconCallback(event: string; tag: TXMLTag);
  public
    { Public declarations }
    procedure populateServers();
  end;

var
  frmJoinRoom: TfrmJoinRoom;

procedure StartJoinRoom; overload;
procedure StartJoinRoom(room_jid: TJabberID; nick, password: WideString); overload;
procedure StartJoinRoomBrowse;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
implementation
{$R *.DFM}
uses
    EntityCache, JabberUtils, ExUtils,  GnuGetText, Jabber1, Session, Room;

const
    sInvalidNick = 'You must enter a nickname';
    sInvalidRoomJID = 'The Room Address you entered is invalid. It must be valid Jabber ID.';

{---------------------------------------}
procedure StartJoinRoom;
var
    jr: TfrmJoinRoom;
begin
    if (not MainSession.Prefs.getBool('brand_muc')) then exit;
    jr := TfrmJoinRoom.Create(Application);
    with jr do begin
        txtRoom.Text := MainSession.Prefs.getStringInProfile(MainSession.Profile.Name, 'tc_lastroom');
        txtServer.Text := MainSession.Prefs.getStringInProfile(MainSession.Profile.Name, 'tc_lastserver');
        txtNick.Text := MainSession.Profile.getDisplayUsername();
        if (MainSession.Prefs.getBool('brand_prevent_change_nick')) then begin
            txtNick.Enabled := False;
            chkUseRegisteredNickname.Enabled := False;
            chkUseRegisteredNickname.Checked := False;
        end;
        //txtNick.Text := MainSession.Prefs.getStringInProfile(MainSession.Profile.Name, 'tc_lastnick');
        populateServers();
        Show;
    end;
end;

{---------------------------------------}
procedure StartJoinRoom(room_jid: TJabberID; nick, password: WideString); overload;
var
    jr: TfrmJoinRoom;
begin
    if (not MainSession.Prefs.getBool('brand_muc')) then exit;
    jr := TfrmJoinRoom.Create(Application);
    with jr do begin
        txtRoom.Text := room_jid.userDisplay;
        txtServer.Text := room_jid.domain;
        txtNick.Text := nick;
        txtPassword.Text := password;

        if (txtNick.Text = '') then
            txtNick.Text := MainSession.Profile.getDisplayUsername();

        populateServers();
        Show;
    end;
end;

{---------------------------------------}
procedure StartJoinRoomBrowse;
var
    jr: TfrmJoinRoom;
    i: integer;
begin
    if (not MainSession.Prefs.getBool('brand_muc')) then exit;
    jr := TfrmJoinRoom.Create(Application);
    with jr do begin
        txtRoom.Text := MainSession.Prefs.getStringInProfile(MainSession.Profile.Name, 'tc_lastroom');
        txtServer.Text := MainSession.Prefs.getStringInProfile(MainSession.Profile.Name, 'tc_lastserver');
        txtNick.Text := MainSession.Profile.getDisplayUsername();
        if (MainSession.Prefs.getBool('brand_prevent_change_nick')) then begin
            txtNick.Enabled := False;
            chkUseRegisteredNickname.Enabled := False;
            chkUseRegisteredNickname.Checked := False;
        end;
        populateServers();
        optBrowse.Checked := true;
        Tabs.ActivePage := tabSheet2;
        btnBack.Enabled := true;
        btnNext.Caption := _('Finish');

        _enableNext();

        // browse each server
        for i := 0 to txtServer.Items.Count - 1 do
            _fetch(txtServer.Items[i]);
        Show;
    end;
end;

{---------------------------------------}
procedure TfrmJoinRoom.populateServers();
var
    l: TWidestringlist;
    i: integer;
    tmp: TJabberID;
begin
    txtServer.Items.Clear();
    l := TWidestringlist.Create();
    jEntityCache.getByFeature(FEAT_GROUPCHAT, l);
    tmp := TJabberID.Create('');
    for i := 0 to l.Count - 1 do begin
        tmp.ParseJID(l[i]);
        if (tmp.user = '') then begin
            txtServer.Items.Add(l[i]);
            txtServerFilter.Items.Add(l[i]);
        end;
    end;
    tmp.Free();
    l.Free();
    txtServerFilter.ItemIndex := 0;
    _processFilter();
end;

{---------------------------------------}
procedure TfrmJoinRoom.FormCreate(Sender: TObject);
begin
    tabSheet1.TabVisible := false;
    tabSheet2.TabVisible := false;
    Tabs.ActivePage := tabSheet1;

    MainSession.Prefs.RestorePosition(Self);

    AssignUnicodeFont(Self);
    TranslateComponent(Self);

    _all := TList.Create();
    _filter := TList.Create();
    _cur := _all;
    _cur_sort := 0;
    _asc := true;
    _wait := TWidestringlist.Create();

    _cb := MainSession.RegisterCallback(EntityCallback, '/session/entity');
    _disconcb := MainSession.RegisterCallback(DisconCallback, '/session/disconnected');
    txtServerFilter.Items.Add(_('- ALL SERVERS -'));

    if (MainSession.Prefs.getBoolInProfile(MainSession.Profile.Name, 'tc_browse')) then
        optBrowse.Checked := true
    else
        optSpecify.Checked := true;
    chkDefaultConfig.Checked := MainSession.Prefs.getBoolInProfile(MainSession.Profile.Name, 'tc_default_config');
    chkUseRegisteredNickname.Checked := MainSession.Prefs.getBoolInProfile(MainSession.Profile.Name, 'tc_use_reg_nick');
    Image1.Picture.Icon.Handle := Application.Icon.Handle;
    Self.Icon.Handle := Application.Icon.Handle;

    optSpecifyClick(Self);
    _enableNext();
end;

{---------------------------------------}
procedure TfrmJoinRoom.FormDestroy(Sender: TObject);
begin
    if (MainSession <> nil) then begin
        MainSession.Prefs.SavePosition(Self);
        MainSession.UnRegisterCallback(_cb);
        MainSession.UnRegisterCallback(_disconcb);
    end;

    _all.Free();
    _filter.Free();
    _wait.Free();
end;

{---------------------------------------}
procedure TfrmJoinRoom.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
    Action := caFree;
end;

{---------------------------------------}
procedure TfrmJoinRoom.btnNextClick(Sender: TObject);
var
    i: integer;
    dconfig: boolean;
    pass: Widestring;
    rjid: Widestring;
    rmjid: TJabberID;
    li: TTntListItem;
    registered_nick: boolean;
begin
    if ((Tabs.ActivePage = tabSheet1) and (optBrowse.Checked)) then begin
        // change tabs if they selected browse
        Tabs.ActivePage := tabSheet2;
        btnBack.Enabled := true;
        btnNext.Caption := _('Finish');

        _enableNext();

       _all.Clear();
       _filter.Clear();

        // browse each server
        for i := 0 to txtServer.Items.Count - 1 do
            _fetch(txtServer.Items[i]);
        exit;
    end;

    // otherwise, just join..
    if (Tabs.ActivePage = tabSheet1) then begin
        rjid := txtRoom.Text + '@' + txtServer.Text;
        if (not isValidJid(rjid)) then begin
            MessageDlgW(_(sInvalidRoomJID), mtError, [mbOK], 0);
            exit;
        end;
    end
    else begin
        li := lstRooms.Selected;
        if (li = nil) then exit;
        rjid := li.Caption + '@' + li.SubItems[0];
    end;
    rmjid := TJabberID.Create(rjid, false);
    rjid := rmjid.jid();
    rmjid.Free();

    if (txtNick.Text = '') then begin
        MessageDlgW(_(sInvalidNick), mtError, [mbOK], 0);
        exit;
    end;

    pass := Trim(txtPassword.Text);
    dconfig := chkDefaultConfig.Checked;
    registered_nick := chkUseRegisteredNickname.Checked;
    StartRoom(rjid, txtNick.Text, pass, true, dconfig, registered_nick);

    with MainSession.Prefs do begin
        setStringInProfile(MainSession.Profile.Name, 'tc_lastroom', txtRoom.Text);
        setStringInProfile(MainSession.Profile.Name, 'tc_lastserver', txtServer.Text);
        setStringInProfile(MainSession.Profile.Name, 'tc_lastnick', txtNick.Text);
        setBoolInProfile(MainSession.Profile.Name, 'tc_browse', optBrowse.Checked);
        setBoolInProfile(MainSession.Profile.Name, 'tc_default_config', dconfig);
        setBoolInProfile(MainSession.Profile.Name, 'tc_use_reg_nick', registered_nick);
    end;
    Self.Close;
    exit;

end;

{---------------------------------------}
procedure TfrmJoinRoom._enableNext();
begin
    if (Tabs.ActivePage = tabSheet1) then begin
        if (optSpecify.Checked) then begin
            if ((Trim(txtRoom.Text) <> '') and
                (Trim(txtServer.Text) <> '') and
                (Trim(txtNick.Text) <> '')) then
                btnNext.Enabled := true
            else
                btnNext.Enabled := false;
        end
        else begin
            btnNext.Enabled := true;
        end;
    end
    else if (Tabs.ActivePage = tabSheet2) then begin
        if (lstRooms.SelCount > 0) then
            btnNext.Enabled := true
        else
            btnNext.Enabled := false;
    end;
end;

{---------------------------------------}
procedure TfrmJoinRoom.btnFetchClick(Sender: TObject);
var
    tj: TJabberID;
    i: Integer;
begin
    _all.Clear();
    _filter.Clear();
    if (txtServerFilter.Text = _('- ALL SERVERS -')) then
    begin
        for i := 0 to txtServer.Items.Count - 1 do
            _fetch(txtServer.Items[i]);
        exit;
    end;
    tj := TJabberID.Create(txtServerFilter.Text);
    if ((not tj.isValid) or (tj.user <> '') or (tj.resource <> '')) then begin
        tj.Free();
        MessageDlgW(_('You must enter a valid server name.'), mtError, [mbOK], 0);
        exit;
    end;
    _fetch(tj.Domain);
    tj.Free();
end;

{---------------------------------------}
procedure TfrmJoinRoom._addRoomJid(ce: TJabberEntity);
begin
    // make sure to not add dupes.
    if (_all.IndexOf(ce) = -1) then _all.Add(ce);
end;

{---------------------------------------}
procedure TfrmJoinRoom._fetch(jid: Widestring);
var
    Entity: TJabberEntity;
begin
    if (_wait.IndexOf(jid) >= 0) then exit;

    _wait.Append(jid);

    txtServerFilter.Enabled := false;
    btnFetch.Visible := false;
    aniWait.Visible := true;
    aniWait.Active := true;
    Entity :=  jEntityCache.getByJid(jid);
    if (Entity <> nil) then
       Entity.Refresh(MainSession);
end;

{---------------------------------------}
procedure TfrmJoinRoom._processFilter();
var
    ce: TJabberEntity;
    e, i: integer;
    f: Widestring;
begin
    // filter on the current dropdown..
    i := txtServerFilter.ItemIndex;

    if (i = 0) then
        _cur := _all
    else begin
        f := txtServerFilter.Text;
        _filter.Clear();
        for e := 0 to _all.Count - 1 do begin
            ce := TJabberEntity(_all[e]);
            if (ce.jid.domain = f) then
                _filter.Add(ce);
        end;
        _cur := _filter;
    end;

    if (_cur_sort = 0) then begin
        if (_asc) then
            _cur.Sort(EntityJidCompare)
        else
            _cur.Sort(EntityJidCompareRev);
    end
    else begin
        if (_asc) then
            _cur.Sort(EntityDomainCompare)
        else
            _cur.Sort(EntityDomainCompare);
    end;
    lstRooms.Items.Count := _cur.Count;
    lstRooms.Invalidate();
end;

{---------------------------------------}
procedure TfrmJoinRoom.EntityCallback(event: string; tag: TXMLTag);
var
    idx, i: integer;
    tmp: TJabberID;
    c, ce: TJabberEntity;
begin
    if ((event <> 'timeout') and
        (tag <> nil)) then begin
        tmp := TJabberID.Create(tag.getAttribute('from'));

        idx := _wait.IndexOf(tmp.full);
        if (idx < 0) then exit;

        // if this is /session/entity/items, AND, this jid supports MUC,
        // assume it's children are rooms.
        if (event = '/session/entity/items') then begin
            _wait.Delete(idx);
            ce := jEntityCache.getByJid(tmp.full);
            if (ce <> nil) then begin
                for i := 0 to ce.ItemCount - 1 do begin
                    c := ce.Items[i];
                    if (c.Jid.user <> '') then
                        _addRoomJid(c);
                end;

                if (_wait.Count = 0) then begin
                    aniWait.Active := false;
                    aniWait.Visible := false;
                    btnFetch.Visible := true;
                    txtServerFilter.Enabled := true;
                    _processFilter();
                end;
            end;
        end
        else begin
            // if this is #info, then just flesh out this item..
        end;

        tmp.Free();
    end;
end;

{---------------------------------------}
procedure TfrmJoinRoom.DisconCallback(event: string; tag: TXMLTag);
begin
    if (event = '/session/disconnected') then
        Self.Close();
end;

{---------------------------------------}
procedure TfrmJoinRoom.btnBackClick(Sender: TObject);
begin
    if (Tabs.ActivePage = tabSheet2) then begin
        Tabs.ActivePage := tabSheet1;
        btnNext.Caption := _('Next >');
        btnBack.Enabled := false;
        _enableNext();
    end;
end;

{---------------------------------------}
procedure TfrmJoinRoom.btnCancelClick(Sender: TObject);
begin
    Self.Close();
end;

{---------------------------------------}
procedure TfrmJoinRoom.optSpecifyClick(Sender: TObject);
begin
    txtServer.Enabled := optSpecify.Checked;
    txtRoom.Enabled := optSpecify.Checked;
    txtPassword.Enabled := optSpecify.Checked;

    if (optSpecify.Checked) then
        btnNext.Caption := _('Finish')
    else
        btnNext.Caption := _('Next >');
    _enableNext();
end;

{---------------------------------------}
procedure TfrmJoinRoom.txtServerFilterKeyPress(Sender: TObject;
  var Key: Char);
begin
  inherited;
    if (Key = Chr(13)) then begin
        jEntityCache.fetch(txtServerFilter.Text, MainSession, false);
        _processFilter();
        Key := Chr(0);
    end;
end;

{---------------------------------------}
procedure TfrmJoinRoom.lstRoomsChange(Sender: TObject; Item: TListItem;
  Change: TItemChange);
var
    li: TTntListItem;
begin
    _enableNext();
    li := lstRooms.Selected;
    if (li = nil) then exit;

    txtServer.Text := li.SubItems[0];
    txtRoom.Text := li.Caption;
end;

{---------------------------------------}
procedure TfrmJoinRoom.lstRoomsDblClick(Sender: TObject);
begin
    btnNextClick(Self);
end;

{---------------------------------------}
procedure TfrmJoinRoom.txtServerFilterSelect(Sender: TObject);
begin
    // Filter on this server.
    _processFilter();
end;

{---------------------------------------}
procedure TfrmJoinRoom.lstRoomsData(Sender: TObject; Item: TListItem);
var
    i: integer;
    ce: TJabberEntity;
begin
    // populate this item from the current list
    i := Item.Index;
    if ((i < 0) or (i >= _cur.Count)) then exit;

    ce := TJabberEntity(_cur[i]);
    Item.Caption := ce.Jid.userDisplay;
    Item.SubItems.Add(ce.jid.domain);
end;

{---------------------------------------}
procedure TfrmJoinRoom.lstRoomsColumnClick(Sender: TObject;
  Column: TListColumn);
begin
  inherited;
    if (Column.Index = 2) then exit;

    if (Column.Index = _cur_sort) then
        _asc := not _asc
    else begin
        _cur_sort := Column.Index;
        _asc := true;
    end;
    _processFilter();
end;

{---------------------------------------}
procedure TfrmJoinRoom.txtNickChange(Sender: TObject);
begin
  inherited;
    _enableNext();
end;

procedure TfrmJoinRoom.txtRoomChange(Sender: TObject);
begin
  inherited;
    _enableNext();
end;

procedure TfrmJoinRoom.txtServerChange(Sender: TObject);
begin
  inherited;
    _enableNext();
end;

//procedure TfrmJoinRoom.txtServerFilterChange(Sender: TObject);
//begin
//    btnFetch.Enabled := (txtServerFilter.ItemIndex <> 0);
//end;

{---------------------------------------}
procedure TfrmJoinRoom.lstRoomsDataFind(Sender: TObject; Find: TItemFind;
  const FindString: WideString; const FindPosition: TPoint;
  FindData: Pointer; StartIndex: Integer; Direction: TSearchDirection;
  Wrap: Boolean; var Index: Integer);
var
    ci: TJabberEntity;
    i: integer;
    f: boolean;
begin
    // incremental search for items..
    // shamelessly stolen from our JUD code :)
    i := StartIndex;

    if (Find = ifExactString) or (Find = ifPartialString) then begin
        repeat
            if (i = _cur.Count - 1) then begin
                if (Wrap) then i := 0 else exit;
            end;
            ci := TJabberEntity(_cur[i]);
            f := Pos(FindString, ci.Jid.user) > 0;
            inc(i);
        until (f or (i = StartIndex));
        if (f) then Index := i - 1;
    end;
end;

{---------------------------------------}
procedure TfrmJoinRoom.lstRoomsKeyPress(Sender: TObject; var Key: Char);
begin
    if (Key = Chr(13)) then btnNextClick(Self);

end;

end.
