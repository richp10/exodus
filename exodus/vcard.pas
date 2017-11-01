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
unit vcard;


interface

uses
    XMLVCard,
    XMLTag,
    Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
    Dialogs, ComCtrls, buttonFrame, StdCtrls, ExtCtrls, TntStdCtrls,
    TntComCtrls, ExtDlgs, ExForm, TntForms, ExFrame;

type
  TfrmVCard = class(TExForm)
    Splitter1: TSplitter;
    PageControl1: TTntPageControl;
    TabSheet1: TTntTabSheet;
    TabSheet3: TTntTabSheet;
    Label12: TTntLabel;
    Label6: TTntLabel;
    Label28: TTntLabel;
    Label8: TTntLabel;
    Label9: TTntLabel;
    cboOcc: TTntComboBox;
    TabSheet4: TTntTabSheet;
    Label13: TTntLabel;
    Label21: TTntLabel;
    Label29: TTntLabel;
    Label30: TTntLabel;
    Label31: TTntLabel;
    Label32: TTntLabel;
    txtHomeCountry: TTntComboBox;
    TabSheet5: TTntTabSheet;
    Label22: TTntLabel;
    Label23: TTntLabel;
    Label24: TTntLabel;
    Label19: TTntLabel;
    Label20: TTntLabel;
    TabSheet6: TTntTabSheet;
    Label15: TTntLabel;
    Label16: TTntLabel;
    Label17: TTntLabel;
    Label18: TTntLabel;
    Label26: TTntLabel;
    Label14: TTntLabel;
    txtWorkCountry: TTntComboBox;
    frameButtons1: TframeButtons;
    txtBDay: TTntEdit;
    txtHomeVoice: TTntEdit;
    txtHomeFax: TTntEdit;
    txtHomeState: TTntEdit;
    txtHomeZip: TTntEdit;
    txtHomeCity: TTntEdit;
    txtHomeStreet2: TTntEdit;
    txtHomeStreet1: TTntEdit;
    txtOrgName: TTntEdit;
    txtOrgUnit: TTntEdit;
    txtOrgTitle: TTntEdit;
    txtWorkVoice: TTntEdit;
    txtWorkFax: TTntEdit;
    txtWorkState: TTntEdit;
    txtWorkZip: TTntEdit;
    txtWorkCity: TTntEdit;
    txtWorkStreet2: TTntEdit;
    txtWorkStreet1: TTntEdit;
    memDesc: TTntMemo;
    Label1: TTntLabel;
    TreeView1: TTntTreeView;
    OpenPic: TOpenPictureDialog;
    TntLabel1: TTntLabel;
    PaintBox1: TPaintBox;
    btnPicBrowse: TTntButton;
    Label2: TTntLabel;
    lblEmail: TTntLabel;
    Label7: TTntLabel;
    Label5: TTntLabel;
    lblURL: TTntLabel;
    txtNick: TTntEdit;
    txtPriEmail: TTntEdit;
    txtFirst: TTntEdit;
    txtLast: TTntEdit;
    txtWeb: TTntEdit;
    btnPicClear: TTntButton;
    txtMiddle: TTntEdit;
    TntLabel2: TTntLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure frameButtons1btnCancelClick(Sender: TObject);
    procedure TreeView1Click(Sender: TObject);
    procedure frameButtons1btnOKClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnPicBrowseClick(Sender: TObject);
    procedure PaintBox1Paint(Sender: TObject);
    procedure btnPicClearClick(Sender: TObject);

  private
    { Private declarations }
    _vcard: TXMLVCard;
    procedure Callback(jid: Widestring; vcard: TXMLVCard);
  public
    { Public declarations }
    procedure vCardIQCB(event: string; tag: TXMLTag);
  end;

var
  frmVCard: TfrmVCard;

procedure ShowMyProfile;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
implementation

{$R *.dfm}
uses
    Avatar, JabberUtils, ExUtils,  GnuGetText, IQ, Session, XMLVCardCache;
const
    sVCardError = 'No vCard response was ever returned.';
    sFailureToSetVCard = 'Could not modify profile.' + #13#10 + 'Either the server is too busy or you do not have permission to change your profile.';

{---------------------------------------}
procedure ShowMyProfile;
var
    f: TfrmVCard;
begin
    f := TfrmVCard.Create(Application);
    f.Show;
end;

{---------------------------------------}
procedure TfrmVCard.FormCreate(Sender: TObject);
var
    n: TTntTreeNode;
    i: integer;
begin
    AssignUnicodeFont(Self);
    TranslateComponent(Self);

    // Hide all the tabs
    TabSheet1.TabVisible := false;
    TabSheet3.TabVisible := false;
    TabSheet4.TabVisible := false;
    TabSheet5.TabVisible := false;
    TabSheet6.TabVisible := false;

    // Do this to ensure the nodes are properly translated.
         TreeView1.Items.Clear();
         TreeView1.Items.Add(nil,       _('Basic'));
    n := TreeView1.Items.AddChild(nil,  _('Personal Information'));
         TreeView1.Items.AddChild(n,    _('Address'));
    n := TreeView1.Items.AddChild(nil,  _('Work Information'));
         TreeView1.Items.AddChild(n,    _('Address'));

    for i := 0 to TreeView1.Items.Count - 1 do
        TreeView1.Items[i].Expand(true);

    PageControl1.ActivePageIndex := 0;
    TreeView1.FullExpand();
    MainSession.Prefs.RestorePosition(Self);

    GetVCardCache().find(MainSession.SessionJid.jid, Callback, true);
end;

{---------------------------------------}
procedure TfrmVCard.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    MainSession.Prefs.SavePosition(Self);
    Action := caFree;
end;

{---------------------------------------}
procedure TfrmVCard.Callback(jid: Widestring; vcard: TXMLVCard);
begin
    // callback for vcard info
    if (vcard = nil) then begin
        MessageDlgW(_(sVCardError), mtInformation, [mbOK], 0);
        _vcard := TXMLVCard.Create();
        exit;
    end;
    
    _vcard := vcard;

    with _vcard do begin
        txtFirst.Text := GivenName;
        txtMiddle.Text := MiddleName;
        txtLast.Text := FamilyName;
        txtNick.Text := nick;
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

        if (Picture <> nil) then
            Picture.Draw(PaintBox1.Canvas, PaintBox1.ClientRect);
    end;
end;

{---------------------------------------}
procedure TfrmVCard.frameButtons1btnCancelClick(Sender: TObject);
begin
    Self.Close;
end;

{---------------------------------------}
procedure TfrmVCard.TreeView1Click(Sender: TObject);
begin
    PageControl1.ActivePageIndex := TreeView1.Selected.AbsoluteIndex;
end;

{---------------------------------------}
procedure TfrmVCard.frameButtons1btnOKClick(Sender: TObject);
var
    payload: TXMLTag;
    iq: TJabberIQ;
    i: integer;
begin
    // Save the vcard..
    with _vcard do begin
        GivenName := txtFirst.Text;
        MiddleName := txtMiddle.Text;
        FamilyName := txtLast.Text;
        nick := txtNick.Text;
        email := txtPriEmail.Text;
        url := txtWeb.Text;
        role := cboOcc.Text;
        bday := txtBday.Text;
        Desc := memDesc.Lines.Text;

        WorkPhone.number := txtWorkVoice.Text;
        WorkPhone.work := true; WorkPhone.voice := true;

        WorkFax.number := txtWorkFax.Text;
        WorkFax.work := true; WorkPhone.fax := true;

        HomePhone.number := txtHomeVoice.Text;
        HomePhone.home := true; HomePhone.voice := true;

        HomeFax.number := txtHomeFax.Text;
        HomeFax.home := true; HomePhone.fax := true;

        with work do begin
            work := true;
            home := false;
            Street := txtWorkStreet1.Text;
            ExtAdr := txtWorkStreet2.Text;
            Locality := txtWorkCity.Text;
            Region := txtWorkState.Text;
            PCode := txtWorkZip.Text;
            Country := txtWorkCountry.Text;
        end;

        with Home do begin
            home := true;
            work := false;
            Street := txtHomeStreet1.Text;
            ExtAdr := txtHomeStreet2.Text;
            Locality := txtHomeCity.Text;
            Region := txtHomeState.Text;
            PCode := txtHomeZip.Text;
            Country := txtHomeCountry.Text;
        end;

        OrgName := txtOrgName.Text;
        OrgUnit := txtOrgUnit.Text;
        OrgTitle := txtOrgTitle.Text;
    end;

    payload := TXMLTag.Create('iq');
    _vcard.fillTag(payload);

    // save this hash to the profile..
    if (_vcard.Picture <> nil) then begin
        MainSession.Profile.Avatar := _vcard.Picture.Data;
        MainSession.Profile.AvatarHash := _vcard.Picture.getHash();
        MainSession.Profile.AvatarMime := _vcard.Picture.MimeType;
        MainSession.Prefs.SaveProfiles();
        MainSession.setPresence(MainSession.Show, MainSession.Status,
            MainSession.Priority);
    end;

    iq := TJabberIQ.Create(MainSession, MainSession.generateID(), payload.GetFirstTag('vCard'), vCardIQCB, 10);
    iq.iqType := 'set';
    iq.Namespace := 'vcard-temp';
    payload.Free;

    // Show Hourglass Mouse Pointer
    frameButtons1.btnOK.Cursor := crHourGlass;
    frameButtons1.btnCancel.Cursor := crHourGlass;
    Self.Cursor := crHourGlass;
    for i := 0 to Self.ControlCount - 1 do begin
        Self.Controls[i].Cursor := crHourGlass;
    end;
    frameButtons1.Cursor := crHourGlass;
    for i := 0 to frameButtons1.ControlCount - 1 do begin
        frameButtons1.Controls[i].Cursor := crHourGlass;
    end;
    TabSheet1.Cursor := crHourGlass;
    for i := 0 to TabSheet1.ControlCount - 1 do begin
        TabSheet1.Controls[i].Cursor := crHourGlass;
    end;

    // Disable controls
    frameButtons1.btnOK.Enabled := false;
    frameButtons1.btnCancel.Enabled := false;
    for i := 0 to Self.ControlCount - 1 do begin
        Self.Controls[i].Enabled := false;
    end;
    frameButtons1.Enabled := false;
    for i := 0 to frameButtons1.ControlCount - 1 do begin
        frameButtons1.Controls[i].Enabled := false;
    end;
    TabSheet1.Enabled := false;
    for i := 0 to TabSheet1.ControlCount - 1 do begin
        TabSheet1.Controls[i].Enabled := false;
    end;

    iq.Send();
end;

{---------------------------------------}
procedure TfrmVCard.vCardIQCB(event: string; tag: TXMLTag);
var
    w: word;
begin
    if ((event = 'timeout') or
        ((tag <> nil) and
        (tag.GetAttribute('type') = 'error'))) then begin
        w := 0; //reserved
        MessageBoxExW(Self.Handle, PWideChar(_(sFailureToSetVCard)), PWideChar(_('My Profile')), MB_OK OR MB_ICONERROR, w);
    end;

    Self.Close;
end;

{---------------------------------------}
procedure TfrmVCard.FormDestroy(Sender: TObject);
begin
    //nothing to see here...
end;

{---------------------------------------}
procedure TfrmVCard.btnPicBrowseClick(Sender: TObject);
var
    a: TAvatar;
    d: string;
begin
    // browse for a new vcard picture
    if (OpenPic.Execute()) then begin
        a := TAvatar.Create();
        a.LoadFromFile(OpenPic.FileName);
        if (not a.Valid) then begin
            // a is NOT valid
            a.Free();
            exit;
        end;

        // check size of a
        d := a.Data;
        if (Length(d) > MAX_AVATAR_SIZE) then begin
            a.Free();
            MessageDlgW(_('This graphic is too large and could considerably degrade performance. Please choose another avatar.'),
                mtError, [mbOk], 0);
            exit;
        end;

        // a is valid
        if (_vcard.Picture <> nil) then
            _vcard.Picture.Free();
        _vcard.Picture := a;
        a.Draw(PaintBox1.Canvas, PaintBox1.ClientRect);
        PaintBox1.Repaint();  // ensures old picture is overwritten if bigger
    end;
end;

{---------------------------------------}
procedure TfrmVCard.PaintBox1Paint(Sender: TObject);
begin
    // paint the avatar
    if ((_vcard <> nil) and (_vcard.Picture <> nil)) then
        _vcard.picture.Draw(PaintBox1.Canvas, PaintBox1.ClientRect)
    else begin
        PaintBox1.Canvas.Brush.Color := clBtnFace;
        PaintBox1.Canvas.FillRect(PaintBox1.ClientRect);
    end;
end;

{---------------------------------------}
procedure TfrmVCard.btnPicClearClick(Sender: TObject);
begin
    if (_vcard.Picture <> nil) then
        FreeAndNil(_vcard.Picture);
    PaintBox1.Repaint();
end;

end.
