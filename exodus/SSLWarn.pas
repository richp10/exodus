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
unit SSLWarn;


interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, TntStdCtrls, ExtCtrls, buttonFrame, ExForm, TntForms,
  ExFrame;

type
  TfrmSSLWarn = class(TExForm)
    Image1: TImage;
    lblHeader: TTntLabel;
    txtMsg: TTntMemo;
    frameButtons1: TframeButtons;
    optDisconnect: TTntRadioButton;
    optAllowSession: TTntRadioButton;
    optAllowAlways: TTntRadioButton;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmSSLWarn: TfrmSSLWarn;

const
    sslReject = 0;
    sslAllowSession = 1;
    sslAllowAlways = 2;

function ShowSSLWarn(msg, fp: widestring): integer;

implementation

{$R *.dfm}

uses
    GnuGetText;

function ShowSSLWarn(msg, fp: widestring): integer;
var
    f: TfrmSSLWarn;
begin
    f := TfrmSSLWarn.Create(Application);
    f.txtMsg.Lines.Append(_('The SSL certificate received from the server has errors.'));
    f.txtMsg.Lines.Append(msg);
    f.txtMsg.Lines.Append(_('Certificate fingerprint: ') + fp);
    f.ShowModal();
    if (f.optDisconnect.Checked) then
        Result := sslReject
    else if (f.optAllowSession.Checked) then
        Result := sslAllowSession
    else
        Result := sslAllowAlways;
    f.Close();
end;

procedure TfrmSSLWarn.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    Action := caFree;
end;

end.
