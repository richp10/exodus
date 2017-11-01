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
unit COMToolbarButton;


{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  ComCtrls, ComObj, Exodus_TLB, StdVcl;

type
  TExodusToolbarButton = class(TAutoObject, IExodusToolbarButton, IExodusToolbarButton2)
  private
    _button: TToolButton;
    _menu_listener: IExodusMenuListener;
    _imgList: IExodusRosterImages;
    _imgID: widestring;
    _assignedOnClick: boolean;
    _name: widestring;
  public
    constructor Create(btn: TToolButton; ImageList: IExodusRosterImages);reintroduce; overload;
    destructor Destroy(); override;
  protected
    function Get_ImageID: WideString; safecall;
    function Get_Tooltip: WideString; safecall;
    function Get_Visible: WordBool; safecall;
    procedure Set_ImageID(const Value: WideString); safecall;
    procedure Set_Tooltip(const Value: WideString); safecall;
    procedure Set_Visible(Value: WordBool); safecall;
    function Get_Enabled: WordBool; safecall;
    procedure Set_Enabled(Value: WordBool); safecall;
    function Get_MenuListener: IExodusMenuListener; safecall;
    procedure Set_MenuListener(const Value: IExodusMenuListener); safecall;
    function Get_Name: Widestring; safecall;
  public
    procedure OnClick(Sender: TObject);
  end;


implementation

uses
    ComServ, DebugManager, SysUtils;

constructor TExodusToolbarButton.Create(btn: TToolButton; ImageList: IExodusRosterImages);
begin
    _button := btn;
    _name := _button.Name;
    _assignedOnClick := not Assigned(_button.OnClick);
    if (_assignedOnClick) then
        _button.OnClick := Self.OnClick;
    _imgList := ImageList;
    inherited create();
end;

destructor TExodusToolbarButton.Destroy();
begin
    try
        _menu_listener := nil;
        _imgList := nil;
        if (_assignedOnClick) then
            _button.OnClick := nil;
        _button := nil;
    except
        On E:Exception do
            DebugMessage('Exception in TExodusToolbarButton.Destroy Button: ' + _name +', (' + E.message + ')');
    end;
    inherited;
end;

function TExodusToolbarButton.Get_ImageID: WideString;
begin
    Result := _imgID;
end;

function TExodusToolbarButton.Get_Tooltip: WideString;
begin
    Result := _button.Hint;
end;

function TExodusToolbarButton.Get_Visible: WordBool;
begin
    Result := _button.Visible;
end;

procedure TExodusToolbarButton.Set_ImageID(const Value: WideString);
var
    idx: integer;
begin
    idx := _ImgList.Find(Value);
    if (idx >= 0) then
    begin
        _imgID := Value;
        _button.ImageIndex := idx;
    end;
end;

procedure TExodusToolbarButton.Set_Tooltip(const Value: WideString);
begin
    _button.Hint := Value;
end;

procedure TExodusToolbarButton.Set_Visible(Value: WordBool);
begin
    _button.Visible := Value;
end;

function TExodusToolbarButton.Get_Enabled: WordBool;
begin
    Result := _button.Enabled;
end;

procedure TExodusToolbarButton.Set_Enabled(Value: WordBool);
begin
    _button.Enabled := Value;
end;

function TExodusToolbarButton.Get_MenuListener: IExodusMenuListener;
begin
    Result := _menu_listener;
end;

procedure TExodusToolbarButton.Set_MenuListener(const Value: IExodusMenuListener);
begin
    _menu_listener := Value;
end;

procedure TExodusToolbarButton.OnClick(Sender: TObject);
begin
    if (_menu_listener <> nil) then begin
        try
            _menu_listener.OnMenuItemClick(_button.Name, '');
        except
            On E:Exception do
                DebugMessage('Exception in TExodusToolbarButton.OnClick Button: ' + _button.Name +', (' + E.message + ')');
        end;
    end;
end;

function TExodusToolbarButton.Get_Name(): Widestring;
begin
    Result := _name;
end;

initialization
  TAutoObjectFactory.Create(ComServer, TExodusToolbarButton, Class_ExodusToolbarButton,
    ciMultiInstance, tmApartment);
end.
