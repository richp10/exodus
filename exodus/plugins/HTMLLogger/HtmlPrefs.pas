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
unit HtmlPrefs;


interface

uses
    LoggerPlugin, 
    Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
    Dialogs, StdCtrls, TntStdCtrls;

type
  TfrmHtmlPrefs = class(TForm)
    txtLogPath: TTntEdit;
    btnLogBrowse: TTntButton;
    chkLogRooms: TTntCheckBox;
    btnLogClearAll: TTntButton;
    chkLogRoster: TTntCheckBox;
    TntLabel1: TTntLabel;
    TntButton1: TTntButton;
    TntButton2: TTntButton;
    procedure btnLogClearAllClick(Sender: TObject);
    procedure btnLogBrowseClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    Logger: THTMLLogger;
  end;

var
  frmHtmlPrefs: TfrmHtmlPrefs;

implementation
{$WARN UNIT_PLATFORM OFF}
{$R *.dfm}

uses
    FileCtrl;

const
    sPrefsLogDir = 'Select log directory';

procedure TfrmHtmlPrefs.btnLogClearAllClick(Sender: TObject);
begin
    Logger.purgeLogs();
end;

procedure TfrmHtmlPrefs.btnLogBrowseClick(Sender: TObject);
var
    tmps: string;
begin
    tmps := txtLogPath.Text;
    if SelectDirectory(sPrefsLogDir, '', tmps) then
        txtLogPath.Text := tmps;
end;

end.
