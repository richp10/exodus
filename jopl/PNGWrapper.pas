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
unit PNGWrapper;

interface
uses
    NGImages,
    graphics,
    classes;

type
    TPNGWrapper = class(TNGImage)
    protected
        procedure SetBackgroundColor(value: TColor); virtual;
        function GetBackgroundColor(): TColor; virtual;
    public
        constructor Create(BackColor: TColor); reintroduce;overload;

        function  GetEmpty : boolean; override;
        procedure Assign(Source: TPersistent); override;

        procedure LoadFromStream(stream: TStream); override;
        procedure LoadFromFile(const FileName: string ); override;

        property BackgroundColor: TCOlor read GetBackgroundColor write SetBackgroundColor;
    end;

implementation

constructor TPNGWrapper.Create(BackColor: TColor);
begin
    inherited create();
    BGColor := BackColor;
end;

function TPNGWrapper.GetBackgroundColor(): TColor;
begin
    Result := BGColor;
end;

//set color to show through alpha
procedure TPNGWrapper.SetBackgroundColor(value: TColor);
var
    ts: TMemoryStream;
    tpng: TPNGWrapper;
begin
    if (Self.BGColor <> ColorToRGB(value)) then
    begin
        ts := nil;
        //if lib is currently displaying the bitmap, streeam a copy
        //and reload after setting backcolor. Only way
        //to force bitmap to be completely rebuilt (probably some
        //slick way to do it, no time to figure it out
        if (not Self.Empty) and (Self.StatusDisplaying) then
        begin
            MNG_Stop(); //mng_display_reset
            ts := TMemoryStream.create();
            Self.SaveToStream(ts);
            ts.Seek(0, soBeginning)
        end;
        Self.BGColor := ColorToRGB(value);
        Self.UseBKGD := true;
        //reload if we were displaying
        if (ts <> nil) then begin
            tpng := TPNGWrapper.create();
            tpng.BGColor := Self.BGColor;
            tpng.UseBKGD := true;
            tpng.LoadFromStream(ts); //mng_initialize, mng_display
            Self.Assign(tpng);
            tpng.free(); //keeps ref count == 1
        end;
        ts.Free();
    end;
end;

function  TPNGWrapper.GetEmpty : boolean;
var
    tbm: Graphics.TBitmap;
begin
    Result := inherited GetEmpty();
    //check bitmap for emptyness. NGImage is empty if we have
    //an unassigned libmng handle, not if this bitmap is empty or not...
    //handle is created during construction so, in essence an NGImage is nver empty?
    //dummy up an empty by checking bitmaps contents
    if (not Result) then
    begin
        tbm := Self. CopyBitmap();
        Result := tbm.Empty;
        tbm.free();
    end;
end;

procedure TPNGWrapper.Assign(Source : TPersistent);
var
    tpng: TPNGWrapper;
begin
    if (Source <> nil) then
        inherited
    else begin
        //assigning nil does not clear NGImage bitmap
        //assign an empty png isntead
        tpng := TPNGWrapper.create();
        inherited Assign(tpng);
        tpng.Free(); //keeps ref count == 1
    end;
end;

procedure TPNGWrapper.LoadFromFile(const filename: string);
begin
    inherited;
    MNG_Pause(); //mng_display_freeze, OK state to write
end;

procedure TPNGWrapper.LoadFromStream(stream: TStream);
begin
    inherited;
    MNG_Pause(); //mng_display_freeze, OK state to write
end;

initialization
    TPicture.RegisterFileFormat('PNG', 'Portable Network Graphics', TPNGWrapper);
finalization
    TPicture.UnregisterGraphicClass(TPNGWrapper);

end.
