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
unit RiserWindow;


interface

uses
    Variants,
    Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
    Dialogs, ExtCtrls, StdCtrls, TntStdCtrls, ExForm;

const
    TOAST_BUFFER_PIX = 2;

type
  TfrmRiser = class(TExForm)
    Timer1: TTimer;
    Timer2: TTimer;
    Image1: TImage;
    Label1: TTntLabel;
    Shape1: TShape;
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure Panel2Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Timer2Timer(Sender: TObject);
    procedure Shape1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormResize(Sender: TObject);
  private
    { Private declarations }
    _taskrect: TRect;
    _taskdir: integer;
    _clickForm: TForm;
    _clickHandle: HWND;
    _event: widestring;
    _eventXML: widestring;
  protected
    procedure CreateParams(var Params: TCreateParams); override;
  public
    { Public declarations }
    procedure Position();
  end;

var
    singleToast: TfrmRiser;
    frmRiser: TfrmRiser;

procedure ShowRiserWindow(clickForm: TForm; msg: Widestring; imgIndex: integer); overload;
procedure ShowRiserWindow(clickHandle: HWND; msg: Widestring; imgIndex: integer); overload;
procedure ShowRiserWindow(msg: Widestring; imgIndex: integer; clickEvent: widestring; clickEventXML: widestring); overload;

procedure ShowRiserWindow(clickForm: TForm; clickHandle: HWND; msg: Widestring; imgIndex: integer; event: widestring = ''; eventXML: widestring = ''); overload;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
implementation

{$R *.dfm}
uses
    Types,
    JabberUtils,
    ExUtils,
    GnuGetText,
    Session,
    Dockable,
    Jabber1,
    XMLTag,
    XMLParser;

{---------------------------------------}
procedure ShowRiserWindow(clickForm: TForm; msg: Widestring; imgIndex: integer);
begin
    ShowRiserWindow(clickForm, 0, msg, imgIndex);
end;

{---------------------------------------}
procedure ShowRiserWindow(clickHandle: HWND; msg: Widestring; imgIndex: integer);
begin
    ShowRiserWindow(nil, clickHandle, msg, imgIndex);
end;

{---------------------------------------}
procedure ShowRiserWindow(msg: Widestring; imgIndex: integer; clickEvent: widestring; clickEventXML: widestring);
begin
    ShowRiserWindow(nil, 0, msg, imgIndex, clickEvent, clickEventXML);
end;

{---------------------------------------}
procedure ShowRiserWindow(clickForm: TForm; clickHandle: HWND; msg: Widestring; imgIndex: integer; event: widestring; eventXML: widestring);
var
    animate: boolean;
begin

    // Don't show toast while auto away
    //if ((frmExodus.IsAutoAway) or (frmExodus.IsAutoXA)) then exit;

    if (singleToast <> nil) then begin
        with singleToast do begin
            Timer1.Enabled := false;
            Timer2.Enabled := false;
            Close();
        end;
        FreeAndNil(singleToast);
    end;
    
    // create a new instance
    singleToast := TfrmRiser.Create(nil);
    animate := true;
//        AssignDefaultFont(singleToast.Label1.Font);

    // reduce the font size by 1 pt.
    //singleToast.Label1.Font.Size := singleToast.Label1.Font.Size - 1;

    // Setup alpha blending..
    if MainSession.Prefs.getBool('toast_alpha') then begin
        singleToast.AlphaBlend := true;
        singleToast.AlphaBlendValue := MainSession.Prefs.getInt('toast_alpha_val');
    end;

    singleToast._clickForm := clickForm;
    singleToast._clickHandle := clickHandle;
    singleToast._event := event;
    singleToast._eventXML := eventXML;

    if ((clickForm <> nil) and (clickHandle = 0)) then
        singleToast._clickHandle := clickForm.Handle;
         
    with singleToast do begin
        Label1.Top := 5;
        Label1.Left := Image1.Left + Image1.Width + 2;
        Label1.Width := ClientWidth - Label1.Left - 5;
        Label1.Caption := msg;

        if (Label1.Width > (ClientWidth - 55)) then
            ClientWidth := Label1.Width + 70;

        if (Label1.Height > (ClientHeight + 30)) then
            ClientHeight := Label1.Height + 30;
    end;
    singleToast.Position();

    // madness to make sure toast images are transparent.
    with singleToast.Image1 do begin
        Canvas.Brush.Color := clBtnFace;
        Canvas.FillRect(Rect(0, 0,  Width, Height));
        frmExodus.ImageList1.GetBitmap(imgIndex, Picture.Bitmap);
        if (not animate) then Repaint();
    end;

    // raise the window
    if animate then begin
        // singleToast.Show;
        ShowWindow(singleToast.Handle, SW_SHOWNOACTIVATE);
        singleToast.Visible := true;
        singleToast.Timer1.Enabled := true;
    end;

end;

{---------------------------------------}
procedure TfrmRiser.CreateParams(var Params: TCreateParams);
begin
    inherited CreateParams(Params);
    with Params do begin
        ExStyle := ExStyle or WS_EX_NOPARENTNOTIFY;
        //WndParent := 0;
    end;
end;

{---------------------------------------}
procedure TfrmRiser.FormCreate(Sender: TObject);
begin
    AssignUnicodeFont(Self, 9);
    TranslateComponent(Self);
    Timer2.Interval := MainSession.Prefs.getInt('toast_duration') * 1000;
end;

{---------------------------------------}
procedure TfrmRiser.Position();
var
    midx: integer;
    dc, tc: TPoint;
    dtop: TRect;
    taskbar: HWND;
    dx, dy: longint;
    //dh, dw, mh, mw: longint;
begin
    // Netmeeting hack
    if (Assigned(Application.MainForm)) then
        Application.MainForm.Monitor;

    // Find the taskbar, and it's monitor
    taskbar := FindWindow('Shell_TrayWnd', '');
    GetWindowRect(taskbar, _taskrect);

    tc := CenterPoint(_taskrect);
    midx := Screen.MonitorFromPoint(tc, mdNearest).MonitorNum;
    dtop := Screen.Monitors[midx].WorkareaRect;

    // eval the rect to get it's direction
    {
    0 = left side
    1 = right side
    2 = top
    3 = bottom
    }

    // check tc (taskbar center) vs. dc (desktop center)
    // Use geometry, yo.
    dc := CenterPoint(dtop);
    dx := dc.X - tc.X;
    dy := dc.Y - tc.Y;

    if ((dx > 0) and (dy = 0)) then begin
        // Left side
        _taskdir := 0;
        Self.Left := _taskrect.Left - Self.Width - TOAST_BUFFER_PIX;
        Self.Top := _taskrect.Bottom - Self.Height - TOAST_BUFFER_PIX;
    end
    else if ((dx < 0) and (dy = 0)) then begin
        // Right side
        _taskdir := 1;
        Self.Left := _taskrect.Right + Self.Width + TOAST_BUFFER_PIX;
        Self.Top := _taskrect.Bottom - Self.Height - TOAST_BUFFER_PIX;
    end
    else if ((dx = 0) and (dy > 0)) then begin
        // Top
        _taskdir := 2;
        Self.Left := _taskrect.Right - Self.Width - TOAST_BUFFER_PIX;
        Self.Top := _taskrect.Top - Self.Height - TOAST_BUFFER_PIX;
    end
    else begin
        // Bottom
        _taskdir := 3;
        Self.Left := _taskrect.Right - Self.Width - TOAST_BUFFER_PIX;
        Self.Top := _taskrect.Bottom + Self.Height + TOAST_BUFFER_PIX;
    end;
end;

{---------------------------------------}
procedure TfrmRiser.Timer1Timer(Sender: TObject);
var
    stop: boolean;
begin
    stop := false;
    case _taskdir of
    0: begin
        // taskbar on left
        Self.Left := Self.Left + 2;
        if (Self.Left > _taskrect.Right) then stop := true;
    end;
    1: begin
        // taskbar on right
        Self.Left := Self.Left - 2;
        if ((Self.Left + Self.Width)  < _taskrect.Left) then stop := true;
    end;
    2: begin
        // taskbar on top
        Self.Top := Self.Top + 2;
        if (Self.Top > _taskrect.Bottom) then stop := true;
    end;
    3: begin
        // taskbar on bottom
        Self.Top := Self.Top - 2;
        if (Self.Top + Self.Height) < _taskrect.top then stop := true;
    end;
    end;

    if (stop) then begin
        Timer1.Enabled := false;
        Timer2.Enabled := true;
    end;

end;

{---------------------------------------}
procedure TfrmRiser.Panel2Click(Sender: TObject);
var
    ttag: TXMLTag;
    parser: TXMLTagParser;
begin
    Self.Close;

    // If we have an event AND no window handle of any sort,
    // fire the event, then exit.  This is useful for plugins.
    if ((_event <> '') and
        (_clickHandle = 0) and
        (_clickForm = nil)) then
    begin
        parser := TXMLTagParser.Create();
        parser.ParseString(_eventXML);
        ttag := parser.popTag();
        if (ttag <> nil) then
        begin
            MainSession.FireEvent(_event, ttag);
        end;
        ttag.Free();
        parser.Free();
        exit;
    end;

    // make sure the window handle is still valid
    if ((_clickHandle <> 0) and (not IsWindow(_clickHandle))) then
        exit;

    // Special case for the main exodus window.
    if ((_clickForm = nil) and (_clickHandle <> 0)) then begin
        setForegroundWindow(_clickHandle);
        exit;
    end
    else if (_clickForm = nil) then
        exit

    else if ((_clickForm = frmExodus) and (frmExodus.isMinimized())) then
        frmExodus.trayShowClick(nil)

    else if (_clickForm.WindowState = wsMinimized) then
        ShowWindow(_clickForm.Handle, SW_SHOWNORMAL);

    // ok, try and raise the window
    if (_clickForm is TfrmDockable) then with TfrmDockable(_clickForm) do begin
        ShowDefault();
        exit;
    end
    else begin
        SetForegroundWindow(_clickHandle);
    end;

    if (_clickForm <> nil) then
        _clickForm.Show();
end;

{---------------------------------------}
procedure TfrmRiser.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    singleToast := nil;
    Action := caFree;
end;

{---------------------------------------}
procedure TfrmRiser.Timer2Timer(Sender: TObject);
begin
    // close ourself
    Self.Close;
end;

{---------------------------------------}
procedure TfrmRiser.Shape1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
    Panel2Click(Shape1);
end;

{---------------------------------------}
procedure TfrmRiser.FormResize(Sender: TObject);
begin
    // resize the border shape
    Shape1.Width := Self.ClientWidth;
    Shape1.Height := Self.ClientHeight;
end;

initialization
    singleToast := nil;

end.
