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
unit DockWizard;


interface

uses
    Dockable,
    Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
    Dialogs, StdCtrls, TntStdCtrls, ExtCtrls, TntExtCtrls, ComCtrls, ToolWin,
  ImgList;

type
  TfrmDockWizard = class(TfrmDockable)
    TntPanel1: TTntPanel;
    Bevel1: TBevel;
    btnBack: TTntButton;
    btnNext: TTntButton;
    btnCancel: TTntButton;
    Tabs: TPageControl;
    TabSheet1: TTabSheet;
    Panel1: TPanel;
    Bevel2: TBevel;
    lblWizardTitle: TTntLabel;
    lblWizardDetails: TTntLabel;
    Image1: TImage;
    pnlBevel: TTntPanel;
    procedure FormCreate(Sender: TObject);
    procedure Panel1Resize(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmDockWizard: TfrmDockWizard;

implementation

{$R *.dfm}

procedure TfrmDockWizard.FormCreate(Sender: TObject);
begin
    inherited;

    lblWizardTitle.Width := Panel1.Width - lblWizardTitle.Left - Image1.Width - 5;
    lblWizardDetails.Width := Panel1.Width - lblWizardDetails.Left - Image1.Width - 5;
end;

procedure TfrmDockWizard.Panel1Resize(Sender: TObject);
begin
    inherited;
    lblWizardTitle.Width := Panel1.Width - lblWizardTitle.Left - Image1.Width - 5;
    lblWizardDetails.Width := Panel1.Width - lblWizardDetails.Left - Image1.Width - 5;

end;

end.
