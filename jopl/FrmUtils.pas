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
unit FrmUtils;

interface
uses
    Unicode,
    {$ifdef EXODUS}
    PrefController,
    {$endif}
    Graphics, 
    Classes, 
    SysUtils,
    Forms,
    Windows;

type
	TGlueEdge = (geNone, geTop, geRight, geLeft, geBottom);


	function withinGlueSnapRange(stationaryfrm, movingfrm: TForm; glueRange: integer = 10): TGlueEdge;
    function CheckWindowFullyVisibleOnScreen(WndHandle: HWnd): HWnd;

implementation
uses
    {$ifdef EXODUS}
    GnuGetText,
    {$endif}

    Controls,
    Types;

{---------------------------------------}
function withinGlueSnapRange(stationaryfrm, movingfrm: TForm; glueRange: integer): TGlueEdge;
var
    stationaryRect: TRect;
    movingRect: TRect;
begin
    Result := geNone;

    if (stationaryfrm = nil) then exit;
    if (movingfrm = nil) then exit;
    if (glueRange < 0) then exit;
    if (stationaryfrm.WindowState = wsMaximized) then exit;
    if (movingfrm.WindowState = wsMaximized) then exit;
    if (stationaryfrm.WindowState = wsMinimized) then exit;
    if (movingfrm.WindowState = wsMinimized) then exit;


    // Capture frm1 rect.
    stationaryRect.Top := stationaryfrm.Top;
    stationaryRect.Left := stationaryfrm.Left;
    stationaryRect.Bottom := stationaryfrm.Top + stationaryfrm.Height;
    stationaryRect.Right := stationaryfrm.Left + stationaryfrm.Width;

    // Capture frm2 rect.
    movingRect.Top := movingfrm.Top;
    movingRect.Left := movingfrm.Left;
    movingRect.Bottom := movingfrm.Top + movingfrm.Height;
    movingRect.Right := movingfrm.Left + movingfrm.Width;

    // Check to see if we are in range
    //  - Need to be within glue range of a side
    //  - Need to be within glue range of secondary trait, like the top
    if ((movingRect.Left <= (stationaryRect.Right + glueRange)) and
        (movingRect.Left >= (stationaryRect.Right - glueRange)) and
        (movingRect.Top <= (stationaryRect.Top + glueRange)) and
        (movingRect.Top >= (stationaryRect.Top - glueRange))) then begin
        // Close to my left edge
        Result := geLeft;
    end
    else if ((movingRect.Right >= (stationaryRect.Left - glueRange)) and
            (movingRect.Right <= (stationaryRect.Left + glueRange)) and
            (movingRect.Top <= (stationaryRect.Top + glueRange)) and
            (movingRect.Top >= (stationaryRect.Top - glueRange))) then begin
        // Close to my right edge
        Result := geRight;
    end
    else if ((movingRect.Top <= (stationaryRect.Bottom + glueRange)) and
            (movingRect.Top >= (stationaryRect.Bottom - glueRange)) and
            (movingRect.Left <= (stationaryRect.Left + glueRange)) and
            (movingRect.Left >= (stationaryRect.Left - glueRange))) then begin
        // Close to my top edge
        Result := geTop;
    end
    else if ((movingRect.Bottom >= (stationaryRect.Top - glueRange)) and
            (movingRect.Bottom <= (stationaryRect.Top + glueRange)) and
            (movingRect.Left <= (stationaryRect.Left + glueRange)) and
            (movingRect.Left >= (stationaryRect.Left - glueRange))) then begin
        // Close to my bottom edge
        Result := geBottom;
    end
    else begin
        // Not close enough to anything
        Result := geNone;
    end;
end;

{---------------------------------------}
function CheckWindowFullyVisibleOnScreen(WndHandle: HWnd): HWnd;
var
    Wnd: HWnd;
    rect: TRect;
    myRect: TRect;
    pWP: PWindowPlacement;
begin
    // Check for windows in front of passed in one
    // Return HWND of first covering window if even partially covered.
    // Return 0 if not covered.
    Result := 0;

    if (WndHandle = 0) then exit;

    try
        if (GetWindowRect(WndHandle, myRect)) then begin
            wnd := GetWindow(WndHandle, GW_HWNDPREV);
            while (wnd <> 0) do begin
                if (GetWindowRect(wnd, rect)) then begin
                    // Is the left of a window within my left and right OR
                    // is the right of a window within my left and right
                    if (((rect.Left >= myRect.Left) and
                         (rect.Left <= myRect.Right)) or
                        ((rect.right >= myRect.Left) and
                        (rect.right <= myRect.Right))) then begin
                        // Yes, left or right overlaps within our window.

                        // Now is the top of a window within my top and bottom OR
                        // Is the bottom of a window within my top and bottom
                        if (((rect.top >= myRect.top) and
                            (rect.top <= myRect.bottom)) or
                            ((rect.bottom >= myRect.top) and
                            (rect.bottom <= myRect.bottom))) then begin
                            // Yes, we over lap on top or bottom.
                            GetMem(pWP, SizeOf(WindowPlacement));
                            if (GetWindowPlacement(wnd, pWP)) then begin
                                if ((pWP.showCmd = SW_MAXIMIZE) or
                                    (pWP.showCmd = SW_RESTORE) or
                                    (pWP.showCmd = SW_SHOW) or
                                    (pWP.showCmd = SW_SHOWMAXIMIZED) or
                                    (pWP.showCmd = SW_SHOWNA) or
                                    (pWP.showCmd = SW_SHOWNOACTIVATE) or
                                    (pWP.showCmd = SW_SHOWNORMAL)) then begin
                                    // In a "showing" state so return
                                    // window handle as confirmation that
                                    // we are at least partially obscured.
                                    Result := wnd;
                                    FreeMem(pWP);
                                    exit;
                                end;
                            end;
                            FreeMem(pWP);
                        end;
                    end;
                end;
                wnd := GetWindow(wnd, GW_HWNDPREV);
            end;
        end;
    except
    end;
end;

end.
