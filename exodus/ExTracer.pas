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
unit ExTracer;


interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, buttonFrame, StdCtrls, ExForm, TntForms, ExFrame;

{$ifdef TRACE_EXCEPTIONS}
type
  TfrmException = class(TExForm)
    mmLog: TMemo;
    frameButtons1: TframeButtons;
    procedure frameButtons1btnCancelClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  TCatchersMit = class
  public
    procedure gotException(Sender: TObject; e: Exception);
    procedure gotExceptionNoDlg(Sender: TObject; e: Exception);
  end;

var
  frmException: TfrmException;
  CatchersMit: TCatchersMit;

procedure ExodusException(ExceptObj: TObject; ExceptAddr: Pointer; OSException: Boolean);
{$endif}

implementation

{$R *.dfm}

uses
    {$ifdef TRACE_EXCEPTIONS}
    IdException, JclDebug, JclHookExcept, TypInfo,
    {$endif}
    ExResponders, Unicode;

procedure TCatchersMit.gotException(Sender: TObject; e: Exception);
var
    l: TWidestringlist;
begin
    l := TWidestringlist.Create();
    l.Add('Exception: ' + e.Message);
    ExHandleException(l, true);
end;

procedure TCatchersMit.gotExceptionNoDlg(Sender: TObject; e: Exception);
var
    l: TWidestringlist;
begin
    l := TWidestringlist.Create();
    l.Add('Exception: ' + e.Message);
    ExHandleException(l, false);
end;

procedure ExodusException(ExceptObj: TObject; ExceptAddr: Pointer; OSException: Boolean);
var
    e: Exception;
    l: TWidestringlist;
begin

    // ignore some exceptions
    e := Exception(ExceptObj);
    if (e is EConvertError) then exit;
    if (e is EIdSocketError) then exit;
    if (e is EIdClosedSocket) then exit;
    if (e is EIdDNSResolverError) then exit;
    if (e is EIdConnClosedGracefully) then exit;
    if (e.inheritsFrom(EIdException)) then exit;

    // Just use the existing error log stuff.
    l := TWidestringlist.Create();
    l.Add('Exception: ' + e.Message);
    ExHandleException(l, true);
end;

procedure TfrmException.frameButtons1btnCancelClick(Sender: TObject);
begin
    Self.Close();
end;

procedure TfrmException.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
    Action := caHide;
end;

initialization

    {$ifdef TRACE_EXCEPTIONS}
    frmException := nil;
    JclStackTrackingOptions := JclStackTrackingOptions + [stRawMode];
    JclStackTrackingOptions := JclStackTrackingOptions + [stExceptFrame];
    JclStackTrackingOptions := JclStackTrackingOptions + [stStaticModuleList];
    JclStartExceptionTracking;
    // Just use Application.onException since these notifiers
    // always fire, even if the exception is about to be caught.
    // JclAddExceptNotifier(ExodusException);
    {$endif}

    CatchersMit := TCatchersMit.Create();
    Application.OnException := CatchersMit.gotException;

finalization
    Application.onException := nil;
    CatchersMit.Free();

end.
