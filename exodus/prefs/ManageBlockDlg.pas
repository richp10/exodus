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
unit ManageBlockDlg;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,
  Unicode,
  TnTClasses,
  ExForm, StdCtrls, TntStdCtrls, TntForms, ExFrame, ExBrandPanel, ExtCtrls;

type
  TManageBlockDlg = class(TExForm)
    ExBrandPanel1: TExBrandPanel;
    lblBlockIns: TTntLabel;
    memBlocks: TTntMemo;
    btnOK: TTntButton;
    btnCancel: TTntButton;
    procedure TntFormCreate(Sender: TObject);
  private
  public
    procedure setBlockers(blockers: TWideStringList);
    procedure getBlockers(blockers: TWideStringList);
  end;

implementation

{$R *.dfm}
uses
    PrefController,
    ExUtils;

procedure TManageBlockDlg.TntFormCreate(Sender: TObject);
begin
    inherited;
    AssignUnicodeFont(memBlocks.Font, 10);
end;

procedure TManageBlockDlg.setBlockers(blockers: TWideStringList);
begin
    memBlocks.Lines.BeginUpdate();
    memBlocks.lines.clear();
    AssignTntStrings(blockers,memBlocks.lines);
    memBlocks.lines.EndUpdate();
end;

procedure TManageBlockDlg.getBlockers(blockers: TWideStringList);
var
    i: integer;
begin
    blockers.Clear();
    for i := 0 to memBlocks.lines.Count - 1 do
        blockers.Add(memBlocks.lines[i]);
end;

end.
