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
unit COMMsgOutToolbar;


{$WARN SYMBOL_PLATFORM OFF}

interface

uses
    ComObj, Exodus_TLB, COMToolbar, StdVcl;

type
    TExodusMsgOutToolbar = class(TExodusToolbarBase, IExodusMsgOutToolbar)
    protected
        function AddButton(const ImageID: WideString): IExodusToolbarButton; override;
        function AddControl(const ID: WideString): IExodusToolbarControl; override;
        function Get_Count: Integer; override;
        function GetButton(index: Integer): IExodusToolbarButton; override;
        procedure RemoveButton(const button: WideString); override;
    end;

implementation

uses
    ComServ;

function TExodusMsgOutToolbar.AddButton(const ImageID: WideString): IExodusToolbarButton;
begin
    Result := inherited AddButton(ImageID);
end;

function TExodusMsgOutToolbar.AddControl(const ID: WideString): IExodusToolbarControl;
begin
    Result := inherited AddControl(ID);
end;

function TExodusMsgOutToolbar.Get_Count: Integer;
begin
    Result := inherited Get_Count();
end;

function TExodusMsgOutToolbar.GetButton(index: Integer): IExodusToolbarButton;
begin
    Result := inherited GetButton(index);
end;

procedure TExodusMsgOutToolbar.RemoveButton(const button: WideString);
begin
    inherited;
end;

initialization
    TAutoObjectFactory.Create(ComServer, TExodusMsgOutToolbar, Class_ExodusMsgOutToolbar,
                              ciMultiInstance, tmApartment);
end.
