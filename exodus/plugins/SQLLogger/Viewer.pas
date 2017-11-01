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
unit Viewer;



interface

uses
    SQLiteTable,
    Contnrs, Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
    Dialogs, StdCtrls, ExtCtrls, ComCtrls, ExRichEdit,
    TntStdCtrls, Buttons, TntExtCtrls, Grids, TntGrids, TntComCtrls,
    RichEdit2;

type
  TMonthDay = 1..31;

  TConversation = class
    jid: Widestring;
    thread: Widestring;
    count: integer;
    msgs: TSQLiteTable;
    dt: TDateTime;
  end;

  TfrmView = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    pnlCal: TPanel;
    pnlToday: TTntPanel;
    pnlCalHeader: TTntPanel;
    btnPrevMonth: TSpeedButton;
    btnNextMonth: TSpeedButton;
    gridCal: TTntStringGrid;
    TntLabel1: TTntLabel;
    cboJid: TTntComboBox;
    TntLabel2: TTntLabel;
    txtWords: TTntEdit;
    pnlRight: TPanel;
    MsgList: TExRichEdit;
    Splitter1: TSplitter;
    btnSearch: TTntButton;
    lstConv: TTntListView;
    TntLabel3: TTntLabel;
    cboDateFilter: TTntComboBox;
    pnlSQL: TPanel;
    lblSQL: TTntLabel;
    btnDetails: TTntButton;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure gridCalSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure gridCalDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure btnNextMonthClick(Sender: TObject);
    procedure cboJidChange(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure lstConvData(Sender: TObject; Item: TListItem);
    procedure lstConvSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure btnSearchClick(Sender: TObject);
    procedure lstConvDataStateChange(Sender: TObject; StartIndex,
      EndIndex: Integer; OldState, NewState: TItemStates);
    procedure cboDateFilterChange(Sender: TObject);
    procedure btnDetailsClick(Sender: TObject);
    procedure cboJidSelect(Sender: TObject);
    procedure lstConvDblClick(Sender: TObject);
  private
    { Private declarations }
    _jid: String;
    _days: set of TMonthDay;
    _last: TDatetime;
    _m: Word;
    _y: Word;
    _i1: integer;
    _i2: integer;
    _keywords: TStringlist;
    _start_idx: integer;
    _end_idx: integer;
    _date_filter: integer;

    // persistent result sets
    _convs: TObjectList;

    procedure DisplayMsg(tmp: TSQLiteTable);
    procedure SelectMonth(d: TDateTime);
    procedure SelectDay(d: TDateTime);
    procedure SelectAll();
    procedure DrawCal(d: TDateTime);
    
    procedure _processSelectedConvs();
    procedure _query();
    procedure _updateConvList();

  public
    { Public declarations }
    db: TSQLiteDatabase;

    procedure ShowJid(jid: Widestring);
    procedure ShowSearch();
  end;

var
  frmView: TfrmView;

implementation

uses
    SQLUtils, SQLPlugin,
    DateUtils;

{$R *.dfm}

{---------------------------------------}

{---------------------------------------}
{---------------------------------------}
procedure TfrmView.ShowJid(jid: Widestring);
begin
    cboJid.Items.Add(jid);
    cboJid.ItemIndex := 1;
    _jid := UTF8Encode(jid);
    _last := 0;
    SelectMonth(Now());
    _query();
    SelectDay(Now());
end;

{---------------------------------------}
{---------------------------------------}
procedure TfrmView.ShowSearch();
begin
    cboJid.ItemIndex := 0;
    _jid := '';
    _last := 0;
    SelectMonth(Now());
    _query();
    SelectDay(Now());
end;

{---------------------------------------}
{---------------------------------------}
procedure TfrmView._updateConvList();
var
    cnt: integer;
begin
    //
    if (_end_idx > -1) then
        cnt := (_end_idx - _start_idx) + 1
    else
        cnt := 0;
    lstConv.Items.Clear();
    lstConv.Items.Count := cnt;
    lstConv.Invalidate();
    lstConv.Refresh();

    // Select the first thing in the list automatically.
    if (cnt > 0) then
        lstConv.ItemIndex := 0;
end;

{---------------------------------------}
procedure TfrmView.SelectAll();
var
    i: integer;
    conv: TConversation;
begin
    if ((_convs = nil) or (_convs.Count = 0)) then begin
        lstConv.Items.Count := 0;
        lstConv.Invalidate();
        lstConv.Refresh();
        exit;
    end;

    if (_date_filter = 1) then begin
        for i := 0 to _convs.Count - 1 do begin
            conv := TConversation(_convs[i]);
            if ((Trunc(conv.dt) >= _i1) and (Trunc(conv.dt) <= _i2)) then begin
                if (_start_idx = -1) then _start_idx := i;
                _end_idx := i;
            end;
        end;
    end
    else begin
        _start_idx := 0;
        _end_idx := _convs.Count - 1;
    end;

    _updateConvList();
end;

{---------------------------------------}
procedure TfrmView.SelectDay(d: TDateTime);
var
    c1, r, c, i: integer;
    td, d1: TDateTime;
    conv: TConversation;
    sel: TGridRect;
begin
    _date_filter := 0;
    td := Trunc(d);
    if (_last = td) then exit;

    // Clear out existing
    _start_idx := -1;
    _end_idx := -1;
    MsgList.WideLines.Clear();

    // hunt thru _convs to find the range     
    if ((_convs = nil) or (_convs.Count = 0)) then begin
        lstConv.Items.Count := 0;
        lstConv.Invalidate();
        lstConv.Refresh();
        exit;
    end;

    for i := 0 to _convs.Count - 1 do begin
        conv := TConversation(_convs[i]);
        if (Trunc(conv.dt) = td) then begin
            if (_start_idx = -1) then _start_idx := i;
            _end_idx := i;
        end;
    end;

    _updateConvList();
    
    _last := td;

    // find out where the first of this month is..
    d1 := EncodeDate(YearOf(d), MonthOf(d), 1);
    c1 := DayOfWeek(d1) - 1;

    c := DayOfWeek(d) - 1;
    r := NthDayOfWeek(d);

    // if todays day of the week is before the day of the week of the
    // first of the month, then we aren't on the first "row", we're on the
    // "second" row (ie, Jan 1, is a Friday, it's currently Jan 3, which
    // is the following sunday, which is row 2).
    if (c < c1) then r := r + 1;

    sel.top := r;
    sel.bottom := r;
    sel.left := c;
    sel.right := c;
    gridCal.Selection := sel;

end;

{---------------------------------------}
procedure TfrmView.SelectMonth(d: TDateTime);
var
    y, m:  Word;
    d1, d2: TDateTime;
begin
    y := YearOf(d);
    m := MonthOf(d);
    d1 := EncodeDate(y, m, 1);
    d2 := EncodeDate(y, m, DaysInMonth(d1));
    _i1 := Trunc(d1);
    _i2 := Trunc(d2);
end;

{---------------------------------------}
procedure TfrmView.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    Action := caFree;
end;

{---------------------------------------}
procedure TfrmView.DisplayMsg(tmp: TSQLiteTable);
var
    d: integer;
    t: double;
    txt: WideString;
    ts: double;
    nick: Widestring;
    c: TColor;
begin
    txt := UTF8Decode(sql2str(tmp.Fields[F1_BODY]));

    d := StrToInt(tmp.Fields[F1_DATE]);
    t := StrToFloat(tmp.Fields[F1_TIME]);
    ts := d + t;

    // Make sure we're inputting text in Unicode format.
    MsgList.InputFormat := ifUnicode;
    MsgList.SelStart := Length(MsgList.WideLines.Text);
    MsgList.SelLength := 0;

    MsgList.SelAttributes.Color := clGray;
    MsgList.WideSelText := '[' + FormatDateTime('h:mm am/pm', ts) + ']';

    nick := UTF8Decode(tmp.Fields[F1_NICK]);
    if (nick = '') then begin
        c := clGreen;
        MsgList.SelAttributes.Color := c;
        MsgList.WideSelText := '' + txt;
    end
    else begin
        if (Uppercase(tmp.Fields[F1_OUT]) = 'TRUE') then
            c := clRed
        else
            c := clBlue;

        MsgList.SelAttributes.Color := c;
        MsgList.WideSelText := '<' + nick + '>';

        MsgList.SelAttributes.Color := clDefault;
        MsgList.WideSelText := ' ' + txt;
    end;

    MsgList.WideSelText := #13#10;
end;

{---------------------------------------}
procedure TfrmView.FormCreate(Sender: TObject);
var
    i, cw: integer;
begin
    _last := 0;
    _start_idx := -1;
    _end_idx := -1;
    _keywords := TStringlist.Create();
    
    gridCal.Cells[0, 0] := 'S';
    gridCal.Cells[1, 0] := 'M';
    gridCal.Cells[2, 0] := 'T';
    gridCal.Cells[3, 0] := 'W';
    gridCal.Cells[4, 0] := 'T';
    gridCal.Cells[5, 0] := 'F';
    gridCal.Cells[6, 0] := 'S';

    _convs := nil;
    cw := Trunc(gridCal.Width / 7.0);
    for i := 0 to 6 do
        gridCal.ColWidths[i] := cw;
    DrawCal(Now());
    pnlToday.Caption := 'Today: ' + DateToStr(Now());
end;

{---------------------------------------}
procedure TfrmView.DrawCal(d: TDateTime);
var
    cur: TDateTime;
    days: Word;
    r, c, i: integer;
begin
    // Draw this month in the calandar
    for r := 1 to gridCal.RowCount - 1 do begin
        for c := 0 to gridCal.ColCount - 1 do
            gridCal.Cells[c,r] := '';
    end;
    
    r := 1;
    _m := MonthOf(d);
    _y := YearOf(d);
    pnlCalHeader.Caption := FormatDateTime('mmmm, yyyy', d);
    days := DaysInMonth(d);
    for i := 1 to days do begin
        cur := EncodeDate(_y, _m, i);
        // DayOfTheWeek, 1 = Monday, 7 = Sunday
        c := DayOfTheWeek(cur);
        if (c = 7) then begin
            inc(r);
            c := 0;
        end;
        gridCal.Cells[c, r] := IntToStr(i);
    end;
    MsgList.WideLines.Clear();
end;

{---------------------------------------}
procedure TfrmView.gridCalSelectCell(Sender: TObject; ACol, ARow: Integer;
  var CanSelect: Boolean);
var
    d: Word;
    td: TDateTime;
begin
    d := SafeInt(gridCal.Cells[ACol, ARow]);

    CanSelect := (d in _days);
    if (CanSelect) then begin
        td := EncodeDate(_y, _m, d);
        if (td <> _last) then
            SelectDay(td);
    end;
end;

{---------------------------------------}
procedure TfrmView.gridCalDrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
var
    d: Word;
    txt: string;
    pw, ph, tw, th: integer;
begin
    txt := gridCal.Cells[ACol, ARow];
    d := SafeInt(txt);

    // Draw the cell..
    gridCal.Canvas.Brush.Style := bsSolid;
    if (gdFixed in State) then begin
        gridCal.Canvas.Brush.Color := clBtnFace;
        gridCal.Canvas.Font.Color := clBtnText;
    end
    else if (gdSelected in State) then begin
        gridCal.Canvas.Brush.Color := clHighlight;
        gridCal.Canvas.Font.Color := clHighlightText;
    end
    else begin
        gridCal.Canvas.Brush.Color := clWindow;
    end;

    // Draw the cell's BG
    gridCal.Canvas.FillRect(Rect);

    // If this day is bold, make it so..
    if (d in _days) then begin
        gridCal.Canvas.Font.Color := clWindowText;
        gridCal.Canvas.Font.Style := [fsBold];
    end
    else begin
        gridCal.Canvas.Font.Color := clGrayText;
        gridCal.Canvas.Font.Style := [];
    end;

    // center the text
    tw := gridCal.Canvas.TextWidth(txt);
    th := gridCal.Canvas.TextHeight(txt);
    pw := ((Rect.Right - Rect.Left) - tw) div 2;
    ph := ((Rect.Bottom - Rect.Top) - th) div 2;
    gridCal.Canvas.TextOut(Rect.Left + pw, Rect.Top + ph, txt);
end;

{---------------------------------------}
procedure TfrmView.btnNextMonthClick(Sender: TObject);
var
    i: integer;
    new: TDateTime;
    d: Word;
begin
    if (Sender = btnPrevMonth) then
        i := -1
    else
        i := +1;

    d := DayOf(_last);
    IncAMonth(_y, _m, d, i);
    new := EncodeDate(_y, _m, d);
    DrawCal(new);
    SelectMonth(new);
    _query();
end;

{---------------------------------------}
procedure TfrmView.cboJidChange(Sender: TObject);
begin
    //
end;

{---------------------------------------}
procedure TfrmView.FormDestroy(Sender: TObject);
begin
    if (_convs <> nil) then
        FreeAndNil(_convs);
end;

{---------------------------------------}
procedure TfrmView.lstConvData(Sender: TObject; Item: TListItem);
var
    idx: integer;
    c: TConversation;
    dtstr: Widestring;
begin
    //
    if ((_convs = nil) or (_start_idx = -1) or (_end_idx = -1)) then exit;

    idx := Item.Index + _start_idx;
    if (idx >= _convs.Count) then exit;

    c := TConversation(_convs[idx]);

    dtstr := TimeToStr(c.dt);
    Item.Caption := dtstr;
    Item.SubItems.Add(IntToStr(c.Count));
    Item.SubItems.Add(c.jid);
end;

{---------------------------------------}
procedure TfrmView._processSelectedConvs();
var
    i,r: integer;
    c: TConversation;
    tmp: TSQLiteTable;
    cmd, sql: string;
begin
    // Show this conversation
    MsgList.WideLines.Clear();
    if (lstConv.SelCount = 0) then exit;

    for i := 0 to lstConv.Items.Count - 1 do begin
        if (lstConv.Items[i].Selected) then begin
            c := TConversation(_convs[_start_idx + i]);
            cmd := 'SELECT * FROM jlogs WHERE jid="%s" AND thread="%s" AND date=%d ORDER BY time;';
            sql := Format(cmd, [c.jid, c.thread, Trunc(double(c.dt))]);
            tmp := db.GetTable(sql);
            for r := 0 to tmp.RowCount - 1 do begin
                DisplayMsg(tmp);
                tmp.Next();
            end;
        end;
    end;
end;

{---------------------------------------}
procedure TfrmView.lstConvSelectItem(Sender: TObject; Item: TListItem;
  Selected: Boolean);
begin
    _processSelectedConvs();
end;

{---------------------------------------}
procedure TfrmView.btnSearchClick(Sender: TObject);
var
    idx: integer;
    j: Widestring;
begin
    // perform the search for keywords
    idx := cboJid.ItemIndex;
    if (idx = 0) then begin
        j := '';
    end
    else begin
        j := cboJid.Text;
    end;

    if (j <> _jid) then begin
        _jid := j;
        if ((j <> '') and (cboJid.Items.IndexOf(j) = -1)) then begin
            cboJid.Items.Add(j);
            if (cboJid.Items.Count > 20) then
                cboJid.Items.Delete(1);
        end;
    end;

    _keywords.Delimiter := ' ';
    _keywords.DelimitedText := txtWords.Text;
    _query();
end;

{---------------------------------------}
procedure TfrmView.lstConvDataStateChange(Sender: TObject; StartIndex,
  EndIndex: Integer; OldState, NewState: TItemStates);
begin
    _processSelectedConvs();
end;

{---------------------------------------}
procedure TfrmView._query();
var
    minday, dd, i: integer;
    f, sql: string;
    w: boolean;
    tmp: TSQLiteTable;
    td: TDatetime;
    conv: TConversation;
begin
    // requery based on current settings
    w := false;
    f := '';
    dd := 0;

    sql := 'SELECT DISTINCT date FROM jlogs ';

    // if we are filtering a jid, do so..
    if (_jid <> '') then begin
        if (w) then f := f + ' AND ' else f := f + ' WHERE ';
        f := f + Format('jid="%s"', [_jid]);
        w := true;
    end;

    // if we have keywords, make it so..
    if (_keywords.Count > 0) then begin
        for i := 0 to _keywords.Count - 1 do begin
            if (w) then f := f + ' AND ' else f := f + ' WHERE ';
            f := f + Format('body like "%%%s%%"', [_keywords[i]]);
            w := true;
        end;
    end;
    
    // if we have a date filter, do so..
    if (_date_filter <> 2) then begin
        if (w) then f := f + ' AND ' else f := f + ' WHERE ';
        f := f + Format('date > %d and date < %d ', [_i1, _i2]);
    end;

    sql := sql + f;
    lblSQL.Caption := sql;
    tmp := db.GetTable(sql);
    _days := [];
    minday := 0;
    for i := 0 to tmp.RowCount - 1 do begin
        // make all of these days bold
        dd := StrToInt(tmp.Fields[0]);
        _days := _days + [DayOf(dd)];
        if (minday = 0) then minday := dd;
        tmp.Next();
    end;

    if (_convs <> nil) then begin
        FreeAndNil(_convs);
        lstConv.Items.Count := 0;
    end;
    tmp.Free();

    // get all the conversations
    // columns are
    // min_date, min_time, count, thread, jid
    sql := 'SELECT Min(date) as min_date, Min(time) as min_time, Count(body) as msg_count, thread, jid FROM jlogs';
    sql := sql + f;
    sql := sql + ' GROUP BY jid, date, thread ORDER BY min_date, min_time;';

    lblSQL.Caption := sql;
    tmp := db.GetTable(sql);

    _convs := TObjectList.Create();
    _convs.OwnsObjects := true;

    // 0 = min_date, 1 = min_time, 2 = msg_count, 3 = thread, 4 = jid]
    for i := 0 to tmp.RowCount - 1 do begin
        conv := TConversation.Create();
        if (_jid <> '') then
            conv.jid := _jid
        else
            conv.jid := tmp.Fields[4];
        conv.count := SafeInt(tmp.Fields[2]);
        conv.dt := SafeInt(tmp.Fields[0]) + StrToFloat(tmp.Fields[1]);
        conv.thread := tmp.Fields[3];
        _convs.Add(conv);
        tmp.Next();
    end;
    tmp.Free();

    _start_idx := -1;
    _end_idx := -1;
    _last := 0;

    DrawCal(_i1);
    MsgList.Widelines.Clear();

    // select the first day thats in this set
    if ((_date_filter = 0) and (dd > 0)) then begin
        td := minday;
        SelectDay(td);
    end
    else
        SelectAll();
end;

{---------------------------------------}
procedure TfrmView.cboDateFilterChange(Sender: TObject);
begin
    // select a date range..
    _date_filter := cboDateFilter.ItemIndex;
    _query();
end;

{---------------------------------------}
procedure TfrmView.btnDetailsClick(Sender: TObject);
begin
    if pnlSQL.Visible then begin
        pnlSQL.Visible := false;
        btnDetails.Caption := 'Show SQL';
    end
    else begin
        pnlSQL.Visible := true;
        btnDetails.Caption := 'Hide SQL';
    end;
end;

{---------------------------------------}
procedure TfrmView.cboJidSelect(Sender: TObject);
begin
    // Select this JID
    btnSearchClick(Sender);
end;

{---------------------------------------}
procedure TfrmView.lstConvDblClick(Sender: TObject);
var
    l: integer;
    c: TConversation;
begin
    // filter on this jid
    l := lstConv.ItemIndex;
    if ((l < 0) or (lstConv.Items.Count = 0)) then exit;

    c := TConversation(_convs[_start_idx + l]);
    if (c.jid <> _jid) then begin
        cboJid.Text := c.jid;
        btnSearchClick(Self);
    end;
end;

end.

