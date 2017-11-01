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
unit COMExodusHover;

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  ComObj, ActiveX, Exodus_TLB, StdVcl, PLUGINCONTROLLib_TLB, ExFrame;

type
  TCOMExodusHover = class(TAutoObject, IExodusHover)
  public
    constructor Create(ItemType: WideString; GUID: WideString);
    destructor Destroy(); override;
  protected
    function Get_Listener: IExodusHoverListener; safecall;
    procedure Set_Listener(const Value: IExodusHoverListener); safecall;
    function Get_AXControl: IUnknown; safecall;
    procedure Show(const Item: IExodusItem); safecall;
    procedure Hide(const Item: IExodusItem); safecall;

  private
    _AxControl: TAxControl;
    _ItemType: WideString;
    _Listener: IExodusHoverListener;
    _HoverFrame: TExFrame;
  end;

implementation

uses
    ComServ,
    RosterForm,
    ExItemHoverForm,
    Controls,
    SysUtils;

constructor TCOMExodusHover.Create(ItemType: WideString; GUID: WideString);
begin
    _Listener := nil;
    _ItemType := ItemType;
    try
       _AxControl := TAXControl.Create(nil, StringToGuid(GUID));

       _HoverFrame := TExFrame.Create(nil);
       _HoverFrame.AutoSize := false;
       _AxControl.Parent := _HoverFrame;
       _HoverFrame.Width := _AxControl.Width;
       _HoverFrame.Height := _AxControl.Height;
       _HoverFrame.AutoSize := true;
    except
        _AxControl := nil;
    end;
end;

destructor TCOMExodusHover.Destroy();
begin
   _AxControl.Free();
   _HoverFrame.Free();
end;

function TCOMExodusHover.Get_Listener: IExodusHoverListener;
begin
    Result := _Listener;
end;

procedure TCOMExodusHover.Set_Listener(const Value: IExodusHoverListener);
begin
    _Listener  := Value;
end;

function TCOMExodusHover.Get_AXControl: IUnknown;
begin
    Result := IUnknown(_AxControl.OleObject);
end;

procedure TCOMExodusHover.Show(const Item: IExodusItem);
begin
   if (GetRosterWindow().HoverWindow.CurrentFrame <> _HoverFrame) then
   begin
       GetRosterWindow().HoverWindow.AutoSize := false;
       if (GetRosterWindow().HoverWindow.CurrentFrame <> nil) then
            GetRosterWindow().HoverWindow.CurrentFrame.Parent := nil;
       GetRosterWindow().HoverWindow.CurrentFrame := _HoverFrame;
       GetRosterWindow().HoverWindow.CurrentFrame.Parent := GetRosterWindow().HoverWindow;
       GetRosterWindow().HoverWindow.AutoSize := true;
    end;
    if (_Listener <> nil) then
        _Listener.OnShow(Item);
end;

procedure TCOMExodusHover.Hide(const Item: IExodusItem);
begin
    if (_Listener <> nil) then
        _Listener.OnHide(Item);
    GetRosterWindow().HoverWindow.CurrentFrame := nil;
    _HoverFrame.Parent := nil;
end;



initialization
  TAutoObjectFactory.Create(ComServer, TCOMExodusHover, Class_COMExodusHover,
    ciMultiInstance, tmApartment);
end.
