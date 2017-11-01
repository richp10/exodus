object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Select Certificate'
  ClientHeight = 253
  ClientWidth = 413
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  DesignSize = (
    413
    253)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 16
    Width = 184
    Height = 13
    Caption = 'Select the certificate you want to use.'
  end
  object Button1: TTntButton
    Left = 249
    Top = 220
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 1
    OnClick = Button1Click
  end
  object Button2: TTntButton
    Left = 330
    Top = 220
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 2
  end
  object StringGrid1: TStringGrid
    Left = 8
    Top = 56
    Width = 397
    Height = 158
    Anchors = [akLeft, akTop, akRight, akBottom]
    BevelKind = bkSoft
    BevelOuter = bvSpace
    FixedCols = 0
    RowCount = 2
    Options = [goFixedVertLine, goVertLine, goRangeSelect, goColSizing, goEditing, goRowSelect, goThumbTracking]
    TabOrder = 0
    ColWidths = (
      74
      78
      79
      73
      64)
    RowHeights = (
      24
      24)
  end
end
