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
unit CustomPres;

interface

uses
    Menus, 
    Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
    Dialogs, buttonFrame, StdCtrls, ComCtrls, TntStdCtrls, ExForm, TntForms,
  ExFrame, Unicode;

type
  TfrmCustomPres = class(TExForm)
    frameButtons1: TframeButtons;
    Label1: TTntLabel;
    cboType: TTntComboBox;
    Label2: TTntLabel;
    txtStatus: TTntEdit;
    Label3: TTntLabel;
    txtPriority: TTntEdit;
    chkSave: TTntCheckBox;
    boxSave: TGroupBox;
    lblTitle: TTntLabel;
    txtTitle: TTntEdit;
    lblHotkey: TTntLabel;
    txtHotkey: THotKey;
    procedure FormCreate(Sender: TObject);
    procedure frameButtons1btnOKClick(Sender: TObject);
    procedure frameButtons1btnCancelClick(Sender: TObject);
    procedure chkSaveClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure txtTitleChange(Sender: TObject);
    procedure txtHotkeyChange(Sender: TObject);
  private
    { Private declarations }
    _show_list: TWidestringList;
  public
    { Public declarations }
  end;

var
  frmCustomPres: TfrmCustomPres;

procedure ShowCustomPresence();

const
    sDupHotKey = 'Hotkey is already used for presence %s';

implementation

{$R *.dfm}

uses
    JabberUtils, ExUtils,  GnuGetText,
    Jabber1, Session, Presence;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
procedure ShowCustomPresence();
var
    f: TfrmCustomPres;
begin
    // show a new custom presence dialog box
    f := TfrmCustomPres.Create(Application);
    frmExodus.PreModal(f);
    f.ShowModal;
    frmExodus.PostModal();
end;

{---------------------------------------}
procedure TfrmCustomPres.FormCreate(Sender: TObject);
var
    i, pos: integer;

    procedure BrandShowOption(value: Widestring; brand: Boolean);
    begin
        if brand then begin
            _show_list.Add(value);
            Inc(pos);
        end
        else begin
            cboType.Items.Delete(Pos);
        end;

    end;
begin
    AssignUnicodeFont(Self);
    TranslateComponent(Self);

    if (_show_list = nil) then begin
        _show_list := TWidestringList.Create();
        pos := 0;
        BrandShowOption('chat', MainSession.Prefs.getBool('show_presence_menu_chat'));
        BrandShowOption('', MainSession.Prefs.getBool('show_presence_menu_available'));
        BrandShowOption('away', MainSession.Prefs.getBool('show_presence_menu_away'));
        BrandShowOption('xa', MainSession.Prefs.getBool('show_presence_menu_xa'));
        BrandShowOption('dnd', MainSession.Prefs.getBool('show_presence_menu_dnd'));
    end;


    // Default to the current settings
    if (MainSession.Show = 'chat') then i := _show_list.IndexOf('chat')
    else if (MainSession.Show = 'away') then i := _show_list.IndexOf('away')
    else if (MainSession.show = 'xa') then i := _show_list.IndexOf('xa')
    else if (MainSession.Show = 'dnd') then i := _show_list.IndexOf('dnd')
    else i := _show_list.IndexOf('');

    if (i = -1) then i := 0;

    cboType.ItemIndex := i;
    txtStatus.Text := MainSession.Status;
    txtPriority.Text := IntToStr(MainSession.Priority);
    chkSave.Checked := false;
end;

{---------------------------------------}
procedure TfrmCustomPres.frameButtons1btnOKClick(Sender: TObject);
var
    show, status: WideString;
    pri: integer;
    cp: TJabberCustomPres;
begin
    // apply the new presence to the session
    show := _show_list[cboType.ItemIndex];
    status := txtStatus.Text;
    pri := StrToInt(txtPriority.Text);

    // make sure we're compliant here.
    if (pri > 128) then
        pri := 128
    else if (pri < -128) then
        pri := -128;

    MainSession.setPresence(show, status, pri);

    // save custom presence
    if (chkSave.Checked) then begin
        cp := TJabberCustomPres.Create();
        cp.title := txtTitle.Text;
        cp.Show := show;
        cp.Status := status;
        cp.Priority := pri;
        cp.hotkey := ShortCutToText(txtHotkey.HotKey);
        MainSession.Prefs.setPresence(cp);
        MainSession.FireEvent('/session/prefs', nil);
    end;

    Self.Close;
end;

{---------------------------------------}
procedure TfrmCustomPres.txtHotkeyChange(Sender: TObject);
var
    i: integer;
    msg: WideString;
    list: TWideStringList;
    cp: TJabberCustomPres;
begin
    inherited;

    // Do check to see if hotkey combo already used.
    list := MainSession.Prefs.getAllPresence();

    for i := 0 to list.Count - 1 do begin
        cp := TJabberCustomPres(list.Objects[i]);
        if ((cp.hotkey <> '') and
            (cp.hotkey = ShortCutToText(txtHotkey.HotKey))) then begin
              msg := WideFormat(_(sDupHotKey),[cp.title]);
              MessageDlgW(msg, mtInformation, [mbOk], 0);
              txtHotkey.HotKey := TextToShortcut('');
        end;    
    end;
end;

{---------------------------------------}
procedure TfrmCustomPres.txtTitleChange(Sender: TObject);
begin
    if (chkSave.Checked) then begin
        frameButtons1.btnOK.Enabled := not (txtTitle.Text = '');
    end;
end;

{---------------------------------------}
procedure TfrmCustomPres.frameButtons1btnCancelClick(Sender: TObject);
begin
    Self.Close;
end;

{---------------------------------------}
procedure TfrmCustomPres.chkSaveClick(Sender: TObject);
var
    e: boolean;
begin
    e := chkSave.Checked;
    lblTitle.Enabled := e;
    txtTitle.Enabled := e;
    lblHotkey.Enabled := e;
    txtHotkey.Enabled := e;
    
    if (not e) then begin
        frameButtons1.btnOK.Enabled := true;
    end
    else begin
        if (txtTitle.Text = '') then
            txtTitle.Text := txtStatus.Text;
        txtTitle.SetFocus();
        txtTitle.SelectAll();
    end;

end;

{---------------------------------------}
procedure TfrmCustomPres.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
    Action := caFree;
end;

end.
