inherited frmPrefHotkeys: TfrmPrefHotkeys
  Left = 259
  Top = 156
  Caption = 'frmPrefHotkeys'
  ClientHeight = 342
  ClientWidth = 392
  OldCreateOrder = True
  OnDestroy = FormDestroy
  ExplicitWidth = 404
  ExplicitHeight = 354
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnlHeader: TTntPanel
    Width = 392
    ExplicitWidth = 392
    inherited lblHeader: TTntLabel
      Left = 6
      Width = 50
      Caption = 'Hotkeys'
      ExplicitLeft = 6
      ExplicitWidth = 50
    end
  end
  object pnlContainer: TExBrandPanel
    AlignWithMargins = True
    Left = 0
    Top = 29
    Width = 389
    Height = 216
    Margins.Left = 0
    Margins.Top = 6
    Margins.Bottom = 0
    Align = alTop
    AutoSize = True
    BevelOuter = bvNone
    ParentColor = True
    TabOrder = 1
    AutoHide = True
    object TntLabel1: TTntLabel
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 383
      Height = 13
      Align = alTop
      Caption = '&Pressing a hotkey will enter the associated message'
      FocusControl = lstHotkeys
      ExplicitWidth = 249
    end
    object lstHotkeys: TTntListView
      AlignWithMargins = True
      Left = 3
      Top = 22
      Width = 383
      Height = 167
      Align = alTop
      Columns = <
        item
          Caption = 'Hotkey'
        end
        item
          Caption = 'Message'
          Width = 333
        end>
      ReadOnly = True
      RowSelect = True
      SortType = stData
      TabOrder = 0
      ViewStyle = vsReport
      OnSelectItem = lstHotkeysSelectItem
    end
    object btnModifyHotkeys: TTntButton
      Left = 70
      Top = 195
      Width = 61
      Height = 21
      Caption = '&Edit...'
      Enabled = False
      TabOrder = 2
      OnClick = btnModifyHotkeysClick
    end
    object btnAddHotkeys: TTntButton
      Left = 3
      Top = 195
      Width = 61
      Height = 21
      Caption = '&Add...'
      TabOrder = 1
      OnClick = btnAddHotkeysClick
    end
    object btnRemoveHotkeys: TTntButton
      Left = 137
      Top = 195
      Width = 61
      Height = 21
      Caption = '&Remove'
      Enabled = False
      TabOrder = 3
      OnClick = btnRemoveHotkeysClick
    end
    object btnClearAll: TTntButton
      Left = 204
      Top = 195
      Width = 61
      Height = 21
      Caption = '&Clear All'
      TabOrder = 4
      OnClick = btnClearAllClick
    end
  end
end
