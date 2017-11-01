unit Main;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Menus, ExtCtrls;

type
  TMainForm = class(TForm)
    Image1: TImage;
    OpenDialog1: TOpenDialog;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    Open1: TMenuItem;
    Exit1: TMenuItem;
    N1: TMenuItem;
    SaveDialog1: TSaveDialog;
    mnuSave: TMenuItem;
    procedure Image1DblClick(Sender: TObject);
    procedure Open1Click(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure mnuSaveClick(Sender: TObject);

  private
  public

  end;

var
  MainForm: TMainForm;

implementation
uses
    NGImages, NGConst;

{$R *.DFM}

procedure TMainForm.mnuSaveClick(Sender: TObject);
var
    NG : TNGImage;
begin
    NG := TNGImage(Image1.Picture.Graphic);
    if assigned(NG) and SaveDialog1.Execute then
    begin
        NG.saveToFile(SaveDialog1.FileName);
    end;
end;

procedure TMainForm.Image1DblClick(Sender: TObject);
begin
  Open1Click(nil);
end;

procedure TMainForm.Open1Click(Sender: TObject);
var NG : TNGImage;
begin
  FHasMouse := false;
  if OpenDialog1.Execute then
  begin
    NG := TNGImage.Create;
    if NG <> nil then
    try
      NG.BGColor := ColorToRGB(clBtnFace);
      NG.LoadFromFile(OpenDialog1.FileName);
      Image1.Picture.Assign(NG);
    finally
      NG.Free;
    end;
  end;
end;

procedure TMainForm.Exit1Click(Sender: TObject);
begin
  Close;
end;

end.
