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
unit DockWindow;



interface

uses
  Windows, Messages, SysUtils,
  Variants, Classes, Graphics,
  Controls, Forms, Dialogs,
  ExForm, Dockable, TntComCtrls,
  ComCtrls, ExtCtrls, TntExtCtrls,
  ExodusDockManager, StdCtrls,
  ExGradientPanel, AWItem, Unicode,
  StateForm, XMLTag,
  FrmUtils;

type

  TSortState = (ssUnsorted, ssAlpha, ssRecent, ssType, ssUnread);

  TfrmDockWindow = class(TfrmState, IExodusDockManager)
    splAW: TTntSplitter;
    AWTabControl: TPageControl;
    pnlActivityList: TPanel;
    pnlTabControl: TPanel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure AWTabControlDockDrop(Sender: TObject; Source: TDragDockObject; X,
      Y: Integer);
    procedure AWTabControlUnDock(Sender: TObject; Client: TControl;
      NewTarget: TWinControl; var Allow: Boolean);
    procedure FormShow(Sender: TObject);
    procedure WMActivate(var msg: TMessage); message WM_ACTIVATE;
    procedure FormDockDrop(Sender: TObject; Source: TDragDockObject; X,
      Y: Integer);
    Procedure WMSyscommand(Var msg: TWmSysCommand); message WM_SYSCOMMAND;
    procedure FormResize(Sender: TObject);
    procedure OnMove(var Msg: TWMMove); message WM_MOVE;
    procedure FormHide(Sender: TObject);
    procedure pnlTabControlResize(Sender: TObject);
  private
    { Private declarations }
    _dockState: TDockStates;
    _sortState: TSortState;
    _glueEdge: TGlueEdge;
    _glueRange: integer;
    _undocking: boolean;
    _sessionCB: integer;
    _suppressShow: boolean;

    procedure _layoutDock();
    procedure _layoutAWOnly();
    procedure _saveDockWidths();
    procedure _needToBeShowingCheck();
    procedure _glueCheck();
    function _canShowWindow(): boolean;

  protected
    { Protected declarations }
    procedure CreateParams(Var params: TCreateParams); override;

  public
    { Public declarations }

    // IExodusDockManager interface
    procedure CloseDocked(frm: TfrmDockable);
    function OpenDocked(frm : TfrmDockable) : TTntTabSheet;
    procedure FloatDocked(frm : TfrmDockable);
    function GetDockSite() : TWinControl;
    procedure BringDockedToTop(form: TfrmDockable);
    function getTopDocked(): TfrmDockable;
    procedure SelectNext(goforward: boolean; visibleOnly:boolean=false);
    procedure OnNotify(frm: TfrmDockable; notifyEvents: integer);reintroduce; overload;
    procedure UpdateDocked(frm: TfrmDockable);

    procedure BringToFront();
    function isActive(): boolean;
    function getHWND(): THandle;
    function ShowDockManagerWindow(Show: boolean = true; BringWindowToFront: boolean = true): boolean;

    function getTabSheet(frm : TfrmDockable) : TTntTabSheet;
    function getTabForm(tab: TTabSheet): TForm;
    procedure updateLayoutDockChange(frm: TfrmDockable; docking: boolean; FirstOrLastDock: boolean);
    procedure setWindowCaption(txt: widestring);
    procedure moveGlued();
    procedure SessionCallback(event: string; tag: TXMLTag);
    function GetActiveTabSheet(): TTntTabSheet;
    procedure changeGotoActivityWindowButton();

    property glueEdge: TGlueEdge read _glueEdge write _glueEdge;
  end;

var
  frmDockWindow: TfrmDockWindow;
  dockWindowKBHook: HHook; {this intercepts keyboard input}

  function dockWindowKeyboardHookProc(code: Integer; wParam: Word; lParam: LongInt): LongInt; stdcall;

const
    ACTIVITYLIST_CAPTION = 'Activity List';

implementation

uses
    RosterForm,
    Session,
    PrefController,
    ActivityWindow,
    Jabber1,
    ExUtils,
    ExSession,
    Notify,
    gnugettext;

{$R *.dfm}

{---------------------------------------}
function dockWindowKeyboardHookProc(code: Integer; wParam: Word; lParam: LongInt) : LongInt;
var
    keyUp: boolean;
    ctrl_down: boolean;
    shift_down: boolean;
    aw: TfrmActivityWindow;
begin
    // To prevent Windows from passing the keystrokes
    // to the target window, the Result value must
    // be a nonzero value.
    Result:=0;

    if (code < 0) then begin
        // MUST call CallNextHookEx according to MSDN
        Result := CallNextHookEx(dockWindowKBHook, code, wParam, lParam);
    end
    else begin
        case Code of
            HC_ACTION: begin
                keyUp := ((lParam and (1 shl 31)) <> 0);

                // Is the Control key pressed
                if ((GetKeyState(VK_CONTROL) and (1 shl 15)) <> 0) then begin
                    ctrl_down := true;
                end
                else begin
                    ctrl_down := false;
                end;
                // Is the Shift key pressed
                if ((GetKeyState(VK_SHIFT) and (1 shl 15)) <> 0) then begin
                    shift_down := true;
                end
                else begin
                    shift_down := false;
                end;

                if (keyUP) then begin
                    // Only process on KeyUp as we can get many
                    // KeyDowns, but only one KeyUp per press.
                    case wParam of
                        VK_TAB: begin
                            if ((ctrl_down) and (not shift_down)) then begin
                                // Doing a Ctrl-Tab, so go to next item
                                aw := GetActivityWindow();
                                if (aw <> nil) then begin
                                    aw.selectNextItem();
                                end;
                                Result := 1;
                            end
                            else if ((ctrl_down) and (shift_down)) then begin
                                // Doing a Ctrl-Shift-Tab, so go to prev item
                                aw := GetActivityWindow();
                                if (aw <> nil) then begin
                                    aw.selectPrevItem();
                                end;
                                Result := 1;
                            end;
                        end;
                    end;
                end
                else begin
                    // KeyDown event
                    // We don't want to do anything here, but we do want to capture event
                    // so as to possibly not pass onthe key down.
                    case wParam of
                        VK_TAB: begin
                            if (ctrl_down) then begin
                                // Doing a Ctrl-Tab of some version, so mark as
                                // handled (non-zero result), don't pass on.
                                Result := 1;
                            end;
                        end;
                        VK_ESCAPE: begin
                            if (MainSession.Prefs.getBool('esc_close')) then
                            begin
                                // Request to close active tab
                                aw := GetActivityWindow();
                                if ((aw <> nil) and
                                    (aw.dockwindow <> nil) and
                                    (aw.dockwindow.Focused())) then
                                begin
                                    aw.closeActiveDockedWindow();
                                    Result := 1;
                                end;
                            end;
                        end;
                    end;
                end;
            end;
            HC_NOREMOVE: begin
              {This is a keystroke message, but the keystroke message}
              {has not been removed from the message queue, since an}
              {application has called PeekMessage() specifying PM_NOREMOVE}
              Result := 0;
              exit;
            end;
        end;
    end;
end;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
procedure TfrmDockWindow.FormCreate(Sender: TObject);
begin
    inherited;
    pnlActivityList.Constraints.MinWidth := MainSession.Prefs.getInt('activity_list_split_min_width');
    
    setWindowCaption('');
    _dockState := dsUninitialized;
    _sortState := ssUnsorted;
    _glueEdge := geNone;
    _undocking := false;
    dockWindowKBHook := SetWindowsHookEx(WH_KEYBOARD, @dockWindowKeyboardHookProc, HInstance, GetCurrentThreadId()) ;

    _sessionCB := MainSession.RegisterCallback(SessionCallback, '/session');

    Self.RestoreWindowState();

    if ((MainSession.Prefs.getInt(PrefController.P_ACTIVITY_WINDOW_WIDTH) = 0) and
        (MainSession.Prefs.getInt(PrefController.P_ACTIVITY_WINDOW_TAB_WIDTH) = 0)) then begin
        // If both settings are 0, then this must be the first time ever
        // activity window has been ever created and thus we need to preset
        // these items.
        Self.Height := 557; // Match Jabber1 height with first time startup.
        Self.Width  := 185;
        MainSession.Prefs.setInt(PrefController.P_ACTIVITY_WINDOW_WIDTH, 185);
        MainSession.Prefs.setInt(PrefController.P_ACTIVITY_WINDOW_TAB_WIDTH, 450);
    end;

    _layoutAWOnly();

    // Determine glue range
    if (MainSession.Prefs.getBool('glue_activity_window')) then begin
        _glueRange := MainSession.Prefs.getInt('glue_activity_window_range');
    end
    else begin
        _glueRange := -1;
    end;
end;

{---------------------------------------}
procedure TfrmDockWindow.FormDestroy(Sender: TObject);
begin
    inherited;
    MainSession.UnRegisterCallback(_sessionCB);
    _sessionCB := -1;
    UnHookWindowsHookEx(dockWindowKBHook);
end;

{---------------------------------------}
procedure TfrmDockWindow.CreateParams(Var params: TCreateParams);
begin
    // Make this window show up on the taskbar
    inherited CreateParams( params );
    params.ExStyle := params.ExStyle or WS_EX_APPWINDOW;
    params.WndParent := GetDesktopwindow;
end;

{---------------------------------------}
procedure TfrmDockWindow.CloseDocked(frm: TfrmDockable);
var
    aw: TfrmActivityWindow;
    item: TAWTrackerItem;
begin
    if (frm = nil) then exit;

    try
        aw := GetActivityWindow();
        if (aw <> nil) then begin
            item := aw.findItem(frm);
            aw.removeItem(item);
        end;

        if (frm.Docked) then begin
            updateLayoutDockChange(frm, true, AWTabControl.PageCount = 1);
        end;

        _needToBeShowingCheck();
    except
    end;
end;

{---------------------------------------}
function TfrmDockWindow.OpenDocked(frm : TfrmDockable) : TTntTabSheet;
begin
    if (not Self.Showing) then begin
        ShowDockManagerWindow(true, false);
    end;
    frm.ManualDock(AWTabControl); //fires TabsDockDrop event
    setWindowCaption(frm.Caption);
    Result := GetTabSheet(frm);
    frm.Visible := true;
end;

{---------------------------------------}
procedure TfrmDockWindow.pnlTabControlResize(Sender: TObject);
begin
    // This hides the tabs.  If we try to hide
    // tabs via the TabVisible property on the
    // tab sheets, we see poor redraw behavior.
    // Hiding the tabs off the top of the screen
    // seems to make a more visual pleaseing
    // experience.
    inherited;
    AWTabControl.Top := -1 * AWTabControl.TabHeight;
    AWTabControl.Height := pnlTabControl.ClientHeight + AWTabControl.TabHeight;
    AWTabControl.Left := 0;
    AWTabControl.Width := pnlTabControl.ClientWidth;
end;

{---------------------------------------}
procedure TfrmDockWindow.FloatDocked(frm : TfrmDockable);
begin
    frm.ManualFloat(frm.FloatPos);
end;

{---------------------------------------}
procedure TfrmDockWindow.FormDockDrop(Sender: TObject; Source: TDragDockObject;
  X, Y: Integer);
begin
    if (Source.Control is TfrmDockable) then begin
        // We got a new form dropped on us.
        OpenDocked(TfrmDockable(Source.Control));
    end;
end;

{---------------------------------------}
procedure TfrmDockWindow.FormHide(Sender: TObject);
begin
    inherited;
    frmExodus.mnuWindows_View_ShowActivityWindow.Checked := false;
end;

{---------------------------------------}
procedure TfrmDockWindow.FormResize(Sender: TObject);
begin
    inherited;
    Self.Constraints.MaxWidth := 0;
end;

{---------------------------------------}
procedure TfrmDockWindow.FormShow(Sender: TObject);
var
    aw: TfrmActivityWindow;
begin
    inherited;
    aw := GetActivityWindow();
    if (aw <> nil) and (not aw.docked)then begin
        aw.DockActivityWindow(pnlActivityList);
        aw.dockwindow := Self;
        aw.Show;
        aw.OnDockDrop := FormDockDrop;
    end;
    frmExodus.mnuWindows_View_ShowActivityWindow.Checked := true;
    frmExodus.mnuWindows_View_ShowActivityWindow.Enabled := true;
    frmExodus.trayShowActivityWindow.Enabled := true;
    frmExodus.btnActivityWindow.Enabled := true;
    frmExodus.trayShowActivityWindow.Enabled := true;

    _glueCheck();
end;

{---------------------------------------}
function TfrmDockWindow.GetDockSite() : TWinControl;
begin
    if (Self.DockSite) then
        Result := Self
    else
        Result := nil;
end;

{---------------------------------------}
procedure TfrmDockWindow.AWTabControlDockDrop(Sender: TObject;
  Source: TDragDockObject; X, Y: Integer);
begin
    // We got a new form dropped on us.
    if (Source.Control is TfrmDockable) then begin
        _undocking := false;
        updateLayoutDockChange(TfrmDockable(Source.Control), true, false);
        TTntTabSheet(AWTabControl.Pages[AWTabControl.PageCount - 1]).ImageIndex := TfrmDockable(Source.Control).ImageIndex;
        TfrmDockable(Source.Control).OnDocked();

        if (Self.WindowState = wsMaximized) then begin
            Self.Top := Self.Monitor.WorkareaRect.Top;
            Self.Left := Self.Monitor.WorkareaRect.Top;
            Self.Height := Self.Monitor.WorkareaRect.Bottom - Self.Monitor.WorkareaRect.Top;
            Self.Width := Self.Monitor.WorkareaRect.Right - Self.Monitor.WorkareaRect.Left;
        end;
    end;
end;

{---------------------------------------}
procedure TfrmDockWindow.AWTabControlUnDock(Sender: TObject;
  Client: TControl; NewTarget: TWinControl; var Allow: Boolean);
begin
    // check to see if the tab is a frmDockable
    Allow := true;
    if ((Client is TfrmDockable) {and TfrmDockable(Client).Docked})then begin
        setWindowCaption('');
        _undocking := true;
        CloseDocked(TfrmDockable(Client));
        TfrmDockable(Client).OnFloat();
        _undocking := false;
    end;
end;

{---------------------------------------}
procedure TfrmDockWindow.BringDockedToTop(form: TfrmDockable);
var
    tsheet: TTntTabSheet;
begin
    if (Self.AWTabControl.PageCount > 0) then begin
        tsheet := GetTabSheet(form);
        if (tsheet <> nil) then begin
            Self.AWTabControl.ActivePage := tsheet;
            if (Self.Active)  then            
                form.gotActivate();
        end;
    end;
end;

{---------------------------------------}
function TfrmDockWindow.getTopDocked() : TfrmDockable;
var
    top : TForm;
    i: integer;
begin
    Result := nil;
    // Find the visible tab as we cannot use ActivePage reliably with hidden tabs
    for i := 0 to AWTabControl.PageCount - 1 do begin
        if (AWTabControl.Pages[i].Visible) then begin
            top := getTabForm(AWTabControl.Pages[i]);
            if ((top is TfrmDockable) and (TfrmDockable(top).Docked)) then begin
                Result := TfrmDockable(top);
                exit;
            end;
        end;
    end;
end;

{---------------------------------------}
procedure TfrmDockWindow.SelectNext(goforward: boolean; visibleOnly:boolean=false);
begin
    AWTabControl.SelectNextPage(goforward, visibleonly);
end;

{---------------------------------------}
procedure TfrmDockWindow.OnNotify(frm: TfrmDockable; notifyEvents: integer);
begin
    if ((notifyEvents and notify_front) > 0) then
        bringDockedToTop(frm);
        
    //stateform will flash and bring dock manager to front as needed
    inherited OnNotify(notifyEvents);
end;

{---------------------------------------}
procedure TfrmDockWindow.UpdateDocked(frm: TfrmDockable);
var
    item: TAWTrackerItem;
    aw: TfrmActivityWindow;
begin
    if (frm = nil) then exit;
    
    aw := ActivityWindow.GetActivityWindow();

    if (aw <> nil) then begin
        // See if item is in list
        item := aw.findItem(frm);
        if ((item = nil) and
            (frm.UID <> ''))then begin
            // Item NOT being tracked so let's add it
            item := aw.addItem(frm);
        end;

        if (item <> nil) then begin
            // Deal with priority
            item.awItem.priorityFlag(frm.PriorityFlag);

            // Successful lookup or add
            item.awItem.imgIndex := frm.ImageIndex;

            // Deal with new msg highlight
            if (frm.UnreadMsgCount > item.awItem.count) then begin
                item.awItem.newMessage(true);
            end;

            // Deal with msg count
            if (item.awItem.count <> frm.UnreadMsgCount) then
            begin
                item.awItem.count := frm.UnreadMsgCount;
                if (aw.currentListSort = ssUnread) then
                begin
                    // If this changed, only need to resort
                    // on unread sort option.
                    // This helps with eleminating unneccessary
                    // redraws
                    aw.needToSortList := true;
                end;
            end;

            // Deal with change of nickname
            aw.SetItemName(item.awItem, frm.Caption, frm.Hint);

            // Deal with undocked window focus
            if (frm.Activating) then begin
                if ((not Self.Showing) and
                    (frm.Docked)) then begin
                    ShowDockManagerWindow(true, true);
                end;
                aw.activateItem(item.awItem);
            end;

            aw.itemChangeUpdate(item);
            _needToBeShowingCheck();
        end;

        // Make sure right color button is showing on contact list toolbar
        changeGotoActivityWindowButton();
    end;
end;

{---------------------------------------}
procedure TfrmDockWindow.BringToFront();
begin
    ForceForegroundWindow(Self.Handle);//Self.ShowDockManagerWindow(true, true);
end;

{---------------------------------------}
function TfrmDockWindow.isActive(): boolean;
begin
    Result := Self.Active;
end;

{---------------------------------------}
function TfrmDockWindow.getHWND(): THandle;
begin
    Result := Self.Handle;
end;

{---------------------------------------}
function TfrmDockWindow.ShowDockManagerWindow(Show: boolean = true; BringWindowToFront: boolean = true): boolean;
var
    aoEvent: widestring;
begin
    Result := false;

    if ((Show) and
        (_canShowWindow())) then begin

        Self.ShowDefault(BringWindowToFront);

        // Make sure that if we are starting up and we are supposed to
        // start minimized to systray, then be sure to be minimized to systray
        aoEvent := TAutoOpenEventManager.GetAutoOpenEvent();
        if (((aoEvent = AOE_STARTUP) or (aoEvent = AOE_AUTHED)) and
            (not frmExodus.Showing)) then begin
            close();
        end;
        Result := true;

        // Check to see if we are on screen and if not,
        // bring back to screen
        if (((Self.Top >= Screen.DesktopRect.Bottom) or
            (Self.Left >= Screen.DesktopRect.Right) or
            ((Self.Top + Self.Height) <= Screen.DesktopRect.Top) or
            ((Self.Left + Self.Width) <= Screen.DesktopRect.Left)) and
            (not frmExodus.dockWindowGlued)) then
        begin
            Self.MakeFullyVisible();
        end;
    end
    else if (not Show) then begin
        close(); //hide, sets Showing property to false
        Result := true;
    end;
end;

{---------------------------------------}
function TfrmDockWindow.getTabSheet(frm : TfrmDockable) : TTntTabSheet;
var
    i : integer;
    tf : TForm;
begin
    //walk currently docked sheets and try to find a match
    Result := nil;
    for i := 0 to AWTabControl.PageCount - 1 do begin
        tf := getTabForm(AWTabControl.Pages[i]);
        if (tf = frm) then begin
            Result := TTntTabSheet(AWTabControl.Pages[i]);
            exit;
        end;
    end;
end;

{---------------------------------------}
function TfrmDockWindow.getTabForm(tab: TTabSheet): TForm;
begin
    // Get an associated form for a specific tabsheet
    Result := nil;
    if ((tab <> nil) and (tab.ControlCount = 1)) then begin
        if (tab.Controls[0] is TForm) then begin
            Result := TForm(tab.Controls[0]);
            exit;
        end;
    end;
end;

{---------------------------------------}
procedure TfrmDockWindow.WMActivate(var msg: TMessage);
var
    frm: TfrmDockable;
begin
    inherited; //stop flashing
    if (Msg.WParamLo <> WA_INACTIVE) then begin
        if (_dockState = dsDocked) then begin
            frm := getTopDocked();
            if (frm <> nil) and (frm.visible) then begin
                frm.gotActivate();
            end;
        end;
    end;
end;

{
    Update UI after some dock event has occurred.

    HideDock if last tab was undocked, ShowNormalDock if moving from
    no tabs to at least one tab, handle embedded roster state changes.

    Since it can be difficult to know exactly when to perform a
    change in the DockState (in some instances this method may be called
    before the TPageControl has had a chance to cleanup an tab), a
    flag is passed to force a state change.

    @param frm the form that was just docked/undocked
    @param docking  is the form being docked or undocked?
    @toggleDockState moving from (dsDockOnly or dsRosterDock) to dsRosterOnly or vice versa
}
{---------------------------------------}
procedure TfrmDockWindow.updateLayoutDockChange(frm: TfrmDockable; docking: boolean; FirstOrLastDock: boolean);

var
    oldState : TDockStates;
    newState : TDockStates;
begin
    oldState := _dockState;
    //figure out what state we are moving to...
    if (docking) then begin
       if (FirstOrLastDock) then begin
         newState := dsUnDocked;
       end
       else begin
         newState := dsDocked;
       end
    end
    else
      newState := dsUnDocked;

    if (newState <> oldState) then begin
        // Disable minimum window size while undocking/docking.
        Self.Constraints.MinHeight := 0;
        Self.Constraints.MinWidth := 0;
        if (newState = dsDocked) then
            _layoutDock()
        else
            _layoutAWOnly();
    end;

    _glueCheck();
end;

{
    Adjust layout so roster panel and dock panel are shown
}
{---------------------------------------}
procedure TfrmDockWindow._layoutDock();
var
  mon: TMonitor;
  ratioRoster: real;
  aw: TfrmActivityWindow;
begin
    if (_dockState <> dsDocked) then begin
        _saveDockWidths();
        //this is a mess. To get splitter working with the correct control
        //we need to hide/de-align/set their relative positions/size them and show them
        pnlActivityList.align := alNone;
        splAW.align := alNone;

        splAW.Visible := false; //hide this first or will expand and throw widths off
        pnlActivityList.Visible := false;
        pnlTabControl.Visible := false;

        //Obtain the width of the monitor
        //If we exceed the width of the monitor,
        //recalculate widths for roster based on the same ratio
        mon := Screen.MonitorFromWindow(Self.Handle, mdNearest);
        if (MainSession.Prefs.getInt(PrefController.P_ACTIVITY_WINDOW_WIDTH) + 3 + MainSession.Prefs.getInt(PrefController.P_ACTIVITY_WINDOW_TAB_WIDTH) >= mon.Width) then begin
          ratioRoster := (MainSession.Prefs.getInt(PrefController.P_ACTIVITY_WINDOW_WIDTH) + 3)/(MainSession.Prefs.getInt(PrefController.P_ACTIVITY_WINDOW_WIDTH) + 3 + MainSession.Prefs.getInt(PrefController.P_ACTIVITY_WINDOW_TAB_WIDTH));
          Self.ClientWidth  := mon.Width;
          pnlActivityList.Width := Trunc(Self.ClientWidth * ratioRoster);
        end
        else begin
            Self.ClientWidth := MainSession.Prefs.getInt(PrefController.P_ACTIVITY_WINDOW_WIDTH) + 3 + MainSession.Prefs.getInt(PrefController.P_ACTIVITY_WINDOW_TAB_WIDTH);
            pnlActivityList.Width := MainSession.Prefs.getInt(PrefController.P_ACTIVITY_WINDOW_WIDTH);
        end;

        pnlActivityList.Left := 0;
        pnlActivityList.Align := alLeft;
        pnlActivityList.Visible := true;
        splAW.Left := pnlActivityList.BoundsRect.Right + 1;
        splAW.Align := alLeft;
        splAW.Visible := true;
        pnlTabControl.Left := pnlActivityList.BoundsRect.Right + 4;
        pnlTabControl.Align := alClient;
        pnlTabControl.Visible := true;

        Self.DockSite := false;
        pnlActivityList.DockSite := false;

        _dockState := dsDocked;

        aw := GetActivityWindow();
        if (aw <> nil) then begin
            aw.setDockingSpacers(_dockState);
        end;

        // Change Minimum window size
        Self.Constraints.MinHeight := MainSession.Prefs.getInt('activity_window_with_docked_min_height');
        Self.Constraints.MinWidth := MainSession.Prefs.getInt('activity_window_with_docked_min_width');
    end;
end;

{
    Adjust layout so only roster panel is shown
}
{---------------------------------------}
procedure TfrmDockWindow._layoutAWOnly();
var
  aw: TfrmActivityWindow;
begin
    //if tabs were being shown, save tab size
    _saveDockWidths();
    if (_dockState <> dsUnDocked) then begin
        pnlTabControl.Visible := false;
        pnlActivityList.Align := alClient;
        splAW.Visible := false;
        Self.ClientWidth := MainSession.Prefs.getInt(PrefController.P_ACTIVITY_WINDOW_WIDTH);
        Self.DockSite := true;
        pnlActivityList.DockSite := true;

        _dockState := dsUnDocked;

        aw := GetActivityWindow();
        if (aw <> nil) then begin
            aw.setDockingSpacers(_dockState);
        end;

        // Change Minimum window size
        Self.Constraints.MinHeight := MainSession.Prefs.getInt('activity_window_without_docked_min_height');
        Self.Constraints.MinWidth := MainSession.Prefs.getInt('activity_window_without_docked_min_width');
    end;
end;

{
    Save the current roster and dock panel widths.

    Depending on current state...
}
{---------------------------------------}
procedure TfrmDockWindow._saveDockWidths();
begin
    if (_dockState = dsUnDocked) then
        MainSession.Prefs.setInt(PrefController.P_ACTIVITY_WINDOW_WIDTH, pnlActivityList.Width)
    else if (_dockState = dsDocked) then begin
        MainSession.Prefs.setInt(PrefController.P_ACTIVITY_WINDOW_WIDTH, pnlActivityList.Width);
        MainSession.Prefs.setInt(PrefController.P_ACTIVITY_WINDOW_TAB_WIDTH, AWTabControl.Width);
    end;
end;

{---------------------------------------}
procedure TfrmDockWindow.setWindowCaption(txt: widestring);
begin
    if (txt = '') then begin
        Caption := _(ACTIVITYLIST_CAPTION);
    end
    else begin
        Caption := _(ACTIVITYLIST_CAPTION) +
                   ' - ' +
                   txt;
    end;
end;

{---------------------------------------}
procedure TfrmDockWindow.WMSyscommand(var msg: TWmSysCommand);
begin
    case (msg.cmdtype and $FFF0) of
        SC_MAXIMIZE: begin
            if (_dockState = dsUnDocked) then begin
                Self.Constraints.MaxWidth := Self.Width;
            end;
            inherited;
        end;
        SC_RESTORE: begin
            if (_dockState = dsUnDocked) then begin
                Self.Constraints.MaxWidth := Self.Width;
            end;
            inherited;
        end;
        else begin
            inherited;
        end;
    end;
end;

{---------------------------------------}
procedure TfrmDockWindow.OnMove(var Msg: TWMMove);
begin
    _glueCheck();
    moveGlued();
    inherited;
end;

{---------------------------------------}
procedure TfrmDockWindow._needToBeShowingCheck();
var
    aw: TfrmActivityWindow;
begin
    // This check is here to hide the activity
    // window if nothing is docked or undocked
    // (nothing in list).  There is no reason to
    // show the activity list if there are no
    // windows to track.  Note, check for undocking
    // exists to prevent flashing when an undock
    // closes the docked item and readds the undocked
    // item.
    aw := GetActivityWindow();
    if (aw <> nil) then begin
        if ((aw.itemCount <= 0) and
            (not _undocking)) then begin
            // We shouldn't be showing
            frmExodus.mnuWindows_View_ShowActivityWindow.Checked := false;
            frmExodus.mnuWindows_View_ShowActivityWindow.Enabled := false;
            frmExodus.trayShowActivityWindow.Enabled := false;
            frmExodus.btnActivityWindow.Enabled := false;
            frmExodus.trayShowActivityWindow.Enabled := false;
            Self.Close(); //hide
        end
        else begin
            // We CAN be shown, but don't HAVE to be shown so
            // enable window access
            frmExodus.mnuWindows_View_ShowActivityWindow.Checked := true;
            frmExodus.mnuWindows_View_ShowActivityWindow.Enabled := true;
            frmExodus.trayShowActivityWindow.Enabled := true;
            frmExodus.btnActivityWindow.Enabled := true;
            frmExodus.trayShowActivityWindow.Enabled := true;
        end;
    end;
end;

{---------------------------------------}
procedure TfrmDockWindow._glueCheck();
begin
    if (Self.WindowState = wsMaximized) then exit;

    _glueEdge := withinGlueSnapRange(frmExodus, Self, _glueRange);

    if (_glueEdge <> geNone) then begin
        frmExodus.glueWindow(true);
    end
    else begin
        frmExodus.glueWindow(false);
    end;
end;

{---------------------------------------}
function TfrmDockWindow._canShowWindow(): boolean;
var
    aw: TfrmActivityWindow;
begin
    Result := false;

    aw := GetActivityWindow();
    if (aw <> nil) then begin
        if ((aw.itemCount > 0) and
            (not _suppressShow)) then begin
            Result := true;
        end;
    end;
end;

{---------------------------------------}
procedure TfrmDockWindow.moveGlued();
begin
    if (Self.WindowState = wsMaximized) then exit;
    
    if (Self.Showing) then begin
        case (_glueEdge) of
            geTop: begin
                // Glued on my Top edge
                Self.Top := frmExodus.Top + frmExodus.Height;
                Self.Left := frmExodus.Left;
            end;
            geLeft: begin
                // Glued on my Left edge
                Self.Top := frmExodus.Top;
                Self.Left := frmExodus.Left + frmExodus.Width;
            end;
            geRight: begin
                // Glued on my Right edge
                Self.Top := frmExodus.Top;
                Self.Left := frmExodus.Left - Self.Width;
            end;
            geBottom: begin
                // Glued on my Bottom edge
                Self.Top := frmExodus.Top - Self.Height;
                Self.Left := frmExodus.Left;
            end;
            else begin
                // Not glued - nothing to do
            end;
        end;
    end;
end;

{---------------------------------------}
procedure TfrmDockWindow.SessionCallback(event: string; tag: TXMLTag);
begin
    if (event = '/session/dockwindow/disableshow') then begin
        _suppressShow := true;
    end
    else if (event = '/session/dockwindow/enableshow') then begin
        _suppressShow := false;
    end
    else if (event ='/session/prefs') then begin
        if (MainSession.Prefs.getBool('glue_activity_window')) then begin
            _glueRange := MainSession.Prefs.getInt('glue_activity_window_range');
        end
        else begin
            _glueRange := -1;
        end;
    end;
end;

{---------------------------------------}
function TfrmDockWindow.GetActiveTabSheet(): TTntTabSheet;
var
    i: integer;
begin
    Result := TTntTabSheet(AWTabControl.ActivePage);

    if (Result = nil) then begin
        for i := 0 to AWTabControl.PageCount - 1 do begin
            if (AWTabControl.Pages[i].Visible) then begin
                Result := TTntTabSheet(AWTabControl.Pages[i]);
                break;
            end;
        end;
    end;
end;

{---------------------------------------}
procedure TfrmDockWindow.changeGotoActivityWindowButton();
const
    ALBUTTON_NORMAL = 8;
    ALBUTTON_UNREAD = 9;
    ALBUTTON_PRI = 10;
var
    i: integer;
    imgref: integer;
    frm: TfrmDockable;
    aw: TfrmActivityWindow;
begin
    imgref := ALBUTTON_NORMAL;

    aw := GetActivityWindow();

    if (aw <> nil) then
    begin
        for i := 0 to aw.itemCount - 1 do
        begin
            frm := aw.findItem(i).frm;

            if (frm.PriorityFlag) then begin
                // Priority always takes precedence, so don't need to look farther
                imgref := ALBUTTON_PRI;
                break;
            end
            else if (frm.UnreadMsgCount > 0) then begin
                // Still need to look incase there is a priority msg.
                imgref := ALBUTTON_UNREAD;
            end;
        end;
    end;

    frmExodus.btnActivityWindow.ImageIndex := imgref;
end;


end.



