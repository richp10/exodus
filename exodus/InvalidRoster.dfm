inherited frmInvalidRoster: TfrmInvalidRoster
  Left = 223
  Top = 127
  Caption = 'Invalid Contact List Items'
  ClientHeight = 292
  ClientWidth = 386
  ExplicitWidth = 394
  ExplicitHeight = 325
  PixelsPerInch = 120
  TextHeight = 16
  inherited pnlDock: TTntPanel
    Width = 386
    TabOrder = 2
    ExplicitWidth = 386
    inherited pnlDockTopContainer: TTntPanel
      Width = 386
      ExplicitWidth = 386
      inherited tbDockBar: TToolBar
        Left = 336
        ExplicitLeft = 336
      end
      inherited pnlDockTop: TTntPanel
        Width = 332
        ExplicitWidth = 332
      end
    end
    inherited pnlDockControlSite: TTntPanel
      Width = 386
      ExplicitWidth = 386
    end
  end
  inline frameButtons1: TframeButtons
    Left = 0
    Top = 252
    Width = 386
    Height = 40
    Align = alBottom
    Color = 13681583
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -17
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentColor = False
    ParentFont = False
    TabOrder = 0
    TabStop = True
    ExplicitTop = 252
    ExplicitWidth = 386
    ExplicitHeight = 40
    inherited Panel2: TPanel
      Width = 386
      Height = 40
      ExplicitTop = 6
      ExplicitWidth = 386
      ExplicitHeight = 40
      inherited Bevel1: TBevel
        Width = 386
        Height = 6
        ExplicitWidth = 386
        ExplicitHeight = 6
      end
      inherited Panel1: TPanel
        Left = 190
        Top = 6
        Width = 196
        Height = 34
        ExplicitLeft = 190
        ExplicitTop = 6
        ExplicitWidth = 196
        ExplicitHeight = 34
        inherited btnOK: TTntButton
          Left = 5
          Width = 92
          Height = 31
          Caption = 'Remove'
          Default = False
          OnClick = frameButtons1btnOKClick
          ExplicitLeft = 5
          ExplicitWidth = 92
          ExplicitHeight = 31
        end
        inherited btnCancel: TTntButton
          Left = 101
          Width = 92
          Height = 31
          Caption = 'Close'
          Default = True
          OnClick = frameButtons1btnCancelClick
          ExplicitLeft = 101
          ExplicitWidth = 92
          ExplicitHeight = 31
        end
      end
    end
  end
  object ListView1: TTntListView
    Left = 0
    Top = 97
    Width = 386
    Height = 155
    Align = alClient
    Checkboxes = True
    Columns = <
      item
        Caption = 'Contact ID'
        Width = 123
      end
      item
        Caption = 'Item'
        Width = 98
      end
      item
        Caption = 'Pres. Error'
        Width = 246
      end>
    PopupMenu = popItems
    TabOrder = 1
    ViewStyle = vsReport
  end
  object popItems: TTntPopupMenu
    Left = 24
    Top = 40
    object oggleCheckboxes1: TTntMenuItem
      Caption = 'Toggle Checkboxes'
      OnClick = oggleCheckboxes1Click
    end
  end
end
