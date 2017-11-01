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
unit fResults;


interface

uses
    XMLTag, Unicode,
    Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
    Dialogs, ComCtrls, TntComCtrls, ExFrame;

type
  TframeResults = class(TExFrame)
    lstResults: TTntListView;
    procedure lstResultsData(Sender: TObject; Item: TListItem);
  private
    { Private declarations }
    _cols: TWidestringlist;
    _tags: TXMLTagList;
    _x: TXMLTag;

  public
    { Public declarations }
    procedure parse(x: TXMLTag);
  end;

procedure buildXDataResults(x: TXMLTag; o: TWinControl);

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
implementation
{$R *.dfm}

{---------------------------------------}
procedure buildXDataResults(x: TXMLTag; o: TWinControl);
var
    f: TframeResults;
begin
    f := TframeResults.Create(o);
    f.parent := o;
    f.parse(x);
    f.Visible := true;
    f.Align := alClient;
end;

{---------------------------------------}
procedure TframeResults.parse(x: TXMLTag);
var
    i: integer;
    tmps: Widestring;
    tags: TXMLTagList;
    r, f: TXMLTag;
    col: TTntListColumn;
begin
    _cols := nil;
    lstResults.Columns.Clear();
    r := x.GetFirstTag('reported');
    if (r <> nil) then begin
        // setup the columns.
        _cols := TWidestringlist.Create();

        tags := r.QueryTags('field');
        for i := 0 to tags.count - 1 do begin
            f := tags[i];
            _cols.Add(f.getAttribute('var'));
            col := lstResults.Columns.Add();
            tmps := f.getAttribute('label');
            if (tmps = '') then tmps := f.GetAttribute('var');
            col.Caption := tmps;
        end;
    end;

    // we're owner data.. so just setup the list.
    _x := x;
    _tags := x.QueryTags('item');
    lstResults.Items.Count := _tags.Count;
end;

{---------------------------------------}
procedure TframeResults.lstResultsData(Sender: TObject; Item: TListItem);
var
    idx: integer;
    xi: TXMLTag;
    i: integer;
    f: TXMLTag;
    tmps: Widestring;
begin
    // populate this item
    idx := Item.Index;
    if (idx >= _tags.Count) then exit;
    xi := _tags[idx];

    // get all of the columns from this tag.
    for i := 0 to _cols.count - 1 do begin
        f := xi.QueryXPTag('/item/field[@var="' + _cols[i] + '"]');
        if (f <> nil) then
            tmps := f.GetFirstTag('value').data
        else
            tmps := '';

        if (i = 0) then
            Item.Caption := tmps
        else
            Item.SubItems.Add(tmps);
    end;
end;

end.
