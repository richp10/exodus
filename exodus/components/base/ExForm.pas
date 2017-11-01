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
unit ExForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, TntForms;

type
  TExForm = class(TTntForm)
  protected
    procedure CreateWindowHandle(const Params: TCreateParams);override;
  public
    class procedure SetDefaultFont(font: TFont);
    class procedure SetDefaultWindowColor(color: TColor);
    class procedure GetDefaultFont(DestFont: TFont);
    class function GetDefaultWindowColor(): TColor;
  end;


implementation

{$R *.dfm}
var
    brandedFont: TFont;
    brandedColor: TColor;


class procedure TExForm.SetDefaultFont(font: TFont);
begin
    brandedFont.Assign(font);
end;

class procedure TExForm.SetDefaultWindowColor(color: TColor);
begin
    brandedColor := color;
end;

class procedure TExForm.GetDefaultFont(DestFont: TFont);
begin
    DestFont.Assign(brandedFont);
end;

class function TExForm.GetDefaultWindowColor(): TColor;
begin
    Result := brandedColor;
end;

procedure TExForm.CreateWindowHandle(const Params: TCreateParams);
begin
    inherited;
    Self.Color := GetDefaultWindowColor();
    GetDefaultFont(Self.Font);
end;

initialization

    brandedFont := TFont.Create();
    // Assign either Arial or Arial Unicode MS to this form.
    if (Screen.Fonts.IndexOf('Arial Unicode MS') = -1) then
        brandedFont.name := 'Arial'
    else
        brandedFont.Name := 'Arial Unicode MS';

    brandedFont.size := 8;
    brandedFont.Color := clWindowText;
    brandedFont.Style := [];

    brandedColor := clBtnFace;

finalization
    brandedFont.Free();
end.
