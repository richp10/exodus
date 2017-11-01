inherited frmModifyHotkeys: TfrmModifyHotkeys
  BorderStyle = bsDialog
  Caption = 'Modify Hotkey'
  ClientHeight = 99
  ClientWidth = 392
  ExplicitWidth = 398
  ExplicitHeight = 137
  PixelsPerInch = 120
  TextHeight = 16
  object TntLabel1: TTntLabel
    AlignWithMargins = True
    Left = 8
    Top = 11
    Width = 43
    Height = 16
    Caption = '&Hotkey:'
    FocusControl = cbhotkey
  end
  object TntLabel2: TTntLabel
    AlignWithMargins = True
    Left = 8
    Top = 41
    Width = 55
    Height = 16
    Caption = '&Message:'
    FocusControl = txtHotkeyMessage
  end
  object btnOK: TTntButton
    AlignWithMargins = True
    Left = 228
    Top = 68
    Width = 75
    Height = 23
    Caption = 'OK'
    Default = True
    Enabled = False
    ModalResult = 1
    TabOrder = 2
  end
  object btnCancel: TTntButton
    AlignWithMargins = True
    Left = 309
    Top = 68
    Width = 75
    Height = 23
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 3
  end
  object txtHotkeyMessage: TTntEdit
    AlignWithMargins = True
    Left = 74
    Top = 38
    Width = 310
    Height = 24
    MaxLength = 80
    TabOrder = 1
    OnChange = txtHotkeyMessageChange
  end
  object cbhotkey: TTntComboBox
    AlignWithMargins = True
    Left = 74
    Top = 8
    Width = 95
    Height = 24
    Style = csDropDownList
    ItemHeight = 16
    Sorted = True
    TabOrder = 0
  end
end
