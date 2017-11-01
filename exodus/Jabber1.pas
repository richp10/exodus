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
unit Jabber1;


interface

uses
    // Exodus stuff
    BaseChat, ExResponders, LoginWindow, RosterForm, Presence, XMLTag,
    ShellAPI, Registry, Emote,
    Dockable, DisplayName, COMToolbar,
    // Delphi stuff
    Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
    ScktComp, StdCtrls, ComCtrls, Menus, ImgList, ExtCtrls,
    Buttons, OleCtrls, AppEvnts, ToolWin,
    IdHttp, TntComCtrls, DdeMan, IdBaseComponent, IdComponent, IdUDPBase,
    IdUDPClient, IdDNSResolver, TntMenus, IdAntiFreezeBase, IdAntiFreeze,
    TntForms, ExTracer, VistaAltFixUnit, ExForm, ExodusDockManager, DockWindow,
    ActnList, TntActnList, TntStdCtrls, ActnMan, ActnCtrls, ActnMenus,
    XPStyleActnCtrls, ActnColorMaps, COMRosterItem, COMExodusItem, Exodus_TLB,
    IEMsgList, ExCustomSeparatorBar;

const
    RUN_ONCE : string = '\Software\Microsoft\Windows\CurrentVersion\Run';
    RECONNECT_RETRIES = 3;

    DT_UNKNOWN=0;       // unknown desktop status
    DT_OPEN=1;          // the default desktop is active
    DT_LOCKED=2;        // the winlogon desktop is active, and a user is logged
    DT_NO_LOG=3;        // the winlogon desktop is active, and no user is logged
    DT_SCREENSAVER=4;   // the screensaver desktop is active
    DT_FULLSCREEN=5;    // Something like PowerPoint is running full screen

    // FROM pbt.h in the win32 SDK
    PBT_APMQUERYSUSPEND = $0000;
    PBT_APMQUERYSTANDBY = $0001;
    PBT_APMQUERYSUSPENDFAILED = $0002;
    PBT_APMQUERYSTANDBYFAILED = $0003;
    PBT_APMSUSPEND = $0004;
    PBT_APMSTANDBY = $0005;
    PBT_APMRESUMECRITICAL = $0006;
    PBT_APMRESUMESUSPEND = $0007;
    PBT_APMRESUMESTANDBY = $0008;
    PBT_APMBATTERYLOW = $0009;
    PBT_APMPOWERSTATUSCHANGE = $000A;
    PBT_APMOEMEVENT = $000B;
    PBTF_APMRESUMEFROMFAILURE = $0000001;

    WM_TRAY = WM_USER + 5269;
    WM_PREFS = WM_USER + 5272;
    WM_SHOWLOGIN = WM_USER + 5273;
    WM_CLOSEAPP = WM_USER + 5274;
    WM_RECONNECT = WM_USER + 5300;
    WM_INSTALLER = WM_USER + 5350;
    WM_MUTEX = WM_USER + 5351;
    WM_DISCONNECT = WM_USER + 5352;

type
    TGetLastTick = function: dword; stdcall;
    TGetLastInputFunc = function(var lii: tagLASTINPUTINFO): Bool; stdcall;
    TInitHooks = procedure; stdcall;
    TStopHooks = procedure; stdcall;

  TfrmExodus = class(TExForm, IControlDelegate)
    MainMenu1: TTntMainMenu;
    ImageList1: TImageList;
    timAutoAway: TTimer;
    popTray: TTntPopupMenu;
    AppEvents: TApplicationEvents;
    Toolbar: TCoolBar;
    timReconnect: TTimer;
    timTrayAlert: TTimer;
    XMPPAction: TDdeServerConv;
    Resolver: TIdDNSResolver;
    Help1: TTntMenuItem;
    trayExit: TTntMenuItem;
    N01: TTntMenuItem;
    trayDisconnect: TTntMenuItem;
    N4: TTntMenuItem;
    trayPresence: TTntMenuItem;
    trayShow: TTntMenuItem;
    About1: TTntMenuItem;
    N12: TTntMenuItem;
    Custom2: TTntMenuItem;
    N5: TTntMenuItem;
    trayPresDND: TTntMenuItem;
    trayPresXA: TTntMenuItem;
    trayPresAway: TTntMenuItem;
    trayPresChat: TTntMenuItem;
    trayPresOnline: TTntMenuItem;
    IdAntiFreeze1: TIdAntiFreeze;
    bigImages: TImageList;
    File1: TTntMenuItem;
    People: TTntMenuItem;
    Windows1: TTntMenuItem;
    mnuFile_Connect: TTntMenuItem;
    mnuFile_Disconnect: TTntMenuItem;
    mnuFile_MyStatus: TTntMenuItem;
    mnuFile_MyStatus_Available: TTntMenuItem;
    mnuFile_MyStatus_Away: TTntMenuItem;
    mnuFile_MyStatus_Donotdisturb: TTntMenuItem;
    mnuFile_Exit: TTntMenuItem;
    mnuPeople_Search: TTntMenuItem;
    mnuPeople_Contacts: TTntMenuItem;
    mnuPeople_Contacts_AddContact: TTntMenuItem;
    mnuPeople_Contacts_DeleteContact: TTntMenuItem;
    mnuPeople_Contacts_ContactProperties: TTntMenuItem;
    mnuPeople_Contacts_RenameContact: TTntMenuItem;
    mnuPeople_Contacts_SendMessage: TTntMenuItem;
    mnuPeople_Contacts_BlockContact: TTntMenuItem;
    mnuPeople_Contacts_FindContactinRoster: TTntMenuItem;
    mnuPeople_Contacts_ViewHistory: TTntMenuItem;
    mnuPeople_Group: TTntMenuItem;
    mnuPeople_Group_AddNewRoster: TTntMenuItem;
    mnuPeople_Group_DeleteGroup: TTntMenuItem;
    mnuPeople_Group_RenameGroup: TTntMenuItem;
    N13: TTntMenuItem;
    mnuPeople_Group_AddContacttoGroup: TTntMenuItem;
    mnuPeople_Group_RemoveContactfromGroup: TTntMenuItem;
    mnuPeople_Conference: TTntMenuItem;
    mnuPeople_Conference_InviteContacttoConference: TTntMenuItem;
    mnuPeople_Conference_OpenNewConferenceRoom: TTntMenuItem;
    mnuPeople_Conference_SearchforConferenceRoom: TTntMenuItem;
    mnuPeople_Conference_ViewHistory: TTntMenuItem;
    mnuWindows_CloseAll: TTntMenuItem;
    mnuWindows_List1: TTntMenuItem;
    mnuWindows_MinimizetoSystemTray: TTntMenuItem;
    mnuWindows_MinimizetoTaskBar: TTntMenuItem;
    mnuPeople_Contacts_SendFile: TTntMenuItem;
    mnuFile_MyStatus_FreeToChat: TTntMenuItem;
    mnuFile_MyStatus_XtendedAway: TTntMenuItem;
    mnuFile_MyStatus_Invisible: TTntMenuItem;
    N6: TTntMenuItem;
    mnuWindows_View: TTntMenuItem;
    mnuWindows_View_ShowToolbar: TTntMenuItem;
    mnuWindows_View_ShowChatToolbar: TTntMenuItem;
    mnuWindows_View_ShowInstantMessages1: TTntMenuItem;
    mnuFile_ShowDebugXML: TTntMenuItem;
    mnuWindows_View_ShowActivityWindow: TTntMenuItem;
    trayShowActivityWindow: TTntMenuItem;
    tbsView: TPageControl;
    tabLogin: TTabSheet;
    tabRoster: TTabSheet;
    pnlLogin: TPanel;
    pnlRoster: TPanel;
    GridPanel1: TGridPanel;
    imgSSL: TImage;
    pnlStatus: TPanel;
    lblStatus: TTntLabel;
    imgDown: TImage;
    popPresence: TTntPopupMenu;
    TntMenuItem1: TTntMenuItem;
    TntMenuItem2: TTntMenuItem;
    TntMenuItem3: TTntMenuItem;
    TntMenuItem4: TTntMenuItem;
    TntMenuItem5: TTntMenuItem;
    TntMenuItem6: TTntMenuItem;
    Custom1: TTntMenuItem;
    TntMenuItem7: TTntMenuItem;
    imgPresence: TImage;
    N19: TTntMenuItem;
    N20: TTntMenuItem;
    mnuFile_Password: TTntMenuItem;
    N21: TTntMenuItem;
    mnuFile_Preferences: TTntMenuItem;
    mnuFile_Registration: TTntMenuItem;
    mnuFile_Registration_EditReg: TTntMenuItem;
    mnuFile_Registration_VCard: TTntMenuItem;
    pnlToolbar: TPanel;
    ToolBar1: TToolBar;
    btnConnect: TToolButton;
    btnDisconnect: TToolButton;
    btnOnlineRoster: TToolButton;
    btnAddContact: TToolButton;
    btnRoom: TToolButton;
    btnFind: TToolButton;
    btnSendFile: TToolButton;
    btnBrowser: TToolButton;
    ToolButtonSep1: TToolButton;
    btnOptions: TToolButton;
    btnActivityWindow: TToolButton;
    popCreate: TTntPopupMenu;
    Folder1: TTntMenuItem;
    Contact1: TTntMenuItem;
    txtStatus: TTntEdit;
    imgAd: TImage;
    MainbarImageList: TImageList;
    popViewStates: TTntPopupMenu;
    popShowOnline: TTntMenuItem;
    popShowAll: TTntMenuItem;
    mnuContacts_ViewHistory: TTntMenuItem;
    mnuFile_Plugins: TTntMenuItem;
    N16: TTntMenuItem;
    mnuFile_Plugins_Options: TTntMenuItem;
    ToolbarSeparatorBar: TExCustomSeparatorBar;
    pnlStatusLabel: TPanel;

    procedure FormCreate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnAddContactClick(Sender: TObject);
    procedure mnuConferenceClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure Preferences1Click(Sender: TObject);
    procedure ClearMessages1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnDelPersonClick(Sender: TObject);
    procedure ShowXML1Click(Sender: TObject);
    procedure Exit2Click(Sender: TObject);
    procedure JabberorgWebsite1Click(Sender: TObject);
    procedure JabberCentralWebsite1Click(Sender: TObject);
    procedure About1Click(Sender: TObject);
    procedure presOnlineClick(Sender: TObject);
    procedure mnuMyVCardClick(Sender: TObject);
    procedure mnuToolbarClick(Sender: TObject);
    procedure NewGroup2Click(Sender: TObject);
    procedure timAutoAwayTimer(Sender: TObject);
    procedure MessageHistory2Click(Sender: TObject);
    procedure Properties2Click(Sender: TObject);
    procedure mnuVCardClick(Sender: TObject);
    procedure mnuSearchClick(Sender: TObject);
    procedure mnuChatClick(Sender: TObject);
    procedure mnuBookmarkClick(Sender: TObject);
    procedure presCustomClick(Sender: TObject);
    procedure trayShowClick(Sender: TObject);
    procedure trayExitClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure WinJabWebsite1Click(Sender: TObject);
    procedure JabberBugzilla1Click(Sender: TObject);
    procedure mnuPasswordClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure mnuMessageClick(Sender: TObject);
    procedure Test1Click(Sender: TObject);
    procedure mnuBrowserClick(Sender: TObject);
    procedure timReconnectTimer(Sender: TObject);
    procedure presToggleClick(Sender: TObject);
    procedure AppEventsActivate(Sender: TObject);
    procedure AppEventsDeactivate(Sender: TObject);
    procedure timTrayAlertTimer(Sender: TObject);
    procedure JabberUserGuide1Click(Sender: TObject);
    procedure mnuPluginDummyClick(Sender: TObject);
    procedure SubmitExodusFeatureRequest1Click(Sender: TObject);
    procedure ShowBrandURL(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure mnuRegistrationClick(Sender: TObject);
    procedure XMPPActionExecuteMacro(Sender: TObject; Msg: TStrings);
    procedure mnuFindClick(Sender: TObject);
    procedure mnuFindAgainClick(Sender: TObject);
    procedure presDNDClick(Sender: TObject);
    procedure ResolverStatus(ASender: TObject; const AStatus: TIdStatus;
      const AStatusText: String);
    procedure mnuPluginOptsClick(Sender: TObject);
    procedure mnuDisconnectClick(Sender: TObject);

    {
        Event fired when programaticvally undocking

        Does not update the layout of the dock manager. This method is used
        when undocking tabs while updating the layout (see updateLayoutPrefChange)
    }
    procedure TabsUnDockNoLayoutChange(Sender: TObject; Client: TControl;
                                       NewTarget: TWinControl; var Allow: Boolean);
    procedure mnuChatToolbarClick(Sender: TObject);
    procedure mnuFile_MyProfiles_DeleteProfileClick(Sender: TObject);
    procedure mnuFile_MyProfiles_ModifyProfileClick(Sender: TObject);
    procedure mnuFile_MyProfiles_RenameProfileClick(Sender: TObject);
    procedure mnuFile_MyProfiles_CreateNewProfileClick(Sender: TObject);
    procedure mnuPeople_Contacts_BlockContactClick(Sender: TObject);
    procedure mnuOptions_FontClick(Sender: TObject);
    procedure mnuOptions_EnableStartupWithWindowsClick(Sender: TObject);
    procedure OptionsClick(Sender: TObject);
    procedure mnuOptions_Notifications_ContactOnlineClick(Sender: TObject);
    procedure mnuOptions_Notifications_ContactOfflineClick(Sender: TObject);
    procedure mnuWindows_CloseAllClick(Sender: TObject);
    procedure mnuWindows_MinimizetoSystemTrayClick(Sender: TObject);
    procedure mnuPeople_Contacts_RenameContactClick(Sender: TObject);
    procedure mnuPeople_Group_AddNewRosterClick(Sender: TObject);
    procedure mnuPeople_Group_DeleteGroupClick(Sender: TObject);
    procedure mnuPeople_Group_RenameGroupClick(Sender: TObject);
    procedure mnuPeople_Conference_InviteContacttoConferenceClick(Sender: TObject);
    procedure mnuOpenNewConferenceRoom1Click(Sender: TObject);
    procedure mnuFile_ConnectClick(Sender: TObject);
    procedure mnuPeople_Contacts_SendFileClick(Sender: TObject);
    procedure mnuPeople_ConferenceClick(Sender: TObject);
    procedure btnFindClick(Sender: TObject);
    procedure mnuWindows_View_ShowActivityWindowClick(Sender: TObject);
    procedure trayShowActivityWindowClick(Sender: TObject);
    procedure clickChangeStatus(Sender: TObject);
    procedure clickEditStatus(Sender: TObject);
    procedure txtStatusKeyPress(Sender: TObject; var Key: Char);
    procedure txtStatusExit(Sender: TObject);
    procedure imgAdClick(Sender: TObject);
    procedure popChangeView(Sender: TObject);
    procedure mnuContacts_ViewHistoryClick(Sender: TObject);
    procedure popCreatePopup(Sender: TObject);
    procedure clickCreatePopupItem(Sender: TObject);
    procedure PeopleClick(Sender: TObject);
    procedure mnuRegisterUDClick(Sender: TObject);
    procedure mnuFileRegistrationClick(Sender: TObject);
    procedure pnlStatusLabelMouseEnter(Sender: TObject);
    procedure pnlStatusLabelMouseLeave(Sender: TObject);
  private
    { Private declarations }
    _noMoveCheck: boolean;              // don't check form moves
    _ApprovedExitWithCOMActive: boolean;// Flag to show COM object message when exiting.

    _tray_notify: boolean;              // boolean for flashing tray icon
    _edge_snap: integer;                // edge snap fuzziness
    _auto_login: boolean;
    _expanded: boolean;                 // are we expanded or not?
    _docked_forms: TList;               // list of all of the docked forms
    // Various state flags
    _windows_ver: integer;
    _is_broadcast: boolean;             // Should this copy broadcast pres changes
    _hidden: boolean;                   // are we minimized to the tray
    _was_max: boolean;                  // was the main window maximized before?
    _logoff: boolean;                   // are we logging off on purpose
    _shutdown: boolean;                 // are we being shutdown
    _cleanupComplete : boolean;        //all close events have fired and app is ready to terminate
    _close_min: boolean;                // should the close btn minimize, not close
    _appclosing: boolean;               // is the entire app closing
//    _new_tabindex: integer;             // new tab which was just docked
    _new_account: boolean;              // is this a new account
    _pending_passwd: Widestring;
    _enforceConstraints: boolean;       // Should minimum size constraints be enforced


    // Stuff for the Autoaway
    _idle_hooks: THandle;               // handle the lib
    _GetLastTick: TGetLastTick;         // function ptrs inside the lib
    _InitHooks: TInitHooks;
    _StopHooks: TStopHooks;
    _valid_aa: boolean;                 // do we have a valid auto-away setup?
    _GetLastInput: TGetLastInputFunc;
    _is_autoaway: boolean;              // Are we currently auto-away
    _is_autoxa: boolean;                // Are we currently auto-xa

    _auto_away_interval: integer;       //# of seconds between checks when moving from availabel state
    _last_show: Widestring;             // last show for restoring after auto-away
    _last_status: Widestring;           // last status    (ditto)
    _last_priority: integer;            // last priority  (ditto)

    // Tray Icon stuff
    _tray: NOTIFYICONDATA;
    _tray_tip: string;
    _tray_icon_idx: integer;
    _tray_icon: TIcon;

    // Some callbacks
    _sessioncb: integer;
    _dns_cb: integer;

    // Reconnect variables
    _reconnect_interval: integer;
    _reconnect_cur: integer;
    _reconnect_tries: integer;

    // Stuff for tracking win32 API events
    _win32_tracker: Array of integer;
    _win32_idx: integer;

    // Dockmanager stuff
    _dockManager: IExodusDockManager;
    _dockWindow: TfrmDockWindow;
    _dockWindowGlued: boolean;

    // Other
    _killshow: boolean;
    _glueRange: integer;
    _hiddenIEMsgList: TfIEMsgList;
    _mnuRegisterUD: TTntMenuItem;
    _PageControlSaveWinProc: TWndMethod;


//    _currRosterPanel: TPanel; //what panel is roster being rendered in
    procedure _PageControlNewWndProc(var Msg: TMessage);
    procedure SaveBands();
    procedure RestoreBands();

    procedure setupReconnect();
    procedure setupTrayIcon();
    procedure setTrayInfo(tip: string);
    procedure setTrayIcon(iconNum: integer);
    procedure SetAutoAway();
    procedure SetAutoXA();
    procedure SetAutoAvailable();
    procedure SetupAutoAwayTimer();

    procedure ShowLogin();
    procedure ShowRoster();
    procedure UpdatePresenceDisplay();

    function win32TrackerIndex(windows_msg: integer): integer;

    procedure CTCPCallback(event: string; tag: TXMLTag);

    procedure _sendInitPresence();
    {**
     *  Cleanup objects, registered callbacks etc. Prepare for shutdown
     **}
    procedure cleanup();

    {**
     *  Busywait until cleanupmethod is complete by checking _cleanupComplete flag
    **}
    procedure waitForCleanup();
    procedure _chkUserDirectory();
  protected
    // Hooks for the keyboard and the mouse
    _hook_keyboard: HHOOK;
    _hook_mouse: HHOOK;

    procedure Repaint(); override;
    // Window message handlers
    procedure CreateParams(var Params: TCreateParams); override;
    procedure WMSysCommand(var msg: TWmSysCommand); message WM_SYSCOMMAND;
    procedure WMSize(var msg: TMessage); message WM_SIZE;
    procedure WMWindowPosChanging(var msg: TWMWindowPosChanging); message WM_WINDOWPOSCHANGING;
    procedure WMTray(var msg: TMessage); message WM_TRAY;
    procedure WMQueryEndSession(var msg: TMessage); message WM_QUERYENDSESSION;
    procedure WMShowLogin(var msg: TMessage); message WM_SHOWLOGIN;
    procedure WMCloseApp(var msg: TMessage); message WM_CLOSEAPP;
    procedure WMReconnect(var msg: TMessage); message WM_RECONNECT;
    procedure WMInstaller(var msg: TMessage); message WM_INSTALLER;
    procedure WMDisconnect(var msg: TMessage); message WM_DISCONNECT;
    procedure WMDisplayChange(var msg: TMessage); message WM_DISPLAYCHANGE;
    procedure WMPowerChange(var msg: TMessage); message WM_POWERBROADCAST;
    procedure CMMouseEnter(var msg: TMessage); message CM_MOUSEENTER;
    procedure CMMouseLeave(var msg: TMessage); message CM_MOUSELEAVE;

    procedure WMActivate(var msg: TMessage); message WM_ACTIVATE;
    procedure WMMoving(var Msg: TWMMoving); message WM_MOVING;
    procedure WMMove(var Msg: TWMMove); message WM_MOVE;
    procedure WMExitSizeMove(var Message: TMessage) ; message WM_EXITSIZEMOVE;

    function WMAppBar(dwMessage: DWORD; var pData: TAppBarData): UINT; stdcall;

    {
        Check the current dock state against the "required" dock state and
        update GUI accordingly.

        For instance, if dock is forbidden but we have docked tabs, undock all
        and compact the interface, or if dock is required and we have undocked
        windows, expand the GUI and dock undocked forms.

        Also renders roster in appropriate panel, whether in pnlRoster or
        in a docked form that can handl;e it (TfrmMsgQueue).
    }
    procedure updateLayoutPrefChange();

    {
        Adjust layout so roster panel and dock panel are shown
    }

    {
        Adjust layout so only roster panel is shown
    }
    procedure layoutRosterOnly();

    {
        Undock all docked forms.

        Prevents tab change, onundock events from firing. Does not update
        layout.
    }
    procedure DoDisconnect();
    //IControlDelegate
    function AddControl(ID: widestring; ToolbarName: widestring): IExodusToolbarControl;
published
    // Callbacks
    procedure DNSCallback(event: string; tag: TXMLTag);
    procedure SessionCallback(event: string; tag: TXMLTag);
    procedure ChangePasswordCallback(event: string; tag: TXMLTag);

    // This is only used for testing..
    procedure BadCallback(event: string; tag: TXMLTag);

    procedure restoreToolbar;
    procedure restoreAlpha;
    procedure restoreMenus(enable: boolean);
  public
    ActiveChat: TfrmBaseChat;
//    Tabs: TExodusTabs;

    function getLastTick(): dword;
    function screenStatus(): integer;
    function IsAutoAway(): boolean;
    function IsAutoXA(): boolean;
    function isMinimized(): boolean;

    procedure Startup();
    procedure DoConnect();
    procedure CancelConnect();
    procedure AcceptFiles( var msg : TWMDropFiles ); message WM_DROPFILES;
    procedure DefaultHandler(var msg); override;
    procedure TrackWindowsMsg(windows_msg: integer);
    procedure fireWndMessage(handle: HWND; msg: Cardinal;
        wParam: integer; lParam: integer);

    procedure Flash();
    procedure doRestore();

    procedure PreModal(frm: TForm);
    procedure PostModal();

    procedure glueWindow(doGlue: boolean = true);

    {
        Do notifyEvents notification events in the context of frm.

        If frm is nil, dock manager should handle what notification
        events it knows about (flash, bring to front).

        If the form is not TfrmDockable, check to see if it is the
        roster window and notify either the form it embedded in (PGM mode)
        or treat as dock manager notification.

        If frm is TfrmDockable and docked handle as follows

            if notify_docked_flasher pref is true and notifyEvents has flash,
            dock manager must keep flashing until every notified docked form
            has gained focus.

            If not true and notifyEvents has flash, flash minimum times

    }
    procedure OnNotify(frm: TForm; notifyEvents: integer);

    procedure BringToFront();

    function isActive(): boolean;

    {
        Find the first docked form that is can render a roster

        Really there is only one form that can do this, TfrmMsgQueue,
        and its pretty much hard coded to that form.
    }

    {
        Process the Options menu items for checkmarks.
    }
    procedure OptionsMenuItemsChecks();

    {
        Disables/enables menu items for group and contact menus based on roster selection
    }
    procedure ResetMenuItems(Node: TTnTTreeNode);

    {
        Removes a shortcut from an already existing menu so there are no duplicates
    }
    procedure RemoveMenuShortCut(value: integer);
    function DisableHelp(Command: Word; Data: Longint;
     var CallHelp: Boolean): Boolean;
    procedure doHide();
    function IsShortCut(var Message: TWMKey): Boolean; override;
    function AppKeyDownHook(var Msg: TMessage): Boolean;

    property dockManager:IExodusDockManager read _dockManager;
    property dockWindowGlued: boolean read _dockWindowGlued;
  end;

  {
      Dock states, allowed -> docking/undocking , required -> dock only, forbidden -> undock only
  }
  TAllowedDockStates = (adsAllowed, adsForbidden);

procedure StartTrayAlert();
procedure StopTrayAlert();

function ExodusGMHook(code: integer; wParam: word; lParam: longword): longword; stdcall;
function ExodusCWPHook(code: integer; wParam: word; lParam: longword): longword; stdcall;

function getDockManager(): IExodusDockManager;

{
    get the current docking state.

    Dock state may be dsAllowed -> forms may be docked or undocked
                      dsRequired -> dockable forms MUST dock, may not be undocked
                      dsForbidden -> dockable forms cannot dock, must be undocked
    Dock state is based on the "expanded" preference to indicate docking is allowed
    and the "dock-locked" preference.
    
    (expanded && dock-locked --> dsRequired, expanded && !dock-locked --> dsAllowed,
     !expanded --> dsForbidden)
}
function getAllowedDockState() : TAllowedDockStates;

{
    Is the roster currently embedded in the Messenger tab?

    This function will return true if the roster should be embedded whenever
    the messenger tab is docked. Will return false if roster should never be
    embedded. Will return true if roster is currently embedded in a docked
    messenger tab *and* if it *should* be embedded when the messenger tab is
    undocked or not shown. Essentially this is a GUI hint to the roster rendering
    code.
}


var
    frmExodus: TfrmExodus;
    sExodusPresence: Cardinal;
    sExodusMutex: Cardinal;
    sShellRestart: Cardinal;
    sExodusGMHook: HHOOK;
    sExodusCWPHook: HHOOK;

const
    sXMPP_Profile = '-*- Temp profile: %s -*-';
{*
    sExodus = 'Exodus';
*}
    //sChat = 'Chat';

    sCommError = 'There was an error during communication with the Jabber Server';
    sDisconnected = 'You have been disconnected.';
    sAuthError = 'There was an error trying to authenticate you.'#13#10'Either you used the wrong password, or this account is already in use by someone else.';
    sRegError = 'An Error occurred trying to register your new account. This server may not allow open registration.';
    sAuthNoAccount = 'This account does not exist on this server. Create a new account?';
    sNewAccount = 'Your new jabber account is activated. Would you like to fill out additional registration information?';
    sNoContactsSel = 'You must select one or more contacts.';

    sSetAutoAvailable = 'Setting Auto Available';
    sSetAutoAway = 'Setting AutoAway';
    sSetAutoXA = 'Setting AutoXA';
    sSetupAutoAway = 'Trying to setup the Auto Away timer.';
    sAutoAwayFail = 'AutoAway Setup FAILED!';
    sAutoAwayWin32 = 'Using Win32 API for Autoaway checks!!';
    sAutoAwayFailWin32 = 'ERROR GETTING WIN32 API ADDR FOR GetLastInputInfo!!';

    sMsgContacts = 'Contacts from ';

    sLookupProfile = 'Lookup Profile';
    sSendMessage = 'Send a Message';
    sStartChat = 'Start Chat';
    sRegService = 'Register with Service';

    sJID = 'Jabber ID';
    sEnterJID = 'Enter Jabber ID: ';
    sEnterSvcJID = 'Enter Jabber ID of Service: ';

    sPasswordError = 'Error changing password.';
    sPasswordChanged = 'Password changed.';
    sPasswordCaption = 'Password';
    sPasswordPrompt = 'Enter Password';

    sBrandingError = 'Branding error!';
    sQueryTypeError = 'Unknown query type: ';
    sUserExistsErr = ''#13#10' ERROR: The username ''%s'' already exists.';
    sRegNotImplErr = ''#13#10' ERROR: This server does not support in-band registration.';

    sOutOfSystemResourcesError = 'Out of system resources.';

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
const
    MaxIcons = 64;      // How many icons are in icons.res ??

    ico_Unassigned = -1;
    ico_Offline = 0;
    ico_None = 1;
    ico_Online = 1;
    ico_Chat = 4;
    ico_Away = 2;
    ico_XA = 10;
    ico_DND = 3;
    ico_Folder = 9;
    ico_ResFolder = 7;
    ico_Unknown = 6;
    ico_msg = 11;
    ico_info = 12;
    ico_userbook = 13;

    ico_key = 16;
    ico_application = 19;
    ico_user = 20;
    ico_conf = 21;
    ico_service = 22;
    ico_headline = 23;
    ico_Unread = 23;
    ico_keyword = 24;
    ico_render = 25;
    ico_grpfolder = 26;
    ico_down = 27;
    ico_right = 28;
    ico_blocked = 39;
    ico_blockoffline = 41;
    ico_error = 32;

    ico_online_minus_one = 44;
    ico_away_minus_one = 45;
    ico_dnd_minus_one = 46;
    ico_chat_minus_one = 47;
    ico_xa_minus_one = 48;
{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
implementation
uses

    // XXX: ZipMstr
    StateForm, CapsCache,
    RosterImages, ToolbarImages,
    ExodusImageList,
    COMExodusItemList,
    NewUser, CommandWizard, Notify,
    About, AutoUpdate, AutoUpdateStatus, Browser, Chat,
    ChatController,
    ChatWin, ToolbarColorSelect,
    Debug, DNSUtils, Entity,
    EntityCache, ExSession, JabberUtils, ExUtils,
    InputPassword, Invite, GnuGetText,
    Iq, JUD, JabberID, JabberMsg, IdGlobal, LocalUtils,
    JabberConst, ComController, CommCtrl, CustomPres,
    JoinRoom, MsgController, MsgDisplay,
    Password,
    PrefController, Prefs, PrefNotify, Profile, RegForm, RemoveContact, RiserWindow,
    Room, XferManager, Stringprep, SSLWarn,
    RosterAdd, Session, StandardAuth, StrUtils, Subscribe, Unicode, VCard, xData,
    XMLUtils, XMLParser,
    ComServ, PrefFile,
    ManagePluginsDlg,
    DebugManager, TntGraphics, SelectItem,
    HistorySearch,
    FrmUtils,
    COMExodusControlSite, //TExodusControlSite
    ExActionCtrl,
    ActivityWindow,
    COMObj;

{$R *.DFM}

const
    sRosterAvail = 'Available';
    sRosterChat = 'Free to Chat';
    sRosterAway = 'Away';
    sRosterXA = 'Extended Away';
    sRosterDND = 'Do Not Disturb';
    sRosterOffline = 'Offline';

//Hidden Helpers!
type TActionHelper = class
private
    _typedActs: IExodusTypedActions;
    _actName: Widestring;

public
    constructor Create(typedActs: IExodusTypedActions; actname: Widestring);
    destructor Destroy; override;

    property TypedActions: IExodusTypedActions read _typedActs;
    property ActionName: Widestring read _actName;

    procedure click(Sender: TObject);
end;
constructor TActionHelper.Create(typedActs: IExodusTypedActions; actname: WideString);
begin
    _typedActs := typedActs;
    _actName := actname;
end;
destructor TActionHelper.Destroy;
begin
    _typedActs := nil;

    inherited;
end;
procedure TActionHelper.click(Sender: TObject);
begin
    if (TypedActions <> nil) then TypedActions.execute(ActionName);
end;

function getDockManager(): IExodusDockManager;
begin
    Result := frmExodus.dockManager;
end;

{---------------------------------------}
procedure TfrmExodus.mnuFile_MyProfiles_CreateNewProfileClick(Sender: TObject);
begin
    GetLoginWindow().clickCreateProfile(Sender);
end;

procedure TfrmExodus.CreateParams(var Params: TCreateParams);
begin
    // Make each window appear on the task bar.
    inherited CreateParams(Params);
    with Params do begin
        ExStyle := ExStyle or WS_EX_APPWINDOW;
        WndParent := GetDesktopWindow();
    end;
end;

{---------------------------------------}
function TfrmExodus.AddControl(ID: widestring; ToolbarName: widestring): IExodusToolbarControl;
begin
    Result := TExodusControlSite.create(Toolbar, Toolbar, StringToGuid(Id));
    Toolbar.Bands.Items[Toolbar.Bands.Count-1].Text := Id;
end;

procedure TfrmExodus.Repaint();
var
    i: integer;
begin
    //show toolbar (coolbar) if 1 or more controls are visible
    Toolbar.visible := false;
    for i := 0 to Toolbar.Bands.Count - 1 do
        Toolbar.visible := Toolbar.visible or Toolbar.Bands[i].Control.Visible;
    inherited;
end;

procedure TfrmExodus.Flash();
begin
end;

{---------------------------------------}
procedure TfrmExodus.doRestore();
begin
    if (_hidden) then begin
        Self.WindowState := wsNormal;
        Self.Visible := true;
        if (_was_max) then
            ShowWindow(Handle, SW_MAXIMIZE)
        else
            ShowWindow(Handle, SW_RESTORE);
        _hidden := false;
    end
    else if (Self.WindowState = wsMaximized) then begin
        ShowWindow(Handle, SW_RESTORE);
        //The following two lines are required to resize panels on restore
        Self.AutoSize := true;
        Self.AutoSize := false;
        _was_max := false;
    end;

    if ((_dockwindow <> nil) and
        (not _dockwindow.Showing)) then begin
        getDockManager().ShowDockManagerWindow(true, false);
    end;

    SetForegroundWindow(Self.Handle);
end;

{---------------------------------------}
procedure TfrmExodus.WMSize(var msg: TMessage);
begin
    // Windows-M and "Show Desktop" use this to hide all windows
    if (_noMoveCheck) then
        inherited
    else if ((msg.WParam = SIZE_MINIMIZED) and (not _hidden)) then begin
        _hidden := true;
        _was_max := (Self.WindowState = wsMaximized);
        msg.Result := 0;
    end
    else if ((msg.WParam = SIZE_RESTORED) and (_hidden)) then begin
        msg.Result := 0;
    end
    else
        inherited;
end;

{---------------------------------------}
procedure TfrmExodus.WMDisplayChange(var msg: TMessage);
begin
    checkAndCenterForm(Self);
end;

{---------------------------------------}
procedure TfrmExodus.WMPowerChange(var msg: TMessage);
begin
    // APM event
    case msg.wParam of
    PBT_APMQUERYSUSPEND, PBT_APMQUERYSTANDBY: begin
        // system wants to be suspended
        DebugMsg('Got a PBT_APMQUERYSUSPEND. Logging off');
        MainSession.Prefs.SaveProfiles();
        MainSession.Prefs.SaveServerPrefs();
        if (MainSession.Active) then begin
            _logoff := true;
            PostMessage(Self.Handle, WM_DISCONNECT, 0, 0);
            _auto_login := true;
        end;
        msg.Result := 1;
        exit;
        end;
    PBT_APMSUSPEND, PBT_APMSTANDBY: begin
        // disconnect
        DebugMsg('Got a PBT_APMSUSPEND.');
        msg.Result := 1;
        end;
    PBT_APMRESUMECRITICAL, PBT_APMRESUMESUSPEND, PBT_APMRESUMESTANDBY: begin
        // connect
        DebugMsg('Got a PBT_RESUME*.');
        _logoff := false;
        _reconnect_tries := 0;
        if (_auto_login) then begin
            _auto_login := false;
            setupReconnect();
        end;
        msg.Result := 1;
        end;
    end;
end;

{---------------------------------------}
procedure TfrmExodus.WMSysCommand(var msg: TWmSysCommand);
begin
    // Catch some of the important windows msgs
    // so that we can handle minimizing & stuff properly
    case (msg.CmdType and $FFF0) of
    SC_MAXIMIZE: begin
        MainSession.Prefs.setInt(PrefController.P_ROSTER_WIDTH, Self.ClientWidth);
        MainSession.Prefs.setInt(PrefController.P_ROSTER_HEIGHT, Self.ClientHeight);
        inherited;
        msg.Result := 0;
    end;
    SC_MINIMIZE: begin
        _hidden := true;
        _was_max := (Self.WindowState = wsMaximized);
        Self.Visible := false;
        ShowWindow(Handle, SW_HIDE);
        msg.Result := 0;
    end;
    SC_RESTORE: begin
        doRestore();
        msg.Result := 0;
    end;
    SC_CLOSE: begin
        if ((_close_min) and (not _shutdown)) then begin
            _hidden := true;
            Self.Visible := false;
            ShowWindow(Handle, SW_HIDE);
            msg.Result := 0;
        end
        else
            inherited;
    end;
    else
        inherited;
    end;
end;

{---------------------------------------}
procedure TfrmExodus.WMTray(var msg: TMessage);
var
    cp: TPoint;
begin
    // this gets fired when the user clicks on the tray icon
    // manually handle popping up the tray menu..
    // since the delphi/vcl impl isn't quite right.
    if (Msg.LParam = WM_LBUTTONDBLCLK) then begin
        // restore our app
        doRestore();
        _hidden := false;

        getDockManager().BringToFront(); // takes focus
        Self.BringToFront(); // take back focus

        msg.Result := 0;
    end
    else if ((Msg.LParam = WM_LBUTTONDOWN) and (not Application.Active) and (not _hidden))then begin
        SetForegroundWindow(Self.Handle);
    end

    else if (Msg.LParam = WM_RBUTTONDOWN) then begin
        GetCursorPos(cp);
        SetForegroundWindow(Self.Handle);
        Application.ProcessMessages;
        popTray.Popup(cp.x, cp.y);
    end

    else if (Msg.LParam = WM_MOUSEMOVE) then begin
//        DebugMsg('Move');
    end

    else if (Msg.LParam = WM_MOUSELAST) then begin
//        DebugMsg('Out');
    end

    else begin
//        DebugMsg('other');
    end;

end;

{---------------------------------------}
procedure TfrmExodus.WMQueryEndSession(var msg: TMessage);
begin
    _shutdown := true;
    inherited; //will eventually fire FormQueryClose event
    //busywait until app has a chance to cleanup
    waitForCleanup();
    msg.Result := 1;
end;

{---------------------------------------}
procedure TfrmExodus.WMShowLogin(var msg: TMessage);
begin
    // Show the login window
    _reconnect_tries := 0;
    _new_account := false;

    //TODO:  display login window
end;

{---------------------------------------}
procedure TfrmExodus.WMCloseApp(var msg: TMessage);
begin
    // Close the main form
    Self.Close();
end;

{---------------------------------------}
procedure TfrmExodus.WMReconnect(var msg: TMessage);
begin
    // Enable the reconnect timer
    timReconnect.Enabled := true;
end;

{---------------------------------------}
procedure TfrmExodus.WMInstaller(var msg: TMessage);
var
    reg : TRegistry;
    cmd : string;
begin
    // We are getting a Windows Msg from the installer
    if (not _shutdown) then begin
        reg := TRegistry.Create();
        reg.RootKey := HKEY_CURRENT_USER;
        reg.OpenKey('\Software\Jabber\' + getAppInfo().ID + '\Restart\' + IntToStr(Application.Handle), true);

        reg.WriteString('cmdline', '"' + ParamStr(0) +
                        '" -c "' + MainSession.Prefs.Filename + '"');
        GetDir(0, cmd);
        reg.WriteString('cwd', cmd);

        reg.CloseKey();
        reg.Free();

        _shutdown := true;
        Self.Close;
        waitForCleanup();
    end;
end;

{---------------------------------------}
procedure TfrmExodus.WMDisconnect(var msg: TMessage);
begin
    DoDisconnect();
end;

{---------------------------------------}
procedure TfrmExodus.WMActivate(var msg: TMessage);
 begin
    if (Msg.WParamLo <> WA_INACTIVE) then begin
//        outputdebugMsg('TfrmExodus.WMActivate');

//        StopFlash(Self);
        stopTrayAlert();

        if ((_dockWindow <> nil) and
            (_dockWindow.Showing) and
            (_dockWindowGlued) and
            (_dockWindow.WindowState = wsNormal)) then begin
            // This will keep the glued window on top
            // when this window is activated.
            SetWindowPos(_dockWindow.Handle, Self.Handle,
                    0, 0, 0, 0,
                    SWP_NOSIZE or SWP_NOMOVE or SWP_NOACTIVATE or SWP_NOSENDCHANGING);
        end;
    end;
    inherited;
 end;

{---------------------------------------}
{---------------------------------------}
procedure TfrmExodus.FormCreate(Sender: TObject);
var
    win_ver: string;
    menu_list, shortcut_list: TWideStringList;
    i : integer;
    mi: TMenuItem;
    s: TXMLTag;
    prefstate: TPrefState;
    adVal: Widestring;

    function _GetAppMenuName(): Widestring;
    begin
        Result := MainSession.Prefs.getString('brand_application_id');
        if (Pos('&', Result) = 0) then begin
            Result := '&' + Result;
        end;
    end;

begin
    TVistaAltFix.Create(Self); // MS Vista hotfix via code gear: http://cc.codegear.com/item/24282

    Application.HookMainWindow(AppKeyDownHook);

    _killshow := false;

    Randomize();

    ActiveChat := nil;
    _docked_forms := TList.Create;
    _auto_login := false;

    // Do translation magic
    AssignUnicodeFont(Self);
    TranslateComponent(Self);

    // setup our tray icon
    _tray_icon := TIcon.Create();

    // setup our master image lists
    RosterTreeImages.setImageList(ImageList1);
    GetRosterWindow().ImageList := RosterTreeImages.ImageList;
    MainbarImages.setImageList(MainbarImageList);

    Exsession.ExCOMToolbar := TExodusToolbar.Create(toolbar1, COMToolbarImages, Self, 'mainbar');
    Exsession.COMToolbar := ExCOMToolbar;

    // if we are testing auto-away, then fire the
    // timer every 1 second, instead of every 10 secs.
    if (ExStartup.testaa) then
        _auto_away_interval := 1
    else
        _auto_away_interval := 10;
    timAutoAway.Interval := _auto_away_interval * 1000;

    // Init our emoticons
    InitializeEmoticonLists();
    getToolbarColorSelect();

    // Setup our caption and the help menus.
    with MainSession.Prefs do begin
        adVal := GetString('brand_ad');
        if adVal <> '' then begin
            try
                imgAd.Picture.LoadFromFile(adVal);
            except
                //TODO:  loggit?
            end;
        end;

        adVal := GetString('brand_ad_url');
        if adVal <> '' then begin
            imgAd.Hint := adVal;
            imgAd.Cursor := crHandPoint;
        end;


        self.Caption := GetString('brand_caption');
        trayShow.Caption := _('Show ') + getAppInfo.Caption;
        trayExit.Caption := _('Exit ') + getAppInfo.Caption;
        RestorePosition(Self);

        File1.Caption := _GetAppMenuName();
        About1.Caption := _('About ') + getAppInfo.Caption;

        menu_list := TWideStringList.Create();
        fillStringlist('brand_help_menu_list', menu_list);

        shortcut_list := TWideStringList.Create();
        fillStringList('brand_help_shortcut_list', shortcut_list);
        for i := 0 to menu_list.Count-1 do begin
            mi := TMenuItem.Create(self);
            mi.Caption := menu_list.Strings[i];
            mi.OnClick := ShowBrandURL;
            if ((i < shortcut_list.Count) and
                (shortcut_list.Strings[i] <> '')) then begin
                mi.ShortCut := TextToShortCut(shortcut_list.Strings[i]);
                RemoveMenuShortCut(mi.ShortCut);
            end;
            Help1.Insert(i, mi);
        end;
        menu_list.Free();
        shortcut_list.Free();

        _enforceConstraints := true;
        frmExodus.Constraints.MinHeight := getInt('brand_min_profiles_window_height');
        frmExodus.Constraints.MinWidth := getInt('brand_min_profiles_window_width');

        mnuContacts_ViewHistory.Visible := getBool('brand_history_search');
    end;
//
//    // Setup our session callback
    _sessioncb := MainSession.RegisterCallback(SessionCallback, '/session');
//
    // setup some branding stuff
    with (MainSession.Prefs) do begin
        btnRoom.Visible := getBool('brand_muc');

        mnuFile_Password.Visible := getBool('brand_changepassword');
        mnuFile_Registration_VCard.Visible := getBool('brand_vcard');
        mnuFile_Registration_EditReg.Visible := getBool('brand_registration');
        mnuPeople_Contacts_SendFile.Visible := getBool('brand_ft');
        btnSendFile.Visible := getBool('brand_ft');
        peerFTAction.Enabled := getBool('brand_ft');
        mnuPeople_Contacts_BlockContact.Visible := getBool('brand_allow_blocking_jids');
        mnuFile_ShowDebugXML.Visible := getBool('brand_show_debug_in_menu');
    end;

    prefstate := PrefController.getPrefState('auto_start');
//
//    // Make sure presence menus have unified captions
////    setRosterMenuCaptions(presOnline, presChat, presAway, presXA, presDND);
////    setRosterMenuCaptions(mnuFile_MyStatus_Available, mnuFile_MyStatus_FreeToChat,
////                            mnuFile_MyStatus_Away, mnuFile_MyStatus_XtendedAway,
////                            mnuFile_MyStatus_DoNotDisturb);
////    setRosterMenuCaptions(trayPresOnline, trayPresChat, trayPresAway,
////        trayPresXA, trayPresDND);
//
//    // Setup the Tabs, toolbar, panel, and roster madness
    restoreMenus(false);
    restoreToolbar();

    // some gui related flags
    _appclosing := false;

    _noMoveCheck := false;
    _tray_notify := false;
    _reconnect_tries := 0;
    _hidden := false;
    _shutdown := false;
    _cleanupComplete := false;
    _close_min := MainSession.prefs.getBool('close_min');
//
//    // Setup the IdleUI stuff..
    _is_autoaway := false;
    _is_autoxa := false;
    _is_broadcast := false;
    _windows_ver := WindowsVersion(win_ver);

    // Setup various callbacks, timers, etc.
    setupAutoAwayTimer();
    s := TXMLTag.Create('startup');
    Self.SessionCallback('/session/prefs', s);
    s.Free();

    Self.setupTrayIcon();

    // If we are supposed to be hidden, make it so.
    if (ExStartup.minimized) then begin
        // This is here because on some systems, the minimize
        // at startup was not working at all.  For some reason
        // some machines don't respond to the SC_MINIMIZE called
        // at this point.
        _killshow := true;
    end;
    Self.Visible := true;

    // Set our default presence info.
    MainSession.setPresence(ExStartup.show, ExStartup.Status, ExStartup.Priority);

    // Init our win32 msg tracker.
    SetLength(_win32_tracker, 20);
    _win32_idx := 0;
    sExodusCWPHook := 0;
    sExodusGMHook := 0;

    OptionsMenuItemsChecks();

    _dockWindowGlued := false;

    _dockWindow := TfrmDockWindow.Create(Application);
    _dockManager := _dockWindow;
    Self.DockSite := false;
    btnActivityWindow.Visible := true;
    trayShowActivityWindow.Visible := true;
    mnuWindows_View_ShowActivityWindow.Visible := true;

    with GetLoginWindow() do begin
        DockWindow(pnlLogin);
        Visible := true;
    end;
    with GetRosterWindow() do begin
        DockWindow(pnlRoster);
        Visible := true;
    end;

    if (MainSession.Prefs.getBool('glue_activity_window')) then begin
        _glueRange := MainSession.Prefs.getInt('glue_activity_window_range');
    end
    else begin
        _glueRange := -1;
    end;

    if (MainSession.Prefs.getInt('msglist_type') = 1) then begin
        // msglist_type = HTML_MSGLIST
        // Need to start up an instance of IE because the first IE startup
        // can be VERY slow.
        _hiddenIEMsgList := TfIEMsgList.Create(nil);
    end
    else begin
        _hiddenIEMsgList := nil;
    end;
    _mnuRegisterUD := nil;

    ExCOMRoster.AddPredefinedMenu('Status', popPresence);
    _PageControlSaveWinProc := tbsView.WindowProc;
    tbsView.WindowProc := _PageControlNewWndProc;    
end;

{---------------------------------------}
function TfrmExodus.WMAppBar(dwMessage: DWORD; var pData: TAppBarData): UINT; stdcall;
begin
    // what the heck fires this?????
    Result := 0;
    MoveWindow(Self.Handle, pData.rc.Left, pData.rc.Top,
        Self.Width, Screen.Height, true);
end;

{---------------------------------------}
procedure TfrmExodus.setupTrayIcon();
var
    picon: TIcon;
begin
    // Create the tray icon, etc..
    picon := TIcon.Create();
    ImageList1.GetIcon(0, picon);
    with _tray do begin
        Wnd := Self.Handle;
        uFlags := NIF_ICON + NIF_MESSAGE + NIF_TIP;
        uCallbackMessage := WM_TRAY;
        hIcon := picon.Handle;
        strPCopy(szTip, getAppInfo().Caption);
        cbSize := SizeOf(_tray);
    end;
    Shell_NotifyIcon(NIM_ADD, @_tray);
    picon.Free();
end;

{---------------------------------------}
procedure TfrmExodus.Startup;
var
    tab_w, roster_w: integer;
begin
    //show the initial roster quickly
    // figure out the width of the msg queue
    tab_w := MainSession.Prefs.getInt(P_TAB_WIDTH);
    roster_w := MainSession.Prefs.getInt(P_ROSTER_WIDTH);

    // Check to see if roster was closed in Maximized state
    // negative width means closed maximized
    if (roster_w < 0) then begin
        roster_w := Abs(roster_w);
        Self.ClientWidth := roster_w;
        Self.ClientHeight := MainSession.Prefs.getInt(P_ROSTER_HEIGHT);
        WindowState := wsMaximized;
    end;

    //set to defaults if we don't have widths
    if ((tab_w <= 0) or (roster_w <= 0)) then begin
        tab_w := 2 * (Self.ClientWidth div 3);
        roster_w := Self.ClientWidth - tab_w - 3;
        MainSession.Prefs.setInt(P_TAB_WIDTH, tab_w);
        MainSession.Prefs.setInt(P_ROSTER_WIDTH, roster_w);
        MainSession.Prefs.setInt(P_ROSTER_HEIGHT, Self.ClientHeight);
    end;

    updateLayoutPrefChange();
    ShowLogin();

    // load up all the plugins..
    if (MainSession.Prefs.getBool('brand_plugs')) then
    begin
        InitPlugins();
        {JJF todo fix this
        if ( IsRequiredPluginsSelected() = false ) then
            StartPrefs(pref_plugins);
        }
    end;

    _expanded := false;
    TAutoOpenEventManager.onAutoOpenEvent('startup');
    // auto-login if enabled, otherwise, show the login window
    // Note that we use a Windows Msg to do this to show the login
    // window async since it's a modal dialog.
    with MainSession.Prefs do begin
        if (ExStartup.debug) then begin
            ShowDebugForm(false);
        end;
        if (ExStartup.auto_login) then begin
            // snag default profile, etc..
            if (ExStartup.priority <> -1) then
                MainSession.Priority := ExStartup.priority;
            Self.DoConnect();
        end
        else
            PostMessage(Self.Handle, WM_SHOWLOGIN, 0, 0);
    end;
    RestoreBands();
end;

{---------------------------------------}
procedure TfrmExodus.DoConnect();
var
    rip: string;
    req_srv, req_a: string;
    pw : WideString;
begin
    btnConnect.Enabled := false;
    mnuFile_Connect.Enabled := false;

    // Hack to deal with fact that the first time IE gets started
    // it has a noticible delay.  By doing the reset here,
    // the delay is "hidden" amongst other login steps
    if (_hiddenIEMsgList <> nil) then begin
        _hiddenIEMsgList.Reset();
    end;

    // Make sure that the active profile
    // has the password field filled out.
    // If not, pop up the password prompt,
    // otherwise, just call connect.

    // NB: For non-std auth agents, set prompt_password
    // accordingly.
    //make sure we have an auth agent
    MainSession.checkAuthAgent();
    if ((not MainSession.Profile.WinLogin) and
        (MainSession.password = '') and
        ((MainSession.getAuthAgent() = nil) or (MainSession.getAuthAgent().prompt_password))) then begin
        pw := '';
        if ((not InputQueryW(_(sPasswordCaption), _(sPasswordPrompt), pw, True)) or
            (pw = '')) then
            begin
                GetLoginWindow().ToggleGUI(lgsDisconnected);
                exit;
            end;
        MainSession.Password := pw;
        // resave this password if we're supposed to
        if (MainSession.Profile.SavePasswd) then begin
            MainSession.Profile.password := pw;
            MainSession.Prefs.SaveProfiles();
        end;
    end;
    MainSession.Prefs.setString('temp-pw', MainSession.Password);
    MainSession.FireEvent('/session/connecting', nil);

    with MainSession.Profile do begin
        // These are fall-thru defaults..
        if (Host <> '') then
            ResolvedIP := Host
        else
            ResolvedIP := Server;
        ResolvedPort := Port;

        // If we should, do SRV lookups
        if (srv) then begin
            _dns_cb := MainSession.RegisterCallback(DNSCallback, '/session/dns');
            req_srv := '_xmpp-client._tcp.' + Server;
            req_a := Server;
            rip := '';

            DebugMsg('Looking up SRV: ' + req_srv);
            GetSRVAsync(MainSession, Resolver, req_srv, req_a);
        end
        else begin
            DebugMsg('Using specified Host/Port: ' + Host + '  ' + IntToStr(Port));
            MainSession.Connect();
        end;
    end;

end;

{---------------------------------------}
procedure TfrmExodus.DNSCallback(event: string; tag: TXMLTag);
var
    t, ip: string;
    p: Word;
begin
    // process the async DNS request
    MainSession.UnRegisterCallback(_dns_cb);
    _dns_cb := -1;
    t := tag.getAttribute('type');
    if (t = 'failed') then with MainSession.Profile do begin
        // stringprep here for idn's
        ResolvedIP := xmpp_nameprep(Server);
        if (ssl = ssl_port) then
            ResolvedPort := 5223
        else
            ResolvedPort := 5222;

        DebugMsg('Direct DNS failed.. Using server: ' + Server);
        MainSession.Connect();
        exit;
    end;

    // get the bits off the packet
    ip := Trim(tag.getAttribute('ip'));
    p := StrToIntDef(tag.getAttribute('port'), 0);

    with MainSession.Profile do begin
        if (ip <> '') then
            ResolvedIP := ip
        else
            ResolvedIP := Server;

        if (p > 0) then
            ResolvedPort := p
        else
            ResolvedPort := 5222;

        if ((ResolvedPort = 5222) and (ssl = ssl_port)) then
            ResolvedPort := 5223;

        if (p > 0) then
            DebugMsg('Got SRV: ' + ResolvedIP + '  ' + IntToStr(ResolvedPort))
        else
            DebugMsg('Got A: ' + ResolvedIP + '  ' + IntToStr(ResolvedPort));
    end;

    if (not MainSession.Active) then MainSession.Connect();
end;


{---------------------------------------}
procedure TfrmExodus.setTrayInfo(tip: string);
begin
    // setup the tray tool-tip
    _tray_tip := tip;
    StrPCopy(@_tray. szTip, tip);
    Shell_NotifyIcon(NIM_MODIFY, @_tray);
end;

{---------------------------------------}
procedure TfrmExodus.setTrayIcon(iconNum: integer);
begin
    // setup the tray icon based on a specific icon index
    _tray_icon_idx := iconNum;
    ImageList1.GetIcon(iconNum, _tray_icon);
    _tray.hIcon := _tray_icon.Handle;
    Shell_NotifyIcon(NIM_MODIFY, @_tray);
end;

{---------------------------------------}
procedure TfrmExodus.CancelConnect();
begin
    _logoff := true;

    // we don't care about DNS lookups anymore
    if (_dns_cb <> -1) then begin
        MainSession.UnRegisterCallback(_dns_cb);
        _dns_cb := -1;
        CancelDNS();
        MainSession.FireEvent('/session/disconnected', nil);
    end
    else if (MainSession.Active) then
        MainSession.Disconnect()
    else
        timReconnect.Enabled := false;
end;

{---------------------------------------}
procedure TfrmExodus.mnuPeople_Contacts_SendFileClick(Sender: TObject);
begin
//    frmRosterWindow.popSendFile.Click();
end;

procedure TfrmExodus.SessionCallback(event: string; tag: TXMLTag);
var
    ssl, rtries, code: integer;
    msg : TMessage;
    tmp: TXMLTag;
    fp, m: Widestring;
    fps: TWidestringlist;
    i: integer;
    extExists, RTEnabled: boolean;
    logmsg: TJabberMessage;
    tmpjid: TJabberID;
    rawXMLTag: TXMLTag;
begin
    // session related events
    if event = '/session/connected' then begin
        timReconnect.Enabled := false;
        _logoff := false;
        _reconnect_tries := 0;
        setTrayIcon(1);
        btnDisconnect.Enabled := true;
        mnuFile_Disconnect.Enabled := true;
        btnConnect.Enabled := false;
        mnuFile_Connect.Enabled := false;
        btnOptions.Enabled := false;
    end

    else if event = '/session/error/auth' then begin
        _logoff := true;
        MainSession.Profile.password := '';
        MessageDlgW(_(sAuthError), mtError, [mbOK], 0);

        // when the new user wizard is being used, NoAuth is set.
        if (not MainSession.NoAuth) then begin
            PostMessage(Self.Handle, WM_DISCONNECT, 0, 0);
            PostMessage(Self.Handle, WM_SHOWLOGIN, 0, 0);
        end;
        exit;
    end

    else if (event = '/session/error/tls') then begin
        MessageDlgW(_('There was an error trying to setup SSL.'), mtError,
            [mbOK], 0);
        _logoff := true;
        PostMessage(Self.Handle, WM_DISCONNECT, 0, 0);
        PostMessage(Self.Handle, WM_SHOWLOGIN, 0, 0);
    end

    else if ((event = '/session/error/ssl') and (tag <> nil)) then begin
        fp := tag.getAttribute('fingerprint');

        // check for an allowed cert.
        fps := TWidestringlist.Create();
        MainSession.Prefs.fillStringlist('allow-certs', fps);
        if (fps.IndexOf(fp) >= 0) then begin
            fps.Free();
            exit;
        end;

        ssl := ShowSSLWarn(tag.Data(), fp);
        if (ssl = sslAllowAlways) then begin
            // save this cert in prefs
            fps.Add(fp);
            MainSession.Prefs.setStringlist('allow-certs', fps);
        end
        else if (ssl = sslReject) then begin
            // kick the connection off
            _logoff := true;
            PostMessage(Self.Handle, WM_DISCONNECT, 0, 0);
            PostMessage(Self.Handle, WM_SHOWLOGIN, 0, 0);
        end;
        fps.Free();
    end

    else if event = '/session/compressionerrror' then begin
        if tag <> nil then
            DebugMsg(tag.xml);
        MessageDlgW(_('There was an error trying to setup compression.'), mtError,
            [mbOK], 0);
        _logoff := true;
        PostMessage(Self.Handle, WM_DISCONNECT, 0, 0);
        PostMessage(Self.Handle, WM_SHOWLOGIN, 0, 0);
    end

    else if event = '/session/error/reg' then begin
        _logoff := true;

        m := _(sRegError);
        if (tag <> nil) then begin
            // try to find out a more detailed error message
            tmp := tag.GetFirstTag('error');
            if (tmp <> nil) then begin
                code := StrToIntDef(tmp.GetAttribute('code'), 0);
                case code of
                    409: m := m + WideFormat(_(sUserExistsErr), [MainSession.Profile.Username]);
                    501: m := m + _(sRegNotImplErr);
                    else
                        m := m + ''#13#10' ERROR: ' + ErrorText(tmp);
                end;
            end;
        end;

        MessageDlgW(m, mtError, [mbOK], 0);
        PostMessage(Self.Handle, WM_DISCONNECT, 0, 0);
        exit;
    end

    else if event = '/session/error/noaccount' then begin
        if (MessageDlgW(_(sAuthNoAccount), mtConfirmation, [mbYes, mbNo], 0) = mrNo) then begin
            // Just disconnect, they don't want an account
            _logoff := true;
            PostMessage(Self.Handle, WM_DISCONNECT, 0, 0);
        end
        else begin
            // create the new account
            _new_account := true;
            MainSession.CreateAccount();
        end;
    end

    else if event = '/session/authenticated' then with MainSession do begin
        Self.Caption := MainSession.Prefs.getString('brand_caption') + ' - ' + MainSession.Profile.getJabberID().getDisplayJID();


        setTrayInfo(Self.Caption);
        imgSSL.Visible := MainSession.SSLEnabled;
        GridPanel1.Height := pnlStatus.Height + 2;
        imgSSL.Align := alClient;
        imgPresence.Align := alClient;
        imgSSL.AutoSize := false;
        imgPresence.AutoSize := false;
        //GridPanel1.Realign;

        // Accept files dragged from Explorer
        // Only do this for normal (non-polling) connections
        if ((MainSession.Profile.ConnectionType = conn_normal) and
            (MainSession.Prefs.getBool('brand_ft'))) then
            DragAcceptFiles(Handle, True);

        // 3. Make the roster the active tab
        // 4. Activate the menus
        // 5. turn on the auto-away timer
        // 6. check for new brand.xml file
        // 7. check for new version
        ShowRoster();

        restoreMenus(true);
        if (_valid_aa) then timAutoAway.Enabled := true;
        InitUpdateBranding();
        InitAutoUpdate();

        // if we have a new account, prompt for reg info
        if (_new_account) then begin
            if (MessageDlgW(_(sNewAccount), mtConfirmation, [mbYes, mbNo], 0) = mrYes) then begin
                mnuRegistrationClick(Self);
            end;
            _new_account := false;
        end;
        // Play any pending XMPP actions
        PlayXMPPActions();

        // We are logged in, so change main form to roster witdth
        with MainSession.Prefs do begin
            frmExodus.Constraints.MinHeight := getInt('brand_min_roster_window_height');
            frmExodus.Constraints.MinWidth := getInt('brand_min_roster_window_width');
        end;

        btnOptions.Enabled := true;
        _sendInitPresence();
    end

    else if (event = '/session/disconnected') then begin
        // Make sure windows knows we don't want files
        // dropped on us anymore.
        if (MainSession.Profile.ConnectionType = conn_normal) then
            DragAcceptFiles(Handle, False);

        timAutoAway.Enabled := false;
        CloseSubscribeWindows();

        // Close whatever rooms we have
        CloseAllRooms();
        CloseAllChats();
        //stop dock window flashing now that we are disconnected
        StopFlash(_dockwindow); //from notify.pas

        Self.Caption := getAppInfo().Caption;
        setTrayInfo(Self.Caption);
        setTrayIcon(0);

        imgSSL.Visible := false;

        _new_account := false;
        restoreMenus(false);
        //if disconnect happened because of a close request, post a message
        //so close can continue *after* every other listener has a chance
        //to respond to session disconnect event.
        if (_appclosing) then
            PostMessage(Self.Handle, WM_CLOSEAPP, 0, 0)
        else if (not _logoff) then with timReconnect do begin
            if ((_is_autoaway) or (_is_autoxa)) then
                // keep _last_* the same.. do nothing
            else begin
                _last_show := MainSession.Show;
                _last_status := MainSession.Status;
                _last_priority := MainSession.Priority;
            end;

            inc(_reconnect_tries);

            rtries := MainSession.Prefs.getInt('recon_tries');
            if (rtries < 0) then rtries := 3;

            if (_reconnect_tries <= rtries) then begin
                setupReconnect();
            end
            else begin
                DebugMsg('Attempted to reconnect too many times.');
                PostMessage(Self.Handle, WM_SHOWLOGIN, 0, 0);
             end;

        end
        else begin
            _last_show := '';
            _last_status := '';
        end;
        btnConnect.Enabled := true;
        mnuFile_Connect.Enabled := true;
        btnOptions.Enabled := true;

        ShowLogin();

        // Change back to profile width from roster width
        with MainSession.Prefs do begin
            frmExodus.Constraints.MinHeight := getInt('brand_min_profiles_window_height');
            frmExodus.Constraints.MinWidth := getInt('brand_min_profiles_window_width');
        end;
    end
    else if event = '/session/commtimeout' then begin
        timAutoAway.Enabled := false;
        _logoff := true;
    end

    else if event = '/session/commerror' then begin
        timAutoAway.Enabled := false;
    end

    else if event = '/session/error/stream' then begin
        // we got a stream error.
        // _logoff is set to tell the client to NOT to auto-reconnect
        // This prevents the clients from resource-battling
        _logoff := true;
    end

    else if event = '/session/prefs' then begin
        // some private vars we want to cache
        with MainSession.prefs do begin
            if (getBool('snap_on')) then
                _edge_snap := getInt('edge_snap')
            else
                _edge_snap := -1;
            _close_min := getBool('close_min');

            use_emoticons := getBool('emoticons');
        end;

        // setup the Exodus window..
        if (MainSession.Prefs.getBool('window_ontop')) then
            SetWindowPos(Self.Handle, HWND_TOPMOST, 0,0,0,0,
                SWP_NOMOVE + SWP_NOREPOSITION + SWP_NOSIZE)
        else
            SetWindowPos(Self.Handle, HWND_NOTOPMOST, 0,0,0,0,
                SWP_NOMOVE + SWP_NOREPOSITION + SWP_NOSIZE);

        if (MainSession.Prefs.getBool('window_toolbox')) then begin
            if (Self.BorderStyle <> bsSizeToolWin) then begin
                // requires a restart of the application
                Self.BorderStyle := bsSizeToolWin;
            end;
        end
        else begin
            if (Self.BorderStyle <> bsSizeable) then begin
                Self.BorderStyle := bsSizeable;
            end;
        end;

        // reset the tray icon stuff
        Shell_NotifyIcon(NIM_DELETE, @_tray);
        Self.setupTrayIcon();
        setTrayInfo(_tray_tip);
        setTrayIcon(_tray_icon_idx);

        // do gui stuff
        if ((tag = nil) or (tag.Name <> 'startup')) then begin
            //updateLayoutPrefChange();
            //This is gross. For all TfrmDockable windows, call the onDock or onFloat
            //events, allowing the windows to update preferences.
            for i := 0 to Screen.FormCount - 1 do begin
                if (Screen.Forms[i].InheritsFrom(TfrmDockable)) then begin
                    if (TfrmDockable(Screen.Forms[i]).Docked) then
                        TfrmDockable(Screen.Forms[i]).OnDocked()
                    else
                        TfrmDockable(Screen.Forms[i]).OnFloat()
                end;
            end;

        end;
        restoreMenus(MainSession.Active);
        restoreToolbar();
        restoreAlpha();
        //add or remove xhtml-im caps feature based on pref. Push presence if
        //cpas ext modified.
        //extExists := (MainSession.GetExtList.IndexOf('xhtml-im') <> -1);
        extExists := jSelfCaps.hasFeature(XMLNS_XHTMLIM);
        RTEnabled := MainSession.Prefs.getBool('richtext_enabled');
        if (extExists <> RTEnabled) then begin
            if (not RTEnabled) then
                jSelfCaps.RemoveFeature(XMLNS_XHTMLIM)
            else
                jSelfCaps.AddFeature(XMLNS_XHTMLIM);

            //send presence if not starting up
            if ((tag = nil) or (tag.Name <> 'startup')) then
                MainSession.setPresence(MainSession.Show, MainSession.Status, MainSession.Priority);
        end;

        if (MainSession.Prefs.getBool('glue_activity_window')) then begin
            _glueRange := MainSession.Prefs.getInt('glue_activity_window_range');
        end
        else begin
            _glueRange := -1;
        end;
        
    end

    else if (event = '/session/presence') then begin
        //ShowPresence(MainSession.show);
        UpdatePresenceDisplay();

        // don't send message on autoaway
        if (_is_autoaway or _is_autoxa) then exit;

        //don't send message if auto-return
        if (_is_broadcast) then exit;

        // Send a windows msg so other copies of Exodus will change their
        // status to match ours.
        if (not MainSession.Prefs.getBool('presence_message_send')) then exit;
        msg.LParamHi := GetPresenceAtom(MainSession.Show);
        msg.LParamLo := GetPresenceAtom(MainSession.Status);
        PostMessage(HWND_BROADCAST, sExodusPresence, self.Handle, msg.LParam);
    end

    else if (event = '/session/log_message') then begin
        // We got a message to log using the log plugins
        if (tag <> nil) then begin
            logmsg := nil;
            rawXMLTag := tag.GetFirstTag('raw_msg_xml');
            if ((rawXMLTag <> nil) and
                (rawXMLTag.ChildCount > 0)) then begin
                rawXMLTag := rawXMLTag.GetFirstTag('message');
                if (rawXMLTag <> nil) then begin
                    logmsg := TJabberMessage.Create(rawXMLTag);
                end;
            end;

            if (logmsg = nil) then begin
                logmsg := TJabberMessage.Create(tag);
            end;

            logmsg.Time := StrToDateTime(tag.GetFirstTag('time').Data);
            tmpjid := TJabberID.Create(logmsg.FromJID);
            if (tmpjid.getDisplayJID() = MainSession.BareJid) then begin
                tmpjid.Free;  // Hack to get around problems with displayname and being logged in with multiple resources.
                tmpjid := TJabberID.Create(MainSession.BareJid);
                logmsg.isMe := true;
                logmsg.Nick := DisplayName.getDisplayNameCache().getDisplayName(tmpjid);
            end
            else begin
                logmsg.isMe := false;
                logmsg.Nick := DisplayName.getDisplayNameCache().getDisplayName(tmpjid);
            end;
            if (tag.GetFirstTag('isme') <> nil) then
                logmsg.isMe := true;

            LogMessage(logmsg);
            tmpjid.Free();
            logmsg.Free();
        end
    end

    else if (event = '/session/error-out-of-system-resources') then
    begin
        DebugMessage(_(sOutOfSystemResourcesError));
        MessageBoxW(Application.Handle,
                   PWideChar(_(sOutOfSystemResourcesError)),
                   PWideChar(MainSession.Prefs.GetString('brand_caption')),
                   MB_OK or MB_ICONERROR);
        Application.Terminate();
    end

    else if (event = '/session/force_shutdown') then
    begin
        // A plugin/extrenal app has decided to force Exodus to shutdown
        _ApprovedExitWithCOMActive := true; 
        Self.Close();
    end;
end;

{---------------------------------------}
procedure TfrmExodus._sendInitPresence();
begin
    // set our presence now that we have our roster

    // Don't broadcast our initial presence
    _is_broadcast := true;
    if (_is_autoxa) then
        setAutoXA()
    else if (_is_autoaway) then
        setAutoAway()
    else if (_last_show <> '') then
        MainSession.setPresence(_last_show, _last_status, _last_priority)
    else
        MainSession.setPresence(MainSession.Show, MainSession.Status, MainSession.Priority);
    _is_broadcast := false;
    //re-load authed desktop
    TAutoOpenEventManager.onAutoOpenEvent('authed');
end;

{---------------------------------------}
procedure TfrmExodus.setupReconnect();
var
    rint: integer;
begin
    // Setup a reconnect timer
    rint := MainSession.Prefs.getInt('recon_time');
    if (rint <= 0) then
        _reconnect_interval := Trunc(Random(20)) + 2
    else
        _reconnect_interval := rint;

    // Make sure the timer is set to 1 second incs.
    timReconnect.Interval := 1000;
    DebugMsg('Setting reconnect timer to: ' + IntToStr(_reconnect_interval));

    _reconnect_cur := 0;
//    frmRosterWindow.aniWait.Visible := false;
    PostMessage(Self.Handle, WM_RECONNECT, 0, 0);
end;

{---------------------------------------}
procedure TfrmExodus.restoreToolbar;
begin
    // setup the toolbar based on prefs
    with MainSession.Prefs do begin
        pnlToolbar.Visible := getBool('toolbar');
        mnuWindows_View_ShowToolbar.Checked := pnlToolbar.Visible;

        popShowOnline.Checked := getBool('roster_only_online');
        popShowAll.Checked := not popShowOnline.Checked;
    end;
    Toolbar1.Wrapable := false;
end;

{---------------------------------------}
procedure TfrmExodus.restoreAlpha;
var
    alpha: boolean;
begin
    // setup the alpha-transparency for the main window
    // based on the prefs
    with MainSession.Prefs do begin
        alpha := getBool('roster_alpha');
        Self.AlphaBlend := (alpha);
        if alpha then
            Self.AlphaBlendValue := MainSession.Prefs.getInt('roster_alpha_val')
        else
            Self.AlphaBlendValue := 255;
{
        if (frmMsgQueue <> nil) then begin
            frmMsgQueue.lstEvents.Color := TColor(getInt('roster_bg'));
            frmMsgQueue.txtMsg.Color := TColor(getInt('roster_bg'));
            AssignDefaultFont(frmMsgQueue.txtMsg.Font);
        end;
}        
    end;
end;

{---------------------------------------}
procedure TfrmExodus.restoreMenus(enable: boolean);
begin
    // (dis)enable the menus
    trayPresence.Enabled := enable;

    // (dis)enable the tray menus
    trayPresence.Enabled := enable;
    trayDisconnect.Enabled := enable;

    // Enable toolbar btns
    btnOnlineRoster.Enabled := enable;
    btnAddContact.Enabled := enable;
    btnRoom.Enabled := enable;
    btnFind.Enabled := enable;
    btnBrowser.Enabled := enable;
    if (not enable) then // if all these other toolbar buttons are disabling, then send file should as well.
        btnSendFile.Enabled := false;

    // Build the custom presence menus.
    //if (enable) then begin
    //    BuildPresMenus(mnuPresence, presOnlineClick);
    //end;

    // File Menu
    mnuFile_Connect.Visible := not enable;
    mnuFile_Disconnect.Visible := enable;
    mnuFile_MyStatus.Enabled := enable;
    //mnuFile_MyProfiles.Enabled := not enable;

    mnuFile_Password.Enabled := enable;
    mnuFile_Registration.Enabled := enable;

    // Build the custom presence menus.
    if (enable) then begin
        BuildPresMenus(mnuFile_MyStatus, presOnlineClick);
        BuildPresMenus(trayPresence, presOnlineClick);
        BuildPresMenus(popPresence, presOnlineClick);
    end;

    // deal with connect tool bar buttons.
    // done this way to try and avoid tool bar size "bouncing"
    Toolbar1.AutoSize := false;
    if (enable) then begin
        btnConnect.Visible := not enable;
        mnuFile_Connect.Enabled := not enable;

        btnDisconnect.Visible := enable;
        mnuFile_Disconnect.Enabled := enable;
    end
    else begin
        btnDisconnect.Visible := enable;
        mnuFile_Disconnect.Enabled := enable;

        btnConnect.Visible := not enable;
        mnuFile_Connect.Enabled := not enable;
    end;
    Toolbar1.AutoSize := true;


    // People Menu
    People.Enabled := enable;

    // Options Menu
    mnuWindows_View_ShowInstantMessages1.Enabled := enable;
    //Windows Menu
end;

{---------------------------------------}
procedure TfrmExodus.CTCPCallback(event: string; tag: TXMLTag);
{** JJF msgqueue refactor
var
    e: TJabberEvent;
**}    
begin
{** JJF msgqueue refactor
    // record some kind of CTCP result
    if ((tag <> nil) and (tag.getAttribute('type') = 'result')) then begin
        if MainSession.IsPaused then
            MainSession.QueueEvent(event, tag, Self.CTCPCallback)
        else begin
            e := CreateJabberEvent(tag);
            e.elapsed_time := SafeInt(tag.GetAttribute('iq_elapsed_time'));
            RenderEvent(e); //msg queue now own event, don't free
        end;
    end
**}    
end;

{**
 *  Cleanup objects, registered callbacks etc. Prepare for shutdown
**}
procedure TfrmExodus.cleanup();
begin
    SaveBands();

    //mainsession should never be nil here. It is created before this object
    //and only destroyed on ExSession finalization.
    // Unhook the auto-away DLL
    StateForm.TAutoOpenEventManager.onAutoOpenEvent('shutdown');

    if (_idle_hooks <> 0) then begin
        _StopHooks();
        _idle_hooks := 0;
    end;

    // Unhook the other Win32 hooks.
    if (sExodusGMHook <> 0) then begin
        UnHookWindowsHookEx(sExodusGMHook);
        sExodusGMHook := 0;
    end;
    if (sExodusCWPHook <> 0) then begin
        UnhookWindowsHookEx(sExodusCWPHook);
        sExodusCWPHook := 0;
    end;

    CloseDebugForm();

    // Unload all of the remaining plugins
    UnloadPlugins();

    // Close the Activity Window
    _dockWindow.Close();

    // Unregister callbacks, etc.
    MainSession.UnRegisterCallback(_sessioncb);
    MainSession.Prefs.SavePosition(Self);

    // Clear our master icon list
    RosterTreeImages.Clear();

    // Kill the tray icon stuff
    if (_tray_icon <> nil) then
        FreeAndNil(_tray_icon);

    if (_docked_forms <> nil) then
        FreeAndNil(_docked_forms);

    Shell_NotifyIcon(NIM_DELETE, @_tray);
    // Close the roster window
    RosterForm.CloseRosterWindow();

    _cleanupComplete := true;
end;

{**
 *  Busywait until cleanupmethod is complete by checking _cleanupComplete flag
**}
procedure TfrmExodus.waitForCleanup();
begin
    repeat
        Application.ProcessMessages();
    until (_cleanupComplete);
end;

{---------------------------------------}
{**
 *  Expect this method to be called twice when connected.
 *  once for the initial close request, once when Close is called
 *  in the WMCLoseApp message handler, which is posted by session/disconnect
 *  event.
**}
procedure TfrmExodus.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
    //mainsession should never be nil here, it is created before this object
    //and destroyed in ExSession finalization

    // Kill any History searches that may be in progress as they hold
    // COM objects open and will trip the next check.
    HistorySearchManager.CancelAllSearches();

    // Ask before closing in COM server situation
    // Ignore self reference (ComServer.ObjectCount > 1)
    if ((MainSession.Prefs.getBool('brand_warn_close_com_server')) and
        (ComServer.ObjectCount > 1) and
        (not _ApprovedExitWithCOMActive))then begin
        if (MessageDlgW(_('Other applications currently depend on this application.  Exiting this application may cause unpredicatable results in those applications.  Do you wish to exit?'), mtConfirmation, [mbYes, mbNo],0) = mrNo) then begin
            CanClose := false;
            exit;
        end;
    end;
    _ApprovedExitWithCOMActive := true;

    // Disable showing error dialog when exiting
    Application.OnException := CatchersMit.gotExceptionNoDlg;

    //Save our current width...
    if (WindowState <> wsMaximized) then begin
        // not maximized so go ahead and save our current width
        MainSession.Prefs.setInt(PrefController.P_ROSTER_WIDTH, Self.ClientWidth);
        MainSession.Prefs.setInt(PrefController.P_ROSTER_HEIGHT, Self.ClientHeight);
    end
    else begin
        // we are maxmized so pull the last width, and save it as a negative to indicate Maximzed.
        MainSession.Prefs.setInt(PrefController.P_ROSTER_WIDTH, (-1 * Abs(MainSession.Prefs.getInt(PrefController.P_ROSTER_WIDTH))));
        MainSession.Prefs.setInt(PrefController.P_ROSTER_HEIGHT, MainSession.Prefs.getInt(PrefController.P_ROSTER_HEIGHT));
    end;

    // If we are not already disconnected, then
    // disconnect. Once we successfully disconnect,
    // we'll close the form properly (xref _appclosing)
    if (MainSession.Active) and (not _appclosing)then begin
        _appclosing := true;
        _logoff := true;
        TAutoOpenEventManager.onAutoOpenEvent('disconnected');
        MainSession.Disconnect();
        CanClose := false;
    end
    else
        cleanup();
end;

procedure TfrmExodus.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    Action := caFree;
end;

{---------------------------------------}

{---------------------------------------}
procedure TfrmExodus.btnAddContactClick(Sender: TObject);
var
    cp: TPoint;
begin
    // add a contact
    //ShowAddContact();
    if MainSession.Active then begin
        cp := btnAddContact.ClientOrigin;
        cp.Y := cp.Y + btnAddContact.ClientHeight;
        popCreate.Popup(cp.x, cp.y);
    end;
end;

{---------------------------------------}
procedure TfrmExodus.mnuConferenceClick(Sender: TObject);
begin
    // Join a TC Room
    StartJoinRoom();
end;

{---------------------------------------}
procedure TfrmExodus.mnuContacts_ViewHistoryClick(Sender: TObject);
begin
    inherited;

    StartShowHistory();
end;

{---------------------------------------}
procedure TfrmExodus.mnuFile_ConnectClick(Sender: TObject);
begin
    btnConnect.Enabled := false;
    btnOptions.Enabled := false;
    mnuFile_Connect.Enabled := false;
    GetLoginWindow().lstProfilesClick(Sender);
    btnActivityWindow.Enabled := false;
    mnuWindows_View_ShowActivityWindow.Enabled := false;
    trayShowActivityWindow.Enabled := false;
end;

{---------------------------------------}
procedure TfrmExodus.mnuOptions_Notifications_ContactOfflineClick(Sender: TObject);
begin

end;

{---------------------------------------}
procedure TfrmExodus.mnuOptions_Notifications_ContactOnlineClick(Sender: TObject);
begin
end;

{---------------------------------------}
procedure TfrmExodus.FormResize(Sender: TObject);
begin
    // Check for constraints
    if (_enforceConstraints) then begin
        if (frmExodus.Width < frmExodus.Constraints.MinWidth) then
            frmExodus.Width := frmExodus.Constraints.MinWidth;
        if (frmExodus.Height < frmExodus.Constraints.MinHeight) then
            frmExodus.Height := frmExodus.Constraints.MinHeight;
    end;
end;

{---------------------------------------}
procedure TfrmExodus.Preferences1Click(Sender: TObject);
begin
    // Show the prefs
    StartPrefs();
end;



{---------------------------------------}
procedure TfrmExodus.ClearMessages1Click(Sender: TObject);
begin
    // Clear events from the list view.
{
    if (frmMsgQueue <> nil) then with frmMsgQueue do begin
        while (lstEvents.Items.Count > 0) do
            frmMsgQueue.RemoveItem(0);
    end;
}    
end;

{---------------------------------------}
procedure TfrmExodus.WMWindowPosChanging(var msg: TWMWindowPosChanging);
var
    r: TRect;
begin
    // Handle snapping this window to the screen edges.
    if _noMoveCheck then exit;
    if _edge_snap = -1 then exit;

    If (((SWP_NOMOVE or SWP_NOSIZE) and msg.WindowPos^.flags) <>
        (SWP_NOMOVE or SWP_NOSIZE)) and (msg.WindowPos^.hwnd = Self.Handle) then begin
        {  Window is moved or sized, get usable screen area. }

        SystemParametersInfo( SPI_GETWORKAREA, 0, @r, 0 );

        {
        Check if operation would move part of the window out of this area.
        If so correct position and, if required, size, to keep window fully
        inside the workarea. Note that simply adding the SWM_NOMOVE and
        SWP_NOSIZE flags to the flags field does not work as intended if
        full dragging of windows is disabled. In this case the window would
        snap back to the start position instead of stopping at the edge of the
        workarea, and you could still move the drag rectangle outside that
        area.
        }

        with msg.WindowPos^ do begin
            if abs(x -  r.left) < _edge_snap then x:= r.left;
            if abs(y -  r.top) < _edge_snap then y := r.top;

            if abs( (x + cx) - r.right ) < _edge_snap then begin
                x := r.right - cx;
                if abs(x -  r.left) < _edge_snap then begin
                    cx := cx - (r.left - x);
                    x := r.Left;
                end; { if }
            end; { if }

            if abs( (y + cy) - r.bottom ) < _edge_snap then begin
                y := r.bottom - cy;
                if abs(y -  r.top) < _edge_snap then begin
                    cy := cy - (r.top - y);
                    y := r.top;
                end; { if }
            end; { if }
        end; { With }

    end;

    inherited;
end;

{---------------------------------------}
procedure TfrmExodus.FormShow(Sender: TObject);
begin
    _noMoveCheck := false;

    if (_killshow) then begin
        // This is here because on some systems, the minimize
        // at startup was not working at all.  For some reason
        // some machines don't respond to the SC_MINIMIZE at
        // the point it was being called.
        _killshow := false;
        _hidden := true;
        PostMessage(Self.Handle, WM_SYSCOMMAND, SC_MINIMIZE , 0);
    end;
end;

{---------------------------------------}
procedure TfrmExodus.btnDelPersonClick(Sender: TObject);
begin
    // delete the current contact
    //frmRosterWindow.popRemoveClick(Self);
end;

procedure TfrmExodus.btnFindClick(Sender: TObject);
begin
    StartSearch('');
end;

{---------------------------------------}
procedure TfrmExodus.ShowXML1Click(Sender: TObject);
begin
    if (isDebugShowing) then
      CloseDebugForm()
    else
      ShowDebugForm();
end;

{---------------------------------------}
procedure TfrmExodus.Exit2Click(Sender: TObject);
begin
    // Close the whole honkin' thing
    _shutdown := true;
    Self.Close;
end;

{---------------------------------------}
procedure TfrmExodus.JabberorgWebsite1Click(Sender: TObject);
begin
    // goto www.jabber.org
    ShellExecute(Application.Handle, 'open', 'http://www.jabber.org', '', '', SW_SHOW);
end;

{---------------------------------------}
procedure TfrmExodus.JabberCentralWebsite1Click(Sender: TObject);
begin
    // goto www.jabberstudio.org
    ShellExecute(Application.Handle, 'open', 'http://www.jabberstudio.org', '', '', SW_SHOW);
end;

{---------------------------------------}
procedure TfrmExodus.SubmitExodusFeatureRequest1Click(Sender: TObject);
begin
    // goto http://www.jabberstudio.org/projects/exodus/features/add.php
    ShellExecute(Application.Handle, 'open', 'http://www.jabberstudio.org', '', '', SW_SHOW);

end;

{---------------------------------------}
procedure TfrmExodus.SaveBands();
var I, ID: Integer;
    aFile: TWideStringList;
    function Value(v: Integer; ID: Integer; Key: String): String; overload;
    begin
      Result := Format('%d-%s=%d', [ID, Key, v])
    end;
    function Value(v: String; ID: Integer; Key: String): String; overload;
    begin
      Result := Format('%d-%s=%s', [ID, Key, v])
    end;
    function Value(b: Boolean; ID: Integer; Key: String): String; overload;
    begin
      if b then
        Result := Format('%d-%s=true', [ID, Key])
      else
        Result := Format('%d-%s=false', [ID, Key]);
    end;
begin
  I := 0; ID := 0; 
  aFile := TWideStringList.Create;

  { Parse all available coolbands } 
  while I=I do // Make this an endless loop 
  begin 
    try 
      ID := Toolbar.Bands.Items[I].ID;
    except 
      on EListError do 
      begin 
        MainSession.Prefs.setStringlist('bands', aFile);
        aFile.Free;
        exit;
      end; 
    end; 

    { Write it's properties to file - Set } 
    aFile.Add(Value(Toolbar.Bands.Items[I].Text, ID, 'Name'));

    aFile.Add(Value(Toolbar.Bands.Items[I].Index, ID, 'Index'));
    aFile.Add(Value(Toolbar.Bands.Items[I].Width, ID, 'Width'));

    aFile.Add(Value(Toolbar.Bands.Items[I].Break, ID, 'Break'));
    aFile.Add(Value(Toolbar.Bands.Items[I].FixedSize, ID, 'FixedSize'));
    aFile.Add(Value(Toolbar.Bands.Items[I].HorizontalOnly, ID, 'HorizontalOnly'));
    aFile.Add(Value(Toolbar.Bands.Items[I].Visible, ID, 'Visible'));

    outputdebugMsg(PAnsiChar(Format('Save-Band:%s, Index:%d, Width:%d, Break:%d, Control.Width:%d',
                                      [Toolbar.Bands.Items[I].Text
                                      ,Toolbar.Bands.Items[I].Index
                                      ,Toolbar.Bands.Items[I].Width
                                      ,Integer(Toolbar.Bands.Items[I].Break)
                                      ,Toolbar.Bands.Items[I].Control.Width
                                      ])));

    I := I+1;
  end;
end;

{---------------------------------------}
procedure TfrmExodus.RestoreBands();
var I, ID, Value : Integer;
    aFile: TWideStringList;
    bValue: Boolean;
    function IsValid(ID: Integer; Key: String; Out V: Integer): boolean;  overload;
    var sValue : String;
    begin
      try
        sValue := aFile.Values[IntToStr(ID)+'-'+Key];
        if Length(sValue)>0 then begin
          V := StrToInt(sValue);
          Result := true;
        end else
          Result := false;
      except
        Result := false;
      end;
    end;
    function IsValid(ID: Integer; Key: String; Out V: Boolean): boolean;  overload;
    var sValue : String;
    begin
      try
        sValue := aFile.Values[IntToStr(ID)+'-'+Key];
        if Length(sValue)>0 then begin
          Result := true;
          if CompareText(sValue, 'false')=0 then
            V := false
          else if CompareText(sValue, 'true')=0 then
            V := true
          else
            Result := false;
        end else
          Result := false;
      except
          Result := false;
      end;
    end;
begin
  I := 0; ID := 0;
  aFile := TWideStringList.Create;

  try
      try
        MainSession.Prefs.fillStringlist('bands', aFile);

        { Parse all available Tcoolband (s), ttoolbar }
        while I=I do
        begin
          try
            ID := Toolbar.Bands.Items[I].ID;
          except
            on EListError do Exit;
          end;

          { Restore properties from file - Get }
          if IsValid (ID, 'Index', Value) then
            Toolbar.Bands.Items[I].Index := Value ;
          if IsValid (ID, 'Width', Value) then
            Toolbar.Bands.Items[I].Width := Value;

          Toolbar.Bands.Items[I].MinWidth := Toolbar.Bands.Items[I].Control.Width;

          if IsValid (ID, 'Break', bValue) then
            Toolbar.Bands.Items[I].Break := bValue;
          if IsValid (ID, 'FixedSize', bValue) then
            Toolbar.Bands.Items[I].FixedSize := bValue;
          if IsValid (ID, 'HorizontalOnly', bValue) then
            Toolbar.Bands.Items[I].HorizontalOnly := bValue;
          if IsValid (ID, 'Visible', bValue) then
            Toolbar.Bands.Items[I].Visible := bValue;

          outputdebugMsg(PAnsiChar(Format('Restore-Band:%s, Index:%d, Width:%d, Break:%d, Control.Width:%d',
                                          [Toolbar.Bands.Items[I].Text
                                          ,Toolbar.Bands.Items[I].Index
                                          ,Toolbar.Bands.Items[I].Width
                                          ,Integer(Toolbar.Bands.Items[I].Break)
                                          ,Toolbar.Bands.Items[I].Control.Width
                                          ])));
          I := I+1;
        end;
      except
          OutputDebugString(PAnsiChar('Exception in Restore'));
      end;
      ToolBar.ParentColor := true;
      aFile.Clear();
  finally
      aFile.Free();
  end;
end;

{--------------------------------------}
procedure TfrmExodus.About1Click(Sender: TObject);
begin
    // Show some about dialog box
    frmAbout := TfrmAbout.Create(Application);
    frmAbout.ShowModal();
    SaveBands();
end;

{---------------------------------------}
procedure TfrmExodus.presOnlineClick(Sender: TObject);
var
    stat, show: Widestring;
    cp: TJabberCustomPres;
    mi: TMenuItem;
    pri: integer;
begin
    // change our own presence
    mi := TMenuItem(sender);
    case mi.GroupIndex of
    0: show := '';
    1: show := 'away';
    2: show := 'xa';
    3: show := 'dnd';
    4: show := 'chat';
    end;
    stat := mi.Caption;
    pri := MainSession.Priority;
    if (mi.Tag >= 0) then begin
        cp := MainSession.Prefs.getPresIndex(mi.Tag);
        if (cp <> nil) then begin
            if (cp.Priority <> -1) then pri := cp.Priority;
            stat := cp.Status;
        end;
    end;
    MainSession.setPresence(show, stat, pri);
end;

{---------------------------------------}
procedure TfrmExodus.mnuMyVCardClick(Sender: TObject);
begin
    ShowMyProfile();
end;

procedure TfrmExodus.mnuOpenNewConferenceRoom1Click(Sender: TObject);
begin

end;

{---------------------------------------}
procedure TfrmExodus.mnuToolbarClick(Sender: TObject);
begin
    // toggle toolbar on/off
    pnlToolbar.Visible := not pnlToolbar.Visible;
    mnuWindows_View_ShowToolbar.Checked := pnlToolbar.Visible;
    MainSession.Prefs.setBool('toolbar', pnlToolbar.Visible);
end;

{---------------------------------------}
procedure TfrmExodus.NewGroup2Click(Sender: TObject);
//var
//    go: TJabberGroup;
//    x: TXMLTag;
begin
//    // Add a roster grp.
//    go := promptNewGroup();
//    if (go = nil) then exit;
//    if (go.Data <> nil) then exit;
//    
//    with frmRosterWindow do begin
//        RenderGroup(go);
//        treeRoster.AlphaSort(true);
//    end;
//    x := TXMLTag.Create('group');
//    x.setAttribute('name', go.FullName);
//
//    // XXX: is this event right for new groups?
//    MainSession.FireEvent('/roster/group', x, TExodusItem(nil));
//    x.Free();
//
end;

{---------------------------------------}
procedure TfrmExodus.MessageHistory2Click(Sender: TObject);
begin
    // show a history dialog
    //frmRosterWindow.popHistoryClick(Sender);
end;

{---------------------------------------}
procedure TfrmExodus.Properties2Click(Sender: TObject);
begin
    // Show a properties dialog
    //frmRosterWindow.popPropertiesClick(Sender);
end;

{---------------------------------------}
procedure TfrmExodus.mnuVCardClick(Sender: TObject);
var
    jid: WideString;
begin
    // lookup some arbitrary vcard..
    if InputQueryW(_(sLookupProfile), _(sEnterJID), jid) then
        ShowProfile(jid);
end;

{---------------------------------------}
procedure TfrmExodus.mnuSearchClick(Sender: TObject);
begin
    // Start a default search
    StartJoinRoomBrowse;
end;


{---------------------------------------}
procedure TfrmExodus.mnuChatClick(Sender: TObject);
//var
//    n: TTreeNode;
//    ritem: TJabberRosterItem;
//    jid: WideString;
//    tjid: TJabberID;
begin
    // Start a chat w/ a specific JID
//    jid := '';
//    if (frmRosterWindow.treeRoster.SelectionCount > 0) then begin
//        n := frmRosterWindow.treeRoster.Selected;
//        if (TObject(n.Data) is TJabberRosterItem) then begin
//            ritem := TJabberRosterItem(n.Data);
//            if ritem <> nil then
//            begin
//                jid := ritem.jid.getDisplayJID();
//            end;
//        end;
//    end;
//
//    if InputQueryW(_(sStartChat), _(sEnterJID), jid) then
//    begin
//        tjid := TJabberID.Create(jid, false);
//        jid := tjid.jid();
//        StartChat(jid, tjid.resource, true);
//        tjid.Free();
//    end;
end;

{---------------------------------------}
procedure TfrmExodus.mnuPeople_Group_AddNewRosterClick(Sender: TObject);
begin
    //frmRosterWindow.popAddGroup.Click();
end;

procedure TfrmExodus.mnuPeople_Contacts_BlockContactClick(Sender: TObject);
begin
    //frmRosterWindow.popBlock.Click();
end;

procedure TfrmExodus.mnuBookmarkClick(Sender: TObject);
begin
    // Add a new bookmark to our list..
 { TODO : Roster refactor }
    //ShowBookmark('');
end;

{---------------------------------------}
procedure TfrmExodus.presCustomClick(Sender: TObject);
begin
    // Custom presence
    ShowCustomPresence();
end;

{---------------------------------------}
procedure TfrmExodus.trayShowActivityWindowClick(Sender: TObject);
begin
    mnuWindows_View_ShowActivityWindowClick(Sender);
end;

{---------------------------------------}
procedure TfrmExodus.trayShowClick(Sender: TObject);
begin
    // Show the application from the popup Menu
    doRestore();
end;

{---------------------------------------}
procedure TfrmExodus.trayExitClick(Sender: TObject);
begin
    // Close the application
    Self.Close;
end;

{---------------------------------------}
procedure TfrmExodus.FormActivate(Sender: TObject);
begin
    StopFlash(Self);
//    StopTrayAlert();
end;



{---------------------------------------}
procedure TfrmExodus.WinJabWebsite1Click(Sender: TObject);
begin
    // goto exodus.jabberstudio.org
    ShellExecute(Application.Handle, 'open', 'http://exodus.jabberstudio.org', '', '', SW_SHOW);
end;

{---------------------------------------}
procedure TfrmExodus.JabberBugzilla1Click(Sender: TObject);
begin
    // submit a bug on JS.org
    ShellExecute(Application.Handle, 'open', 'http://www.jabberstudio.org/projects/exodus/bugs/', '', '', SW_SHOW);
end;

{---------------------------------------}
// JJF TODO: remove these calls, show server version/time somewhere else (about box?)
procedure TfrmExodus.mnuFile_MyProfiles_ModifyProfileClick(Sender: TObject);
begin
    GetLoginWindow().mnuModifyProfileClick(Sender);
end;

{---------------------------------------}
procedure TfrmExodus.mnuPasswordClick(Sender: TObject);
var
    iq: TJabberIQ;
    f : TfrmPassword;
begin
    {
    // change the password.. send the following XML to do this
    // This only works if we're authenticated
    <iq type='set' to='jabberhostname[e.g., jabber.org]'>
      <query xmlns='jabber:iq:register'>
        <username>username</username>
        <password>newpassword</password>
      </query>
    </iq>
    }

    f := TfrmPassword.Create(self);
    if (f.ShowModal() = mrCancel) then
        exit;

    iq := TJabberIQ.Create(MainSession, MainSession.generateID, Self.ChangePasswordCallback, 120);
    with iq do begin
        iqType := 'set';
        toJid := MainSession.Server;
        Namespace := XMLNS_REGISTER;
        qTag.AddBasicTag('username', MainSession.Username);
        qTag.AddBasicTag('password', f.txtNewPassword.Text);
        _pending_passwd := f.txtNewPassword.Text;
    end;
    f.Free();
    iq.Send();
end;

{---------------------------------------}
procedure TfrmExodus.ChangePasswordCallback(event: string; tag: TXMLTag);
begin
    if (event <> 'xml') then
        MessageDlgW(_(sPasswordError), mtError, [mbOK], 0)
    else begin
        if (tag.GetAttribute('type') = 'result') then begin
            MessageDlgW(_(sPasswordChanged), mtInformation, [mbOK], 0);
            MainSession.Profile.password := _pending_passwd;
            MainSession.Prefs.SaveProfiles();
        end
        else
            MessageDlgW(_(sPasswordError), mtError, [mbOK], 0);
    end;
end;

{---------------------------------------}
procedure TfrmExodus.AcceptFiles( var msg : TWMDropFiles );
const
  cnMaxFileNameLen = 255;
//var
//    i,
//    nCount     : integer;
//    acFileName : array [0..cnMaxFileNameLen] of char;
//    p, orig_p  : TPoint;
//    Node       : TTreeNode;
//    ri         : TJabberRosterItem;
//    f          : TForm;
//    j          : TJabberID;
//    pageIndex  : integer;
begin
   { TODO : Roster refactor }
//    // Accept some files being dropped on this form
//    // If we are expaned, and not showing the roster tab,
//    // and the current tab has a chat window, then
//    // call the chat window's AcceptFiles() method.
//{    if ((Jabber1.GetDockState() <> dsForbidden) and
//        (Tabs.ActivePage <> tbsRoster)) then begin
//        f := getTabForm(Tabs.ActivePage);
//        if (f is TfrmChat) then begin
//            TfrmChat(f).AcceptFiles(msg);
//        end;
//        exit;
//    end;
//}
//    // figure out which node was the drop site.
//    if (DragQueryPoint(msg.Drop, p) = false) then exit;
//    orig_p := p;
//    //First check if file is dragged to the chat window
//    //Convert dropping point to tab coordinates
//    p := tabs.ParentToClient(p, Self);
//    if (PtInRect(tabs.ClientRect, p)) then begin
//      //File is draged to the tab area (active or not active)
//      pageIndex := Tabs.IndexOfTabAt(p.X, p.Y);
//      if ((pageIndex >= 0) and (pageIndex <= Tabs.PageCount)) then begin
//        f := getTabForm(Tabs.Pages[pageIndex]);
//        if (f is TfrmChat) then begin
//           TfrmChat(f).AcceptFiles(msg);
//        end;
//        exit;
//      end;
//
//      //File has been dragged to active page
//      if (PtInRect(tabs.ActivePage.ClientRect, p)) then begin
//         f := getTabForm(Tabs.ActivePage);
//         if (f is TfrmChat) then begin
//            TfrmChat(f).AcceptFiles(msg);
//         end;
//         exit;
//      end;
//    end;
//
//    p := orig_p;
//    // Translate to screen coordinates, then back to client coordinates
//    // for the roster window.  This would have been easier if RosterWindow
//    // had worked as the target of DragAcceptFiles.
//    p := ClientToScreen(p);
//    p := frmRosterWindow.treeRoster.ScreenToClient(p);
//    Node := frmRosterWindow.treeRoster.GetNodeAt(p.X, p.Y);
//    if ((Node = nil) or (Node.Level = 0)) then exit;
//
//    // get the roster item attached to this node.
//    if (Node.Data = nil) then
//        exit
//    else if (TObject(Node.Data) is TJabberRosteritem) then begin
//        ri := TJabberRosterItem(Node.Data);
//        if (not ri.IsContact) then exit;
//        if (not ri.IsNative) then exit;
//
//        j := ri.jid;
//
//        // find out how many files we're accepting
//        nCount := DragQueryFile( msg.Drop,
//                                 $FFFFFFFF,
//                                 acFileName,
//                                 cnMaxFileNameLen );
//
//        // query Windows one at a time for the file name
//        for i := 0 to nCount-1 do begin
//            DragQueryFile( msg.Drop, i,
//                           acFileName, cnMaxFileNameLen );
//            FileSend(j.full, acFileName);
//        end;
//
//        // let Windows know that we're done
//        DragFinish( msg.Drop );
//    end;
end;


{---------------------------------------}
procedure TfrmExodus.FormDestroy(Sender: TObject);
var
   Value: PWideChar;
begin
    //TODO:  save dimensions?
    if (not _cleanupComplete) then
        cleanup();

    _hiddenIEMsgList.Free();
    _hiddenIEMsgList := nil;
    _dockWindow := nil; // Don't free here as form is "owned" by application
    if (_mnuRegisterUD <> nil) then
    begin
        if (_mnuRegisterUD.Tag <> 0) then
        begin
            Value :=  Pointer(_mnuRegisterUD.Tag);
            StrDisposeW(Value);
        end;
    end;

   tbsView.WindowProc := _PageControlSaveWinProc;
   _PageControlSaveWinProc := nil;

    Exsession.ExCOMToolbar := nil;
    Exsession.COMToolbar := nil;
end;

{---------------------------------------}
procedure TfrmExodus.mnuRegisterUDClick(Sender: TObject);
var
    EntityJID: PWideChar;
begin
    EntityJID := Pointer(_mnuRegisterUD.Tag);
    StartServiceReg(EntityJID);
end;


procedure TfrmExodus.mnuMessageClick(Sender: TObject);
//var
//    jid: WideString;
//    n: TTreeNode;
//    ritem: TJabberRosterItem;
//    tjid: TJabberID;
begin
   { TODO : Roster refactor }
//    // Message someone
//    jid := '';
//    if (frmRosterWindow.treeRoster.SelectionCount > 0) then begin
//        n := frmRosterWindow.treeRoster.Selected;
//        if (TObject(n.Data) is TJabberRosterItem) then begin
//            ritem := TJabberRosterItem(n.Data);
//            if ritem <> nil then
//            begin
//                jid := ritem.jid.getDisplayJID()
//            end;
//        end;
//    end;
//
//    if InputQueryW(_(sSendMessage), _(sEnterJID), jid) then
//    begin
//        tjid := TJabberID.Create(jid, false);
//        jid := tjid.jid();
//        tjid.Free();
//        StartMsg(jid);
//    end;
end;

procedure TfrmExodus.mnuWindows_MinimizetoSystemTrayClick(Sender: TObject);
begin
    Self.Hide();
    _hidden := true;
end;


procedure TfrmExodus.mnuWindows_View_ShowActivityWindowClick(Sender: TObject);
begin
    inherited;
    if (_dockwindow = nil) then exit;

    getDockManager().ShowDockManagerWindow(true, true);
end;

{---------------------------------------}
procedure TfrmExodus.Test1Click(Sender: TObject);
//var
    {
    i: IExodusController;
    btn: IExodusToolbarButton;
    }
    // btn: TToolButton;

    {
    h: integer;
    i: IExodusController;
    f, o, m, x: TXMLTag;
    }
    //i: integer;
    //z: TZipMaster;
    //go: TJabberGroup;
    //x: TXMLTag;
begin
    {
    i := ExCOMController as IExodusController;
    btn := i.Toolbar.addButton('contact');
    btn.Tooltip := 'Some tooltip';
    }

    {
    btn := TToolButton.Create(Self);
    btn.Parent := ToolBar1;
    btn.Left := ToolBar1.Buttons[ToolBar1.ButtonCount - 1].Left +
        ToolBar1.Buttons[ToolBar1.ButtonCount - 1].Width + 1;
    btn.ImageIndex := 10;
    }

    {
    go := MainSession.Roster.addGroup('aaaa');
    go.SortPriority := 900;
    go.KeepEmpty := true;
    go.ShowPresence := false;

    x := TXMLTag.Create('group');
    x.setAttribute('name', go.FullName);
    MainSession.FireEvent('/roster/group', x, TJabberRosterItem(nil));
    x.Free();

    go := MainSession.Roster.addGroup('bbbb');
    go.SortPriority := 900;
    go.KeepEmpty := true;
    go.ShowPresence := false;

    x := TXMLTag.Create('group');
    x.setAttribute('name', go.FullName);
    MainSession.FireEvent('/roster/group', x, TJabberRosterItem(nil));
    x.Free();
    }

    // ShowNewUserWizard();
    {
    z := TZipMaster.Create(nil);
    i := z.Load_Unz_Dll();
    ShowMessage(IntToStr(i));

    i := z.Load_Zip_Dll();
    ShowMessage(IntToStr(i));

    z.ZipFileName := 'd:\temp\jisp\emoticons\Ninja.jisp';
    i := z.Extract();
    ShowMessage(IntToStr(i));

    i := z.List();
    ShowMessage(IntToStr(i));
    }

    //
    //ShowMessage(BoolToStr(IsUnicodeEnabled()));
    {
    Application.CreateForm(TfrmTest1, frmTest1);
    frmTest1.ShowDefault();
    }
    {
    i := ExComController as IExodusController;
    h := i.CreateDockableWindow('foo');
    ShowMessage(IntToStr(h));
    }

    // Do some xdata tests
    {
    m := TXMLTag.Create('message');
    x := m.AddTag('x');
    x.setAttribute('xmlns', 'jabber:x:data');
    x.setAttribute('type', 'form');

    // just a simple edit field
    f := x.addTag('field');
    f.setAttribute('type',  'text');
    f.setAttribute('var',   'field1');
    f.setAttribute('label', 'field 1');
    f.AddBasicTag('value', 'Some basic text');

    // list-single
    f := x.addTag('field');
    f.setAttribute('type',  'list-single');
    f.setAttribute('var',   'single');
    f.setAttribute('label', 'A');
    f.AddBasicTag('value', '2');
    o := f.AddTag('option');
    o.setAttribute('label', 'Choice 1');
    o.AddBasicTag('value', '1');
    o := f.AddTag('option');
    o.setAttribute('label', 'Choice 2');
    o.AddBasicTag('value', '2');
    o := f.AddTag('option');
    o.setAttribute('label', 'Choice 3');
    o.AddBasicTag('value', '3');

    // list-multi
    f := x.addTag('field');
    f.setAttribute('type',  'list-multi');
    f.setAttribute('var',   'B');
    f.setAttribute('label', 'Some choices');
    f.AddBasicTag('value', '1');
    f.AddBasicTag('value', '2');
    o := f.AddTag('option');
    o.setAttribute('label', 'Choice 1');
    o.AddBasicTag('value', '1');
    o := f.AddTag('option');
    o.setAttribute('label', 'Choice 2');
    o.AddBasicTag('value', '2');
    o := f.AddTag('option');
    o.setAttribute('label', 'Choice 3');
    o.AddBasicTag('value', '3');
    o := f.AddTag('option');
    o.setAttribute('label', 'Choice 4');
    o.AddBasicTag('value', '4');
    o := f.AddTag('option');
    o.setAttribute('label', 'Choice 5');
    o.AddBasicTag('value', '5');

    // boolean
    f := x.addTag('field');
    f.setAttribute('type',  'boolean');
    f.setAttribute('var',   'C');
    f.setAttribute('label', 'Some really really really really really really really really long boolean');
    f.AddBasicTag('value', 'YES');

    // a bunch of fixed fields
    f := x.AddTag('field');
    f.setAttribute('type', 'fixed');
    f.AddBasicTag('value', '111 This is some longish fixed label. Blah, blah, blah, blah, blah, blah.');

    f := x.AddTag('field');
    f.setAttribute('type', 'fixed');
    f.addBasicTag('value', '222 A label with a url like http://www.yahoo.com voo blah.');

    f := x.AddTag('field');
    f.setAttribute('type', 'fixed');
    f.addBasicTag('value', '333 A label with a url like http://www.yahoo.com blahlkjad;lasdlkasdlkasd;lksa;dlkasd;lkas;as;asa;ldakdalkda;ldka;kdasdla;kk.');

    f := x.AddTag('field');
    f.setAttribute('type', 'fixed');
    f.addBasicTag('value', '444 0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789.');

    f := x.AddTag('field');
    f.setAttribute('var', 'jidA');
    f.setAttribute('label', 'Select a Jid');
    f.setAttribute('type', 'jid-single');
    f.AddBasicTag('value', 'foo@bar.com');

    f := x.AddTag('field');
    f.setAttribute('var', 'jidB');
    f.setAttribute('label', 'Select several jids');
    f.setAttribute('type', 'jid-multi');
    f.AddBasicTag('value', 'a@bar.com');
    f.AddBasicTag('value', 'b@baz.com');
    f.AddBasicTag('value', 'c@thud.com');

    f := x.AddTag('field');
    f.setAttribute('type', 'fixed');
    f.addBasicTag('value', '555 foo bar 0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789.');

    f := x.AddTag('field');
    f.setAttribute('type', 'fixed');
    f.addBasicTag('value', '666 foo bar'#13#10' sdkfjls'#13#10'kjdflksjdf;ljsf;'#13#10'klsjf;lkjsafkjsaldfj;lasjfd;klsajd;kljasdjf;ajdf;ljsfd;kjasdf;jas;fkja;df;ljaslfkj;asdf;klasdfklasdfj;ajdf;ljsf;ksafd;kjadsf;jkasdjfs;lf;lsdf');

    ShowXData(m);
    }
    
end;

{---------------------------------------}
procedure TfrmExodus.BadCallback(event: string; tag: TXMLTag);
begin
    // Cause an AV for testing
    PInteger(nil)^ := 0;
end;

{---------------------------------------}
procedure TfrmExodus.DefaultHandler(var msg);
var
    m : TMessage;
    status: string;
    show: string;
begin
    // Is this a replacement defualt windows msg handler??
    m := TMessage(msg);
    if (m.Msg = sExodusPresence) then begin
        if (HWND(m.WParam) = Self.Handle) then exit;
        if (not MainSession.Prefs.getBool('presence_message_listen')) then
            exit;
        show := GetPresenceString(m.LParamHi);
        status := GetPresenceString(m.LParamLo);
        // already there.
        if ((MainSession.Show = show) and (MainSession.Status = status)) then exit;
        _is_broadcast := true;
        MainSession.setPresence(show, status, MainSession.Priority);
        _is_broadcast := false;
    end
    else if (m.Msg = sExodusMutex) then begin
        // show the form
        Self.Show;
        doRestore();
        SetForegroundWindow(Self.Handle);
    end
    else if (m.Msg = sShellRestart) then begin
        // the shell was restarted...
        // reshow our tray icons
        setupTrayIcon();
        setTrayInfo(_tray_tip);
        setTrayIcon(_tray_icon_idx);
    end
    else
        inherited;
end;

procedure TfrmExodus.mnuPeople_Group_DeleteGroupClick(Sender: TObject);
begin
    //frmRosterWindow.popGrpRemove.Click();
end;

procedure TfrmExodus.mnuFile_MyProfiles_DeleteProfileClick(Sender: TObject);
begin
    GetLoginWindow().mnuDeleteProfileClick(Sender);
end;


{---------------------------------------}
procedure TfrmExodus.mnuBrowserClick(Sender: TObject);
begin
    // Show a jabber browser.
    Browser.ShowBrowser();
end;

{---------------------------------------}
procedure TfrmExodus.timReconnectTimer(Sender: TObject);
begin
    // It is possible for the timer to be running when
    // exit is called. This can cause a crash when started
    // as a COM object (not standard EXE).
    if (not _shutdown) then begin
        // It is possible to have the reconnect timer running
        // when the old sesion has not been de-activated.  This
        // could happen when the connection was lost but a chat window
        // has a dialog box open (specifically an "active chat" is asking
        // permission to shutdown).  If we try to reconnect in this state,
        // we get an assert.
        if (not MainSession.Active) then begin
            // try to reconnect...
            inc(_reconnect_cur);
            if (_reconnect_cur >= _reconnect_interval) then begin
                timReconnect.Enabled := false;
                DoConnect();
            end
            else begin
                getLoginWindow().UpdateReconnect(_reconnect_interval - _reconnect_cur);
            end;
        end;
    end;
end;

{---------------------------------------}
procedure TfrmExodus.presToggleClick(Sender: TObject);
begin
    if (MainSession.Show = '') then
        MainSession.setPresence('away', _('Away'), MainSession.Priority)
    else
        MainSession.setPresence('', _('Available'), MainSession.Priority)
end;

{---------------------------------------}
procedure TfrmExodus.AppEventsActivate(Sender: TObject);
begin
    StopTrayAlert();
end;

{---------------------------------------}
procedure TfrmExodus.PreModal(frm: TForm);
begin
    // make not on top.
    if (MainSession.Prefs.getBool('window_ontop')) then begin
        SetWindowPos(frmExodus.Handle, HWND_NOTOPMOST, 0, 0, 0, 0, SWP_NOSIZE + SWP_NOMOVE);
        BringWindowToTop(frm.Handle);
    end;
end;

{---------------------------------------}

procedure TfrmExodus.PostModal();
begin
    // make on top if applicable.
    if (MainSession.Prefs.getBool('window_ontop')) then
        SetWindowPos(frmExodus.Handle, HWND_TOPMOST, 0, 0, 0, 0, SWP_NOSIZE + SWP_NOMOVE);
end;

{---------------------------------------}
procedure TfrmExodus.AppEventsDeactivate(Sender: TObject);
begin
    // app was deactivated..
    if (Self.ActiveChat <> nil) then begin
        Self.ActiveChat.HideEmoticons();
        Self.ActiveChat := nil;
    end;
end;

{---------------------------------------}
procedure TfrmExodus.timTrayAlertTimer(Sender: TObject);
var
    iconNum : integer;
begin
     _tray_notify := not _tray_notify;
     if (_tray_notify) then begin
        iconNum := 0;//_tray_icon_idx + RosterImages.RI_OFFLINEATTN_INDEX;
        if (iconNum > RosterImages.RI_XAATTN_INDEX) then
            iconNum := RosterImages.RI_XAATTN_INDEX;
    end
     else
         iconNum := _tray_icon_idx;

    ImageList1.GetIcon(iconNum, _tray_icon);
    _tray.hIcon := _tray_icon.Handle;
    Shell_NotifyIcon(NIM_MODIFY, @_tray);
end;

{---------------------------------------}
procedure StartTrayAlert();
begin
     frmExodus.timTrayAlert.Enabled := true;
end;

{---------------------------------------}
procedure StopTrayAlert();
begin
    //events might get this called pretty early
    if (frmExodus = nil) or (frmExodus.timTrayAlert = nil) then exit;

    if (frmExodus.timTrayAlert.Enabled) then begin
        frmExodus.timTrayAlert.Enabled := false;
        frmExodus._tray_notify := false;
        frmExodus.setTrayIcon(frmExodus._tray_icon_idx);
    end;
end;

{---------------------------------------}
procedure TfrmExodus.JabberUserGuide1Click(Sender: TObject);
begin
    ShellExecute(Application.Handle, 'open', pchar(string(MainSession.Prefs.getString('brand_help_userguide'))), '', '', SW_SHOW);
end;

{---------------------------------------}
procedure TfrmExodus.mnuPluginDummyClick(Sender: TObject);
begin
    // call the COM Controller
    ExCOMController.fireMenuClick(Sender);
end;

{---------------------------------------}
function TfrmExodus.win32TrackerIndex(windows_msg: integer): integer;
var
    i: integer;
begin
    Result := -1;
    for i := 0 to _win32_idx - 1 do begin
        if (_win32_tracker[i] = windows_msg) then begin
            Result := i;
            break;
        end;
    end;
end;

procedure TfrmExodus.TrackWindowsMsg(windows_msg: integer);
var
    idx: integer;
begin
    if (sExodusCWPHook = 0) then begin
        sExodusCWPHook := SetWindowsHookEx(WH_CALLWNDPROC, @ExodusCWPHook,
            0, GetCurrentThreadID);
        sExodusGMHook := SetWindowsHookEx(WH_GETMESSAGE, @ExodusGMHook,
            0, GetCurrentThreadID);
    end;

    idx := win32TrackerIndex(windows_msg);
    if (idx = -1) then begin
        _win32_tracker[_win32_idx] := windows_msg;
        inc(_win32_idx);
        if (_win32_idx >= Length(_win32_tracker)) then begin
            SetLength(_win32_tracker, _win32_idx + 20);
        end;
    end;

    AppEvents.Activate();
end;

{---------------------------------------}
procedure TfrmExodus.fireWndMessage(handle: HWND; msg: Cardinal;
    wParam: integer; lParam: integer);
var
    etag: TXMLTag;
begin
    // check to see if this Msg is one we are tracking..
    // and fire the appropriate event if it is.
    etag := TXMLTag.Create('event');
    etag.setAttribute('msg', IntToStr(msg));
    etag.setAttribute('hwnd', IntToStr(Handle));
    etag.setAttribute('lparam', IntToStr(lParam));
    etag.setAttribute('wparam', IntToStr(wParam));
    MainSession.FireEvent('/windows/msg', etag);
end;

{---------------------------------------}
procedure TfrmExodus.ShowBrandURL(Sender: TObject);
var
    i : integer;
    url_list: TWideStringList;
    shellresult: cardinal;
begin
    i := Help1.IndexOf(TMenuItem(Sender));
    if (i < 0) then exit;

    url_list := TWideStringList.Create();
    MainSession.Prefs.fillStringlist('brand_help_url_list', url_list);

    if (i < url_list.Count) then begin
        try
            shellresult := ShellExecute(Application.Handle, 'open',
                         pchar(string(url_list.Strings[i])),
                         '', '', SW_SHOW);
            if (shellresult <= 32) then begin
                // > 32 is success (see Window API documentation)
                // We are here so must be some form of error.
                // If url is a relative path, this might fail, so try
                // to use url with exe home directory.
                if (FileExists(ExtractFilePath(Application.ExeName) +
                    url_list.Strings[i])) then begin
                    ShellExecute(Application.Handle, 'open',
                                 pchar(string(ExtractFilePath(Application.ExeName) +
                                        url_list.Strings[i])), '', '', SW_SHOW);
                end;
            end;
        except
        end;
    end
    else
        MessageDlgW(_(sBrandingError), mtWarning, [mbOK], 0);

    url_list.Free();
end;

procedure TfrmExodus.mnuChatToolbarClick(Sender: TObject);
var
    tempbool: boolean;
begin
    // toggle toolbar on/off
    tempbool := MainSession.Prefs.getBool('chat_toolbar');
    tempbool := not tempbool;
    mnuWindows_View_ShowChatToolbar.Checked := tempbool;
    MainSession.Prefs.setBool('chat_toolbar', tempbool);
    MainSession.FireEvent('/session/prefs', nil);
end;

procedure TfrmExodus.mnuWindows_CloseAllClick(Sender: TObject);
begin
    GetActivityWindow().enableListUpdates(false);
    MainSession.FireEvent('/session/close-all-windows', nil);
    StopFlash(_dockwindow); //from notify.pas
    GetActivityWindow().enableListUpdates(true);
end;

{---------------------------------------}
function ExodusGMHook(code: integer; wParam: word; lParam: longword): longword; stdcall;
var
    idx: integer;
    msg: TMsg;
begin
    // Something is coming from our WH_GETMESSAGE Hook
    msg := TMsg(Ptr(lParam)^);

    if (frmExodus <> nil) then begin
        idx := frmExodus.win32TrackerIndex(msg.message);
        if (idx >= 0) then
            frmExodus.fireWndMessage(msg.hwnd, msg.message, msg.wParam, msg.lParam);
    end;

    Result := CallNextHookEx(sExodusGMHook, Code, wParam, lParam);
end;

{---------------------------------------}
function ExodusCWPHook(code: integer; wParam: word; lParam: longword): longword; stdcall;
var
    idx: integer;
    cwp: TCWPStruct;
begin
    // Something is coming from CALLWNDPROC Hook
    if ((Code = HC_ACTION) and (frmExodus <> nil)) then begin
        cwp := TCWPStruct(Ptr(lParam)^);
        idx := frmExodus.win32TrackerIndex(cwp.message);
        if (idx >= 0) then
            frmExodus.fireWndMessage(cwp.hwnd, cwp.message, cwp.wParam, cwp.lParam);
    end;

    Result := CallNextHookEx(sExodusCWPHook, Code, wParam, lParam);
end;

{---------------------------------------}
procedure TfrmExodus.FormPaint(Sender: TObject);
begin
end;

{---------------------------------------}
function TfrmExodus.isMinimized(): boolean;
begin
    Result := (_hidden) or (Self.Windowstate = wsMinimized);
end;

{---------------------------------------}
procedure TfrmExodus.mnuRegistrationClick(Sender: TObject);
begin
    // register with the server..
    StartServiceReg(MainSession.Server);
end;

{---------------------------------------}
procedure TfrmExodus.XMPPActionExecuteMacro(Sender: TObject;
  Msg: TStrings);
var
    c_node: TXMLTag;
    c_jid: TJabberID;
    m: string;
begin
    // Explorer is giving is something about a XMPP file..
    if (Msg.Count = 0) then exit;
    m := Lowercase(Msg[0]);
    if (m = 'ignore') then exit;
    if (Pos('open', m) = 1) then begin
        Delete(m, 1, 6);
        Delete(m, Length(m), 1);
        c_node := nil;
        c_jid := nil;
        ParseXMPPFile(m, c_node, c_jid);
        if (MainSession.Active) then
            // ignore c_node, c_jid
            PlayXMPPActions()
        else begin
            // TODO: Handle xmpp connect's via DDE
        end;
    end
    else if (Pos('uri', m) = 1) then begin
        m := Msg[0];
        Delete(m, 1, 5);
        if LeftStr(m, 1) = '''' then begin
            Delete(m, 1, 1);
        end;

        if RightStr(m, 1) = '''' then begin
            Delete(m, Length(m), 1);
        end;

        ParseURI(m, c_node, c_jid);
        if (MainSession.Active) then
            PlayXMPPActions()
        else begin
            // TODO: Handle xmpp connect's via DDE
        end;
    end;
end;

{---------------------------------------}
procedure TfrmExodus.mnuFindClick(Sender: TObject);
begin
    //frmRosterWindow.StartFind();
end;

procedure TfrmExodus.mnuOptions_FontClick(Sender: TObject);
begin
    Prefs.StartPrefs(pref_display);
end;

procedure TfrmExodus.mnuPeople_ConferenceClick(Sender: TObject);
begin
  //invite to room should only be available if rooms are open.
end;

procedure TfrmExodus.mnuPeople_Conference_InviteContacttoConferenceClick(Sender: TObject);
var
    items: IExodusItemList;
    jids: TWidestringList;
    idx: Integer;
    tabCtrl: IExodusTabController;
begin
    //TODO:  do it with the items...
    tabCtrl := GetRosterWindow().TabController;
    jids := TWidestringList.Create();
    if (tabCtrl.ActiveTab <> -1) then begin
         items := tabCtrl.Tab[tabCtrl.ActiveTab].GetSelectedItems();
         for idx := 0 to items.Count - 1 do begin
             if (items.Item[idx].Type_ <> 'contact') then continue;
             jids.Add(items.Item[idx].UID);
         end;
    end;

    ShowInvite('', jids);
end;


{---------------------------------------}
procedure TfrmExodus.mnuFindAgainClick(Sender: TObject);
begin
    //frmRosterWindow.FindAgain();
end;

{---------------------------------------}
procedure TfrmExodus.presDNDClick(Sender: TObject);
var
    m: TTntMenuItem;
    show: Widestring;
begin
    m := TTntMenuItem(Sender);
    if (m.Count > 0) then exit;

    case m.Tag of
    0: show := '';
    1: show := 'chat';
    2: show := 'away';
    3: show := 'xa';
    4: show := 'dnd';
    end;
    MainSession.setPresence(show, '', MainSession.Priority);

end;

{---------------------------------------}
procedure TfrmExodus.CMMouseEnter(var msg: TMessage);
begin
    //
end;

{---------------------------------------}
procedure TfrmExodus.CMMouseLeave(var msg: TMessage);
begin
    //
end;

{---------------------------------------}
procedure TfrmExodus.mnuPeople_Contacts_RenameContactClick(Sender: TObject);
begin
    //frmRosterWindow.popRenameClick(Sender);
end;

procedure TfrmExodus.mnuPeople_Group_RenameGroupClick(Sender: TObject);
begin
    //frmRosterWindow.popGrpRename.Click();
end;

procedure TfrmExodus.mnuFile_MyProfiles_RenameProfileClick(Sender: TObject);
begin
    GetLoginWindow().mnuRenameProfileClick(Sender);
end;

procedure TfrmExodus.mnuFileRegistrationClick(Sender: TObject);
begin
  inherited;
  //Check if there is entity with UserDirectory services
  _chkUserDirectory();
end;


{---------------------------------------}
procedure TfrmExodus._chkUserDirectory();
var
    tmps: WideString;
    Value: PWideChar;
    Services: TWideStringList;
    Idx, i: Integer;
    Entity: TJabberEntity;
begin
    //Resiter User Directory menu item already exists, don't need to do anything.
    if (_mnuRegisterUD <> nil) then exit;
    //Check if enttity with given features exists.
    Entity := nil;
    //Need to get tmps from pref file.

    //tmps := 'users.wrk171.corp.jabber.com';
    tmps := MainSession.Prefs.getString('brand_user_directory') + WideChar('.') + MainSession.Server;
    Services := TWideStringList.Create();
    jEntityCache.getByFeature(XMLNS_REGISTER, Services);
    Idx :=  Services.IndexOf(tmps);
    if (Idx <> -1) then
       //Found entity
       Entity := jEntityCache.getByJid(Services[Idx])
    else
    begin
        //Look for brandable string in the list
        for i := 0 to Services.Count - 1 do
        begin
            Entity := jEntityCache.getByJid(Services[i]);
            if (Entity = nil) then continue;
            if (Entity.Name = USER_DIRECTORY_NAME) then
                break
            else
                Entity := nil;
        end;
    end;
    //If entity is not nill, craete a menu item.
    if (Entity <> nil) then
    begin
        _mnuRegisterUD := TTntMenuItem.Create(Self);
        _mnuRegisterUD.Caption := Entity.Name;
        _mnuRegisterUD.OnClick := mnuRegisterUDClick;
        Value := StrNewW(PWideChar(Entity.Jid.Jid));
        _mnuRegisterUD.Tag := Integer(Value);
        mnuFile_Registration.Add(_mnuRegisterUD);
    end;
end;

procedure TfrmExodus.ResolverStatus(ASender: TObject;
  const AStatus: TIdStatus; const AStatusText: String);
begin
    // DNS status
    DebugMsg('DNS Lookup status: ' + AStatusText);
end;

{---------------------------------------}
procedure TfrmExodus.mnuPluginOptsClick(Sender: TObject);
begin
    // Show the prefs/plugins page.
    ManagePluginsDlg.showManagePluginDlg(Self);
end;

{---------------------------------------}
procedure TfrmExodus.mnuDisconnectClick(Sender: TObject);
begin
    DoDisconnect();
end;

procedure TfrmExodus.DoDisconnect();
begin
    if (Showing) then begin
        btnDisconnect.Enabled := false;
        mnuFile_Disconnect.Enabled := false;
    end;

    if MainSession.Active then begin
        _logoff := true;
        TAutoOpenEventManager.onAutoOpenEvent('disconnected');
        //dock manager should close with last window closing
//        if (not isDebugShowing()) then begin
//            getDockManager().ShowDockManagerWindow(false, false);
//        end;
        MainSession.Disconnect();
    end;

    ShowLogin();
end;

procedure TfrmExodus.mnuOptions_EnableStartupWithWindowsClick(Sender: TObject);
begin
end;

{******************************************************************************
 ***************************** Auto Away **************************************
 *****************************************************************************}

{---------------------------------------}
procedure TfrmExodus.setupAutoAwayTimer();
var
    lii: TLastInputInfo;
begin
    // Setup the auto-away timer
    // Note that for W2k and XP, we are just going to
    // use the special API calls for getting inactivity.
    // For other OS's we need to use the wicked nasty DLL
    _valid_aa := false;
    DebugMsg(_(sSetupAutoAway));
    if ((_windows_ver < cWIN_2000) or (_windows_ver = cWIN_ME)) then begin
        // Use the DLL
        @_GetLastTick := nil;
        @_InitHooks := nil;
        @_StopHooks := nil;

        _idle_hooks := LoadLibrary('IdleHooks.dll');
        if (_idle_hooks <> 0) then begin
            // start the hooks
            @_GetLastTick := GetProcAddress(_idle_hooks, 'GetLastTick');
            @_InitHooks := GetProcAddress(_idle_hooks, 'InitHooks');
            @_StopHooks := GetProcAddress(_idle_hooks, 'StopHooks');
            _InitHooks();
            _valid_aa := true;
        end
        else
            DebugMsg(_(sAutoAwayFail));
    end
    else begin
        // Use the GetLastInputInfo API call
        // Use GetProcAddress so we can still run on Win95/98/ME/NT which
        // don't have this function. If we just make the call, we end up
        // depending on that API call.
        @_GetLastInput := nil;
        @_GetLastInput := GetProcAddress(GetModuleHandle('user32'), 'GetLastInputInfo');
        if (@_GetLastInput <> nil) then begin
            lii.cbSize := sizeof(tagLASTINPUTINFO);
            if (_GetLastInput(lii)) then begin
                DebugMsg(_(sAutoAwayWin32));
                _valid_aa := true;
            end;
        end;
        if (not _valid_aa) then
            DebugMsg(_(sAutoAwayFailWin32));
    end;
end;

 {---------------------------------------}
function TfrmExodus.IsAutoAway(): boolean;
begin
    Result := _is_autoaway;
end;

{---------------------------------------}
function TfrmExodus.IsAutoXA(): boolean;
begin
    Result := _is_autoxa;
end;

 {---------------------------------------}
function TfrmExodus.getLastTick(): dword;
var
    lii: TLastInputInfo;
begin
    // Return the last tick count of activity
    Result := 0;
    //if not (2k or xp)
    if ((_windows_ver < cWIN_2000) or (_windows_ver = cWIN_ME)) then begin
        //use idl dll
        if ((_idle_hooks <> 0) and (@_GetLastTick <> nil)) then
            Result := _GetLastTick();
    end
    else begin
        // use GetLastInputInfo
        lii.cbSize := sizeof(tagLASTINPUTINFO);
        if (_GetLastInput(lii)) then
            Result := lii.dwTime;
    end;
end;

function TfrmExodus.screenStatus(): integer;
var
    desk: HDESK;
    name: string;
    len: dword;
    hw: HWINSTA;
    w,d: HWND;
    wSize: TRect;
    mon: TMonitor;
    bounds: TRect;
    winfo: TWindowInfo;
    ScreenSaverRunning: LongBool;
begin
    if ((_windows_ver < cWIN_NT) or (_windows_ver = cWIN_ME)) then begin
        result := DT_UNKNOWN;
        exit;
    end;

    desk := OpenInputDesktop(0, False, MAXIMUM_ALLOWED);
    if desk = 0 then begin
        result := DT_LOCKED;
        exit;
    end;

    GetUserObjectInformation(desk, UOI_NAME, PChar(name), 0, len);
    SetLength(name, len + 1);
    if not GetUserObjectInformation(desk, UOI_NAME, PChar(name), len, len) then begin
        CloseDesktop(desk);
        result := DT_UNKNOWN;
        exit;
    end;
    CloseDesktop(desk);
    // there's a null on the end.  Not sure why this worked before the -1.
    SetLength(name, len-1);

    if ((MainSession.Prefs.getBool('auto_away')) and
        (MainSession.Prefs.getBool('away_screen_saver'))) then
    begin
        ScreenSaverRunning := false;
        if (name = 'Screen-saver') then begin
            // This only seems to be the case when the desktop is locked
            ScreenSaverRunning := true;
        end
        else begin
            // Alternate check for when screen saver is running but desktop is not locked
            SystemParametersInfo(SPI_GETSCREENSAVERRUNNING, 0, @ScreenSaverRunning, 0);
        end;

        if (ScreenSaverRunning) then
        begin
            result := DT_SCREENSAVER;
            exit;
        end;
    end;

    if name = 'Default' then begin  // NO I18N!
        // what about fullscreen mode, like PowerPoint shows?
        w := GetForegroundWindow();
        d := FindWindow('Progman', nil);
        if (w <> d) then begin
            // Got a window and it is NOT the program manager (desktop).
            winfo.cbSize := SizeOf(TWindowInfo);
            Windows.GetWindowInfo(w, winfo);
            wSize := winfo.rcWindow;
            //Adjust wSize by window border
            wSize.Top := wSize.Top + winfo.cyWindowBorders;
            wSize.Bottom := wSize.Bottom - winfo.cyWindowBorders;
            wSize.Left := wSize.Left + winfo.cxWindowBorders;
            wSize.Right := wSize.Right - winfo.cxWindowBorders;

            mon := Screen.MonitorFromWindow(w, mdNearest);
            //If window gets destroyed in between calls, returned
            //monitor could be nil which is causing crash, added check for this.
            if (mon = nil) then  begin
              result := DT_UNKNOWN;
              exit;
            end;

            bounds := mon.WorkareaRect;
            if((bounds.Left = wSize.Left) and
               (bounds.Right = wSize.Right) and
               (bounds.Top = wSize.Top) and
               (bounds.Bottom = wSize.Bottom) and
               (MainSession.Prefs.getBool('auto_away')) and
               (MainSession.Prefs.getBool('away_full_screen'))) then begin
               //result := DT_FULLSCREEN;
               result := DT_UNKNOWN;
               exit;
            end;
        end;
        result := DT_OPEN;
        exit;
    end;

    if name = 'Winlogon' then begin
        hw := OpenWindowStation('winsta0', False, WINSTA_ENUMERATE or WINSTA_ENUMDESKTOPS);
        GetUserObjectInformation(hw, UOI_USER_SID, Nil, 0, len);
        CloseWindowStation(hw);

        // if no user is assosiated with winsta0, then no user is
        // is logged on:
        if len = 0 then
            // no one is logged on:
            result := DT_NO_LOG
        else
            // the station is locked
            result := DT_LOCKED;
        exit;
    end;
    result := DT_UNKNOWN;
end;
{---------------------------------------}
{**
 * Autoaway timer OnTimer event.

    Auto-away mad-ness......

    Get the current idle time, and based on that, "do the right thing".

    Note that we don't want to set a-away if we're already
    away, XA, or DND.

    getLasTick() uses either the idleHooks.dll or the appropriate
    API call if they are available (w2k and xp) to get the last
    tick count which had activity.

 * Will fire once every 10 seconds when the user is authenticated and available
 * Fires once every seconds when user is authenticated and not available.
**}
procedure TfrmExodus.timAutoAwayTimer(Sender: TObject);
var
    away, xa, dis: dword; //prefs defining elapsed minute triggers
//    dmsg: string;
    do_xa, do_dis: boolean;
    avail: boolean;
    _last_tick, cur_idle, mins: dword;      // last user input
    _auto_away: boolean;                // perform auto-away ops
    ss : integer;
begin
    //if we are not connected bail
    if (MainSession = nil) then exit;
    if (not MainSession.Active) then exit;

    with MainSession.Prefs do begin
        _auto_away := getBool('auto_away');
        //get autoway prefs
        away := getInt('away_time');
        xa := getInt('xa_time');
        dis := getInt('disconnect_time');
        do_xa := getBool('auto_xa');
        do_dis := getBool('auto_disconnect');
    end;
    //_autoAway is set when prefs are updatecd
    //if auto_away is enabled
    if ((_auto_away)) then begin
        ss := screenStatus();
        //if screen is locked, screensaver or full screen app the autoaway
        if ss > DT_OPEN then begin
            //if not already autoaway, make it so
            if not _is_autoaway then begin
                SetAutoAway();
            end;
            exit;
        end;
        //otherwise check to see if auto away should be triggered
        _last_tick := getLastTick();
        if (_last_tick = 0) then begin
            exit; //might return 0 if library setup failed
        end;
        //get number of seconds since last activity
        cur_idle := Windows.GetTickCount();
        cur_idle := (cur_idle - _last_tick);
        cur_idle := cur_idle div 1000;
        //if we are testing auto-away (via the -a command line) then
        //make mins = to seconds (to speed things up), otherwise determine
        //number of minutes since last input
        //if testing autoaway via the -a command line param, dump debug stmts
        if (ExStartup.testaa) then begin
            mins := cur_idle;
//            if (not _is_autoaway) and (not _is_autoxa) then begin
//                dmsg := 'Idle Check: ' + SafeBoolStr(_is_autoaway) + ', ' +
//                    SafeBoolStr(_is_autoxa) + ', ' +
//                    IntToStr(cur_idle ) + ' secs'#13#10;
//                DebugMsg(dmsg);
//            end;
        end
        else begin
            mins := cur_idle div 60
        end;
        //are we in an availabel show state?
        avail := (MainSession.Show <> 'dnd') and (MainSession.Show <> 'xa') and
            (MainSession.Show <> 'away');
        //if we had activity within the last minute and are currently
        //auto'd away, send available
        if ((mins = 0) and ((_is_autoaway) or (_is_autoxa))) then begin
            // we are available again
            SetAutoAvailable()
        //if we have auto-disconnect enabled and last input > disconnect time
        //and we are auto-extended away (hmm, thats seems wrong, you can have
        //auto-disconnect without auto-extended away, but must have auto-away
        end
        else if ((do_dis) and (mins >= dis) and (_is_autoxa)) then begin
            // Disconnect us
            _logoff := true;
            PostMessage(Self.Handle, WM_DISCONNECT, 0, 0);
        end
        // if auto-xa'd just exit, only state we could move to is
        //available or disconnect handled above
        else if (_is_autoxa) then begin
            exit
        end
        //if auto-away and auto-xa is enabled and idle time > xa time, go XA
        else if ((do_xa) and (mins >= xa) and (_is_autoaway)) then begin
            SetAutoXA()
        end
        //if available and auto-away enabled and idle time > away time, go away
        else if ((mins >= away) and (not _is_autoaway) and (avail)) then begin
            // We are avail, need to be away
            SetAutoAway();
        end;
    end;
end;

{---------------------------------------}
procedure TfrmExodus.SetAutoAway;
var
    new_pri: integer;
begin
    // set us to away
    DebugMsg(_(sSetAutoAway));
    Application.ProcessMessages;
{** JJF msgqueue refactor
    if (MainSession.Prefs.getBool('branding_queue_not_available_msgs') = false) then begin
      MainSession.Pause();
    end;
**}
    if ((MainSession.Show = 'away') or
        (MainSession.Show = 'xa') or
        (MainSession.Show = 'dnd')) then begin
        exit;
    end;

    _last_show := MainSession.Show;
    _last_status := MainSession.Status;
    _last_priority := MainSession.Priority;
    // must be before SetPresence
    _is_autoaway := true;

    // If we aren't doing auto-xa, then just set the flag now.
    if (not MainSession.Prefs.getBool('auto_xa')) then
        _is_autoxa := true
    else
        _is_autoxa := false;

    if MainSession.Prefs.getBool('aa_reduce_pri') then
        new_pri := 0
    else
        new_pri := _last_priority;

    MainSession.SetPresence('away', MainSession.prefs.getString('away_status'),
        new_pri);

    timAutoAway.Interval := 1000;
//    DebugMsg('SetAutoAway values:  _last_show: ' + _last_show + ' _last_status: ' + _last_status +
//             ' _last_priority: ' + IntToStr(_last_priority) + ' _is_autoaway: ' + BoolToStr(_is_autoaway) + ' _is_autoxa: ' +
//             BoolToStr(_is_autoxa) + ' new_pri: ' + IntToStr(new_pri));
end;

{---------------------------------------}
procedure TfrmExodus.SetAutoXA;
begin
    // set us to xa
    DebugMsg(_(sSetAutoXA));

    // must be before SetPresence
    _is_autoaway := false;
    _is_autoxa := true;

    MainSession.SetPresence('xa', MainSession.prefs.getString('xa_status'),
        MainSession.Priority);

    if (timAutoAway.Interval > 1000) then
        timAutoAway.Interval := 1000;

//    DebugMsg('SetAutoXA values:  _last_show: ' + _last_show + ' _last_status: ' + _last_status +
//             ' _last_priority: ' + IntToStr(_last_priority) + ' _is_autoaway: ' + BoolToStr(_is_autoaway) + ' _is_autoxa: ' +
//             BoolToStr(_is_autoxa));
end;

{---------------------------------------}
procedure TfrmExodus.SetAutoAvailable;
begin
    // reset our status to available
    DebugMsg(_(sSetAutoAvailable));
    timAutoAway.Enabled := false;
    timAutoAway.Interval := _auto_away_interval * 1000;
    MainSession.SetPresence(_last_show, _last_status, _last_priority);
    // must be *after* SetPresence
    _is_autoaway := false;
    _is_autoxa := false;

    if (_valid_aa) then begin
        timAutoAway.Enabled := true;
    end;
{** JJF msgqueue refactor
    if (MainSession.Prefs.getBool('branding_queue_not_available_msgs') = false) then begin
      MainSession.Play();
    end;
**}    
end;

{*******************************************************************************
**************************** Dock Management ***********************************
*******************************************************************************}

{***************************** helper methods**********************************}


{
    get the "allowed" docking state.

    Dock state may be adsAllowed -> forms may be docked or undocked
                      adsRequired -> dockable forms MUST dock, may not be undocked
                      adsForbidden -> dockable forms cannot dock, must be undocked
    Dock state is based on the "expanded" and "dock_locked" preference.

    (expanded && dock_locked --> dsRequired, expanded && !dock_locked --> dsAllowed,
     !expanded --> dsForbidden)
}
function getAllowedDockState() : TAllowedDockStates;
begin
    Result := adsAllowed;
    if (MainSession <> nil) then  begin
        if (not MainSession.Prefs.getBool('expanded')) then
            Result := adsForbidden
    end;
end;

{************************** component bound events ****************************}

{
    Event fired when programaticvally undocking

    Does not update the layout of the dock manager. This method is used
    when undocking tabs while updating the layout (see updateLayoutPrefChange)
}
procedure TfrmExodus.TabsUnDockNoLayoutChange(Sender: TObject; Client: TControl;
  NewTarget: TWinControl; var Allow: Boolean);
var
    frm: TfrmDockable;
    idx: Integer;
begin
outputdebugmsg('TfrmExodus.TabsUnDockNoLayoutChange');
    // check to see if the tab is a frmDockable
    Allow := true;
    if (Client is TfrmDockable) then begin
        frm := TfrmDockable(client);
        frm.Docked := false;
        frm.OnFloat();
        idx := _docked_forms.IndexOf(TfrmDockable(frm));
        if (idx >= 0) then
            _docked_forms.Delete(idx);
    end;
end;


{**************************** state change requests ***************************}
{************************************ layout **********************************}
{---------------------------------------}
{
    Use prefs to set the dock layout.

    This method is used to move from one dock mode to another. for example,
    Docking was not allowed but the user now chooses to allow docking.
}
procedure TfrmExodus.updateLayoutPrefChange();
begin
    if (frmRoster = nil) then exit; //nop, not initialized yet
    // make sure the roster is docked in the appropriate place.

    layoutRosterOnly();
    //undockAllForms();
    Self.DockSite := false;
end;


{
    Adjust layout so only roster panel is shown
}
procedure TfrmExodus.layoutRosterOnly();
begin
    //if tabs were being shown, save tab size
    _enforceConstraints := false;
    _noMoveCheck := true;
    if (WindowState <> wsMaximized) then begin
        Self.ClientWidth := Abs(MainSession.Prefs.getInt(PrefController.P_ROSTER_WIDTH));
        Self.ClientHeight := Abs(MainSession.Prefs.getInt(PrefController.P_ROSTER_HEIGHT));
    end;
    _noMoveCheck := false;
    Self.DockSite := false;

    if (MainSession.Active) then
        frmExodus.Constraints.MinWidth := MainSession.Prefs.getInt('brand_min_roster_window_width')
    else
        frmExodus.Constraints.MinWidth := MainSession.Prefs.getInt('brand_min_profiles_window_width');

    _enforceConstraints := true;
end;

procedure TfrmExodus.clickChangeStatus(Sender: TObject);
var
    cp : TPoint;
begin
    // popup the menu and to change our status
    if MainSession.Active then begin
        GetCursorPos(cp);
        popPresence.Popup(cp.x, cp.y);
    end;
end;
procedure TfrmExodus.clickEditStatus(Sender: TObject);
begin
    //prepare for display madness
    pnlStatus.Visible := false;
    lblStatus.Align := alNone;
    imgDown.Align := alNone;
    txtStatus.Align := alNone;

    //hide read-only stuff
    lblStatus.Visible := false;
    imgDown.Visible := false;

    //display read-write stuff
    txtStatus.Text := MainSession.Status;
    txtStatus.Visible := true;
    txtStatus.Align := alClient;
    pnlStatus.Align := alClient;

    pnlStatus.Visible := true;

    txtStatus.SetFocus;
end;
procedure TfrmExodus.txtStatusExit(Sender: TObject);
begin
    inherited;

    //prepare for display madness
    pnlStatus.Visible := false;
    lblStatus.Align := alNone;
    imgDown.Align := alNone;
    txtStatus.Align := alNone;

    txtStatus.Visible := false;

    imgDown.Align := alLeft;
    lblStatus.Align := alLeft;

    pnlStatus.Align := alClient;
    imgDown.Visible := true;
    lblStatus.Visible := true;
    pnlStatus.Visible := true;
end;

procedure TfrmExodus.txtStatusKeyPress(Sender: TObject; var Key: Char);
var
    pres: TJabberCustomPres;
    val: Widestring;
    status, show: Widestring;
    priority: Integer;
begin
    //something to do
    if Key = #13 then begin
        //TODO:  save and change status
        val := Trim(txtStatus.Text);
        if (val <> '') then begin
            //custom status
            pres := MainSession.prefs.getPresence(val);
            if pres = nil then begin
                //no existing presence...create it!
                pres := TJabberCustomPres.Create;
                pres.title := val;
                pres.Status := val;
                pres.Show := MainSession.Show;
                pres.Priority := MainSession.Priority;

                MainSession.Prefs.setPresence(pres);
                SessionCallback('/session/prefs', nil);
            end;

            status := pres.Status;
            show := pres.Show;
            priority := pres.Priority;
        end
        else begin
            //default status
            status := '';
            show := MainSession.Show;
            priority := MainSession.Priority;
        end;

        MainSession.setPresence(show, status, priority);
    end else if Key <> #27 then begin
        inherited;
        exit;
    end;

    txtStatusExit(Sender);
    Key := #0;
end;


procedure TfrmExodus.OnNotify(frm: TForm; notifyEvents: integer);
begin
    //handle bring to front and flash
    if (frm = Self) then begin
        if ((notifyEvents and notify_front) <> 0) then
            bringToFront()
        else if ((notifyEvents and notify_flash) <> 0) then
            Self.Flash();
    end;
end;

procedure TfrmExodus.imgAdClick(Sender: TObject);
var
    url: Widestring;
begin
    inherited;

    url := imgAd.Hint;

    if url <> '' then begin
        ShellExecute(Application.Handle, 'open', PChar(url), nil, nil, SW_SHOWNORMAL);
    end;
end;

function TfrmExodus.isActive(): boolean;
begin
    Result := Self.Active;
end;

procedure TfrmExodus.BringToFront();
begin
    Self.doRestore();
    ShowWindow(Self.Handle, SW_SHOWNORMAL);
    Self.Visible := true;
    ForceForegroundWindow(Self.Handle);
end;

procedure TfrmExodus.OptionsClick(Sender: TObject);
begin
    OptionsMenuItemsChecks();
end;

procedure TfrmExodus.OptionsMenuItemsChecks();
begin
end;


procedure TfrmExodus.PeopleClick(Sender: TObject);
var
    tabCtrl: IExodusTabController;
    tab: IExodusTab;
    actMap: IExodusActionMap;
    typedActs: IExodusTypedActions;
    items: IExodusItemList;

    procedure SetupMenuItem(mi: TTntMenuItem; name: Widestring);
    var
        act: IExodusAction;
        newAct: TActionHelper;
    begin
        if (typedActs = nil) then
            act := nil
        else
            act := typedActs.GetActionNamed(name);

        TActionHelper(Pointer(mi.Tag)).Free();
        mi.Enabled := (act <> nil);
        if (mi.Enabled) then begin
            newAct := TActionHelper.Create(typedActs, name);
            mi.OnClick := newAct.click;
            mi.Tag := Integer(Pointer(newAct));
        end
        else begin
            mi.OnClick := nil;
            mi.Tag := 0;
        end;
    end;
begin
  tabCtrl := GetRosterWindow().TabController;
  if (tabCtrl.ActiveTab = -1) then
    items := TExodusItemList.Create()
  else begin
    tab := tabCtrl.Tab[tabCtrl.ActiveTab];
    items := tab.GetSelectedItems();
  end;

  actMap := GetActionController().buildActions(items);

  //Enable/Disable contact menus...
  if (items.Count = 1) and (items.Item[0].Type_ = 'contact') then
    typedActs := actMap.GetActionsFor('')
  else
    typedActs := actMap.GetActionsFor('contact');
  SetupMenuItem(mnuPeople_Contacts_BlockContact, '{000-exodus.googlecode.com}-080-block-contact');
  SetupMenuItem(mnuPeople_Contacts_ViewHistory, '{000-exodus.googlecode.com}-040-view-history');
  SetupMenuItem(mnuPeople_Contacts_ContactProperties, '{000-exodus.googlecode.com}-100-properties');
  SetupMenuItem(mnuPeople_Contacts_RenameContact, '{000-exodus.googlecode.com}-150-rename');
  SetupMenuItem(mnuPeople_Contacts_DeleteContact, '{000-exodus.googlecode.com}-190-delete');

  //Enable/Disable room menus...
  if (items.Count = 1) and (items.Item[0].Type_ = 'room') then
    typedActs := actMap.GetActionsFor('')
  else
    typedActs := actMap.GetActionsFor('room');
  mnuPeople_Conference_InviteContacttoConference.Enabled := (Room.room_list.Count > 0);

  //Enable/Disable group menus...
  if (items.Count > 0) and (items.Item[0].Type_ = 'group') then
    typedActs := actMap.GetActionsFor('')
  else
    typedActs := actMap.GetActionsFor('group');
  SetupMenuItem(mnuPeople_Group_RenameGroup, '{000-exodus.googlecode.com}-150-rename');
  SetupMenuItem(mnuPeople_Group_DeleteGroup, '{000-exodus.googlecode.com}-190-delete');

  //Enable/Disable 'create' menu items...
  typedActs := getActionController().actionsForType('{create}');
  SetupMenuItem(mnuPeople_Contacts_AddContact, '{000-exodus.googlecode.com}-000-add-contact');
  SetupMenuItem(mnuPeople_Group_AddNewRoster, '{000-exodus.googlecode.com}-090-add-group');
end;

procedure TfrmExodus.pnlStatusLabelMouseEnter(Sender: TObject);
begin
  inherited;

  pnlStatusLabel.BevelKind := bkFlat;
end;

procedure TfrmExodus.pnlStatusLabelMouseLeave(Sender: TObject);
begin
  inherited;

  pnlStatusLabel.BevelKind := bkNone;
end;

procedure TfrmExodus.popChangeView(Sender: TObject);
begin
    if (Sender = popShowAll) and (not popShowAll.Checked) then begin
        MainSession.prefs.setBool('roster_only_online', false);
        if MainSession.Active then begin
            MainSession.FireEvent('/session/prefs', nil);
        end;
    end
    else if (Sender = popShowOnline) and (not popShowOnline.Checked) then begin
        MainSession.prefs.setBool('roster_only_online', true);
        if MainSession.Active then begin
            MainSession.FireEvent('/session/prefs', nil);
        end;
    end;
end;

procedure TfrmExodus.popCreatePopup(Sender: TObject);
var
    typedActs: IExodusTypedActions;
    idx: Integer;
    act: IExodusAction;
    root, mi: TTntMenuItem;
begin
  inherited;

  root := TTntMenuItem(popCreate.Items);

  //Clear previous...
  if root.Tag <> 0 then begin
      typedActs := IExodusTypedActions(Pointer(root.tag));
      typedActs._Release;
  end;

  //Fill in the results...
  typedActs := GetActionController().actionsForType('{create}');

  root.Clear();
  if (typedActs = nil) or (typedActs.ActionCount = 0) then
    exit;
  
  root.Tag := Integer(Pointer(typedActs));
  typedActs._AddRef;

  for idx := 0 to typedActs.ActionCount - 1 do begin
    //Insert spacer if more than three, and we're at the end
    {
    if (idx >= 3) and (idx = typedActs.ActionCount - 1) then begin
        mi := TTntMenuItem.Create(popCreate);
        mi.Caption := _('-');

        root.Add(mi);
    end;
    }

    act := typedActs.Action[idx];

    mi := TTntMenuItem.Create(popCreate);
    mi.Caption := act.Caption;
    mi.ImageIndex := act.ImageIndex;
    mi.Tag := Integer(Pointer(act));
    mi.OnClick := clickCreatePopupItem;
    //TODO:  setup submenus?

    root.Add(mi);
  end
end;

//Reset menu items for contacts and groups based on the roster selection
procedure TfrmExodus.ResetMenuItems(Node: TTnTTreeNode);
begin
//   if (Node = nil) then begin
//     mnuPeople_Group_RenameGroup.Enabled := false;
//     mnuPeople_Group_DeleteGroup.Enabled := false;
//     mnuPeople_Contacts_RenameContact.Enabled := false;
//     mnuPeople_Contacts_DeleteContact.Enabled := false;
//     mnuPeople_Contacts_BlockContact.Enabled := false;
//     mnuPeople_Contacts_ContactProperties.Enabled := false;
//     mnuPeople_Contacts_SendFile.Enabled := false;
//     mnuPeople_Contacts_SendFile.Enabled := false;
//     mnuPeople_Contacts_SendMessage.Enabled := false;
//     mnuPeople_Contacts_ViewHistory.Enabled := false;
//   end
//   else if (frmRosterWindow.getNodeType(Node) = node_grp) then begin
//     mnuPeople_Group_RenameGroup.Enabled := true;
//     mnuPeople_Group_DeleteGroup.Enabled := true;
//     mnuPeople_Contacts_RenameContact.Enabled := false;
//     mnuPeople_Contacts_DeleteContact.Enabled := false;
//     mnuPeople_Contacts_BlockContact.Enabled := false;
//     mnuPeople_Contacts_ContactProperties.Enabled := false;
//     mnuPeople_Contacts_SendFile.Enabled := false;
//     mnuPeople_Contacts_SendMessage.Enabled := false;
//     mnuPeople_Contacts_ViewHistory.Enabled := false;
//   end
//   else if (frmRosterWindow.getNodeType(Node) = node_ritem) then begin
//     mnuPeople_Group_RenameGroup.Enabled := false;
//     mnuPeople_Group_DeleteGroup.Enabled := false;
//     mnuPeople_Contacts_RenameContact.Enabled := true;
//     mnuPeople_Contacts_DeleteContact.Enabled := true;
//     mnuPeople_Contacts_BlockContact.Enabled := true;
//     mnuPeople_Contacts_ContactProperties.Enabled := true;
//     mnuPeople_Contacts_SendFile.Enabled := true;
//     mnuPeople_Contacts_SendMessage.Enabled := true;
//     mnuPeople_Contacts_ViewHistory.Enabled := true;
//   end;
//   //invite to room should only be available if rooms are open.
//   Self.mnuPeople_Conference_InviteContacttoConference.Enabled := (Room.room_list.Count > 0);
end;

procedure TfrmExodus.RemoveMenuShortCut(value: integer);
    procedure RemoveMenuShortCutRecurse(value: integer; menuItem: TMenuItem);
    var
        i: integer;
    begin
        if (menuItem.ShortCut = value) then
            menuItem.ShortCut := TextToShortCut('');
        if (menuItem.Count > 0) then begin
            for i := 0 to menuItem.Count - 1 do
                RemoveMenuShortCutRecurse(value, menuItem.Items[i]);
        end;
    end;
var
    i: integer;
begin
    for i := 0 to MainMenu1.Items.Count - 1 do
        RemoveMenuShortCutRecurse(value, MainMenu1.Items[i]);
end;

function TfrmExodus.DisableHelp(Command: Word; Data: Longint;
    var CallHelp: Boolean): Boolean;
begin
  CallHelp := false;
  Result := true;
end;

procedure TfrmExodus.glueWindow(doGlue: boolean);
begin
    _dockWindowGlued := doGlue;
end;

procedure TfrmExodus.WMMoving(var Msg: TWMMoving);
begin
    OutputDebugString('Got WM_MOVING');

    if (_dockWindowGlued) then begin
        if (_dockWindow <> nil) then begin
            _dockWindow.moveGlued();
        end;
    end;

    inherited;
end;

procedure TfrmExodus.WMMove(var Msg: TWMMove);
var
    gedge: TGlueEdge;
begin
    OutputDebugString('Got WM_MOVE');

    if (not _dockWindowGlued) then begin
        if (_dockWindow <> nil) then begin
            gedge := withinGlueSnapRange(_dockWindow, self, _glueRange);
            if (gedge <> geNone) then begin
                // Set the edge on the dock window.
                // Edge is opposite of gedge
                case gedge of
                    geNone: begin
                        _dockWindow.glueEdge := geNone;
                    end;
                    geTop: begin
                        _dockWindow.glueEdge := geBottom;
                        Self.Left := _dockWindow.Left;
                        Self.Top := _dockWindow.Top + _dockWindow.Height;
                    end;
                    geRight: begin
                        _dockWindow.glueEdge := geLeft;
                        Self.Top := _dockWindow.Top;
                        Self.Left := _dockWindow.Left - Self.Width;
                    end;
                    geLeft: begin
                        _dockWindow.glueEdge := geRight;
                        Self.Top := _dockWindow.Top;
                        Self.Left := _dockWindow.Left + _dockWindow.Width;
                    end;
                    geBottom: begin
                        _dockWindow.glueEdge := geTop;
                        Self.Left := _dockWindow.Left;
                        Self.Top := _dockWindow.Top - Self.Height;
                    end;
                end;
            end;
        end;
    end
    else begin
        if (_dockWindow <> nil) then begin
            _dockWindow.moveGlued();
        end;
    end;

    inherited;
end;

procedure TfrmExodus.WMExitSizeMove(var Message: TMessage);
var
    gedge: TGlueEdge;
begin
    if (_dockWindow <> nil) then begin
        gedge := withinGlueSnapRange(_dockWindow, self, _glueRange);
        if (gedge <> geNone) then begin
            _dockWindowGlued := true;
        end;
    end;

    inherited;
end;


procedure TfrmExodus.doHide();
begin
    _hidden := true;
    Self.Visible := false;
    PostMessage(Self.handle, WM_SYSCOMMAND, SC_MINIMIZE , 0);
end;

procedure TfrmExodus.ShowLogin();
begin
    if tabRoster.Visible then with tabRoster do begin
        Visible := false;
        SendToBack();
    end;

    with tabLogin do begin
        if not Visible then Visible := true;
        BringToFront();
    end;
end;
procedure TfrmExodus.ShowRoster();
begin
    if tabLogin.Visible then with tabLogin do begin
        Visible := false;
        SendToBack();
    end;

    with tabRoster do begin
        if not Visible then Visible := true;
        BringToFront();
    end;
end;

procedure TfrmExodus.UpdatePresenceDisplay;
var
    show: WideString;
    stat: WideString;
    cap:  WideString;
    idx:  Integer;
    txtWidth, maxWidth: Integer;
begin
    show := MainSession.Show;
    stat := MainSession.Status;
    idx  := 0;

    if (show = '') then begin
        idx := RosterTreeImages.Find('available');
        cap := _(sRosterAvail);
    end
    else if (MainSession.Show = 'away') then begin
        idx := RosterTreeImages.Find('away');
        cap := _(sRosterAway);
    end
    else if (MainSession.Show = 'dnd') then begin
        idx := RosterTreeImages.Find('dnd');
        cap := _(sRosterDND);
    end
    else if (MainSession.Show = 'chat') then begin
        idx := RosterTreeImages.Find('chat');
        cap := _(sRosterChat);
    end
    else if (MainSession.Show = 'xa') then begin
        idx := RosterTreeImages.Find('xa');
        cap := _(sRosterXA);
    end
    else if (MainSession.Show = 'offline') then begin
        idx := RosterTreeImages.Find('offline');
        cap := _(sRosterOffline);
        stat := '';
    end;

    if (stat <> '') then
        cap := cap + ' (' + stat + ')';

    txtWidth := WideCanvasTextWidth(lblStatus.Canvas, cap);
    maxWidth := pnlStatus.ClientWidth -
            (imgDown.Width + imgDown.Margins.Left + imgDown.Margins.Right) -
            (lblStatus.Margins.Left + lblStatus.Margins.Right);
    lblStatus.Hint := cap;
    lblStatus.Caption := cap;
    lblStatus.Width := Min(txtWidth, maxWidth);
    setTrayIcon(idx);
    ImageList1.GetIcon(idx, imgPresence.Picture.Icon);
end;


procedure TfrmExodus.clickCreatePopupItem(Sender: TObject);
var
    typedActs: IExodusTypedActions;
    act: IExodusAction;
begin
    typedActs := IExodusTypedActions(Pointer(popCreate.Items.tag));
    act := IExodusAction(Pointer(TTntMenuItem(Sender).Tag));

    typedActs.execute(act.Name);
end;

function TfrmExodus.IsShortcut(var Message: TWMKey): Boolean;
begin
    if (GetForegroundWindow <> Handle) then
    begin
        Result := false
    end
    else
    begin
        Result := inherited IsShortCut(Message)
    end;
end;

function TfrmExodus.AppKeyDownHook(var Msg: TMessage): Boolean;
begin
    // Prevent Alt and F10 from accessing main menu unless this form has focus
    case Msg.Msg of
    Cm_AppSysCommand:
        Result := (msg.WParam = SC_KEYMENU) and (GetForegroundWindow <> Handle);
    else
        Result := false;
    end;
end;

{---------------------------------------}
procedure TfrmExodus._PageControlNewWndProc(var Msg: TMessage);
begin
  if(Msg.Msg=TCM_ADJUSTRECT) then
  begin
      _PageControlSaveWinProc(Msg);
      PRect(Msg.LParam)^.Top:=PRect(Msg.LParam)^.Top-6;
  end
  else
      _PageControlSaveWinProc(Msg);

end;

initialization
    //JJF 5/5/06 not sure if registering for EXODUS_ messages will cause
    //problems for branded clients
    //(for instance when Exodus and brand are both running). Ask Joe H.
    //Joe H answered "it is desirable for all Exodus based clients to share presence"
    sExodusPresence := RegisterWindowMessage('EXODUS_PRESENCE');
    sExodusMutex := RegisterWindowMessage('EXODUS_MESSAGE');
    sShellRestart := RegisterWindowMessage('TaskbarCreated');
end.

