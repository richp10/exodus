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
unit ExCheckGroupBox;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,
  ExBrandPanel, StdCtrls, TntStdCtrls, ExtCtrls, TntExtCtrls;

type
  TExCheckGroupBox = class(TExBrandPanel)
    procedure chkBoxClick(Sender: TObject);
  private
    _ignoreList: TList;
    _initialized: boolean;
    _checkChangeEvent: TNotifyEvent;

    _chkBox: TTntCheckBox;
    _pnlTop: TTntPanel;
    _pnlBevel: TTntPanel;
    _bevel: TTntBevel;

    _ControlsInitialized: boolean;
    
    procedure InitializeControls();
  protected
    //creates top panel and caption label
    procedure CreateWindowHandle(const Params: TCreateParams); override;

    procedure AutoSizeCheckBox();
    function GetChecked(): boolean;
    procedure SetChecked(b: boolean);

    procedure SetEnabled(enabled: boolean);override;
    procedure EnableChildren(e: boolean; useInitial: boolean = false; ignore: TList = nil); override;
    function VisibleChildren(): integer; override;
    function GetCaption(): WideString;
    procedure SetCaption(c: widestring);
    procedure Loaded();override;
  public
    Constructor Create(AOwner: TComponent);override;
    Destructor Destroy();override;


    procedure CheckAutoHide();override;
    procedure CaptureChildStates();override;
  published
    Property Checked: boolean read getChecked write setChecked;
    Property Caption: Widestring read GetCaption write SetCaption;
    property OnCheckChanged: TNotifyEvent read _checkChangeEvent write _checkChangeEvent;
  end;

  procedure Register();

implementation
uses JclWideStrings;


procedure Register();
begin
    RegisterComponents('Exodus Components', [TExCheckGroupBox]);
end;


procedure OutputDebugMsg(Message : String);
begin
    OutputDebugString(PChar(Message));
end;

procedure TExCheckGroupBox.Loaded();
begin
    inherited;
    //force a resize of our caption
    Self.Caption := Self.Caption;
end;

Constructor TExCheckGroupBox.Create(AOwner: TComponent);
begin
    inherited;
    _pnlTop := TTntPanel.Create(Self);
    _pnlTop.Parent := Self;
    _pnlTop.Name := 'pnlTop';

    _pnlBevel := TTntPanel.Create(_pnlTop);
    _pnlBevel.Parent := _pnlTop;
    _pnlBevel.Name := 'pnlBevel';
    _pnlBevel.Caption := '';

    _bevel := TTntBevel.Create(_pnlBevel);
    _bevel.parent := _pnlBevel;
    _bevel.Shape := bsTopLine;
    _bevel.Name := 'bevel';

    _chkBox := TTntCheckBox.Create(_pnlTop);
    _chkBox.Parent := _pnlTop;
    _chkBox.Name := 'chkBox';

    _ignoreList := nil;
    _initialized := false;
    _ControlsInitialized := false;
end;

Destructor TExCheckGroupBox.Destroy;
begin
    if (_ignoreList <> nil) then
        _ignoreList.Free();
    inherited;
end;

procedure TExCheckGroupBox.CreateWindowHandle(const Params: TCreateParams);
begin
    inherited;
    AutoSizeCheckBox();
end;

procedure TExCheckGroupBox.InitializeControls();
begin
    if (not _ControlsInitialized) then begin
        Self.ParentFont := True;
        Self.ParentColor := True;
        
        _pnlTop.Height := 18;
        _pnlTop.Align := alTop;
        _pnlTop.caption := '';
        _pnlTop.BevelOuter := bvNone;
        _pnlTop.ParentFont := true;
        _pnlTop.ParentColor := True;
        _pnlTop.TabStop := false;

        _chkBox.Align := alLeft;
        _chkBox.ParentFont := True;
        _chkBox.ParentColor := True;
        _chkBox.TabStop := True;
        _chkBox.TabOrder := 0;
        _chkBox.OnClick := Self.chkBoxClick;

        _pnlBevel.Align := alClient;
        _pnlBevel.BevelOuter := bvNone;
        _pnlBevel.ParentFont := True;
        _pnlBevel.ParentColor := True;
        _pnlBevel.TabStop := False;

        _bevel.Align := alNone;
        _bevel.Left := 3;
        _bevel.Width := _pnlBevel.Width - 3;
        _bevel.Top := 8;
        _bevel.Anchors := [akTop, akleft, akRight];

        _ControlsInitialized := true;
    end;
end;

function TExCheckGroupBox.GetCaption(): WideString;
begin
    Result := _chkBox.Caption;
end;

procedure TExCheckGroupBox.AutoSizeCheckBox();
var
    extra: WideString;
    s: TSize;
begin
    InitializeControls();
    Self.Canvas.Font := Self.Font;

    //if caption has accellerator defined, don't add additional & char...
    extra := '';
    if (WidePos('&', _chkBox.Caption) = 0) then
        extra := extra + 'W';
     s.cX := 0;
     s.cY := 0;
     Windows.GetTextExtentPoint32W(Canvas.Handle, PWideChar(_chkBox.Caption + extra), Length(_chkBox.Caption + extra), s);

     _chkBox.Width := s.cX + _chkBox.Height - 3;

end;

procedure TExCheckGroupBox.SetCaption(c: widestring);
begin
    _chkBox.Caption := c;    
    AutoSizeCheckBox();
end;

procedure TExCheckGroupBox.chkBoxClick(Sender: TObject);
begin
    inherited;
    //only update children if we have been "initialized". We
    //don't want to step on initial child states...
    if (not _initialized) then exit;

    //relay event
    if (Assigned(_checkChangeEvent)) then begin
        _checkChangeEvent(Sender);
    end;
    enableChildren(Checked, true, nil);
end;


procedure TExCheckGroupBox.SetEnabled(enabled: boolean);
begin
    _chkBox.Enabled := CanEnabled and enabled;
    _bevel.Enabled := CanEnabled and enabled;
    
    inherited;
end;

function TExCheckGroupBox.GetChecked(): boolean;
begin
    Result := _chkBox.Checked
end;

procedure TExCheckGroupBox.SetChecked(b: boolean);
begin
    _chkBox.Checked := b;
    if _initialized then enableChildren(b, true, nil);
end;

procedure TExCheckGroupBox.CheckAutoHide();
begin
    if (not _initialized) then
        captureChildStates();

    inherited;
end;

function TExCheckGroupBox.VisibleChildren(): integer;
var
    i: integer;
begin
    Result := 0;
    for i := 0 to Self.ControlCount -1 do begin
        if (Self.Controls[i].Visible and (Self.Controls[i].Name <> 'pnlTop')) then
            inc(Result);
    end;
end;

procedure TExCheckGroupBox.CaptureChildStates();
begin
    inherited;
    _initialized := true;
end;

procedure TExCheckGroupBox.EnableChildren(e: boolean; useInitial: boolean; ignore: TList);
var
    tIgnore: TList;
begin
    //add check box to ignore list and call inherited handler
    if (ignore = nil) then
      tIgnore := TList.Create()
    else
      tIgnore := ignore;

    tIgnore.Add(_pnlTop);
    //only enable children if we are checked.
    inherited enableChildren(e and Checked, UseInitial, tIgnore);

    if (ignore = nil) then
      tIgnore.Free();
end;

end.
