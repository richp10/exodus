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
unit PrefPresence;


interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, PrefPanel, StdCtrls, ComCtrls, ExtCtrls, TntStdCtrls,
  TntComCtrls, TntExtCtrls, ExNumericEdit, ExGroupBox, TntForms, ExFrame,
  ExBrandPanel, Unicode;

type
  TfrmPrefPresence = class(TfrmPrefPanel)
    ExBrandPanel1: TExBrandPanel;
    chkClientCaps: TTntCheckBox;
    chkRoomJoins: TTntCheckBox;
    chkPresenceSync: TTntCheckBox;
    ExGroupBox1: TExGroupBox;
    rbAllPres: TTntRadioButton;
    rbLastPres: TTntRadioButton;
    rbNoPres: TTntRadioButton;
    ExGroupBox2: TExGroupBox;
    lstCustomPres: TTntListBox;
    btnCustomPresAdd: TTntButton;
    btnCustomPresRemove: TTntButton;
    btnCustomPresClear: TTntButton;
    btnDefaults: TTntButton;
    pnlProperties: TExBrandPanel;
    Label11: TTntLabel;
    txtCPTitle: TTntEdit;
    Label12: TTntLabel;
    txtCPStatus: TTntEdit;
    Label13: TTntLabel;
    cboCPType: TTntComboBox;
    Label14: TTntLabel;
    txtCPPriority: TExNumericEdit;
    lblHotkey: TTntLabel;
    txtCPHotkey: THotKey;
    procedure FormDestroy(Sender: TObject);
    procedure lstCustomPresClick(Sender: TObject);
    procedure txtCPTitleChange(Sender: TObject);
    procedure btnCustomPresAddClick(Sender: TObject);
    procedure btnCustomPresRemoveClick(Sender: TObject);
    procedure btnCustomPresClearClick(Sender: TObject);
    procedure btnDefaultsClick(Sender: TObject);
    function  isDuplicateHotKey(key: WideString; out idx: integer): Boolean;
  private
    { Private declarations }
    _pres_list: TList;
    _no_pres_change: boolean;
    _show_list: TWideStringList;

    procedure clearPresList();
  public
    { Public declarations }
    procedure LoadPrefs(); override;
    procedure SavePrefs(); override;
  end;

var
  frmPrefPresence: TfrmPrefPresence;

const
    sPrefsDfltPres = 'Untitled Presence';
    sPrefsClearPres = 'Clear all custom presence entries?';
    sPrefsDefaultPres = 'Restore default presence entries?';
    sPrefsDupHotKey = 'Hotkey is already used for presence %s';

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
implementation
{$R *.dfm}
uses
    GnuGetText, Menus, Presence, Session, XMLUtils, JabberUtils, ExUtils,
    PrefController, PrefFile;

{---------------------------------------}
procedure TfrmPrefPresence.LoadPrefs();
var
    i, pos: integer;
    ws: TWidestringlist;
    cp: TJabberCustomPres;
    prefstate: TPrefState;

    procedure BrandShowOption(value: Widestring; brand: boolean);
    begin
        if brand then begin
            _show_list.Add(value);
            Inc(Pos);
        end else begin
            cboCPType.Items.Delete(Pos);
        end;
    end;
begin
    inherited;

    with MainSession.Prefs do begin
        // presence tracking
        i := GetInt('pres_tracking');
        if (i = 2) then
            rbNoPres.Checked := true
        else if (i = 1) then
            rbLastPres.Checked := true
        else
            rbAllPres.Checked := true;

        prefstate := getPrefState('pres_tracking');
        if (prefstate = psReadOnly) then
        begin
            rbNoPres.Enabled := false;
            rbLastPres.Enabled := false;
            rbAllPres.Enabled := false;
        end
        else if (prefstate = psInvisible) then begin
            ExGroupBox1.Visible := false;
        end;

        // Custom Presence options
        lstCustomPres.Items.Clear();
        //Setup visible show list
        if (_show_list = nil) then begin
            pos := 0;
            _show_list := TWideStringList.Create();
            BrandShowOption('chat', getBool('show_presence_menu_chat'));
            BrandShowOption('', getBool('show_presence_menu_available'));
            BrandShowOption('away', getBool('show_presence_menu_away'));
            BrandShowOption('xa', getBool('show_presence_menu_xa'));
            BrandShowOption('dnd', getBool('show_presence_menu_dnd'));
        end;

        ws := getAllPresence();
        _pres_list := TList.Create();

        for i := 0 to ws.Count - 1 do begin
            cp := TJabberCustomPres(ws.Objects[i]);
            if _show_list.IndexOf(cp.Show) = -1 then continue;
            lstCustomPres.Items.Add(cp.title);
            _pres_list.Add(cp);
        end;
    end;
end;

{---------------------------------------}
procedure TfrmPrefPresence.SavePrefs();
var
    i: integer;
    cp: TJabberCustomPres;
begin
    with MainSession.Prefs do begin
        i := 0;
        if (rbNoPres.Checked) then
            i := 2
        else if (rbLastPres.Checked) then
            i := 1;
        SetInt('pres_tracking', i);

        // Custom presence list
        RemoveAllPresence();
        for i := 0 to _pres_list.Count - 1 do begin
            cp := TJabberCustomPres(_pres_list.Items[i]);
            if (Trim(cp.title) = '') then
                cp.title := sPrefsDfltPres;
            setPresence(cp);
        end;
    end;

    inherited;
end;

{---------------------------------------}
procedure TfrmPrefPresence.clearPresList();
var
    i: integer;
begin
  inherited;
    for i := 0 to _pres_list.Count - 1 do
        TJabberCustomPres(_pres_list[i]).Free();
    _pres_list.Clear();
end;

{---------------------------------------}
procedure TfrmPrefPresence.FormDestroy(Sender: TObject);
begin
    inherited;
    clearPresList();
    _pres_list.Free();
    _show_list.Free();
end;

{---------------------------------------}
procedure TfrmPrefPresence.lstCustomPresClick(Sender: TObject);
var
    e: boolean;
    idx: integer;
begin
    // show the props of this presence object
    _no_pres_change := true;

    e := ((lstCustomPres.Items.Count > 0) and (lstCustomPres.ItemIndex >= 0));
    pnlProperties.Enabled := e;

    if (not e) then begin
        txtCPTitle.Text := '';
        txtCPStatus.Text := '';
        txtCPPriority.Text := '0';
    end
    else with TJabberCustomPres(_pres_list[lstCustomPres.ItemIndex]) do begin
        idx := _show_list.IndexOf(show);
        if idx <> -1 then begin
            cboCPType.ItemIndex := idx;
            txtCPTitle.Text := title;
            txtCPStatus.Text := status;
            txtCPPriority.Text := IntToStr(priority);
            txtCPHotkey.HotKey := TextToShortcut(hotkey);
        end;
    end;
    _no_pres_change := false;
end;

{---------------------------------------}
procedure TfrmPrefPresence.txtCPTitleChange(Sender: TObject);
var
    i, idx: integer;
    msg: WideString;
begin
    // something changed on the current custom pres object
    // automatically update it.
    if (lstCustomPres.ItemIndex < 0) then exit;
    if (_no_pres_change) then exit;

    i := lstCustomPres.ItemIndex;
    with  TJabberCustomPres(_pres_list[i]) do begin
        title := txtCPTitle.Text;
        status := txtCPStatus.Text;
        priority := SafeInt(txtCPPriority.Text);
        hotkey := ShortCutToText(txtCPHotkey.HotKey);
        show := _show_list[cboCPType.ItemIndex];
        if (title <> lstCustomPres.Items[i]) then
            lstCustomPres.Items[i] := title;
        if (isDuplicateHotKey(hotkey, idx)) then begin
          msg := WideFormat(_(sPrefsDupHotKey),[TJabberCustomPres(_pres_list[idx]).title]);
          MessageDlgW(msg, mtInformation, [mbOk], 0);
          hotkey := '';
          txtCPHotkey.HotKey := TextToShortcut(hotkey);
        end;

    end;
end;

function  TfrmPrefPresence.isDuplicateHotKey(key: WideString; out idx: integer): Boolean;
var
  i: Integer;
begin
  Result := false;
  idx := -1;
  for i := 0 to _pres_list.Count - 1 do
    begin
      if (TJabberCustomPres(_pres_list[i]).hotkey = key) and
         (i <> lstCustomPres.ItemIndex) and
         (TJabberCustomPres(_pres_list[i]).hotkey <> '') then begin
          Result := true;
          idx := i;
          exit;
      end;
    end;

end;

{---------------------------------------}
procedure TfrmPrefPresence.btnCustomPresAddClick(Sender: TObject);
var
    cp: TJabberCustomPres;
begin
    // add a new custom pres
    cp := TJabberCustomPres.Create();
    cp.title := sPrefsDfltPres;
    cp.show := '';
    cp.Status := '';
    cp.priority := 0;
    cp.hotkey := '';
    _pres_list.Add(cp);
    lstCustompres.Items.Add(cp.title);
    lstCustompres.ItemIndex := lstCustompres.Items.Count - 1;
    lstCustompresClick(Self);
end;

{---------------------------------------}
procedure TfrmPrefPresence.btnCustomPresRemoveClick(Sender: TObject);
var
    cp: TJabberCustomPres;
begin
    // delete the current pres
    if (lstCustomPres.ItemIndex >= 0) then begin
      cp := TJabberCustomPres(_pres_list[lstCustomPres.ItemIndex]);
      _pres_list.Remove(cp);
      lstCustompres.Items.Delete(lstCustomPres.ItemIndex);
      lstCustompresClick(Self);
      cp.Free();
    end;
end;

{---------------------------------------}
procedure TfrmPrefPresence.btnCustomPresClearClick(Sender: TObject);
begin
    // clear all entries
    if MessageDlgW(_(sPrefsClearPres), mtConfirmation, [mbYes, mbNo], 0) = mrNo then exit;

    lstCustomPres.Items.Clear;
    clearPresList();
    lstCustompresClick(Self);
    MainSession.Prefs.removeAllPresence();
end;

{---------------------------------------}
procedure TfrmPrefPresence.btnDefaultsClick(Sender: TObject);
begin
    if MessageDlgW(_(sPrefsDefaultPres), mtConfirmation, [mbYes, mbNo], 0) = mrNo then exit;
    MainSession.Prefs.setupDefaultPresence();
    LoadPrefs();
end;

end.
