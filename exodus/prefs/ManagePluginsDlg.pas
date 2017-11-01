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
unit ManagePluginsDlg;


interface

uses
    Unicode,
    Windows,
    Messages,
    SysUtils,
    Variants,
    Classes,
    Graphics,
    Controls,
    Forms,
    Dialogs,
    PrefPanel,
    ComCtrls,
    TntComCtrls,
    StdCtrls,
    TntStdCtrls,
    ExtCtrls,
    TntExtCtrls,
    ExForm;

type
  TfrmPrefPlugins = class(TExForm)
    Label6: TTntLabel;
    lblPluginScan: TTntLabel;
    btnConfigPlugin: TTntButton;
    txtPluginDir: TTntEdit;
    btnBrowsePluginPath: TTntButton;
    lstPlugins: TTntListView;
    btnCancel: TTntButton;
    btnOK: TTntButton;
    procedure btnOKClick(Sender: TObject);
    procedure TntFormCreate(Sender: TObject);
    procedure lstPluginsSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure btnBrowsePluginPathClick(Sender: TObject);
    procedure lblPluginScanClick(Sender: TObject);
    procedure btnConfigPluginClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }

    procedure scanPlugins();
    procedure savePlugins();
    procedure scanPluginDir(selected: TWidestringList);

  public
    { Public declarations }
    procedure LoadPrefs();
    procedure SavePrefs();
  end;

type
    TRegProc = function: HResult; stdcall;

const
    sRegPluginError = 'The plug-in could not be registered with windows.';
    sExternalLibrary = 'External Library';
    sPluginChangeWarning = 'Changes to plug-ins require a restart before being active.';

procedure showManagePluginDlg(AOwner: TComponent);

implementation
{$R *.dfm}
uses
    ActiveX,
    COMController,
    ComObj,
    Exodus_TLB,
    JabberUtils,
    ExUtils,
    GnuGetText,
    PathSelector,
    Registry,
    Session,
    PrefController,
    BrowseForFolderU,
    ShellAPI;

procedure showManagePluginDlg(AOwner: TComponent);
var
    td: TfrmPrefPlugins;
begin
    td := TfrmPrefPlugins.create(AOwner);
    td.ShowModal();
    td.Free();
end;

{---------------------------------------}
procedure TfrmPrefPlugins.LoadPrefs();
var
    dir: Widestring;
begin
    with MainSession.Prefs do begin
        // plugins
        dir := getString('plugin_dir');
        if (dir = '') then
            dir := ExtractFilePath(Application.ExeName) + 'plugins';

        if (not DirectoryExists(dir)) then
            dir := ExtractFilePath(Application.ExeName) + 'plugins';

        txtPluginDir.Text := dir;
        scanPlugins();
     end;
end;

procedure TfrmPrefPlugins.lstPluginsSelectItem(Sender: TObject; Item: TListItem;
  Selected: Boolean);
begin
  inherited;
  if (lstPlugins.Selected <> nil) then
    btnConfigPlugin.Enabled := IsPluginConfigurable(lstPlugins.Selected.Caption);
end;

{---------------------------------------}
procedure TfrmPrefPlugins.SavePrefs();
begin
    with MainSession.Prefs do begin
        // Plugins
        setString('plugin_dir', txtPluginDir.Text);
        savePlugins();
    end;
end;

{---------------------------------------}
procedure TfrmPrefPlugins.scanPlugins();
var
    sl: TWidestringList;
    i: integer;
begin
    // load the listview
    lstPlugins.Clear();

    // get the list of selected plugins..
    sl := TWidestringList.Create();

    for i := 0 to plugs.Count - 1 do begin
        sl.Add(plugs[i]);
    end;

    // Scan the director
    scanPluginDir(sl);

    btnConfigPlugin.Enabled := false; // no item selected when rescaned.

    sl.Free();
end;

procedure TfrmPrefPlugins.TntFormCreate(Sender: TObject);
begin
    inherited;
    LoadPrefs();
end;

{---------------------------------------}
procedure TfrmPrefPlugins.savePlugins();
var
    i: integer;
    item: TTntListItem;
    newenabledplugs: TWidestringlist;
    currentplugs: TWidestringlist;
    listchanged: boolean;
    idx: integer;
begin
    // save all "checked" captions
    newenabledplugs := TWidestringlist.Create();
    currentplugs := TWidestringlist.Create();
    listchanged := false;

    //All we need to do here is to build the list of selected plug-ins
    //We do NOT load or register them here.
    //Plugins only load on startup.
    for i := 0 to lstPlugins.Items.Count - 1 do begin
        item := lstPlugins.Items[i];

        if (item.Checked) then begin
            // save the Classname
            newenabledplugs.Add(item.Caption);
        end;
    end;

    // Get list of current loaded plugins
    for i := 0 to plugs.count - 1 do begin
        currentplugs.Add(plugs[i]);
    end;

    // See if all enabled plugs are in current plugs list
    for i := 0 to newenabledplugs.count - 1 do begin
        if (currentplugs.Find(newenabledplugs[i], idx)) then begin
            currentplugs.Delete(idx);
        end
        else begin
            // Not in current loaded plugs, so things changed
            listchanged := true;
            break;
        end;
    end;

    // If any plugs in current list that aren't found in the check above,
    // must be new
    if (currentplugs.Count > 0) then begin
        listchanged := true;
    end;

    // If the list changed, save list and ask for restart.
    if (listchanged) then begin
        // save out plugins to prefs file for loading next time.
        MainSession.Prefs.setStringlist('plugin_selected', newenabledplugs);

        MessageBoxW(Self.Handle,
                    pWideChar(_(sPluginChangeWarning)),
                    pWideChar(Self.Caption),
                    MB_OK or MB_ICONWARNING);
    end;

    // cleanup
    newenabledplugs.Free();
    currentplugs.Free();
end;

{---------------------------------------}
procedure TfrmPrefPlugins.scanPluginDir(selected: TWidestringList);
var
    dir: Widestring;
    sr: TSearchRec;
    idx: integer;
    item: TTntListItem;
    dll, progID, doc: WideString;
    reg: TRegistry;
    values: TStrings;
    i: integer;
begin
    dir := txtPluginDir.Text;
    if (not DirectoryExists(dir)) then exit;
    if (FindFirst(dir + '\\*.dll', faAnyFile, sr) = 0) then begin
        repeat
            dll := dir + '\' + sr.Name;
            if (CheckPluginDll(dll, progID, doc)) then begin
                item := lstPlugins.Items.Add();
                item.Caption := progID;
                item.SubItems.Add(doc);
                item.SubItems.Add(dll);

                // check to see if this is selected
                idx := selected.IndexOf(item.Caption);
                item.Checked := (idx >= 0);
            end;
        until FindNext(sr) <> 0;
        FindClose(sr);
    end;

    reg := TRegistry.Create();
    reg.RootKey := HKEY_CURRENT_USER;
    reg.OpenKey('\Software\Jabber\' + PrefController.GetAppInfo().ID + '\Plugins', true);
    values := TStringList.Create();
    reg.GetValueNames(values);
    for i := 0 to values.Count - 1 do begin
        item := lstPlugins.Items.Add();
        item.Caption := values[i];
        item.SubItems.Add(reg.ReadString(values[i]));
        item.SubItems.Add(sExternalLibrary);

        // check to see if this is selected
        idx := selected.IndexOf(item.Caption);
        item.Checked := (idx >= 0);
    end;
    values.Free();
    reg.Free();
end;

{---------------------------------------}
procedure TfrmPrefPlugins.btnBrowsePluginPathClick(Sender: TObject);
var
    p: String;
begin
    // Change the plugin dir
    p := txtPluginDir.Text;
    if (not DirectoryExists(p)) then
        p := '';

    p := BrowseForFolder(_('Select Plugins Directory'), p);
    if (p <> '') then begin
        if (p <> txtPluginDir.Text) then begin
            txtPluginDir.Text := p;
            scanPlugins();
        end;
    end;
end;

{---------------------------------------}
procedure TfrmPrefPlugins.lblPluginScanClick(Sender: TObject);
begin
    inherited;
    scanPlugins();
end;

{---------------------------------------}
procedure TfrmPrefPlugins.btnConfigPluginClick(Sender: TObject);
var
    li: TListItem;
    com_name: string;
begin
    li := lstPlugins.Selected;
    if (li = nil) then exit;
    com_name := li.Caption;
    ConfigurePlugin(com_name);
end;

procedure TfrmPrefPlugins.btnOKClick(Sender: TObject);
begin
    inherited;
    SavePrefs();
end;

procedure TfrmPrefPlugins.FormCreate(Sender: TObject);
begin
  inherited;
    AssignUnicodeURL(lblPluginScan.Font, 8);
    btnConfigPlugin.Enabled := false;
end;

end.
