inherited frmPassword: TfrmPassword
  Left = 245
  Top = 196
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsDialog
  Caption = 'Password Dialog'
  ClientHeight = 184
  ClientWidth = 233
  DefaultMonitor = dmDesktop
  ParentFont = True
  OldCreateOrder = True
  Position = poScreenCenter
  OnCloseQuery = frmOnCloseQuery
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TTntLabel
    Left = 8
    Top = 9
    Width = 69
    Height = 13
    Caption = 'Old password:'
  end
  object Label2: TTntLabel
    Left = 8
    Top = 57
    Width = 74
    Height = 13
    Caption = 'New password:'
  end
  object Label3: TTntLabel
    Left = 8
    Top = 105
    Width = 113
    Height = 13
    Caption = 'Confirm new password:'
  end
  object txtOldPassword: TTntEdit
    Left = 8
    Top = 30
    Width = 217
    Height = 21
    PasswordChar = '*'
    TabOrder = 0
    OnChange = OnChangeText
  end
  inline frameButtons1: TframeButtons
    Left = 0
    Top = 151
    Width = 233
    Height = 33
    Align = alBottom
    Color = 13681583
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentColor = False
    ParentFont = False
    TabOrder = 3
    TabStop = True
    ExplicitTop = 151
    ExplicitWidth = 233
    ExplicitHeight = 33
    inherited Panel2: TPanel
      Width = 233
      Height = 33
      ExplicitWidth = 233
      ExplicitHeight = 33
      inherited Bevel1: TBevel
        Width = 233
        ExplicitWidth = 233
      end
      inherited Panel1: TPanel
        Left = 73
        Height = 28
        ExplicitLeft = 73
        ExplicitHeight = 28
      end
    end
  end
  object txtNewPassword: TTntEdit
    Left = 8
    Top = 75
    Width = 217
    Height = 21
    PasswordChar = '*'
    TabOrder = 1
    OnChange = OnChangeText
  end
  object txtConfirmPassword: TTntEdit
    Left = 8
    Top = 123
    Width = 217
    Height = 21
    PasswordChar = '*'
    TabOrder = 2
    OnChange = OnChangeText
  end
end
