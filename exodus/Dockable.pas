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
unit Dockable;


interface

uses
    Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
    ComCtrls, Dialogs, ImgList, Buttons, ToolWin, Contnrs,
    ExtCtrls, TntComCtrls, StateForm, Unicode, XMLTag, buttonFrame, JabberMsg,
    Menus, TntMenus, TntExtCtrls, Exodus_TLB, COMToolbar, COMDockToolbar,
    COMExodusControlSite;

  function generateUID(): widestring;

type
  {
    Dockable forms may be docked/undocked either through drag -n- dock operations
    or programatically through their DockForm/FloatForm methods. Because there
    are two different paths that result in this state change One set of events
    has been defined that will fire in either case.
  }
  TfrmDockable = class(TfrmState, IControlDelegate)
    pnlDock: TTntPanel;
    pnlDockTop: TTntPanel;
    pnlDockTopContainer: TTntPanel;
    tbDockBar: TToolBar;
    btnDockToggle: TToolButton;
    btnCloseDock: TToolButton;
    pnlDockControlSite: TTntPanel;
    procedure FormCreate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    {
        Drag event.

        Override default event handlers to change when this form should accept
        dragged objects. Fired by dock manager when user drags something over
        tab.
    }
    procedure OnDockedDragOver(Sender, Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean);virtual;
    {
        Drop event

        Override to handle objects dropped into form, specifically
        from dock manager (tabs)
    }
    procedure OnDockedDragDrop(Sender, Source: TObject; X, Y: Integer); virtual;
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure btnCloseDockClick(Sender: TObject);
    procedure btnDockToggleClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    _docked: boolean;

    _normalImageIndex: integer;//image shown when not notifying
    _prefs_callback_id: integer; //ID for prefs events
    _session_close_all_callback: integer;
    _session_dock_all_callback: integer;
    _session_float_all_callback: integer;

    //Unread messages in the currently open window
    _unreadmsg: integer; // Unread msg count

    //Messages persisted through session, available at OnRestoreWindowState
    _persistMessages: boolean; //should messages be persisted through a session?

    _uid: widestring; // Unique ID (usually a jid) for this particular dockable window
    _priorityflag: boolean; // Is there a high priority msg unread
    _activating: boolean; //in GotActive event
    _lastActivity: TDateTime; // what was the last activity for this window
    _closing: boolean; // Is the window closing (for updatedocked() call);
    
    _COMDockbar: IExodusDockToolbar;
    _dbControlContainer: IExodusControlSite;

    function  getImageIndex(): Integer;
    procedure setImageIndex(idx: integer);
    procedure prefsCallback(event: string; tag: TXMLTag);
    procedure closeAllCallback(event: string; tag: TXMLTag);
    procedure dockAllCallback(event: string; tag: TXMLTag);
    procedure floatAllCallback(event: string; tag: TXMLTag);
    //procedure restoreUnreadXML();
  protected
    updateDockedCnt: integer;

    procedure OnRestoreWindowState(windowState : TXMLTag);override;
    procedure OnPersistWindowState(windowState : TXMLTag);override;
    procedure OnPersistedMessage(msg: TXMLTag);virtual;

    property NormalImageIndex: integer read _normalImageIndex write _normalImageIndex;

    procedure showDockbar(show: boolean);
    procedure showTopbar(show: boolean);
    procedure showCloseButton(show: boolean);
    procedure showDockToggleButton(show: boolean);
    procedure updateMsgCount(msg: TJabberMessage); overload; virtual;
    procedure UpdatePriority(msg: TJabberMessage); overload; virtual;
    procedure updateMsgCount(msgTag: TXMLTag); overload; virtual;
    procedure updateLastActivity(lasttime: TDateTime); virtual;

    //getters/setters for activity window properties. Allows subclasses to set their
    //state as the state of these properties change
    procedure SetUnreadMsgCount(value : integer);virtual;
    function GetUnreadMsgCount(): Integer;virtual;
    procedure updateDocked(); virtual;

    function AddControl(ID: widestring; ToolbarName: widestring): IExodusToolbarControl;virtual;

    function GetDockbar(): IExodusDockToolbar;
    procedure CreateParams(var Params: TCreateParams); override;
    procedure StoreUnreadMessage(unreadMsg: widestring; key: widestring = '');
    procedure OnRestoreUnreadDB ();override;

public
    _windowType: widestring; // what kind of dockable window is this

    Constructor Create(AOwner: TComponent); override;

    procedure Dock(NewDockSite: TWinControl; ARect: TRect); override;
    procedure Repaint; override;


    procedure DockForm; virtual;
    procedure FloatForm; virtual;

    procedure ShowDefault(bringtofront:boolean=true);override;

    {
        Event fired when docking is complete.

        Docked property will be true, tabsheet will be assigned. This event
        is fired after all other docking events are complete.
    }
    procedure OnDocked();virtual;

    {
        Event fired when a float (undock) is complete.

        Docked property will be false, tabsheet will be nil. This event
        is fired after all other floating events are complete.
    }
    procedure OnFloat();virtual;

    {
        A notification event has occurred.

        notifyEvents is a bitmap flag of what events should fire.
    }
    procedure OnNotify(notifyEvents: integer);override;

    procedure gotActivate();override;

    {
        Get the UID for the window.
    }
    function getUID(): Widestring; virtual;

    {
        Set the UID for the window.
    }
    procedure setUID(id:widestring); virtual;

    {
        Clear out the UnreadMsgCount
    }
    procedure ClearUnreadMsgCount(); virtual;


    { Public Properties }
    property Docked: boolean read _docked write _docked;
    property FloatPos: TRect read getPosition;

    property ImageIndex: Integer read getImageIndex write setImageIndex;

    {
        A UID (usually a JID) that identifies this window for tracking
        by the activity window.
    }
    property UID: WideString read _uid write _uid;
    property UnreadMsgCount: integer read GetUnreadMsgCount write SetUnreadMsgCount;
    property PriorityFlag: boolean read _priorityflag write _priorityflag;
    property Activating: boolean read _activating write _activating;
    property LastActivity: TDateTime read _lastActivity write _lastActivity;
    property WindowType: widestring read _windowType write _windowType;
    property PersistUnreadMessages: boolean read _persistMessages write _persistMEssages;
    property Dockbar: IExodusDockToolbar read GetDockbar;
  end;

implementation

{$R *.dfm}

uses
    PrefController,
    RosterImages,
    JabberConst,
    ExSession,
    IDGlobal,
    ComObj,
    SQLUtils,
    XMLUtils, XMLParser, ChatWin, Debug, JabberUtils, ExUtils,  GnuGetText, Session, Jabber1;

var
  dockable_uid: integer;
  //frmDockable: TfrmDockable;

const
    DOCKBAR_CONTROL_DEFAULT_HEIGHT = 27;

function generateUID(): widestring;
begin
    Inc(dockable_uid);
    Result := 'dockableUID_' + inttostr(dockable_uid);
end;

procedure initializeDatabase();
begin
    try
        if (DataStore.CheckForTableExistence('unread_cache')) then exit;

        DataStore.ExecSQL('CREATE TABLE unread_cache (' +
                'key TEXT, ' +
                'xml TEXT);'
                );
        DataStore.ExecSQL('CREATE INDEX unread_cache_idx1 on unread_cache (key);');
    except
        //TODO: loggit
    end;
end;

Constructor TfrmDockable.Create(AOwner: TComponent);
begin
    inherited;
    _normalImageIndex := RosterImages.RI_AVAILABLE_INDEX;
    _docked := false;
    with MainSession do
    begin
        SnapBuffer := Prefs.getInt('edge_snap');

        _prefs_callback_id := RegisterCallback(prefsCallback, '/session/prefs');
        _session_close_all_callback := RegisterCallback(closeAllCallback, '/session/close-all-windows');
        _session_dock_all_callback := RegisterCallback(dockAllCallback, '/session/dock-all-windows');
        _session_float_all_callback := RegisterCallback(floatAllCallback, '/session/float-all-windows');
        //set initial conditions for dock
        if (Jabber1.getAllowedDockState() = adsForbidden) then
            _docked := false  //docking not allowed
        else
            //initial condition, how to handle windows we have no state for
            _docked := MainSession.Prefs.getBool('start_docked');
        end;

    _unreadmsg := -1;
    _persistMessages := false;

    _priorityflag := false;
    _activating := false;
    _uid := generateUID();

end;

procedure TfrmDockable.CreateParams(var Params: TCreateParams);
begin
    inherited CreateParams(Params);
    params.ExStyle := params.ExStyle or WS_EX_APPWINDOW;
    if (not Self._docked) then
        params.WndParent := GetDesktopwindow;
end;

procedure TfrmDockable.Dock(NewDockSite: TWinControl; ARect: TRect);
begin
    _docked := (NewDockSite <> nil);
    inherited;
end;

procedure TfrmDockable.Repaint;
var
    contHeight: integer;
    topHeight: integer;
begin
    topHeight := max(pnlDockTop.Height, tbDockBar.Height);
    contHeight := topHeight;
    if (_dbControlContainer <> nil) and (_dbControlContainer as IExodusToolbarControl).Visible then
        inc(contHeight, DOCKBAR_CONTROL_DEFAULT_HEIGHT);

    //if height should change, realign everything    
    if (pnlDock.Height <> contHeight) then
    begin
        disableAlign();
        try
            pnlDockTopContainer.Height := topHeight;
            pnlDock.Height := contHeight;
        finally
            enableAlign();
        end;    
    end;
    inherited;
end;

function TfrmDockable.AddControl(ID: widestring; ToolbarName: widestring): IExodusToolbarControl;
var
    twc: TWinControl;
begin
    Result := nil;
    if (ToolbarName <> 'dockbar') then exit;

    //dockbar will only have one control at a time. If this control is already
    //created, just return it, otherwise destroy existing container
    //and make new one
    if (_dbControlContainer = nil) or (_dbControlContainer.ControlGUID <> ID) then
    begin
        //"deparent" container and let ref counts free it when appropriate
        if (_dbControlContainer <> nil) then
            TExodusControlSite((_dbControlContainer as IInterfaceComponentReference).GetComponent).Parent := nil;

         //don't specify an owner, let ref counts manage lifetime
        _dbControlContainer := TExodusControlSite.create(nil, pnlDockControlSite, StringToGUID(ID)) as IExodusControlSite;
        _dbControlContainer.AlignClient := true;
        Repaint();
    end;
    Result := _dbControlContainer as IExodusToolbarControl;
end;

function TfrmDockable.GetDockbar(): IExodusDockToolbar;
begin
    if (_COMDockbar = nil) then
        _COMDockbar := TExodusDockToolbar.create(tbDockbar, ExSession.COMRosterImages, Self, 'dockbar', false);
    Result := _COMDockbar;
end;

{---------------------------------------}
procedure TfrmDockable.FormCreate(Sender: TObject);
begin
    btnCloseDock.ImageIndex := RosterImages.RosterTreeImages.Find(RI_CLOSETAB_KEY);
    btnDockToggle.ImageIndex := RosterImages.RosterTreeImages.Find(RI_UNDOCK_KEY);
    _closing := false;

    inherited;
   
end;

procedure TfrmDockable.setImageIndex(idx: integer);
begin
    if (_normalImageIndex <> idx) then
    begin
        _normalImageIndex := idx;
        RosterTreeImages.GetIcon(idx, Self.Icon);
        updateDocked();
    end;
end;

function TfrmDockable.getImageIndex(): Integer;
begin
    Result := _normalImageIndex;
end;

procedure TfrmDockable.SetUnreadMsgCount(value : integer);
begin
    if (_unreadMsg <> value) then
    begin
        _unreadmsg := value;
        updateDocked();
    end;
end;

function TfrmDockable.GetUnreadMsgCount(): integer;
begin
    Result := _unreadmsg;
end;

procedure TfrmDockable.OnDockedDragOver(Sender, Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
begin
    inherited;
    Accept := false;
    //implement in subclass
end;

procedure TfrmDockable.OnDockedDragDrop(Sender, Source: TObject; X, Y: Integer);
begin
    inherited;
    //implement in subclass
end;

procedure TfrmDockable.OnPersistedMessage(msg: TXMLTag);
begin
    //nop in base class
end;

{---------------------------------------}
procedure TfrmDockable.btnCloseDockClick(Sender: TObject);
begin
    inherited;
    Self.Close();
end;

{---------------------------------------}
procedure TfrmDockable.btnDockToggleClick(Sender: TObject);
begin
    inherited;
    if (Docked) then
        FloatForm()
    else begin
        DockForm();
        //if dockman is not iconizied, bring tab to front
        if (not IsIconic(GetDockManager().getHWND)) then
        begin
            GetDockManager().BringToFront();
            GetDockManager.BringDockedToTop(Self);
        end;
    end;
//will be activated by float or when brought to front    _doActivate();
end;

{---------------------------------------}
procedure TfrmDockable.DockForm;
begin
    //make sure we are restored before docking, elimiates docking eccentricites
    if (WindowState = wsMinimized) then    
        ShowWindow(Self.Handle, SW_RESTORE);
    GetDockManager().OpenDocked(self);
end;

{---------------------------------------}
procedure TfrmDockable.FloatForm;
begin
    GetDockManager().FloatDocked(Self);
end;

{---------------------------------------}
procedure TfrmDockable.gotActivate();
begin
    inherited;
    //if we are already active, ignore this request
    if (not _activating) then
    begin
        _activating := true;
        ClearUnreadMsgCount();
        UpdateDocked();
        _activating := false;
    end;
end;

{---------------------------------------}
procedure TfrmDockable.ClearUnreadMsgCount();
var
    key, sql: string;
begin
    //only need to updateDocked if we are changing state
    if ((_unreadmsg > 0) or _priorityflag) then
    begin
        try
            initializeDatabase();
            
            key := str2sql(GetWindowStateKey());
            sql := Format('delete from unread_cache where key=''%s'';',
                    [key]);
            DataStore.ExecSQL(sql);
        except
        end;

        _unreadmsg := 0;
        _priorityflag := false;
        updateDocked();
    end;
end;

{---------------------------------------}
procedure TfrmDockable.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    inherited;
    MainSession.UnRegisterCallback(_prefs_callback_id);
    MainSession.UnRegisterCallback(_session_close_all_callback);
    MainSession.UnRegisterCallback(_session_dock_all_callback);
    MainSession.UnRegisterCallback(_session_float_all_callback);
end;

procedure TfrmDockable.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
    _closing := true;
    GetDockManager().CloseDocked(Self);
    inherited;
end;

{---------------------------------------}
procedure TfrmDockable.ShowDefault(bringtofront:boolean);
var
    initVis: boolean;
begin
    initVis := Self.Visible;
    RestoreWindowState();

    if (Docked) then
    begin
        //not visible --> initial state, floating --> moving to docked state
        if ((not Self.Visible) or Self.Floating) then
        begin
            Self.DockForm();//will cause dockmanager to be shown
        end;

        //should be showing by the time we get here
        if (bringtofront) then begin
            GetDockManager().BringDockedToTop(Self);
            GetDockManager().BringToFront();
        end;
    end
    //initial condition, open as stateform window
    else if (not Self.Visible) then
    begin
        inherited; //handles show, bring to front
        OnFloat();
    end
    else begin
        //floating --> moving to floating state
        inherited; //handles bring to front
    end;
    if (not initVis) then
        updateDocked(); // Make sure activity list is updated if we became visible
end;

{---------------------------------------}
procedure TfrmDockable.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
    inherited;

    // handle Ctrl-Tab to switch tabs
    if ((Key = VK_TAB) and (ssCtrl in Shift) and (self.Docked))then begin
        GetDockManager().SelectNext(not (ssShift in Shift));
        Key := 0;
    end
    //if ctrl d try to toggle dock state
    else if ((Jabber1.getAllowedDockState() <> adsForbidden) and ([ssCtrl] = Shift)) and (Key=68) then begin
      btnDockToggleClick(Self);
      Key := 0;
    end
    else if ((Key = VK_ESCAPE) and
             (MainSession.Prefs.getBool('esc_close'))) then
    begin
        Self.Close();
    end;
end;

function visibleButtonCount(bar: TToolBar): integer;
var
    i : integer;
begin
    Result := 0;
    for i := 0 to bar.ButtonCount - 1 do begin
        if (bar.Buttons[i].Visible) then
            inc(Result);
    end;
end;

procedure TfrmDockable.OnDocked();
begin
    Self.Align := alClient;
    tbDockBar.Visible := true;
    btnCloseDock.Visible := true;
    btnDockToggle.ImageIndex := RosterImages.RosterTreeImages.Find(RI_UNDOCK_KEY);
    btnDockToggle.Hint := _('Undock this tab (ctrl-d)');
    btnDockToggle.Visible := (Jabber1.getAllowedDockState() <> adsForbidden);
    pnlDockTop.Visible := true;
end;

procedure TfrmDockable.OnFloat();
begin
    btnCloseDock.Visible := false;
    btnDockToggle.ImageIndex := RosterImages.RosterTreeImages.Find(RI_DOCK_KEY);
    btnDockToggle.Visible := (Jabber1.getAllowedDockState() <> adsForbidden);
    btnDockToggle.Hint := _('Dock this window (ctrl-d)');
    //hide top panel if no toolbar buttons are showing and no subclass has
    //added a child component (pnlDockTop.ControlCount = 1 -> only toolbar)
    tbDockBar.Visible := (visibleButtonCount(tbDockbar) > 0);
    pnlDockTop.Visible := (pnlDockTop.ControlCount <> 1) or tbDockBar.Visible;
end;

//procedure TfrmDockable.restoreUnreadXML();
//var
//        txlist: TXMLTagList;
//        idx: Integer;
//        ttag: TXMLTag;
//begin
//        ttag := windowState.GetFirstTag('unread');
//        if (ttag <> nil) then
//        begin
//            txList := ttag.ChildTags;
//            for idx := 0 to txList.Count - 1 do
//                OnPersistedMessage(txList[idx]);
//        end;
//end;

procedure TfrmDockable.OnRestoreUnreadDB();
    var
        parser: TXMLTagParser;
        table: IExodusDataTable;
        sql, key: string;
        xml: Widestring;
        tag: TXMLTag;
        idx:  Integer;
begin
        PersistUnreadMessages := false;
        parser := nil;
        tag := nil;
        initializeDatabase();

        key := str2sql(WidestringToUTF8(GetWindowStateKey()));
        try
            table := CreateCOMObject(CLASS_ExodusDataTable) as IExodusDataTable;
            sql := Format('select * from unread_cache where (key=''%s'');',[key]);
            if not DataStore.GetTable(sql, table) then
            begin
                FreeAndNil(tag);
                FreeAndNil(parser);
                PersistUnreadMessages := true;
                exit;
            end;
            if not table.FirstRow then
            begin
                FreeAndNil(tag);
                FreeAndNil(parser);
                PersistUnreadMessages := true;
                exit;
            end;

            parser := TXMLTagParser.Create();
            for idx := 0 to table.RowCount - 1 do begin
                xml := table.GetFieldByName('xml');
                if (xml = '') then continue;
                xml := XML_UnEscapeChars(xml);

                parser.Clear();
                parser.ParseString(xml);
                if (parser.Count = 0) then continue;
                tag := parser.popTag();
                if (tag <> nil) then OnPersistedMessage(tag);
                FreeAndNil(tag);
                table.NextRow;
            end;
        except
            //TODO: loggit
        end;
        FreeAndNil(tag);
        FreeAndNil(parser);
        PersistUnreadMessages := true;
end;

procedure TfrmDockable.OnRestoreWindowState(windowState : TXMLTag);
begin
    inherited;
    if (Jabber1.getAllowedDockState() = adsForbidden) then
        _docked := false  //docking not allowed
    else if (MainSession.Prefs.getBool('restore_window_state') and
            (windowState.GetAttribute('dock') <> '')) then
        _docked := windowState.GetAttribute('dock') = 't'
    else
        //initial condition, how to handle windows we have no state for
        _docked := MainSession.Prefs.getBool('start_docked');
end;

procedure TfrmDockable.OnPersistWindowState(windowState : TXMLTag);
begin
    if (not Floating) then
        windowState.setAttribute('dock', 't')
    else
        windowState.setAttribute('dock', 'f');
    inherited;
end;

procedure TfrmDockable.OnNotify(notifyEvents: integer);
begin
    //if we are docked, delgate to dock manager
    if (Docked) then
        GetDockManager().OnNotify(Self, notifyEvents)
    else inherited; //inherited will handle isNotifying and floating window notifications
end;

procedure TfrmDockable.showDockbar(show: boolean);
begin
    tbDockBar.Visible := show;
end;

procedure TfrmDockable.showTopbar(show: boolean);
begin
    pnlDockTop.Visible := show;
end;

procedure TfrmDockable.FormDestroy(Sender: TObject);
begin
    _COMDockbar := nil;
    inherited;
end;

procedure TfrmDockable.showCloseButton(show: boolean);
begin
    btnCloseDock.Visible := show;
end;

procedure TfrmDockable.showDockToggleButton(show: boolean);
begin
    btnDockToggle.Visible := show;
end;

procedure TfrmDockable.prefsCallback(event: string; tag: TXMLTag);
begin
    if (event = '/session/prefs') then
        SnapBuffer := MainSession.Prefs.getInt('edge_snap');
end;

function TfrmDockable.getUID(): Widestring;
begin
    Result := _uid;
end;

procedure TfrmDockable.setUID(id:widestring);
begin
    _uid := id;
end;

procedure TfrmDockable.updateMsgCount(msg: TJabberMessage);
begin
    UpdatePriority(msg);
    UpdateMsgCount(msg.Tag);
end;

//create an appropriate delay tag from datetime, optional from, description
function CreateDelayTag(dt: TDateTime; UTC: boolean = false; from: widestring=''; desc: widestring=''): TXMLTag;
begin
    // This delay tag is in XEP-0203 format (complient with XEP-0082)
    Result := TXMLTag.create('delay');
    Result.setAttribute('xmlns', XMLNS_DELAY_203);
    Result.setAttribute('stamp', DateTimeToXEP82DateTime(dt, UTC));
    if (from <> '') then
        Result.setAttribute('from', from);
    if (desc <> '') then
        Result.AddCData(desc)
end;

procedure TfrmDockable.UpdatePriority(msg: TJabberMessage);
begin
    //no message or we are not tracking messages
    if (msg = nil) then exit;

    if (not Active) then
    begin
        if ((not Docked) or
            (GetDockManager().getTopDocked() <> Self) or
            (not GetDockManager().isActive)) then
        begin
            _priorityflag := _priorityflag or (( msg.Priority = High) and (not msg.isMe));
        end;
    end;
end;

procedure TfrmDockable.updateMsgCount(msgTag: TXMLTag);
var
    etag, dttag: TXMLTag;
    ttag: TXMLTag;
begin
    //no message or we are not tracking messages
    if (msgTag = nil) or (_unreadmsg = -1) then exit;

    if (not Active) then
    begin
        if ((not Docked) or
            (GetDockManager().getTopDocked() <> Self) or
            (not GetDockManager().isActive)) then
        begin
            Inc(Self._unreadmsg);
            if (PersistUnreadMessages) then
            begin
                ttag := nil;
                //add dtstamp if not already in packet
                dttag := GetDelayTag(msgTag);
                if (dttag = nil) then
                begin
                    ttag := TXMLTag.create(msgTag);
                    ttag.AddTag(CreateDelayTag(UTCNow(), true));
                end;

                //filter tag, removing anything we don't want to persist (events for instance)
                etag := msgTag.QueryXPTag(XP_MSGXEVENT);
                if (etag <> nil) then
                begin
                    if (ttag = nil) then
                        ttag := TXMLTag.create(msgTag);
                    etag := ttag.QueryXPTag(XP_MSGXEVENT);
                    ttag.RemoveTag(etag);
                end;
                if (ttag <> nil) then
                begin
                    StoreUnreadMessage(ttag.XML);
                    ttag.Free();
                end
                else StoreUnreadMessage(msgTag.XML);
            end;
            updateDocked();
        end;
    end;
end;

procedure TfrmDockable.updateLastActivity(lasttime: TDateTime);
begin
    if (lasttime > _lastActivity) then begin
        _lastActivity := lasttime;
        updateDocked();
    end;
end;

procedure TfrmDockable.closeAllCallback(event: string; tag: TXMLTag);
begin
    if (event = '/session/close-all-windows') then begin
        Self.Close();
        Application.ProcessMessages();
    end;
end;

procedure TfrmDockable.dockAllCallback(event: string; tag: TXMLTag);
begin
    if ((event = '/session/dock-all-windows') and (not Docked)) then
        Self.DockForm;
end;

procedure TfrmDockable.floatAllCallback(event: string; tag: TXMLTag);
begin
    if ((event = '/session/float-all-windows') and (_docked)) then
        Self.FloatForm;
end;

procedure TfrmDockable.updateDocked();
begin
    if (_closing) then exit;
    
    Inc(updateDockedCnt);

    // Prevent UpdateDocked being called from updateDocked
    if (updateDockedCnt <= 1) then begin
//        try
            getDockManager().UpdateDocked(Self);
//        except
//        end;
    end;

    Dec(updateDockedCnt);
end;


procedure TfrmDockable.StoreUnreadMessage(unreadMsg: widestring; key: widestring);
var
    em, sql: widestring;
begin
    initializeDatabase();

    if (key = '') then
        key := str2sql(WideStringToUTF8(GetWindowStateKey()));
    em := XML_EscapeChars(unreadMsg);
    sql := Format('insert into unread_cache (key,xml) values (''%s'',''%s'');',
                  [key, str2sql(WideStringToUTF8(em))]);
    DataStore.ExecSQL(sql);
end;

initialization
    dockable_uid := 0;


end.
