inherited frmGrpRemove: TfrmGrpRemove
  Left = 280
  Top = 173
  Caption = 'Remove Contacts'
  ClientHeight = 172
  ClientWidth = 319
  DefaultMonitor = dmDesktop
  OldCreateOrder = False
  Position = poMainFormCenter
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  inline frameButtons1: TframeButtons
    Left = 0
    Top = 138
    Width = 319
    Height = 34
    Align = alBottom
    TabOrder = 0
    TabStop = True
    ExplicitTop = 138
    ExplicitWidth = 319
    ExplicitHeight = 34
    inherited Panel2: TPanel
      Width = 319
      Height = 34
      ExplicitWidth = 319
      ExplicitHeight = 34
      inherited Bevel1: TBevel
        Width = 319
        ExplicitWidth = 306
      end
      inherited Panel1: TPanel
        Left = 159
        Height = 29
        ExplicitLeft = 159
        ExplicitHeight = 29
        inherited btnOK: TTntButton
          OnClick = frameButtons1btnOKClick
        end
        inherited btnCancel: TTntButton
          OnClick = frameButtons1btnCancelClick
        end
      end
    end
  end
  object optMove: TTntRadioButton
    Left = 8
    Top = 8
    Width = 249
    Height = 17
    Caption = 'Move contacts to another group:'
    Checked = True
    TabOrder = 1
    TabStop = True
    OnClick = optClick
  end
  object cboNewGroup: TTntComboBox
    Left = 24
    Top = 32
    Width = 145
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    Sorted = True
    TabOrder = 2
  end
  object optNuke: TTntRadioButton
    Left = 8
    Top = 64
    Width = 209
    Height = 17
    Caption = 'Remove all contacts in this group:'
    TabOrder = 3
    OnClick = optClick
  end
  object chkUnsub: TTntCheckBox
    Left = 24
    Top = 89
    Width = 233
    Height = 17
    Caption = 'Remove these contacts from my contact list.'
    Checked = True
    State = cbChecked
    TabOrder = 4
  end
  object chkUnsubed: TTntCheckBox
    Left = 24
    Top = 112
    Width = 287
    Height = 17
    Caption = 'Force the contacts to remove me from their contact list'
    Checked = True
    State = cbChecked
    TabOrder = 5
  end
end
