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
unit PrefSystem;


interface

uses
    PrefPanel, 
    Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
    Dialogs, StdCtrls, TntStdCtrls, ExtCtrls, TntExtCtrls, XmlTag, ExGroupBox,
    TntForms, ExFrame, ExBrandPanel, ExNumericEdit;

type
  TfrmPrefSystem = class(TfrmPrefPanel)
    gbParentGroup: TExBrandPanel;
    ExGroupBox2: TExGroupBox;
    chkAutoStart: TTntCheckBox;
    gbOnStart: TExGroupBox;
    chkAutoLogin: TTntCheckBox;
    chkStartMin: TTntCheckBox;
    chkRestoreDesktop: TTntCheckBox;
    chkDebug: TTntCheckBox;
    ExGroupBox4: TExGroupBox;
    chkSaveWindowState: TTntCheckBox;
    pnlDockPref: TTntPanel;
    lblDockPref: TTntLabel;
    rbDocked: TTntRadioButton;
    rbUndocked: TTntRadioButton;
    ExGroupBox3: TExGroupBox;
    chkToolbox: TTntCheckBox;
    chkCloseMin: TTntCheckBox;
    chkSingleInstance: TTntCheckBox;
    chkOnTop: TTntCheckBox;
    pnlAutoUpdates: TTntPanel;
    chkAutoUpdate: TTntCheckBox;
    btnUpdateCheck: TTntButton;
    pnlLocale: TTntPanel;
    lblLang: TTntLabel;
    lblLangScan: TTntLabel;
    cboLocale: TTntComboBox;
    ExBrandPanel1: TExBrandPanel;
    btnPlugins: TTntButton;
    gbReconnect: TExGroupBox;
    pnlAttempts: TExBrandPanel;
    lblAttempts: TTntLabel;
    txtAttempts: TExNumericEdit;
    pnlTime: TExBrandPanel;
    lblTime: TTntLabel;
    lblTime2: TTntLabel;
    lblSeconds: TTntLabel;
    txtTime: TExNumericEdit;
    procedure btnPluginsClick(Sender: TObject);
    procedure btnUpdateCheckClick(Sender: TObject);
    procedure btnUpdateCheckMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure lblLangScanClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);override;
  private
    { Private declarations }
    _dirty_locale: Widestring;
    _old_locale: Widestring;
    _lang_codes: TStringlist;
    _initial_chkdebug_state: boolean;

    procedure ScanLocales();

    procedure setLocaleState();
  public
    { Public declarations }
    procedure LoadPrefs(); override;
    procedure SavePrefs(); override;
  end;

var
  frmPrefSystem: TfrmPrefSystem;

const
    sNoUpdate = 'No new update available.';
    sBadLocale = ' is set to use a language which is not available on your system. Resetting language to default.';
    sNewLocale1 = 'You must exit ';
    sNewLocale2 = ' and restart it before your new locale settings will take affect.';

    sStartCheckCaption = '&Start ';
    sOnStartedAppCaption = 'When I start ';
    
{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
implementation
{$WARNINGS OFF}
{$R *.dfm}
uses
    LocalUtils, JabberUtils, ExUtils,  GnuGetText,
    AutoUpdate, FileCtrl,
    PathSelector, PrefController, Registry, Session, StrUtils,
    jabber1, PrefFile, ManagePluginsDlg, Debug;

const
    RUN_ONCE : string = '\Software\Microsoft\Windows\CurrentVersion\Run';

{The system preferences page displays the following prefs:
    <auto_updates value="0" control="chkAutoUpdate" state="ro"/>
    <auto_start value="0" control="chkAutoStart"/>
    <debug value="0" control="chkDebug"/>
    <min_start value="0" control="chkStartMin"/>
    <autologin value="0" control="chkAutoLogin"/>
    <window_ontop value="0" control="chkOnTop" state="ro"/>
    <window_toolbox value="0" control="chkToolbox" state="ro"/>
    <close_min value="0" control="chkCloseMin" state="ro"/>
    <single_instance value="1" control="chkSingleInstance" state="ro"/>
    <default_nick control="txtDefaultNick" state="ro">
    	<control name="lblDefaultNick"/>
    </default_nick>
    <locale value="Default" state="inv"/>

}
{---------------------------------------}
procedure TfrmPrefSystem.ScanLocales();
var
    langs: TStringlist;
    mo, lm, lang, dir: Widestring;
    sr: TSearchRec;
    lang_name: string;
begin
    // scan .\locale\... for possible lang packs
    dir := ExtractFilePath(Application.EXEName) + '\locale';

    // look for subdirs in locale
    langs := TStringlist.Create();
    _lang_codes.Clear();
    _lang_codes.Add('Default');
    _lang_codes.Add('en');
    if (DirectoryExists(dir)) then begin
        if (FindFirst(dir + '\*.*', faDirectory, sr) = 0) then begin
            repeat
                // check for a LM_MESSAGES dir, and default.mo inside of it
                lang := dir + sr.Name;
                lm := lang + '\LC_MESSAGES';
                if (DirectoryExists(lm)) then begin
                    mo := lm + '\default.mo';
                    if (FileExists(mo)) then begin
                        _lang_codes.add(sr.Name);
                        lang_name := getLocaleName(sr.Name);
                        if (lang_name <> '') then
                            langs.add(lang_name)
                        else
                            langs.add(sr.Name);
                    end;
                end;
            until FindNext(sr) <> 0;
            FindClose(sr);
        end;
    end;
    cboLocale.Items.Clear();
    cboLocale.Items.Assign(langs);
    cboLocale.Items.Insert(0, 'Default');
    cboLocale.Items.Insert(1, 'English');
    FreeAndNil(langs);
end;

procedure TfrmPrefSystem.setLocaleState();
var
    i: integer;
    tmps: Widestring;
    temptag: TXmlTag;
begin
    try
        with MainSession.Prefs do begin
            // locale info, we should always have at least "default-english"
            // in the drop down box here.
            temptag := getXMLPref('locale');
            if (temptag = nil) then begin
                tmps := 'Default';
            end
            else begin
                tmps := temptag.GetAttribute('value');
                if (LowerCase(temptag.GetAttribute('state')) = 'inv') then begin
                    pnlLocale.Visible := false;
                    lblLang.Visible := false;
                    cboLocale.Visible := false;
                    lblLangScan.Visible := false;
                end;

                if (LowerCase(temptag.GetAttribute('state')) = 'ro') then begin
                    lblLang.Enabled := false;
                    cboLocale.Enabled := false;
                    lblLangScan.Enabled := false;
                end;
            end;

            // stay compatible with old prefs
            if (Pos('Default', tmps) = 1) then begin
                tmps := 'Default';
            end;
            _old_locale := tmps;
            _dirty_locale := tmps;

            if (tmps <> '') then begin
                i := _lang_codes.IndexOf(tmps);
                if (i >= 0) then
                    cboLocale.ItemIndex := i
                else begin
                    // check for en when given en_US
                    i := Pos('_', tmps);
                    if (i > 1) then begin
                        tmps := Copy(tmps, 1, i - 1);
                        i := _lang_codes.indexOf(tmps);
                    end;

                    if (i = -1) then begin
                        MessageDlgW(getAppInfo().ID +  _(sBadLocale), mtError, [mbOK], 0);
                        cboLocale.ItemIndex := 0;
                    end
                    else begin
                        _old_locale := tmps;
                        setString('locale', tmps);
                        cboLocale.ItemIndex := i;
                    end;
                end;
            end
            else
                cboLocale.ItemIndex := 0;
        end;
    finally
        temptag.Free();
    end;
end;

{---------------------------------------}
procedure TfrmPrefSystem.LoadPrefs();
var
    tmps: Widestring;
    reg: TRegistry;
    s: TPrefState;
begin
    // System Prefs
    _dirty_locale := '';
    if (_lang_codes = nil) then
        _lang_codes := TStringlist.Create();
    ScanLocales();

    inherited;

    setLocaleState();
    with MainSession.Prefs do begin

        //<<AUTO START>>
        s := PrefController.getPrefState('auto_start');
        chkAutoStart.Visible := (s <> psInvisible);
        chkAutoStart.Enabled := (s <> psReadOnly);
        if (s = psReadWrite) then begin
            // get auto-start from registry settings
            reg := TRegistry.Create();
            try
                reg.RootKey := HKEY_CURRENT_USER;
                reg.OpenKey(RUN_ONCE, true);
                chkAutoStart.Checked := (reg.ValueExists(PrefController.getAppInfo.ID));
                reg.CloseKey();
            finally
                reg.Free();
            end;
        end
        else chkAutoStart.Checked := GetBool('auto_start');

        //<<DEFAULT NICKNAME>>

        //<<AUTO LOGIN>> 
        //Auto login should not be enabled if password is not saved
        s := PrefController.getPrefState('autologin');
        chkAutoLogin.Enabled := (s <> psReadOnly) and
                                (s <> psInvisible) and
                                (MainSession.Profile.SavePasswd or MainSession.Profile.WinLogin or MainSession.Profile.x509Auth) and
                                MainSession.Authenticated;
        if (s = psInvisible) then begin
          chkAutoLogin.Visible := false;
        end;

        btnPlugins.Visible := GetBool('brand_plugs');
        
        //<<DEBUG>> enabled/visiblity already set in inherited, check branding override
        chkDebug.Visible := getBool('brand_show_debug_in_menu');

        //<<AUTO UPDATE>> hide panel if branded hidden
        pnlAutoUpdates.Visible := chkAutoUpdate.Visible;
        btnUpdateCheck.Enabled := chkAutoUpdate.enabled;

        //app name branding
        tmps := GetString('brand_caption');
        if (tmps = '') then
            tmps := _('Exodus');
        chkAutoStart.Caption := _(sStartCheckCaption + tmps);
        gbOnStart.Caption := _(sOnStartedAppCaption + tmps);

        //window dock pref
        rbDocked.Checked := GetBool('start_docked');
        rbUndocked.checked := not rbDocked.Checked;
        s := PrefController.getPrefState('start_docked');
        pnlDockPref.Visible := (s <> psInvisible);
        lblDockPref.Enabled := (s <> psReadOnly);
        rbDocked.Enabled := lblDockPref.Enabled;
        rbUndocked.Enabled := lblDockPref.Enabled;

        if (StrToInt(txtAttempts.Text) < 0) then txtAttempts.Text := '3';
    end;
    gbParentGroup.checkAutoHide();
end;

{---------------------------------------}
procedure TfrmPrefSystem.SavePrefs();
var
    reg: TRegistry;
    tmp, cmd: Widestring;
    i: integer;
begin
    // System Prefs
    inherited;

    // Show the debug window if "show on startup" is selected and
    // wasn't selected when the prefs window was created.
    if (chkDebug.Checked) then begin
        if (_initial_chkdebug_state = false) then begin
            if (not isDebugShowing()) then begin
                frmExodus.ShowXML1Click(nil);
            end;
            _initial_chkdebug_state := true;
        end
    end
    else
        _initial_chkdebug_state := false;


    with MainSession.Prefs do begin
        i := cboLocale.ItemIndex;
        if (i < 0) then i := 0;
        tmp := _lang_codes[i];

        if (tmp <> _dirty_locale) then begin
            _dirty_locale := tmp;
            MessageDlgW(_(sNewLocale1) + getAppInfo().ID +  _(sNewLocale2), mtInformation, [mbOK], 0);
        end;

        setString('locale', tmp);
        
        reg := TRegistry.Create();
        try
            reg.RootKey := HKEY_CURRENT_USER;
            reg.OpenKey(RUN_ONCE, true);

            if (not chkAutoStart.Checked) then begin
                if (reg.ValueExists(PrefController.getAppInfo.ID)) then
                    reg.DeleteValue(PrefController.getAppInfo.ID);
            end
            else begin
                cmd := '"' + ParamStr(0) + '"';
                for i := 1 to ParamCount do
                    cmd := cmd + ' "' + ParamStr(i) + '"';
                reg.WriteString(PrefController.getAppInfo.ID,  cmd);
            end;
            reg.CloseKey();
        finally
            reg.Free();
        end;

        SetBool('start_docked', rbDocked.Checked);
    end;
end;

{---------------------------------------}
procedure TfrmPrefSystem.btnPluginsClick(Sender: TObject);
begin
    inherited;
    ManagePluginsDlg.showManagePluginDlg(Self);
end;

procedure TfrmPrefSystem.btnUpdateCheckClick(Sender: TObject);
var
    available : boolean;
begin
    Screen.Cursor := crHourGlass;
    available := InitAutoUpdate(false);
    Screen.Cursor := crDefault;

    if (not available) then
        MessageDlgW(_(sNoUpdate), mtInformation, [mbOK], 0);
end;

{---------------------------------------}
procedure TfrmPrefSystem.btnUpdateCheckMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
    if (ssShift in Shift) or (ssCtrl in Shift) then begin
        MainSession.Prefs.setDateTime('last_update', Now());
    end;
end;

{---------------------------------------}

procedure TfrmPrefSystem.lblLangScanClick(Sender: TObject);
begin
  inherited;
    ScanLocales();
end;

procedure TfrmPrefSystem.FormCreate(Sender: TObject);
begin
    inherited;
    AssignUnicodeURL(lblLangScan.Font, 8);
    _initial_chkdebug_state := MainSession.Prefs.getBool('debug');

    btnUpdateCheck.Visible := chkAutoUpdate.Visible;
    btnUpdateCheck.Enabled := chkAutoUpdate.Enabled;
end;

end.
