inherited frmCustomPres: TfrmCustomPres
  Left = 254
  Top = 169
  BorderStyle = bsDialog
  Caption = 'Custom Presence'
  ClientHeight = 261
  ClientWidth = 313
  DefaultMonitor = dmDesktop
  Position = poMainFormCenter
  OnClose = FormClose
  OnCreate = FormCreate
  ExplicitWidth = 319
  ExplicitHeight = 293
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TTntLabel
    Left = 8
    Top = 11
    Width = 75
    Height = 13
    Caption = 'Presence Type:'
  end
  object Label2: TTntLabel
    Left = 8
    Top = 43
    Width = 35
    Height = 13
    Caption = 'Status:'
  end
  object Label3: TTntLabel
    Left = 8
    Top = 75
    Width = 34
    Height = 13
    Caption = 'Priority'
  end
  inline frameButtons1: TframeButtons
    Left = 0
    Top = 227
    Width = 313
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
    TabOrder = 5
    TabStop = True
    ExplicitTop = 227
    ExplicitWidth = 313
    ExplicitHeight = 34
    inherited Panel2: TPanel
      Width = 313
      Height = 34
      ExplicitWidth = 313
      ExplicitHeight = 34
      inherited Bevel1: TBevel
        Width = 313
        ExplicitWidth = 313
      end
      inherited Panel1: TPanel
        Left = 153
        Height = 29
        ExplicitLeft = 153
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
  object cboType: TTntComboBox
    Left = 96
    Top = 8
    Width = 201
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 0
    Items.Strings = (
      'Chat'
      'Available'
      'Away'
      'Ext. Away'
      'Do Not Disturb')
  end
  object txtStatus: TTntEdit
    Left = 96
    Top = 40
    Width = 201
    Height = 21
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
  end
  object txtPriority: TTntEdit
    Left = 96
    Top = 72
    Width = 33
    Height = 21
    TabOrder = 2
    Text = '0'
  end
  object chkSave: TTntCheckBox
    Left = 8
    Top = 104
    Width = 241
    Height = 17
    Caption = 'Save this presence to my preferences.'
    TabOrder = 3
    OnClick = chkSaveClick
  end
  object boxSave: TGroupBox
    Left = 8
    Top = 128
    Width = 289
    Height = 81
    TabOrder = 4
    object lblTitle: TTntLabel
      Left = 8
      Top = 18
      Width = 24
      Height = 13
      Caption = 'Title:'
      Enabled = False
    end
    object lblHotkey: TTntLabel
      Left = 8
      Top = 50
      Width = 39
      Height = 13
      Caption = 'HotKey:'
      Enabled = False
    end
    object txtTitle: TTntEdit
      Left = 80
      Top = 15
      Width = 193
      Height = 21
      Enabled = False
      TabOrder = 0
      OnChange = txtTitleChange
    end
    object txtHotkey: THotKey
      Left = 80
      Top = 48
      Width = 193
      Height = 19
      Enabled = False
      HotKey = 32833
      TabOrder = 1
      OnChange = txtHotkeyChange
    end
  end
end
