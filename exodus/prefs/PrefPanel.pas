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
unit PrefPanel;


interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, TntExtCtrls, ExForm, StdCtrls, TntStdCtrls;

type
  TfrmPrefPanel = class(TExForm)
    pnlHeader: TTntPanel;
    lblHeader: TTntLabel;
    procedure FormCreate(Sender: TObject); virtual;
  private
    { Private declarations }
    procedure loadPrefsOwner(owner: TWinControl);
    procedure savePrefsOwner(owner: TWinControl);
  public
    { Public declarations }
    procedure LoadPrefs(); virtual;
    procedure SavePrefs(); virtual;
  end;

var
  frmPrefPanel: TfrmPrefPanel;

implementation

{$R *.dfm}

uses
    Menus, ComCtrls, TntComCtrls,
    Session, PrefFile, PrefController, GnuGetText, JabberUtils, ExUtils,  XMLUtils,
    ExNumericEdit,
    ExbrandPanel,
    ExCheckGroupBox;

procedure TfrmPrefPanel.LoadPrefs();
begin
    loadPrefsOwner(Self);
end;

procedure TfrmPrefPanel.SavePrefs();
begin
    savePrefsOwner(Self);
end;

procedure TfrmPrefPanel.loadPrefsOwner(owner: TWinControl);
var
    s: TPrefState;
    p, sval: Widestring;
    c: TControl;
    i: integer;
begin
    // auto-load prefs based on controls and their types.
    for i := 0 to Owner.ControlCount - 1 do begin
        c := owner.Controls[i];
        p := MainSession.Prefs.getPref(c.name);

        if (p = '') or (c.InheritsFrom(TExBrandPanel))then begin
            if (c.inheritsFrom(TWinControl)) then
                loadPrefsOwner(TWinControl(c));
            if (p = '') then continue;
        end;

        s := getPrefState(p);
        sval := MainSession.Prefs.getString(p);

        // Do stuff based on the controls type
        if (c.inheritsFrom(TTntCheckBox)) then
            TCheckBox(c).Checked := SafeBool(sval)
        else if (c.InheritsFrom(TExCheckGroupBox)) then
            TExCheckGroupBox(c).Checked := SafeBool(sval)
        else if ((c.inheritsFrom(TUpDown)) or (c.inheritsFrom(TTntUpDown))) then
            TUpDown(c).Position := SafeInt(sval)
        else if (c.inheritsFrom(TExNumericEdit)) then
            TExNumericEdit(c).Text := sval
        else if (c.inheritsFrom(TTntComboBox)) then begin
            if (TTntComboBox(c).Style = csDropDown) then
                TTntComboBox(c).Text := sval
            else
                TTntComboBox(c).ItemIndex := SafeInt(sval);
        end
        else if (c.inheritsFrom(TColorBox)) then
            TColorBox(c).Selected := TColor(SafeInt(sval))
        else if (c.inheritsFrom(TTrackBar)) then
            TTrackBar(c).Position := SafeInt(sval)
        else if (c.inheritsFrom(THotKey)) then
            THotkey(c).HotKey := TextToShortcut(sval)
        else if (c.inheritsFrom(TTntRadioGroup)) then
            TTntRadioGroup(c).ItemIndex := SafeInt(sval)
        else if (c.inheritsFrom(TTntEdit)) then
            TTntEdit(c).Text := sval
        else if ((c.inheritsFrom(TTntLabel)) or
                 (c.inheritsFrom(TLabel))) then
            // do nothing
        else if ((c.InheritsFrom(TTntButton)) or
                 (c.InheritsFrom(TButton))) then
            // do nothing
        else begin
            exit;
//            assert(false);
        end;

        // Make sure to set state for this control
        if (s = psReadOnly) then begin
            c.enabled := false;
            if (c.inheritsFrom(TTntEdit)) then
                TTntEdit(c).ReadOnly := true;
        end
        else if (s = psInvisible) then
            c.visible := false;

    end;
end;

procedure TfrmPrefPanel.savePrefsOwner(owner: TWinControl);
var
    c: TControl;
    i: integer;
    p: Widestring;
    s: TPrefState;
begin
    for i := 0 to owner.ControlCount - 1 do begin
        c := owner.Controls[i];
        p := MainSession.Prefs.getPref(c.name);

        // only update if this the primary control, and we have a pref
        //this might be a "checkable" group box so drill down and check children
        if (p = '') or (c.InheritsFrom(TExBrandPanel))then begin
            if (c.inheritsFrom(TWinControl)) then
                savePrefsOwner(TWinControl(c));
            if (p = '') then continue;
        end;

        if (AnsiCompareText(c.name, MainSession.Prefs.getControl(p)) <> 0) then
            continue;

        // don't bother w/ RO or INV prefs
        s := getPrefState(p);
        if ((s = psReadOnly) or (s = psInvisible)) then continue;

        if (c.inheritsFrom(TTntCheckBox)) then
            MainSession.Prefs.setBool(p, TCheckBox(c).Checked)
        else if (c.InheritsFrom(TExCheckGroupBox)) then
            MainSession.Prefs.setBool(p, TExCheckGroupBox(c).Checked)
        else if ((c.inheritsFrom(TUpDown)) or (c.inheritsFrom(TTntUpDown))) then
            MainSession.Prefs.setInt(p, TUpDown(c).Position)
        else if (c.inheritsFrom(TExNumericEdit)) then
            MainSession.Prefs.setInt(p, StrToInt(TExNumericEdit(c).Text))
        else if (c.inheritsFrom(TTntComboBox)) then begin
            if (TTntComboBox(c).Style = csDropDown) then
                MainSession.Prefs.setString(p, TTntComboBox(c).Text)
            else
                MainSession.Prefs.setInt(p, TTntComboBox(c).ItemIndex);
        end
        else if (c.inheritsFrom(TColorBox)) then
            MainSession.Prefs.setInt(p, integer(TColorBox(c).Selected))
        else if (c.inheritsFrom(TTrackBar)) then
            MainSession.Prefs.setInt(p, TTrackBar(c).Position)
        else if (c.inheritsFrom(THotKey)) then
            MainSession.Prefs.setString(p, ShortcutToText(THotKey(c).Hotkey))
        else if (c.inheritsFrom(TTntRadioGroup)) then
            MainSession.Prefs.setInt(p, TTntRadioGroup(c).ItemIndex)
        else if (c.inheritsFrom(TTntEdit)) then
            MainSession.Prefs.setString(p, TTntEdit(c).Text);
    end;
end;

procedure TfrmPrefPanel.FormCreate(Sender: TObject);
begin
    AssignUnicodeFont(Self, 8);
    AssignUnicodeHighlight(pnlHeader.Font, 10);
    TranslateComponent(Self);
    LoadPrefs();
end;

end.
