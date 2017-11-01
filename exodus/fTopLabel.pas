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
unit fTopLabel;

interface

uses
    XMLTag, Unicode,  
    Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
    StdCtrls, ExtCtrls, TntStdCtrls, ExFrame;

type
  TframeTopLabel = class(TExFrame)
    Panel1: TPanel;
    lbl: TTntLabel;
    txtData: TTntEdit;
    procedure FrameResize(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    field_name: string;
  end;
  
procedure RenderTopFields(ParentControl: TWinControl; fields: TXMLTagList;
    var key: Widestring);
procedure PopulateTopFields(ParentControl: TWinControl; container: TXMLTag);

function getTopFieldsUsername(ParentControl: TWinControl): widestring;
function getTopFieldsPassword(ParentControl: TWinControl): widestring;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
implementation

{$R *.dfm}
uses
    ExUtils;

{---------------------------------------}
procedure RenderTopFields(ParentControl: TWinControl; fields: TXMLTagList;
    var key: Widestring);
var
    cur_field: Widestring;
    ti, tt, i: integer;
    cur_tag: TXMLTag;
    ff, cur_frame: TframeTopLabel;
begin
    ti := 0;
    tt := 0;
    ff := nil;
    for i := 0 to fields.Count -1 do begin
        cur_tag := fields[i];
        if (cur_tag.Name = 'instructions') then
          // do nothing
        else if (cur_tag.Namespace <> '') then
          // ignore stuff in other namesapces
        else if (cur_tag.Name = 'key') then begin
          key := cur_tag.Data;
        end
        else begin
            cur_field := cur_tag.Name;
             if (ParentControl.FindChildControl('frame_'+ cur_field) <> nil) then
                 continue;

            cur_frame := TframeTopLabel.Create(ParentControl);
            with cur_frame do begin
                Parent := ParentControl;
                Top := tt;
                Visible := true;
                field_name := cur_field;
                lbl.Caption := getDisplayField(cur_field);
                Name := 'frame_' + field_name;
                TabOrder := ti;
                if (cur_field = 'password') then
                    txtData.PasswordChar := '*';
                inc(ti);
            end;
            AssignUnicodeFont(cur_frame.Font, 8);
            tt := tt + cur_frame.height + 1;
            cur_frame.Align := alTop;

            if (ff = nil) then
              ff := cur_frame;
        end;
    end;
end;

{---------------------------------------}
procedure PopulateTopFields(ParentControl: TWinControl; container: TXMLTag);
var
    i: integer;
begin
    // go thru all the frames and add tags for each field
    for i := 0 to ParentControl.ControlCount - 1 do begin
        if (ParentControl.Controls[i] is TframeTopLabel) then begin
            with TframeTopLabel(ParentControl.Controls[i]) do begin
                if (txtData.Text <> '') then
                    container.AddBasicTag(field_name, txtData.Text);
            end;
        end;
    end;
end;

{---------------------------------------}
function getTopFieldsUsername(ParentControl: TWinControl): widestring;
var
    i: integer;
begin
    Result := '';
    for i := 0 to ParentControl.ControlCount - 1 do begin
        if (ParentControl.Controls[i] is TframeTopLabel) then begin
            with TframeTopLabel(ParentControl.Controls[i]) do begin
                if (field_name = 'username') then begin
                    Result := txtData.Text;
                    exit;
                end;
            end;
        end;
    end;
end;

{---------------------------------------}
function getTopFieldsPassword(ParentControl: TWinControl): widestring;
var
    i: integer;
begin
    Result := '';
    for i := 0 to ParentControl.ControlCount - 1 do begin
        if (ParentControl.Controls[i] is TframeTopLabel) then begin
            with TframeTopLabel(ParentControl.Controls[i]) do begin
                if (field_name = 'password') then begin
                    Result := txtData.Text;
                    exit;
                end;
            end;
        end;
    end;
end;


{---------------------------------------}
procedure TframeTopLabel.FrameResize(Sender: TObject);
begin
    // resize the text box..
    txtData.Width := Self.ClientWidth - 7;
end;

end.
