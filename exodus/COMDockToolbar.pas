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
unit COMDockToolbar;


{$WARN SYMBOL_PLATFORM OFF}

interface

uses
    ComObj, Exodus_TLB, COMToolbar, StdVcl;

type
    TExodusDockToolbar = class(TExodusToolbarBase, IExodusDockToolbar)
    protected
        function AddButton(const ImageID: WideString): ExodusToolbarButton; override; safecall;
        function AddControl(const ID: WideString): ExodusToolbarControl; override; safecall;
        function Get_Count: Integer; override;
        function GetButton(index: Integer): ExodusToolbarButton; override;safecall;
        procedure RemoveButton(const button: WideString); override;
    end;

implementation

uses
    ComServ;

function TExodusDockToolbar.AddButton(const ImageID: WideString): ExodusToolbarButton;
begin
    Result := inherited AddButton(ImageID);
end;

function TExodusDockToolbar.AddControl(const ID: WideString): ExodusToolbarControl;
begin
    Result := inherited AddControl(ID);
end;

function TExodusDockToolbar.Get_Count: Integer;
begin
    Result := inherited Get_Count();
end;

function TExodusDockToolbar.GetButton(index: Integer): ExodusToolbarButton;
begin
    Result := inherited GetButton(index);
end;

procedure TExodusDockToolbar.RemoveButton(const button: WideString);
begin
    inherited;
end;

initialization
    TAutoObjectFactory.Create(ComServer, TExodusDockToolbar, Class_ExodusDockToolbar,
                              ciMultiInstance, tmApartment);
end.
