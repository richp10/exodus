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
unit COMToolbarControl;


{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  SysUtils, Variants, ComCtrls, ComObj, ActiveX, Exodus_TLB, StdVcl, PLUGINCONTROLLib_TLB ;

type
  TExodusToolbarControl = class(TAutoObject, IExodusToolbarControl)
  private
    AXControl: TAXControl;

  public
    constructor Create(AXControl: TAXControl);

  protected
    function  Get_Visible: WordBool; safecall;
    procedure Set_Visible(Value: WordBool); safecall;
    function  Get_Enabled: WordBool; safecall;
    procedure Set_Enabled(Value: WordBool); safecall;

  end;

implementation

uses
    RosterImages, ComServ;

constructor TExodusToolbarControl.Create(AXControl: TAXControl);
begin
      Self.AXControl := AXControl;
end;

function TExodusToolbarControl.Get_Visible: WordBool;
begin
    Result := AXControl.Visible;
end;

procedure TExodusToolbarControl.Set_Visible(Value: WordBool);
begin
    AXControl.Visible := Value;
end;

function TExodusToolbarControl.Get_Enabled: WordBool;
begin
    Result := AXControl.Enabled;
end;

procedure TExodusToolbarControl.Set_Enabled(Value: WordBool);
begin
    AXControl.Enabled := Value;
end;

initialization
  TAutoObjectFactory.Create(ComServer, TExodusToolbarControl, Class_ExodusToolbarControl,
    ciMultiInstance, tmApartment);
end.
