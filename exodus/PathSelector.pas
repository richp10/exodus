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
unit PathSelector;


interface

{$WARN UNIT_PLATFORM OFF}

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, buttonFrame, ComCtrls, ShellCtrls, TntStdCtrls;

type
  TfrmPathSelector = class(TForm)
    frameButtons1: TframeButtons;
    Label1: TTntLabel;
    Folders: TShellTreeView;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmPathSelector: TfrmPathSelector;

function browsePath(var SelectedPath: string): boolean;

implementation
{$R *.dfm}
uses
    GnuGetText;

function browsePath(var SelectedPath: string): boolean;
var
    f: TfrmPathSelector;
begin
    //
    Result := false;
    f := TfrmPathSelector.Create(nil);
    if (SelectedPath <> '') then
        f.Folders.Path := SelectedPath;

    if (f.ShowModal = mrOK) then begin
        SelectedPath := f.Folders.Path;
        Result := true;
    end;
    f.Free();
end;


procedure TfrmPathSelector.FormCreate(Sender: TObject);
begin
    TranslateComponent(Self);
end;

end.
