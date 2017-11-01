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
unit PrefGraphics;


interface
uses
    Windows,
    SysUtils,
    XMLTag, XMLParser,
    ExtCtrls,
    Graphics,
    PrefController,
    Unicode;
type
    TBrandedGraphic = class
        graphicKey : WideString;
        gtype   : WideString;
        resname : WideString;
        source  : WideString;
        cached  : boolean;
        image   : TImage;

        destructor Destroy;override;

        function getImage(img : TImage) : boolean;
        function setImage(img : TImage) : boolean;
    end;

    TPrefGraphic = class
    private
        FCache : TWideStringList; //name - TBrandedGraphic map
    protected
        function getCacheIndex(key : WideString; imgList : WideString = '') : integer;
        procedure addOneImage(imageXML : TXMLTag; imgList : WideString = '');
    public
        Constructor Create();
        Destructor Destroy();override;

        function setBranded(brandedXML : TXMLTag) : boolean;
        function getImage(key : WideString; image : TImage; imgList: WideString = '') : boolean;
        procedure setImage(key : WideString; image : TImage; imgList: WideString = '');
    end;

implementation
uses
Classes;
destructor TBrandedGraphic.destroy;
begin
    inherited destroy();
    if (image <> nil) then
        image.Free();
end;

function dllLoad(g : TBrandedGraphic) : boolean;
var
    ins: THandle;
begin
    Result := false;
    ins := LoadLibrary(PChar(String(g.source)));
    try
        if (ins > 0) then begin
            if (g.image = nil) then
                g.image := TImage.create(nil);
            try
                g.image.Picture.Bitmap.LoadFromResourceName(ins, UpperCase(String(g.resname)));
                Result := true;
            except
                g.image.Free();
                g.image := nil;
            end;
        end;
    finally
        FreeLibrary(ins);
    end;
end;

function resourceLoad(g : TBrandedGraphic) : boolean;
begin
    Result := false;
end;

function fileLoad(g : TBrandedGraphic) : boolean;
var
    img : TImage;
begin
    img := TImage.create(nil);
    try
        try
            img.Picture.LoadFromFile(g.source);
            if (g.image = nil) then
                g.image := TImage.create(nil);
            g.image.Picture.Assign(img.Picture);
            Result := true;
        except
            Result := false;
        end;
    finally
        img.free();
    end;
end;

function TBrandedGraphic.getImage(img : TImage) : boolean;
begin
    Result := true;
    if image = nil then begin
        //see if the pict can be loaded
        if (gtype = 'dll') then
            Result := dllLoad(self)
        else if (gtype = 'resource') then
            Result := resourceLoad(Self)
        else if (gtype = 'file') then
             Result := fileLoad(Self)
        else
            Result := false;
    end;
    if (result) then
        img.Picture.Assign(image.Picture)
end;

function TBrandedGraphic.setImage(img : TImage) : boolean;
begin
    REsult := false;
end;

{**
expect
    <xmlpref>
        <imagelist graphickey='roster'>
            <image graphickey='offline' type='dll' resname='offline' source='.\rosterimages.dll'/>
            <image graphickey='available' type='file' source='.\images\available.bmp'/>
            <image graphickey='away' type='resource' resname='away' source='away.res'/>
        </imagelist>
        <image graphickey='appimage' type='dll' resname='appimage' source='.\rosterimages.dll'/>
    </xmlpref>
*}
Constructor TPrefGraphic.Create();
begin
    inherited Create();
    //parse XML for branding info
    FCache := TWideStringList.Create();

end;

Destructor TPrefGraphic.Destroy();
var
    i: integer;
    g: TBrandedGraphic;
begin
    for i := FCache.Count -1 downto 0 do begin
        g := TBrandedGraphic(FCache.Objects[i]);
        g.Free();
        FCache.Delete(i);
    end;
    FCache.Free();
    inherited Destroy();
end;

function TPrefGraphic.getCacheIndex(key : WideString; imgList : WideString = '') : integer;
var
    fullkey : WideString;
begin
    fullkey := imgList;
    if (fullkey <> '') then
        fullkey := fullkey + ':';
    fullkey := fullkey + key;

    Result := FCache.indexOf(fullkey);
end;

Procedure TPrefGraphic.addOneImage(imageXML : TXMLTag; imgList : WideString = '');
var
    gInfo : TBrandedGraphic;
begin
    gInfo := TBrandedGraphic.create();
    gInfo.graphicKey := imageXML.getAttribute('graphickey');
    if (imgList <> '') then
        gInfo.graphicKey := imgList + ':' + gInfo.graphicKey;
    gInfo.gtype := imageXML.getAttribute('type');
    gInfo.source := imageXML.getAttribute('source');
    gInfo.resname := imageXML.getAttribute('resname');
    gInfo.cached := false;

    if (FCache.indexOf(gInfo.graphicKey) <> -1) then
        FCache.Objects[FCache.indexOf(gInfo.graphicKey)].Free();
    FCache.addObject(gInfo.graphicKey, gInfo);
end;

function TPrefGraphic.setBranded(brandedxml : TXMLTag) : boolean;
var
    children : TXMLTagList;
    imgListChildren : TXMLTagList;
    i, j : integer;
    tag : TXMLTag;
    tstr : WideString;
begin
    if (brandedXML <> nil) then begin
        children := brandedXML.ChildTags();
        for i := 0 to children.Count - 1 do begin
            tag := TXMLTag(children[i]);
            //check if known image tag
            if (tag.name = 'image') then begin
                addOneImage(tag);
            end
            else if (tag.name = 'imagelist') then begin
                tstr := tag.getAttribute('graphickey');
                imgListChildren := tag.childTags();
                for j := 0 to imgListChildren.Count - 1 do begin
                    addOneImage(imgListChildren[j], tstr);
                end;
                imgListChildren.Free();
            end;
        end;
        children.Free();
    end;
    Result := true;
end;


function TPrefGraphic.getImage(key : WideString; image : TImage; imgList: WideString = '') : boolean;
var
    idx : integer;
begin
    idx := getCacheIndex(key, imgList);
    Result := (idx <> -1) and TBrandedGraphic(FCache.Objects[idx]).getImage(image);
end;

procedure TPrefGraphic.setImage(key : WideString; image : TImage; imgList: WideString = '');
var
    idx : integer;
begin
    idx := getCacheIndex(key, imgList);
    if (idx <> -1) then begin //load cache
        TBrandedGraphic(FCache.Objects[idx]).image.picture := image.picture;
    end;
end;

end.
