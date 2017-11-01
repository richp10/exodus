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
unit Prefs;


interface

uses
    // panels
    PrefPanel, PrefSystem, PrefRoster,  
    PrefMsg, PrefNotify, PrefAway, PrefPresence, PrefTransfer,
    PrefHotkeys, PrefDisplay,

    // other stuff
    Menus, ShellAPI, Unicode,
    Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
    ComCtrls, StdCtrls, ExtCtrls, buttonFrame, CheckLst,
    ExRichEdit, Dialogs, RichEdit2, TntStdCtrls, TntComCtrls, TntExtCtrls, ExForm,
    ExGraphicButton, TntForms, ExFrame, ExBrandPanel, ExGradientPanel;

type
  TfrmPrefs = class(TExForm)
    Panel1: TPanel;
    btnOK: TTntButton;
    btnCancel: TTntButton;
    Button6: TTntButton;
    ExGradientPanel1: TExGradientPanel;
    imgSystem: TExGraphicButton;
    imgContactList: TExGraphicButton;
    imgDisplay: TExGraphicButton;
    imgNotifications: TExGraphicButton;
    imgMessages: TExGraphicButton;
    imgAutoAway: TExGraphicButton;
    imgPresence: TExGraphicButton;
    imgHotKeys: TExGraphicButton;
    pcPrefs: TTntPageControl;
    tsSystem: TTntTabSheet;
    tsContactList: TTntTabSheet;
    tsDisplay: TTntTabSheet;
    tsNotifications: TTntTabSheet;
    tsMessages: TTntTabSheet;
    tsAutoAway: TTntTabSheet;
    tsPresence: TTntTabSheet;
    tsHotKeys: TTntTabSheet;
    ScrollBox1: TScrollBox;
    procedure memKeywordsKeyPress(Sender: TObject; var Key: Char);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure TabSelect(Sender: TObject);
    procedure frameButtons1btnOKClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    _lastSelButton: TExGraphicButton;

    _system: TfrmPrefSystem;
    _roster: TfrmPrefRoster;
    _display: TfrmPrefDisplay;
    _message: TfrmPrefMsg;
    _notify: TfrmPrefNotify;
    _away: TfrmPrefAway;
    _pres: TfrmPrefPresence;
//    _xfer: TfrmPrefTransfer;
    _hotkeys: TfrmPrefHotkeys;

    _defaultPage: TExGraphicButton;
  public
    { Public declarations }
    procedure LoadPrefs;
    procedure SavePrefs;
  end;

var
  frmPrefs: TfrmPrefs;

const
    pref_system = 'system';
    pref_roster = 'roster';
    pref_display = 'display';
    pref_notify = 'notify';
    pref_msgs = 'msgs';
    pref_away = 'away';
    pref_pres = 'presence';
    pref_hotkeys = 'hotkeys';


procedure StartPrefs(start_page: string = '');
function IsRequiredPluginsSelected(): WordBool;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
implementation

{$R *.DFM}
{$WARN UNIT_PLATFORM OFF}

uses
    GnuGetText, PrefController, Session, ExUtils, Room, JabberUtils,
    PrefFile;

{---------------------------------------}
procedure StartPrefs(start_page: string);
var
    s: TExGraphicButton;
    f: TfrmPrefs;
begin
    if ((MainSession.Active) and (not MainSession.Authenticated)) then exit;

    f := TfrmPrefs.Create(nil);
    f.LoadPrefs;

    if (start_page = pref_roster) then s := f.imgContactList
    else if (start_page = pref_display) then s := f.imgDisplay
    else if (start_page = pref_notify) then s := f.imgNotifications
    else if (start_page = pref_msgs) then s := f.imgMessages
    else if (start_page = pref_away) then s := f.imgAutoAway
    else if (start_page = pref_pres) then s := f.imgPresence
    else if (start_page = pref_hotkeys) then s := f.imgHotkeys
    else s := f.imgSystem;

    if (not s.Visible) then
        s := f._defaultPage;
        
    f.TabSelect(s);
    f.ShowModal;
    f.Free();
end;

function IsRequiredPluginsSelected(): WordBool;
var
  plugins_selected: TWideStringlist;
  plugins_required: TWideStringlist;
  i,j: integer;
  plugins_msg : WideString;
begin
   Result := true;

   plugins_selected := TWideStringlist.Create();
   plugins_required := TWideStringlist.Create();
   with Mainsession.Prefs do
   begin
      fillStringList('plugin_selected',plugins_selected);
      fillStringList('brand_required_plugins',plugins_required);
      plugins_msg := getString('brand_required_plugins_message');
      if (plugins_msg = '' )  then
        plugins_msg := 'This installation is not in compliance with Instant Messaging Policy: A mandatory component %s has been disabled.';

   end;

   for i := 0 to plugins_required.Count - 1 do
   begin
       j := plugins_selected.IndexOf(plugins_required[i]);
       if ( j < 0 ) then
       begin
         plugins_msg := WideFormat(plugins_msg, [plugins_required[i]]);
         MessageDlgW(_(plugins_msg),mtWarning, [mbOK], 0);
         Result := false;
       end;
   end;

   plugins_required.Free();
   plugins_selected.Free();

end;
{---------------------------------------}
procedure TfrmPrefs.LoadPrefs;
begin
end;


procedure TfrmPrefs.memKeywordsKeyPress(Sender: TObject; var Key: Char);
begin
end;

{---------------------------------------}
procedure TfrmPrefs.SavePrefs;
begin
    // save prefs to the reg
    with MainSession.Prefs do begin
        BeginUpdate();

        // Iterate over all the panels we have
        if (_roster <> nil) then
            _roster.SavePrefs();

        if (_system <> nil) then
            _system.SavePrefs();

        if (_display <> nil) then
            _display.SavePrefs();

        if (_message <> nil) then
            _message.SavePrefs();

        if (_notify <> nil) then
            _notify.SavePrefs();

        if (_away <> nil) then
            _away.SavePrefs();

        if (_pres <> nil) then
            _pres.SavePrefs();

        if (_hotkeys <> nil) then
            _hotkeys.SavePrefs();

        endUpdate();
    end;
    MainSession.FireEvent('/session/prefs', nil);
end;

{---------------------------------------}
procedure TfrmPrefs.FormClose(Sender: TObject; var Action: TCloseAction);
begin

  if ( (MainSession.Prefs.getBool('brand_plugs') = true) and
       (IsRequiredPluginsSelected() = false)) then
  begin
    Action := caNone;
    exit;
  end;

//    MainSession.Prefs.SavePosition(Self);
    Action := caFree;
end;

{---------------------------------------}
procedure TfrmPrefs.FormCreate(Sender: TObject);
begin
    // Setup some fonts
    AssignUnicodeFont(Self);

    TranslateComponent(Self);

    // Load the system panel


    // branding
    { JJF fix this
    with (MainSession.Prefs) do begin
        imgTransfer.Visible := getBool('brand_ft');
        lblTransfer.Visible := getBool('brand_ft');
        imgPlugins.Visible := getBool('brand_plugs');
        lblPlugins.Visible := getBool('brand_plugs');
    end;
     }
    // Init all the other panels
    _system := nil;
    _roster := nil;
    _display := nil;
    _message := nil;
    _notify := nil;
    _away := nil;
    _pres := nil;
    _hotkeys := nil;
    _lastSelButton := nil;
    pcPrefs.Visible := false;
    _defaultPage := nil;

    //map or graphics to pages
    imgSystem.Target := tsSystem;
    imgSystem.Visible := MainSession.Prefs.getBool('show_system_preferences');
    imgContactList.Target := tsContactList;
    imgContactList.Visible := MainSession.Prefs.getBool('show_contact_list_preferences');
    imgDisplay.Target := tsDisplay;
    imgDisplay.Visible := MainSession.Prefs.getBool('show_display_preferences');
    imgNotifications.Target := tsNotifications;
    imgNotifications.Visible := MainSession.Prefs.getBool('show_notification_preferences');
    imgMessages.Target := tsMessages;
    imgMessages.Visible := MainSession.Prefs.getBool('show_message_preferences');
    imgAutoAway.Target := tsAutoAway;
    imgAutoAway.Visible := MainSession.Prefs.getBool('show_auto_away_preferences');
    imgPresence.Target := tsPresence;
    imgPresence.Visible := MainSession.Prefs.getBool('show_presence_preferences');
    imgHotKeys.Target := tsHotKeys;
    if ((not MainSession.Prefs.getBool('show_hot_key_preferences')) or
        (getPrefState('hotkeys_keys') = psInvisible) or
        (getPrefState('hotkeys_text') = psInvisible)) then begin
        imgHotKeys.Visible := false;
    end
    else begin
        imgHotKeys.Visible := true;
    end;

    //pick a default page...
    if (imgSystem.Visible) then
        _defaultPage := imgSystem
    else if (imgContactList.Visible) then
        _defaultPage := imgContactList
    else if (imgDisplay.Visible) then
        _defaultPage := imgDisplay
    else if (imgNotifications.Visible) then
        _defaultPage := imgNotifications
    else if (imgMessages.Visible) then
        _defaultPage := imgMessages
    else if (imgAutoAway.Visible) then
        _defaultPage := imgAutoAway
    else if (imgPresence.Visible) then
        _defaultPage := imgPresence
    else if (imgHotKeys.Visible) then
        _defaultPage := imgHotKeys;

    pcPrefs.Visible := (_defaultPage <> nil);

//    MainSession.Prefs.RestorePosition(Self);
end;

{---------------------------------------}
procedure TfrmPrefs.TabSelect(Sender: TObject);
var
    f: TfrmPrefPanel;
begin
    f := nil;
    if ((Sender = nil) or (not (Sender is TExGraphicButton))) then exit; //paranoid


    if (Sender = imgSystem)  then begin
        if (_system = nil) then begin
            _system := TfrmPrefSystem.Create(Self);
            _system.parent := tsSystem;
        end;
        f := _system;
    end
    else if (Sender = imgContactList)then begin
        if (_roster = nil) then begin
            _roster := TfrmPrefRoster.Create(Self);
            _roster.parent := tsCOntactList;
        end;
        f := _roster;
    end
    else if (Sender = imgDisplay) then begin
        if (_display = nil) then begin
            _display := TfrmPrefDisplay.Create(Self);
            _display.parent := tsDisplay;
        end;
        f := _display;
    end
    else if (Sender = imgMessages) then begin
        if (_message = nil) then begin
            _message := TfrmPrefMsg.Create(Self);
            _message.parent := tsMessages;
        end;
        f := _message;
    end
    else if (Sender = imgNotifications) then begin
        if (_notify = nil) then begin
            _notify := TfrmPrefNotify.Create(Self);
            _notify.parent := tsNotifications;
        end;
        f := _notify;
    end
    else if (Sender = imgAutoAway)then begin
        if (_away = nil) then begin
            _away := TfrmPrefAway.Create(Self);
            _away.parent := tsAutoAway;
        end;
        f := _away;
    end
    else if (Sender = imgPresence) then begin
        if (_pres = nil) then begin
            _pres := TfrmPrefPresence.Create(Self);
            _pres.parent := tsPresence;
        end;
        f := _pres;
    end
    else if (Sender = imgHotkeys)then begin
        if (_hotkeys = nil) then begin
            _hotkeys := TfrmPrefHotkeys.Create(Self);
            _hotKeys.parent := tsHotKeys;
        end;
        f := _hotkeys;
    end;

    // setup the panel..
    if (f <> nil) then begin

        if (_lastSelButton <> nil) then begin
            _lastSelButton.Selected := false;
            TTabSheet(_lastSelButton.Target).Visible := false;
        end;

        _lastSelButton := TExGraphicButton(Sender);
        _lastSelButton.Selected := true;
        
        f.Align := alClient;
        f.Visible := true;
        pcPrefs.Visible := false;
        TTabSheet(_lastSelButton.Target).Visible := true;
        TTabSheet(_lastSelButton.Target).BringToFront();
        pcPrefs.ActivePage := TTabSheet(_lastSelButton.Target);
        pcPrefs.Visible := true;
        pcPrefs.BringToFront();        
    end;
end;

{---------------------------------------}
procedure TfrmPrefs.frameButtons1btnOKClick(Sender: TObject);
begin
    SavePrefs;
    Self.BringToFront();
end;

{---------------------------------------}
procedure TfrmPrefs.FormDestroy(Sender: TObject);
begin
    // destroy all panels we have..
    _system.Free();
    _roster.Free();
    _display.Free();
    _message.Free();
    _notify.Free();
    _away.Free();
    _pres.Free();
    _hotkeys.Free();
end;

{---------------------------------------}
procedure TfrmPrefs.FormShow(Sender: TObject);
begin
    if (_lastSelButton = nil) then
        TabSelect(_defaultPage);
    if (Self.Height > (Self.Monitor.Height - 30)) then
    begin
        Self.Top := 0;
        Self.Height := Self.Monitor.Height - 30; //little breathing room
        //inc width by scrollbar width
        Self.Width := Self.Width + Self.VertScrollBar.ThumbSize;
    end;
    if (Self.width > Self.Monitor.width) then
    begin
        Self.Left := 0;
        Self.width := Self.Monitor.width;
    end;        
end;

end.

