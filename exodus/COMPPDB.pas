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
unit COMPPDB;


{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  ComObj, ActiveX, Exodus_TLB, StdVcl;

type
  TExodusPPDB = class(TAutoObject, IExodusPPDB)
  protected
    function Find(const JabberID, Resource: WideString): IExodusPresence;
      safecall;
    function Next(const JabberID, Resource: WideString): IExodusPresence;
      safecall;
    function Get_Count: Integer; safecall;
    function Get_LastPresence: IExodusPresence; safecall;
    { Protected declarations }
  end;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
implementation

uses
    COMPresence, Presence, Session, ComServ;

{---------------------------------------}
function TExodusPPDB.Find(const JabberID,
  Resource: WideString): IExodusPresence;
var
    p: TJabberPres;
begin
    p := MainSession.ppdb.FindPres(JabberID, Resource);
    if (p <> nil) then
        Result := TExodusPresence.Create(p)
    else
        Result := nil;
end;

{---------------------------------------}
function TExodusPPDB.Next(const JabberID,
  Resource: WideString): IExodusPresence;
var
    p: TJabberPres;
begin
    p := MainSession.ppdb.Findpres(JabberID, Resource);
    p := MainSession.ppdb.NextPres(p);
    if (p <> nil) then
        Result := TExodusPresence.Create(p)
    else
        Result := nil;
end;

{---------------------------------------}
function TExodusPPDB.Get_Count: Integer;
begin
    Result := MainSession.ppdb.Count;
end;

{---------------------------------------}
function TExodusPPDB.Get_LastPresence: IExodusPresence;
var
    p: TJabberPres;
begin
    p := mainSession.ppdb.LastPres;
    if (p <> nil) then
        Result := TExodusPresence(p)
    else
        Result := nil;
end;

initialization
  TAutoObjectFactory.Create(ComServer, TExodusPPDB, Class_ExodusPPDB,
    ciMultiInstance, tmApartment);

end.
