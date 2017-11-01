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
unit Jud;

interface

uses
    IQ, XMLTag, Contnrs,
    Unicode, Windows, Messages,
    SysUtils, Variants, Classes,
    Graphics, Controls, Forms,
    Dialogs, DockWizard, ComCtrls,
    TntComCtrls, StdCtrls, TntStdCtrls,
    ExtCtrls, TntExtCtrls, Menus,
    Wizard, TntMenus, fXData,
    ToolWin, TntForms, ExFrame;

const
   WM_FIELDS_UPDATED = WM_USER + 6000;
   
type

  TJUDItem = class
  private
    _count: integer;
    procedure setCount(value: integer);
  public
    xdata: boolean;
    jid: string;
    cols: array of Widestring;
    property Count: integer read _count write setCount;
  end;

  TfrmJud = class(TfrmWizard)
    lblSelect: TTntLabel;
    cboJID: TTntComboBox;
    TabSheet2: TTabSheet;
    lblWait: TTntLabel;
    aniWait: TAnimate;
    TabFields: TTabSheet;
    lblInstructions: TTntLabel;
    TabSheet4: TTabSheet;
    Panel2: TPanel;
    Label3: TTntLabel;
    lstContacts: TTntListView;
    PopupMenu1: TTntPopupMenu;
    btnContacts: TButton;
    popChat: TTntMenuItem;
    N1: TTntMenuItem;
    popProfile: TTntMenuItem;
    popAdd: TTntMenuItem;
    lblCount: TTntLabel;
    TabXData: TTabSheet;
    xdataBox: TframeXData;
    btnChat: TButton;
    btnBroadcastMsg: TButton;
    lblGroup: TTntLabel;
    procedure lstContactsMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure btnBroadcastMsgClick(Sender: TObject);
    procedure OnChatClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnNextClick(Sender: TObject);
    procedure lstContactsContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: Boolean);
    procedure popAddClick(Sender: TObject);
    procedure Label1Click(Sender: TObject);
    procedure popProfileClick(Sender: TObject);
    procedure popChatClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure lstContactsColumnClick(Sender: TObject; Column: TListColumn);
    procedure lstContactsData(Sender: TObject; Item: TListItem);
    procedure lstContactsDataFind(Sender: TObject; Find: TItemFind;
      const FindString: String; const FindPosition: TPoint;
      FindData: Pointer; StartIndex: Integer; Direction: TSearchDirection;
      Wrap: Boolean; var Index: Integer);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnCancelClick(Sender: TObject);
    procedure btnBackClick(Sender: TObject);
    procedure FormResize(Sender: TObject);


    procedure TabSheet1Enter(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);

  protected
    procedure WMFieldsUpdated(var msg: TMessage); message WM_FIELDS_UPDATED;
    procedure NextEnabled();

  private
    { Private declarations }
    virtlist: TObjectList;

    cur_jid: string;
    cur_key: Widestring;
    cur_state: string;
    cur_iq: TJabberIQ;

    jid_col: integer;
    nick_col: integer;

    procedure getFields;
    procedure sendRequest();
    procedure clearFields();
    procedure reset();
    procedure FieldsCallback(event: string; tag: TXMLTag);
    procedure ItemsCallback(event: string; tag: TXMLTag);
    function convertDisplayToJID(displayJID: widestring): widestring;


  public
    { Public declarations }
  end;

var
  frmJud: TfrmJud;

const
    sJUDSearch = 'Search';
    sJUDStart = 'Start';
    sJUDStop = 'Stop';
    sJUDErrorContacting = 'Could not contact the search agent.';
    sJUDErrorSendMessage = 'You cannot send message to yourself';
    sJUDErrorChat = 'You cannot start chat with yourself';
    sJUDTimeout = 'The search timed out.';
    sJUDEmpty = 'No Results were found.';
    sJUDAdd = 'Add Contacts';
    sJUDCount = '%d items found.';


function StartSearch(sjid: string): TfrmJUD;
function ItemCompare(Item1, Item2: Pointer): integer;


implementation

uses
    XData, ChatWin,
//    MsgRecv,
    Entity, EntityCache, InputPassword,
    GnuGetText, JabberConst,
    Profile, JabberID,
    fGeneric, Session, JabberUtils,
    ExUtils,  XMLUtils, fTopLabel,
    TntClasses, DisplayName, Jabber1,
    RosterImages, Exodus_TLB, SndBroadcastDlg;

var
    cur_sort: integer;
    cur_dir: boolean;

{$R *.dfm}

{---------------------------------------}
function StartSearch(sjid: string): TfrmJUD;
var
    f: TfrmJUD;
    stringlist: TTntStrings;
    searchlist, gclist: TTntStrings;
    i: integer;
    j: TJabberID;
    function notCommonList(list1, list2: TTntStrings): TTntStrings;
    var
        i,j: integer;
        matchfound: boolean;
        retval: TTntStrings;
    begin
        retval := TTntStringList.Create();
        for i := 0 to list1.Count - 1 do begin
            matchfound := false;
            for j := 0 to list2.Count - 1 do begin
                if (list2.Strings[j] = list1.Strings[i]) then begin
                    // Found a match
                    matchfound := true;
                end;
            end;

            if (not matchfound) then begin
                retval.Add(list1.Strings[i]);
            end;
        end;
        Result := retval;
    end;
begin
    // Start a new search
    // create a new room
    f := TfrmJUD.Create(Application);

    // populate the drop down box based on our entity cache
    f.cboJID.Items.Clear();
    searchlist := TTntStringList.create();
    gclist := TTntStringList.create();
    jEntityCache.getByFeature(FEAT_SEARCH, searchlist);

    // makesure to not return gcs as part of our search
    jEntityCache.getByFeature(FEAT_GROUPCHAT, gclist);

    stringlist := notCommonList(searchlist, gclist);

    searchlist.Clear();
    searchlist.Free;
    gclist.Clear();
    gclist.Free();

    If (MainSession.Prefs.getBool('search_component_only')) then begin
        for i := 0 to stringlist.Count -1 do begin
            j := TJabberID.Create(stringlist[i]);
            if (j.user = '') then
                f.cboJID.Items.Add(stringlist[i]);
            j.Free();
        end;
    end
    else  f.cboJID.Items.AddStrings(stringlist);

    if ((f.cboJid.Items.Count > 0) and
        (f.cboJid.Items.Strings[0] <> '')) then begin
        f.Hint := f.cboJid.Items.Strings[0];
    end;

    f.reset();
    f.Show();

    // either get the fields right away,
    // or pre-select the first item
    if (sjid <> '') then begin
        f.cboJID.Text := sjid;
    end
    else if (f.cboJID.Items.Count > 0) then begin
        f.cboJID.ItemIndex := 0;
    end;
    Result := f;
end;

{---------------------------------------}
procedure TJUDItem.setCount(value: integer);
begin
    SetLength(cols, value + 1);
    _count := value;
end;

{---------------------------------------}
procedure TfrmJUD.FormCreate(Sender: TObject);
var
    dflt_grp: Widestring;
begin
  inherited;
    cur_jid := '';
    cur_key := '';
    cur_state := 'get_fields';
    cur_sort := -1;
    cur_dir := true;
  
    dflt_grp := MainSession.Prefs.getString('roster_default');

    virtlist := TObjectList.Create();
    virtlist.OwnsObjects := true;

    AssignDefaultFont(Self.Font);
    AssignDefaultFont(Tabs.Font);
    AssignDefaultFont(TabFields.Font);
    TabSheet1.TabVisible := false;
    TabSheet2.TabVisible := false;
    TabFields.TabVisible := false;
    TabSheet4.TabVisible := false;
    TabXData.TabVisible := false;
    Tabs.ActivePage := TabSheet1;
    btnContacts.Enabled := false;
    btnChat.Enabled := false;
    btnBroadcastMsg.Enabled := false;
    Image1.Picture.Icon.Handle := Application.Icon.Handle;
    lblGroup.Caption := dflt_grp;
end;


procedure TfrmJud.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  inherited;
  //Just need to send a message to ourseflves to check
  //if controls are empty after key down event is processed
  //by the control
  PostMessage(Self.Handle, WM_FIELDS_UPDATED, 0, 0);
end;

{---------------------------------------}
procedure TfrmJUD.getFields;
begin
    // get the fields to search on..
    // setup a fTopLabel frame for each field

    cur_state := 'fields';

    // make sure the lstView is clear
    lstContacts.Items.BeginUpdate();
    lstContacts.Items.Clear();
    lstContacts.Columns.Clear();
    lstContacts.Items.EndUpdate();

    // show the wait stuff
    clearFields();
    aniWait.Active := true;
    Tabs.ActivePage := TabSheet2;
    btnBack.Enabled := false;
    btnNext.Enabled := false;

    cur_jid := cboJID.Text;
    cur_iq := TJabberIQ.Create(MainSession, MainSession.generateID(), FieldsCallback);
    with cur_iq do begin
        iqType := 'get';
        Namespace := XMLNS_SEARCH;
        toJid := cur_jid;
        Send();
    end;
end;

{---------------------------------------}
procedure TfrmJUD.sendRequest();
var
    valid: boolean;
    x: TXMLTag;
begin
    // send the iq-set to the agent
    cur_jid := cboJID.Text;
    valid := true;

    // make sure we wait for a long time for really nasty queries and slow entities :)
    cur_iq := TJabberIQ.Create(MainSession, MainSession.generateID(), ItemsCallback, 120);
    with cur_iq do begin
        iqType := 'set';
        Namespace := XMLNS_SEARCH;
        toJid := cur_jid;

        if (cur_state = 'xsearch') then begin
            try
                x := xDataBox.Submit();
                cur_iq.qTag.AddTag(x);
                x.setAttribute('type', 'submit');
                cur_state := 'xitems';
            except
                on EXDataValidationError do begin
                    // XXX - Handle validation errors
                end;
            end;
        end
        else begin
            cur_state := 'items';
            PopulateTopFields(TabFields, cur_iq.qTag);
        end;
    end;

    if (valid) then begin
        btnBack.Enabled := false;
        btnNext.Enabled := false;
        aniWait.Active := true;
        Tabs.ActivePage := TabSheet2;
        cur_iq.Send();
    end;
end;


procedure TfrmJud.TabSheet1Enter(Sender: TObject);
begin
  inherited;
  btnNext.Enabled := true;
end;


procedure TfrmJud.WMFieldsUpdated(var msg: TMessage);
begin
  NextEnabled();
end;

procedure TfrmJud.NextEnabled();
var
 i, j: Integer;
 c: TControl;
 row: TXDataRow;
begin
  inherited;
  if ((Tabs.ActivePage = TabXData) or (Tabs.ActivePage = TabFields)) then begin
    btnNext.Enabled := false;
    //Iterate through all edit controls and see if any characters entered
    for i := 0 to Tabs.ActivePage.ControlCount - 1 do begin
      c := Tabs.ActivePage.Controls[i];
      if (c is TframeTopLabel) then begin
        if (Trim(TframeTopLabel(c).txtData.Text) <> '') then begin
          btnNext.Enabled := true;
          exit;
        end;
      end // If TframeTopLabel
      else begin
        if (c is TframeXData) then begin
          for j := 0 to TframeXData(c).Rows.Count - 1 do begin
            row := TXDataRow(TframeXData(c).Rows[j]);
            if (row.con is TTntEdit) then begin
              if (Trim(TTntEdit(row.con).Text) <> '') then begin
                btnNext.Enabled := true;
                exit;
              end;
            end; //if TTntEdit
          end;  // end for loop for rows
        end; // if TFrameXData
      end; //els TframeTopLable
    end; // End for loop
  end; //Active page
end;



{---------------------------------------}
procedure TfrmJUD.FieldsCallback(event: string; tag: TXMLTag);
var
    fields: TXMLTagList;
    x: TXMLTag;
begin
    // callback when we get the fields back
    cur_state := 'search';
    cur_iq := nil;
    aniWait.Active := false;
    btnBack.Enabled := true;
    btnNext.Enabled := true;

    if (event <> 'xml') then begin
        // timeout
        MessageDlgW(_(sJUDErrorContacting), mtError, [mbOK], 0);
        self.reset();
        exit;
    end
    else if ((tag <> nil) and (tag.GetAttribute('type') = 'error')) then begin
        // we got an iq-error back
        MessageDlgW(_(sJUDErrorContacting), mtError, [mbOK], 0);
        Self.Reset();
        exit;
    end
    else if (tag <> nil) then begin
        // *whoop*, we got a result tag
        // Check for x-data support
        x := tag.QueryXPTag('/iq/query/x[@xmlns="jabber:x:data"]');
        if (x <> nil) then begin
            cur_state := 'xsearch';
            xDataBox.Render(x);
            Tabs.ActivePage := TabXData;
            xDataBox.SetFocus();
        end
        else begin
            fields := tag.QueryXPTag('/iq/query').ChildTags();
            RenderTopFields(TabFields, fields, cur_key);
            fields.Free();
            Tabs.ActivePage := TabFields;
        end;
    end;
    
end;

{---------------------------------------}
procedure TfrmJUD.ItemsCallback(event: string; tag: TXMLTag);
var
    cidx, i,c: integer;
    items, cols: TXMLTagList;
    cur: TXMLTag;
    col: TListColumn;
    ji: TJUDItem;
    fld, jid_fld: Widestring;
    tmp: TJabberID;
    clist: TWideStringList;
    tmps: Widestring;
begin
    // callback when we get our search results back
    cur_iq := nil;
    clist := nil;
    aniWait.Active := false;
    cboJID.Enabled := true;
    btnBack.Enabled := true;
    btnNext.Enabled := true;

    if (event <> 'xml') then begin
        // timeout
        cur_state := 'get_fields';
        MessageDlgW(_(sJUDTimeout), mtError, [mbOK], 0);
        self.reset();
        exit;
    end
    else begin
        // tag
        {
        <iq from='users.jabber.org' id='jcl_6' to='pgm-foo@jabber.org/Exodus' type='result'>
        <query xmlns='jabber:iq:search'>
        <item jid='clever@jabber.org'>
            <nick>Clever</nick>
            <first>Hennie</first>
            <email>clever@jabber.com</email>
            <last/>
        </item></query></iq>
        }

        // get all the returned items
        items := nil;
        if (cur_state = 'items') then
            items := tag.QueryXPTags('/iq/query/item');

        if ((items = nil) or (items.Count = 0)) then
            items := tag.QueryXPTags('//x[@xmlns="jabber:x:data"]/item');

        if ((items = nil) or (items.Count = 0)) then begin
            items.Free();
            cur_state := 'get_fields';
            lstContacts.Clear();
            MessageDlgW(_(sJUDEmpty), mtInformation, [mbOK], 0);
            reset();
            exit;
        end;

        lstContacts.AllocBy := 25;
        lstContacts.Items.Clear;
        virtlist.Clear();

        lstContacts.Columns.Clear();

        // setup the columns for items (no x-data)
        if (cur_state = 'items') then begin
            // use the first item in the list

            // This is an UGLY UGLY hack for really crappy
            // JUD components which return guineauo like:
            // <item jid="foo"><remove/></item>
            cols := nil;
            i := 0;
            repeat
                if (cols <> nil) then cols.Free();
                cur := items[i];
                cols := cur.ChildTags();
                inc(i);
            until ((cols.Count > 1) or (cols[0].Name = 'remove'));

            with lstContacts.Columns.Add() do begin
                // add a JID column by default
                Caption := sJID;
                Width := 100;
                jid_col := 0;
            end;

            nick_col := -1;
            for i := 0 to cols.count - 1 do begin
                col := lstContacts.Columns.Add();
                col.Caption := getDisplayField(cols[i].Name);
                if ((nick_col = -1) and
                    ((Lowercase(cols[i].name) = 'nickname') or
                     (Lowercase(cols[i].name) = 'nick'))) then
                    nick_col := i;
                col.Width := 100;
            end;

            cols.Free();
        end
        else begin
            // reported columns for x-data, setup columns
            cols := tag.QueryXPTags('//x[@xmlns="jabber:x:data"]/reported/field');
            clist := TWidestringList.Create();
            if (cols <> nil) then begin
                for i := 0 to cols.Count - 1 do begin
                    with lstContacts.Columns.Add() do begin
                        Caption := cols[i].GetAttribute('label');
                        fld := cols[i].getAttribute('var');
                        Width := 100;
                        tmps := cols[i].getAttribute('type');
                        if ((tmps = 'jid') or (tmps = 'jid-single')) then begin
                            jid_col := i;
                            jid_fld := fld;
                        end
                        else if ((fld = 'nick') or (fld = 'nickname')) then
                            nick_col := i;
                    end;
                    clist.Add(cols[i].GetAttribute('var'));
                end;
                cols.Free();
            end;
        end;

        // populate the listview.
        if (cur_state = 'items') then begin
            for i := 0 to items.count - 1 do begin
                cur := items[i];
                ji := TJUDItem.Create();
                ji.xdata := false;
                cols := cur.ChildTags();
                tmp := TJabberID.Create(cur.GetAttribute('jid'));
                ji.jid := tmp.getDisplayJID();
                tmp.Free();
                ji.count := lstContacts.Columns.Count + 1;
                for c := 0 to cols.count - 1 do
                    ji.cols[c + 1] := cols[c].Data;
                cols.Free();
                virtlist.Add(ji);
            end;
            cur_state := 'add';
        end

        else begin // xitems
            for i := 0 to items.count - 1 do begin
                cur := items[i];
                ji := TJUDItem.Create();
                ji.xdata := true;
                cols := cur.QueryTags('field');
                ji.count := cols.Count;
                for c := 0 to cols.count - 1 do begin
                    tmps := cols[c].getAttribute('var');
                    cidx := clist.indexOf(tmps);
                    if (cidx > -1) then begin
                        if (tmps = jid_fld) then begin
                            tmp := TJabberID.Create(cols[c].GetBasicText('value'));
                            ji.cols[cidx] := tmp.getDisplayJID();
                            ji.jid := tmp.jid;
                            tmp.Free();
                        end
                        else
                            ji.cols[cidx] := cols[c].GetBasicText('value');
                    end;
                end;
                cols.Free();
                virtlist.Add(ji);
            end;
            cur_state := 'xadd';
        end;

        lblCount.Caption := WideFormat(_(sJUDCount), [virtlist.count]);
        lstContacts.Items.Count := virtlist.Count;

        if (clist <> nil) then clist.Free();
        if (items <> nil) then Items.Free();

        aniWait.Active := false;
        Tabs.ActivePage := TabSheet4;
    end;
end;

{---------------------------------------}
procedure TfrmJUD.btnCloseClick(Sender: TObject);
begin
  inherited;
    Self.Close;
end;

{---------------------------------------}
procedure TfrmJUD.clearFields();
var
    c: TControl;
begin
    // clear all frames from the pnlFields panel
    while (TabFields.ControlCount > 0) do begin
        c := TabFields.Controls[0];
        c.Free();
    end;
end;

{---------------------------------------}
procedure TfrmJUD.btnNextClick(Sender: TObject);
begin
  inherited;
    {
    states go (for non-xdata):
    init -> get_fields -> fields -> search -> items
    or (for x-data):
    init -> get_fields -> fields -> xsearch -> xitems
    }
    btnBack.Enabled := true;
    if (cur_state = 'get_fields') then begin
        // get the fields for this agent
        getFields();
    end

    else if ((cur_state = 'search') or (cur_state = 'xsearch')) then begin
        // fire off the iq-set to do the actual search
        sendRequest();
    end

    else if ((cur_state = 'add') or (cur_state = 'xadd')) then begin
        // loop back and search again
        reset();
    end

    else begin
    end;
    btnContacts.Enabled := false;
    btnChat.Enabled := false;
    btnBroadcastMsg.Enabled := false;
    if (cboJid.SelText <> '') then begin
        Hint := cboJid.SelText;
    end;
end;

{---------------------------------------}
procedure TfrmJUD.reset();
begin
    // reset the GUI
    aniWait.Active := false;
    cur_state := 'get_fields';
    cur_sort := -1;
    cur_dir := true;
    cboJID.Enabled := true;
    clearFields();
    Tabs.ActivePage := TabSheet1;
    btnBack.Enabled := false;
end;

{---------------------------------------}
procedure TfrmJUD.lstContactsContextPopup(Sender: TObject;
  MousePos: TPoint; var Handled: Boolean);
var
    multi: boolean;
begin
  inherited;
    multi := (lstContacts.SelCount > 1);
    if multi then
        popAdd.Caption := _(sJUDAdd)
    else
        popAdd.Caption := _(sJUDAdd);

    popProfile.Enabled := not multi;
    popChat.Enabled := not multi;
end;

{---------------------------------------}
procedure TfrmJUD.popAddClick(Sender: TObject);
var
    i: integer;

    procedure doAdd(item: TListItem);
    var
        nick: Widestring;
        ExItem: IExodusItem;
        jid: TJabberID;
        dflt_grp: WideString;
    begin
        dflt_grp := MainSession.Prefs.getString('roster_default');
        // do the actual add stuff
        jid := TJabberID.Create(item.caption, false); // item may be escaped
        ExItem := MainSession.ItemController.GetItem(jid.jid);
        if (ExItem <> nil) then begin
            if ((ExItem.Value['Subscription'] = 'to') or (ExItem.Value['Subscription'] = 'both')) then
                exit;
        end;

        // add the item
        nick := '';
        if (nick_col >= 0) then
            nick := item.SubItems[nick_col];

        if (nick = '') then nick := DisplayName.getDisplayNameCache().getDisplayName(jid);
        MainSession.Roster.AddItem(jid.jid, nick, dflt_grp, true);
        jid.Free();
        
    end;

begin
  inherited;
    // add selected contacts
    if (lstContacts.SelCount = 1) then
        // only a single user
        doAdd(lstContacts.Selected)
    else begin
        for i := 0 to lstContacts.Items.Count - 1 do begin
            if lstContacts.Items[i].Selected then
                doAdd(lstContacts.Items[i]);
        end;
    end;
end;

{---------------------------------------}
procedure TfrmJUD.Label1Click(Sender: TObject);
begin
  inherited;
    // search again...
    with lstContacts do begin
        Items.BeginUpdate;
        Items.Clear;
        Items.EndUpdate;
    end;

    self.reset();
end;


{---------------------------------------}
function TfrmJUD.convertDisplayToJID(displayJID: widestring): widestring;
var
    jid: TJabberID;
begin
    Result := displayJID;
    jid := TJabberID.Create(displayJID, false);
    Result := jid.jid();
    jid.Free();
end;

{---------------------------------------}
procedure TfrmJUD.popProfileClick(Sender: TObject);
begin
  inherited;
    // view the profile for the user
    ShowProfile(convertDisplayToJID(lstContacts.Selected.Caption));
end;

{---------------------------------------}
procedure TfrmJUD.popChatClick(Sender: TObject);
begin
  inherited;
    // Chat with this person
    StartChat(convertDisplayToJID(lstContacts.Selected.Caption), '', true);
end;

{---------------------------------------}
procedure TfrmJUD.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  inherited;
    if (cur_iq <> nil) then begin
        cur_iq.Free();
        cur_iq := nil;
    end;
end;

{---------------------------------------}
procedure TfrmJUD.lstContactsColumnClick(Sender: TObject;
  Column: TListColumn);
begin
  inherited;
  if (Column.Index = cur_sort) then
    cur_dir := not cur_dir
  else
    cur_dir := true;

  cur_sort := Column.Index;

  // lstContacts.SortType := stText;
  // lstContacts.AlphaSort();

  virtlist.Sort(ItemCompare);
  lstContacts.Refresh;
end;

function ItemCompare(Item1, Item2: Pointer): integer;
var
    j1, j2: TJUDItem;
    s1, s2: string;
begin
    // compare 2 items..
    if (cur_sort = -1) then begin
        Result := 0;
        exit;
    end;

    j1 := TJUDItem(Item1);
    j2 := TJUDItem(Item2);

    if (cur_sort = 0) then begin
        if (cur_dir) then begin
            s1 := j1.jid;
            s2 := j2.jid;
        end
        else begin
            s1 := j2.jid;
            s2 := j1.jid;
        end;
    end
    else begin
        if (cur_dir) then begin
            s1 := j1.cols[cur_sort];
            s2 := j2.cols[cur_sort];
        end
        else begin
            s1 := j2.cols[cur_sort];
            s2 := j1.cols[cur_sort];
        end;
    end;

    Result := StrComp(PChar(LowerCase(s1)),
                      PChar(LowerCase(s2)));
end;

{---------------------------------------}
procedure TfrmJUD.lstContactsData(Sender: TObject; Item: TListItem);
var
    i: integer;
    ji: TJUDItem;
    ti: TTntListItem;
begin
  inherited;
    if (Item.Index < 0) then exit;
    if (Item.Index >= virtlist.Count) then exit;

    ti := TTntListItem(Item);
    ji := TJUDItem(virtlist[Item.Index]);
    if ji <> nil then begin
        if (ji.xdata) then
            ti.Caption := ji.cols[0]
        else
            ti.Caption := ji.jid;
        ti.SubItems.Clear();
        for i := 1 to ji.count do
            ti.SubItems.Add(ji.cols[i]);
    end;
end;

{---------------------------------------}
procedure TfrmJUD.lstContactsDataFind(Sender: TObject; Find: TItemFind;
  const FindString: String; const FindPosition: TPoint; FindData: Pointer;
  StartIndex: Integer; Direction: TSearchDirection; Wrap: Boolean;
  var Index: Integer);
var
    ji: TJUDItem;
    i: integer;
    f: boolean;
begin
  inherited;
    // OnDataFind gets called in response to calls to FindCaption, FindData,
    // GetNearestItem, etc. It also gets called for each keystroke sent to the
    // ListView (for incremental searching)

    i := StartIndex;

    if (Find = ifExactString) or (Find = ifPartialString) then begin
        repeat
            if (i = virtlist.Count - 1) then begin
                if Wrap then i := 0 else exit;
            end;
            ji := TJUDItem(virtlist[i]);
            f := Pos(FindString, ji.jid) > 0;
            inc(i);
        until (f or (i = StartIndex));
        if (f) then Index := i - 1;
    end;
end;

procedure TfrmJud.lstContactsMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  inherited;
     if (lstContacts.Selected <> nil) then begin
         btnContacts.Enabled := true;
         btnChat.Enabled := true;
         btnBroadcastMsg.Enabled := true;
     end
     else begin
         btnContacts.Enabled := false;
         btnChat.Enabled := false;
         btnBroadcastMsg.Enabled := false;
     end;
end;


procedure TfrmJud.OnChatClick(Sender: TObject);
var
  i: integer;
begin
 inherited;
 if (lstContacts.SelCount > 0) then begin
     for i := 0 to lstContacts.Items.Count - 1 do begin
       if lstContacts.Items[i].Selected then begin
          if lstContacts.Items[i].Caption = MainSession.BareJid then begin
             //Can't chat with yourself
             MessageDlgW(_(sJUDErrorChat), mtError, [mbOK], 0);
             continue
          end;
          StartChat(convertDisplayToJID(lstContacts.Items[i].Caption), '', true)
       end;
     end;
 end;
end;

{---------------------------------------}
procedure TfrmJUD.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;
    virtlist.Free();
    Action := caFree;
end;


{---------------------------------------}
procedure TfrmJud.btnBroadcastMsgClick(Sender: TObject);
var
  i: integer;
  jidList: TWideStringList;
begin
 inherited;
 // Only process if contacts selected
 if (lstContacts.SelCount > 0) then begin
     // Construct the list
     jidList := TWideStringlist.Create();
     for i := 0 to lstContacts.Items.Count - 1 do begin
       if lstContacts.Items[i].Selected then begin
          if lstContacts.Items[i].Caption = MainSession.BareJid then begin
             //Add code to display message
             MessageDlgW(_(sJUDErrorSendMessage), mtError, [mbOK], 0);
             continue
          end
          else
             jidList.Add(convertDisplayToJID(lstContacts.Items[i].Caption))
       end;
     end;
     //Broadcast message and cleanup
     ShowSendBroadcast(jidList, '', '');
     jidList.Free();
 end;
end;


procedure TfrmJUD.btnCancelClick(Sender: TObject);
begin
  inherited;
    if ((cur_state = 'fields') or
        (cur_state = 'items') or
        (cur_state = 'xitems')) then begin
        // stop waiting for the fields, or results
        cur_iq.Free();
        cur_iq := nil;
        self.reset();
    end;
    Self.Close();
end;

{---------------------------------------}
procedure TfrmJUD.btnBackClick(Sender: TObject);
begin
  inherited;
    {
    states go (for non-xdata):
    init -> get_fields -> fields -> search -> items
    or (for x-data):
    init -> get_fields -> fields -> xsearch -> xitems
    }
    if (cur_state = 'search') or (cur_state = 'xsearch') then begin
        cur_state := 'get_fields';
        Tabs.ActivePage := TabSheet1;
        btnBack.Enabled := false;
    end
    else if (cur_state = 'add') then begin
        cur_state := 'search';
        Tabs.ActivePage := TabFields;
    end
    else if (cur_state = 'xadd') then begin
        cur_state := 'xsearch';
        Tabs.ActivePage := TabFields;
    end;
end;

{---------------------------------------}
procedure TfrmJUD.FormResize(Sender: TObject);
begin
    if (Tabs.ActivePage = TabSheet4) then
        lblCount.Left := Self.ClientWidth - lblCount.Width - 8;
end;

end.
