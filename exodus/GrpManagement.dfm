inherited frmGrpManagement: TfrmGrpManagement
  Left = 255
  Top = 165
  BorderStyle = bsDialog
  Caption = 'Group Management'
  ClientHeight = 211
  ClientWidth = 361
  DefaultMonitor = dmDesktop
  Position = poMainFormCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  ExplicitWidth = 367
  ExplicitHeight = 243
  PixelsPerInch = 96
  TextHeight = 13
  object lblTitle: TTntLabel
    AlignWithMargins = True
    Left = 3
    Top = 49
    Width = 355
    Height = 13
    Align = alTop
    Visible = False
    ExplicitWidth = 3
  end
  inline frameButtons1: TframeButtons
    Left = 0
    Top = 175
    Width = 361
    Height = 36
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
    ExplicitTop = 175
    ExplicitWidth = 361
    ExplicitHeight = 36
    inherited Panel2: TPanel
      Width = 361
      Height = 36
      ExplicitWidth = 361
      ExplicitHeight = 36
      inherited Bevel1: TBevel
        Width = 361
        ExplicitWidth = 359
      end
      inherited Panel1: TPanel
        Left = 201
        Height = 31
        ExplicitLeft = 201
        ExplicitHeight = 31
        inherited btnOK: TTntButton
          Enabled = False
          OnClick = frameButtons1btnOKClick
        end
        inherited btnCancel: TTntButton
          OnClick = frameButtons1btnCancelClick
        end
      end
    end
  end
  object optMove: TTntRadioButton
    AlignWithMargins = True
    Left = 3
    Top = 26
    Width = 355
    Height = 17
    Align = alTop
    Caption = 'Move the selected items to the following group:'
    Checked = True
    TabOrder = 1
    TabStop = True
    OnClick = optChangeGroupOpClick
  end
  object optCopy: TTntRadioButton
    AlignWithMargins = True
    Left = 3
    Top = 3
    Width = 355
    Height = 17
    Align = alTop
    Caption = 'Copy the selected items to the following group:'
    TabOrder = 2
    OnClick = optChangeGroupOpClick
  end
  object lstGroups: TTntListBox
    AlignWithMargins = True
    Left = 3
    Top = 68
    Width = 355
    Height = 104
    Align = alClient
    ExtendedSelect = False
    ItemHeight = 13
    Sorted = True
    TabOrder = 3
    OnClick = lstGroupsClick
    OnDblClick = lstGroupsDblClick
  end
end
