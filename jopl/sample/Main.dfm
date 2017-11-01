object Form1: TForm1
  Left = 246
  Top = 143
  Width = 433
  Height = 372
  Caption = 'Form1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 425
    Height = 113
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    object Label1: TLabel
      Left = 8
      Top = 11
      Width = 31
      Height = 13
      Caption = 'Server'
    end
    object Label2: TLabel
      Left = 8
      Top = 35
      Width = 48
      Height = 13
      Caption = 'Username'
    end
    object Label3: TLabel
      Left = 8
      Top = 59
      Width = 46
      Height = 13
      Caption = 'Password'
    end
    object Label4: TLabel
      Left = 8
      Top = 83
      Width = 46
      Height = 13
      Caption = 'Resource'
    end
    object txtServer: TEdit
      Left = 96
      Top = 8
      Width = 121
      Height = 21
      TabOrder = 0
    end
    object txtUsername: TEdit
      Left = 96
      Top = 32
      Width = 121
      Height = 21
      TabOrder = 1
    end
    object txtPassword: TEdit
      Left = 96
      Top = 56
      Width = 121
      Height = 21
      PasswordChar = '*'
      TabOrder = 2
    end
    object txtResource: TEdit
      Left = 96
      Top = 80
      Width = 121
      Height = 21
      TabOrder = 3
    end
    object Button1: TButton
      Left = 232
      Top = 8
      Width = 75
      Height = 25
      Caption = 'Connect'
      TabOrder = 4
      OnClick = Button1Click
    end
  end
  object Memo1: TMemo
    Left = 145
    Top = 113
    Width = 280
    Height = 225
    Align = alClient
    Lines.Strings = (
      'Memo1')
    ScrollBars = ssVertical
    TabOrder = 1
  end
  object ListBox1: TListBox
    Left = 0
    Top = 113
    Width = 145
    Height = 225
    Align = alLeft
    ItemHeight = 13
    TabOrder = 2
  end
end
