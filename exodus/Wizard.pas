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
unit Wizard;


interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, TntStdCtrls, ExtCtrls, TntExtCtrls, ComCtrls, ExForm;

type
  TfrmWizard = class(TExForm)
    TntPanel1: TTntPanel;
    Bevel1: TBevel;
    Panel1: TPanel;
    Bevel2: TBevel;
    lblWizardTitle: TTntLabel;
    lblWizardDetails: TTntLabel;
    Image1: TImage;
    Tabs: TPageControl;
    TabSheet1: TTabSheet;
    Panel3: TPanel;
    btnBack: TTntButton;
    btnNext: TTntButton;
    btnCancel: TTntButton;
    procedure FormCreate(Sender: TObject);
    procedure Panel1Resize(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmWizard: TfrmWizard;

implementation

procedure TfrmWizard.FormCreate(Sender: TObject);
begin
    Image1.Picture.Icon.Handle := Application.Icon.Handle;

    lblWizardTitle.Width := Panel1.Width - lblWizardTitle.Left - Image1.Width - 5;
    lblWizardDetails.Width := Panel1.Width - lblWizardDetails.Left - Image1.Width - 5;
end;
{$R *.dfm}

procedure TfrmWizard.Panel1Resize(Sender: TObject);
begin
    inherited;
    lblWizardTitle.Width := Panel1.Width - lblWizardTitle.Left - Image1.Width - 5;
    lblWizardDetails.Width := Panel1.Width - lblWizardDetails.Left - Image1.Width - 5;
end;

end.
