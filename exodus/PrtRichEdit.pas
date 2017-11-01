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
unit PrtRichEdit;


interface

uses
  ComCtrls, Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, RichEdit, ExtCtrls, Printers;

type
  TPageOffset = record
  mStart,mEnd: Integer;
  rendRect: TRect;
  end;

procedure PrintRichEdit(const Caption: string;
                        const RichEdt: TRichEdit;
                        const nCopies: Integer;
                        const prRange: TPrintRange);

procedure PrintAllRichEdit(const Caption: string;
                           const RichEdt: TRichEdit;
                           const nCopies: Integer);


procedure PrintSelRichEdit(const Caption: string;
                           const RichEdt: TRichEdit;
                           const nCopies: Integer);

implementation



procedure PrintAllRichEdit(const Caption: string;
                           const RichEdt: TRichEdit;
                           const nCopies: Integer);
var
  wPage, hPage, xPPI, yPPI, wTwips, hTwips: integer;
  pageRect, rendRect: TRect;
  po: TPageOffset;
  fr: TFormatRange;
  lastOffset, currPage, pageCount: integer;
  xOffset, yOffset: integer;
  FPageOffsets: array of TPageOffset;
  firstPage: boolean;
begin
  //First, get the size of a printed page in printer device units
  wPage := GetDeviceCaps(Printer.Handle, PHYSICALWIDTH);
  hPage := GetDeviceCaps(Printer.Handle, PHYSICALHEIGHT);

  //Next, get the device units per inch for the printer
  xPPI := GetDeviceCaps(Printer.Handle, LOGPIXELSX);
  yPPI := GetDeviceCaps(Printer.Handle, LOGPIXELSY);

  //Convert the page size from device units to twips
  wTwips := MulDiv(wPage, 1440, xPPI);
  hTwips := MulDiv(hPage, 1440, yPPI);

  //Save the page size in twips
  with pageRect do
  begin
    Left := 0;
    Top := 0;
    Right := wTwips;
    Bottom := hTwips
  end;

  //Next, calculate the size of the rendering rectangle in twips
  //Rememeber - 1 inch margins are hardcoded, so the below code
  //reduces the width of the output by 2 inches
  with rendRect do
  begin
    Left := 0;
    Top := 0;
    Right := pageRect.Right - (1440 * 2);
    Bottom := pageRect.Bottom - (1440 * 2)
  end;

  //Define a single page and set starting offset to zero
  po.mStart := 0;
  //Define and initialize a TFormatRange structure. This structure is passed
  //to the TRichEdit with a request to format as much text as will fit on a
  //page starting with the chrg.cpMin offset and ending with the chrg.cpMax.
  //Initially, we tell the RichEdit control to start at the beginning
  //(cpMin = 0) and print as much as possible (cpMax = -1). We also tell it
  //to render to the printer
  with fr do
  begin
    hdc := Printer.Handle;
    hdcTarget  := Printer.Handle;
    chrg.cpMin := po.mStart;
    chrg.cpMax := -1;
  end;

  //In order to recognize when the last page is rendered, we need to know how
  //much text is in the control.
  lastOffset := SendMessage(RichEdt.Handle, WM_GETTEXTLENGTH, 0, 0);

  //As a precaution, clear the formatting buffer
  SendMessage(RichEdt.Handle, EM_FORMATRANGE, 0, 0);

  //Printers frequently cannot print at the absolute top-left position on the
  //page. In other words, there is usually a minimum margin on each edge of the
  //page. When rendering to the printer, RichEdit controls adjust the top-left
  //corner of the rendering rectangle for the amount of the page that is
  //unprintable. Since we are printing with two-inch margins, we are presumably
  //already within the printable portion of the physical page.
  SaveDC(fr.hdc);
  SetMapMode(fr.hdc, MM_TEXT);
  xOffset := GetDeviceCaps(Printer.Handle, PHYSICALOFFSETX);
  yOffset := GetDeviceCaps(Printer.Handle, PHYSICALOFFSETY);
  xOffset := xOffset + MulDiv(1440, xPPI, 1440);
  yOffset := yOffset + MulDiv(1440, yPPI, 1440);
  SetViewportOrgEx(fr.hdc, xOffset, yOffset, nil);

  //Now we build a table of page entries, one entry for each page that would be
  //printed.
  while ((fr.chrg.cpMin <> -1) and (fr.chrg.cpMin < lastOffset)) do
  begin
    fr.rc := rendRect;
    fr.rcPage := pageRect;
    po.mStart := fr.chrg.cpMin;
    fr.chrg.cpMin := SendMessage(RichEdt.Handle, EM_FORMATRANGE, 0, Longint(@fr));
    po.mEnd := fr.chrg.cpMin - 1;
    po.rendRect := fr.rc;
    if High(FPageOffsets) = -1 then SetLength(FPageOffsets, 1)
    else
      SetLength(FPageOffsets, Length(FPageOffsets) + 1);
    FPageOffsets[High(FPageOffsets)] := po
  end;
  // pgm: pageCount := Length(FPageOffsets);
  SendMessage(RichEdt.Handle, EM_FORMATRANGE, 0, 0);
  RestoreDC(fr.hdc, - 1);

  //Now, we are almost ready to actually print.
  Printer.Title := Caption;
  Printer.Copies := nCopies;
  Printer.BeginDoc;
  fr.hdc := Printer.Handle;
  fr.hdcTarget := Printer.Handle;
  SaveDC(fr.hdc);
  SetViewportOrgEx(fr.hdc, xOffset, yOffset, nil);
  //Ok, here we go to print
  firstPage := True;
  //At this point you can select from page and to page
  currPage := 0;  //Print from the first page
  pageCount := High(FPageOffsets);  
  while (currPage < pageCount) do
  begin
    if firstPage then firstPage := False
    else
      Printer.NewPage;
    SetViewportOrgEx(fr.hdc, xOffset, yOffset, nil);
    fr.rc := FPageOffsets[currPage].rendRect;
    fr.rcPage := pageRect;
    fr.chrg.cpMin := FPageOffsets[currPage].mStart;
    fr.chrg.cpMax := FPageOffsets[currPage].mEnd;
    fr.chrg.cpMin := SendMessage(RichEdt.Handle, EM_FORMATRANGE, 1, Longint(@fr));
    Inc(currPage);
  end;

  //At this point, we have finished rendering the contents of the RichEdit
  //control. Now we restore the printer's HDC settings and tell Windows that
  //we are through printing this document
  RestoreDC(fr.hdc, - 1);
  Printer.EndDoc;

  //Finally, we clear the RichEdit control's formatting buffer and delete
  //the saved page table information
  fr.chrg.cpMin := SendMessage(RichEdt.Handle, EM_FORMATRANGE, 0, 0);
  Finalize(FPageOffsets);
  //That's it

end;


procedure PrintRichEdit(const Caption: string;
                        const RichEdt: TRichEdit;
                        const nCopies: Integer;
                        const prRange: TPrintRange);
var
  printarea: TRect;
  richedit_outputarea: TRect;
  printresX, printresY, pageNum: Integer;
  fmtRange: TFormatRange;
  nextChar: Integer;
  S,timeStr,headerStr: string;
begin
  Printer.Title := Caption;
  Printer.Copies := nCopies;
  Printer.BeginDoc;
  DateTimeToString(timeStr,'mm/dd/yyyy hh:mm:ss',Now());
  
  try
    with Printer.Canvas do
    begin
      printresX := GetDeviceCaps(Handle, LOGPIXELSX);
      printresY := GetDeviceCaps(Handle, LOGPIXELSY);
      printarea :=
        Rect(printresX,  // 1 inch left margin
        printresY * 3 div 2,  // 1.5 inch top margin
        Printer.PageWidth - printresX, // 1 inch right margin
        Printer.PageHeight - printresY * 3 div 2); // 1.5 inch Bottom Margin

      // Define a rectangle for the rich edit text. The height is set to the
      // maximum. But we need to convert from device units to twips,
      // 1 twip = 1/1440 inch or 1/20 point.
      richedit_outputarea :=
        Rect(printarea.Left * 1440 div printresX,
        printarea.Top * 1440 div printresY,
        printarea.Right * 1440 div printresX,
        printarea.Bottom * 1440 div printresY);

      // Tell rich edit to format its text to the printer. First set
      // up data record for message:
      fmtRange.hDC := Handle;            // printer handle
      fmtRange.hdcTarget := Handle;     // ditto
      fmtRange.rc := richedit_outputarea;
      fmtRange.rcPage := Rect(0, 0,
        Printer.PageWidth * 1440 div printresX,
        Printer.PageHeight * 1440 div printresY);
      //
      if ( prRange = prAllPages ) then begin
       RichEdt.SelectAll();
      end;

      fmtRange.chrg.cpMin := RichEdt.selStart;
      fmtRange.chrg.cpMax := RichEdt.selStart + RichEdt.selLength;

      // remove characters that need not be printed from end of selection.
      // failing to do so screws up the repeat loop below.
      if ( prRange = prSelection ) then begin
        S := RichEdt.SelText;
        while (fmtRange.chrg.cpMax > 0) and
          (S[fmtRange.chrg.cpMax] <= ' ') do Dec(fmtRange.chrg.cpMax);
      end;

      pageNum := 1;
      repeat
        // Render the text
        headerStr := Caption + ' ' + timeStr + ' - Page No: ' + IntToStr(pageNum);
        Printer.Canvas.TextOut(40,20,headerStr );
        nextChar := SendMessage(RichEdt.Handle,EM_FORMATRANGE, 1, Longint(@fmtRange));
        if nextchar < fmtRange.chrg.cpMax then
        begin
          // more text to print
          printer.newPage;
          Inc(pageNum);
          fmtRange.chrg.cpMin := nextChar;
        end; { If }
      until nextchar >= fmtRange.chrg.cpMax;

      // Free cached information
      SendMessage(RichEdt.Handle,EM_FORMATRANGE, 0, 0);
      if ( prRange = prAllPages ) then begin
        RichEdt.SelStart := 0;
        RichEdt.SelLength := 0;
      end;

    end;
  finally
    Printer.EndDoc;
  end;
end;

procedure PrintSelRichEdit(const Caption: string;
                           const RichEdt: TRichEdit;
                           const nCopies: Integer);
var
  printarea: TRect;
  richedit_outputarea: TRect;
  printresX, printresY: Integer;
  fmtRange: TFormatRange;
  nextChar: Integer;
  S: string;
begin
  Printer.Title := Caption;
  Printer.Copies := nCopies;
  Printer.BeginDoc;
  
  try
    with Printer.Canvas do
    begin
      printresX := GetDeviceCaps(Handle, LOGPIXELSX);
      printresY := GetDeviceCaps(Handle, LOGPIXELSY);
      printarea :=
        Rect(printresX,  // 1 inch left margin
        printresY * 3 div 2,  // 1.5 inch top margin
        Printer.PageWidth - printresX, // 1 inch right margin
        Printer.PageHeight - printresY * 3 div 2); // 1.5 inch Bottom Margin

      // Define a rectangle for the rich edit text. The height is set to the
      // maximum. But we need to convert from device units to twips,
      // 1 twip = 1/1440 inch or 1/20 point.
      richedit_outputarea :=
        Rect(printarea.Left * 1440 div printresX,
        printarea.Top * 1440 div printresY,
        printarea.Right * 1440 div printresX,
        printarea.Bottom * 1440 div printresY);

      // Tell rich edit to format its text to the printer. First set
      // up data record for message:
      fmtRange.hDC := Handle;            // printer handle
      fmtRange.hdcTarget := Handle;     // ditto
      fmtRange.rc := richedit_outputarea;
      fmtRange.rcPage := Rect(0, 0,
        Printer.PageWidth * 1440 div printresX,
        Printer.PageHeight * 1440 div printresY);
      // set range of characters to print to selection
      fmtRange.chrg.cpMin := RichEdt.selstart;
      fmtRange.chrg.cpMax := RichEdt.selStart + RichEdt.sellength - 1;

      // remove characters that need not be printed from end of selection.
      // failing to do so screws up the repeat loop below.
      S := RichEdt.SelText;
      while (fmtRange.chrg.cpMax > 0) and
        (S[fmtRange.chrg.cpMax] <= ' ') do Dec(fmtRange.chrg.cpMax);

      repeat
        // Render the text
        nextChar := SendMessage(RichEdt.Handle,EM_FORMATRANGE, 1, Longint(@fmtRange));
        if nextchar < fmtRange.chrg.cpMax then
        begin
          // more text to print
          printer.newPage;
          fmtRange.chrg.cpMin := nextChar;
        end; { If }
      until nextchar >= fmtRange.chrg.cpMax;

      // Free cached information
      SendMessage(RichEdt.Handle,EM_FORMATRANGE, 0, 0);
    end;
  finally
    Printer.EndDoc;
  end;
end;

end.