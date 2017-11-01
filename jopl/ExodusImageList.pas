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
unit ExodusImageList;


{**
    A wrapper around exposed Exodus Images lists. Allows exiting image lists
    to be manipulated by adding/replacing/deleting existing images without knowing
    about the current state of the list.

    This class keeps a reference to the actual imagelist, so any changes done
    throughan instance of this class effects the actual imagelist it is mapped to

    Class methods provide accessor and factorys for creating new lists.
**}
interface
 uses
    Unicode,
    Session,
    Graphics,
    Classes,
    Controls,
    ExtCtrls;
type
    TExodusImageList = class
    private
        _id         : WideString;
        _imgList    : TImageList;
        _ids        : TWidestringlist;
        _defaultIDs : TWidestringList;

        //function findHandle(handle: HBitmap): integer;
    protected
        procedure setDefaultIDs(default : TWidestringList);
        procedure createDefaultIDs(); virtual;
    public
        constructor Create(ID : WideString); 
        destructor Destroy(); override;

        {**
            Clear the current image list (set to nil) and clear id mappings
        **}
        procedure Clear();

        {**
            Set the current image list with no associated IDs
        **}
        procedure SetImagelist(images: TImagelist);overload;
        {**
            Set the current image list with associated IDs
        **}
        procedure SetImagelist(images: TImagelist; ids : TWidestringList);overload;

        {**
            Replace the image mapped by id with the new one
        **}
        procedure ReplaceImage(id : WideString; Image : TBitMap);overload;
        {**
            Replace the image at index with the new one
        **}
        procedure ReplaceImage(index : integer; Image : TBitMap);overload;
        {**
            Add a new image to end of list and return its index.
            If image exists already, don't replace, just return index (hmmm)
        **}
        function  AddImage(id: Widestring; Image: TBitmap): integer;
        procedure GetImage(index: integer; img: TImage);
        procedure GetIcon(index: integer; ico: TIcon);
        procedure RemoveImage(ImageIndex: integer); overload;
        procedure RemoveImage(id: Widestring); overload;
        function  Find(id: Widestring): integer;
        function  GetID(index: integer): Widestring;
        property  ImageList : TImageList read _imgList;
    end;

implementation
{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
uses
    SysUtils;
    
constructor TExodusImageList.Create(ID : WideString);
begin
    inherited Create();
    _id := ID;
    _ids := TWidestringlist.Create();
    _ids.Duplicates := dupIgnore; //unique entries
    _defaultIDs := nil;
    createDefaultIDs();
end;


procedure TExodusImageList.setDefaultIDs(default : TWidestringList);
begin
    _defaultIDs := default;
end;

procedure TExodusImageList.createDefaultIDs();
begin
    //nop in base class
end;

{---------------------------------------}
procedure TExodusImageList.Clear();
begin
    if (_imgList <> nil) then
        _imgList.Clear();
    _ids.Clear();
end;

{---------------------------------------}

procedure TExodusImageList.setImagelist(images: TImagelist);
begin
    setImageList(images, _defaultIDs);
end;

procedure TExodusImageList.setImagelist(images: TImagelist; ids : TWideStringList);
var
    i : integer;
    img : TImage;
    defImg: TBitmap;
begin
    _imgList := images;
    _ids.Clear();
    if (ids <> nil) then begin
        _ids.AddStrings(ids);
    end;
    img := TImage.Create(nil);
    try

        img.Width := _imgList.Width;
        img.Height := _imgList.Height;
        img.AutoSize := false;
        img.Stretch := true;
        //walk ids and check for image prefs
        for i  := 0 to _ids.Count - 1 do begin
            if (Session.MainSession.Prefs.getImage(_ids.Strings[i], img, _id))  then begin
                try
                    _imgList.ReplaceMasked(i, img.Picture.Bitmap, img.Picture.Bitmap.Canvas.Pixels[0,0]);
                except
                    //probably a size issue, just report it and eat                    
                end;
            end;
        end;
    finally
        img.Free();
    end;
    //make sure image list and id arrays are the same length
    if (_imgList.Count > _ids.Count) then
    begin
        //id < images, add fake ids for the unknown images
        for i := 0 to (_imgList.Count - _ids.Count - 1) do
            _ids.Add('unknown-image' + IntToStr(i))
    end
    else if (_imgList.Count < _ids.count) then
    begin
        defImg := TBitmap.Create();
        _imgList.GetBitmap(0, defImg);
        //ids > images. populate unknown images with defaults
        for i := 0 to (_ids.Count - _imgList.Count - 1) do
        begin
            _imgList.AddMasked(defImg, defImg.Canvas.Pixels[0,0]);
        end;
    end;    
end;

{**
    Replace the image mapped by id with the new one, if it did not exist
    it is added
**}
procedure TExodusImageList.ReplaceImage(id : WideString; image : TBitMap);
begin
    if (_imgList <> nil) then begin
        if (_ids.IndexOf(id) >= 0) then
            _imgList.ReplaceMasked(_ids.IndexOf(id), image, image.Canvas.Pixels[0,0])
        else
            addImage(id, image);
    end;
end;

{**
    Replace the image at index with the new one
**}
procedure TExodusImageList.ReplaceImage(index : integer; Image : TBitMap);
begin
    if (_imgList <> nil) then
        _imgList.ReplaceMasked(index, image, Image.Canvas.Pixels[0,0]);
end;

{---------------------------------------}
destructor TExodusImageList.Destroy();
begin
    _ids.Free();
    _imgList := nil;
    _defaultIDs.Free();
    inherited Destroy;
end;

{---------------------------------------}
function TExodusImageList.AddImage(id: Widestring; Image: TBitmap): integer;
var
    i, j: integer;
    preAddSize: integer;
    postAddSize: integer;
begin
    if (_imgList <> nil) then begin
        i := _ids.IndexOf(id);
        if (i = -1) then begin
            // add the image

            // Determine if we have an incorrectly sized image.
            // That would be an image that offsets the _imgList
            // memory more then 1 icon size.  This is to try and
            // avoid the problem with adding an image that is too
            // wide and that shifting the icon count off from the
            // string list count.  If that happened, requests for
            // icons would return the wrong bitmap.
            preAddSize := _imgList.Count;
            Result := _imgList.AddMasked(Image, Image.Canvas.Pixels[0,0]);
            postAddSize := _imgList.Count;
            if (postAddSize = (preAddSize + 1)) then begin
                // A good add, so add to stringlist
                _ids.add(id);
            end
            else begin
                // A bad add, so back out add from _imgList
                for j := 0 to (postAddSize - preAddSize - 1) do begin
                    _imgList.Delete(preAddSize);
                end;
                Result := -1;
            end;
        end
        else
            Result := i;
    end
    else
        Result := -1;
end;

{---------------------------------------}
procedure TExodusImageList.RemoveImage(ImageIndex: integer);
begin
    if (_imgList <> nil) then
        _imgList.Delete(ImageIndex);
    _ids.Delete(ImageIndex);
end;

{---------------------------------------}
procedure TExodusImageList.RemoveImage(id: Widestring);
var
    i: integer;
begin
    i := _ids.IndexOf(id);
    if (i >= 0) then
        RemoveImage(i);
end;

{---------------------------------------}
{
function TRosterImages.findHandle(handle: HBitmap): integer;
var
    i: integer;
begin
    // find this hbitmap in the list
    for i := 0 to _imglist.Count - 1 do begin
        _imglist.GetBitmap(i, _tmp_bmp);
        if (_tmp_bmp.Handle = handle) then begin
            Result := i;
            exit;
        end;
    end;
    Result := -1;
end;
}

{---------------------------------------}
function TExodusImageList.Find(id: Widestring): integer;
begin
    if (_imgList <> nil) then
        Result := _ids.IndexOf(id)
    else
        Result := -1;        
end;

{---------------------------------------}
function TExodusImageList.GetID(index: integer): Widestring;
begin
    if (index >= 0) and (index < _ids.Count) then
        Result := _ids[index]
    else
        Result := '';
end;

{---------------------------------------}
procedure TExodusImageList.GetImage(index: integer; img: TImage);
begin
    if (_imgList <> nil) then
        _imgList.GetBitmap(index, img.Picture.Bitmap);
end;

procedure TExodusImageList.GetIcon(index: integer; ico: TIcon);
begin
    if (_imgList <> nil) then
        _imgList.GetIcon(index, ico);
end;

end.
