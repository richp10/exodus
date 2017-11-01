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

unit COMExodusItemList;

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  ComObj, Classes, ActiveX, Exodus_TLB, StdVcl;

type
  TExodusItemList = class(TAutoObject, IExodusItemList)
  private
    _items: TInterfaceList;

  protected
    function Get_Count: Integer; safecall;
    function Get_Item(Index: Integer): IExodusItem; safecall;
    function IndexOf(const item: IExodusItem): Integer; safecall;
    procedure Add(const item: IExodusItem); safecall;
    procedure Clear; safecall;
    procedure Delete(index: Integer); safecall;
    procedure Set_Item(Index: Integer; const Value: IExodusItem); safecall;
    procedure Remove(const Value: IExodusItem); safecall;
    function IExodusItemList.Get_Count = IExodusItemList_Get_Count;
    function IExodusItemList_Get_Count: Integer; safecall;
    function IndexOfUid(const uid: WideString): Integer; safecall;
    function CountOfType(const itemtype: WideString): Integer; safecall;
  private
    function _GetItems() : TInterfaceList;
  public
    constructor Create;
    destructor Destroy; override;
  end;

implementation

uses ComServ;

constructor TExodusItemList.Create;
begin
    inherited Create;

    _GetItems();    //pre-load if we're in Exodus codebase
end;

destructor TExodusItemList.Destroy;
begin
    _GetItems().Free;

    inherited;
end;

function TExodusItemList.Get_Count: Integer;
begin
    Result := _GetItems().Count;
end;

function TExodusItemList.Get_Item(Index: Integer): IExodusItem;
begin
    Result := IExodusItem(_GetItems().Items[Index]);
end;
procedure TExodusItemList.Set_Item(Index: Integer; const Value: IExodusItem);
begin
    if (value <> nil) then
        _GetItems().Items[index] := value
    else
        _GetItems().Delete(Index);
end;

procedure TExodusItemList.Add(const item: IExodusItem);
begin
    if (IndexOf(item) = -1) then _GetItems().Add(item);
end;
procedure TExodusItemList.Delete(index: Integer);
begin
    _GetItems().Delete(index);
end;
procedure TExodusItemList.Clear;
begin
    _GetItems().Clear;
end;

function TExodusItemList.IndexOf(const item: IExodusItem): Integer;
begin
    Result := _GetItems().IndexOf(item);
end;
procedure TExodusItemList.Remove(const Value: IExodusItem);
begin
    _GetItems().Remove(Value);
end;

function TExodusItemList.IExodusItemList_Get_Count: Integer;
begin
    Result := _GetItems().Count;
end;

function TExodusItemList._GetItems() : TInterfaceList;
begin
    if (_items = nil) then
        _items := TInterfaceList.Create;
    Result := _items;
end;

function TExodusItemList.IndexOfUid(const uid: WideString): Integer;
var
    items: TInterfaceList;
    item: IExodusItem;
    idx: Integer;
begin
    items := _GetItems();
    Result := -1;

    for idx := 0 to items.Count - 1 do begin
        item := items[idx] as IExodusItem;
        if item.UID = uid then begin
            Result := idx;
            exit;
        end;
    end;
end;

function TExodusItemList.CountOfType(const itemtype: WideString): Integer;
var
    idx: Integer;
    items: TInterfaceList;
begin
    Result := 0;
    items := _GetItems();
    for idx := 0 to items.Count - 1 do begin
        if IExodusItem(items[idx]).Type_ = itemtype then
            Inc(Result);
    end;
end;

initialization
  TAutoObjectFactory.Create(ComServer, TExodusItemList, Class_ExodusItemList,
    ciMultiInstance, tmApartment);
end.
