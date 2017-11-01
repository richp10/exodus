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
unit JabberAuth;


interface

uses
    Classes, SysUtils;

type
    TJabberAuth = class;
    TJabberAuthFactory = function(session: TObject): TJabberAuth;

    TJabberAuth = Class
    public
        prompt_password: boolean;

        procedure StartAuthentication(); virtual; abstract;
        procedure CancelAuthentication(); virtual; abstract;

        function StartRegistration(): boolean; virtual; abstract;
        procedure CancelRegistration(); virtual; abstract;
    end;

function RegisterJabberAuth(name: string; factory: TJabberAuthFactory): boolean;
function CreateJabberAuth(name: string; session: TObject): TJabberAuth;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
implementation
uses
    Session;

var
    jAuthRegistry: TStringlist;

{---------------------------------------}
function RegisterJabberAuth(name: string; factory: TJabberAuthFactory): boolean;
var
    idx: integer;
begin
    Result := false;

    idx := jAuthRegistry.IndexOf(name);
    if (idx >= 0) then exit;

    jAuthRegistry.AddObject(name, @factory);
    Result := true;
end;

{---------------------------------------}
function CreateJabberAuth(name: string; session: TObject): TJabberAuth;
var
    js: TJabberSession;
    factory: TJabberAuthFactory;
    idx: integer;
begin
    Result := nil;
    idx := jAuthRegistry.IndexOf(name);
    if (idx >= 0) then begin
        factory := TJabberAuthFactory(Pointer(integer((jAuthRegistry.Objects[idx]))));
        js := TJabberSession(session);
        Result := factory(js);
    end;
end;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
initialization
    jAuthRegistry := TStringList.Create();

finalization
    jAuthRegistry.Free();

end.
