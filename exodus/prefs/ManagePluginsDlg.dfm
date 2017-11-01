inherited frmPrefPlugins: TfrmPrefPlugins
  Left = 232
  Top = 142
  BorderStyle = bsDialog
  Caption = 'Plug-ins'
  ClientHeight = 361
  ClientWidth = 420
  OldCreateOrder = True
  OnCreate = TntFormCreate
  ExplicitWidth = 426
  ExplicitHeight = 393
  PixelsPerInch = 96
  TextHeight = 13
  object Label6: TTntLabel
    Left = 2
    Top = 257
    Width = 200
    Height = 13
    Caption = 'Plug-in Directory (automatically scanned):'
  end
  object lblPluginScan: TTntLabel
    Left = 2
    Top = 308
    Width = 162
    Height = 13
    Cursor = crHandPoint
    Caption = 'Re-scan this directory for plug-ins'
    OnClick = lblPluginScanClick
  end
  object btnConfigPlugin: TTntButton
    Left = 3
    Top = 223
    Width = 85
    Height = 25
    Caption = 'Configure...'
    Enabled = False
    TabOrder = 1
    OnClick = btnConfigPluginClick
  end
  object txtPluginDir: TTntEdit
    Left = 2
    Top = 277
    Width = 321
    Height = 21
    TabOrder = 2
  end
  object btnBrowsePluginPath: TTntButton
    Left = 332
    Top = 278
    Width = 85
    Height = 23
    Caption = 'Browse...'
    TabOrder = 3
    OnClick = btnBrowsePluginPathClick
  end
  object lstPlugins: TTntListView
    AlignWithMargins = True
    Left = 3
    Top = 9
    Width = 414
    Height = 207
    Margins.Top = 9
    Align = alTop
    BevelWidth = 0
    Checkboxes = True
    Columns = <
      item
        Caption = 'Plug-in'
        Width = 119
      end
      item
        Caption = 'Description'
        Width = 180
      end
      item
        Caption = 'Filename'
        Width = 95
      end>
    TabOrder = 0
    ViewStyle = vsReport
    OnSelectItem = lstPluginsSelectItem
  end
  object btnCancel: TTntButton
    Left = 332
    Top = 329
    Width = 85
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 4
  end
  object btnOK: TTntButton
    Left = 241
    Top = 329
    Width = 84
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 5
    OnClick = btnOKClick
  end
end
