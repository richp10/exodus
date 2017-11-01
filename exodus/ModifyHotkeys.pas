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
unit ModifyHotkeys;


interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, TntStdCtrls, ExForm;

type
  TfrmModifyHotkeys = class(TExForm)
    btnOK: TTntButton;
    btnCancel: TTntButton;
    txtHotkeyMessage: TTntEdit;
    cbhotkey: TTntComboBox;
    TntLabel1: TTntLabel;
    TntLabel2: TTntLabel;
    procedure txtHotkeyMessageChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

procedure TfrmModifyHotkeys.txtHotkeyMessageChange(Sender: TObject);
begin
    if (Length(txtHotkeyMessage.Text) > 0) then
        btnOK.Enabled := true
    else
        btnOK.Enabled := false
end;

end.
