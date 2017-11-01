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
unit ExGettextUtils;



interface

uses
    SysUtils, Dialogs, ComCtrls, StdCtrls, ExtCtrls,
    TntStdCtrls, TntComCtrls, TntExtCtrls, GnuGetText;

type
    TTNTTranslator = class
    public
        procedure TranslateRadioGroup(obj: TObject);
        procedure TranslateCombobox(obj: TObject);
    end;

var
    ExTranslator: TTNTTranslator;

implementation

procedure TTNTTranslator.TranslateRadioGroup(obj: TObject);
var
    rg: TTntRadioGroup;
    w: Widestring;
    i: integer;
begin
    rg := TTntRadioGroup(obj);
    for i := 0 to rg.Items.Count - 1 do begin
        w := rg.Items[i];
        w := GetText(w);
        rg.Items[i] := w;
    end;
    w := rg.Caption;
    w := GetText(w);
    rg.Caption := w;
end;

procedure TTNTTranslator.TranslateCombobox(obj: TObject);
var
    cb: TTntComboBox;
    w: widestring;
    i: integer;
begin
    cb := TTntComboBox(obj);
    for i := 0 to cb.Items.Count - 1 do begin
        w := cb.Items[i];
        w := GetText(w);
        cb.Items[i] := w;
    end;
    w := cb.Text;
    w := GetText(w);
    cb.Text := w;
end;

initialization
    ExTranslator := TTNTTranslator.Create();
    TP_GlobalHandleClass(TTntRadioGroup, ExTranslator.TranslateRadioGroup);
    TP_GlobalHandleClass(TTntComboBox, ExTranslator.TranslateComboBox);

finalization
    FreeAndNil(ExTranslator);

end.
