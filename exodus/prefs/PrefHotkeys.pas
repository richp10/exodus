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
unit PrefHotkeys;



interface

uses
    Unicode, PrefPanel,
    Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
    Dialogs, StdCtrls, TntStdCtrls, ExtCtrls, TntExtCtrls, ComCtrls,
    TntComCtrls, ModifyHotkeys, TntForms, ExFrame, ExBrandPanel;

type
  TfrmPrefHotkeys = class(TfrmPrefPanel)
    pnlContainer: TExBrandPanel;
    TntLabel1: TTntLabel;
    lstHotkeys: TTntListView;
    btnModifyHotkeys: TTntButton;
    btnAddHotkeys: TTntButton;
    btnRemoveHotkeys: TTntButton;
    btnClearAll: TTntButton;
    procedure btnClearAllClick(Sender: TObject);
    procedure btnRemoveHotkeysClick(Sender: TObject);
    procedure lstHotkeysSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure btnAddHotkeysClick(Sender: TObject);
    procedure btnModifyHotkeysClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    function MenuShortCutExists(value: integer): boolean;
    procedure _set_AvailableHotkeys();
    procedure _set_usedkeys(hotkey: Widestring; value: boolean);

  public
    { Public declarations }
    procedure LoadPrefs(); override;
    procedure SavePrefs(); override;

  public
    _used_hotkeys: array[1..12] of boolean;
    _hotkeys_keys: TWidestringlist;
    _hotkeys_text: TWidestringlist;

  end;

var
  frmPrefHotkeys: TfrmPrefHotkeys;

const
    sNoUpdate = 'No new update available.';
    sBadLocale = ' is set to use a language which is not available on your system. Resetting language to default.';
    sNewLocale1 = 'You must exit ';
    sNewLocale2 = ' and restart it before your new locale settings will take affect.';
    sAddHotkey = 'Add Hotkey';

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
implementation
{$WARNINGS OFF}
{$R *.dfm}
uses
    LocalUtils, JabberUtils, ExUtils,  GnuGetText,
    AutoUpdate, FileCtrl,
    PathSelector, PrefController, PrefFile, Registry, Session, StrUtils,
    Menus, Jabber1;

{---------------------------------------}
procedure TfrmPrefHotkeys.btnAddHotkeysClick(Sender: TObject);
var
    dlg: TfrmModifyHotkeys;
    i: Integer;
    item: TTntListItem;
begin
    dlg := TfrmModifyHotkeys.Create(Self.Owner);
    dlg.Position := poOwnerFormCenter;
    dlg.Caption := _(sAddHotkey);
    for i := 1 to 12 do begin
        if (not _used_hotkeys[i]) then begin
            case i of
            1:  dlg.cbhotkey.AddItem('F01', nil);
            2:  dlg.cbhotkey.AddItem('F02', nil);
            3:  dlg.cbhotkey.AddItem('F03', nil);
            4:  dlg.cbhotkey.AddItem('F04', nil);
            5:  dlg.cbhotkey.AddItem('F05', nil);
            6:  dlg.cbhotkey.AddItem('F06', nil);
            7:  dlg.cbhotkey.AddItem('F07', nil);
            8:  dlg.cbhotkey.AddItem('F08', nil);
            9:  dlg.cbhotkey.AddItem('F09', nil);
            10: dlg.cbhotkey.AddItem('F10', nil);
            11: dlg.cbhotkey.AddItem('F11', nil);
            12: dlg.cbhotkey.AddItem('F12', nil);
            end;
        end;
    end;

    dlg.cbhotkey.ItemIndex := 0;

    btnModifyHotkeys.Enabled := false;
    btnRemoveHotkeys.Enabled := false;
    lstHotkeys.ClearSelection;

    if (dlg.ShowModal() = mrCancel) then
        exit;

    item := lstHotkeys.Items.Add();
    item.Caption := dlg.cbhotkey.Text;
    item.SubItems.Add(dlg.txtHotkeyMessage.Text);
    
    _set_usedkeys(item.Caption, true);

    lstHotkeys.AlphaSort();
    //see if we have too many hotkeys to allow for more.
    btnAddHotkeys.Enabled := false;
    for i := 1 to 12 do begin
        if (not _used_hotkeys[i]) then begin
            btnAddHotkeys.Enabled := true;
        end;
    end;
end;

procedure TfrmPrefHotkeys.btnModifyHotkeysClick(Sender: TObject);
var
    dlg: TfrmModifyHotkeys;
    i: Integer;
    item: TTntListItem;
begin
    dlg := TfrmModifyHotkeys.Create(Self);
    dlg.Position := poOwnerFormCenter;

    for i := 1 to 12 do begin
        if (not _used_hotkeys[i]) then begin
            case i of
            1:  dlg.cbhotkey.AddItem('F01', nil);
            2:  dlg.cbhotkey.AddItem('F02', nil);
            3:  dlg.cbhotkey.AddItem('F03', nil);
            4:  dlg.cbhotkey.AddItem('F04', nil);
            5:  dlg.cbhotkey.AddItem('F05', nil);
            6:  dlg.cbhotkey.AddItem('F06', nil);
            7:  dlg.cbhotkey.AddItem('F07', nil);
            8:  dlg.cbhotkey.AddItem('F08', nil);
            9:  dlg.cbhotkey.AddItem('F09', nil);
            10: dlg.cbhotkey.AddItem('F10', nil);
            11: dlg.cbhotkey.AddItem('F11', nil);
            12: dlg.cbhotkey.AddItem('F12', nil);
            end;
        end;
    end;

    dlg.cbhotkey.AddItem(lstHotkeys.Selected.Caption, nil);

    for i := 0 to dlg.cbhotkey.Items.count - 1 do begin
        if (Widestring(dlg.cbhotkey.Items[i]) = lstHotkeys.Selected.Caption) then
            dlg.cbhotkey.ItemIndex := i;
    end;


    dlg.txtHotkeyMessage.Text := Widestring(lstHotkeys.Selected.Subitems[0]);

    btnModifyHotkeys.Enabled := false;
    btnRemoveHotkeys.Enabled := false;
    item := lstHotkeys.Selected;
    
    lstHotkeys.ClearSelection;

    if (dlg.ShowModal() = mrCancel) then
        exit;

    _set_usedkeys(item.Caption, false);
    item.Caption := dlg.cbhotkey.Text;
    item.Subitems.Strings[0] := dlg.txtHotkeyMessage.Text;
    _set_usedkeys(item.Caption, true);

    lstHotkeys.AlphaSort();
end;

procedure TfrmPrefHotkeys.btnRemoveHotkeysClick(Sender: TObject);
begin
    btnAddHotkeys.Enabled := true;
    _set_usedkeys(lstHotkeys.Selected.Caption, false);
    lstHotkeys.Selected.Delete();
    btnRemoveHotkeys.Enabled := false;
    btnModifyHotkeys.Enabled := false;
end;

procedure TfrmPrefHotkeys.btnClearAllClick(Sender: TObject);
var
    i: integer;
begin
    inherited;
    for i := lstHotKeys.Items.Count - 1 downto 0 do begin
        _set_usedkeys(lstHotkeys.items[i].Caption, false);
        lstHotkeys.items[i].Delete();
    end;
    btnAddHotkeys.Enabled := true;
    btnRemoveHotkeys.Enabled := false;
    btnModifyHotkeys.Enabled := false;
end;


procedure TfrmPrefHotkeys.FormDestroy(Sender: TObject);
begin
  inherited;

    if (_hotkeys_keys <> nil) then
        _hotkeys_keys.Free();
    if (_hotkeys_text <> nil) then
        _hotkeys_text.Free();

    _hotkeys_keys := nil;
    _hotkeys_text := nil;
end;

procedure TfrmPrefHotkeys.LoadPrefs();
var
    i: integer;
    item: TTntListItem;
    s1, s2: TPrefState;
begin
    if (_hotkeys_keys = nil) then
        _hotkeys_keys := TWidestringlist.Create();

    if (_hotkeys_text = nil) then
        _hotkeys_text := TWidestringlist.Create();

    // System Prefs
    lstHotkeys.Clear();
    _hotkeys_text.clear();
    _hotkeys_keys.clear();

    MainSession.Prefs.fillStringlist('hotkeys_keys', _hotkeys_keys);
    MainSession.Prefs.fillStringlist('hotkeys_text', _hotkeys_text);

    if (_hotkeys_keys.Count = _hotkeys_text.Count) then begin
        for i := 0 to _hotkeys_keys.count - 1 do begin
            item := lstHotkeys.Items.Add();
            item.Caption := _hotkeys_keys.Strings[i];
            item.SubItems.Add(_hotkeys_text.Strings[i]);
            _set_usedkeys(_hotkeys_keys.Strings[i], true);
        end;

        _set_AvailableHotkeys;

        btnAddHotkeys.Enabled := false;
        for i := 1 to 12 do begin
            if (not _used_hotkeys[i]) then begin
                btnAddHotkeys.Enabled := true;
                break;
            end;
        end;
    end;
    btnRemoveHotkeys.Enabled := false;
    btnModifyHotkeys.Enabled := false;
    
    pnlContainer.CaptureChildStates(); //capture disabled states on mod/remove
    // Finally check state and set controls accordingly
    // If either keys or text are RO or INV, don't allow anything to be set/removed
    s1 := getPrefState('hotkeys_keys');
    s2 := getPrefState('hotkeys_text');
    pnlContainer.Enabled := ((s1 <> psReadOnly) and (s2 <> psReadOnly));
    pnlContainer.Visible := ((s1 <> psInvisible) and (s2 <> psInvisible));
end;

procedure TfrmPrefHotkeys.lstHotkeysSelectItem(Sender: TObject; Item: TListItem;
  Selected: Boolean);
begin
  inherited;
    if (Selected) then begin
        btnRemoveHotkeys.Enabled := true;
        btnModifyHotkeys.Enabled := true;
    end
    else begin
        btnRemoveHotkeys.Enabled := false;
        btnModifyHotkeys.Enabled := false;
    end;
end;

{---------------------------------------}
procedure TfrmPrefHotkeys.SavePrefs();
var
    i: integer;
begin
    // System Prefs
    for i := 0 to _hotkeys_keys.count - 1 do begin
        MainSession.Prefs.RemoveStringlistValue('hotkeys_keys', _hotkeys_keys.Strings[i]);
        MainSession.Prefs.RemoveStringlistValue('hotkeys_text', _hotkeys_text.Strings[i]);
    end;

    _hotkeys_keys.Clear();
    _hotkeys_text.Clear();

    for i := 0 to lstHotkeys.items.Count - 1 do begin
        _hotkeys_keys.Add(lstHotkeys.Items[i].Caption);
        _hotkeys_text.Add(WideString(lstHotkeys.Items[i].SubItems[0]));
    end;
    MainSession.Prefs.setStringlist('hotkeys_keys', _hotkeys_keys);
    MainSession.Prefs.setStringlist('hotkeys_text', _hotkeys_text);
end;

procedure TfrmPrefHotkeys._set_usedkeys(hotkey: Widestring; value: boolean);
begin
    if (hotkey = 'F01') then
        _used_hotkeys[1] := value
    else if (hotkey = 'F02') then
        _used_hotkeys[2] := value
    else if (hotkey = 'F03') then
        _used_hotkeys[3] := value
    else if (hotkey = 'F04') then
        _used_hotkeys[4] := value
    else if (hotkey = 'F05') then
        _used_hotkeys[5] := value
    else if (hotkey = 'F06') then
        _used_hotkeys[6] := value
    else if (hotkey = 'F07') then
        _used_hotkeys[7] := value
    else if (hotkey = 'F08') then
        _used_hotkeys[8] := value
    else if (hotkey = 'F09') then
        _used_hotkeys[9] := value
    else if (hotkey = 'F10') then
       _used_hotkeys[10] := value
    else if (hotkey = 'F11') then
        _used_hotkeys[11] := value
    else if (hotkey = 'F12') then
        _used_hotkeys[12] := value
end;

procedure TfrmPrefHotkeys._set_AvailableHotkeys();
begin
    // This function will set the available hotkeys (F1-F12) based
    // on which keys are used for menus, which take priority over
    // hotkeys

    if (MenuShortCutExists(TextToShortCut('F1'))) then
        _used_hotkeys[1] := true;
    if (MenuShortCutExists(TextToShortCut('F2'))) then
        _used_hotkeys[2] := true;
    if (MenuShortCutExists(TextToShortCut('F3'))) then
        _used_hotkeys[3] := true;
    if (MenuShortCutExists(TextToShortCut('F4'))) then
        _used_hotkeys[4] := true;
    if (MenuShortCutExists(TextToShortCut('F5'))) then
        _used_hotkeys[5] := true;
    if (MenuShortCutExists(TextToShortCut('F6'))) then
        _used_hotkeys[6] := true;
    if (MenuShortCutExists(TextToShortCut('F7'))) then
        _used_hotkeys[7] := true;
    if (MenuShortCutExists(TextToShortCut('F8'))) then
        _used_hotkeys[8] := true;
    if (MenuShortCutExists(TextToShortCut('F9'))) then
        _used_hotkeys[9] := true;
    if (MenuShortCutExists(TextToShortCut('F10'))) then
        _used_hotkeys[10] := true;
    if (MenuShortCutExists(TextToShortCut('F11'))) then
        _used_hotkeys[11] := true;
    if (MenuShortCutExists(TextToShortCut('F12'))) then
        _used_hotkeys[12] := true;
end;

function TfrmPrefHotkeys.MenuShortCutExists(value: integer): boolean;
    function MenuShortCutExistsRecurse(value: integer; menuItem: TMenuItem): boolean;
    var
        i: integer;
    begin
        if (menuItem.ShortCut = value) then
            Result := true
        else if (menuItem.Count > 0) then begin
            for i := 0 to menuItem.Count - 1 do begin
                Result := MenuShortCutExistsRecurse(value, menuItem.Items[i]);
                if (Result) then Exit;                
            end;
        end
        else
            Result := false;
    end;
var
    i: integer;
begin
    for i := 0 to frmExodus.MainMenu1.Items.Count - 1 do begin
        Result := MenuShortCutExistsRecurse(value, frmExodus.MainMenu1.Items[i]);
        if (Result) then Exit;
    end;
end;

end.
