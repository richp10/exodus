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
unit Emoticons;


interface

uses
    BaseChat,
    Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
    Dialogs, ComCtrls, ToolWin, Buttons, TntButtons, ExForm;

type
  TfrmEmoticons = class(TExForm)
    SpeedButton1: TSpeedButton;
    procedure ToolButton1Click(Sender: TObject);
    procedure FormDeactivate(Sender: TObject);
    procedure ToolBar1Click(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    ChatWindow: TfrmBaseChat;
    msn: boolean;
    imgIndex: integer;

    procedure Reset();
  end;

var
  frmEmoticons: TfrmEmoticons;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
implementation

{$R *.dfm}
uses
    Math, Emote, GnuGetText, Jabber1;

{---------------------------------------}
procedure TfrmEmoticons.ToolButton1Click(Sender: TObject);
var
    i: integer;
    e: TEmoticon;
begin
    // a button was clicked.
    if (Sender is TSpeedButton) then begin
        i := TSpeedButton(Sender).Tag;
        e := EmoticonList.Emoticons[i];
        ChatWindow.SetEmoticon(e);
        Self.Hide;
    end
    else
        Self.Hide;
end;

{---------------------------------------}
procedure TfrmEmoticons.FormDeactivate(Sender: TObject);
begin
    if Self.Visible then
        Self.Hide();
end;

{---------------------------------------}
procedure TfrmEmoticons.ToolBar1Click(Sender: TObject);
begin
    Self.Hide;
end;

{---------------------------------------}
procedure TfrmEmoticons.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
    case key of
    VK_ESCAPE: Self.Hide
    end;
end;

{---------------------------------------}
procedure TfrmEmoticons.FormCreate(Sender: TObject);
begin
    TranslateComponent(Self);
end;

{---------------------------------------}
procedure TfrmEmoticons.Reset();
var
    row, col, cols: integer;
    rt, c, w, h, i: integer;
    bmp: TBitmap;
    btn: TSpeedButton;
begin
    // Clear the existing stuff out.
    for i := Self.ControlCount - 1 downto 0 do
        Self.Controls[i].Free();

    // Scan the whole list looking for the biggest thing, w/in reason
    if (EmoticonList.ImageCount = 0) then exit;
    
    w := 0;
    h := 0;
    c := EmoticonList.ImageCount - 1;
    for i := 0 to c do begin
        bmp := EmoticonList.Bitmaps[i];
        w := max(w, bmp.Width);
        h := max(h, bmp.Height);
    end;

    // Give us some xtra room
    w := w + 2;
    h := h + 2;

    // try to make the thing somewhat square..
    rt := Trunc(sqrt(c)) + 1;
    cols := rt;
    row := 0;
    col := 0;
    for i := 0 to c do begin
        btn := TSpeedButton.Create(Self);
        btn.Parent := Self;
        btn.Name := 'btnEmoticon' + IntToStr(i);
        btn.Top := (row * h);
        btn.Left := (col * w);
        btn.Width := w;
        btn.Height := h;
        btn.Spacing := 1;
        btn.Glyph := EmoticonList.Bitmaps[i];
        btn.Visible := true;
        btn.Flat := true;
        btn.Tag := i;
        btn.OnClick := Self.ToolButton1Click;
        inc(col);
        if (col = cols) then begin
            inc(row);
            col := 0;
        end;
    end;

    // Resize the whole form
    Self.Width := (cols * w) + 5;
    Self.Height := ((row + 1) * h) + 5;
end;


end.
