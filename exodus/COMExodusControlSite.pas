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
unit COMExodusControlSite;


{$WARN SYMBOL_PLATFORM OFF}

interface

uses
    Classes, ComObj, Controls, OleCtrls, OleCtnrs, Exodus_TLB;

type
    //Exodus component wrapper for ActiveX controls.

    //ActiveX controls should be wrapped in a TWinControl component for
    //optimal results. Toolbars, activex dock containers create and parent
    //this component.
    //Wrapper component implements an interfaces that allows the container (wrapper)
    //to enable/show/align client, access underlying control and get control
    //metadata
    TExodusControlSite = class(TOleControl, IExodusControlSite, IExodusToolbarControl)
    private
        _control: IDispatch;
        _controlClassID: TGUID;
        _controlName: widestring;
    protected
        //IExodusToolbarControl
        function Get_Enabled: WordBool; virtual; safecall;
        function Get_Visible: WordBool; virtual; safecall;
        procedure Set_Enabled(value: WordBool); virtual; safecall;
        procedure Set_Visible(value: WordBool); virtual; safecall;
        //IExodusActiveXContainer
        function Get_Control: IDispatch; virtual; safecall;
        function Get_ControlName: WideString; virtual; safecall;
        function Get_ControlGUID: WideString; virtual; safecall;
        function Get_AlignClient: WordBool; virtual; safecall;
        procedure Set_AlignClient(value: WordBool); virtual; safecall;

        procedure InitControlData; override;
    public
        constructor Create(AOwner: TComponent; Parent: TWinControl; ClassId: TGuid); reintroduce; overload;
        destructor Destroy(); override;

        property  ControlInterface: IDispatch read Get_Control;
        property  DefaultInterface: IDispatch read Get_Control;

        property Control: IDispatch read Get_Control;
        property ControlName: WideString read Get_ControlName;
        property ControlGUID: WideString read Get_ControlGUID;
        property AlignClient: WordBool read Get_AlignClient write Set_AlignClient;
    end;

implementation

uses SysUtils, StrUtils, Forms;
var
    _nameCounter: integer;

procedure repaintParentForm(parent: TControl);
var
    tc: TControl;
begin
    if (parent <> nil) then
    begin
        tc := GetParentForm(parent, false); //get first parent form, not topmost
        if (tc = nil) then
            tc := parent;
        tc.Repaint();
    end;
end;

procedure TExodusControlSite.InitControlData;
const
  CControlData: TControlData2 = (
    EventIID: '';
    EventCount: 0;
    EventDispIDs: nil;
    LicenseKey: nil; //$00000000;
    Flags: $00000000;
    Version: 100);
begin
  ControlData := @CControlData;
  ControlData.ClassID := _controlClassID;

end;

constructor TExodusControlSite.Create(AOwner: TComponent; Parent: TWinControl; ClassId: TGuid);
begin
    _control := nil;
    _controlClassID := ClassID; //overrides CControlData
    _controlName := 'excontrol_' + IntToStr(_nameCounter);
    inc(_nameCounter);
    inherited create(AOwner);
    Self.Parent := Parent;
    Self.Name := _controlName + '_container';
end;

destructor TExodusControlSite.Destroy();
begin
    _control := nil;
    inherited;
end;

function TExodusControlSite.Get_Enabled: WordBool;
begin
    Result := Enabled;
end;

function TExodusControlSite.Get_Visible: WordBool;
begin
    Result := Visible;
end;

procedure TExodusControlSite.Set_Enabled(value: WordBool);
begin
    Enabled := value;
    repaintParentForm(parent);
end;

procedure TExodusControlSite.Set_Visible(value: WordBool);
begin
    Visible := value;
    repaintParentForm(parent);
end;

function TExodusControlSite.Get_ControlName: WideString;
begin
    Result := _controlName;
end;

function TExodusControlSite.Get_ControlGUID: WideString;
begin
    Result := GUIDToString(_controlClassID);
end;

function TExodusControlSite.Get_Control: IDispatch;
begin
    if (_control = nil) then
        _control := IUnknown(OleObject) as IDispatch;
    Result := _control;
end;

function TExodusControlSite.Get_AlignClient: WordBool;
begin
    Result := (Align = alClient);
end;

procedure TExodusControlSite.Set_AlignClient(value: WordBool);
begin
    if (value) then
        Align := alClient
    else
        Align := alNone;

    repaintParentForm(parent);
end;

initialization
    _nameCounter := 0; 
end.
