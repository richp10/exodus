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
unit COMPresence;


{$WARN SYMBOL_PLATFORM OFF}

interface

uses
    Presence, ComObj, ActiveX, Exodus_TLB, StdVcl;

type
  TExodusPresence = class(TAutoObject, IExodusPresence)
  protected
    function Get_ErrorString: WideString; safecall;
    function Get_PresType: WideString; safecall;
    function Get_Priority: Integer; safecall;
    function Get_Show: WideString; safecall;
    function Get_Status: WideString; safecall;
    function XML: WideString; safecall;
    function isSubscription: WordBool; safecall;
    procedure Set_ErrorString(const Value: WideString); safecall;
    procedure Set_PresType(const Value: WideString); safecall;
    procedure Set_Priority(Value: Integer); safecall;
    procedure Set_Show(const Value: WideString); safecall;
    procedure Set_Status(const Value: WideString); safecall;
    function Get_fromJid: WideString; safecall;
    function Get_toJid: WideString; safecall;
    procedure Set_fromJid(const Value: WideString); safecall;
    procedure Set_toJid(const Value: WideString); safecall;
    { Protected declarations }
  private
    _p: TJabberPres;
  public
    constructor Create(p: TJabberPres);
  end;

implementation

uses
    JabberID, ComServ;

{---------------------------------------}
constructor TExodusPresence.Create(p: TJabberPres);
begin
    _p := p;
end;

{---------------------------------------}
function TExodusPresence.Get_ErrorString: WideString;
begin
    Result := _p.error_code;
end;

{---------------------------------------}
function TExodusPresence.Get_PresType: WideString;
begin
    Result := _p.PresType;
end;

{---------------------------------------}
function TExodusPresence.Get_Priority: Integer;
begin
    Result := _p.Priority;
end;

{---------------------------------------}
function TExodusPresence.Get_Show: WideString;
begin
    Result := _p.Show;
end;

{---------------------------------------}
function TExodusPresence.Get_Status: WideString;
begin
    Result := _p.Status;
end;

{---------------------------------------}
function TExodusPresence.XML: WideString;
begin
    Result := _p.xml();
end;

{---------------------------------------}
function TExodusPresence.isSubscription: WordBool;
begin
    Result := _p.isSubscription();
end;

{---------------------------------------}
procedure TExodusPresence.Set_ErrorString(const Value: WideString);
begin
    _p.error_code := Value;
end;

{---------------------------------------}
procedure TExodusPresence.Set_PresType(const Value: WideString);
begin
    _p.PresType := Value;
end;

{---------------------------------------}
procedure TExodusPresence.Set_Priority(Value: Integer);
begin
    _p.Priority := Value;
end;

{---------------------------------------}
procedure TExodusPresence.Set_Show(const Value: WideString);
begin
    _p.Show := Value;
end;

{---------------------------------------}
procedure TExodusPresence.Set_Status(const Value: WideString);
begin
    _p.Status := Value;
end;

{---------------------------------------}
function TExodusPresence.Get_fromJid: WideString;
begin
    Result := _p.fromJid.full();
end;

{---------------------------------------}
function TExodusPresence.Get_toJid: WideString;
begin
    Result := _p.toJid.full();
end;

{---------------------------------------}
procedure TExodusPresence.Set_fromJid(const Value: WideString);
var
    tmpjid: TJabberID;
begin
    tmpjid := TJabberID.Create(Value);
    _p.fromJid := tmpjid;
end;

{---------------------------------------}
procedure TExodusPresence.Set_toJid(const Value: WideString);
var
    tmpjid: TJabberID;
begin
    tmpjid := TJabberID.Create(value);
    _p.toJid := tmpjid;
end;

initialization
  TAutoObjectFactory.Create(ComServer, TExodusPresence, Class_ExodusPresence,
    ciMultiInstance, tmApartment);

end.
