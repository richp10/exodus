inherited frmSimpleDisplay: TfrmSimpleDisplay
  Caption = 'Simple Message'
  ClientHeight = 219
  ClientWidth = 357
  ExplicitWidth = 365
  ExplicitHeight = 247
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnlDock: TTntPanel
    Width = 357
    TabOrder = 1
    ExplicitWidth = 357
    inherited pnlDockTopContainer: TTntPanel
      Width = 357
      ExplicitWidth = 357
      inherited tbDockBar: TToolBar
        Left = 308
        ExplicitLeft = 308
      end
      inherited pnlDockTop: TTntPanel
        Width = 305
        ExplicitWidth = 305
      end
    end
    inherited pnlDockControlSite: TTntPanel
      Width = 349
      ExplicitWidth = 349
    end
  end
  object pnlMsgDisplay: TTntPanel
    Left = 0
    Top = 33
    Width = 357
    Height = 186
    Align = alClient
    BevelOuter = bvNone
    BorderWidth = 4
    ParentColor = True
    TabOrder = 0
  end
  object mnuSimplePopup: TTntPopupMenu
    Left = 8
    Top = 32
    object mnuCopy: TTntMenuItem
      Caption = 'Copy'
      OnClick = mnuClick
    end
    object mnuCopyAll: TTntMenuItem
      Caption = 'Copy All'
      OnClick = mnuClick
    end
    object mnuClear: TTntMenuItem
      Caption = 'Clear'
      OnClick = mnuClick
    end
  end
end
