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
unit Invite;


interface

uses
    Unicode, XMLTag, Windows, Messages, SysUtils, Variants, Classes,
    Graphics, Controls, Forms,
    Dialogs, StdCtrls, CheckLst, ExtCtrls, buttonFrame, ComCtrls, Grids,
  TntStdCtrls, TntComCtrls, JabberID, ExForm, TntForms, ExFrame,
  ExActions, ExActionCtrl, Exodus_TLB;

type
  TInviteToRoomAction = class(TExBaseAction)
  private
    constructor Create;
  public
    function Get_Enabled: WordBool; override;
    procedure execute(const items: IExodusItemList); override;
  end;
  
  TfrmInvite = class(TExForm)
    frameButtons1: TframeButtons;
    pnlMain: TPanel;
    lstJIDS: TTntListView;
    Splitter1: TSplitter;
    Panel1: TPanel;
    btnRemove: TTntButton;
    Panel2: TPanel;
    memReason: TTntMemo;
    Label2: TTntLabel;
    pnl1: TPanel;
    cboRoom: TTntComboBox;
    Label1: TTntLabel;
    btnAdd: TTntButton;
    procedure frameButtons1btnCancelClick(Sender: TObject);
    procedure frameButtons1btnOKClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure lstJIDSDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure lstJIDSDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure btnRemoveClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnAddClick(Sender: TObject);
    procedure cboRoomChange(Sender: TObject);
    procedure lstJIDSChange(Sender: TObject; Item: TListItem;
      Change: TItemChange);
    procedure lstJIDSDeletion(Sender: TObject; Item: TListItem);
  private
    { Private declarations }

  public
    { Public declarations }
    procedure AddRecip(jid: WideString);
  end;

var
  frmInvite: TfrmInvite;

procedure ShowInvite(room_jid: WideString; jids: TWideStringList = nil); overload;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
implementation
uses
    JabberUtils, ExUtils,  GnuGetText, Jabber1, PrefController,
    JabberConst, InputPassword, DisplayName,
    Session, Room, RosterForm, ContactController, SelectItem, RosterImages;

const
    sConfRoom = 'Conference Room:';
    sInviteBody = 'You have been invited to the %s conference room.';
    sInvalidRoomJID = 'The Conference Room Address you entered is invalid. It must be valid Jabber ID.';

{$R *.dfm}

{---------------------------------------}
procedure ShowInvite(room_jid: WideString; jids: TWideStringList);
var
    i: integer;
    f: TfrmInvite;
    rjid: TJabberID;
begin
    f := TfrmInvite.Create(Application);
    rjid := TJabberID.Create(room_jid);
    if ((room_jid = '') and (f.cboRoom.Items.Count = 1)) then
         f.cboRoom.ItemIndex := 0
    else begin
      //Need to find matching item in the list for "DropDownList" combo box style
      for i := 0 to f.cboRoom.Items.Count - 1 do begin
        if (f.cboRoom.Items[i] = rjid.getDisplayJID()) then begin
          f.cboRoom.ItemIndex := i;
          break;
        end;
      end;
    end;

    rjid.Free();

    // Only add the jids selected
    if (jids <> nil) then begin
        for i := 0 to jids.Count - 1 do
            f.AddRecip(jids[i]);
    end;
    f.Show;
end;

{---------------------------------------}
procedure TfrmInvite.AddRecip(jid: WideString);
var
    idx: integer;
    entered: TTntListItems;
    entry: TListItem;
    item: IExodusItem;
    cap: Widestring;
begin
    item := MainSession.ItemController.GetItem(jid);
    
    //TODO:  validate JID supports MUC??

    //Validate not already present
    entered := lstJIDS.Items;
    for idx := 0 to entered.Count - 1 do begin
        if (entered[idx].SubItems[0] = jid) then exit;
    end;

    if (item <> nil) then
        cap := item.Text
    else
        cap := jid;

    entry := entered.Add();
    entry.Caption := cap;
    entry.SubItems.Add(jid);

  { TODO : Roster refactor }
//    ritem := MainSession.roster.Find(jid);
//    if ritem <> nil then
//        cap := ritem.Text
//    else
//        cap := jid;
//
//    // make sure this JID supports MUC
//    if ((ritem <> nil) and
//        (ritem.tag <> nil) and
//        (ritem.tag.GetAttribute('xmlns') = 'jabber:iq:roster')) then begin
//
//        // if this person can not do offline msgs, and they are offline, bail
//        { TODO : if (not ritem.CanMUC) then begin }
//        if (not ritem.IsNative) then begin
//            MessageDlgW(_('This contact can not join chat rooms.'), mtError,
//                [mbOK], 0);
//            exit;
//        end;
//    end;
//    // make sure we don't already have an item w/ this caption
//    for i := 0 to lstJIDS.Items.Count - 1 do
//        if (lstJIDS.Items[i].SubItems[0] = jid) then exit;
//
//    n := lstJIDS.Items.Add();
//    n.Caption := cap;
//    if ritem <> nil then
//        n.SubItems.Add(ritem.Jid.getDisplayFull())
//    else
//        n.SubItems.Add(jid);
end;

{---------------------------------------}
procedure TfrmInvite.frameButtons1btnCancelClick(Sender: TObject);
begin
    Self.Close;
end;

{---------------------------------------}
procedure TfrmInvite.frameButtons1btnOKClick(Sender: TObject);
var
    frm: TfrmRoom;
    i: integer;
    x, msg: TXMLTag;
    b, room: WideString;
    room_idx: integer;
    jid, roomJID: TJabberID;
begin
    // Make sure we are actually in this room...
    roomJID := TJabberID.Create(cboRoom.Text, false);
    room := roomJID.jid();

    if ((room = '') or (not isValidJID(room))) then begin
        MessageDlgW(_(sInvalidRoomJID), mtError, [mbOK], 0);
        exit;
    end;

    room_idx := room_list.IndexOf(room);
    if (room_idx < 0) then
        StartRoom(room, '', '', True, False, True);
    frm := FindRoom(room);

    // Send out invites.
    b := WideFormat(_(sInviteBody), [room]);
    memReason.Lines.Add(_(sConfRoom) + ' ' + roomJID.getDisplayJID());

    for i := 0 to lstJIDS.Items.Count - 1 do begin
        msg := TXMLTag.Create('message');
        if ((frm <> nil) and (frm.isMUCRoom)) then begin
            // this is MUC.. use muc#user
            msg.setAttribute('to', roomJID.jid());
            b := '';
            x := msg.AddTag('x');
            with x do begin
                setAttribute('xmlns', xmlns_mucuser);
                with AddTag('invite') do begin
                    jid := TJabberID.Create(lstJIDS.Items[i].SubItems[0],false);
                    setAttribute('to', jid.jid );
                    jid.Free();
                    AddBasicTag('reason', memReason.Lines.Text);
                end;
            end;
        end
        else begin
            // this is GC 1.0, or we aren't in the room yet..
            // Use jabber;x:conference
            msg.setAttribute('to', lstJIDS.Items[i].SubItems[0]);
            x := msg.AddTag('x');
            with x do begin
                setAttribute('xmlns', 'jabber:x:conference');
                setAttribute('jid', roomJID.jid());
            end;
        end;
        jabberSendMsg(msg.getAttribute('to'), msg, x, b, '');
    end;
    roomJID.Free();
    Self.Close;
end;

{---------------------------------------}
procedure TfrmInvite.FormCreate(Sender: TObject);
var
    tmp: TWideStringList;
    jid: TJabberID;
    i  : integer;
begin
    // make the form the same width as the list view
    TranslateComponent(Self);
    Self.ClientWidth := pnlMain.Width + 2;
    tmp := TWideStringList.Create();
    for i := 0 to room.room_list.Count - 1 do
        begin
            jid := TJabberID.Create(room.room_list.Strings[i]);
            tmp.Add(jid.getDisplayJID());
            jid.Free();
        end;
    AssignTntStrings(tmp, cboRoom.Items);
    tmp.Free();
    pnlMain.Align := alClient;
end;

{---------------------------------------}
procedure TfrmInvite.lstJIDSDragOver(Sender, Source: TObject; X,
  Y: Integer; State: TDragState; var Accept: Boolean);
begin
    // accept roster items from the main roster as well
    // as the string grid on this form
    Accept := (Source = frmRoster.RosterTree);
end;

{---------------------------------------}
procedure TfrmInvite.lstJIDSChange(Sender: TObject; Item: TListItem;
  Change: TItemChange);
begin
    if ((Length(Trim(cboRoom.Text)) > 0) and
        (lstJIDS.items.Count > 0)) then
        frameButtons1.btnOK.Enabled:= true
    else
        frameButtons1.btnOK.Enabled := false;
end;

procedure TfrmInvite.lstJIDSDeletion(Sender: TObject; Item: TListItem);
begin
    if ((Length(Trim(cboRoom.Text)) > 0) and
        (lstJIDS.items.Count > 1)) then
        frameButtons1.btnOK.Enabled:= true
    else
        frameButtons1.btnOK.Enabled := false;
end;

procedure TfrmInvite.lstJIDSDragDrop(Sender, Source: TObject; X,
  Y: Integer);
//var
//    tree: TTreeView;
//    r, n: TTreeNode;
//    i,j: integer;
begin
    // dropping from main roster window
    { TODO : Roster refactor }
//    tree := TTreeView(Source);
//
//    with tree do begin
//        for i := 0 to SelectionCount - 1 do begin
//            n := Selections[i];
//            if ((n.Data <> nil) and (TObject(n.Data) is TJabberRosterItem)) then
//                // We have a roster item
//                Self.AddRecip(TJabberRosterItem(n.Data).jid.jid)
//            else if (n.Level = 0) then begin
//                // we prolly have a grp
//                for j := 0 to n.Count - 1 do begin
//                    r := n.Item[j];
//                    if ((r.Data <> nil) and (TObject(r.Data) is TJabberRosterItem)) then
//                        Self.AddRecip(TJabberRosterItem(r.Data).jid.jid);
//                end;
//            end;
//        end;
//    end;
end;

{---------------------------------------}
procedure TfrmInvite.btnRemoveClick(Sender: TObject);
var
    i: integer;
begin
    // Remove all the selected items
    for i := lstJIDS.Items.Count - 1 downto 0 do begin
        if lstJIDS.Items[i].Selected then
            lstJIDS.Items.Delete(i);
    end;
end;

procedure TfrmInvite.cboRoomChange(Sender: TObject);
begin
    if ((Length(Trim(cboRoom.Text)) > 0)and
        (lstJIDS.items.Count > 0)) then
        frameButtons1.btnOK.Enabled:= true
    else
        frameButtons1.btnOK.Enabled := false;
end;

{---------------------------------------}
procedure TfrmInvite.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    Action := caFree;
end;

{---------------------------------------}
procedure TfrmInvite.btnAddClick(Sender: TObject);
var
    selected: Widestring;
begin
    // Add a JID
    selected := SelectUIDByType('contact');
    if (selected <> '') then
        AddRecip(selected);
end;

{
    TInviteToRoomAction implementation
}
constructor TInviteToRoomAction.Create;
begin
    inherited Create('{000-exodus.googlecode.com}-050-invite-to-room');

    Caption := _('Invite to Conference...');
end;

function TInviteToRoomAction.Get_Enabled: WordBool;
begin
    Result := (Room.room_list.Count > 0);
end;
procedure TInviteToRoomAction.execute(const items: IExodusItemList);
var
    idx: Integer;
    item: IExodusItem;
    jids: TWidestringList;
    rjid: Widestring;
begin
    jids := TWidestringList.Create;
    rjid := '';

    for idx := 0 to items.Count - 1 do begin
        item := items.Item[idx];
        if (item.Type_ = 'room') and (rjid = '') then rjid := item.UID;
        if (item.Type_ <> 'contact') then continue;
        
        jids.Add(item.UID);
    end;
    ShowInvite(rjid, jids);

    jids.Free;
end;


procedure RegisterActions();
var
    actctrl: IExodusActionController;
    act: IExodusAction;
begin

    actctrl := GetActionController();

    act := TInviteToRoomAction.Create;
    actctrl.registerAction('contact', act);

    actctrl.registerAction('room', act);
    actctrl.addEnableFilter('room', act.Name, 'selection=single');
end;

initialization
    RegisterActions();

end.
