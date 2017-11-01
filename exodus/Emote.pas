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
unit Emote;


interface

uses
{$IFNDEF EXODUS}
    Exodus_TLB,
{$ENDIF}
    ExRichEdit,
    RichEdit2,
    Types,
    Graphics,
    GIFImage,
    Unicode,
    iniFiles,
    RegExpr;

type
    {---------------------------------------}
    TEmoticon = class
    private
        _resHandle : Cardinal;
        _file      : WideString;
        _img_tag   : WideString;
        _rtf       : string;

    protected
        function getRTF(): string; virtual; abstract;
        function getBitmap: Graphics.TBitmap; virtual; abstract;

    public
        constructor Create(filename: string); overload;
        constructor Create(resHandle: cardinal; resFile: WideString; resType: string; fileName: WideString); overload;

        procedure Draw(canvas: TCanvas; r: TRect); virtual; abstract;

        function Width: integer; virtual; abstract;
        function Height: integer; virtual; abstract;

        property RTF: string read GetRTF;
        property Bitmap: Graphics.TBitmap read GetBitmap;
        property Filename: Widestring read _file;
    end;

    {---------------------------------------}
    TGifEmoticon = class(TEmoticon)
    private
        _gif: TGifImage;
        _bmp: Graphics.TBitmap;
    protected
{$IFDEF EXODUS}
        function getRTF(): string; override;
{$ELSE}
        function getRTF(controller: IExodusController): string;
{$ENDIF}
        function getBitmap(): Graphics.TBitmap; override;
    public
        constructor Create(filename: string); overload;
        constructor Create(resHandle: cardinal; resFile: WideString; resType: string; fileName: WideString); overload;
        procedure Draw(canvas: TCanvas; r: TRect); override;
        function Width: integer; override;
        function Height: integer; override;
    end;

    {---------------------------------------}
    TBMPEmoticon = class(TEmoticon)
    private
        _bmp: Graphics.TBitmap;
    protected
{$IFDEF EXODUS}
        function getRTF(): string; override;
{$ELSE}
        function getRTF(controller: IExodusController): string;
{$ENDIF}
        function getBitmap(): Graphics.TBitmap; override;
    public
        constructor Create(filename: string); overload;
        constructor Create(resHandle: cardinal; resFile: Widestring; resType: string; filename: Widestring); overload;
        procedure Draw(canvas: TCanvas; r: TRect); override;
        function Width: integer; override;
        function Height: integer; override;
    end;

    {---------------------------------------}
    TEmoticonList = class
    private
        _text      : THashedStringList;
        _objects   : THashedStringList;

        function _loadObject(mime: WideString; fileName: WideString; resHandle: cardinal; resFile: WideString): TEmoticon;
        function _getImageCount(): integer;
        function _getBitmap(i: integer): Graphics.TBitmap;
        function _getEmoticon(i: integer): TEmoticon;

    public
        constructor Create();
        destructor Destroy(); override;

        function AddResourceFile(resdll: WideString): boolean;
        procedure AddIconDefsFile(filename: string);
{$IFDEF EXODUS}
        procedure SaveIconDefsFile(filename: string);
{$ENDIF}
        procedure Clear();
        procedure setText(index: integer; txt: Widestring);
        procedure Remove(e: TEmoticon);

        function loadObject(txt, filename, object_fn: Widestring): TEmoticon;
        function getImageTag(candidate: WideString): WideString;
        function getRTF(candidate: WideString): WideString;
        function getText(e: TEmoticon): Widestring;
        function getKey(key: Widestring): TEmoticon;
        function indexOfText(txt: Widestring): integer;

        property ImageCount: integer read _getImageCount;
        property Bitmaps[index: integer]: Graphics.TBitmap read _getBitmap;
        property Emoticons[index: integer]: TEmoticon read _getEmoticon;
    end;

{---------------------------------------}
{$IFDEF EXODUS}
procedure InitializeEmoticonLists();
{$ELSE}
procedure InitializeEmoticonLists(controller: IExodusController);
{$ENDIF}
function ProcessRTFEmoticons(txt: Widestring) : string;
function ProcessIEEmoticons(txt: Widestring): WideString;
function BitmapToRTF(pict: Graphics.TBitmap): string;
{$IFDEF EXODUS}
function EmoteToRTF(e: TEmoticon): string;
{$ELSE}
function EmoteToRTF(e: TEmoticon; controller: IExodusController): string;
{$ENDIF}
function EscapeRTF(plain: WideString): string;
function TextileToRTF(plain: WideString): string;

var
    EmoticonList   : TEmoticonList;
    use_emoticons  : boolean;
    emoticon_regex : TRegExpr;
    textile_regex  : TRegExpr;


{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
implementation

uses
{$IFDEF EXODUS}
    PrefController,
    Emoticons,
    Session,
{$ENDIF}
    Windows,
    SysUtils,
    XmlUtils,
    Forms,
    XMLParser,
    XMLTag,
    Classes,
    StrUtils,
    JabberUtils,
    GnuGetText,
    Dialogs;

{---------------------------------------}
constructor TEmoticon.Create(filename: string);
begin
    _resHandle := 0;
    _file := filename;
    _rtf := '';
    _img_tag := '';
end;

{---------------------------------------}
constructor TEmoticon.Create(resHandle: cardinal; resFile: WideString; resType: string; fileName: WideString);
begin
    _resHandle := resHandle;
    _file := ChangeFileExt(filename, '');
    _rtf := '';
    _img_tag := '';
end;

{---------------------------------------}
{------------- TGifEmoticon ------------}
{---------------------------------------}
constructor TGifEmoticon.Create(filename: string);
begin
    inherited;
    _img_tag := '<img src="file://' + _file + '" />';
    _gif := TGifImage.Create();
    _gif.LoadFromFile(_file);
    _bmp := nil;
end;

{---------------------------------------}
constructor TGifEmoticon.Create(resHandle: cardinal; resFile: WideString; resType: string; fileName: WideString);
var
    rs : TResourceStream;
begin
    inherited;
    _img_tag := '<img src="res://' + resFile + '/GIF/' + _file + '" />';

    rs := TResourceStream.Create(_resHandle, _file, 'GIF');
    _gif := TGifImage.Create();
    _gif.LoadFromStream(rs);
    _bmp := nil;

    rs.Free();
end;

{---------------------------------------}
{$IFDEF EXODUS}
function TGifEmoticon.getRTF(): string;
{$ELSE}
function TGifEmoticon.getRTF(controller: IExodusController): string;
{$ENDIF}
begin
    if (_rtf <> '') then begin
        result := _rtf;
        exit;
    end;
{$IFDEF EXODUS}
    _rtf := EmoteToRTF(self);
{$ELSE}
    _rtf := EmoteToRTF(self, controller);
{$ENDIF}
    result := _rtf;
end;

{---------------------------------------}
function TGifEmoticon.getBitmap: Graphics.TBitmap;
begin
    if (_bmp = nil) then begin
        _bmp := _gif.Bitmap;
        _bmp.Transparent := true;
    end;
    Result := _bmp;
end;

{---------------------------------------}
procedure TGifEmoticon.Draw(canvas: TCanvas; r: TRect);
var
    cr: TRect;
    w, h: integer;
begin
    // center the image in the rect
    w := ((r.Right - r.Left) - (_gif.Width)) div 2;
    h := ((r.Bottom - r.Top) - (_gif.Height)) div 2;
    cr.Left := r.left + w;
    cr.Top := r.Top + h;
    cr.Right := cr.Left + _gif.Width;
    cr.Bottom := cr.Top + _gif.Height;
    _gif.Paint(canvas, cr, [goTransparent, goDirectDraw]);
end;

{---------------------------------------}
function TGifEmoticon.Width: integer;
begin
    Result := _gif.Width;
end;

{---------------------------------------}
function TGifEmoticon.Height: integer;
begin
    Result := _gif.Height;
end;

{---------------------------------------}
{------------ TBMPEmoticon -------------}
{---------------------------------------}
constructor TBMPEmoticon.Create(filename: string);
begin
    inherited;
    _bmp := Graphics.TBitmap.Create();
    _bmp.LoadFromFile(_file);
    _bmp.Transparent := true;
end;

{---------------------------------------}
constructor TBMPEmoticon.Create(resHandle: cardinal; resFile: WideString; resType: string; fileName: WideString);
var
    rs : TResourceStream;
begin
    inherited;

    _img_tag := '<img src="res://' + resFile + '/BMP/' + _file + '" />';
    rs := TResourceStream.Create(_resHandle, _file, 'BMP');

    _bmp := Graphics.TBitmap.Create();
    _bmp.LoadFromStream(rs);
    _bmp.Transparent := true;

    rs.Free();
end;

{---------------------------------------}
{$IFDEF EXODUS}
function TBMPEmoticon.getRTF(): string;
{$ELSE}
function TBMPEmoticon.getRTF(controller: IExodusController): string;
{$ENDIF}
begin
    if (_rtf <> '') then begin
        result := _rtf;
        exit;
    end;
{$IFDEF EXODUS}
    _rtf := EmoteToRTF(Self);
{$ELSE}
    _rtf := EmoteToRTF(Self, controller);
{$ENDIF}
    result := _rtf;
end;

{---------------------------------------}
function TBMPEmoticon.getBitmap: Graphics.TBitmap;
begin
    Result := _bmp;
end;

{---------------------------------------}
procedure TBMPEmoticon.Draw(canvas: TCanvas; r: TRect);
var
    w, h: integer;
begin
    // center the image in the rect
    w := ((r.Right - r.left) - (_bmp.Width)) div 2;
    h := ((r.Bottom - r.Top) - (_bmp.Height)) div 2;
    canvas.Draw(r.left + w, r.Top + h, _bmp);
end;

{---------------------------------------}
function TBMPEmoticon.Width: integer;
begin
    Result := _bmp.Width;
end;

{---------------------------------------}
function TBMPEmoticon.Height: integer;
begin
    Result := _bmp.Height;
end;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
{$IFDEF EXODUS}
function EmoteToRTF(e: TEmoticon): string;
{$ELSE}
function EmoteToRTF(e: TEmoticon; controller: IExodusController): string;
{$ENDIF}
var
    r: TRect;
    tbmp: Graphics.TBitmap;
begin
{$IFNDEF EXODUS}
    assert(controller <> nil);
{$ENDIF}
    // transparent fu.. The idea here, is that we create a temp bitmap which
    // is the same size, and we first draw the bg color onto it,
    // THEN draw the pict bitmap over the top. When we draw pict, if it's
    // transparent property is set to true, the only pixels that are affected
    // on tbmp are those that are not the same color as the transparent color.
    tbmp := Graphics.TBitmap.Create();
    tbmp.Width := e.Width;
    tbmp.Height := e.Height;
    with tbmp.Canvas do begin
        Pen.Width := 0;
        Brush.Style := bsSolid;
{$IFDEF EXODUS}
        Brush.Color := TColor(MainSession.Prefs.getInt('color_bg'));
{$ELSE}
        Brush.Color := TColor(controller.getPrefAsInt('color_bg'));
{$ENDIF}
        Pen.Color := Brush.Color;
        Rectangle(0, 0, tbmp.Width, tbmp.Height);
    end;

    r.Top := 0;
    r.Left := 0;
    r.Right := tbmp.Width;
    r.Bottom := tbmp.Height;
    e.Draw(tbmp.Canvas, r);
    Result := BitmapToRTF(tbmp);
    tbmp.Free();
end;


{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
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

{---------------------------------------}
{------------ Emoticon List ------------}
{---------------------------------------}
constructor TEmoticonList.Create();
begin
    _text      := THashedStringList.Create();
    _objects   := THashedStringList.Create();
end;

{---------------------------------------}
function TEmoticonList.getKey(key: Widestring): TEmoticon;
var
    i: integer;
begin
    i := _objects.indexOf(key);
    if (i >= 0) then
        Result := TEmoticon(_objects.Objects[i])
    else
        Result := nil;
end;

{---------------------------------------}
function TEmoticonList.loadObject(txt, filename, object_fn: Widestring): TEmoticon;
var
    ext: Widestring;
begin
    ext := Lowercase(ExtractFileExt(object_fn));
    if (ext = '.bmp') then
        Result := _loadObject('image/x-ms-bmp', object_fn, 0, filename)
    else if (ext = '.gif') then
        Result := _loadObject('image/gif', object_fn, 0, filename)
    else
        Result := nil;

    if (Result <> nil) then
        _text.addObject(txt, Result);
end;

{---------------------------------------}
function TEmoticonList._loadObject(mime: WideString; fileName: WideString; resHandle: cardinal; resFile: WideString): TEmoticon;
var
    key : WideString;
    i : integer;
begin
    key := resFile + '/' + fileName;
    i := _objects.IndexOf(key);
    if (i >= 0) then begin
        result := TEmoticon(_objects[i]);
        exit;
    end;

    // image/gif
    // image/x-ms-bmp
    // image/jpeg
    // image/png
    if (mime = 'image/gif') then begin
        try
            if (resHandle <> 0) then
                result := TGifEmoticon.Create(resHandle, resFile, 'GIF', fileName)
            else
                result := TGifEmoticon.Create(fileName);

            _objects.AddObject(key, result);
        except
            MessageDlgW(WideFormat(_('Failed to load emoticon image: %s'), [fileName]), mtError, [mbOK], 0);
            result := nil;
        end;

    end
    else if (mime = 'image/x-ms-bmp') then begin
        if (resHandle > 0) then
            result := TBMPEmoticon.Create(resHandle, resFile, 'BMP', fileName)
        else
            result := TBMPEmoticon.Create(fileName);

        _objects.AddObject(key, result);
    end
    else
        result := nil;
end;

{---------------------------------------}
procedure TEmoticonList.addIconDefsFile(filename: string);
var
    i: integer;
    mt: Widestring;
    parser: TXMLTagParser;
    o, t, icon, doc: TXMLTag;
    icons: TXMLTagList;
    e: TEmoticon;
begin
    doc := nil;
    parser := nil;
    icons := nil;
    try
        parser := TXMLTagParser.Create();
        parser.ParseFile(filename);
        doc := parser.popTag();
        if (doc = nil) then exit;
        icons := doc.QueryTags('icon');
        for i := 0 to icons.Count - 1 do begin
            e := nil;
            icon := icons[i];
            o := icon.GetFirstTag('object');
            t := icon.GetFirstTag('text');
            if ((o <> nil) and (t <> nil)) then begin
                mt := o.getAttribute('mime');
                e := _loadObject(mt, o.Data(), 0, filename);
            end;

            // add the text into the list.
            if (e <> nil) then
                _text.AddObject(t.Data, e);
        end;

    finally
        if (doc <> nil) then doc.Free();
        if (parser <> nil) then parser.Free();
        if (icons <> nil) then icons.Free();
    end;
end;

{---------------------------------------}
{$IFDEF EXODUS}
procedure TEmoticonList.SaveIconDefsFile(filename: string);
var
    idx, i: integer;
    e: TEmoticon;
    d, m, icon, o: TXMLTag;
    txt: Widestring;
    sl: TStringlist;
begin
    d := TXMLTag.Create('icondef');

    // Create some meta-info
    m := d.AddTag('meta');
    m.AddBasicTag('name', ExtractFileName(filename));
    m.AddBasicTag('description', 'Custom emotion list for ' + PrefController.getAppInfo.ID +' client');

    // walk the list.
    for i := 0 to _objects.Count - 1 do begin
        e := TEmoticon(_objects.Objects[i]);

        // find the txt for this
        idx := _text.IndexOfObject(e);
        if (idx >= 0) then begin
            txt := _text[idx];
            icon := d.AddTag('icon');
            icon.AddBasicTag('text', txt);
            o := icon.AddBasicTag('object', e._file);
            if (e is TBMPEmoticon) then
                o.setAttribute('mime', 'image/x-ms-bmp')
            else if (e is TGifEmoticon) then
                o.SetAttribute('mime', 'image/gif');
        end;
    end;

    sl := TStringlist.Create();
    try
        sl.Add(UTF8Encode(d.xml));
        sl.SaveToFile(filename);
    except
        // XXX: catch this someplace??
    end;
    sl.Free();
end;
{$ENDIF}

{---------------------------------------}
function TEmoticonList.AddResourceFile(resdll: WideString): boolean;
var
    parser : TXMLTagParser;
    icondef : TXMLTag;
    icons, ts, os : TXMLTagList;
    icon, obj : TXMLTag;
    i, j : integer;
    e: TEmoticon;
    h: cardinal;
begin
    h := LoadLibraryW(PWChar(resdll));

    if (h = 0) then
        h := LoadLibrary(PChar(String(resdll)));

    if (h = 0) then begin
        // TODO: debug warning
        Result := false;
        exit;
    end;

    parser := TXMLTagParser.Create();
    try
        parser.ParseResource(h, 'icondef');
    except
    end;
    if (parser.Count <= 0) then begin
        parser.Free();
        Result := false;
        exit;
    end;

    icondef := parser.popTag();
    parser.Free();

    icons := icondef.QueryTags('icon');
    for i := 0 to icons.Count - 1 do begin
        icon := icons[i];

        e := nil;
        os := icon.QueryTags('object');
        for j := 0 to os.Count - 1 do begin
            obj := os[j];
            e := _loadObject(obj.GetAttribute('mime'), obj.Data, h, resdll);
            if (e <> nil) then break;
        end;
        os.Free();

        if (e <> nil) then begin
            ts := icon.QueryTags('text');
            for j := 0 to ts.Count - 1 do begin
                _text.AddObject(ts[j].Data, e);
            end;
            ts.Free();
        end;

    end;
    icons.Free();
    icondef.Free();
    Result := true;
end;

{---------------------------------------}
function TEmoticonList._getImageCount(): integer;
begin
    Result := _objects.Count;
end;

{---------------------------------------}
function TEmoticonList._getBitmap(i: integer): Graphics.TBitmap;
var
    e: TEmoticon;
begin
    if ((i < 0) or (i >= _objects.Count)) then begin
        Result := nil;
        exit;
    end;

    e := TEmoticon(_objects.Objects[i]);
    Result := e.getBitmap();
end;

{---------------------------------------}
function TEmoticonList._getEmoticon(i: integer): TEmoticon;
begin
    if ((i < 0) or (i >= _objects.Count)) then begin
        Result := nil;
        exit;
    end;

    Result := TEmoticon(_objects.Objects[i]);
end;

{---------------------------------------}
destructor TEmoticonList.Destroy();
begin
    Clear();
    _text.Free();
    _objects.Free();
end;

{---------------------------------------}
procedure TEmoticonList.Clear();
var
    i: integer;
    o: TObject;
begin
    // clear out the GDI objects
    for i := 0 to _objects.Count - 1 do begin
        o := _objects.Objects[i];
        if o <> nil then begin
            if o is TGifEmoticon then
                TGifEmoticon(o)._gif.Free()
            else if o is TBMPEmoticon then
                TBMPEmoticon(o)._bmp.Free()
        end;
    end;

    ClearStringListObjects(_objects);
    _objects.Clear();
    _text.Clear();
end;

{---------------------------------------}
function TEmoticonList.getImageTag(candidate: WideString): WideString;
var
    i: integer;
    ttag: TXMLTag;
begin
    result := '';
    i := _text.IndexOf(candidate);
    if (i >= 0) then begin
        result := TEmoticon(_text.Objects[i])._img_tag;
        ttag := StringToXMLTag(result);
        if (ttag <> nil) then begin
            ttag.setAttribute('alt', candidate);
            result := ttag.XML;
            ttag.Free();
        end;
    end;
end;

{---------------------------------------}
function TEmoticonList.getRTF(candidate: WideString): WideString;
var
    i: integer;
begin
    result := '';
    i := _text.IndexOf(candidate);
    if (i >= 0) then
        result := TEmoticon(_text.Objects[i]).GetRTF();
end;

{---------------------------------------}
function TEmoticonList.indexOfText(txt: Widestring): integer;
begin
    Result := _text.indexOf(txt);
end;

{---------------------------------------}
function TEmoticonList.getText(e: TEmoticon): Widestring;
var
    i: integer;
begin
    // just find the first text string in the list that matches
    i := _text.IndexOfObject(e);
    if (i = -1) then
        Result := ''
    else
        Result := _text[i];
end;

{---------------------------------------}
procedure TEmoticonList.setText(index: integer; txt: Widestring);
begin
    if ((index < 0) or (index >= _text.Count)) then exit;

    _text.Strings[index] := txt;
end;

{---------------------------------------}
procedure TEmoticonList.Remove(e: TEmoticon);
var
    i, i2: integer;
begin
    i := _objects.IndexOfObject(e);
    if (i >= 0) then _objects.Delete(i);
    repeat
        i2 := _text.IndexOfObject(e);
        if (i2 >= 0) then _text.Delete(i2);
    until (i2 = -1);
    e.Free();
end;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
{$IFDEF EXODUS}
procedure InitializeEmoticonLists();
{$ELSE}
procedure InitializeEmoticonLists(controller: IExodusController);
{$ENDIF}
var
    dlls : TWideStringList;
    i : integer;
    fn: Widestring;
    dlgrslt: integer;
{$IFNDEF EXODUS}
    slcnt: integer;
{$ENDIF}
begin
{$IFNDEF EXODUS}
    assert(controller <> nil);
{$ENDIF}
    dlls := TWideStringList.Create();
    EmoticonList.Clear();
    // Load up any custom ones we have..
{$IFDEF EXODUS}
    fn := MainSession.Prefs.getString('custom_icondefs');
{$ELSE}
    fn := controller.getPrefAsString('custom_icondefs');
{$ENDIF}
    if ((fn <> '') and (FileExists(fn))) then
        EmoticonList.AddIconDefsFile(fn);

    // Load up any icon sets we have...
{$IFDEF EXODUS}
    MainSession.Prefs.fillStringlist('emoticon_dlls', dlls);
    for i := dlls.Count - 1 downto 0 do begin
        if (not EmoticonList.AddResourceFile(dlls[i])) then begin
            dlgrslt := MessageDlgW(WideFormat(_('Emoticon resource (%s) not found or not a valid emoticon resource. Do you wish to remove from list?'), [dlls[i]]), mtError, [mbYES, mbNO], 0);
            if (dlgrslt = 6) then // mrYes
                dlls.Delete(i);
        end;
    end;
    MainSession.Prefs.setStringlist('emoticon_dlls', dlls);
{$ELSE}
    for i := 0 to controller.GetStringListCount('emoticon_dlls') - 1 do
    begin
        dlls.Add(controller.GetStringListValue('emoticon_dlls', i));
    end;
    for i := dlls.Count - 1 downto 0 do begin
        EmoticonList.AddResourceFile(dlls[i]);
    end;
{$ENDIF}
    dlls.Free();

    // Make sure the GUI form is updated.
{$IFDEF EXODUS}
    if (frmEmoticons = nil) then
        frmEmoticons := TfrmEmoticons.Create(Application);
    frmEmoticons.Reset();
{$ENDIF}
end;

{---------------------------------------}
function ProcessIEEmoticons(txt: Widestring): WideString;
var
    m: boolean;
    ms, s: Widestring;
    lm: integer;
    img: WideString;
    res: WideString;
begin
    if (not use_emoticons) then begin
        result := txt;
        exit;
    end;

    // search for various smileys
    res := '';
    s := txt;
    m := emoticon_regex.Exec(txt);
    lm := 0;
    while(m) do begin
        // we have a match
        lm := emoticon_regex.MatchPos[0] + emoticon_regex.MatchLen[0];
        res := res + emoticon_regex.Match[1];

        img := '';
        // Grab the match text and look it up in our emoticon list
        ms := emoticon_regex.Match[2];
        if (ms <> '') then begin
            img := EmoticonList.getImageTag(ms);
        end;

        // if we have a legal emoticon object, insert it..
        // otherwise insert the matched text
        if (img <> '') then
            res := res + img
        else
            res := res + ms;

        // Match-6 is any trailing whitespace
        if (lm <= length(txt)) then
            res := res + emoticon_regex.Match[6];

        // Search for the next emoticon
        m := emoticon_regex.ExecNext();

        // do a sanity check here, probably because the regex prolly isn't
        // _REALLY_ widestr compliant
        if (m) then begin
            if (length(txt) < emoticon_regex.MatchPos[0]) then
                m := false;
        end;
    end;

    if (lm <= length(txt)) then begin
        // we have a remainder
        res := res +  Copy(txt, lm, length(txt) - lm + 1);
    end;
    result := res;
end;

{---------------------------------------}
function ProcessRTFEmoticons(txt: Widestring) : string;
var
    m: boolean;
    ms, s: Widestring;
    lm: integer;
    rtf: WideString;
    pending: WideString;
begin
    result := '';

    // search for various smileys

    s := txt;
    m := emoticon_regex.Exec(txt);
    lm := 0;
    pending := '';
    while(m) do begin
        // we have a match
        lm := emoticon_regex.MatchPos[0] + emoticon_regex.MatchLen[0];
        pending := pending + emoticon_regex.Match[1];

        rtf := '';
        // Grab the match text and look it up in our emoticon list
        ms := emoticon_regex.Match[2];
        if (ms <> '') then begin
            rtf := EmoticonList.getRTF(ms);
        end;

        // if we have a legal emoticon object, insert it..
        // otherwise insert the matched text
        if (rtf <> '') then begin
            result := result + TextileToRTF(pending);
            pending := '';
            result := result + rtf;
        end
        else
            pending := pending + ms;

        // Match-6 is any trailing whitespace
        if (lm <= length(txt)) then
            pending := pending + emoticon_regex.Match[6];

        // Search for the next emoticon
        m := emoticon_regex.ExecNext();

        // do a sanity check here, probably because the regex prolly isn't
        // _REALLY_ widestr compliant
        if (m) then begin
            if (length(txt) < emoticon_regex.MatchPos[0]) then
                m := false;
        end;
    end;

    if (pending <> '') then
        result := result + TextileToRTF(pending);

    if (lm <= length(txt)) then begin
        // we have a remainder
        txt := Copy(txt, lm, length(txt) - lm + 1);
        result := result + TextileToRTF(txt);
    end;
end;

function EscapeRTF(plain: WideString): string;
var
    rtf: string;
    i: integer;
    c: WideChar;
    state: char;
begin
    rtf := '';
    state := 'c';
    for i := 1 to length(plain) do begin
        c := plain[i];

        // tests:
        // \r   #$D
        // \n   #$A
        // \r\n
        if state = 'r' then begin
            if c = #$A then
                state := 'n'
            else
                state := 'c';
        end
        else if state = 'n' then
            state := 'c';

        if state = 'c' then begin
            // unicode
            if (c > #127) then
                //TODO: Mad Unicode foo to pick the "closest" alternate character
                rtf := rtf + '\u' + IntToStr(ord(c)) + '?'
            else if (c = '{') or (c = '}') or (c = '\') then
                rtf := rtf + '\' + plain[i]
            else if (c = #$D) then begin
                rtf := rtf + '\par ';
                state := 'r';
            end
            else if (c = #$A) then
                rtf := rtf + '\par '
            else
                rtf := rtf + plain[i];
        end;
    end;
    result := rtf;
end;

function TextileToRTF(plain: WideString): string;
var
    m: boolean;
    lm: integer;
    tag: string;
begin
    result := '';
    lm := 0;
    m := textile_regex.Exec(plain);
    while m do begin
        lm := textile_regex.MatchPos[0] + textile_regex.MatchLen[0];
        result := result + EscapeRTF(textile_regex.Match[1]) + textile_regex.Match[2];
        if (textile_regex.Match[3] = '*') then
             tag := '\b'
        else if (textile_regex.Match[3] = '_') then
            tag := '\ul'
        else if (textile_regex.Match[3] = '^') then
            tag := '\super'
        else if (textile_regex.Match[3] = '~') then
            tag := '\sub';

        result := result + tag + ' ' +
                  textile_regex.Match[3] + EscapeRTF(textile_regex.Match[4]) +
                  textile_regex.Match[3] + tag + '0 ' +
                  EscapeRTF(textile_regex.Match[5]);

        m := textile_regex.ExecNext();
    end;
    if (lm <= length(plain)) then begin
        // we have a remainder
        plain := Copy(plain, lm, length(plain) - lm + 1);
        result := result + EscapeRTF(plain);
    end;
end;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
initialization

    EmoticonList := TEmoticonList.Create();

    // This is a "meta-regex" that should match everything
    // Create the static regex object and compile it.
    emoticon_regex := TRegExpr.Create();
    
    with emoticon_regex do begin
        ModifierG := false;
        //Modify set of characters that we would like to treat as word char
        //For emoticon it will be most of the characters but the whitespaces
        WordChars := WordChars +
                       chr(33) + //!
                       chr(34) + //"
                       chr(35) + //#
                       chr(36) + //$
                       chr(37) + //%
                       chr(38) + //&
                       chr(39) + //'
                       chr(40) + //(
                       chr(41) + //)
                       chr(42) + //*
                       chr(43) + //+
                       chr(44) + //,
                       chr(45) + //-
                       chr(46) + //.
                       chr(47) + ///
                       chr(58) + //:
                       chr(59) + //;
                       chr(60) + //<
                       chr(61) + //=
                       chr(62) + //>
                       chr(63) + //?
                       chr(64) + //@
                       chr(91) + //[
                       chr(92) + //\
                       chr(93) + //]
                       chr(94) + //^
                       chr(96) + //'
                       chr(123) + //{
                       chr(124) + //|
                       chr(125) + //}
                       chr(126); //~
        Expression := '(.*)(\b\w+\b)';
        Compile();
    end;

    textile_regex := TRegExpr.Create();
    with textile_regex do begin
        ModifierG := false;
        Expression := '(.*)(^|\s)([*_^~])(.+)\3(\s|$)';
        Compile();
    end;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
finalization
    if (EmoticonList <> nil) then
        FreeAndNil(EmoticonList);
    if (emoticon_regex <> nil) then
        FreeAndNil(emoticon_regex);
    if (textile_regex <> nil) then
        FreeAndNil(textile_regex);
end.
