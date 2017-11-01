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
unit Bookmark;

interface

uses
    Roster, NodeItem,  
    Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
    Dialogs, buttonFrame, StdCtrls, TntStdCtrls, XMLTag, ExForm;

type
  TfrmBookmark = class(TExForm)
    frameButtons1: TframeButtons;
    Label1: TTntLabel;
    cboType: TTntComboBox;
    Label2: TTntLabel;
    txtName: TTntEdit;
    Label3: TTntLabel;
    txtJID: TTntEdit;
    Label4: TTntLabel;
    txtNick: TTntEdit;
    chkAutoJoin: TTntCheckBox;
    chkRegisteredNick: TTntCheckBox;
    procedure frameButtons1btnCancelClick(Sender: TObject);
    procedure frameButtons1btnOKClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    new: boolean;
    _scallback: integer;
  public
    { Public declarations }
    procedure SessionCallback(event: string; tag: TXMLTag);
  end;

var
  frmBookmark: TfrmBookmark;

function ShowBookmark(jid: Widestring; bm_name: Widestring = ''; doing_rename: boolean = false): TfrmBookmark;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
implementation

{$R *.dfm}

uses
    JabberUtils, ExUtils,  GnuGetText, JabberID, Session,
    RosterWindow;

{---------------------------------------}
function ShowBookmark(jid: Widestring; bm_name: Widestring = ''; doing_rename: boolean = false): TfrmBookmark;
var
    f: TfrmBookmark;
    bm: TXMLTag;
    tmp: TJabberID;
begin
    bm := nil;
    if (jid <> '') then
        bm := MainSession.Bookmarks.FindBookmark(jid);

    f := TfrmBookmark.Create(Application);
    if (bm = nil) then f.Caption := _('Add a new bookmark');

    with f do begin
        cboType.ItemIndex := 0;
        tmp := TJabberID.Create(jid);
        if (bm = nil) then begin
            new := true;
            txtJid.Text := tmp.getDisplayJID();
            txtNick.Text := MainSession.Profile.getDisplayUsername();
            if (name <> '') then
                txtName.Text := bm_name
            else
                txtName.Text := tmp.getDisplayJID();
        end
        else begin
            new := false;
            tmp := TJabberID.Create(bm.GetAttribute('jid'));
            txtJID.Text := tmp.getDisplayJID();
            txtName.Text := bm.GetAttribute('name');
            chkAutoJoin.Checked := (bm.GetAttribute('autojoin') = 'true');
            txtNick.Text := bm.GetBasicText('nick');
            chkRegisteredNick.Checked := (bm.GetAttribute('reg_nick') = 'true');
        end;
        tmp.Free();

        Show();
        if (doing_rename) then begin
            txtName.SetFocus;
            txtName.SelectAll;
        end;
    end;

    Result := f;
end;

{---------------------------------------}
procedure TfrmBookmark.frameButtons1btnCancelClick(Sender: TObject);
begin
    Self.Close;
end;

{---------------------------------------}
procedure TfrmBookmark.frameButtons1btnOKClick(Sender: TObject);
var
    bm: TXMLTag;
    nick: TXMLTag;
    ri: TJabberRosterItem;
    jid: TJabberID;
begin
    // Save any changes to the bookmark and resave
    jid := TJabberID.Create(txtJid.Text, false);
    if (new) then begin
        MainSession.Bookmarks.AddBookmark(jid.jid(), txtName.Text,
            txtNick.Text, chkAutoJoin.Checked, chkRegisteredNick.Checked);
    end
    else begin
        bm := MainSession.Bookmarks.FindBookmark(jid.jid());
        assert(bm <> nil);
        bm.setAttribute('name', txtName.Text);
        if chkAutoJoin.Checked then
            bm.setAttribute('autojoin', 'true')
        else
            bm.setAttribute('autojoin', 'false');
        if chkRegisteredNick.Checked then
            bm.setAttribute('reg_nick', 'true')
        else
            bm.setAttribute('reg_nick', 'false');

        nick := bm.GetFirstTag('nick');
        if nick = nil then
            nick := bm.AddTag('nick')
        else
            nick.ClearCData();
        nick.AddCData(txtNick.Text);

        MainSession.bookmarks.SaveBookmarks();
        ri := MainSession.Roster.Find(jid.jid());
        assert(ri <> nil);
        ri.Tag := bm;

        // update the ritem
        MainSession.Bookmarks.parseItem(bm, ri);

        // tell everyone about the updated item
        MainSession.FireEvent('/roster/item', bm, ri);
    end;
    jid.Free();
    Self.Close;
end;

{---------------------------------------}
procedure TfrmBookmark.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
    Action := caFree;
    MainSession.UnRegisterCallback(_scallback);
end;

{---------------------------------------}
procedure TfrmBookmark.FormCreate(Sender: TObject);
begin
    AssignUnicodeFont(Self);
    TranslateComponent(Self);
    if (MainSession.Prefs.getBool('brand_prevent_change_nick')) then begin
        txtNick.Enabled := false;
        chkRegisteredNick.Enabled := false;
    end;
    _scallback := MainSession.RegisterCallback(SessionCallback, '/session');
end;

{---------------------------------------}
procedure TfrmBookmark.SessionCallback(event: string; tag: TXMLTag);
begin
    if (event = '/session/disconnected') then
        Self.Close;
end;

end.
