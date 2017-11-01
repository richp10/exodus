inherited frmAdd: TfrmAdd
  Left = 252
  Top = 233
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'Add Contact'
  ClientHeight = 214
  ClientWidth = 251
  DefaultMonitor = dmDesktop
  Position = poMainFormCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TTntLabel
    Left = 8
    Top = 41
    Width = 56
    Height = 13
    Caption = 'Contact ID:'
  end
  object Label2: TTntLabel
    Left = 8
    Top = 73
    Width = 49
    Height = 13
    Caption = 'Nickname:'
  end
  object Label3: TTntLabel
    Left = 8
    Top = 102
    Width = 33
    Height = 13
    Caption = 'Group:'
  end
  object Label4: TTntLabel
    Left = 8
    Top = 9
    Width = 69
    Height = 13
    Caption = 'Contact Type:'
  end
  object lblGateway: TTntLabel
    Left = 8
    Top = 153
    Width = 82
    Height = 13
    Caption = 'Gateway Server:'
    Enabled = False
  end
  object txtJID: TTntEdit
    Left = 94
    Top = 38
    Width = 139
    Height = 21
    TabOrder = 0
    OnChange = txtJIDChange
    OnExit = txtJIDExit
  end
  object txtNickname: TTntEdit
    Left = 94
    Top = 70
    Width = 139
    Height = 21
    TabOrder = 1
    OnChange = txtNicknameChange
  end
  object cboGroup: TTntComboBox
    Left = 94
    Top = 101
    Width = 142
    Height = 21
    ItemHeight = 13
    Sorted = True
    TabOrder = 2
  end
  inline frameButtons1: TframeButtons
    Left = 0
    Top = 180
    Width = 251
    Height = 34
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
    ExplicitTop = 180
    ExplicitWidth = 251
    ExplicitHeight = 34
    inherited Panel2: TPanel
      Width = 251
      Height = 34
      ExplicitWidth = 251
      ExplicitHeight = 34
      inherited Bevel1: TBevel
        Width = 251
        ExplicitWidth = 251
      end
      inherited Panel1: TPanel
        Left = 91
        Height = 29
        ExplicitLeft = 91
        ExplicitHeight = 29
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
  object cboType: TTntComboBox
    Left = 94
    Top = 8
    Width = 142
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 4
    OnChange = cboTypeChange
  end
  object txtGateway: TTntEdit
    Left = 94
    Top = 150
    Width = 139
    Height = 21
    Enabled = False
    TabOrder = 5
    OnExit = txtJIDExit
  end
end
