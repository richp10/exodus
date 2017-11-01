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
unit COMToolbar;


{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  ComObj, Contnrs, Exodus_TLB, ComCtrls, COMToolbarButton, StdVcl;

type
    IControlDelegate = interface
        function AddControl(ID: widestring; ToolbarName: widestring): IExodusToolbarControl;
    end;

    TExodusToolbarBase = class(TAutoObject, IExodusToolbarController)
    private
        _btnBar: TToolbar;
        _imgList: IExodusRosterImages;
        _growRight: boolean;
        _controlProxy: IControlDelegate;
        _tbName: widestring;
        _buttons: TObjectList;
    protected

        function AddButton(const ImageID: WideString): IExodusToolbarButton; virtual; safecall;
        function GetButton(index: Integer): IExodusToolbarButton; virtual; safecall;
        procedure RemoveButton(const Name: WideString); virtual; safecall;
        function Get_Count: Integer; virtual; safecall;

        function AddControl(const ID: WideString): IExodusToolbarControl; virtual; safecall;
        function GetControl(const Name: widestring): IExodusToolbarControl;virtual; safecall;
        procedure RemoveControl(const Name: WideString); virtual; safecall;
        function Get_ControlCount: Integer; virtual; safecall;

        function Get_ImageList: IExodusRosterImages; virtual; safecall;
        Function Get_Name: widestring; virtual; safecall;

        property Count: integer read Get_Count;
        property ControlCount: integer read Get_ControlCount;
        property ImageList: IExodusRosterImages read Get_ImageList;
        property ButtonBar: TToolbar read _btnBar;
        property Name: widestring read Get_Name;
    public
        constructor Create(btnBar: TToolbar;
                           imgList: IExodusRosterImages;
                           controlProxy: IControlDelegate;
                           Name: widestring;
                           growRight: boolean = true);reintroduce; overload;
        destructor Destroy(); override;

        procedure Initialize(); override;
    end;

    TExodusToolbar = class(TExodusToolbarBase, IExodusToolbar)
    protected
        function AddButton(const ImageID: WideString): IExodusToolbarButton; override;
        function AddControl(const ID: WideString): IExodusToolbarControl; override;
        function Get_Count: Integer; override;
        function GetButton(index: Integer): IExodusToolbarButton; override;
    end;


implementation

uses
     SysUtils, StrUtils, DebugManager, COMExodusControlSite, ComServ;

constructor TExodusToolbarBase.Create(btnBar: TToolbar;
                                      imgList: IExodusRosterImages;
                                      controlProxy: IControlDelegate;
                                      Name: widestring;
                                      growRight: boolean);
begin
    inherited create();
    _btnBar := btnBar;
    _imgList := imgList;
    _growRight := growRight;
    _controlProxy := ControlProxy;
    _tbName := Name;
end;

destructor TExodusToolbarBase.Destroy();
begin
    try
        _buttons.free(); //frees buttons
        _buttons := nil;
        _imgList := nil;
        _btnBar := nil;
        _controlProxy := nil;
        _tbName := '';
    except
        on E:Exception do
            DebugMessage('Exception in ' + Self.ClassName + '.Destroy, (' + E.Message + ')');
    end;
    inherited;
end;

procedure TExodusToolbarBase.Initialize();
begin
    _buttons := TObjectList.create(false); //button bar owns buttuns
    _imgList := nil;
    _btnBar := nil;
    _controlProxy := nil;
    _tbName := '';

    inherited;
end;

function TExodusToolbarBase.Get_ImageList: IExodusRosterImages;
begin
    Result := _imgList;
end;

Function TExodusToolbarBase.Get_Name: widestring;
begin
    Result := _tbName;
end;

function TExodusToolbarBase.Get_Count: Integer;
begin
    Result := _buttons.count;
end;

function TExodusToolbarBase.Get_ControlCount: Integer;
begin
    Raise EOleSysError.create(Self.ClassName + '.ControlCount not implemented', E_NOTIMPL, -1);
end;

function TExodusToolbarBase.GetControl(const Name: widestring): IExodusToolbarControl;
begin
    Raise EOleSysError.create(Self.ClassName + '.GetControl not implemented', E_NOTIMPL, -1);
end;

procedure TExodusToolbarBase.RemoveControl(const Name: WideString);
begin
    Raise EOleSysError.create(Self.ClassName + '.RemoveControl not implemented', E_NOTIMPL, -1);
end;

function TExodusToolbarBase.AddButton(const ImageID: WideString): IExodusToolbarButton;
var
    idx, oldLeft: integer;
    btn: TToolButton;
    g: TGUID;
    guid: string;
begin
    Result := nil;
    try
        if (_btnBar = nil) then exit;
        oldleft := _btnBar.Buttons[_btnBar.ButtonCount - 1].Left + _btnBar.Buttons[_btnBar.ButtonCount - 1].Width;
        _btnBar.AutoSize := false;

        btn := TToolButton.Create(nil); //proxy manages lifetime
        _buttons.add(btn);

        btn.ShowHint := true;
        btn.Top := _btnBar.Buttons[_btnBar.ButtonCount - 1].Top;
        if (_growRight and (_btnBar.ButtonCount > 1)) then
            btn.Left := oldLeft + 1;
        _btnBar.Width := _btnBar.Width + _btnBar.Buttons[_btnBar.ButtonCount - 1].Width + 1;
        btn.Parent := _btnBar;
        _btnBar.AutoSize := true;

        idx := _imgList.Find(ImageID);
        if (idx = -1) then
            idx := 0;
        btn.ImageIndex := idx;

        CreateGUID(g);
        guid := GUIDToString(g);
        guid := AnsiMidStr(guid, 2, length(guid) - 2);
        guid := AnsiReplaceStr(guid, '-', '_');
        btn.Name := _btnBar.Name + '_button_' + guid;

        _btnBar.Visible := true; //we have at least one button
        Result := TExodusToolbarButton.Create(btn, ImageList);
    except
        on E:Exception do
        begin
            DebugMessage('Exception in ' + Self.ClassName + '.AddButton, ImageID: ' + imageID + ', (' + E.Message + ')');
            Result := nil;
        end;
    end;
end;

function TExodusToolbarBase.GetButton(Index: Integer): IExodusToolbarButton;
begin
    Result := nil;
    try
        if (_btnBar = nil) then exit;
        if (Index >= 0) and (Index < _buttons.Count) then
            Result := TExodusToolbarButton.Create(TToolButton(_buttons[Index]), ImageList);
    except
        on E:Exception do
        begin
            DebugMessage('Exception in ' + Self.ClassName + '.GetButton, index: ' + IntToStr(index) + ', (' + E.Message + ')');
            Result := nil;
        end;
    end;
end;

procedure TExodusToolbarBase.RemoveButton(const Name: WideString);
var
    i: integer;
begin
    try
        if (_btnBar = nil) then exit;
        _btnBar.AutoSize := false;
        for i := 0 to _buttons.Count - 1 do
        begin
            if (TToolButton(_buttons[i]).name = Name) then
            begin
                TToolButton(_buttons[i]).Visible := false;
                TToolButton(_buttons[i]).parent := nil; //remove from toolbar
                _buttons.delete(i); //button freed on toolbar destruction, unparented and hidden until then
                break;
            end;
        end;
        _btnBar.AutoSize := true;

        i := 0;
        while (i < _btnBar.ButtonCount) and (not _btnBar.Buttons[i].Visible) do
            inc(i);

        _btnBar.Visible := (i <> _btnBar.ButtonCount);
    except
        on E:Exception do
            DebugMessage('Exception in ' + Self.ClassName + '.RemoveButton, button: ' + Name + ', (' + E.Message + ')');
    end;
end;

function TExodusToolbarBase.AddControl(const ID: WideString): IExodusToolbarControl;
begin
    try
        Result := nil;
        if (_controlProxy <> nil) then
            Result := _controlProxy.AddControl(ID, _tbName);
    except
        on E:Exception do
        begin
            DebugMessage('Exception in ' + Self.ClassName + '.AddControl, ID: ' + ID + ', (' + E.Message + ')');
            Result := nil;
        end;
    end;
end;

function TExodusToolbar.AddButton(const ImageID: WideString): IExodusToolbarButton;
begin
    Result := inherited AddButton(ImageID);
end;

function TExodusToolbar.AddControl(const ID: WideString): IExodusToolbarControl;
begin
    Result := inherited AddControl(ID);
end;

function TExodusToolbar.Get_Count: Integer;
begin
    Result := inherited Get_Count();
end;

function TExodusToolbar.GetButton(index: Integer): IExodusToolbarButton;
begin
    Result := inherited GetButton(index);
end;

initialization
  TAutoObjectFactory.Create(ComServer, TExodusToolbar, Class_ExodusToolbar,
    ciMultiInstance, tmApartment);
end.
