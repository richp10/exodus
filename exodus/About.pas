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
unit About;


interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, jpeg, ExtCtrls, StdCtrls, buttonFrame, ComCtrls, ExRichEdit,
  RichEdit2, ExForm, TntForms, ExFrame;

type
  TfrmAbout = class(TExForm)
    Panel1: TPanel;
    Image1: TImage;
    frameButtons1: TframeButtons;
    pnlVersion: TPanel;
    InfoBox: TExRichEdit;
    procedure frameButtons1btnCancelClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure InfoBoxURLClick(Sender: TObject; url: String);
    procedure pnlVersionMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmAbout: TfrmAbout;

implementation

{$R *.dfm}

uses
    PrefController,
    JabberUtils, ExUtils,  GnuGetText, ShellAPI, XMLUtils, Session, Unicode;

const
    sAbout1 = 'Exodus is the creation of Peter Millard.  Checkout the website at http://exodus.googlecode.com for more information. It is currently licensed under the GNU Public License (GPL) see www.gnu.org for more information on the GPL.';
    sAbout2 = 'TCP/IP components are Copyright (c) 1993 - 2002, Chad Z. Hower (Kudzu) and the Indy Pit Crew - http://www.indyproject.org/index.html.';
    sAbout2a = ' This application may also be using the IndySSL components from Nevrona, and the Open-SSL binaries available from Intellicom.si.';
    sAbout3 = 'SAX XML Parser by: Stefan Heymann Eschenweg 3, 72076 Tubingen, GERMANY mailto:stefan@destructor.de, http://www.destructor.de';
    sAbout4 = 'Unicode library is Copyright (c) 1999, 2000 Mike Lischke (public@lischke-online.de) and Portions Copyright (c) 1999, 2000 Azret Botash (az).';
    sAbout5 = 'RichEdit98 and DBRichEdit98 components for Delphi 3.0-4.0. version 1.40 Author Alexander Obukhov, Minsk, Belarus <alex@niiomr.belpak.minsk.by>';
    sAbout6 = 'NGImage (PNG/MNG) is Copyright (c) 2001,2002 Gerard Juyn, Scott Price';

procedure TfrmAbout.frameButtons1btnCancelClick(Sender: TObject);
begin
    Self.Close;
end;

procedure TfrmAbout.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    MainSession.Prefs.SavePosition(Self);
    Action := caFree;
end;

procedure TfrmAbout.FormCreate(Sender: TObject);
var
    additional  : TWideStringList;
    i           : Integer;
begin
    AssignUnicodeFont(Self);
    TranslateComponent(Self);
    Caption := _('About ') + GetAppInfo().Caption;
    pnlVersion.Caption := _('Version: ') + GetAppVersion();

    InfoBox.WideLines.Clear();
    InfoBox.WideLines.Add(_(sAbout1));
    InfoBox.WideLines.Add('');
    InfoBox.WideLines.Add(_(sAbout2));
    InfoBox.WideLines.Add(_(sAbout2a));
    InfoBox.WideLines.Add('');
    InfoBox.WideLines.Add(_(sAbout3));
    InfoBox.WideLines.Add('');
    InfoBox.WideLines.Add(_(sAbout4));
    InfoBox.WideLines.Add('');
    InfoBox.WideLines.Add(_(sAbout5));
    InfoBox.WideLines.Add('');
    InfoBox.WideLines.Add(_(sAbout6));
    InfoBox.WideLines.Add('');

    additional := TWideStringList.Create();

    MainSession.Prefs.fillStringlist('brand_about_additional_list', additional);
    for i := 0 to additional.Count - 1 do begin
        InfoBox.WideLines.Add(additional.Strings[i]);
    end;

    if (additional.Count > 0) then
        InfoBox.WideLines.Add('');

    additional.Clear();

    MainSession.Prefs.fillStringlist('about_additional_list', additional);
    for i := 0 to additional.Count - 1 do begin
        InfoBox.WideLines.Add(additional.Strings[i]);
    end;

    additional.Free();

    InfoBox.WideLines.Add('');
    MainSession.Prefs.RestorePosition(Self);

    MainSession.Prefs.getImage('appimage', image1);
end;

procedure TfrmAbout.InfoBoxURLClick(Sender: TObject; url: String);
begin
    ShellExecute(Application.Handle, 'open', PChar(url), nil, nil, SW_SHOWNORMAL);
end;

procedure TfrmAbout.pnlVersionMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
    i: integer;
    str: string;
begin
    if (not (ssCtrl in Shift)) then exit;

    str := Application.ExeName;
    for i := 1 to ParamCount do
        str := str + ' ' + ParamStr(i);
    MessageDlgW(str, mtInformation, [mbOK], 0);
end;

end.
