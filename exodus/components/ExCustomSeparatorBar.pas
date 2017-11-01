unit ExCustomSeparatorBar;

interface

uses
  SysUtils,
  Classes,
  Controls,
  ExtCtrls,
  Graphics,
  Windows;

type
  TCustomSeparatorBarProps = class(TPersistent)
      private
        _Color1: TColor;
        _Color2: TColor;
        _horizontal: boolean;
      protected
      public
        procedure Assign(Source: TPersistent); override;
      published
        property Color1: TColor read _Color1 write _Color1;
        property Color2: TColor read _Color2 write _Color2;
        property horizontal: boolean read _horizontal write _horizontal;
  end;

  TExCustomSeparatorBar = class(TPaintBox)
  private
    { Private declarations }
    _props: TCustomSeparatorBarProps;
    procedure setProps(Value: TCustomSeparatorBarProps);
  protected
    { Protected declarations }
    procedure Paint(); override;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    { Published declarations }
    property CustomSeparatorBarProperites: TCustomSeparatorBarProps read _props write setProps;
  end;

procedure Register;

implementation

procedure TCustomSeparatorBarProps.Assign(Source: TPersistent);
begin
    if (Source is TCustomSeparatorBarProps) then
    begin
        _Color1 := TCustomSeparatorBarProps(Source).Color1;
        _Color2 := TCustomSeparatorBarProps(Source).Color2;
        _horizontal := TCustomSeparatorBarProps(Source).horizontal;
        inherited Assign(Source);
    end;
end;

constructor TExCustomSeparatorBar.Create(AOwner: TComponent);
begin
    inherited Create(AOwner);
    _props := TCustomSeparatorBarProps.Create;
end;

destructor TExCustomSeparatorBar.Destroy;
begin
    _props.Free();
    inherited Destroy;
end;

procedure TExCustomSeparatorBar.setProps(Value: TCustomSeparatorBarProps);
begin
    if (assigned(value)) then
    begin
        _props.Assign(Value);
    end;
end;

procedure TExCustomSeparatorBar.Paint();
var
    r: TRect;
begin
    inherited paint();

    if (_props.horizontal) then begin
        // top
        Canvas.Pen.Color := _props.Color1;
        Canvas.Brush.Color := _props.Color1;
        r.Top := 0;
        r.Left := 0;
        r.Bottom := Self.Height div 2;
        r.Right := Self.Width;
        Canvas.FillRect(r);

        // bottom
        Canvas.Pen.Color := _props.Color2;
        Canvas.Brush.Color := _props.Color2;
        r.Top := r.Bottom;
        r.Bottom := Height;
        Canvas.FillRect(r);
    end
    else begin
        // left
        Canvas.Pen.Color := _props.Color1;
        Canvas.Brush.Color := _props.Color1;
        r.Top := 0;
        r.Left := 0;
        r.Bottom := Self.Height;
        r.Right := Self.Width div 2;
        Canvas.FillRect(r);

        // right
        Canvas.Pen.Color := _props.Color2;
        Canvas.Brush.Color := _props.Color2;
        r.Left := r.Right;
        r.Right := Self.Width;
        Canvas.FillRect(r);
    end;
end;

procedure Register;
begin
  RegisterComponents('Exodus Components', [TExCustomSeparatorBar]);
end;

end.
