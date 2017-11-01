object frmConfig: TfrmConfig
  Left = 235
  Top = 139
  Width = 387
  Height = 148
  BorderWidth = 4
  Caption = 'Jabber Stats Configuration'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 115
    Height = 13
    Caption = 'Location of statistics file:'
  end
  object txtFilename: TEdit
    Left = 16
    Top = 24
    Width = 265
    Height = 21
    TabOrder = 0
  end
  inline frameButtons1: TframeButtons
    Left = 0
    Top = 81
    Width = 371
    Height = 30
    Align = alBottom
    AutoScroll = False
    TabOrder = 1
    inherited Bevel1: TBevel
      Width = 371
    end
    inherited Panel1: TPanel
      Left = 211
    end
  end
  object btnBrowse: TButton
    Left = 288
    Top = 22
    Width = 75
    Height = 25
    Caption = 'Browse'
    TabOrder = 2
  end
  object OpenDialog1: TOpenDialog
    DefaultExt = 'txt'
    Filter = 'Text Files|*.txt|All Files|*.*'
    Left = 16
    Top = 56
  end
end
