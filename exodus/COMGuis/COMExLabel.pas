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
unit COMExLabel;



{-----------------------------------------------------------------------------}
{-----------------------------------------------------------------------------}
{ This is autogenerated code using the COMGuiGenerator. DO NOT MODIFY BY HAND }
{-----------------------------------------------------------------------------}
{-----------------------------------------------------------------------------}


{$WARN SYMBOL_PLATFORM OFF}

interface
uses
    ActiveX,Classes,COMExFont,COMExPopupMenu,ComObj,Controls,Exodus_TLB,Forms,Graphics,StdCtrls,StdVcl,TntMenus,TntStdCtrls;

type
    TExControlLabel = class(TAutoObject, IExodusControl, IExodusControlLabel)
    public
        constructor Create(control: TTntLabel);

    private
        _control: TTntLabel;

    protected
        function Get_ControlType: ExodusControlTypes; safecall;
        function Get_Name: Widestring; safecall;
        procedure Set_Name(const Value: Widestring); safecall;
        function Get_Tag: Integer; safecall;
        procedure Set_Tag(Value: Integer); safecall;
        function Get_Left: Integer; safecall;
        procedure Set_Left(Value: Integer); safecall;
        function Get_Top: Integer; safecall;
        procedure Set_Top(Value: Integer); safecall;
        function Get_Width: Integer; safecall;
        procedure Set_Width(Value: Integer); safecall;
        function Get_Height: Integer; safecall;
        procedure Set_Height(Value: Integer); safecall;
        function Get_Cursor: Integer; safecall;
        procedure Set_Cursor(Value: Integer); safecall;
        function Get_Hint: Widestring; safecall;
        procedure Set_Hint(const Value: Widestring); safecall;
        function Get_HelpType: Integer; safecall;
        procedure Set_HelpType(Value: Integer); safecall;
        function Get_HelpKeyword: Widestring; safecall;
        procedure Set_HelpKeyword(const Value: Widestring); safecall;
        function Get_HelpContext: Integer; safecall;
        procedure Set_HelpContext(Value: Integer); safecall;
        function Get_Align: Integer; safecall;
        procedure Set_Align(Value: Integer); safecall;
        function Get_Alignment: Integer; safecall;
        procedure Set_Alignment(Value: Integer); safecall;
        function Get_AutoSize: Integer; safecall;
        procedure Set_AutoSize(Value: Integer); safecall;
        function Get_BiDiMode: Integer; safecall;
        procedure Set_BiDiMode(Value: Integer); safecall;
        function Get_Caption: Widestring; safecall;
        procedure Set_Caption(const Value: Widestring); safecall;
        function Get_Color: Integer; safecall;
        procedure Set_Color(Value: Integer); safecall;
        function Get_DragCursor: Integer; safecall;
        procedure Set_DragCursor(Value: Integer); safecall;
        function Get_DragKind: Integer; safecall;
        procedure Set_DragKind(Value: Integer); safecall;
        function Get_DragMode: Integer; safecall;
        procedure Set_DragMode(Value: Integer); safecall;
        function Get_Enabled: Integer; safecall;
        procedure Set_Enabled(Value: Integer); safecall;
        function Get_Font: IExodusControlFont; safecall;
        function Get_ParentBiDiMode: Integer; safecall;
        procedure Set_ParentBiDiMode(Value: Integer); safecall;
        function Get_ParentColor: Integer; safecall;
        procedure Set_ParentColor(Value: Integer); safecall;
        function Get_ParentFont: Integer; safecall;
        procedure Set_ParentFont(Value: Integer); safecall;
        function Get_ParentShowHint: Integer; safecall;
        procedure Set_ParentShowHint(Value: Integer); safecall;
        function Get_PopupMenu: IExodusControlPopupMenu; safecall;
        function Get_ShowAccelChar: Integer; safecall;
        procedure Set_ShowAccelChar(Value: Integer); safecall;
        function Get_ShowHint: Integer; safecall;
        procedure Set_ShowHint(Value: Integer); safecall;
        function Get_Transparent: Integer; safecall;
        procedure Set_Transparent(Value: Integer); safecall;
        function Get_Layout: Integer; safecall;
        procedure Set_Layout(Value: Integer); safecall;
        function Get_Visible: Integer; safecall;
        procedure Set_Visible(Value: Integer); safecall;
        function Get_WordWrap: Integer; safecall;
        procedure Set_WordWrap(Value: Integer); safecall;
    end;


{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
implementation


constructor TExControlLabel.Create(control: TTntLabel);
begin
     _control := control; 
end;

function TExControlLabel.Get_ControlType: ExodusControlTypes;
begin
    Result := ExodusControlLabel;
end;

function TExControlLabel.Get_Name: Widestring;
begin
      Result := _control.Name;
end;

procedure TExControlLabel.Set_Name(const Value: Widestring);
begin
      _control.Name := Value;
end;

function TExControlLabel.Get_Tag: Integer;
begin
      Result := _control.Tag;
end;

procedure TExControlLabel.Set_Tag(Value: Integer);
begin
      _control.Tag := Value;
end;

function TExControlLabel.Get_Left: Integer;
begin
      Result := _control.Left;
end;

procedure TExControlLabel.Set_Left(Value: Integer);
begin
      _control.Left := Value;
end;

function TExControlLabel.Get_Top: Integer;
begin
      Result := _control.Top;
end;

procedure TExControlLabel.Set_Top(Value: Integer);
begin
      _control.Top := Value;
end;

function TExControlLabel.Get_Width: Integer;
begin
      Result := _control.Width;
end;

procedure TExControlLabel.Set_Width(Value: Integer);
begin
      _control.Width := Value;
end;

function TExControlLabel.Get_Height: Integer;
begin
      Result := _control.Height;
end;

procedure TExControlLabel.Set_Height(Value: Integer);
begin
      _control.Height := Value;
end;

function TExControlLabel.Get_Cursor: Integer;
begin
      Result := _control.Cursor;
end;

procedure TExControlLabel.Set_Cursor(Value: Integer);
begin
      _control.Cursor := Value;
end;

function TExControlLabel.Get_Hint: Widestring;
begin
      Result := _control.Hint;
end;

procedure TExControlLabel.Set_Hint(const Value: Widestring);
begin
      _control.Hint := Value;
end;

function TExControlLabel.Get_HelpType: Integer;
begin
    if (_control.HelpType = htKeyword) then Result := 0;
    if (_control.HelpType = htContext) then Result := 1;
end;

procedure TExControlLabel.Set_HelpType(Value: Integer);
begin
   if (Value = 0) then _control.HelpType := htKeyword;
   if (Value = 1) then _control.HelpType := htContext;
end;

function TExControlLabel.Get_HelpKeyword: Widestring;
begin
      Result := _control.HelpKeyword;
end;

procedure TExControlLabel.Set_HelpKeyword(const Value: Widestring);
begin
      _control.HelpKeyword := Value;
end;

function TExControlLabel.Get_HelpContext: Integer;
begin
      Result := _control.HelpContext;
end;

procedure TExControlLabel.Set_HelpContext(Value: Integer);
begin
      _control.HelpContext := Value;
end;

function TExControlLabel.Get_Align: Integer;
begin
    if (_control.Align = alNone) then Result := 0;
    if (_control.Align = alTop) then Result := 1;
    if (_control.Align = alBottom) then Result := 2;
    if (_control.Align = alLeft) then Result := 3;
    if (_control.Align = alRight) then Result := 4;
    if (_control.Align = alClient) then Result := 5;
    if (_control.Align = alCustom) then Result := 6;
end;

procedure TExControlLabel.Set_Align(Value: Integer);
begin
   if (Value = 0) then _control.Align := alNone;
   if (Value = 1) then _control.Align := alTop;
   if (Value = 2) then _control.Align := alBottom;
   if (Value = 3) then _control.Align := alLeft;
   if (Value = 4) then _control.Align := alRight;
   if (Value = 5) then _control.Align := alClient;
   if (Value = 6) then _control.Align := alCustom;
end;

function TExControlLabel.Get_Alignment: Integer;
begin
    if (_control.Alignment = taLeftJustify) then Result := 0;
    if (_control.Alignment = taRightJustify) then Result := 1;
    if (_control.Alignment = taCenter) then Result := 2;
end;

procedure TExControlLabel.Set_Alignment(Value: Integer);
begin
   if (Value = 0) then _control.Alignment := taLeftJustify;
   if (Value = 1) then _control.Alignment := taRightJustify;
   if (Value = 2) then _control.Alignment := taCenter;
end;

function TExControlLabel.Get_AutoSize: Integer;
begin
    if (_control.AutoSize = False) then Result := 0;
    if (_control.AutoSize = True) then Result := 1;
end;

procedure TExControlLabel.Set_AutoSize(Value: Integer);
begin
   if (Value = 0) then _control.AutoSize := False;
   if (Value = 1) then _control.AutoSize := True;
end;

function TExControlLabel.Get_BiDiMode: Integer;
begin
    if (_control.BiDiMode = bdLeftToRight) then Result := 0;
    if (_control.BiDiMode = bdRightToLeft) then Result := 1;
    if (_control.BiDiMode = bdRightToLeftNoAlign) then Result := 2;
    if (_control.BiDiMode = bdRightToLeftReadingOnly) then Result := 3;
end;

procedure TExControlLabel.Set_BiDiMode(Value: Integer);
begin
   if (Value = 0) then _control.BiDiMode := bdLeftToRight;
   if (Value = 1) then _control.BiDiMode := bdRightToLeft;
   if (Value = 2) then _control.BiDiMode := bdRightToLeftNoAlign;
   if (Value = 3) then _control.BiDiMode := bdRightToLeftReadingOnly;
end;

function TExControlLabel.Get_Caption: Widestring;
begin
      Result := _control.Caption;
end;

procedure TExControlLabel.Set_Caption(const Value: Widestring);
begin
      _control.Caption := Value;
end;

function TExControlLabel.Get_Color: Integer;
begin
      Result := _control.Color;
end;

procedure TExControlLabel.Set_Color(Value: Integer);
begin
      _control.Color := Value;
end;

function TExControlLabel.Get_DragCursor: Integer;
begin
      Result := _control.DragCursor;
end;

procedure TExControlLabel.Set_DragCursor(Value: Integer);
begin
      _control.DragCursor := Value;
end;

function TExControlLabel.Get_DragKind: Integer;
begin
    if (_control.DragKind = dkDrag) then Result := 0;
    if (_control.DragKind = dkDock) then Result := 1;
end;

procedure TExControlLabel.Set_DragKind(Value: Integer);
begin
   if (Value = 0) then _control.DragKind := dkDrag;
   if (Value = 1) then _control.DragKind := dkDock;
end;

function TExControlLabel.Get_DragMode: Integer;
begin
    if (_control.DragMode = dmManual) then Result := 0;
    if (_control.DragMode = dmAutomatic) then Result := 1;
end;

procedure TExControlLabel.Set_DragMode(Value: Integer);
begin
   if (Value = 0) then _control.DragMode := dmManual;
   if (Value = 1) then _control.DragMode := dmAutomatic;
end;

function TExControlLabel.Get_Enabled: Integer;
begin
    if (_control.Enabled = False) then Result := 0;
    if (_control.Enabled = True) then Result := 1;
end;

procedure TExControlLabel.Set_Enabled(Value: Integer);
begin
   if (Value = 0) then _control.Enabled := False;
   if (Value = 1) then _control.Enabled := True;
end;

function TExControlLabel.Get_Font: IExodusControlFont;
begin
      Result := TExControlFont.Create(TFont(_control.Font));
end;

function TExControlLabel.Get_ParentBiDiMode: Integer;
begin
    if (_control.ParentBiDiMode = False) then Result := 0;
    if (_control.ParentBiDiMode = True) then Result := 1;
end;

procedure TExControlLabel.Set_ParentBiDiMode(Value: Integer);
begin
   if (Value = 0) then _control.ParentBiDiMode := False;
   if (Value = 1) then _control.ParentBiDiMode := True;
end;

function TExControlLabel.Get_ParentColor: Integer;
begin
    if (_control.ParentColor = False) then Result := 0;
    if (_control.ParentColor = True) then Result := 1;
end;

procedure TExControlLabel.Set_ParentColor(Value: Integer);
begin
   if (Value = 0) then _control.ParentColor := False;
   if (Value = 1) then _control.ParentColor := True;
end;

function TExControlLabel.Get_ParentFont: Integer;
begin
    if (_control.ParentFont = False) then Result := 0;
    if (_control.ParentFont = True) then Result := 1;
end;

procedure TExControlLabel.Set_ParentFont(Value: Integer);
begin
   if (Value = 0) then _control.ParentFont := False;
   if (Value = 1) then _control.ParentFont := True;
end;

function TExControlLabel.Get_ParentShowHint: Integer;
begin
    if (_control.ParentShowHint = False) then Result := 0;
    if (_control.ParentShowHint = True) then Result := 1;
end;

procedure TExControlLabel.Set_ParentShowHint(Value: Integer);
begin
   if (Value = 0) then _control.ParentShowHint := False;
   if (Value = 1) then _control.ParentShowHint := True;
end;

function TExControlLabel.Get_PopupMenu: IExodusControlPopupMenu;
begin
      Result := TExControlPopupMenu.Create(TTntPopupMenu(_control.PopupMenu));
end;

function TExControlLabel.Get_ShowAccelChar: Integer;
begin
    if (_control.ShowAccelChar = False) then Result := 0;
    if (_control.ShowAccelChar = True) then Result := 1;
end;

procedure TExControlLabel.Set_ShowAccelChar(Value: Integer);
begin
   if (Value = 0) then _control.ShowAccelChar := False;
   if (Value = 1) then _control.ShowAccelChar := True;
end;

function TExControlLabel.Get_ShowHint: Integer;
begin
    if (_control.ShowHint = False) then Result := 0;
    if (_control.ShowHint = True) then Result := 1;
end;

procedure TExControlLabel.Set_ShowHint(Value: Integer);
begin
   if (Value = 0) then _control.ShowHint := False;
   if (Value = 1) then _control.ShowHint := True;
end;

function TExControlLabel.Get_Transparent: Integer;
begin
    if (_control.Transparent = False) then Result := 0;
    if (_control.Transparent = True) then Result := 1;
end;

procedure TExControlLabel.Set_Transparent(Value: Integer);
begin
   if (Value = 0) then _control.Transparent := False;
   if (Value = 1) then _control.Transparent := True;
end;

function TExControlLabel.Get_Layout: Integer;
begin
    if (_control.Layout = tlTop) then Result := 0;
    if (_control.Layout = tlCenter) then Result := 1;
    if (_control.Layout = tlBottom) then Result := 2;
end;

procedure TExControlLabel.Set_Layout(Value: Integer);
begin
   if (Value = 0) then _control.Layout := tlTop;
   if (Value = 1) then _control.Layout := tlCenter;
   if (Value = 2) then _control.Layout := tlBottom;
end;

function TExControlLabel.Get_Visible: Integer;
begin
    if (_control.Visible = False) then Result := 0;
    if (_control.Visible = True) then Result := 1;
end;

procedure TExControlLabel.Set_Visible(Value: Integer);
begin
   if (Value = 0) then _control.Visible := False;
   if (Value = 1) then _control.Visible := True;
end;

function TExControlLabel.Get_WordWrap: Integer;
begin
    if (_control.WordWrap = False) then Result := 0;
    if (_control.WordWrap = True) then Result := 1;
end;

procedure TExControlLabel.Set_WordWrap(Value: Integer);
begin
   if (Value = 0) then _control.WordWrap := False;
   if (Value = 1) then _control.WordWrap := True;
end;




end.
