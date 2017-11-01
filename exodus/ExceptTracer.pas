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
unit ExceptTracer;


interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, buttonFrame;

type
  TfrmTracer = class(TForm)
    frameButtons1: TframeButtons;
    Panel1: TPanel;
    Memo1: TMemo;
    procedure frameButtons1btnOKClick(Sender: TObject);
    procedure frameButtons1btnCancelClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmTracer: TfrmTracer;

implementation

{$R *.dfm}

procedure TfrmTracer.frameButtons1btnOKClick(Sender: TObject);
begin
    Self.Close();
end;

procedure TfrmTracer.frameButtons1btnCancelClick(Sender: TObject);
begin
    Self.Close();
end;

procedure TfrmTracer.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    Action := caFree;
end;

end.
