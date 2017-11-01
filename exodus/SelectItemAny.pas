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
unit SelectItemAny;


interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, SelectItem, Menus, TntMenus, StdCtrls, TntStdCtrls, ExtCtrls,
  TntExtCtrls, ExCustomSeparatorBar;

type
  TfrmSelectItemAny = class(TfrmSelectItem)
    pnlAny: TTntPanel;
    chkAny: TTntCheckBox;
    procedure chkAnyClick(Sender: TObject);
  private
    { Private declarations }
    _itemViewDefaultColor: TColor;
    _txtJIDDefaultColor: TColor;

  protected
    { Protected declarations }

  public
    { Public declarations }
  end;


function SelectUIDByTypeAny(itemtype: Widestring; title: Widestring = ''; ownerHWND: HWND = 0): Widestring;

var
  frmSelectItemAny: TfrmSelectItemAny;

const
    ANY_JID_MARKER = '@#ANY';

implementation

{$R *.dfm}

function SelectUIDByTypeAny(itemtype: Widestring; title: Widestring; ownerHWND: HWND): Widestring;
var
    selector: TfrmSelectItem;
begin
    Result := '';
    selector := TfrmSelectItemAny.Create(nil, itemtype, ownerHWND);
    if (title <> '') then
        selector.Caption := title;

    if (selector.ShowModal = mrOk) then begin
        Result := selector.SelectedUID;
    end;

    selector.Free;
end;

procedure TfrmSelectItemAny.chkAnyClick(Sender: TObject);
var
    templist: TList;
begin
    inherited;

    if (chkAny.Checked) then begin
        _itemViewDefaultColor := _itemView.Color;
        _itemView.Enabled := false;
        _itemView.ParentColor := true;
        templist := TList.Create();
        _itemView.Select(templist);
        templist.Free();

        _txtJIDDefaultColor := txtJID.Color;
        txtJID.Enabled := false;
        txtJID.ParentColor := true;
        txtJID.Text := '';

        _selectedUID := ANY_JID_MARKER;
        btnOK.Enabled := true;
    end
    else begin
        _itemView.Enabled := true;
        _itemView.ParentColor := false;
        _itemView.Color := _itemViewDefaultColor;

        txtJID.Enabled := true;
        txtJID.ParentColor := false;
        txtJID.Color := _txtJIDDefaultColor;

        _selectedUID := '';
        btnOK.Enabled := false;
    end;
end;

end.
