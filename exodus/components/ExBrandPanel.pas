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
unit ExBrandPanel;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Contnrs, ExtCtrls, ExFrame;

type
  TControlInfo = class
    _control: TControl;
    _visible: boolean;
    _enabled: boolean;
  end;

  //A simple panel that autohides, mass enables/disables
  TExBrandPanel = class(TPanel)
  private
      _autoHide: boolean;
    //since we may be "disabling" an already disabled child, we don't want to
    //enable that child when mass enabling. track initial enabled and visible
    //states of children
    _InitialStates: TObjectList; //of TControlInfo

    _CanEnable: boolean;
    _CanShow: boolean; //are children allowed to be shown? entire panel may be hidden.
  protected
    procedure CreateWindowHandle(const Params: TCreateParams); override;
    procedure Loaded(); override;

    function GetAutoHide(): boolean;
    procedure SetAutoHide(b: boolean);

    function VisibleChildren(): integer; virtual;
    procedure EnableChildren(e: boolean; useInitial: boolean = false; ignore: TList = nil); virtual;
    procedure ShowChildren(v: boolean; useInitial: boolean = false; ignore: TList = nil); virtual;

    procedure SetEnabled(enabled: boolean); override;
  public
    Constructor Create(AOwner: TComponent); override;
    Destructor Destroy; Override;

    procedure CheckAutoHide(); virtual;
    procedure CaptureChildStates(); virtual;

    property CanEnabled: boolean read _canEnable write _canEnable;
    property CanShow: boolean read _CanShow write _CanShow;
  published
    property AutoHide: boolean read getAutoHide write setAutoHide;
  end;

  procedure Register();

implementation

procedure Register();
begin
    RegisterComponents('Exodus Components', [TExBrandPanel]);
end;

procedure TExBrandPanel.CreateWindowHandle(const Params: TCreateParams);
begin
    Self.Caption := '';
    Self.ParentColor := True;
    Self.ParentFont := True;

    Self.BevelOuter := bvNone;
    Self.TabStop := false;
    inherited;
end;

procedure TExBrandPanel.Loaded();
begin
    inherited;
    Self.Caption := '';
end;

//protected methods
function TExBrandPanel.visibleChildren(): integer;
var
    i: integer;
begin
    Result := 0;
    for i := 0 to Self.ControlCount -1 do begin
        if (Self.Controls[i].Visible) then
            inc(Result);
    end;
end;

function findControlInfo(list: TList; child: TControl): TControlInfo;
var
    i: integer;
begin
    Result := nil;
    if (list = nil) or (child = nil) then exit;

    for i := 0 to list.Count - 1 do begin
        if (TControlInfo(list[i])._control = child) then begin
            Result := TControlInfo(list[i]);
            break;
        end;
    end;
end;

function controlInList(list: TList; child: TControl): boolean;
var
    i: integer;
begin
    Result := false;
    if (list = nil) or (child = nil) then exit;
    for  i:= 0 to list.Count - 1 do begin
        if (list[i] = child) then begin
          Result := true;
          break;
        end;
    end;
end;

procedure TExBrandPanel.setEnabled(enabled: boolean);
begin
    inherited SetEnabled(_canEnable and enabled);

    if (_canEnable) then
        enableChildren(enabled, true, nil);
end;

procedure TExBrandPanel.showChildren(v: boolean; useInitial: boolean = false; ignore: TList = nil);
var
    i: integer;
    oneT: TControl;
    oneI: TControlInfo;
    initialVisible: boolean;
begin
    for i := 0 to Self.ControlCount -1 do begin
        oneT := Self.Controls[i];
        if (not controlInList(ignore, oneT)) then begin
            if (oneT is TExBrandPanel) then
                TExBrandPanel(oneT).showChildren(v, useInitial, ignore)
            else begin
                initialVisible := true;
                if (v) then begin
                    if (useInitial) then begin
                        oneI := findControlInfo(_initialStates, oneT);
                        if (oneI <> nil) then
                            initialVisible := oneI._visible;
                    end;
                end;
                oneT.Visible := v and initialVisible;
            end;
        end;
    end;
end;

procedure TExBrandPanel.enableChildren(e: boolean; useInitial: boolean; ignore: TList);
var
    i: integer;
    oneT: TControl;
    oneI: TControlInfo;
    initialEnable: boolean;
begin
    for i := 0 to Self.ControlCount -1 do begin
        oneT := Self.Controls[i];
        if (not controlInList(ignore, oneT)) then begin
            if (oneT is TExBrandPanel) then
                TExBrandPanel(oneT).enableChildren(e, useInitial, ignore)
            else begin
              initialEnable := true;
              if (e) then begin
                  if (useInitial) then begin
                      oneI := findControlInfo(_initialStates, oneT);
                      if (oneI <> nil) then
                          initialEnable := oneI._enabled;
                  end;
              end;
              oneT.Enabled := e and initialEnable;
            end;
        end;
    end;
end;

function TExBrandPanel.getAutoHide(): boolean;
begin
    Result := _autoHide;
end;

procedure TExBrandPanel.setAutoHide(b: boolean);
begin
  _autoHide := b;
end;

procedure TExBrandPanel.captureChildStates();
var
  i: integer;
  t: TControlInfo;
begin
  if (csDesigning in Self.ComponentState) then exit;

  if (_initialStates <> nil) then
      _initialStates.Free();
  _initialStates := TObjectList.Create();

  //walk pnlGroups children and get their initial states
  for i := 0 to Self.ControlCount -1 do begin
      if (Controls[i] is TExBrandPanel) then
          TExBrandPanel(Controls[i]).captureChildStates()
      else begin
        t := TControlInfo.create();
        t._control := Self.Controls[i];
        t._visible := Self.Controls[i].visible;
        t._enabled := Self.Controls[i].enabled;
        _initialStates.Add(t);
      end
  end;
end;

Constructor TExBrandPanel.create(AOwner: TComponent);
begin
    inherited;
    _InitialStates := nil;
    _CanEnable := true;
    _CanShow := true;

    TabStop := false; //never want to be a tab stop.
end;

Destructor TExBrandPanel.Destroy;
begin
  if (_initialStates <> nil) then
    _initialStates.Free();
  inherited;
end;

procedure TExBrandPanel.checkAutoHide();
var
    i: integer;
begin
    if ((csDesigning in Self.ComponentState) or ((not _CanShow) and (not Self.Visible))) then exit;
    //update any TExBrandPanel children we have first so we can reliably check
    //visiblity states
    for i := 0 to Self.ControlCount - 1 do begin
        if (Self.Controls[i] is TExBrandPanel) then
            TExBrandPanel(Self.Controls[i]).checkAutoHide();
    end;

    //don't mess with visiblity if not autohiding
    if (_autoHide) then
        Self.Visible := (visibleChildren() > 0);
end;

end.
