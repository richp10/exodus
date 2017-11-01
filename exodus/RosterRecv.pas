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
unit RosterRecv;


interface

uses
    Dockable, 
    Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
    buttonFrame, StdCtrls, ComCtrls, Grids, ExtCtrls, ExRichEdit, RichEdit2,
    TntStdCtrls, TntComCtrls, TntExtCtrls, JabberID, XMLTag, StrUtils, Unicode,
  ToolWin, TntForms, ExFrame;

type
  TfrmRosterRecv = class(TfrmDockable)
    frameButtons1: TframeButtons;
    txtMsg: TExRichEdit;
    Splitter1: TSplitter;
    lvContacts: TTntListView;
    Panel1: TTntPanel;
    Label2: TTntLabel;
    cboGroup: TTntComboBox;
    pnlFrom: TTntPanel;
    StaticText1: TTntStaticText;
    txtFrom: TTntStaticText;
    procedure FormCreate(Sender: TObject);
    procedure frameButtons1btnOKClick(Sender: TObject);
    procedure frameButtons1btnCancelClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure Restore(tag: TXMLTag);
  end;

  procedure ReceivedRoster(tag: TXMLTag);

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
implementation
uses
    JabberUtils, ExUtils,  S10n, ContactController, Session, Jabber1,
  DisplayName, JabberConst, Exodus_TLB, COMExodusItem;

{$R *.DFM}
procedure ReceivedRoster(tag: TXMLTag);
var
    frm: TfrmRosterRecv;
begin
    frm := TfrmRosterRecv.Create(Application);
    frm.Restore(tag);
    frm.ShowDefault();
end;

{---------------------------------------}
procedure TfrmRosterRecv.Restore(tag: TXMLTag);
var
    i: integer;
    n: TListItem;
    from: TJabberID;
//    noi, noi_label, noi_image_prefix: Widestring;
//    offset: Cardinal;
      TmpTag: TXMLTag;
      Item: IExodusItem;
begin
    // Fill up the GUI based on the event

    from := TJabberID.Create(tag.GetAttribute('from'));
    txtFrom.Caption := DisplayName.getDisplayNameCache().getDisplayNameAndBareJID(from);
    from.Free();

    txtMsg.Lines.Text := tag.GetBasicText('body');
    TmpTag := tag.QueryXPTag(XP_MSGXROSTER);

    for i := 0 to TmpTag.ChildCount - 1 do
    begin
        n := lvContacts.Items.Add();
        n.Checked := true;

        Item := MainSession.ItemController.GetItem(TmpTag.ChildTags[i].GetAttribute('jid'));

        if (Item <> nil) then
        begin
            n.Caption := Item.Text;
            n.SubItems.Add(Item.UID);
            //n.ImageIndex := Item.ImageIndex;
        end
        else
        begin
            n.Caption := TmpTag.ChildTags[i].GetAttribute('name');
            n.SubItems.Add(TmpTag.ChildTags[i].GetAttribute('jid'));
            //n.ImageIndex := -1;
        end;
//            if (ri.Tag.GetAttribute('noi') <> '') then begin
//                for j:= 0 to MainSession.Prefs.getStringlistCount('recv_contact_image_prefix') - 1 do begin
//                    noi := MainSession.Prefs.getStringlistValue('recv_contact_image_prefix', j);
//                    offset := Pos('=', noi);
//                    if (offset > 0) then begin
//                        noi_label :=  Trim(LeftStr(noi, offset - 1));
//                        noi_image_prefix := Trim(RightStr(noi, StrLenW(PWideChar(noi)) - offset));
//                        if (noi_label = ri.Tag.GetAttribute('noi')) then
//                            ri.ImagePrefix := noi_image_prefix;
//                    end;
//                end;
//            end;

    end;

//    ShowDefault();
end;

{---------------------------------------}
procedure TfrmRosterRecv.FormCreate(Sender: TObject);
var
   Groups: IExodusItemList;
   i, Index: Integer;
   DefaultGroup: WideString;
begin
  inherited;

    // Fill up the groups drop down
    Groups := MainSession.ItemController.GetItemsByType('group');
    for i := 0 to Groups.Count - 1 do
      cboGroup.Items.Add(Groups.Item[i].uid);

    DefaultGroup := MainSession.Prefs.getString('roster_default');
    Index := cboGroup.Items.IndexOf(DefaultGroup);
    if ((Index >= 0) and (Index <= cboGroup.Items.Count)) then
       cboGroup.ItemIndex := Index;
    _windowType := 'roster_recv';
end;

{---------------------------------------}
procedure TfrmRosterRecv.frameButtons1btnOKClick(Sender: TObject);
var
    i: integer;
    l: TListItem;
    nick, jid: Widestring;
    jidObj: TJabberID;
begin

  inherited;
    // Add the selected contacts, then close
    for i := 0 to lvContacts.Items.Count - 1 do begin
        l := lvContacts.Items[i];
        if (l.Checked) then begin
            // subscribe
            jidObj := TJabberID.Create(l.SubItems[0], false);
            jid := jidObj.jid;
            nick := l.Caption;

            MainSession.Roster.AddItem(jid, nick, cboGroup.Text, true);
            jidObj.Free();
        end;
    end;
    Self.Close();
end;

{---------------------------------------}
procedure TfrmRosterRecv.frameButtons1btnCancelClick(Sender: TObject);
begin
  inherited;
    Self.Close();
end;

{---------------------------------------}
procedure TfrmRosterRecv.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;
    Action := caFree;
end;

end.

