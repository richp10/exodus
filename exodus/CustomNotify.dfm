inherited frmCustomNotify: TfrmCustomNotify
  Left = 240
  Top = 208
  BorderWidth = 4
  Caption = 'Custom Notification Options'
  ClientHeight = 265
  ClientWidth = 318
  DefaultMonitor = dmDesktop
  OldCreateOrder = False
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object lblDefault: TTntLabel
    Left = 16
    Top = 215
    Width = 146
    Height = 13
    Cursor = crHandPoint
    Caption = 'Reset to default preferences ...'
    OnClick = lblDefaultClick
  end
  object chkNotify: TTntCheckListBox
    Left = 16
    Top = 8
    Width = 257
    Height = 65
    ItemHeight = 13
    TabOrder = 0
    OnClick = chkNotifyClick
  end
  inline frameButtons1: TframeButtons
    Left = 0
    Top = 235
    Width = 318
    Height = 30
    Align = alBottom
    Color = 13681583
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentColor = False
    ParentFont = False
    TabOrder = 2
    TabStop = True
    ExplicitTop = 235
    ExplicitWidth = 318
    ExplicitHeight = 30
    inherited Panel2: TPanel
      Width = 318
      Height = 30
      ExplicitWidth = 318
      ExplicitHeight = 30
      inherited Bevel1: TBevel
        Width = 318
        Height = 1
        ExplicitTop = -1
        ExplicitWidth = 318
        ExplicitHeight = 1
      end
      inherited Panel1: TPanel
        Left = 158
        Top = 1
        Height = 29
        ExplicitLeft = 158
        ExplicitTop = 1
        ExplicitHeight = 29
      end
    end
  end
  object optNotify: TTntGroupBox
    Left = 16
    Top = 85
    Width = 257
    Height = 124
    Caption = 'Notify Options'
    TabOrder = 1
    object chkFlash: TTntCheckBox
      Left = 8
      Top = 48
      Width = 209
      Height = 17
      Caption = 'Flash Taskbar button, or highlight tab'
      TabOrder = 1
      OnClick = chkToastClick
    end
    object chkToast: TTntCheckBox
      Left = 8
      Top = 24
      Width = 153
      Height = 17
      Caption = 'Show a "Toast" popup'
      TabOrder = 0
      OnClick = chkToastClick
    end
    object chkTrayNotify: TTntCheckBox
      Left = 8
      Top = 71
      Width = 209
      Height = 17
      Caption = 'Flash tray icon'
      TabOrder = 2
      OnClick = chkToastClick
    end
    object chkFront: TTntCheckBox
      Left = 8
      Top = 94
      Width = 241
      Height = 17
      Caption = 'Bring window to front'
      TabOrder = 3
      OnClick = chkToastClick
    end
  end
end
