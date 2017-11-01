object frmHtmlPrefs: TfrmHtmlPrefs
  Left = 249
  Top = 164
  BorderStyle = bsDialog
  Caption = 'HTML Logging Options'
  ClientHeight = 160
  ClientWidth = 357
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object TntLabel1: TTntLabel
    Left = 8
    Top = 8
    Width = 149
    Height = 13
    Caption = 'Directory to store HTML logs in:'
  end
  object txtLogPath: TTntEdit
    Left = 18
    Top = 24
    Width = 247
    Height = 21
    TabOrder = 0
  end
  object btnLogBrowse: TTntButton
    Left = 275
    Top = 22
    Width = 75
    Height = 25
    Caption = 'Browse'
    TabOrder = 1
    OnClick = btnLogBrowseClick
  end
  object chkLogRooms: TTntCheckBox
    Left = 10
    Top = 74
    Width = 287
    Height = 17
    Caption = 'Log conference rooms'
    TabOrder = 2
    Visible = False
  end
  object btnLogClearAll: TTntButton
    Left = 12
    Top = 129
    Width = 102
    Height = 25
    Caption = 'Clear All Logs'
    TabOrder = 3
    OnClick = btnLogClearAllClick
  end
  object chkLogRoster: TTntCheckBox
    Left = 10
    Top = 52
    Width = 287
    Height = 17
    Caption = 'Only log messages from people in my contact list'
    TabOrder = 4
  end
  object TntButton1: TTntButton
    Left = 194
    Top = 128
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 5
  end
  object TntButton2: TTntButton
    Left = 272
    Top = 128
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 6
  end
end
