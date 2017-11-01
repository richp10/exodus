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
unit fGeneric;


interface

uses
    Unicode, XMLTag,
    Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
    StdCtrls, TntCheckLst, TntStdCtrls, ExtCtrls, Contnrs, ExodusLabel, ExFrame;

type

  TframeGeneric = class(TExFrame)
    elCaption: TExodusLabel;
    procedure FrameResize(Sender: TObject);
  private
    { Private declarations }
    value: Widestring;
    fld_type: string;
    fld_var: Widestring;
    frm_type: string;
    req: boolean;
    c: TControl;
    opts_vals: TStringList;
    dot : TButton;
    change_width: boolean;

    function getValues: TWideStringList;
    procedure JidFieldDotClick(Sender: TObject);
  public
    { Public declarations }
    procedure render(tag: TXMLTag);
    function isValid: boolean;
    function getXML: TXMLTag;
    function getLabelWidth: integer;
    procedure setLabelWidth(val: integer);

    property FormType: string read frm_type write frm_type;
  end;

implementation

{$R *.dfm}
uses
    Math, JabberConst, 
    Jabber1, GnuGetText,
    JabberID, ShellAPI,
    SelectItem, ExRichEdit,
    JabberUtils, ExUtils,  CheckLst, RichEdit2, Types;

const
    sRequired = '(Required)';

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
procedure TframeGeneric.render(tag: TXMLTag);
var
    v, l, t: Widestring;
    opts: TXMLTagList;
    idx, i: integer;
begin
    // take a x-data field tag and do the right thing
    Self.BorderWidth := 1;
    AssignDefaultFont(Self.Font);
    dot := nil;

    fld_var := tag.GetAttribute('var');
    t := tag.GetAttribute('type');
    req := tag.TagExists('required');
    value := tag.GetBasicText('value');
    Self.Hint := tag.GetBasicText('desc');

    if (req) then begin
       if (Self.Hint = '') then
          Self.Hint := _(sRequired)
       else
          Self.Hint := Self.Hint + ''#13#10 + _(sRequired);
   end;

    elCaption.Caption := tag.GetAttribute('label');
    if (elCaption.Caption = '') then
        elCaption.Caption := tag.GetAttribute('var');

    if (elCaption.Caption = '') then
        elCaption.Width := 0
    else begin
        elCaption.Caption := elCaption.Caption + ':';
        if (req) then
           elCaption.Caption := '* ' + elCaption.Caption;
    end;

    if ((t = 'text-multi') or (t = 'jid-multi')) then begin
        c := TTntMemo.Create(Self);
        c.Parent := Self;
        opts := tag.QueryTags('value');
        with TTntMemo(c) do begin
            TabOrder := 0;
            Align := alClient;
            ScrollBars := ssBoth;
            Lines.Clear();
            for i := 0 to opts.Count - 1 do
                Lines.Add(opts[i].Data);
        end;
        Self.Height := Self.Height * 3;
    end

    else if (t = 'list-multi') then begin
        c := TTntCheckListbox.Create(self);
        c.Parent := Self;
        opts_vals := TStringList.Create();
        opts := tag.QueryTags('option');
        with TTntCheckListbox(c) do begin
            TabOrder := 0;
            Align := alClient;
            for i := 0 to opts.Count - 1 do begin
                v := opts[i].GetBasicText('value');
                if (v = '') then continue;

                l := opts[i].GetAttribute('label');
                if (l = '') then l := v;

                Items.Add(l);
                opts_vals.Add(v);
            end;
        end;

        opts := tag.QueryTags('value');
        for i := 0 to opts.Count - 1 do begin
            idx := opts_vals.IndexOf(opts[i].Data);
            TTntCheckListbox(c).Checked[idx] := true;
        end;

        if (TTntCheckListbox(c).Items.Count < 6) then
            i := TTntCheckListbox(c).Items.Count
        else
            i := 5;
        Self.Height := (TTntCheckListbox(c).ItemHeight * i) + 5;
        TTntCheckListbox(c).TopIndex := 0;
        TTntCheckListbox(c).TabOrder := 0;
        TTntCheckListbox(c).Repaint();
    end
    else if (t = 'list-single') then begin
        c := TTntCombobox.Create(self);
        c.Parent := Self;
        opts_vals := TStringList.Create();
        opts := tag.QueryTags('option');
        with TTntCombobox(c) do begin
            TabOrder := 0;
            Style := csDropDownList;
            Align := alClient;
            for i := 0 to opts.Count - 1 do begin
                v := opts[i].GetBasicText('value');
                if (v = '') then continue;

                l := opts[i].GetAttribute('label');
                if (l = '') then l := v;

                Items.Add(l);
                opts_vals.Add(v);
            end;
            ItemIndex := opts_vals.IndexOf(value);
        end;
    end

    else if (t = 'boolean') then begin
        c := TTntCheckbox.Create(Self);
        with TTntCheckbox(c) do begin
            TabOrder := 0;
            Caption := '';
            Checked := (value = '1');
        end;
    end
    else if (t = 'fixed') then begin
        elCaption.Visible := false;
        c := TExodusLabel.Create(Self);
        with TExodusLabel(c) do begin
            TabOrder := 0;
            Parent := Self;
            Align := alTop;
            Caption := value;
        end;
    end

    else if ((t = 'hidden') and (frm_type <> 'submit')) then begin
        Self.Height := 0;
        elCaption.Height := 0;
        c := nil;
    end

    else if ((t = 'jid') or (t = 'jid-single')) then begin
        c :=  TTntEdit.Create(Self);
        with TTntEdit(c) do begin
            TabOrder := 0;
            Text := value;
            // Anchors := [akLeft, akTop, akBottom, akRight];
            Parent := Self;
            Align := alNone;
            Top := 1;
        end;

        dot := TButton.Create(Self);
        with TButton(dot) do begin
            TabOrder := 1;
            Caption := _('...');
            OnClick := JidFieldDotClick;
            Top := 1;
            Parent := Self;
            Visible := true;
            Width := c.Height - 2;
            Align := alRight;
        end;

        c.Width := Self.ClientWidth - elCaption.Width - dot.Width - 10;
    end
    else begin  // 'text-single', 'text-private', or unknown
        c := TTntEdit.Create(Self);
        with TTntEdit(c) do begin
            TabOrder := 0;
            Text := value;
            Align := alNone;
            if (t = 'text-private') then
                PasswordChar := '*';
            Top := 1;
        end;
    end;

    if (c <> nil) then begin
        c.Parent := Self;
        c.Visible := true;
        c.Left := elCaption.Width + 5;
        c.Top := 1;
        //Self.ClientHeight := c.Height + (2 * Self.BorderWidth);
    end;

    fld_type := t;
    if (frm_type = 'submit') then
        c.Enabled := false;

    // Force redraw to make everything size correctly.
    FrameResize(nil);
end;

{---------------------------------------}
function TframeGeneric.isValid: boolean;
begin
    Result := (not req) or (getValues().Count > 0);

    if (fld_type = 'jid') then
        // make sure we have a valid JID
        Result := isValidJID(TTntEdit(c).Text);

    if (Result) then
       elCaption.Font.Color := clWindowText
    else
       elCaption.Font.Color := clRed;
end;

{---------------------------------------}
function TframeGeneric.getXML: TXMLTag;
var
    vals: TWideStringlist;
    i: integer;
begin
    // Return the xml for this field
    vals := getValues();

    if (vals.Count = 0) then begin
        vals.Free();
        Result := nil;
        exit;
    end;

    Result := TXMLTag.Create('field');
    Result.setAttribute('var', fld_var);

    for i := 0 to vals.Count - 1 do
        Result.AddBasicTag('value', vals[i]);

    vals.Free();
end;

{---------------------------------------}
function TframeGeneric.getValues: TWideStringList;
var
    tmps: WideString;
    i: integer;
begin
    Result := TWideStringlist.Create();
    if (c = elCaption) then exit;

    if (c is TTntEdit) then begin
        tmps := Trim(TTntEdit(c).Text);
        if (tmps <> '') then
            Result.Add(TTntEdit(c).Text);
    end
    else if (c is TTntMemo) then begin
        tmps := Trim(TTntMemo(c).Text);
        if (tmps <> '') then with TTntMemo(c) do begin
            for i := 0 to Lines.Count - 1 do
                Result.Add(Lines[i]);
        end;
    end
    else if (c is TTntCheckListbox) then with TTntCheckListbox(c) do begin
        for i := 0 to Items.Count - 1 do begin
            if Checked[i] then
                Result.Add(opts_vals[i]);
        end;
    end
    else if (c is TTntCombobox) then begin
        i := TTntCombobox(c).ItemIndex;
        if (i <> -1) then
            Result.Add(opts_vals[i]);
    end
    else if (c is TTntCheckbox) then begin
        if (TTntCheckbox(c).checked) then
            Result.Add('1')
        else
            Result.Add('0');
    end
    else if (c = nil) then
        Result.Add(value);
end;

{---------------------------------------}
procedure TframeGeneric.JidFieldDotClick(Sender: TObject);
var
    selected :Widestring;
begin
    selected := SelectUIDByType('contact');
    if (selected <> '') then begin
        TTntEdit(c).Text := selected;
    end;
end;

{---------------------------------------}
procedure TframeGeneric.FrameResize(Sender: TObject);
begin
    if (change_width) then exit;

    if (c is TTntEdit) then begin
        if (dot <> nil) then
            c.width := Self.ClientWidth - elCaption.Width - dot.Width - 6 - 2
        else begin
            c.Width := Self.ClientWidth - elCaption.Width;
        end;
        Self.Height := max(max(c.Height + 4, Self.Height), elCaption.Height);
    end
    else if (c <> nil) then begin
        if (c.Height+2 > Self.Height) then
            self.Height := c.Height + 4;
        if elCaption.Height > Self.Height then
            self.Height := elCaption.Height;
    end;
end;

{---------------------------------------}
function TframeGeneric.getLabelWidth: integer;
var
    p : TForm;
begin
    if ((elCaption = nil) or (elCaption.Width = 0) or (elCaption = c)) then
        result := 0
    else begin
        p := TForm(Self.Owner);
        result := CanvasTextWidthW(p.Canvas, elCaption.Caption);
    end;
end;

{---------------------------------------}
procedure TframeGeneric.setLabelWidth(val: integer);
begin
    if ((elCaption.Width <> 0) and (elCaption <> c)) then begin
        change_width := true;
        elCaption.Width := val;
        change_width := false;
        if ((c <> nil) and (not (c is TExodusLabel))) then
            c.Left := val;
    end;
end;

end.
