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
unit PluginAuth;


interface

uses
    Exodus_TLB, JabberAuth, Classes, SysUtils;

type
    TExPluginAuth = Class(TJabberAuth)
    public
        plugin: IExodusAuth;

        procedure StartAuthentication(); override;
        procedure CancelAuthentication(); override;

        function StartRegistration(): boolean; override;
        procedure CancelRegistration(); override;
    end;

implementation

procedure TExPluginAuth.StartAuthentication();
begin
    //
    plugin.StartAuth();
end;

procedure TExPluginAuth.CancelAuthentication();
begin
    //
    plugin.CancelAuth();
end;

function TExPluginAuth.StartRegistration(): boolean;
begin
    //
    Result := plugin.StartRegistration();
end;

procedure TExPluginAuth.CancelRegistration();
begin
    //
    plugin.CancelRegistration();
end;


end.
 