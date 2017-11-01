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
unit ActivityWindow;



interface

uses
  Windows,
  Messages,
  SysUtils,
  Variants,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  ExForm,
  Dockable,
  TntComCtrls,
  ComCtrls,
  ExtCtrls,
  TntExtCtrls,
  ExodusDockManager,
  StdCtrls,
  ExGradientPanel,
  AWItem,
  Unicode,
  DockWindow,
  Menus,
  TntMenus,
  TntStdCtrls,
  Buttons,
  TntButtons,
  XMLTag,
  ExCustomSeparatorBar;

type

  TScrollState = (ssDisabled, ssEnabled, ssNewMessage, ssNewWindow, ssPriority);

  TAWTrackerItem = class
  private
    { Private declarations }
    _dockable_frm: TfrmDockable;
    _awItem: TfAWItem;

  protected
    { Protected declarations }

  public
    { Public declarations }
    property frm: TfrmDockable read _dockable_frm write _dockable_frm;
    property awItem: TfAWItem read _awItem write _awItem;
  end;

  TfrmActivityWindow = class(TExForm)
    pnlListBase: TExGradientPanel;
    pnlListScrollUp: TExGradientPanel;
    pnlListScrollDown: TExGradientPanel;
    pnlList: TExGradientPanel;
    pnlListSort: TExGradientPanel;
    imgScrollUp: TImage;
    imgScrollDown: TImage;
    lblSort: TTntLabel;
    popAWSort: TTntPopupMenu;
    mnuAlphaSort: TTntMenuItem;
    mnuRecentSort: TTntMenuItem;
    mnuTypeSort: TTntMenuItem;
    mnuUnreadSort: TTntMenuItem;
    SortTopSpacer: TBevel;
    ListLeftSpacer: TBevel;
    ListRightSpacer: TBevel;
    imgSortArrow: TImage;
    pnlBorderTop: TExGradientPanel;
    pnlBorderBottom: TExGradientPanel;
    imgShowRoster: TImage;
    SortLeftSpacer: TBevel;
    SortRightSpacer: TBevel;
    timShowActiveDocked: TTimer;
    popAWList: TTntPopupMenu;
    mnuAW_CloseAll: TTntMenuItem;
    mnuAW_DockAll: TTntMenuItem;
    mnuAW_FloatAll: TTntMenuItem;
    timScrollTimer: TTimer;
    ScrollUpSeparatorBar: TExCustomSeparatorBar;
    SortSeparatorBar: TExCustomSeparatorBar;
    ScrollDownSeparatorBar: TExCustomSeparatorBar;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure pnlListScrollUpClick(Sender: TObject);
    procedure pnlListScrollDownClick(Sender: TObject);
    procedure mnuAlphaSortClick(Sender: TObject);
    procedure mnuRecentSortClick(Sender: TObject);
    procedure mnuTypeSortClick(Sender: TObject);
    procedure mnuUnreadSortClick(Sender: TObject);
    procedure pnlListSortClick(Sender: TObject);
    procedure imgShowRosterClick(Sender: TObject);
    procedure timShowActiveDockedTimer(Sender: TObject);
    procedure mnuAW_CloseAllClick(Sender: TObject);
    procedure mnuAW_DockAllClick(Sender: TObject);
    procedure mnuAW_FloatAllClick(Sender: TObject);
    procedure pnlListScrollUpMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure pnlListScrollUpMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure timScrollTimerTimer(Sender: TObject);
    procedure pnlListScrollDownMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure pnlListScrollDownMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure pnlListResize(Sender: TObject);
    procedure pnlListBaseResize(Sender: TObject);
  private
    { Private declarations }
    _timerScrollUp: boolean;
    _trackingList: TWidestringList;
    _docked: boolean;
    _activeitem: TfAWItem;
    _dockwindow: TfrmDockWindow;
    _showingTopItem: integer;
    _oldActivateSheet: TTntTabSheet;
    _curListSort: TSortState;
    _canScrollUp: boolean;
    _canScrollDown: boolean;
    _StartColor: TColor;
    _EndColor: TColor;
    _sortDefaultStartColor: TColor;
    _sortDefaultEndColor: TColor;
    _scrollPriorityStartColor: TColor;
    _scrollPriorityEndColor: TColor;
    _scrollNewWindowStartColor: TColor;
    _scrollNewWindowEndColor: TColor;
    _scrollNewMessageStartColor: TColor;
    _scrollNewMessageEndColor: TColor;
    _scrollDefaultStartColor: TColor;
    _scrollDefaultEndColor: TColor;
    _scrollEnabledStartColor: TColor;
    _scrollEnabledEndColor: TColor;
    _sort_bevel_shadow_color: TColor;
    _sort_bevel_highlight_color: TColor;
    _scrollup_bevel_shadow_color: TColor;
    _scrollup_bevel_highlight_color: TColor;
    _scrolldown_bevel_shadow_color: TColor;
    _scrolldown_bevel_highlight_color: TColor;

    _scrollUpState: TScrollState;
    _scrollDownState: TScrollState;
    _currentActivePage: TTntTabSheet;
    _FilesDragAndDropEnabled: Boolean;
    _needToSortList: boolean;    // Added to try and cut down on sorts as performance is hurt by multiple sorts
    _lastListActivity: TDateTime;
    _sessionCB: integer;
    _doUpdates: boolean;

    procedure _clearTrackingList();
    function _findItem(awitem: TfAWItem): TAWTrackerItem;
    procedure _sortTrackingList(sortType: TSortState = ssUnsorted);
    procedure _updateDisplay(allowPartialVisible: boolean = true);
    procedure _activateNextDockedItem(curitemindx: integer);
    procedure _enableScrollUp(doenable: boolean = true);
    procedure _enableScrollDown(doenable: boolean = true);
    procedure _setScrollUpColor();
    procedure _setScrollDownColor();
    function _getItemCount(): integer;
    procedure _sortTrackingListRecentActivity();
    procedure _sortTrackingListType();
    procedure _sortTrackingListUnread();
    procedure _sortTrackingListAlpha();
    procedure _setFilesDragAndDrop(Value: Boolean);
    procedure _forceSyncOfDockedPanel();
  protected
    { Protected declarations }
    procedure CreateParams(Var params: TCreateParams); override;
    procedure onItemClick(Sender: TObject);

  public
    { Public declarations }
    procedure activateItem(awitem: TfAWItem);
    procedure DockActivityWindow(dockSite : TWinControl);
    procedure removeItem(var item:TAWTrackerItem);
    function addItem(frm:TfrmDockable): TAWTrackerItem;
    function findItem(id:widestring): TAWTrackerItem; overload;
    function findItem(frm:TfrmDockable): TAWTrackerItem; overload;
    function findItem(awitem: TfAWItem): TAWTrackerItem; overload;
    function findItem(index: integer): TAWTrackerItem; overload;
    function findItemIndex(awitem: TfAWItem): integer;
    procedure scrollToActive();
    procedure setDockingSpacers(dockstate: TDockStates);
    procedure itemChangeUpdate(const item: TAWTrackerItem);
    procedure selectNextItem();
    procedure selectPrevItem();
    procedure SetItemName(awitem: TfAWItem; name: widestring; itemhint: widestring);
    procedure onSessionCallback(event: string; tag: TXMLTag);
    procedure forceUpdate();
    procedure enableListUpdates(enable: boolean = true);
    procedure closeActiveDockedWindow();

    property docked: boolean read _docked write _docked;
    property dockwindow: TfrmDockWindow read _dockwindow write _dockwindow;
    property currentActivePage: TTntTabSheet read _currentActivePage;
    property itemCount: integer read _getItemCount;
    property FilesDragAndDrop: Boolean read _FilesDragAndDropEnabled write _SetFilesDragAndDrop;
    property currentListSort: TSortState read _curListSort;
    property needToSortList: boolean read _needToSortList write _needToSortList;
    property updatesEnabled: boolean read _doUpdates;

  end;

  // Global Functions
  procedure DockActivityWindow(docksite : TWinControl);
  function GetActivityWindow() : TfrmActivityWindow;
  procedure CloseActivityWindow();

var
  frmActivityWindow: TfrmActivityWindow;

implementation

uses
    Room,
    ChatWin,
    Session,
    Jabber1,
    RosterImages,
    gnugettext,
    ExUtils,
    ShellAPI,
    stringprep;

{$R *.dfm}

const
    sSortBy         = 'Sort By:  ';
    sSortUnsorted   = 'Unsorted';  // Not currently supported
    sSortAlpha      = 'Alphabetical';
    sSortRecent     = 'Activity';
    sSortType       = 'Type';
    sSortUnread     = 'Unread';


{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
procedure DockActivityWindow(docksite : TWinControl);
begin
    if (frmActivityWindow <> nil) then
        frmActivityWindow.DockActivityWindow(docksite);
end;

{
    Get the singleton instance of the activity window
}
function GetActivityWindow() : TfrmActivityWindow;
begin
    if (frmActivityWindow = nil) then
        frmActivityWindow := TfrmActivityWindow.Create(Application);
    Result := frmActivityWindow;
end;

{
    Free the singleton activity window
}
procedure CloseActivityWindow();
begin
    if (frmActivityWindow <> nil) then begin
        frmActivityWindow.Close();
        frmActivityWindow := nil;
    end;
end;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
procedure TfrmActivityWindow.CreateParams(Var params: TCreateParams);
begin
    // Make this window show up on the taskbar
    inherited CreateParams( params );
    params.ExStyle := params.ExStyle or WS_EX_APPWINDOW;
end;

{---------------------------------------}
procedure TfrmActivityWindow.FormCreate(Sender: TObject);
var
    tag: TXMLTag;
begin
    inherited;
    _trackingList := TWidestringList.Create;
    _showingTopItem := -1;
    _canScrollUp := false;
    _canScrollDown := false;
    _oldActivateSheet := nil;
    _needToSortList := true;

    case MainSession.Prefs.getInt('activity_window_sort') of
        0: begin
            _curListSort := ssUnsorted;
            lblSort.Caption := _(sSortBy) + _(sSortUnsorted);
        end;
        1: begin
            _curListSort := ssAlpha;
            lblSort.Caption := _(sSortBy) + _(sSortAlpha);
        end;
        2: begin
            _curListSort := ssRecent;
            lblSort.Caption := _(sSortBy) + _(sSortRecent);
        end;
        3: begin
            _curListSort := ssType;
            lblSort.Caption := _(sSortBy) + _(sSortType);
        end;
        4: begin
            _curListSort := ssUnread;
            lblSort.Caption := _(sSortBy) + _(sSortUnread);
        end;
    end;

    frmExodus.ImageList1.GetIcon(RosterTreeImages.Find('arrow_up'), imgScrollUp.Picture.Icon);
    frmExodus.ImageList1.GetIcon(RosterTreeImages.Find('arrow_down'), imgScrollDown.Picture.Icon);
    frmExodus.ImageList1.GetIcon(RosterTreeImages.Find('arrow_down'), imgSortArrow.Picture.Icon);
    frmExodus.ImageList1.GetIcon(RosterTreeImages.Find('show_roster'), imgShowRoster.Picture.Icon);

    _scrollUpState := ssDisabled;
    _scrollDownState := ssEnabled;
    _startColor := pnlList.GradientProperites.startColor;
    _endColor := pnlList.GradientProperites.endColor;
    _scrollDefaultStartColor := pnlListScrollUp.GradientProperites.startColor;
    _scrollDefaultEndColor := pnlListScrollUp.GradientProperites.endColor;
    _sortDefaultStartColor := pnlListSort.GradientProperites.startColor;
    _sortDefaultEndColor := pnlListSort.GradientProperites.endColor;
    _scrollEnabledStartColor := $00C4B399;
    _scrollEnabledEndColor := $00A58A69;
    _scrollPriorityStartColor := $000000ff;
    _scrollPriorityEndColor := $000000ff;
    _scrollNewWindowStartColor := $0000ffff;
    _scrollNewWindowEndColor := $0000aaaa;
    _scrollNewMessageStartColor := $0000ffff;
    _scrollNewMessageEndColor := $0000aaaa;
    tag := MainSession.Prefs.getXMLPref('activity_window_default_color');
    if (tag <> nil) then begin
        _startColor := TColor(StrToInt(tag.GetFirstTag('start').Data));
        _endColor := TColor(StrToInt(tag.GetFirstTag('end').Data));
         pnlList.GradientProperites.startColor := _startColor;
         pnlList.GradientProperites.endColor := _endColor;
         pnlListBase.GradientProperites.startColor := _startColor;
         pnlListBase.GradientProperites.endColor := _endColor;
    end;
    FreeAndNil(tag);
    tag := MainSession.Prefs.getXMLPref('activity_window_default_color');
    if (tag <> nil) then begin
        _sortDefaultStartColor := TColor(StrToInt(tag.GetFirstTag('start').Data));
        _sortDefaultEndColor := TColor(StrToInt(tag.GetFirstTag('end').Data));
         pnlListSort.GradientProperites.startColor := _sortDefaultStartColor;
         pnlListSort.GradientProperites.endColor := _sortDefaultEndColor;
    end;
    FreeAndNil(tag);
    tag := MainSession.Prefs.getXMLPref('activity_window_default_color');
    if (tag <> nil) then begin
        _scrollDefaultStartColor := TColor(StrToInt(tag.GetFirstTag('start').Data));
        _scrollDefaultEndColor := TColor(StrToInt(tag.GetFirstTag('end').Data));
        pnlListScrollUp.GradientProperites.startColor := _scrollDefaultStartColor;
        pnlListScrollUp.GradientProperites.endColor := _scrollDefaultEndColor;
    end;
    FreeAndNil(tag);
    tag := MainSession.Prefs.getXMLPref('activity_window_high_priority_color');
    if (tag <> nil) then begin
        _scrollPriorityStartColor := TColor(StrToInt(tag.GetFirstTag('start').Data));
        _scrollPriorityEndColor := TColor(StrToInt(tag.GetFirstTag('end').Data));
    end;
    FreeAndNil(tag);
    tag := MainSession.Prefs.getXMLPref('activity_window_new_window_color');
    if (tag <> nil) then begin
        _scrollNewWindowStartColor := TColor(StrToInt(tag.GetFirstTag('start').Data));
        _scrollNewWindowEndColor := TColor(StrToInt(tag.GetFirstTag('end').Data));
    end;
    FreeAndNil(tag);
    tag := MainSession.Prefs.getXMLPref('activity_window_new_message_color');
    if (tag <> nil) then begin
        _scrollNewMessageStartColor := TColor(StrToInt(tag.GetFirstTag('start').Data));
        _scrollNewMessageEndColor := TColor(StrToInt(tag.GetFirstTag('end').Data));
    end;
    FreeAndNil(tag);
    tag := MainSession.Prefs.getXMLPref('activity_window_bevel_color');
    if (tag <> nil) then begin
        _sort_bevel_shadow_color := TColor(StrToInt(tag.GetFirstTag('shadow').Data));
        _sort_bevel_highlight_color := TColor(StrToInt(tag.GetFirstTag('highlight').Data));
        _scrollup_bevel_shadow_color := TColor(StrToInt(tag.GetFirstTag('shadow').Data));
        _scrollup_bevel_highlight_color := TColor(StrToInt(tag.GetFirstTag('highlight').Data));
        _scrolldown_bevel_shadow_color := TColor(StrToInt(tag.GetFirstTag('shadow').Data));
        _scrolldown_bevel_highlight_color := TColor(StrToInt(tag.GetFirstTag('highlight').Data));
        SortSeparatorBar.CustomSeparatorBarProperites.Color1 := _sort_bevel_shadow_color;
        SortSeparatorBar.CustomSeparatorBarProperites.Color2 := _sort_bevel_highlight_color;
        ScrollUpSeparatorBar.CustomSeparatorBarProperites.Color1 := _scrollup_bevel_shadow_color;
        ScrollUpSeparatorBar.CustomSeparatorBarProperites.Color2 := _scrollup_bevel_highlight_color;
        ScrollDownSeparatorBar.CustomSeparatorBarProperites.Color1 := _scrolldown_bevel_shadow_color;
        ScrollDownSeparatorBar.CustomSeparatorBarProperites.Color2 := _scrolldown_bevel_highlight_color;
    end;
    FreeAndNil(tag);

    _FilesDragAndDropEnabled := false;

    _sessionCB := MainSession.RegisterCallback(OnSessionCallback, '/session/activitywindow');
    _doUpdates := true;
end;

{---------------------------------------}
procedure TfrmActivityWindow.FormDestroy(Sender: TObject);
var
    listsort: integer;
begin
    inherited;
    _clearTrackingList();
    _trackingList.Free;
    case _curListSort of
        ssUnsorted: listSort := 0;
        ssAlpha: listSort := 1;
        ssRecent: listSort := 2;
        ssType: listSort := 3;
        ssUnread: listSort := 4;
        else
            listSort := 0;
    end;
    MainSession.Prefs.setInt('activity_window_sort', listSort);

    if (_sessionCB > -1) then
    begin
        MainSession.UnRegisterCallback(_sessionCB);
    end;
end;

{---------------------------------------}
procedure TfrmActivityWindow.mnuAlphaSortClick(Sender: TObject);
begin
    _needToSortList := true;
    _sortTrackingList(ssAlpha);
    _updateDisplay();
end;

{---------------------------------------}
procedure TfrmActivityWindow.mnuAW_CloseAllClick(Sender: TObject);
begin
    inherited;
    _needToSortList := true;
    enableListUpdates(false);
    MainSession.FireEvent('/session/close-all-windows', nil);
    enableListUpdates(true);
end;

{---------------------------------------}
procedure TfrmActivityWindow.mnuAW_DockAllClick(Sender: TObject);
begin
    inherited;
    _needToSortList := true;
    enableListUpdates(false);
    MainSession.FireEvent('/session/dock-all-windows', nil);
    enableListUpdates(true);
end;

{---------------------------------------}
procedure TfrmActivityWindow.mnuAW_FloatAllClick(Sender: TObject);
begin
    inherited;
    _needToSortList := true;
    enableListUpdates(false);
    MainSession.FireEvent('/session/float-all-windows', nil);
    enableListUpdates(true);
end;

{---------------------------------------}
procedure TfrmActivityWindow.mnuRecentSortClick(Sender: TObject);
begin
    _needToSortList := true;
    _sortTrackingList(ssRecent);
    _updateDisplay();
end;

{---------------------------------------}
procedure TfrmActivityWindow.mnuTypeSortClick(Sender: TObject);
begin
    _needToSortList := true;
    _sortTrackingList(ssType);
    _updateDisplay();
end;

{---------------------------------------}
procedure TfrmActivityWindow.mnuUnreadSortClick(Sender: TObject);
begin
    _needToSortList := true;
    _sortTrackingList(ssUnread);
    _updateDisplay();
end;

{---------------------------------------}
procedure TfrmActivityWindow._clearTrackingList();
var
    i: integer;
    item: TAWTrackerItem;
begin
    try
        for i := _trackingList.Count - 1 downto 0 do begin
            item := TAWTrackerItem(_trackingList.Objects[i]);
            if (item <> nil) then begin
                removeItem(item);
            end;
        end;
    except
    end;
end;

{---------------------------------------}
procedure TfrmActivityWindow.removeItem(var item:TAWTrackerItem);
var
    i: integer;
begin
    if (item = nil) then exit;

    _needToSortList := true;

    for i := 0 to _trackingList.Count - 1 do
    begin                                                         
        if (item = TAWTrackerItem(_trackingList.Objects[i])) then begin
            // Change active item
            if (_activeitem = item.awItem) then begin
                _activeitem := nil;
            end;
            if ((_trackingList.Count > 1) and
                (item.frm.Docked)) then begin
                _activateNextDockedItem(i); // This calls _updateData which can change the _trackingList order.
            end;

            break;
        end;
    end;

    // Go through the find process again, because call to _activateNextDockedItem above might have changed list order
    for i := 0 to _trackingList.Count - 1 do
    begin
        if (item = TAWTrackerItem(_trackingList.Objects[i])) then begin
            // Remove from list
            _trackingList.Delete(i);

            // Delete item (this is the item passed in, so it will be invalid after this)
            item.frm := nil;
            item.awItem.Free();
            item.awItem := nil;
            item.Free();
            item := nil;

            // Update list view
            _updateDisplay();

            if (_trackingList.Count <= 0) then begin
                _showingTopItem := -1;
            end;

            break;
        end;
    end;
end;

{---------------------------------------}
function TfrmActivityWindow.addItem(frm:TfrmDockable): TAWTrackerItem;
begin
    Result := findItem(frm);     

    if ((Result = nil) and
        (frm <> nil)) then begin
        _needToSortList := true;

        Result := TAWTrackerItem.Create();
        Result.awItem := TfAWItem.Create(nil);
        Result.frm := frm;
        _trackingList.AddObject(frm.UID, Result);
        Result.awItem.OnClick := Self.onItemClick;

        // Setup item props
        Result.awItem.Visible := false;
        Result.awItem.Parent := pnlList;
        Result.awItem.Align := alNone;
        Result.awItem.Left := ListLeftSpacer.Width;
        Result.awItem.Width := pnlList.Width - ListLeftSpacer.Width - ListRightSpacer.Width;
        Result.awItem.name := frm.Caption;
        if (frm.Hint <> '') then begin
            Result.awItem.Hint := frm.Hint;
        end
        else begin
            Result.awItem.Hint := frm.Caption;
        end;
        Result.awItem.defaultStartColor := pnlList.GradientProperites.startColor;
        Result.awItem.defaultEndColor := pnlList.GradientProperites.endColor;

        if (_showingTopItem < 0) then begin
            _showingTopItem := 0;
        end;

        _updateDisplay();
    end;
end;

{---------------------------------------}
function TfrmActivityWindow.findItem(id:widestring): TAWTrackerItem;
var
    idx: integer;
begin
    Result := nil;

    idx := _trackingList.IndexOf(id);

    if (idx >= 0) then begin
        Result := TAWTrackerItem(_trackingList.Objects[idx]);
    end;
end;

{---------------------------------------}
function TfrmActivityWindow.findItem(frm:TfrmDockable): TAWTrackerItem;
var
    i:integer;
    item: TAWTrackerItem;
begin
    Result := nil;

    for i := 0 to _trackingList.Count - 1 do begin
        item := TAWTrackerItem(_trackingList.Objects[i]);
        if (item.frm = frm) then begin
            Result := item;
            exit;
        end;
    end;
end;

{---------------------------------------}
function TfrmActivityWindow.findItem(awitem: TfAWItem): TAWTrackerItem;
var
    i: integer;
    item: TAWTrackerItem;
begin
    Result := nil;

    for i := 0 to _trackingList.Count - 1 do begin
        item := TAWTrackerItem(_trackingList.Objects[i]);
        if (item.awitem = awitem) then begin
            Result := item;
            exit;
        end;
    end;
end;

{---------------------------------------}
function TfrmActivityWindow.findItem(index: integer): TAWTrackerItem; 
begin
    Result := nil;
    if (index < 0) then exit;
    if (index >= _trackingList.Count) then exit;

    Result := TAWTrackerItem(_trackingList.Objects[index]);     
end;

{---------------------------------------}
function TfrmActivityWindow.findItemIndex(awitem: TfAWItem): integer;
var
    i: integer;
    item: TAWTrackerItem;
begin
    Result := -1;

    for i := 0 to _trackingList.Count - 1 do begin
        item := TAWTrackerItem(_trackingList.Objects[i]);
        if (item.awitem = awitem) then begin
            Result := i;
            exit;
        end;
    end;
end;


{---------------------------------------}
procedure TfrmActivityWindow.DockActivityWindow(dockSite : TWinControl);
begin
    if (dockSite <> Self.Parent) then begin
        //JJF manualdock forces a show of this form, which causes it to activate.
        //changing parents does not. to look good, AW window window must be borderless
        Self.Parent := docksite;
//        Self.ManualDock(dockSite);//, nil, alClient);
///        Application.processMessages();
        Self.Align := alClient;
        _docked := true;
    end;
end;

{---------------------------------------}
procedure TfrmActivityWindow.onItemClick(Sender: TObject);
var
    awitem: TfAWItem;
begin
    if (Sender = nil) then exit;

    try
        awitem := TfAWItem(Sender);
        activateItem(awitem);
    except
    end;
end;

{---------------------------------------}
procedure TfrmActivityWindow.pnlListBaseResize(Sender: TObject);
begin
    // Make sure that the "top" property of the scroll buttons are
    // correct.  VCL built in resize/position code doesn't always
    // get it right.
    pnlListScrollDown.Top := pnlListBase.Height - pnlListScrollDown.Height;
    pnlListScrollUp.Top := pnlListSort.Height;
end;

procedure TfrmActivityWindow.pnlListResize(Sender: TObject);
begin
    inherited;
    imgScrollUp.Left := (pnlListScrollUp.Width div 2) - (imgScrollUp.Width div 2);
    imgScrollDown.Left := (pnlListScrollDown.Width div 2) - (imgScrollDown.Width div 2);
    _updateDisplay();
end;

{---------------------------------------}
procedure TfrmActivityWindow.pnlListScrollDownClick(Sender: TObject);
begin
    if (_canScrollDown) then begin
        Inc(_showingTopItem);
        _updateDisplay();
    end;
end;

{---------------------------------------}
procedure TfrmActivityWindow.pnlListScrollDownMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
    inherited;
    _timerScrollUp := false;
    timScrollTimer.Interval := 250;
    timScrollTimer.Enabled := true;
end;

{---------------------------------------}
procedure TfrmActivityWindow.pnlListScrollDownMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
    inherited;
    timScrollTimer.Enabled := false;
end;

{---------------------------------------}
procedure TfrmActivityWindow.pnlListScrollUpClick(Sender: TObject);
begin
    if (_canScrollUp) then begin
        if (_showingTopItem > 0) then begin
            Dec(_showingTopItem);
        end;
        _updateDisplay();
    end;
end;

{---------------------------------------}
procedure TfrmActivityWindow.pnlListScrollUpMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
    inherited;
    _timerScrollUp := true;
    timScrollTimer.Interval := 250;
    timScrollTimer.Enabled := true;
end;

{---------------------------------------}
procedure TfrmActivityWindow.pnlListScrollUpMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
    inherited;
    timScrollTimer.Enabled := false;
end;

{---------------------------------------}
procedure TfrmActivityWindow.pnlListSortClick(Sender: TObject);
var
    p: TPoint;
begin
    GetCursorPos(p);
    popAWSort.Popup(p.X, p.Y);
end;

{---------------------------------------}
procedure TfrmActivityWindow.activateItem(awitem: TfAWItem);
var
    trackitem: TAWTrackerItem;
    tsheet: TTntTabSheet;
begin
    if (awitem = nil) then exit;

    try
        _needToSortList := true;

        trackitem := _findItem(awitem);

        // Deactivate old item if new item docked
        try
            if ((trackitem.frm.Docked) and
                (_activeitem <> nil)) then begin
                _activeitem.activate(false);
            end;
        except
            _activeitem := nil;
        end;

        // Activate if Docked
        //only change to active colors if msg count = 0 (-1) or will be cleared later
        //prevents new message/new window colors from being overwritten
        if (_dockWindow.Active and trackitem.frm.Docked) or
            trackitem.frm.active or (awitem.count < 1) then begin
            awitem.activate(true, trackitem.frm.Docked);
        end;

        if (trackitem.frm.Docked) then begin
            _activeitem := awitem;
        end;

        if (trackitem.frm.Docked) then begin
            // Docked Window
            tsheet := _dockwindow.getTabSheet(trackitem.frm);
            if (tsheet <> nil) then begin
                try
                    tsheet.Visible := true;
                    _oldActivateSheet := tsheet;
                    //tsheet will get a activated when ActivePage is set if
                    //_dockWindow is active. That fires various aactivastion
                    //events, includign clearing unread messages as needed.
                    //If _dockWindow is not active, activation occurs when
                    //if gets focus later.
                    _dockWindow.AWTabControl.ActivePage := tsheet;
                    _dockWindow.setWindowCaption(trackitem.frm.Caption);
                    scrollToActive();
                except
                end;
            end;
        end
        else begin
            trackitem.frm.ShowDefault(true);
        end;
    except
    end;
end;

{---------------------------------------}
function TfrmActivityWindow._findItem(awitem: TfAWItem): TAWTrackerItem;
var
    item: TAWTrackerItem;
    i: integer;
begin
    Result := nil;
    if (awitem = nil) then exit;

    for i := 0 to _trackingList.Count -1 do begin
        item := TAWTrackerItem(_trackingList.Objects[i]);
        if (item.awItem = awitem) then begin
            Result := item;
            break;
        end;
    end;
end;

{---------------------------------------}
procedure TfrmActivityWindow._sortTrackingList(sortType: TSortState);
var
    sortstring: widestring;
begin
    if (sortType = ssUnsorted) then exit;

    try
        if (_needToSortList) then
        begin
            _curListSort := sortType;

            sortstring := _(sSortBy);

            // Always do an Alpha sort first
            _sortTrackingListAlpha();

            if (sortType = ssAlpha) then begin
                sortstring := sortstring + _(sSortAlpha);
            end
            // Refine sort if something other then Alpha
            else if (sortType = ssRecent) then begin
                sortstring := sortstring + _(sSortRecent);
                _sortTrackingListRecentActivity();
            end
            else if (sortType = ssType) then begin
                // Sort by the type of window (room, chat, etc.), then by alpha for tied items
                sortstring := sortstring + _(sSortType);
                _sortTrackingListType();
            end
            else if (sortType = ssUnread) then begin
                // Sort by Highest Unread msgs
                sortstring := sortstring + _(sSortUnread);
                _sortTrackingListUnread();
            end
            else begin
                // Sort was Alpha which we did above
            end;

            lblSort.Caption := sortstring;

            _needToSortList := false;
        end;
    except
    end;
end;

{---------------------------------------}
procedure TfrmActivityWindow._updateDisplay(allowPartialVisible: boolean);
var
    numSlots: integer;
    i: integer;
    item: TAWTrackerItem;
    slotsFilled: integer;
    remainder: integer;
begin
    if (_doUpdates) then
    begin
        _sortTrackingList(_curListSort);
        try
            if (_trackingList.Count > 0) then begin
                // Compute the maximum showing items
                numSlots := pnlList.Height div TAWTrackerItem(_trackingList.Objects[0]).awItem.Height;
                remainder := pnlList.Height mod TAWTrackerItem(_trackingList.Objects[0]).awItem.Height;
                slotsFilled := 0;

                // See if current showing top item needs to be changed so maximum number
                // of items are visible
                if (_showingTopItem > 0) then begin
                    if ((_trackingList.Count - _showingTopItem + 1) < numSlots) then begin
                        // We can show more so change top showing
                        _showingTopItem := _trackingList.Count - numSlots + 1;
                    end;
                end;

                // Crawl list to see what needs displayed
                if (_canScrollUp) then begin
                    _scrollUpState := ssEnabled;
                end
                else begin
                    _scrollUpState := ssDisabled;
                end;
                if (_canScrollDown) then begin
                    _scrollDownState := ssEnabled;
                end
                else begin
                    _scrollDownState := ssDisabled;
                end;

                for i := 0 to _trackingList.Count - 1 do begin
                    item := TAWTrackerItem(_trackingList.Objects[i]);
                    if (i < _showingTopItem) then begin
                        // Off the top of the viewable list
                        item.awItem.Visible := false;
                        if ((item.awItem.priority) and
                            (_scrollUpState < ssPriority)) then begin
                            _scrollUpState := ssPriority;
                        end;
                        if ((item.awItem.newWindowHighlight) and
                            (_scrollUpState < ssNewWindow)) then begin
                            _scrollUpState := ssNewWindow;
                        end;
                        if ((item.awItem.newMessageHighlight) and
                            (_scrollUpState < ssNewMessage)) then begin
                            _scrollUpState := ssNewMessage;
                        end;
                        _enableScrollUp(true);
                    end
                    else if (slotsFilled >= numSlots) then begin
                        // Off the bottom of the viewable list
                        item.awItem.Visible := false;
                        if ((item.awItem.priority) and
                            (_scrollDownState < ssPriority)) then begin
                            _scrollDownState := ssPriority;
                        end;
                        if ((item.awItem.newWindowHighlight) and
                            (_scrollDownState < ssNewWindow)) then begin
                            _scrollDownState := ssNewWindow;
                        end;
                        if ((item.awItem.newMessageHighlight) and
                            (_scrollDownState < ssNewMessage)) then begin
                            _scrollDownState := ssNewMessage;
                        end;
                        _enableScrollDown(true);

                        if ((slotsFilled = numSlots) and
                            (remainder > 0) and
                            (allowPartialVisible)) then begin
                            // we are off the bottom, so we showed the
                            // scroll, but still want to show partial item
                            item.awItem.Left := ListLeftSpacer.Width;
                            item.awItem.Width := pnlList.Width - ListLeftSpacer.Width - ListRightSpacer.Width;
                            item.awItem.Top := item.awItem.Height * slotsFilled;
                            item.awItem.Visible := true;
                            Inc(slotsFilled);
                        end;
                    end
                    else begin
                        // Is in visible part of list
                        item.awItem.Left := ListLeftSpacer.Width;
                        item.awItem.Width := pnlList.Width - ListLeftSpacer.Width - ListRightSpacer.Width;
                        item.awItem.Top := item.awItem.Height * slotsFilled;
                        item.awItem.Visible := true;
                        Inc(slotsFilled);
                    end;
                end;

                // Change scroll state
                _setScrollUpColor();
                _setScrollDownColor();

                // Disable scroll buttons if not needed
                if (_showingTopItem <= 0) then begin
                    // At top of list
                    _enableScrollUp(false);
                end;
                if ((TAWTrackerItem(_trackingList.Objects[_trackingList.Count - 1]).awItem.Visible) and
                    ((TAWTrackerItem(_trackingList.Objects[_trackingList.Count - 1]).awItem.Top +
                     TAWTrackerItem(_trackingList.Objects[_trackingList.Count - 1]).awItem.Height) <= pnlList.Height)) then begin
                    // At bottom of list AND bottom element is fully visible (not partial)
                    _enableScrollDown(false);
                end;
            end
            else begin
                _enableScrollUp(false);
                _enableScrollDown(false);
            end;

            _forceSyncOfDockedPanel();
        except
        end;
    end;
end;

{---------------------------------------}
procedure TfrmActivityWindow._activateNextDockedItem(curitemindx: integer);
var
    newActiveItem: TAWTrackerItem;
    i: integer;
begin
    if (curitemindx < 0) then exit;
    if (curitemindx > (_trackingList.Count - 1)) then exit;
    if (_trackingList.Count = 0) then exit;

    try
        newActiveItem := nil;

        // Seach "down" in list for next docked item.
        i := curitemindx + 1;
        while (i < _trackingList.Count) do begin
            newActiveItem := TAWTrackerItem(_trackingList.Objects[i]);
            if (newActiveItem.frm.Docked) then begin
                break;
            end
            else begin
                newActiveItem := nil;
            end;
            Inc(i);
        end;

        // If nothing docked found, then search "up" list
        if (newActiveItem = nil) then begin
            i := curitemindx - 1;
            while (i >= 0) do begin
                newActiveItem := TAWTrackerItem(_trackingList.Objects[i]);
                if (newActiveItem.frm.Docked) then begin
                    break;
                end
                else begin
                    newActiveItem := nil;
                end;
                Dec(i);
            end;
        end;

        if (newActiveItem <> nil) then begin
            // Got an item, so activate it
            //OnItemClick(newactiveitem.awItem);
            activateItem(newactiveitem.awItem);
        end
        else begin
            // Deactivate all items
            TAWTrackerItem(_trackingList.Objects[curitemindx]).awItem.activate(false);

            // Set title bar to Generalized caption
            _dockWindow.setWindowCaption('');
        end;
    except
    end;
end;

{---------------------------------------}
procedure TfrmActivityWindow.scrollToActive();
var
    i: integer;
    idx: integer;
    numslots: integer;
    tempitem: TAWTrackerItem;
begin
    if (_activeitem = nil) then exit; // No active item

    if (_doUpdates) then
    begin
        _needToSortList := true;

        _updateDisplay(false); // don't want a partial at this instant

        if (_activeitem.Visible) then exit; // Active item is visible

        // Find where the item is in the tracking list
        idx := -1;
        tempitem := nil;
        for i := 0 to _trackingList.Count - 1 do begin
            tempitem := TAWTrackerItem(_trackingList.Objects[i]);
            if (tempitem.awItem = _activeitem) then begin
                idx := i;
                break;
            end;
        end;

        if ((idx >= 0) and
            (tempitem <> nil)) then begin
            if (idx < _showingTopItem) then begin
                // Item is above current visible
                _showingTopItem := idx;
            end
            else begin
                // Item is below current visible
                numSlots := pnlList.Height div tempitem.awItem.Height;
                if (numSlots > 0) then begin
                    _showingTopItem := idx - numSlots + 1;
                end;
            end;
        end;

        _updateDisplay(); // partials are fine now.
    end;
end;

{---------------------------------------}
procedure TfrmActivityWindow._enableScrollUp(doenable: boolean);
begin
    _canScrollUp := doenable;
    pnlListScrollUp.Visible := doenable;

    if (doenable) then begin
        if (_scrollUpState = ssDisabled) then begin
            _scrollUpState := ssEnabled;
        end;
    end
    else begin
        _scrollUpState := ssDisabled;
    end;

    _setScrollUpColor();
end;

{---------------------------------------}
procedure TfrmActivityWindow._enableScrollDown(doenable: boolean);
begin
    _canScrollDown := doenable;
    pnlListScrollDown.Visible := doenable;

    if (doenable) then begin
        if (_scrollDownState = ssDisabled) then begin
            _scrollDownState := ssEnabled;
        end;
    end
    else begin
        _scrollDownState := ssDisabled;
    end;
    _setScrollDownColor();
end;

{---------------------------------------}
procedure TfrmActivityWindow.setDockingSpacers(dockstate: TDockStates);
begin
    case dockstate of
        dsUnDocked: begin
            ListRightSpacer.Width := 10;
            pnlBorderTop.Height := 0;
            pnlBorderBottom.Height := 0;
        end;
        dsDocked: begin
            ListRightSpacer.Width := 0;
            pnlBorderTop.Height := 10;
            pnlBorderBottom.Height := 10;
        end;
        dsUninitialized: begin
            ListRightSpacer.Width := 10;
            pnlBorderTop.Height := 0;
            pnlBorderBottom.Height := 0;
        end;
    end;

    _updateDisplay();
end;

{---------------------------------------}
procedure TfrmActivityWindow.timScrollTimerTimer(Sender: TObject);
begin
    inherited;
    timScrollTimer.Interval := 100;
    if (_timerScrollUp) then begin
        if (_canScrollUp) then begin
            if (_showingTopItem > 0) then begin
                Dec(_showingTopItem);
            end;
            _updateDisplay();
        end;
    end
    else begin
        if (_canScrollDown) then begin
            Inc(_showingTopItem);
            _updateDisplay();
        end;
    end;
end;

{---------------------------------------}
procedure TfrmActivityWindow.timShowActiveDockedTimer(Sender: TObject);
begin
    inherited;

    try
        // This timer has to be here because there are cases where
        // with the TPageControl sometimes, will not show the correct
        // sheet.  Why TPageControl insists on showing its own choice of
        // sheet even after being told what sheet to show is a
        // bit of mystery.  Future refactor to remove
        // TPageControl Completely should solve this issue.
        _forceSyncOfDockedPanel();
    except
    end;
end;

{---------------------------------------}
procedure TfrmActivityWindow.imgShowRosterClick(Sender: TObject);
begin
    frmExodus.BringToFront();
end;

{---------------------------------------}
procedure TfrmActivityWindow.itemChangeUpdate(const item: TAWTrackerItem);
begin
    if (item.frm <> nil) then
    begin
        if ((_curListSort = ssRecent) and
            (item.frm.LastActivity > _lastListActivity)) then
        begin
            _needToSortList := true;
        end;
        if ((_curListSort = ssUnread) and
            (item.frm.LastActivity > _lastListActivity)) then
        begin
            _needToSortList := true;
        end;
    end;

    _updateDisplay();
end;

{---------------------------------------}
procedure TfrmActivityWindow._setScrollUpColor();
    procedure setcolor(startcolor, endcolor: TColor);
    begin
        if ((pnlListScrollUp.GradientProperites.startColor <> startcolor) or
            (pnlListScrollUp.GradientProperites.endColor <> endcolor)) then
        begin
            pnlListScrollUp.GradientProperites.startColor := startcolor;
            pnlListScrollUp.GradientProperites.endColor := endcolor;
            pnlListScrollUp.Invalidate();
        end;
    end;
begin
    case _scrollUpState of
        ssDisabled: begin
            setcolor(_scrollDefaultStartColor, _scrollDefaultEndColor);
        end;
        ssEnabled: begin
            setcolor(_scrollEnabledStartColor, _scrollEnabledEndColor);
        end;
        ssPriority: begin
            setcolor(_scrollPriorityStartColor, _scrollPriorityEndColor);
        end;
        ssNewWindow: begin
            setcolor(_scrollNewWindowStartColor, _scrollNewWindowEndColor);
        end;
        ssNewMessage: begin
            setcolor(_scrollNewMessageStartColor, _scrollNewMessageEndColor);
        end;
    end;
end;

{---------------------------------------}
procedure TfrmActivityWindow._setScrollDownColor();
    procedure setcolor(startcolor, endcolor: TColor);
    begin
        if ((pnlListScrollDown.GradientProperites.startColor <> startcolor) or
            (pnlListScrollDown.GradientProperites.endColor <> endcolor)) then
        begin
            pnlListScrollDown.GradientProperites.startColor := startcolor;
            pnlListScrollDown.GradientProperites.endColor := endcolor;
            pnlListScrollDown.Invalidate();
        end;
    end;
begin
    case _scrollDownState of
        ssDisabled: begin
            setColor(_scrollDefaultStartColor, _scrollDefaultEndColor);
        end;
        ssEnabled: begin
            setColor(_scrollEnabledStartColor, _scrollEnabledEndColor);
        end;
        ssPriority: begin
            setColor(_scrollPriorityStartColor, _scrollPriorityEndColor);
        end;
        ssNewWindow: begin
            setColor(_scrollNewWindowStartColor, _scrollNewWindowEndColor);
        end;
        ssNewMessage: begin
            setColor(_scrollNewMessageStartColor, _scrollNewMessageEndColor);
        end;
    end;
end;

{---------------------------------------}
procedure TfrmActivityWindow.selectNextItem();
var
    i:integer;
    item: TAWTrackerItem;
begin
    try
        _needToSortList := true;
        // Scan through list to find active item.
        for i := 0 to _trackingList.Count - 1 do begin
            item := TAWTrackerItem(_trackingList.Objects[i]);
            if (item <> nil) then begin
                if (item.awItem.active) then begin
                    if ((i + 1) < _trackingList.Count) then begin
                        // Not last item in list
                        item := TAWTrackerItem(_trackingList.Objects[i + 1]);
                        if (item <> nil) then begin
                            activateItem(item.awItem);
                        end;
                    end
                    else begin
                        // Must be last item in list, go to first item.
                        item := TAWTrackerItem(_trackingList.Objects[0]);
                        if (item <> nil) then begin
                            activateItem(item.awItem);
                        end;
                    end;
                    break;
                end;
            end;
        end;
    except
    end;
end;

{---------------------------------------}
procedure TfrmActivityWindow.selectPrevItem();
var
    i:integer;
    item: TAWTrackerItem;
begin
    try
        _needToSortList := true;
        // Scan through list to find active item.
        if (_trackingList.Count > 1) then begin
            for i := 0 to _trackingList.Count - 1 do begin
                item := TAWTrackerItem(_trackingList.Objects[i]);
                if (item <> nil) then begin
                    if (item.awItem.active) then begin
                        if (i > 0) then begin
                            // Not the first item, so just activate previous
                            item := TAWTrackerItem(_trackingList.Objects[i - 1]);
                            if (item <> nil) then begin
                                activateItem(item.awItem);
                            end
                        end
                        else begin
                            // First item, so activate last item in list
                            item := TAWTrackerItem(_trackingList.Objects[_trackingList.Count - 1]);
                            if (item <> nil) then begin
                                activateItem(item.awItem);
                            end;
                        end;
                        break;
                    end;
                end;
            end;
        end;
    except
    end;
end;

{---------------------------------------}
function TfrmActivityWindow._getItemCount(): integer;
begin
    Result := _trackingList.Count;
end;

{---------------------------------------}
procedure TfrmActivityWindow.SetItemName(awitem: TfAWItem; name: widestring; itemhint: widestring);
var
    idx: integer;
    trackeritem: TAWTrackerItem;
begin
    if (awitem = nil) then exit;
    if (name = '') then exit;

    if ((name = awitem.name) and (itemhint = awitem.hint)) then exit;    

    _needToSortList := true;

    idx := findItemIndex(awitem);
    if (idx >= 0) then begin
        trackeritem := TAWTrackerItem(_trackingList.Objects[idx]);
        if (trackeritem <> nil) then begin
            trackeritem.awItem.name := name;
            if (itemhint <> '') then begin
                trackeritem.awItem.hint := itemhint;
            end
            else begin
                trackeritem.awItem.hint := name;
            end;
        end;
    end;     
end;

{---------------------------------------}
procedure TfrmActivityWindow._sortTrackingListRecentActivity();
var
    tempitem1: TAWTrackerItem;
    i: Integer;
    itemadded: Boolean;
    j: Integer;
    insertPoint: Integer;
    tempitem2: TAWTrackerItem;
    tempList: TWideStringList;
begin
    // Sort by most Recent Activity, then by alpha for tied items
    templist := TWidestringList.Create();

    for i := 0 to _trackingList.Count - 1 do
    begin
        // iterate over list to reorder
        itemadded := false;
        tempitem1 := TAWTrackerItem(_trackingList.Objects[i]);
        if (tempitem1 <> nil) then
        begin
            for j := 0 to tempList.Count - 1 do
            begin
                tempitem2 := TAWTrackerItem(tempList.Objects[j]);
                insertPoint := j;
                if (tempitem1.frm.LastActivity > tempitem2.frm.LastActivity) then
                begin
                    // We have an new item to add to the temp list that should be higher
                    // then the current item in the templist
                    tempList.InsertObject(insertPoint, _trackingList.Strings[i], _trackingList.Objects[i]);
                    itemadded := true;
                    break;
                end;
            end;
        end;

        if (not itemadded) then
        begin
            // We didn't insert the item into the temp list so add to end
            tempList.AddObject(_trackingList.Strings[i], _trackingList.Objects[i]);
        end;
    end;

    _trackingList.Clear;
    _trackingList.Free();
    _trackingList := tempList;

    if (_trackingList.Count > 0) then
    begin
        // grab a hold of most recent activity for redraw performance reasons.
        tempitem1 := TAWTrackerItem(_trackingList.Objects[0]);
        _lastListActivity := tempitem1.frm.LastActivity;
    end;
end;

{---------------------------------------}
procedure TfrmActivityWindow._sortTrackingListType();
var
    permRoomList, adhocRoomList, chatList, otherList: TWidestringList;
    i,j: integer;
    tempitem1, tempitem2: TAWTrackerItem;
    itemadded: boolean;
    templist: TWidestringList;
    insertpoint: integer;
begin
    templist := TWidestringList.Create();
    permRoomList := TWidestringList.Create();
    adhocRoomList := TWidestringList.Create();
    chatList := TWidestringList.Create();
    otherList := TWidestringList.Create();

    // Split them up by group to make sure it is rooms -> chats -> others
    for i := 0 to _trackingList.Count - 1 do begin
        tempitem1 := TAWTrackerItem(_trackingList.Objects[i]);
        if (tempitem1 <> nil) then begin
            if (tempitem1.frm.WindowType ='perm_room') then begin
                permRoomList.AddObject(_trackingList.Strings[i], _trackingList.Objects[i]);
            end
            else if (tempitem1.frm.WindowType ='adhoc_room') then begin
                adhocRoomList.AddObject(_trackingList.Strings[i], _trackingList.Objects[i]);
            end
            else if (tempitem1.frm.WindowType = 'chat') then begin
                chatList.AddObject(_trackingList.Strings[i], _trackingList.Objects[i]);
            end
            else begin
                otherList.AddObject(_trackingList.Strings[i], _trackingList.Objects[i]);
            end;
        end;
    end;

    // Sort others list
    for i := 0 to otherList.Count - 1 do begin
        // iterate over list to reorder
        itemadded := false;
        tempitem1 := TAWTrackerItem(otherList.Objects[i]);
        if (tempitem1 <> nil) then begin
            for j := 0 to tempList.Count - 1 do begin
                tempitem2 := TAWTrackerItem(tempList.Objects[j]);
                insertPoint := j;
                if (tempitem2.frm.WindowType > tempitem1.frm.WindowType) then begin
                    // We have an new item to add to the temp list that should be higher
                    // then the current item in the templist
                    tempList.InsertObject(insertPoint, otherList.Strings[i], otherList.Objects[i]);
                    itemadded := true;
                    break;
                end;
            end;
        end;
        if (not itemadded) then begin
            // We didn't insert the item into the temp list so add to end
            tempList.AddObject(otherList.Strings[i], otherList.Objects[i]);
        end;
    end;

    // Reassemble list
    _trackingList.Clear();

    for i := 0 to permRoomList.Count - 1 do begin
        _trackingList.AddObject(permRoomList.Strings[i], permRoomList.Objects[i]);
    end;
    for i := 0 to adhocRoomList.Count - 1 do begin
        _trackingList.AddObject(adhocRoomList.Strings[i], adhocRoomList.Objects[i]);
    end;
    for i := 0 to chatList.Count - 1 do begin
        _trackingList.AddObject(chatList.Strings[i], chatList.Objects[i]);
    end;
    for i := 0 to tempList.Count - 1 do begin //others
        _trackingList.AddObject(tempList.Strings[i], tempList.Objects[i]);
    end;

    // Cleanup
    permRoomList.Clear();
    adhocRoomList.Clear();
    chatList.Clear();
    otherList.Clear();
    templist.Clear();

    permRoomList.Free();
    adhocRoomList.Free();
    chatList.Free();
    otherList.Free();
    templist.Free();
end;

{---------------------------------------}
procedure TfrmActivityWindow._sortTrackingListUnread();
var
    j: Integer;
    i: Integer;
    tempitem1: TAWTrackerItem;
    itemadded: Boolean;
    tempitem2: TAWTrackerItem;
    tempList: TWideStringList;
begin
    tempList := TWidestringList.Create();
    for i := 0 to _trackingList.Count - 1 do
    begin
        // iterate over list to reorder
        itemadded := false;
        tempitem1 := TAWTrackerItem(_trackingList.Objects[i]);
        if (tempitem1 <> nil) then
        begin
            for j := 0 to tempList.Count - 1 do
            begin
                tempitem2 := TAWTrackerItem(tempList.Objects[j]);
                if (tempitem2.awItem.count < tempitem1.awItem.count) then
                begin
                    // We have an new item to add to the temp list that should be higher
                    // then the current item in the templist
                    tempList.InsertObject(j, _trackingList.Strings[i], _trackingList.Objects[i]);
                    itemadded := true;
                    break;
                end;
            end;
        end;
        if (not itemadded) then
        begin
            // We didn't insert the item into the temp list so add to end
            tempList.AddObject(_trackingList.Strings[i], _trackingList.Objects[i]);
        end;
    end;

    _trackingList.Clear;
    _trackingList.Free();
    _trackingList := tempList;
end;

{---------------------------------------}
procedure TfrmActivityWindow._sortTrackingListAlpha();
var
    i: integer;
    templist: TWidestringList;
    j: Integer;
    itemadded: boolean;
    item1, item2: TAWTrackerItem;
    str1, str2: Widestring;
begin
    templist := TWidestringList.Create();

    for i := 0 to _trackingList.Count - 1 do
    begin
        itemadded := false;
        item1 := TAWTrackerItem(_trackingList.Objects[i]);
        str1 := jabber_nameprep_variablelen(item1.awItem.name);
        for j := 0 to tempList.Count - 1 do
        begin
            item2 := TAWTrackerItem(tempList.Objects[j]);
            if ((item1 <> nil) and
                (item2 <> nil)) then
            begin
                str2 := jabber_nameprep_variablelen(item2.awItem.name);
                if (str1 < str2) then
                begin
                    itemadded := true;
                    tempList.InsertObject(j, _trackingList.Strings[i], _trackingList.Objects[i]);
                    break;
                end;
            end;
        end;

        if (not itemadded) then
        begin
            templist.AddObject(_trackingList.Strings[i], _trackingList.Objects[i]);
        end;
    end;

    _trackingList.Clear;

    for i := 0 to tempList.Count - 1 do
    begin
        _trackingList.AddObject(tempList.Strings[i], tempList.Objects[i]);
    end;

    templist.Free();
end;

{---------------------------------------}
procedure TfrmActivityWindow._setFilesDragAndDrop(Value :Boolean);
begin
    _FilesDragAndDropEnabled := Value;
    DragAcceptFiles(Handle, _FilesDragAndDropEnabled)
end;

{---------------------------------------}
procedure TfrmActivityWindow.onSessionCallback(event: string; tag: TXMLTag);
begin
    if (event = '/session/activitywindow/update') then
    begin
        forceUpdate();
    end
    else if (event = '/session/activitywindow/suspendupdates') then
    begin
        enableListUpdates(false);
    end
    else if (event = '/session/activitywindow/resumeupdates') then
    begin
        enableListUpdates(true);
    end;
end;

{---------------------------------------}
procedure TfrmActivityWindow.forceUpdate();
begin
    // We have been asked to force an update to the list
    _needToSortList := true;
    _updateDisplay();
end;

{---------------------------------------}
procedure TfrmActivityWindow.enableListUpdates(enable: boolean);
begin
    _doUpdates := enable;
    pnlListBase.Enabled := enable;
    if (enable) then
    begin
        Screen.Cursor := crDefault;
        forceUpdate();
    end
    else begin
        Screen.Cursor := crHourglass;
    end;
end;

{---------------------------------------}
procedure TfrmActivityWindow._forceSyncOfDockedPanel();
var
    item: TAWTrackerItem;
    sheet: TTabSheet;
    i: integer;
begin
    if ((_dockWindow <> nil) and
        (_dockWindow.AWTabControl.PageCount > 0)) then
    begin
        if ((_activeitem = nil) and
            (_trackingList.Count > 0)) then
        begin
            for i := 0 to _trackingList.Count - 1 do
            begin
                if (TAWTrackerItem(_trackingList.Objects[0]).frm.Docked) then
                begin
                    activateItem(TAWTrackerItem(_trackingList.Objects[i]).awitem);
                    break;
                end;
            end;
        end;

        item := Self._findItem(_activeitem);

        if (item <> nil) then
        begin
            sheet := _dockWindow.getTabSheet(item.frm);
            if (sheet <> nil) then
            begin
                if (_dockwindow.AWTabControl.ActivePage <> sheet) then
                begin
                    _dockwindow.AWTabControl.ActivePage := sheet;
                end;
            end;
        end;
    end;
end;

{---------------------------------------}
procedure TfrmActivityWindow.closeActiveDockedWindow();
var
    tsheet: TTabSheet;
    frm: TfrmDockable;
begin
    tsheet := _dockwindow.AWTabControl.ActivePage;
    if (tsheet <> nil) then
    begin
        frm := TfrmDockable(_dockwindow.getTabForm(tsheet));
        if (frm <> nil) then
        begin
           frm.Close();
        end;
    end;
end;

initialization
    frmActivityWindow := nil;

end.

