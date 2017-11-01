inherited frmPrefPresence: TfrmPrefPresence
  Left = 367
  Top = 167
  Margins.Left = 0
  Caption = 'd'
  ClientHeight = 426
  ClientWidth = 421
  OldCreateOrder = True
  OnDestroy = FormDestroy
  ExplicitWidth = 433
  ExplicitHeight = 438
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnlHeader: TTntPanel
    Width = 421
    ExplicitWidth = 421
    inherited lblHeader: TTntLabel
      Left = 6
      Width = 54
      Caption = 'Presence'
      ExplicitLeft = 5
      ExplicitWidth = 54
    end
  end
  object ExBrandPanel1: TExBrandPanel
    AlignWithMargins = True
    Left = 0
    Top = 26
    Width = 418
    Height = 57
    Margins.Left = 0
    Margins.Bottom = 0
    Align = alTop
    AutoSize = True
    BevelOuter = bvNone
    ParentColor = True
    TabOrder = 1
    AutoHide = False
    object chkClientCaps: TTntCheckBox
      AlignWithMargins = True
      Left = 0
      Top = 0
      Width = 415
      Height = 16
      Margins.Left = 0
      Margins.Top = 0
      Align = alTop
      Caption = 'S&end client capabilities in presence'
      Checked = True
      State = cbChecked
      TabOrder = 0
    end
    object chkRoomJoins: TTntCheckBox
      AlignWithMargins = True
      Left = 0
      Top = 19
      Width = 415
      Height = 16
      Margins.Left = 0
      Margins.Top = 0
      Align = alTop
      Caption = 'Show enter and leave messages in conference room &windows'
      Checked = True
      State = cbChecked
      TabOrder = 1
    end
    object chkPresenceSync: TTntCheckBox
      AlignWithMargins = True
      Left = 0
      Top = 38
      Width = 415
      Height = 16
      Margins.Left = 0
      Margins.Top = 0
      Align = alTop
      Caption = 'Synchronize presence across multiple instances'
      Checked = True
      State = cbChecked
      TabOrder = 2
    end
  end
  object ExGroupBox1: TExGroupBox
    AlignWithMargins = True
    Left = 0
    Top = 86
    Width = 418
    Height = 66
    Margins.Left = 0
    Align = alTop
    AutoSize = True
    BevelOuter = bvNone
    Caption = 'Presence tracking in one-to-one chat windows'
    ParentColor = True
    TabOrder = 2
    AutoHide = True
    object rbAllPres: TTntRadioButton
      AlignWithMargins = True
      Left = 3
      Top = 18
      Width = 412
      Height = 13
      Margins.Top = 0
      Align = alTop
      Caption = 'Trac&k all presence changes'
      TabOrder = 1
    end
    object rbLastPres: TTntRadioButton
      AlignWithMargins = True
      Left = 3
      Top = 34
      Width = 412
      Height = 13
      Margins.Top = 0
      Align = alTop
      Caption = 'Show only &last presence change'
      TabOrder = 2
    end
    object rbNoPres: TTntRadioButton
      AlignWithMargins = True
      Left = 3
      Top = 50
      Width = 412
      Height = 13
      Margins.Top = 0
      Align = alTop
      Caption = 'Do &not show any presence changes'
      TabOrder = 3
    end
  end
  object ExGroupBox2: TExGroupBox
    AlignWithMargins = True
    Left = 0
    Top = 158
    Width = 418
    Height = 223
    Margins.Left = 0
    Margins.Bottom = 0
    Align = alTop
    AutoSize = True
    BevelOuter = bvNone
    Caption = 'Custom presence entries'
    ParentColor = True
    TabOrder = 3
    AutoHide = True
    object lstCustomPres: TTntListBox
      AlignWithMargins = True
      Left = 0
      Top = 16
      Width = 289
      Height = 91
      Margins.Left = 0
      Margins.Bottom = 0
      ItemHeight = 13
      TabOrder = 1
      OnClick = lstCustomPresClick
    end
    object btnCustomPresAdd: TTntButton
      Left = 295
      Top = 16
      Width = 66
      Height = 19
      Caption = '&Add'
      TabOrder = 2
      OnClick = btnCustomPresAddClick
    end
    object btnCustomPresRemove: TTntButton
      Left = 295
      Top = 40
      Width = 66
      Height = 19
      Caption = '&Remove'
      TabOrder = 3
      OnClick = btnCustomPresRemoveClick
    end
    object btnCustomPresClear: TTntButton
      Left = 295
      Top = 64
      Width = 66
      Height = 19
      Caption = '&Clear All'
      TabOrder = 4
      OnClick = btnCustomPresClearClick
    end
    object btnDefaults: TTntButton
      Left = 295
      Top = 88
      Width = 66
      Height = 19
      Caption = '&Defaults'
      TabOrder = 5
      OnClick = btnDefaultsClick
    end
    object pnlProperties: TExBrandPanel
      AlignWithMargins = True
      Left = 5
      Top = 113
      Width = 282
      Height = 107
      Margins.Left = 6
      AutoSize = True
      BevelOuter = bvNone
      ParentColor = True
      TabOrder = 6
      AutoHide = False
      object Label11: TTntLabel
        Left = 0
        Top = 2
        Width = 31
        Height = 13
        Margins.Left = 6
        Caption = '&Name:'
        FocusControl = txtCPTitle
        Transparent = False
      end
      object Label12: TTntLabel
        Left = 0
        Top = 25
        Width = 35
        Height = 13
        Margins.Left = 6
        Caption = '&Status:'
        FocusControl = txtCPStatus
        Transparent = False
      end
      object Label13: TTntLabel
        Left = 0
        Top = 47
        Width = 28
        Height = 13
        Margins.Left = 6
        Caption = '&Type:'
        FocusControl = cboCPType
        Transparent = False
      end
      object Label14: TTntLabel
        Left = 0
        Top = 73
        Width = 38
        Height = 13
        Margins.Left = 6
        Caption = '&Priority:'
        FocusControl = txtCPPriority
        Transparent = False
      end
      object lblHotkey: TTntLabel
        Left = 0
        Top = 92
        Width = 39
        Height = 13
        Margins.Left = 6
        Caption = '&HotKey:'
        FocusControl = txtCPHotkey
        Transparent = False
      end
      object txtCPTitle: TTntEdit
        Left = 72
        Top = 0
        Width = 208
        Height = 21
        TabOrder = 0
        OnChange = txtCPTitleChange
      end
      object txtCPStatus: TTntEdit
        Left = 72
        Top = 23
        Width = 208
        Height = 21
        TabOrder = 1
        OnChange = txtCPTitleChange
      end
      object cboCPType: TTntComboBox
        Left = 72
        Top = 45
        Width = 210
        Height = 21
        Style = csDropDownList
        ItemHeight = 13
        TabOrder = 2
        OnChange = txtCPTitleChange
        Items.Strings = (
          'Free to Chat'
          'Available'
          'Away'
          'Extended Away'
          'Do Not Disturb')
      end
      object txtCPPriority: TExNumericEdit
        Left = 72
        Top = 68
        Width = 68
        Height = 21
        Hint = 'Priority of -1 uses current priority.'
        BevelOuter = bvNone
        ParentColor = True
        ParentShowHint = False
        ShowHint = True
        TabOrder = 3
        TabStop = True
        Text = '0'
        Min = -128
        Max = 127
        OnChange = txtCPTitleChange
        DesignSize = (
          68
          21)
      end
      object txtCPHotkey: THotKey
        Left = 72
        Top = 89
        Width = 90
        Height = 18
        HotKey = 32833
        TabOrder = 4
        OnChange = txtCPTitleChange
      end
    end
  end
end
