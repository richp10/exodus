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
unit DockContainer;


interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Dockable, ExtCtrls, ComCtrls, ToolWin, OleCtrls, SHDocVw, gnugettext,
  TntExtCtrls;

type
  TfrmDockContainer = class(TfrmDockable)
    Panel1: TPanel;
    WebBrowser1: TWebBrowser;
    procedure FormCreate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure TntFormShow(Sender: TObject);
  private
    _id: widestring;

    procedure sendEvent(event: widestring);
  public
    procedure OnDocked();override;
    procedure OnFloat();override;


    property UID: Widestring read _id write _id;
  end;

implementation
uses
  XMLTag,
  Session;

{$R *.dfm}

procedure TfrmDockContainer.sendEvent(event: widestring);
var
  ttag: TXMLtag;
begin
  ttag := TXMLTag.Create('dockcontainer');
  ttag.setAttribute('title', Self.Caption);
  ttag.setAttribute('id', _id);
  Session.MainSession.FireEvent(event, ttag);
  ttag.Free();
end;

procedure TfrmDockContainer.TntFormShow(Sender: TObject);
begin
  inherited;
  sendEvent('/session/dockcontainer/onshow');
end;

procedure TfrmDockContainer.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  sendEvent('/session/dockcontainer/onclose');
  inherited;
end;

procedure TfrmDockContainer.OnDocked();
begin
  inherited;
  sendEvent('/session/dockcontainer/ondocked');
end;

procedure TfrmDockContainer.OnFloat();
begin
  inherited;
  Application.ProcessMessages();
  sendEvent('/session/dockcontainer/onfloat');
end;

procedure TfrmDockContainer.FormCreate(Sender: TObject);
begin
  TP_GlobalIgnoreClassProperty(TWebBrowser,'StatusText');
  inherited;
end;

initialization
end.
