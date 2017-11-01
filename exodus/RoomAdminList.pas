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
unit RoomAdminList;

interface

uses
    XMLTag, IQ, Unicode, SelectItem, SelRoomOccupant,  
    Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
    Dialogs, buttonFrame, StdCtrls, ExtCtrls, CheckLst, ComCtrls,
    TntComCtrls, TntStdCtrls, ExForm, TntForms, ExFrame;

type
  TfrmRoomAdminList = class(TExForm)
    frameButtons1: TframeButtons;
    lstItems: TTntListView;
    Panel2: TPanel;
    btnRemove: TTntButton;
    TntButton1: TTntButton;
    procedure frameButtons1btnOKClick(Sender: TObject);
    procedure frameButtons1btnCancelClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnAddClick(Sender: TObject);
    procedure lstItemsDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure lstItemsDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure btnRemoveClick(Sender: TObject);
    procedure lstItemsEdited(Sender: TObject; Item: TTntListItem;
      var S: WideString);
  published
    procedure listAdminCallback(event: string; tag: TXMLTag);
  private
    { Private declarations }
    _iq: TJabberIQ;
    _adds: TWidestringlist;
    _dels: TWidestringlist;
    _occupant_selector: TfrmSelRoomOccupant;
    _rlist: TList;

    room_jid: Widestring;
    role: bool;
    onList: Widestring;
    offList: Widestring;

    procedure AddJid(j, n: Widestring);
    procedure AddNick(n: Widestring);
  public
    { Public declarations }

    procedure Start();
    procedure SetList(rlist: TWideStringList);
  end;

var
  frmRoomAdminList: TfrmRoomAdminList;

procedure ShowRoomAdminList(room_win: TForm; room_jid, role, affiliation: WideString;
    caption: WideString = ''; rlist: TWideStringList = nil);

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
implementation

uses
    JabberUtils, ExUtils,  GnuGetText, JabberConst, JabberID, Session, Room,
    RosterForm, Exodus_TLB;

{$R *.dfm}

{---------------------------------------}
procedure ShowRoomAdminList(room_win: TForm; room_jid, role, affiliation: WideString;
    caption: Widestring = ''; rlist: TWideStringList = nil);
var
    f: TfrmRoomAdminList;
begin
    // Fire up a new form, and dispatch call Start()
    f := TfrmRoomAdminList.Create(Application);
    f.room_jid := room_jid;
    if (role <> '') then begin
        f.role := true;
        f.onList := role;
        if (role = MUC_PART) then
            f.offList := MUC_VISITOR
        else if (role = MUC_MOD) then
            f.offList := MUC_PART
        else
            f.offList := MUC_NONE;
    end
    else begin
        f.role := false;
        f.onList := affiliation;
        f.offList := MUC_NONE;
    end;

    if (caption <> '') then
        f.Caption := caption;

    f.SetList(rlist);
        
    f.Start();
end;

{---------------------------------------}
procedure TfrmRoomAdminList.SetList(rlist: TWideStringList);
var
    i: integer;
    rm: TRoomMember;
begin
    if (rlist <> nil) then begin
        _rlist := TList.Create();
        for i := 0 to rlist.Count - 1 do begin
            rm := TRoomMember.Create();
            rm.jid := TRoomMember(rlist.Objects[i]).jid;
            rm.Nick := TRoomMember(rlist.Objects[i]).Nick;
            rm.Node := TRoomMember(rlist.Objects[i]).Node;
            rm.status := TRoomMember(rlist.Objects[i]).status;
            rm.show := TRoomMember(rlist.Objects[i]).show;
            rm.blocked := TRoomMember(rlist.Objects[i]).blocked;
            rm.role := TRoomMember(rlist.Objects[i]).role;
            rm.affil := TRoomMember(rlist.Objects[i]).affil;
            rm.real_jid := TRoomMember(rlist.Objects[i]).real_jid;
            _rlist.Add(rm);
        end;
    end
    else
        _rlist := nil;
end;

{---------------------------------------}
procedure TfrmRoomAdminList.Start();
var
    item: TXMLTag;
begin
    // Get the list to be edited
    _iq := TJabberIQ.Create(MainSession, MainSession.generateID(),
        listAdminCallback, 30);
    with _iq do begin
        toJid := room_jid;
        if ((onList = MUC_ADMIN) or (onList = MUC_OWNER)) then
            Namespace := XMLNS_MUCOWNER
        else
            Namespace := XMLNS_MUCADMIN;
        iqType := 'get';
    end;

    item := _iq.qTag.AddTag('item');
    if (role) then
        item.setAttribute('role', onList)
    else
        item.setAttribute('affiliation', onList);
    _iq.Send();

    if (role) then begin
        lstItems.Columns.Delete(1);
        lstItems.Column[0].Width := lstItems.Width - 5;
    end;

    if (onList = MUC_OUTCAST) then begin
        lstItems.Columns.Delete(0);
        lstItems.Column[0].Width := lstItems.Width - 5;
    end;

    Show();
end;

{---------------------------------------}
procedure TfrmRoomAdminList.listAdminCallback(event: string; tag: TXMLTag);
var
    li: TTntListItem;
    i: integer;
    rjid: WideString;
    items: TXMLTagList;
    itemJID: TJabberID;
begin
    // callback for list administration
    _iq := nil;
    if event <> 'xml' then exit;
    if tag = nil then exit;

    if ((tag.Name <> 'iq') or
        (tag.getAttribute('type') = 'error')) then begin
        MessageDlgW(_('There was an error fetching this conference room list.'),
            mtError, [mbOK], 0);
        Self.Close;
        exit;
    end;

    rjid := tag.GetAttribute('from');
    items := tag.QueryXPTags('/iq/query/item');

    room_jid := rjid;

    if (items.Count > 0) then begin
        for i := 0 to items.Count - 1 do begin
            itemJID := TJabberID.Create(items[i].GetAttribute('jid'));
            li := TTntListItem(lstItems.Items.Add());
            if (onList = MUC_OUTCAST) then begin
                li.Caption := itemJID.getDisplayFull();
            end
            else begin
                li.Caption := items[i].GetAttribute('nick');
                li.SubItems.Add(itemJID.getDisplayFull());
            end;
            li.Checked := true;
            itemJID.Free();
        end;
    end;

    items.Free();
end;


{---------------------------------------}
procedure TfrmRoomAdminList.frameButtons1btnOKClick(Sender: TObject);
var
    i: integer;
    item, q, iq: TXMLTag;
    li: TTntListItem;
    nick: TWideStrings;
begin
    // check for no changes
    if ((_adds.Count = 0) and (_dels.Count = 0)) then begin
        Self.Close();
        exit;
    end;

    // submit the new list
    iq := TXMLTag.Create('iq');
    iq.setAttribute('to', room_jid);
    iq.setAttribute('id', MainSession.generateID());
    iq.setAttribute('type', 'set');
    q := iq.AddTag('query');
    if ((onList = MUC_ADMIN) or (onList = MUC_OWNER)) then
        q.setAttribute('xmlns', XMLNS_MUCOWNER)
    else
        q.setAttribute('xmlns', XMLNS_MUCADMIN);

    // Take all the "dels" off the list
    for i := 0 to _dels.Count - 1 do begin
        item := q.AddTag('item');
        if (not role) then
            item.setAttribute('jid', _dels[i])
        else begin
            nick := TWideStrings(_dels.Objects[i]);
            item.SetAttribute('nick', nick[0]);
        end;
        if (role) then
            item.setAttribute('role', offList)
        else
            item.setAttribute('affiliation', offList);
    end;

    // Put all the "adds" on the list
    for i := 0 to _adds.Count - 1 do begin
        item := q.AddTag('item');
        if (not role) then        
            item.setAttribute('jid', _adds[i]);
        li := TTntListItem(_adds.Objects[i]);
        if (li.Caption <> '') then
            item.SetAttribute('nick', li.Caption);
        if (role) then
            item.setAttribute('role', onList)
        else
            item.setAttribute('affiliation', onList);
    end;

    MainSession.SendTag(iq);
    Self.Close();
end;

{---------------------------------------}
procedure TfrmRoomAdminList.frameButtons1btnCancelClick(Sender: TObject);
begin
    Self.Close();
end;

{---------------------------------------}
procedure TfrmRoomAdminList.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
    MainSession.Prefs.SavePosition(Self);
    Action := caFree;
end;

{---------------------------------------}
procedure TfrmRoomAdminList.FormCreate(Sender: TObject);
begin
    AssignUnicodeFont(Self);
    TranslateComponent(Self);
    _iq := nil;
    _adds := TWidestringlist.Create();
    _dels := TWidestringlist.Create();
    _rlist := nil;

    MainSession.Prefs.RestorePosition(Self);
end;

{---------------------------------------}
procedure TfrmRoomAdminList.FormDestroy(Sender: TObject);
var
    i: integer;
begin
    if (_iq <> nil) then FreeAndNil(_iq);
    FreeAndNil(_adds);
    FreeAndNil(_dels);

    if (_rlist <> nil) then begin
        for i := 0 to _rlist.Count - 1 do
            TRoomMember(_rlist.Items[i]).Free;

        _rlist.Clear;
        _rlist.Free;
    end;
end;

{---------------------------------------}
procedure TfrmRoomAdminList.btnAddClick(Sender: TObject);
var
    j: Widestring;
    item: IExodusItem;
begin
    // Add a JID
    if (role) then begin
        // Select by Nick
        _occupant_selector := TfrmSelRoomOccupant.Create(nil);
        _occupant_selector.SetList(_rlist);
        if (_occupant_selector.ShowModal = mrOK) then begin
            j := _occupant_selector.GetSelectedNick();
            AddNick(j);
        end;
        _occupant_selector.Free();
    end
    else begin
        // Select by JID
        j := SelectUIDByType('contact');
        if (j <> '') then begin
            item := MainSession.ItemController.GetItem(j);
            if (item <> nil) and (item.Type_ = 'contact') then
                AddJid(j, item.value['Name'])
            else
                AddJid(j, '');
        end;
    end;
end;

{---------------------------------------}
procedure TfrmRoomAdminList.AddJid(j,n: Widestring);
var
    tmp_jid: TJabberID;
    li: TTntListItem;
begin
    tmp_jid := TJabberID.Create(j);
    if (not tmp_jid.isValid) then begin
        tmp_jid.Free();
        MessageDlgW(_('The Jabber ID you entered is invalid.'), mtError, [mbOK], 0);
        exit;
    end;

    li := TTntListItem(lstItems.Items.Add());
    li.Caption := n;
    li.SubItems.Add(tmp_jid.getDisplayFull());
    li.Checked := true;
    _adds.AddObject(tmp_jid.full, li);

    tmp_jid.Free();
end;

{---------------------------------------}
procedure TfrmRoomAdminList.AddNick(n: Widestring);
var
    li: TTntListItem;
begin
    li := TTntListItem(lstItems.Items.Add());
    li.Caption := n;
    li.Checked := true;
    _adds.AddObject(n, li);
end;

{---------------------------------------}
procedure TfrmRoomAdminList.lstItemsDragOver(Sender, Source: TObject; X,
  Y: Integer; State: TDragState; var Accept: Boolean);
begin
    // Accept roster items
    Accept := (Source = frmRoster.RosterTree);
end;

{---------------------------------------}
procedure TfrmRoomAdminList.lstItemsDragDrop(Sender, Source: TObject; X,
  Y: Integer);
//var
//    tree: TTreeView;
//    n: TTreeNode;
//    i,j: integer;
//    ritem: TJabberRosterItem;
//    gitems: TList;
//    grp: TJabberGroup;
begin
{ TODO : Roster refactor }
//    // dropping from main roster window
//    tree := TTreeView(Source);
//    with tree do begin
//        for i := 0 to SelectionCount - 1 do begin
//            n := Selections[i];
//            if ((n.Data <> nil) and (TObject(n.Data) is TJabberRosterItem)) then begin
//                // We have a roster item
//                ritem := TJabberRosterItem(n.Data);
//                AddJid(ritem.jid.jid, ritem.Text);
//            end
//            else if ((n.Data <> nil) and (TObject(n.Data) is TJabberGroup)) then begin
//                // We have a roster grp
//                grp := TJabberGroup(n.Data);
//                gitems := MainSession.roster.getGroupItems(grp.FullName, false);
//                for j := 0 to gitems.count - 1 do begin
//                    ritem := TJabberRosterItem(gitems[j]);
//                    AddJid(ritem.Jid.jid, ritem.Text);
//                end;
//            end;
//        end;
//    end;
end;

{---------------------------------------}
procedure TfrmRoomAdminList.btnRemoveClick(Sender: TObject);
var
    j: Widestring;
    idx, i: integer;
    itemJID: TJabberID;
    itemlbl: Widestring;
    nick: TWideStrings;
begin
    // Remove these folks from the list
    if (role) then begin
        for i := lstItems.Items.Count - 1 downto 0 do begin
            if (lstItems.Items[i].Selected) then begin
                itemlbl := lstItems.Items[i].Caption;
                idx := _adds.IndexOf(itemlbl);
                if (idx >= 0) then
                    _adds.Delete(idx)
                else begin
                    nick := TWideStringList.Create();
                    nick.Add(lstItems.Items[i].Caption);
                    _dels.AddObject(itemlbl, nick);
                end;

                lstItems.Items.Delete(i);
            end;
        end;
    end
    else begin
        for i := lstItems.Items.Count - 1 downto 0 do begin
            if (lstItems.Items[i].Selected) then begin
                if (onList = MUC_OUTCAST) then
                    itemJID := TJabberID.Create(lstItems.Items[i].Caption, false)
                else
                    itemJID := TJabberID.Create(lstItems.Items[i].SubItems[0], false);
                j := itemJID.full();
                idx := _adds.IndexOf(j);
                if (idx >= 0) then
                    _adds.Delete(idx)
                else begin
                    nick := TWideStringList.Create();
                    nick.Add(lstItems.Items[i].Caption);
                    _dels.AddObject(j, nick);
                end;

                lstItems.Items.Delete(i);
            end;
        end;
    end;
end;

procedure TfrmRoomAdminList.lstItemsEdited(Sender: TObject;
  Item: TTntListItem; var S: WideString);
begin
    // after an item is edited, put them on the add list,
    // so we send in their updated nick
    _adds.AddObject(Item.Caption, Item)
end;

end.
