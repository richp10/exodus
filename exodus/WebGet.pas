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
unit WebGet;


interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, buttonFrame, IdBaseComponent, IdComponent,
  IdTCPConnection, IdTCPClient, IdHTTP, StdCtrls, TntStdCtrls, ExForm, TntForms,
  ExFrame;

type
  TfrmWebDownload = class(TExForm)
    lblStatus: TTntLabel;
    IdHTTP1: TIdHTTP;
    frameButtons1: TframeButtons;
    ProgressBar1: TProgressBar;
    procedure IdHTTP1Status(ASender: TObject; const AStatus: TIdStatus;
      const AStatusText: string);
    procedure frameButtons1btnCancelClick(Sender: TObject);
    procedure IdHTTP1WorkBegin(Sender: TObject; AWorkMode: TWorkMode;
      const AWorkCountMax: Integer);
    procedure IdHTTP1Work(Sender: TObject; AWorkMode: TWorkMode;
      const AWorkCount: Integer);
    procedure IdHTTP1Connected(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;


// Download some URL and pass back the content as a string
// Use this to snag XML files & stuff.
function ExWebDownload(caption, url: string): String;

var
  frmWebDownload: TfrmWebDownload;

implementation
{$R *.dfm}
uses
    GnuGetText, JabberUtils, ExUtils,  IdException;

const
    sDownloading      = 'Downloading...';
    sDownloadComplete = 'Download Complete';
    sInitializing     = 'Initializing...';
    sError            = 'Error: %s';   
    sNetworkError     = 'Network connection is not availble.';


function ExWebDownload(caption, url: string): String;
var
    f: TfrmWebDownload;
begin
    Result := '';
    f := TfrmWebDownload.Create(nil);
    f.caption := caption;
    f.lblStatus.Caption := _(sInitializing);
    f.Show();
    f.lblStatus.Refresh();
    Application.ProcessMessages();

    try
        Result := f.IdHTTP1.Get(url);
        if (f.IdHTTP1.ResponseCode = 200) then begin
            f.lblStatus.Caption := _(sDownloadComplete);
            f.lblStatus.Refresh();
            Application.ProcessMessages();
        end
        else
            Result := '';
        f.Free();
    except
        on EIdConnClosedGracefully do
            f.Free();
        on E: EIdProtocolReplyError do begin
            f.Free();
            MessageDlgW(WideFormat(_(sError), [E.Message]), mtError, [mbOK], 0);
        end
        else begin
            f.Free();
            MessageDlgW(_(sNetworkError), mtError, [mbOK], 0);
        end;

    end;
end;

procedure TfrmWebDownload.frameButtons1btnCancelClick(Sender: TObject);
begin
    // cancel the operation
    IdHttp1.Disconnect();
end;

procedure TfrmWebDownload.IdHTTP1WorkBegin(Sender: TObject;
  AWorkMode: TWorkMode; const AWorkCountMax: Integer);
begin
    ProgressBar1.Max := AWorkCountMax;
    ProgressBar1.Position := 0;
end;

procedure TfrmWebDownload.IdHTTP1Work(Sender: TObject;
  AWorkMode: TWorkMode; const AWorkCount: Integer);
begin
    ProgressBar1.Position := AWorkCount;
end;

procedure TfrmWebDownload.IdHTTP1Connected(Sender: TObject);
begin
    lblStatus.Caption := _(sDownloading);
end;

procedure TfrmWebDownload.IdHTTP1Status(ASender: TObject;
  const AStatus: TIdStatus; const AStatusText: string);
begin
   lblStatus.Caption :=  _(sDownloading);
end;

end.
