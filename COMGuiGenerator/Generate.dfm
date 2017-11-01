object frmGen: TfrmGen
  Left = 239
  Top = 136
  Width = 528
  Height = 343
  Caption = 'Generate COM Interfaces'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  DesignSize = (
    520
    313)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 16
    Width = 72
    Height = 13
    Caption = 'Destination Dir:'
  end
  object Button1: TButton
    Left = 8
    Top = 40
    Width = 75
    Height = 25
    Caption = 'GO'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Edit1: TEdit
    Left = 88
    Top = 14
    Width = 265
    Height = 21
    TabOrder = 1
    Text = '..\Exodus\COMGuis'
  end
  object status: TMemo
    Left = 8
    Top = 72
    Width = 497
    Height = 225
    Anchors = [akLeft, akTop, akRight, akBottom]
    ScrollBars = ssVertical
    TabOrder = 2
  end
end
