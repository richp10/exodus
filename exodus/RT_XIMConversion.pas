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
unit RT_XIMConversion;

{
    Convert rich text to and from xhtml-im.
}
interface
uses
{$IFNDEF EXODUS}
    Exodus_TLB,
{$ENDIF}
    XMLTag,
    ExRichEdit;


    {
        Convert the contents of the given RT component to an XHTML-IM tag.
    }
    function RTToXIM(rtSource: TExRichEdit): TXMLTag;

    {
      populate the given rt with the given xhtml-im.
      Starts at current selection point and populates the rt with cdata, changing
      selection font as needed. }
{$IFDEF EXODUS}
    procedure XIMToRT(rtDest: TexRichEdit; xhtmlTag: TXMLTag; plaintext: WideString = ''; ignoreFontProps: boolean = true);
{$ELSE}
    procedure XIMToRT(controller: IExodusController; rtDest: TexRichEdit; xhtmlTag: TXMLTag; plaintext: WideString = ''; ignoreFontProps: boolean = true);
{$ENDIF}


    {
    Remove any tags, attributes and style properties we do not handle.

    "Ignores" as specified by JEP-71, by moving any cdata in an unknown tag
    to its parent.
    }
{$IFDEF EXODUS}
    function cleanXIMTag(xhtmlTag: TXMLTag; cleanIgnoredProps: boolean = true; cleanProprietaryProps: boolean = true): TXMLTag;
{$ELSE}
    function cleanXIMTag(controller: IExodusController; xhtmlTag: TXMLTag; cleanIgnoredProps: boolean = true; cleanProprietaryProps: boolean = true): TXMLTag;
{$ENDIF}

implementation
uses
{$IFDEF EXODUS}
    ExUtils,
    Session,
{$ENDIF}
    SysUtils,
    COMCtrls,
    StdCtrls,
    ExtCtrls,
    Classes,
    Graphics,
    Windows,
    XMLConstants,
    XMLCData,
    RichEdit2,
    JabberConst,
    Emote;

const
    NBSP: WideChar = #160;

    
{  Bunch of helper functions }

{--------------------------------------}
{thought this was going to do more, TXMLtag escapes everything for us}
function escapeChar(Ch: WideChar): WideString;
begin
    if (ch = #0) then
        Result := ''
    else if (ch = #11) then
        Result := ''
    else Result := ch;
end;

function escapeCData(inStr: WideString): WideString;
begin
    Result := '';
    //replace significant white space with NBSP
    if (Length(instr) > 0) then begin
        if (instr[1] = ' ') then
            Result := NBSP
        else
            Result := instr[1];
        Result := Result + Copy(InStr, 2, Length(InStr) - 2);
        if (Length(inStr) <> 1) then begin
            if (instr[Length(inStr)] = ' ') then
                Result := Result + NBSP
            else
                Result := Result + instr[Length(InStr)];
        end;
    end
end;

function getRGBStr(c: TColor): WideString;
var
    ci: Integer;
begin
    ci := ColorToRGB(c);
    Result := '#' + IntToHex(GetRValue(ci), 2) + IntToHex(GetGValue(ci), 2) + IntToHex(GetBValue(ci), 2);
end;

function getColor(cStr: WideString): TColor;
var
  R, G, B: Byte;
begin
    R := 0;G := 0;B := 0;
    try
        R := StrToInt('$' + Copy(cStr, 2, 2));
        G := StrToInt('$' + Copy(cStr, 4, 2));
        B := StrToInt('$' + Copy(cStr, 6, 2));
    except
    end;
    Result := RGB(R, G, B);
end;

function getRelativeSize(points: integer): WideString;
begin
    if (points <= 8) then Result :='xx-small'
    else if (points = 9) then Result:= 'x-small'
    else if ((points >= 10) and (points <= 13)) then Result := 'small'
    else if ((points >= 14) and (points <= 16)) then Result := 'medium'
    else if ((points >= 17) and (points <= 20)) then Result := 'large'
    else if ((points >= 21) and (points <= 23)) then Result := 'x-large'
    else Result := 'xx-large';
end;

function getPointSize(rel: WideString): integer;
begin
    if (rel = 'xx-small') then
        Result := 7
    else if (rel = 'x-small') then
        Result := 9
    else if (rel = 'small') then
        Result := 13
    else if (rel = 'large') then
        Result := 18
    else if (rel = 'x-large') then
        Result := 22
    else if (rel = 'xx-large') then
        Result := 27
    else
        Result := 16; //medium
end;

{--------------------------------------}
{are these two fonts equal in all things we care about?}
function isEqual(f1, f2: TFont): boolean;
begin
    Result := (f1.Name = f2.Name) and
              (f1.Color = f2.Color) and
              (f1.Style = f2.style) and
              (f1.size= f2.Size);
end;

{--------------------------------------}
procedure assignFont(d: TFont; s: TTextAttributes98);
begin
    d.Name := s.Name;
    d.Color := s.Color;
    d.Size := s.Size;
    d.Style := [];
    d.Pitch := s.Pitch;
    if (s.Bold) then
        d.Style := d.Style + [fsBold];
    if (s.Italic) then
        d.Style := d.Style + [fsItalic];
    if (s.UnderlineType <> ultNone) then
        d.Style := d.Style + [fsUnderline];
    if (s.StrikeOut) then
        d.Style := d.Style + [fsStrikeOut];
end;

{ Assign font from thbe given text attribute. Found a buug
  in RichEdit2's assignment code (bad typecast) so implementing
  this here}
procedure assignTextAttribute(d: TTextAttributes98; s: TFont);
begin
    d.Name := s.Name;
    d.Color := s.Color;
    d.Size := s.Size;
    d.Bold := (fsBold in s.Style);
    d.Italic := (fsItalic in s.Style);
    if (fsUnderline in s.Style) then
        d.UnderlineType := ultSingle
    else
        d.UnderlineType := ultNone;
end;

{--------------------------------------}
{some functions to get ccs styles from fonts}
function getStyleStyle(f: TFont): WideString;
begin
    Result := '';
    if (fsBold in f.style) then begin
        Result := Result + 'font-weight:bold;';
    end;
    if (fsItalic in f.style) then begin
        Result := Result + 'font-style:italic;';
    end;
    if (fsUnderline in f.style) then begin
        Result := Result + 'text-decoration:underline;';
    end;
end;

{--------------------------------------}
function getFontStyle(f: TFont): WideString;
begin
    Result := 'color:' + getRGBStr(f.Color) + ';';
end;

function getStyleAttrib(f: TFont): WideString;
begin
    Result := getStyleStyle(f);
    if (Result <> '') then
        Result := ';' + Result;

    Result := Result + getFontStyle(f);
end;


{--------------------------------------}
{
    Get a style attribute for the differences between the two fonts.

    These styles have a parent child relationship, what sytle differences exist
    between a child span tag and its parent.
}
Function getDiffedStyle(childFont, parentFont: TFont): WideString;
begin
    if (parentFont = nil) then
        Result := getStyleAttrib(childFont)
    else begin
        Result := '';
        if (childFont.Color <> parentFont.Color) then
            Result := Result + 'color:' + getRGBStr(childFont.Color) + ';';
        if (childFont.Style <> parentFont.style) then begin

            if ((fsBold in childFont.Style) and not (fsBold in parentFont.Style)) then
                Result := Result + 'font-weight:bold;'
            else if ((not(fsBold in childFont.Style)) and (fsBold in parentFont.Style)) then
                Result := Result + 'font-weight:normal;';

            if ((fsItalic in childFont.Style) and not (fsItalic in parentFont.Style)) then
                Result := Result + 'font-style:italic;'
            else if ((not(fsItalic in childFont.Style)) and (fsItalic in parentFont.Style)) then
                Result := Result + 'font-style:normal;';

            if ((fsUnderline in childFont.Style) and not (fsUnderline in parentFont.Style)) then
                Result := Result + 'text-decoration:underline;'
            else if ((not(fsUnderline in childFont.Style)) and (fsUnderline in parentFont.Style)) then
                Result := Result + 'text-decoration:none;';
        end;
    end;
end;

{--------------------------------------}
{
    Get the best root for the given fonts.

    If the given fonts differ creates a new child of root and assigns the
    correct style (the diff between parent and child). If there is no
    difference in styles, returns the root. 
}
function addSpanTag(childFont, parentFont: TFont; root: TXMLtag): TXMLtag;
var
    tstr: WideString;
begin
    Result := TXMLtag.create('span');

    tstr := getDiffedStyle(childFont, parentFont);

    if (tstr = '') then begin
        Result.free();
        Result := root;
    end
    else begin
        if (tstr[Length(tstr)] = ';') then
            setLength(tstr, Length(tstr) - 1);
        root.AddTag(Result).setAttribute('style', tstr);
    end;
end;


{--------------------------------------}
function RTToXIM(rtSource: TExRichEdit): TXMLTag;

var
  currSelPos: Integer;
  currFont, defaultFont, testFont: TFont;
  outerTag: TXMLtag;
  currTag: TXMLTag;
  currCData: WideString;
  tstr: WideString;
  allTxt: WideString;
begin
  Result := TXMLTag.Create('html');
  Result.setAttribute('xmlns', XMLNS_XHTMLIM);
  outerTag := Result.AddTagNS('body', XMLNS_XHTML);
  //empty body if no text
  if (Length(WideString(rtSource.WideLines.GetText)) = 0) then exit;

  outerTag := outerTag.AddTag('p');
  currFont := TFont.Create;
  testFont := TFont.Create;
  defaultFont := TFont.Create;

  rtSource.Lines.BeginUpdate;
  try
    assignFont(defaultFont, rtSource.DefAttributes);
    assignFont(currFont, rtSource.DefAttributes);

    tstr :=  getStyleAttrib(defaultFont);
    if (tstr[Length(tstr)] = ';') then
      setLength(tstr, Length(tstr) - 1);

    currTag := outerTag;
    currSelPos := 1;
    currCData := '';
    allTxt := rtSource.WideText;
{$IFDEF EXODUS}
    ExUtils.DebugMsg('rt: ' + tstr);
{$ENDIF}
    while(currSelPos <= Length(allTxt)) do begin
      if ((allTxt[currSelPos] = #13) or // Carriage Return
          (allTxt[currSelPos] = #11)) then begin // Vertical Tab (Shift-Return)
        //emit a break;
        currTag.AddCData(currCData);
        currCData := '';
        currTag.addTag('br');
      end;
      //select the current character, and check style, emit tags when changing
      rtSource.SelStart := currSelPos - 1; //0 based
      rtSource.SelLength := 1;
      AssignFont(testFont, rtSource.SelAttributes);
      //check to see if any font property we handle has changed
      if (not isEqual(testFont, currFont)) then begin
        //differing fonts, change tag
        if (currCData <> '') then
          currTag.AddCData(escapeCData(currCData))
        else if ((currTag <> outerTag) and (currTag.ChildCount = 0)) then
          outerTag.RemoveTag(currTag); //empty tag

        currCData := '';
        currFont.Assign(testFont);
        currTag := AddSpanTag(currFont, defaultFont, outerTag);
      end;
      currCData := currCData + escapeChar(allTxt[currSelPos]);
      inc(currSelPos);
    end;

    if (currCData <> '') then
      currTag.AddCData(escapeCData(currCData));
  finally
    rtSource.Lines.EndUpdate;
    currFont.Free;
    testFont.Free;
    defaultFont.Free;
  end;
end;

const
    goodTags: array[0..6] of WideString = ('br','span','p', 'body', 'html', 'a', 'div');
    goodAttribs: array[0..2] of WideString = ('style', 'xmlns', 'href');
    goodStyleProps: array[0..5] of WideString =('font-family',
                                                'font-size',
                                                'color',
                                                'font-weight',
                                                'font-style',
                                                'text-decoration');
    proprietaryStyleProps: array[0..0] of WideString = ('ex-font-size');
    proprietaryIgnoredStyleProps: array[0..0] of WideString = ('');

type
    TslObject = class
        str: WideString;
        public
        constructor create(s: WideString);
    end;

constructor TslObject.create(s: WideString);
begin
    inherited create;
    str := s;
end;

procedure ParseStyleProps(const sl : TStringList; const props : WideString);
var
    nextDeliim : integer;
    oneProp : widestring;
    OneKey: WideString;
    oneValue: TslObject;
    leftoverProps : widestring;
begin
    leftoverProps := props + ';';
    sl.BeginUpdate;
    sl.Clear;
    try
        while Length(leftoverProps) > 1 do begin
            nextDeliim := Pos(';', leftoverProps);
            oneProp := Copy(leftoverProps,0,nextDeliim-1) ;
            oneKey := Trim(lowerCase(Copy(oneProp,0,Pos(':', oneProp) - 1)));
            oneValue := TslObject.create(Trim(Copy(oneProp,Pos(':', oneProp) + 1, Length(oneProp))));
            sl.AddObject(oneKey, oneValue);
            leftoverProps := Copy(leftoverProps,nextDeliim+1,MaxInt) ;
        end;
    finally
        sl.EndUpdate;
    end;
end;

function getFontFromNode(node: TXMLTag; defaultFont: TFont = nil): TFont;
var
    styleProps: WideString;
    props: TStringList;
    idx: integer;
    oneValue : WideString;
    oneProp: WideString;
    exSizeExists: boolean;
    i: Integer;
begin
    Result := nil;
    exSizeExists := false;
    styleProps := node.GetAttribute('style');
    if (styleProps <> '') then begin
        Result := TFont.Create;
        if (defaultFont <> nil) then
            Result.Assign(defaultFont);
        props := TStringList.Create();
        parseStyleProps(props, styleProps);
        for idx := 0 to props.Count - 1 do begin
            oneProp := props[idx];
            oneValue := TslObject(props.Objects[idx]).str;

            if (oneProp = 'font-family') then begin
                Result.Name := oneValue;
            end
            else if (not exSizeExists) and (oneProp = 'font-size') then begin
                Result.Size := getPointSize(oneValue);
            end
            else if (oneProp = 'ex-font-size') then begin
                exSizeExists := true;
                Result.Size := StrToInt(oneValue);
            end
            else if (oneProp = 'color') then begin
                Result.Color := GetColor(oneValue);
            end
            else if (oneProp = 'font-weight') then begin
                if (oneValue = 'bold') then
                    Result.Style := Result.Style + [fsBold]
                else if (oneValue = 'normal') then
                    Result.Style := Result.Style - [fsBold]
            end
            else if (oneProp = 'font-style') then begin
                if (oneValue = 'italic') then
                    Result.Style := Result.Style + [fsItalic]
                else if (oneValue = 'normal') then
                    Result.Style := Result.Style - [fsItalic]
            end
            else if (oneProp = 'text-decoration') then begin
                if (oneValue = 'underline') then
                    Result.Style := Result.Style + [fsUnderline]
                else if (oneValue = 'none') then
                    Result.Style := Result.Style - [fsUnderline]
            end
        end;
        for i := props.Count - 1 downto 0 do begin
            TslObject(props.Objects[i]).Free;
            props.Delete(i);
        end;
        props.Free();
    end;
end;

function inList(list: array of WideString; key: WideString): boolean;
var
    idx: Integer;
begin
    Result := false; 
    for idx := Low(list) to High(list) do
        if (list[idx] = key) then begin
            Result := true;
            break;
        end;
end;

function isGoodTag(tag: TXMLtag): boolean;
begin
    Result := inList(goodTags, tag.Name);
end;

procedure filterStyleProps(node: TXMLtag; ignoredFontStyles: WideString; cleanProprietaryProps: boolean = true);
var
    propsStr: WideString;
    props: TStringList;
    idx: integer;
    tstr: wideString;
    goodProp: boolean;
begin
    props := TStringList.Create();
    propsStr := node.GetAttribute('style');
    parseStyleProps(props, propsStr);
    //remove any props we don't support
    tstr := '';
    for idx := 0 to props.Count - 1 do begin
        //add if an allowed style and we are not ignoring it
        goodProp := (inList(goodStyleProps, props[idx]) or
                     (not cleanProprietaryProps and inList(proprietaryStyleProps, props[idx])));
        if ((goodProp) and (Pos(props[idx] + ';', ignoredFontStyles) = 0)) then
            tstr := tstr + props[idx] + ':' + TslObject(props.Objects[idx]).str + ';';
        //free damn object
        TslObject(props.Objects[idx]).Free;
    end;

    if (tstr <> '') then begin
        if (tstr[Length(tstr)] = ';') then
            setLength(tstr, Length(tstr) - 1);
        node.setAttribute('style', tstr);
    end
    else node.removeAttribute('style');
    props.Free;
end;

procedure filterAttribs(node: TXMLtag);
var
    idx: integer;
begin
    idx := 0;
    while (idx < node.Attributes.Count) do begin
        if (not inList(goodAttribs, node.Attributes.Name(idx))) then
            node.removeAttribute(node.Attributes.Name(idx))
        else inc(idx);
    end;
end;

procedure filterTags(node: TXMLTag; ignoredFontStyles: WideString; cleanProprietaryProps: boolean = true);
var
    idx: integer;
begin
    if (node.ChildCount > 0) then begin
        for idx := 0 to node.Nodes.Count - 1 do begin
            if (TXMLTag(node.Nodes[idx]).IsTag) then
                filterTags(TXMLTag(node.Nodes[idx]), ignoredFontStyles, cleanProprietaryProps);
        end;
    end;
    if (not inList(goodTags, node.Name)) then begin
        node.name := 'span'; //unknown tags become spans
    end;

    filterAttribs(node);
    filterStyleProps(node, ignoredFontStyles, cleanProprietaryProps);
end;

{
    Remove any tags, attributes and style properties we do not handle.

    "Ignores" as specified by JEP-71, by moving any cdata in an unknown tag
    to its parent.
}
{$IFDEF EXODUS}
function cleanXIMTag(xhtmlTag: TXMLTag; cleanIgnoredProps: boolean = true; cleanProprietaryProps: boolean = true): TXMLTag;
{$ELSE}
function cleanXIMTag(controller: IExodusController; xhtmlTag: TXMLTag; cleanIgnoredProps: boolean = true; cleanProprietaryProps: boolean = true): TXMLTag;
{$ENDIF}
var
    tstr: WideString;
begin
{$IFDEF EXODUS}
DebugMsg('xim cleanTags orig: ' + xhtmlTag.XML, true);
{$ENDIF}
{$IFNDEF EXODUS}
    assert(controller <> nil);
{$ENDIF}
    Result := TXMLtag.create(xhtmlTag); //copy for cleaning
    tstr := '';

    if (cleanIgnoredProps) then begin
{$IFDEF EXODUS}
        tstr := MainSession.Prefs.getString('richtext_ignored_font_styles');
{$ELSE}
        tstr := controller.getPrefAsString('richtext_ignored_font_styles');
{$ENDIF}
    end;
    filterTags(Result, tstr, cleanProprietaryProps);
{$IFDEF EXODUS}
DebugMsg('cleaned: ' + Result.XML, true);
{$ENDIF}
end;

{---------------------------------------}
procedure ReplaceEmoticons(rtDest: TExRichEdit; matchingStr: WideString);
var
    m: boolean;
    ms: Widestring;
    rtf: string;
    lm: integer;
    currFont: TFont;
Begin
    m := emoticon_regex.Exec(matchingStr);
    lm := 0;
    currFont := TFont.Create();
    AssignFont(currFont, rtDest.SelAttributes);
    while(m) do begin
        lm := emoticon_regex.MatchPos[0] + emoticon_regex.MatchLen[0];
        rtDest.SelStart := Length(rtDest.WideLines.Text);
        rtDest.SelLength := 0;
        rtDest.WideSelText := emoticon_regex.Match[1]; //text before emoticon

        rtDest.SelStart := Length(rtDest.WideLines.Text);
        rtDest.SelLength := 0;

        // we have a match
        rtf := '';
        // Grab the match text and look it up in our emoticon list
        ms := emoticon_regex.Match[2];
        if (ms <> '') then begin
            rtf := EmoticonList.getRTF(ms);
        end;

        // if we have a legal emoticon object, insert it..
        // otherwise insert the matched text
        if (rtf <> '') then begin
            rtDest.RTFSelText := rtf;
        end
        else
            rtDest.WideSelText := ms;

        rtDest.SelStart := Length(rtDest.WideLines.Text);
        rtDest.SelLength := 0;
        assignTextAttribute(rtDest.SelAttributes, currFont); //

        rtDest.WideSelText := emoticon_regex.Match[6];

        // Search for the next emoticon
        m := emoticon_regex.ExecNext();

        // do a sanity check here, probably because the regex prolly isn't
        // _REALLY_ widestr compliant
        if (m) then begin
            if (length(matchingStr) < emoticon_regex.MatchPos[0]) then
                m := false;
        end;
    end;
    if (lm <= length(matchingStr)) then begin
        // we have a remainder
        rtDest.SelStart := Length(rtDest.WideLines.Text);
        rtDest.SelLength := 0;

        rtDest.WideSelText := Copy(matchingStr, lm, length(matchingStr) - lm + 1);
    end;
    currFont.Free();
end;

function ReplaceNBSP(instring: Widestring): Widestring;
var
    nbsppos: integer;
begin
    Result := instring;
    nbsppos := POS(NBSP, Result);
    while (nbsppos > 0) do begin
        Result[nbsppos] := ' ';
        nbsppos := POS(NBSP, Result);
    end;
end;

procedure handleCData(rtDest: TExRichEdit; node: TXMLTag; handleEmoticons: boolean = false);
var
    s: widestring;
begin
    rtDest.SelStart := Length(rtDest.WideLines.Text);
    rtDest.SelLength := 0;

    // Clear out any non-breaking spaces as RTF cannot handle them
    s := ReplaceNBSP(TXMLCData(node).Data);

    // Check to see if we found an emoticon
    if (handleEmoticons) then
        ReplaceEmoticons(rtDest, s)
    else
        rtDest.WideSelText := s;
end;

procedure handleNode(rtDest: TexRichEdit; node: TXMLTag; handleEmoticons: boolean = false; isMe : boolean = false);
var
    newFont: TFont;
    currFont: TFont;
    idx: Integer;
begin
    if (node.NodeType = xml_CDATA)then begin
        handleCData(rtDest, node, handleEmoticons);
    end
    else if (node.NodeType = xml_tag) then begin
        if (node.Name = 'a') then begin
            //emit the href, use cdata if its there
            rtDest.SelStart := Length(rtDest.WideLines.Text);
            rtDest.SelLength := 0;
            if (trim(Node.data) <> '') then
                rtDest.WideSelText := node.Data + ' (' + node.GetAttribute('href') + ')'
            else rtDest.WideSelText := ' ' + node.GetAttribute('href') + ' ';
        end
        else if (node.Name = 'br') then begin
            rtDest.SelStart := Length(rtDest.WideLines.Text);
            rtDest.SelLength := 0;
            rtDest.WideSelText := #13#10;
        end
        else begin
            currFont := TFont.Create;
            try
                AssignFont(currFont, rtDest.SelAttributes);
                newFont := getFontFromNode(node, currFont);
                if (newFont <> nil) then begin
                    currFont.Free; // We are replacing this with newFont.
                    currFont := newFont; //setup for text attrib assignment before
                end;
                //If me, then set default font size to my rich edit font
                //IsMe passed with negation as arument, so need to use not 
                if (not isMe) then
                    currFont.Size := rtDest.SelAttributes.Size;
                //pre process, newline for paragraphs for example
                if ((node.Name = 'p') or (node.Name = 'div')) then begin
                    rtDest.SelStart := Length(rtDest.WideLines.Text);
                    rtDest.SelLength := 0;
                    rtDest.RTFSelText := '{\rtf1 \par }';//new paragraph
                end;
                //iterate over our children
                for idx := 0 to node.Nodes.Count - 1 do begin
                    assignTextAttribute(rtDest.SelAttributes, currFont);
                    handleNode(rtDest, TXMLTag(node.Nodes[idx]), handleEmoticons, isMe);
                end;
            finally
                currFont.Free();
            end;
        end;
    end;
end;

{$IFDEF EXODUS}
procedure XIMToRT(rtDest: TexRichEdit; xhtmlTag: TXMLTag; plaintext: WideString; ignoreFontProps: boolean);
{$ELSE}
procedure XIMToRT(controller: IExodusController; rtDest: TexRichEdit; xhtmlTag: TXMLTag; plaintext: WideString; ignoreFontProps: boolean);
{$ENDIF}
var
    cleanedTag, bTag: TXMLtag;
    idx: integer;
    origSelFont: TFont;
    defFont: TFont;
    foundEmoticon: boolean;
    tstr : WideString;
begin
{$IFNDEF EXODUS}
    assert(controller <> nil);
{$ENDIF}
    if (xhtmlTag = nil) then exit;
    tstr := xhtmlTag.Data;
{$IFDEF EXODUS}
    cleanedTag := cleanXIMTag(xhtmlTag, ignoreFontProps);
{$ELSE}
    cleanedTag := cleanXIMTag(controller, xhtmlTag, ignoreFontProps);
{$ENDIF}
    bTag := cleanedTag.GetFirstTag('body');
{$IFDEF EXODUS}
    foundEmoticon := (plainText <> '') and
                      MainSession.Prefs.getBool('emoticons') and
                      emoticon_regex.Exec(plaintext);
{$ELSE}
    foundEmoticon := (plainText <> '') and
                      controller.getPrefAsBool('emoticons') and
                      emoticon_regex.Exec(plaintext);
{$ENDIF}

    origSelFont := TFont.Create;
    defFont := TFont.Create;
    try
        AssignFont(defFont, rtDest.defAttributes);
        AssignFont(origSelFont, rtDest.selAttributes);
        //if first node is a p tag, make it a span...
        if ((bTag.Nodes.Count > 0) and
            (TXMLTag(bTag.Nodes[0]).NodeType = xml_tag) and
            (TXMLTag(bTag.Nodes[0]).Name = 'p')) then
            TXMLTag(bTag.Nodes[0]).Name := 'span';
        //iterate over our children
        for idx := 0 to bTag.Nodes.Count - 1 do begin
            AssignTextAttribute(rtDest.SelAttributes, defFont);
            handleNode(rtDest, TXMLTag(bTag.Nodes[idx]), foundEmoticon, ignoreFontProps)
        end;

        AssignTextAttribute(rtDest.SelAttributes, origSelFont);
    finally
        origSelFont.Free();
        defFont.Free();
        cleanedTag.Free();
    end;
end;
end.
