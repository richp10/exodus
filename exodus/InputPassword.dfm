inherited frmInputPass: TfrmInputPass
  Left = 234
  Top = 143
  ActiveControl = txtPassword
  BorderWidth = 3
  Caption = 'Password'
  ClientHeight = 91
  ClientWidth = 267
  DefaultMonitor = dmDesktop
  OldCreateOrder = False
  Position = poMainFormCenter
  OnClose = FormClose
  OnCreate = FormCreate
  DesignSize = (
    267
    91)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TTntLabel
    Left = 0
    Top = 0
    Width = 76
    Height = 13
    Caption = 'Enter password:'
    Layout = tlCenter
  end
  inline frameButtons1: TframeButtons
    Left = 0
    Top = 59
    Width = 267
    Height = 32
    Align = alBottom
    Color = 13681583
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentColor = False
    ParentFont = False
    TabOrder = 0
    TabStop = True
    ExplicitTop = 59
    ExplicitWidth = 267
    ExplicitHeight = 32
    inherited Panel2: TPanel
      Width = 267
      Height = 32
      ExplicitWidth = 267
      ExplicitHeight = 32
      inherited Bevel1: TBevel
        Width = 267
        ExplicitLeft = -3
        ExplicitTop = -3
        ExplicitWidth = 267
      end
      inherited Panel1: TPanel
        Left = 107
        Height = 27
        ExplicitLeft = 107
        ExplicitHeight = 27
        inherited btnOK: TTntButton
          Enabled = False
        end
      end
    end
  end
  object txtPassword: TTntEdit
    Left = 12
    Top = 29
    Width = 246
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    PasswordChar = '*'
    TabOrder = 1
    OnChange = txtPasswordOnChange
  end
end
