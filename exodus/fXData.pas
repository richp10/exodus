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
unit fXData;


interface

uses
    Unicode, XMLTag,
    Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
    Dialogs, Grids, TntGrids, ExtCtrls, ExFrame;

type
  TframeXData = class(TExFrame)
    Panel1: TPanel;
    ScrollBox1: TScrollBox;
    procedure FrameResize(Sender: TObject);
  private
    { Private declarations }
    _w: integer;
    _rows: TList;
    _ns: Widestring;
    _thread: Widestring;
    procedure buildXData(x: TXMLTag);
  public
    { Public declarations }
    procedure Clear();
    procedure Render(tag: TXMLTag);
    function submit(): TXMLTag;
    function cancel(): TXMLTag;
    function getUsername(): Widestring;
    function getPassword(): Widestring;
    property Rows:  TList read _rows;
  end;

implementation
{$R *.dfm}
uses
    ExUtils, GnuGetText, JabberConst, XMLUtils, Math, xdata;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
procedure TframeXData.Render(tag: TXMLTag);
begin
    // Render the xdata fields
    AssignUnicodeFont(Self.Font, XDATA_FONT_SIZE);
    AssignUnicodeFont(ScrollBox1.Font, XDATA_FONT_SIZE);
    _rows := TList.Create();

    // force our widths to be correct at render time
    Panel1.Width := Self.ClientWidth;
    ScrollBox1.Width := Panel1.Width - (2 * Panel1.BorderWidth);
    FrameResize(Self);

    // render the form
    buildXData(tag);
end;

{---------------------------------------}
procedure TframeXData.Clear();
begin
    if (_rows <> nil) then begin
        ClearListObjects(_rows);
        FreeAndNil(_rows);
    end;
    _w := 0;
    _ns := '';
    _thread := '';
end;

{---------------------------------------}
procedure TframeXData.buildXData(x: TXMLTag);
var
    tpe: Widestring;
    fields: TXMLTagList;
    ins: TXMLTag;
    t, i, rh: integer;
    ro: TXDataRow;
    warning : TXMLTag;
begin
    tpe := x.GetAttribute('type');
    fields := x.QueryTags('field');
    ins := x.GetFirstTag('instructions');

    // make sure we're starting fresh
    t := 0;
    assert((_rows.Count = 0));

    // Create a warning.
    //TODO: make this brandable...
    warning := TXMLTag.Create('warning', 'This form was sent by a potentially untrusted source. Please insure that you trust this source before submitting data');
    ro := TXDataRow.Create(ScrollBox1, warning);
    rh := ro.Draw(t, 0, _w);
    _rows.Add(ro);
    t := t + rh;

    // check for an instructions tag
    if (ins <> nil) then begin
        ro := TXDataRow.Create(ScrollBox1, ins);
        rh := ro.Draw(t, 0, _w);
        _rows.Add(ro);
        t := t + rh;
    end;

    // generate _rows
    for i := 0 to fields.Count - 1 do begin
        ro := TXDataRow.Create(ScrollBox1, fields[i]);
        rh := ro.Draw(t, 0, _w);
        _rows.Add(ro);
        t := t + rh;
    end;

    fields.Free();
end;


{---------------------------------------}
function TframeXData.submit(): TXMLTag;
var
    i: integer;
    x,f: TXMLTag;
    ro: TXDataRow;
begin
    // Return the filled out xdata form and cleanup.
    x := TXMLTag.Create('x');
    x.setAttribute('xmlns', XMLNS_XDATA);

    for i := 0 to _rows.Count - 1 do begin
        ro := TXDataRow(_rows[i]);
        f := ro.GetXML();
        if (not ro.valid) then
            raise EXDataValidationError.Create(_('Empty required fields'))
        else if (f <> nil) then
            x.AddTag(f);
    end;

    Result := x;
end;

{---------------------------------------}
function TframeXData.getUsername(): Widestring;
var
    i: integer;
    ro: TXDataRow;
begin
    Result := '';
    for i := 0 to _rows.Count - 1 do begin
        ro := TXDataRow(_rows[i]);
        if (ro.v = 'username') then begin
            Result := ro.d;
            exit;
        end;
    end;
end;

{---------------------------------------}
function TframeXData.getPassword(): Widestring;
var
    i: integer;
    ro: TXDataRow;
begin
    Result := '';
    for i := 0 to _rows.Count - 1 do begin
        ro := TXDataRow(_rows[i]);
        if (ro.v = 'password') then begin
            Result := ro.d;
            exit;
        end;
    end;
end;

{---------------------------------------}
function TframeXData.cancel(): TXMLTag;
begin
    // cancel the form
    Clear();
    Result := TXMLTag.Create('x');
    Result.setAttribute('xmlns', XMLNS_XDATA);
    Result.setAttribute('type', 'cancel');
end;

{---------------------------------------}
procedure TframeXData.FrameResize(Sender: TObject);
var
    t, rh, i, new, w: integer;
    ro: TXDataRow;
begin
    inherited;

    { SLK:  Added this null check because sometimes we fall
            into here before this form is rendered, although
            I'm not sure exactly how or why. }
    if (_rows = nil) then
        exit;
        
    // re-render fields, etc.
    w := ScrollBox1.ClientWidth - 20;
    w := w - BTN_W;         // allow for col #3
    w := w - (3 * H_WS);    // allow for some horiz whitespace
    new := w div 2;

    // only do this for large updates
    if (abs(new - _w) < 10) then exit;
    _w := new;

    // make sure we're at the top
    if (ScrollBox1.VertScrollBar.Position > 0) then
        ScrollBox1.ScrollBy(0, (-ScrollBox1.VertScrollBar.Range));


    t := 0;
    for i := 0 to _rows.Count - 1 do begin
        ro := TXDataRow(_rows[i]);
        rh := ro.Draw(t, 0, _w);
        t := t + rh;
    end;
    ScrollBox1.Invalidate();


end;

end.
