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
unit COMEntityCache;

{$WARN SYMBOL_PLATFORM OFF}




interface

uses
  ComObj, ActiveX, Exodus_TLB, StdVcl;

type
  TExodusEntityCache = class(TAutoObject, IExodusEntityCache)
  protected
    function discoInfo(const jid, node: WideString;
      timeout: Integer): IExodusEntity; safecall;
    function discoItems(const jid, node: WideString;
      timeout: Integer): IExodusEntity; safecall;
    function fetch(const jid, node: WideString;
      items_limit: WordBool): IExodusEntity; safecall;
    function getByJid(const jid, node: WideString): IExodusEntity; safecall;

  end;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
implementation

uses
    Entity, COMEntity, Session, EntityCache, ComServ;

{---------------------------------------}
function TExodusEntityCache.discoInfo(const jid, node: WideString;
  timeout: Integer): IExodusEntity;
var
    e: TJabberEntity;
    ce: TExodusEntity;
begin
    e := jEntityCache.discoInfo(jid, MainSession, node, timeout);
    ce := TExodusEntity.Create(e);
    Result := ce;
end;

{---------------------------------------}
function TExodusEntityCache.discoItems(const jid, node: WideString;
  timeout: Integer): IExodusEntity;
var
    e: TJabberEntity;
    ce: TExodusEntity;
begin
    e := jEntityCache.discoItems(jid, MainSession, node, timeout);
    ce := TExodusEntity.Create(e);
    Result := ce;
end;

{---------------------------------------}
function TExodusEntityCache.fetch(const jid, node: WideString;
  items_limit: WordBool): IExodusEntity;
var
    e: TJabberEntity;
    ce: TExodusEntity;
begin
    e := jEntityCache.fetch(jid, MainSession, items_limit, node);
    ce := TExodusEntity.Create(e);
    Result := ce;
end;

{---------------------------------------}
function TExodusEntityCache.getByJid(const jid,
  node: WideString): IExodusEntity;
var
    e: TJabberEntity;
    ce: TExodusEntity;
begin
    e := jEntityCache.getByJid(jid, node);
    if (e <> nil) then
        ce := TExodusEntity.Create(e)
    else
        ce := nil;
    Result := ce;
end;

initialization
  TAutoObjectFactory.Create(ComServer, TExodusEntityCache, Class_ExodusEntityCache,
    ciMultiInstance, tmApartment);

end.
