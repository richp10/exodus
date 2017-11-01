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
unit COMEntity;

{$WARN SYMBOL_PLATFORM OFF}


interface

uses
    Entity, 
    ComObj, ActiveX, Exodus_TLB, StdVcl;

type
  TExodusEntity = class(TAutoObject, IExodusEntity)
  protected
    function Get_category: WideString; safecall;
    function Get_discoType: WideString; safecall;
    function Get_jid: WideString; safecall;
    function Get_Name: WideString; safecall;
    function Get_node: WideString; safecall;
    function hasFeature(const Feature: WideString): WordBool; safecall;
    function hasIdentity(const Category, DiscoType: WideString): WordBool;
      safecall;
    function hasInfo: WordBool; safecall;
    function hasItems: WordBool; safecall;
    function Get_Feature(Index: Integer): WideString; safecall;
    function Get_FeatureCount: Integer; safecall;
    function Get_Item(Index: Integer): IExodusEntity; safecall;
    function Get_ItemsCount: Integer; safecall;

  private
    _e: TJabberEntity;

  public
    constructor Create(e: TJabberEntity);

  end;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
implementation

uses ComServ;

{---------------------------------------}
constructor TExodusEntity.Create(e: TJabberEntity);
begin
    _e := e;
end;

{---------------------------------------}
function TExodusEntity.Get_category: WideString;
begin
    Result := _e.Category;
end;

{---------------------------------------}
function TExodusEntity.Get_discoType: WideString;
begin
    Result := _e.CatType;
end;

{---------------------------------------}
function TExodusEntity.Get_jid: WideString;
begin
    Result := _e.Jid.full;
end;

{---------------------------------------}
function TExodusEntity.Get_Name: WideString;
begin
    Result := _e.Name;
end;

{---------------------------------------}
function TExodusEntity.Get_node: WideString;
begin
    Result := _e.Node;
end;

{---------------------------------------}
function TExodusEntity.hasFeature(const Feature: WideString): WordBool;
begin
    Result := _e.hasFeature(Feature);
end;

{---------------------------------------}
function TExodusEntity.hasIdentity(const Category,
  DiscoType: WideString): WordBool;
begin
    Result := _e.hasIdentity(Category, DiscoType);
end;

{---------------------------------------}
function TExodusEntity.hasInfo: WordBool;
begin
    Result := _e.hasInfo;
end;

{---------------------------------------}
function TExodusEntity.hasItems: WordBool;
begin
    Result := _e.hasItems;
end;

{---------------------------------------}
function TExodusEntity.Get_Feature(Index: Integer): WideString;
begin
    Result := _e.Features[Index];
end;

{---------------------------------------}
function TExodusEntity.Get_FeatureCount: Integer;
begin
    Result := _e.FeatureCount;
end;

{---------------------------------------}
function TExodusEntity.Get_Item(Index: Integer): IExodusEntity;
begin
    if (Index < _e.ItemCount) then
        Result := TExodusEntity.Create(_e.Items[Index])
    else
        Result := nil;
end;

{---------------------------------------}
function TExodusEntity.Get_ItemsCount: Integer;
begin
    Result := _e.ItemCount;
end;

initialization
  TAutoObjectFactory.Create(ComServer, TExodusEntity, Class_ExodusEntity,
    ciMultiInstance, tmApartment);

end.
