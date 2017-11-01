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
unit ExItemHoverForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExForm, Exodus_TLB, ExtCtrls, ExBrandPanel, ExGroupBox, StdCtrls,
  TntStdCtrls, Menus, TntMenus, AppEvnts, ExContactHoverFrame, ExRoomHoverFrame,
  Exframe, ExHoverFrame;

type
  TExItemHoverForm = class(TExForm)
    HoverHide: TTimer;
    HoverReenter: TTimer;
    procedure TntFormMouseLeave(Sender: TObject);
    procedure HoverHideTimer(Sender: TObject);
    procedure TntFormMouseEnter(Sender: TObject);
    procedure HoverReenterTimer(Sender: TObject);
    procedure TntFormCreate(Sender: TObject);
    procedure TntFormDestroy(Sender: TObject);
  private
    { Private declarations }
     _ContactFrame: TExContactHoverFrame;
     _RoomFrame: TExRoomHoverFrame;
     _CurrentFrame: TExFrame;
     _OldWndProc: TWndMethod;
     _AXHover: IExodusHover;
     _Item: IExodusItem;
     procedure _NewWndProc(var Message: TMessage);
     procedure _WMSysCommand(var msg: TWmSysCommand); message WM_SYSCOMMAND;
     procedure _CalcHoverPosition(Point: TPoint);
     function _InitControls(Item: IExodusItem): Boolean;
     function _HideForm(): boolean;
     //

  public
    { Public declarations }
    procedure ActivateHover(Point: TPoint; Item: IExodusItem);
    procedure CancelHover();
    procedure SetHover();
    property CurrentFrame: TExFrame read _CurrentFrame write _CurrentFrame;
  end;

implementation
uses COMExodusItem, ExTreeView, Jabber1, Presence, Session, RosterForm, XMLTag;

procedure TExItemHoverForm._NewWndProc(var Message: TMessage);
begin
    if (Message.Msg = WM_NCMOUSELEAVE) then
        CancelHover()
    else if (Message.Msg = WM_NCMOUSEMOVE) then
        SetHover();

    _OldWndProc(Message);
end;


procedure TExItemHoverForm.ActivateHover(Point: TPoint; Item: IExodusItem);
begin
    _Item := Item;
    HoverHide.Enabled := false;
    if (Item = nil) then
    begin
        _HideForm();
        exit;
    end;

    if (Item.Type_ = EI_TYPE_GROUP) then
    begin
        _HideForm();
        exit;
    end;

    if (not _InitControls(Item)) then
    begin
         _HideForm();
         exit;
    end;
    _CalcHoverPosition(Point);
  
    Self.Show;
    HoverHide.Enabled := true;
    HoverReenter.Enabled := false;
end;

function TExItemHoverForm._InitControls(Item: IExodusItem) : Boolean;
begin
    _AXHover := nil;
    Result := true;
    Caption := Item.Text;

    if (Item.Type_ = EI_TYPE_CONTACT) then
    begin
        if (_CurrentFrame <> _ContactFrame) then
        begin
            AutoSize := false;
            if (_CurrentFrame <> nil) then
                _CurrentFrame.Parent := nil;
            _CurrentFrame := _ContactFrame;
            _CurrentFrame.Parent := Self;
            AutoSize := true;
        end;
        _ContactFrame.InitControls(Item);
    end
    else if (Item.Type_ = EI_TYPE_ROOM) then
    begin
        if (_CurrentFrame <> _RoomFrame) then
        begin
            AutoSize := false;
            if (_CurrentFrame <> nil) then
                _CurrentFrame.Parent := nil;
            _CurrentFrame := _RoomFrame;
            _CurrentFrame.Parent := Self;
            AutoSize := true;
        end;
        _RoomFrame.InitControls(Item);
    end
    else
    begin
        _AXHover := MainSession.ItemController.GetHoverByType(Item.Type_);
        if (_AXHover <> nil) then
            _AXHover.Show(Item)
        else
        begin
          Result := false;
          exit;
        end;
    end;

end;

procedure TExItemHoverForm.CancelHover();
begin
   HoverReenter.Enabled := true;
end;

procedure TExItemHoverForm.SetHover();
begin
  HoverReenter.Enabled := false;
  HoverHide.Enabled := false;
end;

procedure TExItemHoverForm.HoverHideTimer(Sender: TObject);
begin
  inherited;
  OutputDebugString(PChar('Hide Timer fired'));
  if (_HideForm()) then 
  begin
    HoverHide.Enabled := false;
  end;
end;

procedure TExItemHoverForm.HoverReenterTimer(Sender: TObject);
begin
  inherited;
  //OutputDebugString(PChar('Reenter Timer fired'));
  if (_HideForm()) then
  begin
    HoverReenter.Enabled := false;
  end;
end;


procedure TExItemHoverForm.TntFormCreate(Sender: TObject);
begin
    inherited;
    _ContactFrame := TExContactHoverFrame.Create(Self);
    _RoomFrame := TExRoomHoverFrame.Create(Self);
    _OldWndProc := Self.WindowProc;
    Self.WindowProc := _NewWndProc;
    HoverReenter.Interval := MainSession.prefs.getInt('roster_hint_reentry_delay');
    HoverHide.Interval := MainSession.prefs.getInt('roster_hint_hide_delay');
end;


procedure TExItemHoverForm.TntFormDestroy(Sender: TObject);
begin
  inherited;
  _ContactFrame.Free();
  _RoomFrame.Free();
  Self.WindowProc := _OldWndProc;
end;

procedure TExItemHoverForm.TntFormMouseEnter(Sender: TObject);
begin
  inherited;
  //OutputDebugString(PChar('Form MouseEnter'));
  SetHover();
end;

procedure TExItemHoverForm.TntFormMouseLeave(Sender: TObject);
begin
    //OutputDebugString(PChar('Form MouseLeave'));
    CancelHover();
end;


procedure TExItemHoverForm._WMSysCommand(var msg: TWmSysCommand);
begin
  if msg.CmdType and $FFF0 = SC_CLOSE then
  begin
    _HideForm();
  end;
end;

procedure TExItemHoverForm._CalcHoverPosition(Point: TPoint);
var
    CurMonitor: TMonitor;
begin
    Point.X := Point.X - Width;


    CurMonitor := Screen.MonitorFromPoint(Point);
    if Width > CurMonitor.Width then
        Width := CurMonitor.Width;
    if Height > CurMonitor.Height then
        Height := CurMonitor.Height;

    if Point.Y + Height > CurMonitor.Top + CurMonitor.Height then
        Point.Y := (CurMonitor.Top + CurMonitor.Height) - Height;
    if Point.X + Width > CurMonitor.Left + CurMonitor.Width then
        Point.X := (CurMonitor.Left + CurMonitor.Width) - Width;

    if Point.X < CurMonitor.Left then
        Point.X := Point.X + GetRosterWindow().Width + Width;


    SetWindowPos(Handle, HWND_BOTTOM, Point.X, Point.Y, Width, Height,
     0);
end;

function TExItemHoverForm._HideForm(): boolean;
var
    canHide: boolean;
    Tag: TXMLTag;
begin
    canHide := true;
    if (_AXHover <> nil) then
    begin
        if (_AXHover.listener <> nil) then
        begin
            canHide := _AXHover.listener.CanHideQuery;
        end;
        if (canHide) then
        begin
            _AXHover.Hide(_Item);
            _AXHover := nil;
        end;
    end;

    if (canHide) then
    begin
        Hide;
    end;

    Result := canHide;
    Tag := TXMLTag.Create();
    MainSession.FireEvent('/session/hover/clear', Tag);
    Tag.Free();
end;



{$R *.dfm}

end.
