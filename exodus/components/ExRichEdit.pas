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
unit ExRichEdit;

interface

uses
    Graphics, RichEdit2, RichEdit,
    Windows, Messages, SysUtils, Classes, Controls, StdCtrls, ComCtrls;

type
  TRichEditURLClick = procedure (Sender: TObject; url: string) of object;

  TExRichEdit = class(TRichEdit98)
  private
    { Private declarations }
    _scrolling: boolean;
    _at_bottom: boolean;
    _one_page: boolean;
  protected
    { Protected declarations }
    procedure CreateWnd; override;
    procedure WMVScroll(var msg: TMessage); message WM_VSCROLL;
    procedure CheckBottom();
  public
    { Public declarations }
    procedure InsertBitmap(bmp: Graphics.TBitmap);
    procedure InsertRTF(rtf: string);
    procedure ScrollToBottom();
    procedure ScrollToTop();
    procedure ScrollPageUp();
    procedure ScrollPageDown();
  published
    { Published declarations }
    property atBottom: boolean read _at_bottom;
    property isScrolling: boolean read _scrolling;
  end;

const
    EN_LINK = $070b;

function BitmapToRTF(pict: Graphics.TBitmap): string;
procedure Register;

implementation
uses
    ShellAPI;

procedure TExRichEdit.CreateWnd;
begin
    inherited;
    _scrolling := false;
    _at_bottom := true;
end;

// pgm 3/3/02 - Adding stuff to the rich edit control
// so that we can directly insert bitmaps
procedure TExRichEdit.InsertBitmap(bmp: Graphics.TBitmap);
var
    s : TStringStream;
begin
    // Insert a bitmap into the control
    s := TStringStream.Create(BitmapToRTF(bmp));
    RTFSelText := s.DataString;
    s.Free;
end;

procedure TExRichEdit.InsertRTF(rtf: string);
begin
    RTFSelText := rtf;
end;

procedure TExRichEdit.CheckBottom();
var
    si: TSCROLLINFO;
begin
    si.cbSize := SizeOf(TScrollInfo);
    si.fMask := SIF_ALL;
    GetScrollInfo(Handle, SB_VERT, si);
    if (si.nMin = -1) then
        _one_page := true
    else
        _one_page := false;

    if (si.nMax = -1) then
        _at_bottom := true
    else
        _at_bottom := ((si.nPos + integer(si.nPage)) >= si.nMax);
end;

// pgm 3/16/04 - Let's catch the scroll event and set our state
procedure TExRichEdit.WMVScroll(var msg: TMessage);
begin
    if (msg.WParamLo = SB_ENDSCROLL) then begin
        _scrolling := false;
        CheckBottom();
    end
    else
        _scrolling := true;

    inherited;
end;

procedure TExRichEdit.ScrollPageUp();
begin
    Perform(EM_SCROLL, SB_PAGEUP, 0);
    CheckBottom();
end;

procedure TExRichEdit.ScrollPageDown();
begin
    Perform(EM_SCROLL, SB_PAGEDOWN, 0);
    CheckBottom();
end;

procedure TExRichEdit.ScrollToTop();
begin
    Perform(EM_SCROLL, SB_TOP, 0);
    CheckBottom();
end;

procedure TExRichEdit.ScrollToBottom();
var
    rect: TRect;
    r: LongBool;
    si: TSCROLLINFO;
    i: integer;
    dy, bl, lc: longint;
begin
    si.cbSize := SizeOf(TScrollInfo);
    si.fMask := SIF_ALL;
    r := GetScrollInfo(Handle, SB_VERT, si);

    if ((r) and (si.nMax > 0)) then begin
        // Get the character which is closest to the lower-right corner
        // of the rectangle.
        Perform(EM_GETRECT, 0, Longint(@rect));
        i := Perform(EM_CHARFROMPOS, 0, integer(@rect.BottomRight));

        // Get the line index which holds that char.
        bl := Perform(EM_EXLINEFROMCHAR, 0, i);
        lc := Perform(EM_GETLINECOUNT, 0, 0);

        // dy = line-count - bottom-line
        dy := lc - bl;

        // Move by dy.
        Perform(EM_LINESCROLL, 0, dy);
    end;

    _at_bottom := true;
end;


procedure Register;
begin
  RegisterComponents('Exodus Components', [TExRichEdit]);
end;

function BitmapToRTF(pict: Graphics.TBitmap): string;
var
    bi, bb, rtf: string;
    bis, bbs: Cardinal;
    achar: ShortString;
    hexpict: string;
    i: Integer;
begin
    GetDIBSizes(pict.Handle, bis, bbs);
    SetLength(bi,bis);
    SetLength(bb,bbs);
    GetDIB(pict.Handle, pict.Palette, PChar(bi)^, PChar(bb)^);
    rtf := '{\rtf1 {\pict\dibitmap ';
    SetLength(hexpict,(Length(bb) + Length(bi)) * 2);
    i := 2;
    for bis := 1 to Length(bi) do begin
        achar := Format('%x',[Integer(bi[bis])]);
        if Length(achar) = 1 then
            achar := '0' + achar;
        hexpict[i-1] := achar[1];
        hexpict[i] := achar[2];
        inc(i,2);
    end;
    for bbs := 1 to Length(bb) do begin
        achar := Format('%x',[Integer(bb[bbs])]);
        if Length(achar) = 1 then
            achar := '0' + achar;
        hexpict[i-1] := achar[1];
        hexpict[i] := achar[2];
        inc(i,2);
    end;
    rtf := rtf + hexpict + ' }}';
    Result := rtf;
end;


end.
