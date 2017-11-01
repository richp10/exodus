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

unit ExActions;

interface

uses ActiveX, Classes, ComObj, Contnrs, Unicode, Exodus_TLB;

type TExodusActionCall = procedure(items: IExodusItemList) of Object;
type TExBaseAction = class(TAutoIntfObject, IExodusAction)
    private
        _name: Widestring;
        _caption: Widestring;
        _imgIdx: Integer;
        _enabled: Boolean;
        _subactions: TInterfaceList;
        _call: TExodusActionCall;

    protected
        procedure set_Caption(txt: Widestring);
        procedure set_ImageIndex(idx: Integer);
        procedure set_Enabled(flag: WordBool);

        function Get_SubActionsList(): TInterfaceList;
        procedure Set_SubActionsList(acts: TInterfaceList);
        procedure addSubaction(act: IExodusAction);
        procedure remSubaction(act: IExodusAction);

    public
        constructor Create(name: Widestring);
        destructor Destroy(); override;

        function Get_Name: Widestring; safecall;
        function Get_Caption: Widestring; safecall;
        function Get_ImageIndex: Integer; safecall;
        function Get_Enabled: WordBool; virtual; safecall;
        function Get_SubActionCount: Integer; safecall;
        function Get_SubAction(idx: Integer): IExodusAction; safecall;

        property Caption: Widestring read Get_Caption write Set_Caption;
        property ImageIndex: Integer read Get_ImageIndex write Set_ImageIndex;
        property Enabled: WordBool read Get_Enabled write Set_Enabled;
        property Callback: TExodusActionCall read _call write _call;

        procedure execute(const items: IExodusItemList); virtual; safecall;
    end;

implementation

uses ComServ, SysUtils;

{
    TBaseAction implementation
}
constructor TExBaseAction.Create(name: Widestring);
begin
{$ifdef EXODUS}
    inherited Create(ComServer.TypeLib, IID_IExodusAction);
{$endif}

    _name := name;
    _imgIdx:= -1;
    _enabled := true;
    _subactions := TInterfaceList.Create;
end;
destructor TExBaseAction.Destroy;
begin
    FreeAndNil(_subactions);

    inherited;
end;

function TExBaseAction.Get_Name: Widestring;
begin
    Result := _name;
end;

function TExBaseAction.Get_Caption: Widestring;
begin
    Result := _caption;
end;
procedure TExBaseAction.set_Caption(txt: WideString);
begin
     _caption := txt;
end;

function TExBaseAction.Get_ImageIndex: Integer;
begin
    Result := _imgIdx;
end;
procedure TExBaseAction.set_ImageIndex(idx: Integer);
begin
    _imgIdx := idx;
end;

function TExBaseAction.Get_Enabled: WordBool;
begin
    Result := _enabled;
end;
procedure TExBaseAction.set_Enabled(flag: WordBool);
begin
    _enabled := flag;
end;

function TExBaseAction.Get_SubActionsList: TInterfaceList;
begin
    Result := _subactions;
end;
procedure TExBaseAction.Set_SubActionsList(acts: TInterfaceList);
var
    idx: Integer;
    act: IExodusAction;
begin
    if (acts = _subactions) then exit;
    
    _subactions.Clear();
    if (acts <> nil) and (acts.Count > 0) then begin
        for idx := 0 to acts.Count - 1 do begin
            act := IExodusAction(acts[idx]);
            _subactions.Add(act);
        end;
    end;
end;

function TExBaseAction.Get_SubActionCount: Integer;
begin
    Result := _subactions.Count;
end;
function TExBaseAction.Get_SubAction(idx: Integer): IExodusAction;
begin
    Result := IExodusAction(_subactions[idx]);
end;
procedure TExBaseAction.addSubaction(act: IExodusAction);
begin
    if (act <> nil) and (_subactions.IndexOf(act) = -1) then
        _subactions.Add(act);
end;
procedure TExBaseAction.remSubaction(act: IExodusAction);
begin
    if (act <> nil) then
        _subactions.Remove(act);
end;

procedure TExBaseAction.execute(const items: IExodusItemList);
begin
    if Enabled and Assigned(_call) then
        Callback(items);
end;

end.
