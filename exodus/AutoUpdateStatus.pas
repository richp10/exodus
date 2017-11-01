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
unit AutoUpdateStatus;

interface

uses
    XMLTag,
    Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
    Dialogs, ComCtrls, StdCtrls, buttonFrame, ExtCtrls, IdBaseComponent,
    IdComponent, IdTCPConnection, IdTCPClient, IdHTTP, TntStdCtrls, ExForm;

type
  TfrmAutoUpdateStatus = class(TExForm)
    Label1: TTntLabel;
    ProgressBar1: TProgressBar;
    Image1: TImage;
    HttpClient: TIdHTTP;
    TntLabel1: TTntLabel;
    Panel1: TPanel;
    Bevel1: TBevel;
    Panel2: TPanel;
    btnOK: TTntButton;
    btnSkip: TTntButton;
    btnCancel: TTntButton;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure frameButtons1btnCancelClick(Sender: TObject);
    procedure HttpClientWork(Sender: TObject; AWorkMode: TWorkMode;
      const AWorkCount: Integer);
    procedure HttpClientWorkBegin(Sender: TObject; AWorkMode: TWorkMode;
      const AWorkCountMax: Integer);
    procedure frameButtons1btnOKClick(Sender: TObject);
    procedure TntLabel1Click(Sender: TObject);
    procedure btnSkipClick(Sender: TObject);

  private
    { Private declarations }
    _url: string;
    _downloading : boolean;
    _fstream: TFileStream;
    _cancel: boolean;
    procedure getFile();
  public
    { Public declarations }
    property URL : string read _url write _url;
  end;

procedure ShowAutoUpdateStatus(URL : string); overload;

var
  frmAutoUpdateStatus: TfrmAutoUpdateStatus;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
implementation
uses
    JabberUtils, ExUtils,  GnuGetText, IdException, IQ, Registry, Session, ShellAPI;

const
    sDownloading      = 'Downloading...';
    sDownloadComplete = 'Download Complete';
    sInitializing     = 'Initializing...';
    sInstalling       = 'Installing...';
    sError            = 'Error: %s';

{$R *.dfm}

{---------------------------------------}
procedure ShowAutoUpdateStatus(URL : string);
begin
     if (frmAutoUpdateStatus = nil) then
        frmAutoUpdateStatus := TfrmAutoUpdateStatus.Create(Application);
    frmAutoUpdateStatus.URL := URL;
    frmAutoUpdateStatus.Show();
end;

{---------------------------------------}
procedure TfrmAutoUpdateStatus.FormCreate(Sender: TObject);
begin
    AssignUnicodeFont(Self, 8);
    TranslateComponent(Self);
    Image1.Picture.Icon.Handle := LoadIcon(0, IDI_QUESTION);
    _downloading := false;
    _url := '';
    _cancel := false;
    MainSession.Prefs.setProxy(HttpClient);
end;

{---------------------------------------}
procedure TfrmAutoUpdateStatus.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
    Action := caFree;
    frmAutoUpdateStatus := nil;
end;

{---------------------------------------}
procedure TfrmAutoUpdateStatus.frameButtons1btnCancelClick(
  Sender: TObject);
begin
    if (_downloading) then begin
        _cancel := true;
        HttpClient.DisconnectSocket();
    end
    else
        Self.Close();
end;

{---------------------------------------}
procedure TfrmAutoUpdateStatus.HttpClientWork(Sender: TObject;
  AWorkMode: TWorkMode; const AWorkCount: Integer);
begin
    ProgressBar1.Position := AWorkCount;
    Application.ProcessMessages();
end;

{---------------------------------------}
procedure TfrmAutoUpdateStatus.HttpClientWorkBegin(Sender: TObject;
  AWorkMode: TWorkMode; const AWorkCountMax: Integer);
begin
    ProgressBar1.Max := AWorkCountMax;
    label1.Caption := _(sDownloading);
    label1.Refresh();
    Application.ProcessMessages();
end;

{---------------------------------------}
procedure TfrmAutoUpdateStatus.frameButtons1btnOKClick(Sender: TObject);
begin
    Self.getFile();
end;

{---------------------------------------}
procedure TfrmAutoUpdateStatus.getFile();
var
    tmp : string;
begin
    SetLength(tmp, 256);
    SetLength(tmp, GetTempPath(255, PChar(tmp)));

    tmp := tmp + ExtractFileName(URLToFilename(_url));

    ProgressBar1.Visible := true;
    btnOK.Enabled := false;
    label1.Caption := _(sInitializing);
    label1.Refresh();
    Image1.Picture.Icon.Handle := LoadIcon(0, IDI_INFORMATION);
    Image1.Refresh();
    _downloading := true;
    Application.ProcessMessages();

    _fstream := nil;
    try
        try
            _fstream := TFileStream.Create(tmp, fmCreate);
            httpClient.Get(_url, _fstream);
            _fstream.Free();
            _fstream := nil;

            if ((_cancel = false) and (httpClient.ResponseCode = 200)) then begin
                label1.Caption := _(sDownloadComplete);
                label1.Refresh();
                Application.ProcessMessages();

                // modification date/time on the file??
                // pgm 11/15/03 - This is _VERY_ hacky... use last modified time
                // plus 2 hours. This should solve weird problems where folks
                // always see auto-update notices.
                MainSession.Prefs.setDateTime('last_update',
                    (httpClient.Response.LastModified + (2.0/24.0)));

                label1.Caption := _(sInstalling);
                label1.Refresh();
                Application.ProcessMessages();

                ShellExecute(Application.Handle, 'open', PChar(tmp), '/S', nil,
                    SW_SHOWNORMAL);
            end
            else if (_cancel = false) then begin
                label1.Caption := WideFormat(_(sError), [httpClient.ResponseText]);
                Application.ProcessMessages();
            end;
        except
            on EIdConnClosedGracefully do
                Self.Close();
            on E: EIdProtocolReplyError do begin
                label1.Caption := WideFormat(_(sError), [E.Message]);
            end;
        end;
    finally
        if (_fstream <> nil) then _fstream.Free();
        _downloading := false;
    end;

    if (_cancel) then Self.Close();

end;

procedure TfrmAutoUpdateStatus.TntLabel1Click(Sender: TObject);
var
    url: String; // *not* widestring.
begin
    url := MainSession.Prefs.getString('auto_update_changelog_url');
    ShellExecute(Application.Handle, 'open', PChar(url), nil, nil, SW_SHOWNORMAL);
end;

procedure TfrmAutoUpdateStatus.btnSkipClick(Sender: TObject);
begin
    // update the last update date/time in the prefs to Now()
    MainSession.Prefs.setDateTime('last_update', Now());
    Self.Close;
end;

end.
