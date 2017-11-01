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
unit PrefLayouts;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, PrefPanel, StdCtrls, jpeg, ExtCtrls, TntStdCtrls, TntExtCtrls;

type
  TfrmPrefLayouts = class(TfrmPrefPanel)
    lblPreview: TTntLabel;
    cboView: TTntComboBox;
    imgView1: TImage;
    lblViewHelp: TTntLabel;
    chkStacked: TTntCheckBox;
    imgView2: TImage;
    procedure cboViewChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure LoadPrefs(); override;
    procedure SavePrefs(); override;

  end;

var
  frmPrefLayouts: TfrmPrefLayouts;

const
    sViewSimple = 'The main window shows only the roster. Other windows are opened in separate windows and never docked';
    sViewShare = 'The main window always shows the roster. Other windows are docked using a tabbed interface to the main window.';
    sViewExpanded = 'The main window shows the roster. Other windows are docked using a tabbed interface to the main window.';


{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
implementation

{$R *.dfm}
uses
    GnuGetText, Session, PrefController; 

{---------------------------------------}
procedure TfrmPrefLayouts.LoadPrefs();
begin
    inherited;
    
    // Get Branded images
    MainSession.Prefs.getImage('undocked', imgView1, 'layouts');
    MainSession.Prefs.getImage('docked_roster', imgView2, 'layouts');
    // Left Align the images
    imgView1.Left := lblPreview.Left;
    imgView2.Left := lblPreview.Left;

    with MainSession.Prefs do begin
        // View management stuff
        if (getBool('expanded')) then
           cboView.ItemIndex := 1
        else
           cboView.ItemIndex := 0;


        cboViewChange(Self);
        chkStacked.Checked := getBool('stacked_tabs');
    end;
end;

{---------------------------------------}
procedure TfrmPrefLayouts.SavePrefs();
begin
    //
    with MainSession.Prefs do begin
        //
        if (cboView.ItemIndex = 0) then begin
            setBool('expanded', false);
        end
        else if (cboView.ItemIndex = 1) then begin
            setBool('expanded', true);
        end;

        setBool('stacked_tabs', chkStacked.Checked);
    end;
end;

{---------------------------------------}
procedure TfrmPrefLayouts.cboViewChange(Sender: TObject);
var
    idx: integer;
begin
  inherited;
    idx := cboView.ItemIndex;
    imgView1.Visible := (idx = 0);
    imgView2.Visible := (idx = 1);

    case idx of
    0: lblViewHelp.Caption := _(sViewSimple);
    1: lblViewHelp.Caption := _(sViewShare);
    end;
    
end;

end.
