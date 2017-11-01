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
unit ExGraphicButton;

interface

uses
  SysUtils, Classes, Controls, ExtCtrls, TntExtCtrls, TntStdCtrls, StdCtrls,
  Graphics, PNGWrapper;

type
  TGraphicButtonOrientation = (gboOverlay, gboLeftOf, gboRightOf, gboAbove, gboBelow);

  TExGraphicButton = class(TCustomControl)
  private
    { Private declarations }
    _orient: TGraphicButtonOrientation;
    _focused: boolean;
    _selected: boolean;
    _pushed: boolean;
    _caption: Widestring;
    _border: TBorderWidth;
    _images: Array[0..3] of TPNGWrapper;

    _target: TObject;

    procedure SetCaption(txt: WideString);
    procedure SetPushed(push: boolean);
    procedure SetSelected(sel: boolean);
    procedure SetBorder(border: TBorderWidth);
    procedure SetOrientation(orient: TGraphicButtonOrientation);

    function GetImageOf(idx: Integer): TPNGWrapper;
    procedure SetImageOf(idx: Integer; img: TPNGWrapper);

    function GetImageEnabled(): TPNGWrapper;
    procedure SetImageEnabled(img: TPNGWrapper);

    function GetImageDisabled(): TPNGWrapper;
    procedure SetImageDisabled(img: TPNGWrapper);

    function GetImageSelected(): TPNGWrapper;
    procedure SetImageSelected(img: TPNGWrapper);

    function GetImagePushed(): TPNGWrapper;
    procedure SetImagePushed(img: TPNGWrapper);

  protected
    procedure Paint(); override;
    procedure DoEnter(); override;
    procedure DoExit(); override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure MouseEnter(Sender: TObject); virtual;
    procedure MouseLeave(Sender: TObject); virtual;

    function CanAutoSize(var NewWidth, NewHeight: Integer): Boolean; override;

    function GetImageToShow(): TPNGWrapper;
    procedure Loaded(); override;
  public
    { Public declarations }
    constructor Create(AOwner : TComponent); override;
    destructor Destroy(); override;

    function CanFocus(): Boolean; override;

  published
    { Published declarations }
    property Align;
    property Anchors default [akLeft, akTop];
    property AutoSize default false;
    property BorderWidth: TBorderWidth read _border write SetBorder default 3;
    property Caption: Widestring read _caption write SetCaption;
    property Enabled default true;
    property Pushed: boolean read _pushed write SetPushed default false;
    property Selected: boolean read _selected write SetSelected default false;
    property Orientation: TGraphicButtonOrientation read _orient
            write SetOrientation default gboOverlay;

    property ImageEnabled: TPNGWrapper read GetImageEnabled write SetImageEnabled;
    property ImageDisabled: TPNGWrapper read GetImageDisabled write SetImageDisabled;
    property ImageSelected: TPNGWrapper read GetImageSelected write SetImageSelected;
    property ImagePushed: TPNGWrapper read GetImagePushed write SetImagePushed;

    property Target: TObject read _target write _target;
    property Padding;

    property OnClick;
    property OnMouseEnter;
    property OnMouseLeave;

end;

procedure Register;

implementation

uses Math, Types, Windows, TntGraphics, TnTWindows;

const
    IMG_ENABLED:    Integer = 0;
    IMG_DISABLED:   Integer = 1;
    IMG_SELECTED:   Integer = 2;
    IMG_PUSHED:     Integer = 3;

procedure Register;
begin
    RegisterComponents('Exodus Components', [TExGraphicButton]);
end;

constructor TExGraphicButton.Create(AOwner: TComponent);
var
    idx: Integer;
begin
    //create these early for dfm loads
    for idx := 0 to Length(_images) - 1 do begin
        _images[idx] := TPNGWrapper.Create;
    end;

    OnMouseEnter := MouseEnter;
    OnMouseLeave := MouseLeave;
    
    inherited Create(AOwner);
end;

destructor TExGraphicButton.Destroy;
var
    idx: Integer;
begin
    for idx := 0 to Length(_images) - 1 do begin
        _images[idx].Free;
    end;

    inherited Destroy;
end;

procedure TExGraphicButton.Loaded();
var
    i: integer;
begin
    for i := 0 to 3 do
    begin
        _images[i].BackgroundColor := Self.Color;
    end;
end;

procedure TExGraphicButton.SetCaption(txt: WideString);
begin
    if txt <> _caption then begin
        _caption := txt;
        repaint;
    end;
end;
procedure TExGraphicButton.SetPushed(push: Boolean);
begin
    if _pushed <> push then begin
        _pushed := push;
        repaint;
    end;
end;
procedure TExGraphicButton.SetSelected(sel: Boolean);
begin
    if _selected <> sel then begin
        _selected := sel;
        repaint;
    end;
end;
procedure TExGraphicButton.SetBorder(border: TBorderWidth);
begin
    if _border <> border then begin
        _border := border;
        repaint;
    end;
end;
procedure TExGraphicButton.SetOrientation(orient: TGraphicButtonOrientation);
begin
    if _orient <> orient then begin
        _orient := orient;
        repaint;
    end;
end;

function TExGraphicButton.GetImageToShow(): TPNGWrapper;
begin
    Result := nil;
    if not Enabled then begin
        Result := GetImageDisabled;
    end
    else if Pushed then begin
        Result := GetImagePushed;
    end
    else if Selected then begin
        Result := GetImageSelected;
    end;

    if (Result = nil) or (Result.Empty) then
        Result := GetImageEnabled;
    //last chance to make sure background is up to date...
    if (result <> nil) then
        Result.BackgroundColor := Self.Color;
end;

function TExGraphicButton.GetImageOf(idx: Integer): TPNGWrapper;
begin
    Result := _images[idx];
end;
procedure TExGraphicButton.SetImageOf(idx: Integer; img: TPNGWrapper);
begin
    _images[idx].Assign(img);
    _images[idx].BackgroundColor := Self.Color;
    Repaint;
end;

function TExGraphicButton.GetImageEnabled(): TPNGWrapper;
begin
    Result := GetImageOf(IMG_ENABLED);
end;
procedure TExGraphicButton.SetImageEnabled(img: TPNGWrapper);
begin
    SetImageOf(IMG_ENABLED, img);
end;

function TExGraphicButton.GetImageDisabled(): TPNGWrapper;
begin
    Result := GetImageOf(IMG_DISABLED);
end;
procedure TExGraphicButton.SetImageDisabled(img: TPNGWrapper);
begin
    SetImageOf(IMG_DISABLED, img);
end;

function TExGraphicButton.GetImageSelected(): TPNGWrapper;
begin
    Result := GetImageOf(IMG_SELECTED);
end;
procedure TExGraphicButton.SetImageSelected(img: TPNGWrapper);
begin
    SetImageOf(IMG_SELECTED, img);
end;

function TExGraphicButton.GetImagePushed(): TPNGWrapper;
begin
    Result := GetImageOf(IMG_PUSHED);
end;
procedure TExGraphicButton.SetImagePushed(img: TPNGWrapper);
begin
    SetImageOf(IMG_PUSHED, img);
end;

procedure TExGraphicButton.DoEnter;
begin
    inherited;

    _focused := true;
    repaint;
end;
procedure TExGraphicButton.DoExit;
begin
    inherited;

    _focused := false;
    repaint;
end;

procedure TExGraphicButton.MouseEnter(Sender: TObject);
begin
    DoEnter();
    inherited;
end;
procedure TExGraphicButton.MouseLeave(Sender: TObject);
begin
    DoExit();
    inherited;
end;
procedure TExGraphicButton.MouseDown(Button: TMouseButton; Shift: TShiftState; X: Integer; Y: Integer);
begin
    Pushed := true;
    inherited MouseDown(Button, Shift, X, Y);
end;
procedure TExGraphicButton.MouseUp(Button: TMouseButton; Shift: TShiftState; X: Integer; Y: Integer);
begin
    Pushed := false;
    inherited MouseUp(Button, Shift, X, Y);
end;

procedure TExGraphicButton.Paint;
var
    OutRect, InRect: TRect;
    imgRect, txtRect: TRect;
    extents: TSize;
    Flags: Longint;
    txt: Widestring;
    img: TPNGWrapper;
    txtColor: TColor;

    procedure paintImage(Canvas: TCanvas; img: TPNGWrapper; bounds: TRect);
    begin
        img.Draw(Canvas, bounds);
    end;

    procedure paintText(Canvas: TCanvas; txt: Widestring; flags: Longint; bounds: TRect);
    var
        txtCanvas: TCanvas;
    begin
        txtCanvas := TCanvas.Create();

        try
            txtCanvas.Handle := GetWindowDC(Self.Handle);
            with txtCanvas do begin
                Font := Self.Font;
                Brush.Style := bsClear;
                Font.Color := txtColor;
                flags := DrawTextBiDiModeFlags(flags);
                Tnt_DrawTextW(Handle,
                        PWideChar(txt), Length(txt),
                        bounds, Flags);
            end;
        finally
            ReleaseDC(Self.Handle, txtCanvas.Handle);
            txtCanvas.Free;
        end;

    end;
    procedure paintFocus(Canvas: TCanvas; bounds: TRect);
    var
        fCanvas: TCanvas;
    begin
        fCanvas := TCanvas.Create();

        try
            fCanvas.Handle := GetWindowDC(Self.Handle);
            with fCanvas do begin
                Pen.Style := psInsideFrame;
                Pen.Color := clBtnShadow;
                Brush.Style := bsClear;
                RoundRect(bounds.Left, bounds.Top,
                        bounds.Right, bounds.Bottom,
                        2, 2);
            end;
        finally
            ReleaseDC(Self.Handle, fCanvas.Handle);
            fCanvas.Free;
        end;
    end;
begin
    if Selected then begin
        txtColor := clWhite;
    end
    else begin
        txtColor := clBlack;
    end;

    txt := Caption;
    OutRect := ClientRect;
    with OutRect do begin
        Left := Left + Margins.Left;
        Top := Top + Margins.Top;
        Right := Right - Margins.Right;
        Bottom := Bottom - Margins.Bottom;
    end;

    InRect := OutRect;
    with InRect do begin
        Left := Left + Padding.Left;
        Top := Top + Padding.Top;
        Right := Right - Padding.Right;
        Bottom := Bottom - Padding.Bottom;
    end;

    imgRect := InRect;
    txtRect := InRect;
    Flags := DT_EXPANDTABS or DT_SINGLELINE;
    
    img := GetImageToShow();

    if (img <> nil) then begin
        extents.cx := img.Width;
        extents.cy := img.Height;
    end;

    case Orientation of
        gboAbove: begin
            //text above image
            imgRect.Top := imgRect.Bottom - extents.cy;
            imgRect.Left := (imgRect.Right div 2) - (extents.cx div 2);
            if (extents.cx mod 2) <> 0 then Inc(imgRect.Left);
            imgRect.Right := imgRect.Left + (extents.cx);
            txtRect.Top := imgRect.Bottom;
            Flags := Flags or DT_CENTER or DT_TOP;
        end;
        gboBelow: begin
            // text below image
            imgRect.Bottom := imgRect.Top + (extents.cy + 1);
            imgRect.Left := (imgRect.Right div 2) - (extents.cx div 2);
            if (extents.cx mod 2) <> 0 then Inc(imgRect.Left);
            imgRect.Right := imgRect.Left + (extents.cx);
            txtRect.Top := imgRect.Bottom;
            Flags := Flags or DT_CENTER or DT_BOTTOM;
        end;
        gboLeftOf: begin
            // text left of image
            imgRect.Left := imgRect.Right - extents.cx;
            imgRect.Top := (imgRect.Bottom div 2) - (extents.cy div 2);
            if (extents.cy mod 2) <> 0 then Inc(imgRect.Top);
            imgRect.Bottom := imgRect.Top + (extents.cy);
            txtRect.Right := imgRect.Left;
            Flags := Flags or DT_VCENTER or DT_RIGHT;
        end;
        gboRightOf: begin
            // text right of image
            imgRect.Right := imgRect.Left + (extents.cx + 1);
            imgRect.Top := (imgRect.Bottom div 2) - (extents.cy div 2);
            if (extents.cy mod 2) <> 0 then Inc(imgRect.Top);
            imgRect.Bottom := imgRect.Top + (extents.cy);
            txtRect.Left := imgRect.Right;
            Flags := Flags or DT_VCENTER or DT_LEFT;
        end;
        gboOverlay: begin
            // text overlays image
            imgRect.Left := (imgRect.Right div 2) - (extents.cx div 2);
            if (extents.cx mod 2) <> 0 then Inc(imgRect.Left);
            imgRect.Right := imgRect.Left + (extents.cx);
            imgRect.Top := (imgRect.Bottom div 2) - (extents.cy div 2);
            if (extents.cy mod 2) <> 0 then Inc(imgRect.Top);
            imgRect.Bottom := imgRect.Top + (extents.cy);
            Flags := Flags or DT_BOTTOM or DT_CENTER;
        end;
    end;
    InflateRect(txtRect, -BorderWidth, -BorderWidth);

    // and now we paint...
        paintImage(Canvas, img, imgRect);
    if txt <> '' then
        paintText(Canvas, txt, flags, txtRect);
    if _focused then
        paintFocus(Canvas, inRect);
end;

function TExGraphicButton.CanFocus(): Boolean;
begin
    Result := inherited CanFocus;
end;
function TExGraphicButton.CanAutoSize(var NewWidth: Integer; var NewHeight: Integer): Boolean;
var
    png: TPNGWrapper;
    ih, iw: Integer;
    th, tw: Integer;
begin
    Result := AutoSize;

    if Result and HandleAllocated() then begin
        png := GetImageToShow();
        if png <> nil then with png do begin
            ih := Height;
            iw := Width;
        end
        else begin
            ih := 0;
            iw := 0;
        end;

        if Caption <> '' then with WideCanvasTextExtent(Canvas, Caption) do begin
            th := cy;
            tw := cx;
        end
        else begin
            th := 0;
            tw := 0;
        end;

        // assume max...
        NewHeight := Max(th, ih);
        NewWidth := Max(tw, iw);
        if      (Orientation = gboLeftOf) or (Orientation = gboRightOf) then begin
            // width is image + text
            NewWidth := tw + iw;
        end;
        if      (Orientation = gboAbove) or (Orientation = gboBelow) then begin
            // height is image + text
            NewHeight := th + ih;
        end;

        with Padding do begin
            NewHeight := NewHeight + Top + Bottom;
            NewWidth := NewWidth + Left + Right;
        end;
        with Margins do begin
            NewHeight := NewHeight + Top + Bottom;
            NewWidth := NewWidth + Left + Right;
        end;
    end;
end;

end.
