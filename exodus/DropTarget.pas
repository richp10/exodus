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
unit DropTarget;


{$WARN SYMBOL_PLATFORM OFF}

interface

uses
    Windows, Classes, Controls, Exodus_TLB, Types;

type
  //Forward Declaration
  TExDropTarget = class;

  TExDropActionType = (datNone, datMove, datCopy);
  TExDropUpdateEvent = procedure(Sender: TExDropTarget;
        X, Y: Integer;
        var action: TExDropActionType) of object;
  TExDropExecuteEvent = procedure(Sender: TExDropTarget;
        X, Y: Integer) of object;
  TExDropEndEvent = procedure(Sender: TExDropTarget) of object;

  TExDropTarget = class
  private
    _act: TExDropActionType;
    _items: IExodusItemList;
    _data: Pointer;

    _updateEvt: TExDropUpdateEvent;
    _executeEvt: TExDropExecuteEvent;
    _endEvt: TExDropEndEvent;

    constructor Create(selected: IExodusItemList);
    
  public
    destructor Destroy(); override;

    function Update(X, Y: Integer): Boolean; virtual;
    procedure Execute(X, Y: Integer);

    property DropAction: TExDropActionType read _act;
    property DragItems: IExodusItemList read _items;
    property Data: Pointer read _data write _data;

    property OnUpdate: TExDropUpdateEvent read _updateEvt write _updateEvt;
    property OnExecute: TExDropExecuteEvent read _executeEvt write _executeEvt;
    property OnEnd: TExDropEndEvent read _endEvt write _endEvt;
  end;

function OpenDropTarget(Source: TObject;
        updateEvt: TExDropUpdateEvent = nil;
        executeEvt: TExDropExecuteEvent = nil;
        endEvt: TExDropEndEvent = nil): TExDropTarget;

implementation

uses COMExodusItemList;

function OpenDropTarget(Source: TObject;
        updateEvt: TExDropUpdateEvent;
        executeEvt: TExDropExecuteEvent;
        endEvt: TExDropEndEvent): TExDropTarget;
var
    itemSel: IExodusItemSelection;
    selected: IExodusItemList;
begin
    Result := nil;
    if not Source.GetInterface(IID_IExodusItemSelection, itemSel) then exit;

    selected := itemSel.GetSelectedItems();
    if (selected = nil) or (selected.Count = 0) then exit;

    Result := TExDropTarget.Create(selected);
    if (Result <> nil) then begin
        Result.OnUpdate := updateEvt;
        Result.OnExecute := executeEvt;
        Result.OnEnd := endEvt;
    end;
end;

constructor TExDropTarget.Create(selected: IExodusItemList);
var
    idx: Integer;
begin
    _act := datNone;
    _items := TExodusItemList.Create();
    for idx := 0 to selected.Count - 1 do
        _items.Add(selected.Item[idx]);
end;
destructor TExDropTarget.Destroy();
begin
    if Assigned(_endEvt) then _endEvt(Self);
    _items := nil;
    
    inherited;
end;

function TExDropTarget.Update(X: Integer; Y: Integer): Boolean;
begin
    if Assigned(_updateEvt) then _updateEvt(Self, X, Y, _act);

    Result := (_act <> datNone);
end;
procedure TExDropTarget.Execute(X: Integer; Y: Integer);
begin
    if (_act <> datNone) and Assigned(_executeEvt) then
        _executeEvt(Self, X, Y);
end;

end.
