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
unit RTFEditor;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, RichEdit2, ToolWin, ExtCtrls, ImgList{$IFDEF VER120}, ImgList{$ENDIF};

type
  TRichEdit98Editor = class(TForm)
    ToolBar: TToolBar;
    BoldBtn: TToolButton;
    ItalicBtn: TToolButton;
    UnderlineBtn: TToolButton;
    ToolButton10: TToolButton;
    ImageList: TImageList;
    ToolButton1: TToolButton;
    LeftBtn: TToolButton;
    CenterBtn: TToolButton;
    ToolButton4: TToolButton;
    RightBtn: TToolButton;
    BulletBtn: TToolButton;
    SizeList: TComboBox;
    Panel1: TPanel;
    OkButton: TButton;
    CancelButton: TButton;
    JustifyBtn: TToolButton;
    FontList: TComboBox;
    Editor: TRichEdit98;
    procedure FormCreate(Sender: TObject);
    procedure BoldBtnClick(Sender: TObject);
    procedure ItalicBtnClick(Sender: TObject);
    procedure UnderlineBtnClick(Sender: TObject);
    procedure FontListChange(Sender: TObject);
    procedure SizeListChange(Sender: TObject);
    procedure SizeListDropDown(Sender: TObject);
    procedure SizeListKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure LeftBtnClick(Sender: TObject);
    procedure CenterBtnClick(Sender: TObject);
    procedure RightBtnClick(Sender: TObject);
    procedure JustifyBtnClick(Sender: TObject);
    procedure EditorSelectionChange(Sender: TObject);
    procedure FontListDrawItem(Control: TWinControl; Index: Integer;
      R: TRect; State: TOwnerDrawState);
    procedure BulletBtnClick(Sender: TObject);
  private
    { Private declarations }
    SizeDropped: Boolean;
  public
    { Public declarations }
  end;

var
  RichEdit98Editor: TRichEdit98Editor;

implementation

uses
  CommCtrl;

{$R *.DFM}
{$R RTFEditor.RES}

function EnumFontFams(var elfe: TENUMLOGFONTEX; var ntme: TNEWTEXTMETRICEXA;
    FontType : Integer; List: TStrings): Integer;
stdcall;
var
  Temp: String;
begin
  Temp := elfe.elfLogFont.lfFaceName;
  if (List.Count = 0) or (List[List.Count-1]<>Temp) then
    List.AddObject(Temp, Pointer(Ord(FontType=TRUETYPE_FONTTYPE)+1));
  Result:= 1;
end;

procedure TRichEdit98Editor.FormCreate(Sender: TObject);
var
  DC: HDC;
  LF: TLogFont;
  S: TStringList;
  Bmp: TBitmap;
begin
  Bmp:= TBitmap.Create;
  Bmp.Handle:= LoadBitmap(HInstance, 'BUTTONS');
  ImageList.AddMasked(Bmp, clFuchsia);
  Bmp.Free;
  S:= TStringList.Create;
  DC:= GetDC(0);
  LF.lfFaceName[0]:= #0;
  LF.lfCharSet:= DEFAULT_CHARSET;
  EnumFontFamiliesEx(DC, LF, @EnumFontFams, Integer(S), 0);
  ReleaseDC(0, DC);
  S.Sort;
  FontList.Items.Assign(S);
  S.Free;
  EditorSelectionChange(Self);
end;

procedure TRichEdit98Editor.BoldBtnClick(Sender: TObject);
begin
  Editor.SelAttributes.Bold:= BoldBtn.Down;
end;

procedure TRichEdit98Editor.ItalicBtnClick(Sender: TObject);
begin
  Editor.SelAttributes.Italic:= ItalicBtn.Down;
end;

procedure TRichEdit98Editor.UnderlineBtnClick(Sender: TObject);
begin
  Editor.SelAttributes.UnderlineType:= TUnderlineType(UnderlineBtn.Down);
end;

procedure TRichEdit98Editor.FontListChange(Sender: TObject);
begin
  Editor.SelAttributes.Name:= FontList.Items[FontList.ItemIndex];
  ActiveControl:= Editor;
end;

procedure TRichEdit98Editor.SizeListChange(Sender: TObject);
begin
  if SizeDropped then
    begin
      Editor.SelAttributes.Size:= StrToIntDef(SizeList.Text, Editor.SelAttributes.Size);
      ActiveControl:= Editor;
      SizeDropped:= False;
    end;
end;

procedure TRichEdit98Editor.SizeListDropDown(Sender: TObject);
begin
  SizeDropped:= True;
end;

procedure TRichEdit98Editor.SizeListKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key=vk_Return then
    begin
      Editor.SelAttributes.Size:= StrToIntDef(SizeList.Text, Editor.SelAttributes.Size);
      ActiveControl:= Editor;
    end;
end;

procedure TRichEdit98Editor.LeftBtnClick(Sender: TObject);
begin
  Editor.Paragraph.Alignment:= taLeft;
end;

procedure TRichEdit98Editor.CenterBtnClick(Sender: TObject);
begin
  Editor.Paragraph.Alignment:= taCenter;
end;

procedure TRichEdit98Editor.RightBtnClick(Sender: TObject);
begin
  Editor.Paragraph.Alignment:= taRight;
end;

procedure TRichEdit98Editor.JustifyBtnClick(Sender: TObject);
begin
  Editor.Paragraph.Alignment:= taJustify;
end;

procedure TRichEdit98Editor.EditorSelectionChange(Sender: TObject);
begin
  with Editor.SelAttributes do
    begin
      FontList.ItemIndex:= FontList.Items.IndexOf(Editor.SelAttributes.Name);
      SizeList.Text:= IntToStr(Size);
      BoldBtn.Down:= Bold;
      ItalicBtn.Down:= Italic;
      UnderlineBtn.Down:= UnderlineType<>ultNone;
    end;
  with Editor.Paragraph do
    begin
      case Alignment of
      taLeft:
        LeftBtn.Down:= True;
      taRight:
        RightBtn.Down:= True;
      taCenter:
        CenterBtn.Down:= True;
      taJustify:
        JustifyBtn.Down:= True;
      end;
      case Numbering of
      nsNone:
        BulletBtn.Down:= False
      else
        BulletBtn.Down:= True;
      end;
    end;
end;

procedure TRichEdit98Editor.FontListDrawItem(Control: TWinControl;
  Index: Integer; R: TRect; State: TOwnerDrawState);
var
  Icon: TIcon;
begin
  Icon:= TIcon.Create;
  ImageList.GetIcon(10-Integer(FontList.Items.Objects[Index]), Icon);
  with FontList.Canvas do
    begin
      FillRect(R);
      TextOut(R.Left+20, R.Top+1, FontList.Items[Index]);
      DrawIconEx(Handle, R.Left+2, R.Top+2, Icon.Handle, 16, 16, 0, 0, DI_NORMAL)
    end;
  Icon.Free;
end;

procedure TRichEdit98Editor.BulletBtnClick(Sender: TObject);
begin
  Editor.Paragraph.Numbering:= TNumberingStyle98(BulletBtn.Down);
end;

end.
      
