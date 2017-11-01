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
unit Avatar;


interface
uses
    XMLTag,
     Graphics, Types, SysUtils, Classes, Dialogs;

const
    MAX_AVATAR_SIZE = 102400;

type

    TAvatarType = (avOLD, avCard);

    TAvatar = class
    public
        constructor Create();
        destructor Destroy(); override;

    private
        _pic: TGraphic;
        _hash: string;  // contains the sha1 hash
        _data: string;  // contains the base64 encoded image
        _height, _width: integer;

        procedure _genData();
        function getMimeType(): string;
    protected
        procedure setHash(hash: string);
        procedure SetPNGBackgroundColor(value: TColor); virtual;
        function GetPNGBackgroundColor(): TColor; virtual;
    public
        jid: Widestring;
        AvatarType: TAvatarType;
        Valid: boolean;
        Pending: boolean;

        procedure SaveToFile(var filename: string);
        procedure LoadFromFile(filename: string);
        procedure Draw(c: TCanvas; r: TRect); overload;
        procedure Draw(c: TCanvas); overload;
        procedure parse(tag: TXMLTag);


        function  getHash(): string;
        function  isValid(): boolean;

        property Graphic: TGraphic read _pic;
        property  Data: string read _data;
        property  MimeType: string read getMimeType;
        property  Height: integer read _height;
        property  Width: integer read _width;

        property PNGBackgroundColor: TColor read GetPNGBackgroundColor write SetPNGBackgroundColor;
    end;

implementation
uses
    JabberUtils, 
    Unicode,
    IdCoderMime,
    GifImage, Jpeg, PNGWrapper,
    gnuGetText,
    SecHash,
    ExForm, //for default bk color
    XMLParser, {AvatarCache, }JabberID;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
constructor TAvatar.Create();
begin
    inherited;
    _pic := nil;
    _hash := '';
    _data := '';
    Valid := false;
end;

{---------------------------------------}
destructor TAvatar.Destroy();
begin
    if (_pic <> nil) then FreeAndNil(_pic);
    inherited;
end;

{---------------------------------------}
procedure TAvatar.SaveToFile(var filename: string);
var
    base: string;
begin
    if (_pic = nil) then exit;
    
    base := ChangeFileExt(filename, '');
    try
        if (_pic is TGifImage) then begin
            filename := base + '.gif';
            TGifImage(_pic).SaveToFile(filename);
        end
        else if (_pic is TJPEGImage) then begin
            filename := base + '.jpg';
            TJPEGImage(_pic).SaveToFile(filename);
        end
        else if (_pic is TPNGWrapper) then begin
            filename := base + '.png';
            TPNGWrapper(_pic).SaveToFile(filename);
        end
        else begin
            filename := base + '.bmp';
            TBitmap(_pic).SaveToFile(filename);
        end;
    except
        // XXX: log save failure?
    end;
end;

{---------------------------------------}
procedure TAvatar.LoadFromFile(filename: string);
var
    ext: string;
begin
    Valid := false;

    try

    ext := Lowercase(ExtractFileExt(filename));
    if (ext = '.gif') then begin
        _pic := TGifImage.Create();
        _pic.Transparent := true;
        _pic.LoadFromFile(filename);
    end
    else if ((ext = '.jpg') or (ext = '.jpeg')) then begin
        _pic := TJpegImage.Create();
        _pic.Transparent := true;
        _pic.LoadFromFile(filename);
    end
    else if (ext = '.png') then begin
        _pic := TPNGWrapper.create();
        TPNGWrapper(_pic).BackgroundColor := TExForm.GetDefaultWindowColor();
        _pic.LoadFromFile(filename);
    end
    else if (ext = '.bmp') then begin
        _pic := TBitmap.Create();
        _pic.Transparent := true;
        _pic.LoadFromFile(filename);
    end
    else begin
        if (_pic <> nil) then FreeAndNil(_pic);
    end;

    if (_pic.Width > 256) then begin
        // resize
    end;

    _genData();

    except
      on invalid: EInvalidGraphic do begin
          MessageDlgW(_('This grahpic cannot be loaded because it''s format isn''t supported. ' + chr(13) + chr(10) + '(Hint: Check that the file''s extension matches it''s type.)'),mtError, [mbOk], 0);
      end;
    end; // end try
end;

{---------------------------------------}
procedure TAvatar._genData();
var
    m: TMemoryStream;
    c: TIdEncoderMime;
begin
    if (_data = '') and (_pic <> nil) then begin
        m := TMemoryStream.Create();
        _pic.SaveToStream(m);

        m.Position := 0;
        c := TIdEncoderMime.Create(nil);
        _data := c.Encode(m);
        c.Free();
        m.Free();

        _hash := '';
    end;

    _height := _pic.Height;
    _width := _pic.Width;

    Valid := true;
end;

{---------------------------------------}
procedure TAvatar.setHash(hash: string);
begin
    _hash := hash;
end;
{---------------------------------------}
function TAvatar.getHash(): string;
var
    i: integer;
    m: TMemoryStream;
    d: TIdDecoderMime;
    hasher: TSecHash;
    h: TIntDigest;
    s: string;
begin
    if (_hash <> '') then begin
        Result := _hash;
        exit;
    end;

    Result := '';
    m := TMemoryStream.Create();
    d := TIdDecoderMime.Create(nil);
    try
        d.DecodeToStream(_data, m);
    except
        m.Free();
        exit;
    end;
    
    m.Position := 0;
    hasher := TSecHash.Create(nil);
    h := hasher.ComputeMem(m.Memory, m.Size);
    for i := 0 to 4 do
        s := s + IntToHex(h[i], 8);
    _hash := Lowercase(s);

    m.Free();
    hasher.Free();
    Result := _hash;
end;

{---------------------------------------}
procedure TAvatar.Draw(c: TCanvas; r: TRect);
var
    aspect: single;
    rw, rh, pw, ph: integer;
begin
    if (_pic = nil) then exit;

    // draw while maintaing the aspect ratio
    ph := _pic.Height;
    pw := _pic.Width;

    rw := (r.Right - r.Left);
    rh := (r.Bottom - r.Top);

    // adjust the rectangle to ensure proper aspect control
    aspect := (ph / pw);

    if (aspect > 1.0) then begin
        rw := Round(rh / aspect);
        r.Right := r.Left + rw
    end
    else begin
        rh := Round(rw * aspect);
        r.Bottom := r.Top + rh;
    end;

    // draw
    c.StretchDraw(r, _pic);
end;

{---------------------------------------}
procedure TAvatar.Draw(c: TCanvas);
begin
    if (_pic = nil) then exit;
    c.Draw(1, 1, _pic);
end;

{---------------------------------------}
procedure TAvatar.parse(tag: TXMLTag);
var
    mtype, bv: TXMLTag;
    data, mt: Widestring;
    m: TMemoryStream;
    d: TIdDecoderMime;
    i: integer;
    tmps: TWidestringList;
begin
    Valid := false;
    if (_pic <> nil) then FreeAndNil(_pic);

    // check for cdata attached directly to <PHOTO>
    data := tag.Data;
    if (trim(data) = '') then begin
        // check for <BINVAL>...</BINVAL>
        bv := tag.GetFirstTag('BINVAL');
        if (bv <> nil) then
            data := bv.Data;
    end;

    // if we have no data, then bail
    if (trim(data) = '') then exit;

    tmps := TWidestringList.Create();
    split(data, tmps);
    _data := '';
    for i := 0 to tmps.Count - 1 do begin
        _data := _data + tmps[i];
    end;

    m := TMemoryStream.Create();
    d := TIdDecoderMime.Create(nil);
    try
        d.DecodeToStream(_data, m);
        m.Position := 0;

        mtype := tag.GetFirstTag('TYPE');
        if (mtype = nil) then
            mtype := tag.GetFirstTag('type');
        if (mtype <> nil) then
            mt := mtype.Data
        else begin
            mt := tag.GetAttribute('mimetype');
            if (mt = '') then mt := tag.GetAttribute('mime-type');
            if (mt = '') then mt := tag.GetAttribute('type');
        end;

        if (mt = 'image/gif') then begin
            _pic := TGifImage.Create();
            _pic.Transparent := true;
            _pic.LoadFromStream(m);
            _genData();
        end
        else if (mt = 'image/jpeg') then begin
            _pic := TJPEGImage.Create();
            _pic.Transparent := true;
            _pic.LoadFromStream(m);
            _genData();
        end
        else if (mt = 'image/x-ms-bmp') or (mt = 'image/bmp') then begin
            _pic := TBitmap.Create();
            _pic.Transparent := true;
            _pic.LoadFromStream(m);
            _genData();
        end
        else if (mt = 'image/png') then begin
            _pic := TPNGWrapper.Create();
            _pic.Transparent := true;
            _pic.loadFromStream(m);

            _genData();
        end
        else if (_data <> '') then begin
            try
                _pic := TJPEGImage.Create();
                _pic.Transparent := true;
                _pic.LoadFromStream(m);
                _genData();
            except
                try
                    FreeAndNil(_pic);
                    m.Position := 0;
                    _pic := TGifImage.Create();
                    _pic.Transparent := true;
                    _pic.LoadFromStream(m);
                    _genData();
                except
                    try
                        // XXX: try PNG?

                        FreeAndNil(_pic);
                        m.Position := 0;
                        _pic := TBitmap.Create();
                        _pic.Transparent := true;
                        _pic.LoadFromStream(m);
                        _genData();
                    except
                        FreeAndNil(_pic);
                    end;
                end;
            end;
        end;
    except
        if (_pic <> nil) then FreeAndNil(_pic);
    end;

    m.Free();
    d.Free();
end;

function TAvatar.getMimeType: string;
begin
    if (_pic = nil) then
        Result := 'INVALID'
    else if (Valid = false) then
        Result := 'INVALID'
    else if (_pic is TGifImage) then
        Result := 'image/gif'
    else if (_pic is TJPEGImage) then
        Result := 'image/jpeg'
    else if (_pic is TBitmap) then
        Result := 'image/x-ms-bmp'
    else if (_pic is TPNGWrapper) then
        Result := 'image/png'
    else
        Result := 'INVALID';
end;

function TAvatar.isValid(): boolean;
begin
    Result := (_pic <> nil);
end;

procedure TAvatar.SetPNGBackgroundColor(value: TColor);
begin
    if (_pic is TPNGWrapper) then
        TPNGWrapper(_pic).BackgroundColor := value;
end;

function TAvatar.GetPNGBackgroundColor(): TColor;
begin
    Result := clNone;
    if (_pic is TPNGWrapper) then
        Result := TPNGWrapper(_pic).BackgroundColor;
end;

end.
