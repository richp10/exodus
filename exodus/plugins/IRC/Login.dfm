object frmStartSession: TfrmStartSession
  Left = 248
  Top = 144
  Width = 298
  Height = 190
  Caption = 'Start IRC Session'
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
    Left = 9
    Top = 11
    Width = 55
    Height = 13
    Caption = 'IRC Server:'
  end
  object Label2: TLabel
    Left = 9
    Top = 35
    Width = 22
    Height = 13
    Caption = 'Port:'
  end
  object Label3: TLabel
    Left = 9
    Top = 59
    Width = 51
    Height = 13
    Caption = 'Nickname:'
  end
  object Label4: TLabel
    Left = 9
    Top = 83
    Width = 45
    Height = 13
    Caption = 'Alternate:'
  end
  object txtServer: TEdit
    Left = 80
    Top = 8
    Width = 185
    Height = 21
    TabOrder = 0
    Text = 'irc.freenode.net'
  end
  object txtPort: TEdit
    Left = 80
    Top = 32
    Width = 185
    Height = 21
    TabOrder = 1
    Text = '6667'
  end
  object txtNickname: TEdit
    Left = 80
    Top = 56
    Width = 185
    Height = 21
    TabOrder = 2
  end
  object txtAlt: TEdit
    Left = 80
    Top = 80
    Width = 185
    Height = 21
    TabOrder = 3
  end
  inline frameButtons1: TframeButtons
    Left = 0
    Top = 120
    Width = 290
    Height = 36
    Align = alBottom
    AutoScroll = False
    TabOrder = 4
    inherited Panel2: TPanel
      Width = 290
      inherited Bevel1: TBevel
        Width = 290
      end
      inherited Panel1: TPanel
        Left = 130
      end
    end
  end
end
