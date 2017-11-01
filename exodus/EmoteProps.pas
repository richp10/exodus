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
unit EmoteProps;


interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, TntStdCtrls, ExtDlgs, ExForm;

type
  TfrmEmoteProps = class(TExForm)
    TntLabel1: TTntLabel;
    txtFilename: TTntEdit;
    btnBrowse: TTntButton;
    TntLabel2: TTntLabel;
    txtText: TTntEdit;
    btnOK: TTntButton;
    btnCancel: TTntButton;
    OpenDialog1: TOpenPictureDialog;
    procedure btnBrowseClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmEmoteProps: TfrmEmoteProps;

implementation

{$R *.dfm}

uses
    Session, PrefController;

procedure TfrmEmoteProps.btnBrowseClick(Sender: TObject);
begin
    // Browse for the image filename
    if (OpenDialog1.Execute) then
        txtFilename.Text := OpenDialog1.Filename;
end;

procedure TfrmEmoteProps.FormCreate(Sender: TObject);
begin
    MainSession.Prefs.RestorePosition(Self);
end;

procedure TfrmEmoteProps.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
    MainSession.Prefs.SavePosition(Self);
end;

end.
