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
unit ExNumericEdit;

interface

uses
  Classes, ExtCtrls, TntStdCtrls, TntComCtrls, Controls, ComCtrls;

type

 TExUpDown = class (TTntUpDown)
 //Added an attribute to allow wrap for rolling the numbers.
 protected
    { Protected declarations }
    procedure CreateWindowHandle(const Params: TCreateParams); override;
 end;

  //Container for spin and edit controls.
  TExNumericEdit = class(TPanel)

  private
    { Private declarations }
     spnNum: TExUpDown;
     editNum: TTntEdit;
     _min: Integer;
     _max: Integer;
     _value: Integer;
     _onChange: TNotifyEvent;
  protected
    { Protected declarations }
    procedure CreateWindowHandle(const Params: TCreateParams); override;
    procedure SetEnabled(enabled: boolean); override;

    procedure editNumKeyPress(Sender: TObject; var Key: Char);
    procedure editNumExit(Sender: TObject);
    procedure spnNumClicked(Sender: TObject; Button: TUDBtnType);
    function IsValidChar(Key: Char): Boolean; virtual;
    function IsValid(): Boolean; virtual;

    procedure SetValue(value : Widestring);
    function  GetValue() : Widestring;
    procedure SetMax(max : Integer);
    procedure SetMin(min : Integer);

  private

    procedure InitializeControls();

  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;

    procedure SetFocus(); override;

  published
    { Published declarations }
    property Text: Widestring read GetValue write SetValue;
    property Min: Integer read _min write SetMin;
    property Max: Integer read _max write SetMax;
    property OnChange: TNotifyEvent read _onChange write _onChange;

  end;

procedure Register;

implementation

uses SysUtils, Windows, Dialogs, Forms, CommCtrl, StdCtrls, GnuGetText, Messages,
Math;
procedure Register;
begin
   RegisterComponents('Exodus Components', [TExNumericEdit]);
end;

procedure TExUpDown.CreateWindowHandle(const Params: TCreateParams);
var
 p: TCreateParams;
begin
  p := Params;
  p.Style := Params.Style or UDS_WRAP;
  inherited CreateWindowHandle(p);

end;


constructor TExNumericEdit.Create(AOwner: TComponent);
begin
    inherited Create(AOwner);

    Left := 0;
    Top := 0;
    TabStop := false;
    Caption := '';

    //Supress out bevel of the panel
    BevelOuter := bvNone;
    spnNum := TExUpDown.Create(Self);
    spnNum.Parent := Self;

    editNum := TTntEdit.Create(Self);
    editNum.Parent := Self;
    editNum.OnKeyPress := Self.editNumKeyPress;
    editNum.OnExit := Self.editNumExit;
    //Initialize range and value
    _min := 0;
    _max := 1000000;
    _value := _min;
    //Create association between spin and edit controls
    spnNum.Associate := editNum;
    _onChange := nil;
end;    {Create}

procedure TExNumericEdit.SetEnabled(enabled: boolean);
begin
    inherited;
    editNum.Enabled := enabled;
    spnNum.Enabled := enabled;
end;

procedure TExNumericEdit.SetFocus();
begin
    inherited;
    editNUm.SetFocus();
end;

procedure TExNumericEdit.InitializeControls();
const
 factor: Single = 1/7;
begin
 Height := Math.Max(spnNum.Height, editNum.Height);
 with editNum do
  begin
    Left := 0;
    Top := 0;
    Width := Self.Width - spnNum.Width;
    TabStop := true;
    TabOrder := 0;
    Text := IntToStr(_value);
    //Set all anchors for proper resizing at design
    Anchors :=  [akLeft, akRight, akTop, akBottom];
  end;  { TTntEdit }

  with spnNum do
  begin
    //Width := Trunc(Self.Width*factor);
    Left := editNum.Width;
    Top := 0;
    TabStop := false;
    Position := _value;
    Max := _max;
    Min := _min;
    //Only need 3 anchors for proper resizing
    Anchors :=  [akTop, akBottom, akRight];
    spnNum.OnClick := Self.spnNumClicked;


  end;  { TExUpDown }

end;

//We need to perfrom all subcomponents initialization here after window was
//created, but before it is displayed.
procedure TExNumericEdit.CreateWindowHandle(const Params: TCreateParams);
var
 p: TCreateParams;
begin
    Caption := '';

    InitializeControls();
    p := Params;
    p.Height := Height;
    p.Caption := PAnsiChar(Caption);
    inherited CreateWindowHandle(p);

end;  { CreateWindowHandle }


//Processes key press event for the edit control.
//If key is invalid, all futher processing is suppresses.
procedure TExNumericEdit.editNumKeyPress(Sender: TObject; var Key: Char);
begin
  if not IsValidChar(Key) then
  begin
    Key := #0;
  end;
  if Key <> #0 then inherited KeyPress(Key);
end;

//Determines if character is valid.
function TExNumericEdit.IsValidChar(Key: Char): Boolean;
begin
    if (Key in ['+', '-', '0'..'9']) or
    (Key = Char(VK_BACK)) or (Key = Char(VK_DELETE)) then
       Result := true
    else
       Result := false;
end;

procedure TExNumericEdit.editNumExit(Sender: TObject);
begin
   Self.IsValid();
   if (Assigned(OnChange)) then
     OnChange(Sender);
end;

//Let the form handle any "OnChange" events if required.
procedure TExNumericEdit.spnNumClicked(Sender: TObject; Button: TUDBtnType);
 begin
   if (Assigned(OnChange)) then
     OnChange(Sender);
 end;


//Checks if sequence of characters is valid number and if it is within the range
function TExNumericEdit.IsValid(): Boolean;
var
  numValue: Integer;
  errorMsg: Widestring;
  caption: Widestring;
  flags: Word;
begin
     Result := true;
    //Check if valid number
    if (TryStrToInt(editNum.Text, numValue)) then begin
      //If valid, check if within the range
      if (numValue < _min) then begin
         errorMsg := _('Value is less than minimum %d.');
         errorMsg := WideFormat(errorMsg, [_min]);
         _value :=  _min;
         Result := false;
      end
      else if (numValue > _max) then begin
          errorMsg := _('Value is more than maximum %d.');
          errorMsg := WideFormat(errorMsg, [_max]);
          _value := _max;
          Result := false;
      end;
    end
    else begin
       // Not a number
       errorMsg := _('Invalid number.');
      _value :=  _min;
       Result := false;
    end;

     //Display error and reset focus
      if (Result = false) then begin
        editNum.Text := IntToStr(_value);
        spnNum.Position := _value;
        caption := _('Error');
        flags := MB_ICONERROR or MB_OK;
        MessageBoxW(Application.Handle, PWideChar(errorMsg), PWideChar(caption), flags);
        try
            // try-except to catch the rare instance where control cannot be focused (throws exception)
            editNum.SetFocus;
        except
            // ignore that setfocus failed.
        end;
        Result := false;
      end
      else begin
        _value := numValue;
        editNum.Text := IntToStr(_value);
        spnNum.Position := _value;
      end;
end;

procedure TExNumericEdit.SetValue(value: Widestring);
begin
  //If valid number, set text on edit control.
  //If invalid number, will be properly rerset inside isValid function.
  if (TryStrToInt(value, _value) = false) then  begin
     _value := _min;
  end;
  editNum.Text := value;
  spnNum.Position := _value;
  //For run time mode or design mode validate the number.
  if (ComponentState * [csLoading] = []) then
    isValid();

end;

function TExNumericEdit.GetValue(): Widestring;
begin
   Result := IntToStr(spnNum.Position);
end;

procedure TExNumericEdit.SetMax(max: Integer);
begin
  //Reset max and check if the value is within the range
  _max := max;
  spnNum.Max := max;
  if (ComponentState * [csLoading] = []) then
      isValid();

end;

procedure TExNumericEdit.SetMin(min: Integer);
begin
  //Reset min and check if the value is within the range
  _min := min;
  spnNum.Min := min;
  if (ComponentState * [csLoading] = []) then
      isValid();

end;

end.
