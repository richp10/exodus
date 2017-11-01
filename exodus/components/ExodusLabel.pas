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
unit ExodusLabel;


interface

uses
  Windows, SysUtils, Classes, Controls, Contnrs, ExtCtrls, Regexpr;

type
  TURLRect = class
    url: string;
    rect: TRect;
  end;

  TExodusLabel = class(TPaintBox)
  private
    { Private declarations }
    _urls: TObjectList;
    _caption: WideString;
    _unicode: boolean;
    procedure MeasureMaybeDraw(doDraw : boolean);

  protected
    { Protected declarations }
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure SetCaption(cap: WideString);

  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy(); override;
    procedure Paint(); override;
    procedure SetBounds(ALeft: Integer; ATop: Integer; AWidth: Integer; AHeight: Integer); override;
    procedure AutoSize();
  published
    { Published declarations }
    property Caption: WideString read _caption write SetCaption;
  end;


procedure Register;

var
  REGEX_URL: TRegExpr;
  unicode_enabled: integer;

implementation

uses
    Forms, Unicode, Types, Math, Graphics, ShellAPI;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
procedure WordSplit(value: WideString; list: TWideStringList);
var
    i, l : integer;
    tmps : WideString;
begin
    tmps := Trim(value);
    l := 1;
    while l <= length(tmps) do begin
        // search for the first non-space
        while (
            (l <= length(tmps)) and
            (UnicodeIsSeparator(Ord(tmps[l]))) and
            (UnicodeIsWhiteSpace(Ord(tmps[l])))) do
            inc(l);

        if l > length(tmps) then exit;
        i := l;

        // search for the first space
        while (i <= length(tmps)) and
            (not UnicodeIsSeparator(Ord(tmps[i]))) and
            (not UnicodeIsWhiteSpace(Ord(tmps[i]))) do
            inc(i);

        list.Add(Copy(tmps, l, i - l));
        l := i + 1;

    end;
end;

function CheckUnicodeEnabled(): boolean;
var
    h: THandle;
    OSVersionInfo32: OSVERSIONINFO;
begin
    // check to see if we're an NT based OS, or we have
    // the unicode layer installed
    if (unicode_enabled = 0) then begin
        OSVersionInfo32.dwOSVersionInfoSize := SizeOf(OSVersionInfo32);
        GetVersionEx(OSVersionInfo32);
        case OSVersionInfo32.dwPlatformId of
        VER_PLATFORM_WIN32_WINDOWS: begin
            { Windows 95/98/ME }
            h := LoadLibrary('unicows.dll');
            if (h = 0) then
                unicode_enabled := -1
            else
                unicode_enabled := +1;
        end;
        VER_PLATFORM_WIN32_NT: begin
            { ALL NT based platforms }
            unicode_enabled := +1;
        end;
        end;
    end;

    if (unicode_enabled = 1) then
        Result := true
    else
        Result := false;
end;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
constructor TExodusLabel.Create(AOwner: TComponent);
begin
    inherited;

    _urls := TObjectList.Create();
    _urls.OwnsObjects := true;

    _unicode := CheckUnicodeEnabled();

end;

{---------------------------------------}
destructor TExodusLabel.Destroy();
begin
    _urls.Free();
    inherited;
end;

{---------------------------------------}
procedure TExodusLabel.SetCaption(cap: WideString);
begin
    _caption := cap;
end;

{---------------------------------------}
procedure TExodusLabel.AutoSize();
begin
    MeasureMaybeDraw(false);
end;

{---------------------------------------}
procedure TExodusLabel.MeasureMaybeDraw(doDraw : boolean);
var
    w: TRect;
    word, txt, txt2: Widestring;
    p1, i, x, y, l, ws: integer;
    words: TWidestringlist;
    p2: double;
    wonkus: boolean;
    ur: TUrlRect;
    hCanvas: HDC;
begin
    if (Self.Caption = '') then exit;
    if (Self.Height = 0) then exit;

    // paint a fixed label, doing m4dd w0rd wr4pp1ng.
    x := 0;
    y := 0;

    // Ensure we have the correct font in the Canvas.
    if ((Self.Canvas.Font.Name <> Self.Font.Name) or
        (Self.Canvas.Font.Size <> Self.Font.Size)) then
        SelectObject(Self.Canvas.Handle, Self.Font.Handle);

    hCanvas := Self.Canvas.Handle;

    // cache the width of a space.
    txt := ' ';
    w.Left := 0;
    w.Right := 0;
    w.Top := 0;
    w.Bottom := 0;
    if (_unicode) then
        DrawTextExW(hCanvas, PWideChar(txt), Length(txt), w,
            DT_SINGLELINE or DT_CALCRECT or DT_NOPREFIX, nil)
    else
        DrawTextEx(hCanvas, PChar(string(txt)), Length(String(txt)), w,
            DT_SINGLELINE or DT_CALCRECT or DT_NOPREFIX, nil);

    ws := w.Right;

    words := TWidestringlist.Create();
    WordSplit(self.Caption, words);

    _urls.Clear();
    wonkus := false;
    i := 0;
    while (i < words.count) do begin
        word := words[i];
        txt := words[i];
        if (x > 0) then txt := ' ' + txt;
        w.top := y;
        w.Left := x;
        w.right := x + 1;
        w.Bottom := y + 1;

        if (_unicode) then
            DrawTextExW(hCanvas, PWideChar(txt), Length(txt), w,
                DT_SINGLELINE or DT_CALCRECT or DT_NOPREFIX, nil)
        else
            DrawTextEx(hCanvas, PChar(String(txt)), Length(String(txt)), w,
                DT_SINGLELINE or DT_CALCRECT or DT_NOPREFIX, nil);

        l := w.Right - w.Left;

        if (w.Right > Self.Width) then begin
            // we need to wrap, since this word would put us over the edge
            if (l > Self.Width) then begin
                // we can't fit in our rect..
                // chop the string and hope for the best :)
                p2 := (Self.Width - x)/l;
                p1 := Floor(p2 * length(txt)) - 1;
                txt := Copy(words[i], 0, p1);
                if (x > 0) then txt := ' ' + txt;
                txt2 := Copy(words[i], p1+1, length(words[i]) - p1);
                words[i] := txt2;
                i := i - 1;
                wonkus := true;
            end
            else begin
                txt := word;

                // re-measure, without the space
                x := 0;
                w.Right := 0;
                w.Top := w.Bottom + 1;

                if (_unicode) then
                    DrawTextExW(hCanvas, PWideChar(txt), Length(txt), w,
                            DT_SINGLELINE or DT_CALCRECT or DT_NOPREFIX, nil)
                else
                    DrawTextEx(hCanvas, PChar(String(txt)), Length(String(txt)), w,
                            DT_SINGLELINE or DT_CALCRECT or DT_NOPREFIX, nil);

                l := w.Right - w.Left;
                y := w.Top;
                wonkus := false;
            end;
        end;

        if (REGEX_URL.Exec(word)) then begin
            if txt[1] = ' ' then begin
                // can't reassign to word, since we may be wonkus,
                // in which case we want the truncated word.
                txt := Copy(txt, 2, length(txt) - 1);
                
                // don't draw the space, but move over for it.  This
                // way the space won't be underlined, and it won't be
                // hit-test.
                x := x + ws;
                l := l - ws;
            end;
            // TODO: This is setting the style to bold, rather than underline.
            //Self.Canvas.Font.Style := [fsUnderline];
            SetTextColor(hCanvas, clBlue);
            ur := TURLRect.Create();
            ur.rect.Left := x;
            ur.rect.Right := x + l;
            ur.rect.Top := y;
            ur.rect.Bottom := w.bottom;
            ur.url := word;
            _urls.Add(ur);
            // TODO: deal with wonkus state for URLs, draw the next chunk in blue,
            // and add another url rect for it.
        end
        else begin
            Self.Canvas.Font.Style := [];
            SetTextColor(hCanvas, clBlack);
        end;

        if (doDraw) then
            TextOutW(hCanvas, x, y, PWideChar(txt), length(txt));
        if (wonkus) then begin
            x := 0;
            y := w.bottom + 2;
            wonkus := false;
        end
        else
            x := x + l + 1;
        inc(i);
    end;

    if (w.Bottom > Self.Parent.Height) and Self.Parent.InheritsFrom(TFrame) then
        Self.Parent.Height := w.Bottom + 2;
    if (w.Bottom > Self.Height) then begin
        //OutputDebugString('TExodusLabel, increasing height');
        Self.Height := w.Bottom;
    end;
end;

procedure TExodusLabel.Paint;
begin
    inherited;

    MeasureMaybeDraw(true);
end;

procedure TExodusLabel.SetBounds(ALeft: Integer; ATop: Integer; AWidth: Integer; AHeight: Integer);
var
    widthChange : boolean;
begin
    widthChange := (AWidth <> Self.Width);
    inherited;
    if (widthChange) then begin
        if (Self.Height > 0) then begin
            Self.Height := 1;
            MeasureMaybeDraw(false);
        end;
    end;
end;

procedure TExodusLabel.MouseMove(Shift: TShiftState; X, Y: Integer);
var
    p: TPoint;
    i: integer;
begin
    // check for URL's
    p.x := x;
    p.y := y;

    for i := 0 to _urls.Count - 1 do begin
        if PtInRect(TURLRect(_urls[i]).rect, p) then begin
            SetCursor(LoadCursor(0, IDC_HAND));
            exit;
        end;
    end;
    SetCursor(LoadCursor(0, IDC_ARROW));
    inherited;
end;

procedure TExodusLabel.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
    p: TPoint;
    i: integer;
    ur: TURLRect;
begin
    // check for URL's
    p.X := x;
    p.y := y;

    for i := 0 to _urls.Count - 1 do begin
        ur := TURLRect(_urls[i]);
        if PtInRect(ur.rect, p) then begin
            ShellExecute(Application.Handle, 'open', PChar(ur.url), nil, nil, SW_SHOWNORMAL);
            exit;
        end;
    end;

    inherited;
end;

procedure Register;
begin
  RegisterComponents('Exodus Components', [TExodusLabel]);
end;

initialization
    REGEX_URL := TRegExpr.Create();
    // http://foo, you see
    // http://bar. this is some text
    REGEX_URL.expression := '(https?|ftp|xmpp)://[^ "'''#$D#$A#$9']+';
    REGEX_URL.Compile();
    unicode_enabled := 0;

finalization
    FreeAndNil(REGEX_URL);
end.
