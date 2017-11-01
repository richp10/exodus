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
unit Notify;


interface

uses
    XMLTag, Presence, Forms;
type
    TPresNotifier = class
    private
        _presCallback: longint;
    public
        constructor Create;
        destructor Destroy; override;

        procedure PresCallback(event: string; tag: TXMLTag; p: TJabberPres);
    end;

const
    // image index for tab notification.
    tab_notify = 42;

procedure DoNotify(win: TForm; notify: integer; msg: Widestring; icon: integer;
    sound_name: string); overload;
procedure DoNotify(win: TForm; pref_name: string; msg: Widestring; icon: integer); overload;

procedure StartFlash(win: TForm);
procedure StopFlash(win: TForm);

{check to see if notification should be allowed. notify flags may be changed
 if only some notifications are allowed}
function AllowNotifications(win: TForm; notifyType: widestring; var notifyEvents: integer): boolean;

implementation
uses
    Windows, MMSystem,
    Sysutils,
    Exodus_TLB, COMExodusItem,
    contnrs, Classes,
    JabberID, Dockable, RosterImages, StateForm, DisplayName,
    ExUtils, GnuGetText, Jabber1, PrefController, RiserWindow, debug, Session;

const
    sNotifyOnline = ' is now online.';
    sNotifyOffline = ' is now offline.';

    IE_PROP_IMAGEPREFIX = 'ImagePrefix';

    SOUND_OPTIONS = SND_FILENAME or SND_ASYNC or SND_NOWAIT or SND_NODEFAULT;

var
    _flashList: TStringList;  //list of flashing window handles

{---------------------------------------}
constructor TPresNotifier.Create();
begin
    inherited;
    _presCallback := MainSession.RegisterCallback(PresCallback);
end;

{---------------------------------------}
destructor TPresNotifier.Destroy;
begin
    MainSession.UnRegisterCallback(_presCallback);
    inherited;
end;

{---------------------------------------}
procedure TPresNotifier.PresCallback(event: string; tag: TXMLTag; p: TJabberPres);
var
    ImageIndex: integer;
    nick, notifyMessage, notifyType: Widestring;
    tjid: TJabberID;
    Item: IExodusItem;
    notifyEvents: integer;
begin
    //bail if we have not yet received a roster
    //bail if the event is one we are notifying about
    if ((event <> '/presence/online') and
        (event <> '/presence/offline')) then
        exit;

    tjid := TJabberID.Create(tag.GetAttribute('from'));
    try
        //bail if blocked
        if (MainSession.IsBlocked(tjid.jid)) then
            exit;

        Item := MainSession.ItemController.GetItem(tjid.jid);
        //bail if not in roster or not a contact
        if (Item = nil) or (Item.Type_ <> EI_TYPE_CONTACT) then
            exit;
        nick := DisplayName.getDisplayNameCache().getDisplayName(tjid);
    finally
        tjid.Free();
    end;

    // someone is coming online for the first time..
    if (event = '/presence/online') then
    begin
        ImageIndex := GetPresenceImage('available', Item.value[IE_PROP_IMAGEPREFIX]);
        notifyMessage := sNotifyOnline;
        notifyType := 'notify_online';
    end
    else begin// someone is going offline
        ImageIndex := GetPresenceImage('offline', Item.value[IE_PROP_IMAGEPREFIX]);
        notifyMessage := sNotifyOffline;
        notifyType := 'notify_offline';
    end;
    notifyEvents := MainSession.Prefs.getInt(notifyType);
    //presence notifcations allow only toast, sound and tray flash
    notifyEvents := (notifyEvents and notify_toast) or
                    (notifyEvents and notify_tray) or
                    (notifyEvents and notify_sound);

    //let notify route where events should happen
    DoNotify(nil, notifyEvents, nick + _(notifyMessage), ImageIndex, notifyType);
end;

function GetTopForm(f: TForm): TCustomForm;
begin
    //get the topmost parent form of win
    Result := Forms.GetParentForm(f, true);
    if (Result = nil) then
        Result := f;
end;

procedure StartFlash(win: TForm);
var
    fi: TFlashWInfo;
    tf: TCustomForm;
begin
    //get the topmost parent form of win
    tf := GetTopForm(win);

    if (_flashList.indexOf(inttostr(tf.Handle)) <> -1) then exit; //already flashing this window

    if (not tf.Showing) then
    begin
        tf.WindowState := wsMinimized;
        tf.Visible := true;
        ShowWindow(tf.Handle, SW_SHOWMINNOACTIVE);
    end;

    //check flasher pref to see if tf should be flashed once or flashed until focused
    if (not MainSession.Prefs.getBool('notify_flasher')) then
        FlashWindow(tf.Handle, false)
    else begin
//debug.DebugMessage('start flashing actual window: ' + inttostr(tf.Handle) + ', class: ' + tf.ClassName);
        _flashList.add(inttostr(tf.Handle));
        fi.hwnd:= tf.Handle;
        fi.dwFlags := FLASHW_TIMER + FLASHW_ALL;
        fi.dwTimeout := 0;
        fi.uCount := 999999999;  //this should not be needed but there ya go
        fi.cbSize:=SizeOf(fi);
        FlashWindowEx(fi);
    end;
end;

procedure StopFlash(win: TForm);
var
    fi: TFlashWInfo;
    tf: TCustomForm;
    idx: integer;
begin
    tf := GetTopForm(win);

    idx := _flashList.indexOf(inttostr(tf.Handle));
    if (idx = -1) then exit; //not flashing

//debug.DebugMessage('stop flashing actual window: ' + inttostr(tf.Handle) + ', class: ' + tf.ClassName);
    _flashList.Delete(idx);

    fi.hwnd:= tf.Handle;
    fi.dwFlags := FLASHW_STOP;
    fi.dwTimeout := 0;
    fi.cbSize:=SizeOf(fi);

    FlashWindowEx(fi);
end;


{check to see if notification should be allowed. notify event flags may be changed
 if only some notifications are allowed (usually type specific)}
function AllowNotifications(win: TForm; notifyType: widestring; var notifyEvents: integer): boolean;
var
    fw: THandle;
begin
    Result := false;
    //if we have no notifications, we are done
    if (notifyEvents = 0) then exit;

    //if suspending on DND and dnd, we are done
    if (MainSession.prefs.getBool('suspend_dnd_notifications') and (MainSession.Show = 'dnd'))  then exit;

    //check active prefs if app is active and we are not bring to front
    if (((notifyEvents and notify_front) = 0) and Application.Active) then
    begin
        //notify active app, we are active app -> notify
        //notify active app, we are not active app -> notify
        //do not notify active app, we are not active app -> notify
        //do not notify active app, we are active app -> bail (no notify)
        if (not MainSession.prefs.getBool('notify_active')) then exit;

        //notify active window, we are active window -> notify
        //notify active window, we are not active window -> notify
        //don't notify active window, we aren't active window -> notify
        //don't notify active window, we are active window -> bail (no notify)
        if (not MainSession.prefs.getBool('notify_active_win')) then
        begin
            fw := GetForegroundWindow();

            //floating window
            if (fw = win.handle) then exit;

            //docked, top docked and dock window is forground
            if ((GetDockManager().GetTopDocked() = win) and
               (fw = GetDockManager().getHWND())) then
                exit;

            //remove flash if dock manager is forground window, perform
            //all other notifications
            if (fw = GetTopForm(win).Handle) and
               ((notifyEvents and notify_flash) = notify_flash) then
                notifyEvents := notifyEvents xor notify_flash; //remove it
        end;
    end;
    Result := true;
end;

procedure HandleNotifications(win: TForm;
                              notify: integer;
                              msg: Widestring;
                              icon: integer;
                              prefKey: string);
var
    sndFN: string;
    cdir: widestring;
begin

    if ((notify and notify_toast) <> 0) then
        ShowRiserWindow(win, msg, icon);

    if ((notify and notify_front) <> 0) then
    begin
        //make sure window is visible
        if (not win.Showing) then
        begin
            win.Visible := true;
            ShowWindow(win.handle, SW_SHOW)
        end;
        ForceForegroundWindow(win.Handle);
    end
    else begin //tray and flash alert only if not bringtofront
        if ((notify and notify_tray) <> 0) then
            StartTrayAlert();

        if ((notify and notify_flash) <> 0) then
            StartFlash(win);
    end;

    if ((notify and notify_sound) <> 0) and
        (MainSession.prefs.getBool('notify_sounds')) then
    begin
        sndFN := MainSession.Prefs.GetSoundFile(prefKey);
        if (sndFN <> '') then
        begin
            //set the current directory to applications,
            //allows relative paths for sound files
            cdir := ExtractFilePath(Application.EXEName);
            SetCurrentDirectoryW(PWideChar(cdir));
            PlaySound(pchar(sndFN), 0, SOUND_OPTIONS);
        end;
    end;
end;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
procedure DoNotify(win: TForm;
                   notify: integer;
                   msg: Widestring;
                   icon: integer;
                   sound_name: string);
begin
    //map nil windows back to the main window
    if (win = nil) then
        win := Application.MainForm;
        
    if (not AllowNotifications(win, sound_name, notify)) then
        exit;

    //pass off bring to front and flash to better handlers if we can
    if ((notify and notify_front) or (notify and notify_flash) <> 0) and
        (win is TfrmState) then
    begin
        TfrmState(win).OnNotify((notify and notify_front) or (notify and notify_flash));
        //remove bring to front and flash, assume stateform took care of them
        notify := notify - ((notify and notify_front) or (notify and notify_flash));
    end;
    HandleNotifications(win, notify, msg, icon, sound_name);
end;

{---------------------------------------}
procedure DoNotify(win: TForm; pref_name: string; msg: Widestring; icon: integer);
begin
    DoNotify(win, MainSession.Prefs.getInt(pref_name), msg, icon, pref_name);
end;

initialization
    _flashList := TStringList.create();
finalization
    _flashList.free();
end.
