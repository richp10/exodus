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
unit AWItem;



{$ifdef VER150}
    {$define INDY9}
{$endif}

interface

uses
    Unicode,
    Windows,
    SysUtils,
    Classes,
    Controls,
    Forms,
    StdCtrls,
    ComCtrls,
    TntStdCtrls,
    ExtCtrls,
    ExFrame,
    ExGradientPanel,
    Graphics,
    Menus,
    TntMenus,
    ExCustomSeparatorBar;

type
    TfAWItem = class(TExFrame)
    pnlAWItemGPanel: TExGradientPanel;
    lblName: TTntLabel;
    lblCount: TTntLabel;
    imgPresence: TImage;
    RightLBLSpacer: TBevel;
    AWItemPopupMenu: TTntPopupMenu;
    mnuCloseWindow: TTntMenuItem;
    mnuFloatWindow: TTntMenuItem;
    mnuDockWindow: TTntMenuItem;
    FarRightSpacer: TBevel;
    N1: TTntMenuItem;
    mnuAWItem_CloseAll: TTntMenuItem;
    mnuAWItem_DockAll: TTntMenuItem;
    mnuAWItem_FloatAll: TTntMenuItem;
    AWItemSeparatorBar: TExCustomSeparatorBar;
    procedure imgPresenceClick(Sender: TObject);
    procedure lblNameClick(Sender: TObject);
    procedure lblCountClick(Sender: TObject);
    procedure pnlAWItemGPanelClick(Sender: TObject);
    procedure TntFrameClick(Sender: TObject);
    procedure AWItemPopupMenuPopup(Sender: TObject);
    procedure mnuCloseWindowClick(Sender: TObject);
    procedure mnuDockWindowClick(Sender: TObject);
    procedure mnuFloatWindowClick(Sender: TObject);
    procedure mnuAWItem_CloseAllClick(Sender: TObject);
    procedure mnuAWItem_DockAllClick(Sender: TObject);
    procedure mnuAWItem_FloatAllClick(Sender: TObject);
    private
        { Private declarations }
        _count: integer;
        _imgIndex: integer;
        _priorityStartColor: TColor;
        _priorityEndColor: TColor;
        _newWindowStartColor: TColor;
        _newWindowEndColor: TColor;
        _activeStartColor: TColor;
        _activeEndColor: TColor;
        _newMessageStartColor: TColor;
        _newMessageEndColor: TColor;
        _startColor: TColor;
        _endColor: TColor;
        _active: boolean;
        _priority: boolean;
        _newWindowHighlight: boolean;
        _newMessageHighlight: boolean;
        _activity_window_selected_font_color: TColor;
        _activity_window_non_selected_font_color: TColor;
        _activity_window_unread_msgs_font_color: TColor;
        _activity_window_high_priority_font_color: TColor;
        _activity_window_unread_msgs_high_priority_font_color: TColor;
        _activity_window_bevel_shadow_color: TColor;
        _activity_window_bevel_highlight_color: TColor;
        _timNewItemTimer: TTimer;
        _timNewMsgTimer: TTimer;
        _flashcnt: integer;
        _msgflashcnt: integer;
        _LowestUnreadMsgCnt: integer;
        _LowestUnreadMsgCntColorChange: integer;

        procedure _setCount(val:integer);
        function _getName(): widestring;
        procedure _setName(val:widestring);
        procedure _setImgIndex(val: integer);
        procedure _setPnlColors(startColor, endColor: TColor);
        procedure _timNewItemTimerTimer(Sender: TObject);
        procedure _timNewMsgTimerTimer(Sender: TObject);
        procedure _stopTimer();
        procedure _stopMsgTimer();
    protected
        { Protected declarations }
    public
        { Public declarations }
        constructor Create(AOwner: TComponent); reintroduce;
        destructor Destroy(); reintroduce;

        procedure activate(setActive:boolean; docked:boolean = true);
        procedure priorityFlag(setPriority:boolean);
        procedure newMessage(setNewMessage:boolean = true);

        property name: WideString read _getName write _setName;
        property count: integer read _count write _setCount;
        property imgIndex: integer read _imgIndex write _setImgIndex;
        property priorityStartColor: TColor read _priorityStartColor write _priorityStartColor;
        property priorityEndColor: TColor read _priorityEndColor write _priorityEndColor;
        property activeStartColor: TColor read _activeStartColor write _activeStartColor;
        property activeEndColor: TColor read _activeEndColor write _activeEndColor;
        property newMessageStartColor: TColor read _newMessageStartColor write _newMessageStartColor;
        property newMessageEndColor: TColor read _newMessageEndColor write _newMessageEndColor;
        property active: boolean read _active;
        property priority: boolean read _priority;
        property defaultStartColor: TColor read _startColor write _startColor;
        property defaultEndColor: TColor read _endColor write _endColor;
        property newWindowHighlight: boolean read _newWindowHighlight;
        property newMessageHighlight: boolean read _newMessageHighlight;
    published
        { published declarations }
    end;

implementation

uses
    Jabber1,
    ActivityWindow,
    Session,
    XMLTag,
    StateForm,
    ExUtils,
    TntSysUtils;


{$R *.dfm}

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
procedure TfAWItem.AWItemPopupMenuPopup(Sender: TObject);
var
    aw: TfrmActivityWindow;
    docked: boolean;
    item: TAWTrackerItem;
begin
    inherited;

    docked := true;
    aw := GetActivityWindow();

    if (aw <> nil) then begin
        item := aw.findItem(self);
        if ((item <> nil) and
            (item.frm <> nil))then begin
            docked := item.frm.Docked;
        end;
    end;

    if (docked) then begin
        mnuDockWindow.Visible := false;
        mnuFloatWindow.Visible := true;
    end
    else begin
        mnuDockWindow.Visible := true;
        mnuFloatWindow.Visible := false;
    end;

end;

{---------------------------------------}
constructor TfAWItem.Create(AOwner: TComponent);
var
    tag: TXMLTag;
    aoEvent: widestring;
begin
    inherited;

    try
        // Set defaults
        _startColor := pnlAWItemGPanel.GradientProperites.startColor;
        _endColor := pnlAWItemGPanel.GradientProperites.endColor;
        _priorityStartColor := $000000ff;
        _priorityEndColor := $000000ff;
        _newWindowStartColor := $0000ffff;
        _newWindowEndColor := $0000aaaa;
        _newMessageStartColor := $0000ffff;
        _newMessageEndColor := $0000aaaa;
        _activeStartColor := $0000ff00;
        _activeEndColor := $0000ff00;
        _activity_window_selected_font_color := $00000000;
        _activity_window_non_selected_font_color := $00000000;
        _activity_window_unread_msgs_font_color := $000000ff;
        _activity_window_high_priority_font_color := $00000000;
        _activity_window_unread_msgs_high_priority_font_color := $00000000;
        _activity_window_bevel_shadow_color := AWItemSeparatorBar.CustomSeparatorBarProperites.Color1;
        _activity_window_bevel_highlight_color := AWItemSeparatorBar.CustomSeparatorBarProperites.Color2;
        _LowestUnreadMsgCnt := 0;
        _LowestUnreadMsgCntColorChange := 1;

        // Set from prefs
        tag := MainSession.Prefs.getXMLPref('activity_window_default_color');
        if (tag <> nil) then begin
            _startColor := TColor(StrToInt(tag.GetFirstTag('start').Data));
            _endColor := TColor(StrToInt(tag.GetFirstTag('end').Data));
            pnlAWItemGPanel.GradientProperites.startColor := _startColor;
            pnlAWItemGPanel.GradientProperites.endColor := _endColor;
        end;
        FreeAndNil(tag);
        tag := MainSession.Prefs.getXMLPref('activity_window_selected_color');
        if (tag <> nil) then begin
            _activeStartColor := TColor(StrToInt(tag.GetFirstTag('start').Data));
            _activeEndColor := TColor(StrToInt(tag.GetFirstTag('end').Data));
        end;
        FreeAndNil(tag);
        tag := MainSession.Prefs.getXMLPref('activity_window_high_priority_color');
        if (tag <> nil) then begin
            _priorityStartColor := TColor(StrToInt(tag.GetFirstTag('start').Data));
            _priorityEndColor := TColor(StrToInt(tag.GetFirstTag('end').Data));
        end;
        FreeAndNil(tag);
        tag := MainSession.Prefs.getXMLPref('activity_window_new_window_color');
        if (tag <> nil) then begin
            _newWindowStartColor := TColor(StrToInt(tag.GetFirstTag('start').Data));
            _newWindowEndColor := TColor(StrToInt(tag.GetFirstTag('end').Data));
        end;
        FreeAndNil(tag);
        tag := MainSession.Prefs.getXMLPref('activity_window_bevel_color');
        if (tag <> nil) then begin
            _activity_window_bevel_shadow_color := TColor(StrToInt(tag.GetFirstTag('shadow').Data));
            _activity_window_bevel_highlight_color := TColor(StrToInt(tag.GetFirstTag('highlight').Data));
            AWItemSeparatorBar.CustomSeparatorBarProperites.Color1 := _activity_window_bevel_shadow_color;
            AWItemSeparatorBar.CustomSeparatorBarProperites.Color2 := _activity_window_bevel_highlight_color;
        end;
        FreeAndNil(tag);
        tag := MainSession.Prefs.getXMLPref('activity_window_new_message_color');
        if (tag <> nil) then begin
            _newMessageStartColor := TColor(StrToInt(tag.GetFirstTag('start').Data));
            _newMessageEndColor := TColor(StrToInt(tag.GetFirstTag('end').Data));
        end;
        FreeAndNil(tag);

        _activity_window_selected_font_color := TColor(MainSession.Prefs.GetInt('activity_window_non_selected_font_color'));
        _activity_window_non_selected_font_color := TColor(MainSession.Prefs.GetInt('activity_window_selected_font_color'));
        _activity_window_unread_msgs_font_color := TColor(MainSession.Prefs.GetInt('activity_window_unread_msgs_font_color'));
        _activity_window_high_priority_font_color := TColor(MainSession.Prefs.GetInt('activity_window_high_priority_font_color'));
        _activity_window_unread_msgs_high_priority_font_color := TColor(MainSession.Prefs.GetInt('activity_window_unread_msgs_high_priority_font_color'));

        _LowestUnreadMsgCnt := Mainsession.Prefs.getInt('lowest_unread_msg_cnt');
        _LowestUnreadMsgCntColorChange := Mainsession.Prefs.getInt('lowest_unread_msg_cnt_color_change');

        // Set timer for new window notification
        aoEvent := TAutoOpenEventManager.GetAutoOpenEvent();
        if ((aoEvent <> AOE_STARTUP) and (aoEvent <> AOE_AUTHED)) then begin
            _timNewItemTimer := TTimer.Create(Self);
            if (_timNewItemTimer <> nil) then begin
                _timNewItemTimer.Enabled := true;
                _timNewItemTimer.Interval := 500;
                _timNewItemTimer.OnTimer := _timNewItemTimerTimer;
                _flashcnt := 0;
                _newWindowHighlight := true;
            end;
            _timNewMsgTimer := TTimer.Create(Self);
        end
        else begin
            _timNewItemTimer := nil;
        end;

        if (_timNewMsgTimer <> nil) then begin
            _timNewMsgTimer.Enabled := false;
            _timNewMsgTimer.Interval := 500;
            _timNewMsgTimer.OnTimer := _timNewMsgTimerTimer;
            _msgflashcnt := 0;
        end;

        AssignUnicodeFont(lblCount.Font);
        AssignUnicodeFont(lblName.Font);

        if (_count < _LowestUnreadMsgCnt) then
        begin
            // Make sure count is not showing if it
            // isn't supposed to.
            lblCount.Caption := ' ';
        end;
    except
    end;
end;

{---------------------------------------}
destructor TfAWItem.Destroy();
begin
    if (_timNewItemTimer <> nil) then begin
        _timNewItemTimer.Enabled := false;
    end;

    if (_timNewMsgTimer <> nil) then begin
        _timNewMsgTimer.Enabled := false;
    end;

    _timNewItemTimer.Free;
    _timNewMsgTimer.Free;
end;

{---------------------------------------}
procedure TfAWItem._timNewItemTimerTimer(Sender: TObject);
begin
    Inc(_flashcnt);
    if (_flashcnt >= 6) then begin
        if (priority) then begin
            _setPnlColors(_priorityStartColor, _priorityEndColor);
        end
        else begin
            _setPnlColors(_newWindowStartColor, _newWindowEndColor);
        end;
        _stopTimer();
    end
    else begin
        if ((_flashcnt mod 2) = 0) then begin
            if (priority) then begin
                _setPnlColors(_priorityStartColor, _priorityEndColor);
            end
            else begin
                _setPnlColors(_newWindowStartColor, _newWindowEndColor);
            end;
        end
        else begin
            if (Self._active) then begin
                _setPnlColors(_activeStartColor, _activeEndColor);
            end
            else begin
                _setPnlColors(_startColor, _endColor);
            end;
        end;
    end;
end;

{---------------------------------------}
procedure TfAWItem._timNewMsgTimerTimer(Sender: TObject);
begin
    Inc(_msgflashcnt);
    if (_msgflashcnt >= 6) then begin
        if (priority) then begin
            _setPnlColors(_priorityStartColor, _priorityEndColor);
        end
        else begin
            _setPnlColors(_newMessageStartColor, _newMessageEndColor);
        end;
        _stopMsgTimer();
    end
    else begin
        if ((_msgflashcnt mod 2) = 0) then begin
            if (priority) then begin
                _setPnlColors(_priorityStartColor, _priorityEndColor);
            end
            else begin
                _setPnlColors(_newMessageStartColor, _newMessageEndColor);
            end;
        end
        else begin
            if (Self._active) then begin
                _setPnlColors(_activeStartColor, _activeEndColor);
            end
            else begin
                _setPnlColors(_startColor, _endColor);
            end;
        end;
    end;
end;

{---------------------------------------}
procedure TfAWItem._stopTimer();
begin
    if (_timNewItemTimer <> nil) then begin
        _timNewItemTimer.Enabled := false;
        _timNewItemTimer.Free();
        _timNewItemTimer := nil;
    end;
end;

{---------------------------------------}
procedure TfAWItem._stopMsgTimer();
begin
    if (_timNewMsgTimer <> nil) then begin
        _timNewMsgTimer.Enabled := false;
    end;
end;

{---------------------------------------}
procedure TfAWItem._setCount(val:integer);
begin
    _count := val;
    if (_count >= _LowestUnreadMsgCnt) then begin
        lblCount.Caption := IntToStr(_count);
        if (_count >= _LowestUnreadMsgCntColorChange) then begin
            if (_priority) then begin
                if (lblCount.Font.Color <> _activity_window_unread_msgs_high_priority_font_color) then
                begin
                    lblCount.Font.Color := _activity_window_unread_msgs_high_priority_font_color;
                end;
            end
            else begin
                if (lblCount.Font.Color <> _activity_window_unread_msgs_font_color) then
                begin
                    lblCount.Font.Color := _activity_window_unread_msgs_font_color;
                end;
            end;
            lblCount.Font.Style := lblCount.Font.Style + [fsBold];
        end
        else begin
            if (_active) then begin
                if (lblCount.Font.Color <> _activity_window_selected_font_color) then
                begin
                    lblCount.Font.Color := _activity_window_selected_font_color;
                end;
            end
            else begin
                if (lblCount.Font.Color <> _activity_window_non_selected_font_color) then
                begin
                    lblCount.Font.Color := _activity_window_non_selected_font_color;
                end;
            end;
            lblCount.Font.Style := lblCount.Font.Style - [fsBold];
        end;
    end
    else begin
        // Count < 0, thus hide count indicator
        lblCount.Caption := ' ';
    end;
end;

{---------------------------------------}
procedure TfAWItem.imgPresenceClick(Sender: TObject);
begin
    inherited;
    Self.OnClick(Self);
end;

{---------------------------------------}
procedure TfAWItem.lblCountClick(Sender: TObject);
begin
    inherited;
    Self.OnClick(Self);
end;

{---------------------------------------}
procedure TfAWItem.lblNameClick(Sender: TObject);
begin
    inherited;
    Self.OnClick(Self);
end;

{---------------------------------------}
procedure TfAWItem.mnuAWItem_CloseAllClick(Sender: TObject);
begin
    inherited;
    GetActivityWindow().enableListUpdates(false);
    MainSession.FireEvent('/session/close-all-windows', nil);
    GetActivityWindow().enableListUpdates(true);
end;

{---------------------------------------}
procedure TfAWItem.mnuAWItem_DockAllClick(Sender: TObject);
begin
    inherited;
    GetActivityWindow().enableListUpdates(false);
    MainSession.FireEvent('/session/dock-all-windows', nil);
    GetActivityWindow().enableListUpdates(true);
end;

{---------------------------------------}
procedure TfAWItem.mnuAWItem_FloatAllClick(Sender: TObject);
begin
    inherited;
    GetActivityWindow().enableListUpdates(false);
    MainSession.FireEvent('/session/float-all-windows', nil);
    GetActivityWindow().enableListUpdates(true);
end;

{---------------------------------------}
procedure TfAWItem.mnuCloseWindowClick(Sender: TObject);
var
    aw: TfrmActivityWindow;
    item: TAWTrackerItem;
begin
    inherited;

    aw := GetActivityWindow();

    if (aw <> nil) then begin
        item := aw.findItem(self);
        if (item <> nil) then begin
            item.frm.Close();
        end;
    end;
end;

{---------------------------------------}
procedure TfAWItem.mnuDockWindowClick(Sender: TObject);
var
    aw: TfrmActivityWindow;
    item: TAWTrackerItem;
begin
    inherited;

    aw := GetActivityWindow();

    if (aw <> nil) then begin
        item := aw.findItem(self);
        if (item <> nil) then begin
            item.frm.DockForm();
            aw.activateItem(Self);
        end;
    end;
end;

{---------------------------------------}
procedure TfAWItem.mnuFloatWindowClick(Sender: TObject);
var
    aw: TfrmActivityWindow;
    item: TAWTrackerItem;
begin
    inherited;

    aw := GetActivityWindow();

    if (aw <> nil) then begin
        item := aw.findItem(self);
        if (item <> nil) then begin
            item.frm.FloatForm();
            aw.activateItem(Self);
        end;
    end;
end;

{---------------------------------------}
function TfAWItem._getName(): widestring;
begin
    Result := lblName.Caption;
end;

{---------------------------------------}
procedure TfAWItem._setName(val:widestring);
begin
    if (val <> lblName.Caption) then
    begin
        lblName.Caption := val;
    end;
end;

{---------------------------------------}
procedure TfAWItem._setImgIndex(val: Integer);
begin
    if ((val >= 0) and
        (val < frmExodus.ImageList1.Count)) then
    begin
        _imgIndex := val;
        frmExodus.ImageList1.GetIcon(_imgIndex, imgPresence.Picture.Icon);
    end;
end;

{---------------------------------------}
procedure TfAWItem.activate(setActive: boolean; docked: boolean);
begin
    _active := setActive;
    if (setActive) then begin
        _newWindowHighlight := false;
        _newMessageHighlight := false;
        _priority := false;
        _stopTimer();
        _stopMsgTimer();
        if (docked) then begin
            _setPnlColors(_activeStartColor, _activeEndColor);
            lblName.Font.Color := _activity_window_selected_font_color;
            lblCount.Font.Color := _activity_window_selected_font_color;
        end
        else begin
            _setPnlColors(_startColor, _endColor);
            lblName.Font.Color := _activity_window_non_selected_font_color;
            lblCount.Font.Color := _activity_window_non_selected_font_color;
        end;
    end
    else begin
        if (_count >= _LowestUnreadMsgCntColorChange) then begin
            // We still have unread messages
            if (_priority) then begin
                if (lblCount.Font.Color <> _activity_window_unread_msgs_high_priority_font_color) then
                begin
                    lblCount.Font.Color := _activity_window_unread_msgs_high_priority_font_color;
                end;
                _setPnlColors(_priorityStartColor, _priorityEndColor);
            end
            else begin
                if (lblCount.Font.Color <> _activity_window_unread_msgs_font_color) then
                begin
                    lblCount.Font.Color := _activity_window_unread_msgs_font_color;
                end;
                _setPnlColors(_newMessageStartColor, _newMessageEndColor);
            end;
            lblCount.Font.Style := lblCount.Font.Style + [fsBold];
        end
        else begin
            // No unread messages
            _setPnlColors(_startColor, _endColor);
            lblName.Font.Color := _activity_window_non_selected_font_color;
            lblCount.Font.Color := _activity_window_non_selected_font_color;
        end;
    end;
end;

{---------------------------------------}
procedure TfAWItem.pnlAWItemGPanelClick(Sender: TObject);
begin
    inherited;
    Self.OnClick(Self);
end;

{---------------------------------------}
procedure TfAWItem.priorityFlag(setPriority:boolean);
begin
    _priority := setPriority;
    if (setPriority) then begin
        _setPnlColors(_priorityStartColor, _priorityEndColor);
        if (lblName.Font.Color <> _activity_window_high_priority_font_color) then
        begin
            lblName.Font.Color := _activity_window_high_priority_font_color;
        end;
    end
    else begin
        if ((pnlAWItemGPanel.GradientProperites.startColor = _priorityStartColor) and
            (pnlAWItemGPanel.GradientProperites.startColor = _priorityStartColor)) then begin
            // This clears out Priority color only if it is showing
            // If the color is something else (like the selected color, then
            // color will be left alone.
            _setPnlColors(_startColor, _endColor);
        end;
    end;
end;

{---------------------------------------}
procedure TfAWItem.newMessage(setNewMessage:boolean);
begin
    _newMessageHighlight := setNewMessage;
    if ((not _newWindowHighlight) and
        (not _priority)) then begin
        if (setNewMessage) then begin
            _setPnlColors(_newMessageStartColor, _newMessageEndColor);
            if (_timNewMsgTimer <> nil) then begin
                _timNewMsgTimer.Enabled := true;
                _msgflashcnt := 0;
            end;
        end
        else begin
            if ((pnlAWItemGPanel.GradientProperites.startColor = _newMessageStartColor) and
                (pnlAWItemGPanel.GradientProperites.startColor = _newMessageStartColor)) then begin
                // This clears out new message color only if it is showing
                // If the color is something else (like the selected color, then
                // color will be left alone.
                _setPnlColors(_startColor, _endColor);
            end;
        end;
    end;
end;

{---------------------------------------}
procedure TfAWItem.TntFrameClick(Sender: TObject);
begin
    inherited;
    Self.OnClick(Self);
end;

{---------------------------------------}
procedure TfAWItem._setPnlColors(startColor, endColor: TColor);
begin
    if ((pnlAWItemGPanel.GradientProperites.startColor <> startColor) or
         (pnlAWItemGPanel.GradientProperites.endColor <> endColor)) then
    begin
        // only change color when needed to reduce redraw time.
        pnlAWItemGPanel.GradientProperites.startColor := startColor;
        pnlAWItemGPanel.GradientProperites.endColor := endColor;
        pnlAWItemGPanel.Invalidate;
    end;
end;


end.
