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
unit ToolbarColorSelect;


interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  BaseChat,
  Dialogs, StdCtrls, ExtCtrls, TntStdCtrls, Buttons, TntExtCtrls, ExForm;

type
  TfrmToolbarColorSelect = class(TExForm)
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    Panel5: TPanel;
    Panel6: TPanel;
    Panel7: TPanel;
    Panel8: TPanel;
    Panel9: TPanel;
    Panel10: TPanel;
    Panel11: TPanel;
    Panel12: TPanel;
    Panel13: TPanel;
    Panel14: TPanel;
    Panel15: TPanel;
    Panel16: TPanel;
    pnlDefault: TTntPanel;

    procedure FormCreate(Sender: TObject);
    procedure FormDeactivate(Sender: TObject);
    procedure Panel1Click(Sender: TObject);
    procedure pnlDefaultClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    { Private declarations }
    _toolbar: TfrmBaseChat;
  public
    SelColor: TColor;
  end;

function getToolbarColorSelect(): TForm; overload;
function getToolbarColorSelect(toolbar: TfrmBaseChat; dColor: TColor): TForm; overload;

implementation
uses
    gnugettext;
var
  frmToolbarColorSelect: TfrmToolbarColorSelect;

function getToolbarColorSelect(): TForm;
begin
    if (frmToolbarColorSelect = nil) then begin
        frmToolbarColorSelect := TfrmToolbarColorSelect.Create(Application);
    end;

    Result := frmToolbarColorSelect;
end;
function getToolbarColorSelect(toolbar: TfrmBaseChat; dColor: TColor): TForm;
begin
    getToolbarColorSelect();
    frmToolbarColorSelect._toolbar := toolbar;
    frmToolbarColorSelect.pnlDefault.Font.Color := dColor;
    Result := frmToolbarColorSelect;
end;


{$R *.dfm}

procedure TfrmToolbarColorSelect.FormCreate(Sender: TObject);
begin
    //layout color pallet
    SelColor := panel1.Color;
    TranslateComponent(Self);
end;

procedure TfrmToolbarColorSelect.FormDeactivate(Sender: TObject);
begin
    if Self.Visible then
        Self.Hide();
end;

procedure TfrmToolbarColorSelect.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case key of
    VK_ESCAPE: Self.Hide
  end;
end;

procedure TfrmToolbarColorSelect.Panel1Click(Sender: TObject);
begin
    SelColor := TPanel(Sender).Color;
    _toolbar.OnColorSelect(SelColor);
    Self.Hide();
end;

procedure TfrmToolbarColorSelect.pnlDefaultClick(Sender: TObject);
begin
    SelColor := TPanel(Sender).Font.Color;
    _toolbar.OnColorSelect(SelColor);
    Self.Hide();
end;

end.
