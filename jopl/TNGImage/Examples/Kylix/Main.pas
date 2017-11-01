unit Main;

interface

uses
  SysUtils, Types, Classes, Variants, QGraphics, QControls, QForms,
  QDialogs, QExtCtrls, QMenus, QTypes,
  NGImages, NGConst;

type
  TMainForm = class(TForm)
    OpenDialog1: TOpenDialog;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    Open1: TMenuItem;
    Exit1: TMenuItem;
    Panel1: TPanel;
    Image1: TImage;
    procedure Image1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Image1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Image1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Image1DblClick(Sender: TObject);
    procedure Open1Click(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
  private
    { Private declarations }
    FHasMouse: boolean;
    procedure RefreshBKGD(Sender: TObject);
    function MouseOnImage(NG: TNGImage; var IHX, IHY: integer) : boolean;
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

{$R *.xfm}

function TMainForm.MouseOnImage(NG: TNGImage; var IHX, IHY: integer) : boolean;
var IHL, IHR, IHT, IHB: Integer;
begin
  IHL:= (Image1.Width  - NG.Width ) div 2;
  IHT:= (Image1.Height - NG.Height) div 2;
  IHR := IHL + NG.Width;
  IHB := IHT + NG.Height;
  if (IHX >= IHL) and (IHX < IHR) and (IHY >= IHT) and (IHY < IHB) then
  begin
    IHX:= IHX - IHL;
    IHY:= IHY - IHT;
    Result:= True;
  end
  else
  begin
    Result:= False;
  end;
end;

procedure TMainForm.Image1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var NG : TNGImage;
begin
  NG := TNGImage(Image1.Picture.Graphic);
  if assigned(NG) and (NG.StatusDynamic) and (MouseOnImage(NG, X, Y)) then
    NG.MNG_TrapEvent(MNG_EVENT_MOUSEDOWN, X, Y);
end;

procedure TMainForm.Image1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var NG : TNGImage;
begin
  NG := TNGImage(Image1.Picture.Graphic);
  if assigned(NG) and (NG.StatusDynamic) then
  begin
    if MouseOnImage(NG, X, Y) then
    begin
      if FHasMouse then
      begin
        NG.MNG_TrapEvent(MNG_EVENT_MOUSEMOVE, X, Y);
      end
      else
      begin
        NG.MNG_TrapEvent(MNG_EVENT_MOUSEENTER, X, Y);
        FHasMouse:= True;
      end;
    end
    else
    begin
      if FHasMouse then
      begin
        NG.MNG_TrapEvent(MNG_EVENT_MOUSEEXIT, X, Y);
        FHasMouse:= False;
      end;
    end;
  end;
end;

procedure TMainForm.Image1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var NG : TNGImage;
begin
  NG := TNGImage(Image1.Picture.Graphic);
  if assigned(NG) and (NG.StatusDynamic) and (MouseOnImage(NG, X, Y)) then
    NG.MNG_TrapEvent(MNG_EVENT_MOUSEUP, X, Y);
end;

procedure TMainForm.Image1DblClick(Sender: TObject);
begin
  Open1Click(self);
end;

procedure TMainForm.RefreshBKGD(Sender: TObject);
begin
  Image1.Invalidate;
end;

procedure TMainForm.Open1Click(Sender: TObject);
var NG : TNGImage;
begin
  FHasMouse:= False;
  if OpenDialog1.Execute then
  begin
    NG := TNGImage.Create;
    try
      NG.LoadFromFile (OpenDialog1.FileName);
      Image1.Picture.Assign(NG);
      if NG.AlphaDepth > 0 then
        TNGImage(Image1.Picture.Graphic).OnRefresh := RefreshBKGD;
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
