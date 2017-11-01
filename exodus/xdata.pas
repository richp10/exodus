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
unit xdata;


interface

uses
    Unicode, XMLTag,
    TntCheckLst, TntStdCtrls, StdCtrls, ExodusLabel,
    Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
    Dialogs, ExForm, buttonFrame, Grids, TntGrids, ExtCtrls, fXData, JabberID,
  ComCtrls, ToolWin, EntityCache, Entity, TntForms, ExFrame, TntExtCtrls,
  Dockable, StateForm;

type

  EXDataValidationError = class(Exception);

  TXDataRow = class
  private
    _owner: TWinControl;
    _hint: Widestring;
    _opts: TWidestringlist;
    _visible: boolean;
    
    procedure buildLabel(l: Widestring);
    procedure setVisible(val: Boolean);

    procedure DrawLabel(r: TRect);
    procedure DrawControl(r: TRect);
    procedure DrawButton(r: TRect);

    procedure JidSelect(Sender: TObject);

  public
    t: Widestring;
    v: Widestring;
    d: Widestring;
    lbl: TExodusLabel;
    con: TControl;
    btn: TTntButton;
    req: boolean;
    fixed: boolean;
    hidden: boolean;
    valid: boolean;
    r: TRect;

    constructor Create(o: TWinControl; x: TXMLTag);
    destructor Destroy(); override;

    function  Draw(top, left, col_width: integer): integer;
    function  GetXML(): TXMLTag;
    property  Visible: boolean read _visible write setVisible;
  end;

  TfrmXData = class(TExForm)
    frameButtons1: TframeButtons;
    frameXData: TframeXData;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure frameButtons1btnOKClick(Sender: TObject);
    procedure frameButtons1btnCancelClick(Sender: TObject);
  private
    { Private declarations }
    _packet: Widestring;
    _ns: Widestring;
    _thread: Widestring;
    _to_jid: Widestring;
    _type: Widestring;
    _responded: boolean;

    function getResponseTag(): TXMLTag;
  public
    { Public declarations }
    procedure Cancel();
    procedure Render(tag: TXMLTag);
  end;

var
  frmXData: TfrmXData;

const V_WS = 5;
const H_WS = 5;
const BTN_W = 30;
const XDATA_FONT_SIZE = 9;
const CHECKBOX_WIDTH = 20;

function  showXDataEx(tag: TXMLTag; title: widestring = ''): boolean;
procedure showXData(tag: TXMLTag);

implementation
{$R *.dfm}
uses
    SelectItem, Jabber1, 
    GnuGetText, JabberUtils, Session, Math, XMLUtils;

const
    sAllRequired = 'All required fields must be filled out.';
    sFormFrom = 'Form from %s';
    sClose = 'Close';
    sCancelled = 'Cancelled';
    sCancelMsg = '%s cancelled your form.';

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
function _showXData(tag: TXMLTag; title: widestring = ''): boolean;
var
    f: TfrmXData;
begin
    f := TfrmXData.Create(nil);
    if (title <> '') then
        f.Caption := title;

    f.Render(tag);
    f.Show();
    Result := true;
end;

{---------------------------------------}
function  showXDataEx(tag: TXMLTag; title: widestring = ''): boolean;
begin
    Result := _showXData(tag, title);
end;

{---------------------------------------}
procedure showXData(tag: TXMLTag);
begin
    _showXData(tag);
end;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
const MULTI_HEIGHT = 65;

constructor TXDataRow.Create(o: TWinControl; x: TXMLTag);
var
    i, idx: integer;
    opt, ol, l: Widestring;
    xl: TXMLTagList;
    jid: TJabberID;
begin
    _owner := o;
    _opts := nil;
    _visible := false;
    lbl := nil;
    con := nil;
    btn := nil;
    fixed := false;
    hidden := false;
    valid := true;

    if (x.Name = 'warning') then begin
        t := 'warning';
        fixed := true;
        req := false;
        buildLabel(x.Data);
        exit;
    end;

    if (x.Name = 'instructions') then begin
        t := 'instructions';
        fixed := true;
        req := false;
        buildLabel(x.Data);
        exit;
    end;

    v := x.GetAttribute('var');
    d := x.GetBasicText('value');
    l := x.GetAttribute('label');
    t := x.GetAttribute('type');
    _hint := x.GetBasicText('desc');
    req := (x.GetFirstTag('required') <> nil);

    // Create our controls
    if (t = 'fixed') then begin
        fixed := true;
        buildLabel(d);
        exit;
    end

    else if (t = 'hidden') then begin
        hidden := true;
        exit;
    end

    else if (t = 'boolean') then begin
        buildLabel(l);
        con := TTntCheckBox.Create(_owner);
        con.Parent := _owner;
        con.Visible := false;
        with TTntCheckBox(con) do begin
            Caption := '';
            Width := CHECKBOX_WIDTH; 
            d := Lowercase(d);
            Checked := ((d = 'true') or (d = '1') or (d = 'yes') or (d = 'assent'));
            Hint := _hint;
        end;
    end

    else if ((t = 'text-multi') or (t = 'jid-multi')) then begin
        buildLabel(l);
        con := TTntMemo.Create(_owner);
        con.Parent := _owner;
        con.Visible := false;

        with TTntMemo(con) do begin
            Height := MULTI_HEIGHT;
            ScrollBars := ssVertical;
            Lines.Clear();
            xl := x.QueryTags('value');
            for i := 0 to xl.Count - 1 do begin
                if (t = 'jid-multi') then begin
                    jid := TJabberID.Create(xl[i].Data);
                    Lines.Add(jid.getDisplayFull());
                    jid.Free();
                end
                else
                    Lines.Add(xl[i].Data);
            end;
            FreeAndNil(xl);
            WordWrap := false;
        end;
    end

    else if (t = 'list-single') then begin
        buildLabel(l);
        con := TTntComboBox.Create(_owner);
        con.Parent := _owner;
        con.Visible := false;
        _opts := TWidestringlist.Create();

        with TTntComboBox(con) do begin
            Style := csDropDownList;
            Items.Clear();
            xl := x.QueryTags('option');
            for i := 0 to xl.Count - 1 do begin
                opt := xl[i].GetBasicText('value');
                ol := xl[i].GetAttribute('label');
                _opts.Add(opt);
                if (ol = '') then
                    Items.Add(opt)
                else
                    Items.Add(ol);
            end;
            FreeAndNil(xl);
            i := _opts.IndexOf(d);
            if (i <> -1) and (i < Items.Count) then
                ItemIndex := _opts.IndexOf(d);
        end;
    end

    else if (t = 'list-multi') then begin
        buildLabel(l);
        con := TTntCheckListbox.Create(_owner);
        con.Parent := _owner;
        con.Visible := false;
        _opts := TWidestringlist.Create();

        with TTntCheckListbox(con) do begin
            Height := MULTI_HEIGHT;
            Items.Clear();
            xl := x.QueryTags('option');
            for i := 0 to xl.Count - 1 do begin
                opt := xl[i].GetBasicText('value');
                ol := xl[i].GetAttribute('label');
                _opts.Add(opt);
                if (ol = '') then
                    Items.Add(opt)
                else
                    Items.Add(ol);
            end;
            FreeAndNil(xl);

            // select all <value> elements
            xl := x.QueryTags('value');
            for i := 0 to xl.Count - 1 do begin
                idx := _opts.IndexOf(xl[i].Data);
                if (idx >= 0) then
                    Checked[idx] := true;
            end;
        end;
    end

    else begin
        // text-single, text-private or unknown
        buildLabel(l);
        con := TTntEdit.Create(_owner);
        con.Parent := _owner;
        con.Visible := false;
        with TTntEdit(con) do begin
            if (t = 'jid-single') then begin
                jid := TJabberID.create(d);
                Text := jid.getDisplayFull();
                jid.Free();
            end
            else
                Text := d;
            if (t = 'text-private') then
                PasswordChar := '*';
        end;
    end;

    // Create '...' btns for jid-multi and jid-single
    if ((t = 'jid-multi') or (t = 'jid-single')) then begin
        btn := TTntButton.Create(_owner);
        btn.Caption := '...';
        btn.Parent := _owner;
        btn.Visible := false;
        btn.OnClick := JidSelect;
        btn.Width := CHECKBOX_WIDTH;
    end;

end;

{---------------------------------------}
destructor TXDataRow.Destroy();
begin
    if (lbl <> nil) then
        FreeAndNil(lbl);
    if (con <> nil) then
        FreeAndNil(con);
    if (btn <> nil) then
        FreeAndNil(btn);
    if (_opts <> nil) then
        FreeAndNil(_opts);
end;

{---------------------------------------}
procedure TXDataRow.buildLabel(l: Widestring);
begin
    lbl := TExodusLabel.Create(_owner);
    lbl.Parent := _owner;

    // put stars on required fields
    if (req) then
        lbl.Caption := l + ' ' + _('(Required)')
    else
        lbl.Caption := l;
        
    lbl.Hint := _hint;
    lbl.Visible := false;
end;

{---------------------------------------}
function TXDataRow.GetXML(): TXMLTag;
var
    f: TXMLTag;
    i, j: integer;
    jid: TJabberID;
begin
    // fetch data from controls into d params
    // and send back the <field/> element
    valid := true;
    if ((t = 'fixed') or (t = 'instructions')) then begin
        Result := nil;
        exit;
    end;

    f := TXMLTag.Create('field');
    f.setAttribute('var', v);

    if (t = 'hidden') then begin
        f.AddBasicTag('value', d);
    end

    else if (t = 'boolean') then begin
        if (TTntCheckBox(con).Checked) then
            d := '1'
        else
            d := '0';
        f.AddBasicTag('value', d);
    end

    else if (t = 'text-multi') then begin
        with TTntMemo(con) do begin
            if ((req) and (Lines.Count = 0)) then
                valid := false
            else begin
                for i := 0 to Lines.Count - 1 do
                    f.AddBasicTag('value', Lines[i]);
            end;
        end;
    end

    else if (t = 'jid-multi') then begin
         with TTntMemo(con) do begin
            if ((req) and (Lines.Count = 0)) then
                valid := false
            else begin
                for i := 0 to Lines.Count - 1 do begin
                    jid := TJabberID.Create(Lines[i], false);
                    f.AddBasicTag('value', jid.full);
                    jid.Free();
                end;
            end;
        end;
    end

    else if (t = 'list-single') then begin
        i := TTntComboBox(con).ItemIndex;
        f.AddBasicTag('value', _opts[i]);
    end

    else if (t = 'list-multi') then begin
        with TTntCheckListbox(con) do begin
            j := 0;
            for i := 0 to Items.Count - 1 do begin
                if (Checked[i]) then begin
                    inc(j);
                    f.AddBasicTag('value', _opts[i]);
                end;
            end;
            if ((req) and (j = 0)) then
                valid := false;
        end;
    end

    else begin
        // text-single, text-private or unknown
        d := TTntEdit(con).Text;
        if ((req) and (d = '')) then
            valid := false;
        if (t = 'jid-single') then begin
            jid := TJabberID.Create(d, false);
            f.AddBasicTag('value', jid.full);
            jid.Free();
        end
        else
            f.AddBasicTag('value', d);
    end;

    Result := f;

end;

{---------------------------------------}
procedure TXDataRow.setVisible(val: Boolean);
begin
    if (val = _visible) then exit;

    if (lbl <> nil) then lbl.Visible := val;
    if (con <> nil) then con.Visible := val;
    if (btn <> nil) then btn.Visible := val;

    _visible := val;
end;

{---------------------------------------}
procedure TXDataRow.JidSelect(Sender: TObject);
var
    selected: Widestring;
    jid: TJabberID;
begin
    selected := SelectUIDByType('contact');
    if (selected <> '') then begin
        jid := TJabberID.Create(selected);
        if (con is TTntEdit) then
            TTntEdit(con).Text := jid.GetDisplayFull()
        else if (con is TTntMemo) then
            TTntMemo(con).Lines.Add(jid.GetDisplayFull());
        jid.Free();
    end;
end;

{---------------------------------------}
function TXDataRow.Draw(top, left, col_width: integer): integer;
var
    rh: integer;
    r1, r2, r3, rj: TRect;
begin
    // check for hidden fields
    if ((lbl = nil) and (con = nil)) then begin
        Result := 0;
        exit;
    end;

    // check the label height
    if (lbl <> nil) then begin
        if (t = 'boolean') then
            lbl.Width := col_width * 2 - con.Width
        else if (fixed) then
            lbl.Width := col_width * 2
        else
            lbl.Width := col_width;
        lbl.AutoSize();

        // allow for xtra whitespace between instructions
        if (t = 'instructions') then
            rh := lbl.Height + V_WS + V_WS
        else
            rh := lbl.Height + V_WS
    end
    else
        rh := 0;

    // check the control height
    if (con <> nil) then
        rh := max(rh, con.Height + V_WS);

    // setup the rects for this row
    r1.Top := top;
    r1.Left := left;
    r1.Right := col_width;
    r1.Bottom := top + rh;

    r2 := r1;
    r2.Left := col_width;
    r2.Right := r2.Left + col_width;

    rj := r1;
    rj.Right := col_width * 2;

    r3 := r2;
    r3.Left := r2.Right;
    r3.Right := r2.Right + BTN_W;

    if (t = 'boolean') then begin
        // draw the control left, then the label directly next to it
        r2.Left := r1.Left + con.Width + H_WS;
        r1.Right := r2.Left - H_WS;
        DrawControl(r1);
        DrawLabel(r2);
    end
    else if (fixed) then
        DrawLabel(rj)
    else if ((lbl = nil) and (con <> nil)) then
        DrawControl(rj)
    else begin
        if (lbl <> nil) then
            DrawLabel(r1);
        if (con <> nil) then
            DrawControl(r2);
    end;

    if (btn <> nil) then
        DrawButton(r3);

    Result := rh;
end;

{---------------------------------------}
procedure TXDataRow.DrawLabel(r: TRect);
begin
    if (lbl = nil) then exit;
    if (r.Top < 0) then exit;

    lbl.Left := r.Left;
    lbl.Top := r.Top;
    lbl.Width := r.Right - r.Left;

    if (not lbl.Visible) then begin
        lbl.Visible := true;
        lbl.Refresh();
        _visible := true;
    end;
end;

{---------------------------------------}
procedure TXDataRow.DrawControl(r: TRect);
var
    move: boolean;
begin
    if (con = nil) then exit;
    if (r.Top < 0) then exit;

    move := (r.Top <> con.Top) or (r.Left <> con.Left);

    con.Top := r.Top;
    con.Left := r.Left;
    con.Width := r.Right - r.Left;

    if (not con.visible) or (move) then begin
        con.Visible := true;
        con.Refresh();
        _visible := true;
    end;

end;

{---------------------------------------}
procedure TXDataRow.DrawButton(r: TRect);
begin
    if (btn = nil) then exit;
    if (r.Top < 0) then exit;

    btn.Top := r.Top;
    btn.Left := r.Left;

    if (not btn.Visible) then begin
        btn.Visible := true;
        btn.Invalidate();
        _visible := true;
    end;
end;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
procedure TfrmXData.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    inherited;
    if (not _responded) then Cancel();
    Action := caFree;
    if (MainSession <> nil) then
        MainSession.Prefs.SavePosition(Self);
end;

{---------------------------------------}
procedure TfrmXData.Render(tag: TXMLTag);
var
    x: TXMLTag;
begin
    // Get our context/xmlns
    _to_jid := tag.getAttribute('from');
    Caption := Caption + ' from ' + _to_jid;

    if (tag.Name = 'iq') then begin
        _packet := 'iq';
        _ns := tag.QueryXPData('/iq/query@xmlns')
    end
    else if (tag.Name = 'message') then begin
        _packet := 'message';
        _thread := tag.GetBasicText('thread');
    end;

    // Get the x-data container.
    x := tag.QueryXPTag('//x[@xmlns="jabber:x:data"]');
    if (x = nil) then exit;

    _type := x.GetAttribute('type');
    _responded := false;

    frameXData.Render(x);
end;

{---------------------------------------}
function TfrmXData.getResponseTag(): TXMLTag;
var
    r, q: TXMLTag;
begin
    // Get a properly formatted result or cancel packet
    r := TXMLTag.Create(_packet);
    r.setAttribute('to', _to_jid);

    if (_packet = 'message') then begin
        if (_thread <> '') then
            r.AddBasicTag('thread', _thread);
        r.AddTag('body');
    end
    else if (_packet = 'iq') then begin
        r.setAttribute('type', 'set');
        r.setAttribute('id', MainSession.generateID());

        q := r.AddTag('query');
        q.setAttribute('xmlns', _ns);
    end;

    Result := r;
end;

{---------------------------------------}
procedure TfrmXData.frameButtons1btnOKClick(Sender: TObject);
var
    r, q, x: TXMLTag;
    e: TJabberEntity;
begin
  inherited;

    // submit the form
    if ((_type = 'form') and (_to_jid <> '')) then begin
        // do something
        if (not MainSession.Active) then begin
            MessageDlgW(_('You are currently disconnected. Please reconnect before responding to this form.'),
                mtError, [mbOK], 0);
            exit;
        end;

        try
            r := getResponseTag();
            if (_packet = 'iq') then
                q := r.GetFirstTag('query')
            else
                q := r;
            x := frameXData.submit();
            q.AddTag(x);
            x.setAttribute('type', 'submit');
        except
            on EXDataValidationError do begin
                MessageDlgW(_(sAllRequired), mtError, [mbOK], 0);
                exit;
            end;
        end;

        MainSession.SendTag(r);
        //Refresh entity
        e := jEntityCache.getByJid(_to_jid, '');
        if (e <> nil) then
           e.refreshInfo(MainSession);

    end;
    _responded := true;

    Self.Close();
end;

{---------------------------------------}
procedure TfrmXData.frameButtons1btnCancelClick(Sender: TObject);
begin
  inherited;
    frameXData.Cancel();
    Self.Close();
end;

{---------------------------------------}
procedure TfrmXData.Cancel();
var
    r, x, q: TXMLTag;
begin
    if ((_type = 'form') and (_to_jid <> '')) then begin
        if (not MainSession.Active) then begin
            MessageDlgW(_('You are currently disconnected. Please reconnect before responding to this form.'),
                mtError, [mbOK], 0);
            exit;
        end;
        r := getResponseTag();  // creates <iq><query></iq> and all the fillings
        x := frameXData.cancel();
        if (r.Name = 'message') then
            r.AddTag(x)
        else begin
            q := r.GetFirstTag('query');
            if (q = nil) then Exit;
            q.AddTag(x);
        end;

        MainSession.SendTag(r);
    end;
    _responded := true;
end;

end.
