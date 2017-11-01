inherited frmPrefSystem: TfrmPrefSystem
  Left = 259
  Top = 156
  ActiveControl = chkAutoStart
  Caption = 'frmPrefSystem'
  ClientHeight = 548
  OldCreateOrder = True
  ExplicitWidth = 394
  ExplicitHeight = 560
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnlHeader: TTntPanel
    Font.Style = [fsBold]
    TabOrder = 1
    inherited lblHeader: TTntLabel
      Left = 6
      Width = 45
      Caption = 'System'
      ExplicitLeft = 5
      ExplicitWidth = 45
    end
  end
  object gbParentGroup: TExBrandPanel
    AlignWithMargins = True
    Left = 0
    Top = 26
    Width = 305
    Height = 522
    Margins.Left = 0
    Margins.Right = 0
    Margins.Bottom = 0
    Align = alLeft
    BevelOuter = bvNone
    ParentColor = True
    TabOrder = 0
    AutoHide = True
    object ExGroupBox2: TExGroupBox
      AlignWithMargins = True
      Left = 0
      Top = 3
      Width = 305
      Height = 37
      Margins.Left = 0
      Margins.Right = 0
      Margins.Bottom = 0
      Align = alTop
      AutoSize = True
      BevelOuter = bvNone
      Caption = 'When I start my computer'
      ParentColor = True
      TabOrder = 0
      AutoHide = True
      object chkAutoStart: TTntCheckBox
        AlignWithMargins = True
        Left = 3
        Top = 18
        Width = 302
        Height = 19
        Margins.Top = 0
        Margins.Right = 0
        Margins.Bottom = 0
        Align = alTop
        Caption = '&Start Exodus'
        TabOrder = 0
      end
    end
    object gbOnStart: TExGroupBox
      AlignWithMargins = True
      Left = 0
      Top = 46
      Width = 305
      Height = 85
      Margins.Left = 0
      Margins.Top = 6
      Margins.Right = 0
      Margins.Bottom = 4
      Align = alTop
      AutoSize = True
      BevelOuter = bvNone
      Caption = 'When I start Exodus'
      ParentColor = True
      TabOrder = 1
      AutoHide = True
      object chkAutoLogin: TTntCheckBox
        AlignWithMargins = True
        Left = 3
        Top = 18
        Width = 302
        Height = 16
        Margins.Top = 0
        Margins.Right = 0
        Margins.Bottom = 0
        Align = alTop
        Caption = '&Automatically login with the last active profile'
        TabOrder = 0
      end
      object chkStartMin: TTntCheckBox
        AlignWithMargins = True
        Left = 3
        Top = 34
        Width = 302
        Height = 18
        Margins.Top = 0
        Margins.Right = 0
        Margins.Bottom = 0
        Align = alTop
        Caption = 'Start contact list &minimized to the System Tray'
        TabOrder = 1
      end
      object chkRestoreDesktop: TTntCheckBox
        AlignWithMargins = True
        Left = 3
        Top = 52
        Width = 302
        Height = 16
        Margins.Top = 0
        Margins.Right = 0
        Margins.Bottom = 0
        Align = alTop
        Caption = '&Restore desktop to previous state'
        TabOrder = 2
      end
      object chkDebug: TTntCheckBox
        AlignWithMargins = True
        Left = 3
        Top = 68
        Width = 302
        Height = 17
        Margins.Top = 0
        Margins.Right = 0
        Margins.Bottom = 0
        Align = alTop
        Caption = 'Show the console &window'
        TabOrder = 3
      end
    end
    object ExGroupBox4: TExGroupBox
      AlignWithMargins = True
      Left = 0
      Top = 141
      Width = 305
      Height = 108
      Margins.Left = 0
      Margins.Top = 6
      Margins.Right = 0
      Margins.Bottom = 6
      Align = alTop
      AutoSize = True
      BevelOuter = bvNone
      Caption = 'Other system preferences'
      ParentColor = True
      TabOrder = 2
      AutoHide = True
      object chkSaveWindowState: TTntCheckBox
        AlignWithMargins = True
        Left = 3
        Top = 18
        Width = 302
        Height = 16
        Margins.Top = 0
        Margins.Right = 0
        Margins.Bottom = 0
        Align = alTop
        Caption = 'Save window &positions'
        TabOrder = 0
      end
      object pnlDockPref: TTntPanel
        AlignWithMargins = True
        Left = 0
        Top = 37
        Width = 302
        Height = 43
        Margins.Left = 0
        Align = alTop
        AutoSize = True
        BevelOuter = bvNone
        ParentColor = True
        TabOrder = 1
        object lblDockPref: TTntLabel
          Left = 3
          Top = 0
          Width = 87
          Height = 13
          Caption = 'Show all windows:'
          FocusControl = rbDocked
        end
        object rbDocked: TTntRadioButton
          Left = 13
          Top = 14
          Width = 232
          Height = 13
          Caption = '&Docked'
          TabOrder = 0
          TabStop = True
        end
        object rbUndocked: TTntRadioButton
          Left = 13
          Top = 29
          Width = 232
          Height = 14
          Caption = '&Undocked'
          TabOrder = 1
          TabStop = True
        end
      end
      object ExBrandPanel1: TExBrandPanel
        AlignWithMargins = True
        Left = 0
        Top = 86
        Width = 302
        Height = 19
        Margins.Left = 0
        Align = alTop
        AutoSize = True
        BevelOuter = bvNone
        ParentColor = True
        TabOrder = 3
        AutoHide = True
        object btnPlugins: TTntButton
          Left = 3
          Top = 0
          Width = 109
          Height = 19
          Caption = 'Manage Plu&g-ins...'
          TabOrder = 0
          OnClick = btnPluginsClick
        end
      end
    end
    object ExGroupBox3: TExGroupBox
      AlignWithMargins = True
      Left = 0
      Top = 353
      Width = 305
      Height = 164
      Margins.Left = 0
      Margins.Top = 6
      Margins.Right = 0
      Margins.Bottom = 6
      Align = alTop
      AutoSize = True
      BevelOuter = bvNone
      Caption = 'Advanced system preferences'
      ParentColor = True
      TabOrder = 4
      AutoHide = True
      ExplicitTop = 348
      object chkToolbox: TTntCheckBox
        AlignWithMargins = True
        Left = 3
        Top = 51
        Width = 302
        Height = 15
        Margins.Top = 0
        Margins.Right = 0
        Margins.Bottom = 0
        Align = alTop
        Caption = 'Small titlebar for main window'
        TabOrder = 2
      end
      object chkCloseMin: TTntCheckBox
        AlignWithMargins = True
        Left = 3
        Top = 18
        Width = 302
        Height = 16
        Margins.Top = 0
        Margins.Right = 0
        Margins.Bottom = 0
        Align = alTop
        Caption = 'Close button minimizes to the System Tray'
        TabOrder = 0
      end
      object chkSingleInstance: TTntCheckBox
        AlignWithMargins = True
        Left = 3
        Top = 34
        Width = 302
        Height = 17
        Margins.Top = 0
        Margins.Right = 0
        Margins.Bottom = 0
        Align = alTop
        Caption = 'Only allow a single, running instance'
        TabOrder = 1
      end
      object chkOnTop: TTntCheckBox
        AlignWithMargins = True
        Left = 3
        Top = 66
        Width = 302
        Height = 17
        Margins.Top = 0
        Margins.Right = 0
        Margins.Bottom = 0
        Align = alTop
        Caption = 'Always on top'
        TabOrder = 3
        Visible = False
      end
      object pnlAutoUpdates: TTntPanel
        AlignWithMargins = True
        Left = 0
        Top = 86
        Width = 302
        Height = 21
        Margins.Left = 0
        Align = alTop
        AutoSize = True
        BevelOuter = bvNone
        ParentColor = True
        TabOrder = 4
        object chkAutoUpdate: TTntCheckBox
          Left = 2
          Top = 4
          Width = 182
          Height = 16
          Caption = 'Check for updates automatically'
          TabOrder = 0
        end
        object btnUpdateCheck: TTntButton
          Left = 187
          Top = 0
          Width = 73
          Height = 21
          Caption = 'Check Now'
          TabOrder = 1
          OnClick = btnUpdateCheckClick
          OnMouseUp = btnUpdateCheckMouseUp
        end
      end
      object pnlLocale: TTntPanel
        AlignWithMargins = True
        Left = 0
        Top = 113
        Width = 302
        Height = 48
        Margins.Left = 0
        Align = alTop
        AutoSize = True
        BevelOuter = bvNone
        ParentColor = True
        TabOrder = 5
        object lblLang: TTntLabel
          Left = 2
          Top = 0
          Width = 101
          Height = 13
          Caption = 'Language file to use:'
          FocusControl = cboLocale
        end
        object lblLangScan: TTntLabel
          Left = 2
          Top = 35
          Width = 130
          Height = 13
          Cursor = crHandPoint
          Caption = 'Scan for language catalo&gs'
          OnClick = lblLangScanClick
        end
        object cboLocale: TTntComboBox
          Left = 2
          Top = 14
          Width = 169
          Height = 21
          Style = csDropDownList
          ItemHeight = 13
          TabOrder = 0
          Items.Strings = (
            'English (American)')
        end
      end
    end
    object gbReconnect: TExGroupBox
      AlignWithMargins = True
      Left = 0
      Top = 258
      Width = 302
      Height = 86
      Margins.Left = 0
      Align = alTop
      AutoSize = True
      BevelOuter = bvNone
      Caption = 'Reconnect options'
      Padding.Bottom = 6
      ParentColor = True
      TabOrder = 3
      AutoHide = True
      object pnlAttempts: TExBrandPanel
        AlignWithMargins = True
        Left = 0
        Top = 21
        Width = 299
        Height = 31
        Margins.Left = 0
        Align = alTop
        AutoSize = True
        BevelOuter = bvNone
        ParentColor = True
        TabOrder = 1
        AutoHide = True
        object lblAttempts: TTntLabel
          Left = 0
          Top = 3
          Width = 151
          Height = 13
          Caption = 'Num&ber of reconnect attempts:'
          FocusControl = txtAttempts
          Transparent = False
        end
        object txtAttempts: TExNumericEdit
          Left = 171
          Top = 0
          Width = 45
          Height = 21
          BevelOuter = bvNone
          ParentColor = True
          TabOrder = 0
          Text = '0'
          Min = 0
          Max = 1000000
          DesignSize = (
            45
            21)
        end
      end
      object pnlTime: TExBrandPanel
        Left = 0
        Top = 55
        Width = 302
        Height = 31
        Align = alTop
        AutoSize = True
        BevelOuter = bvNone
        ParentColor = True
        TabOrder = 2
        AutoHide = True
        object lblTime: TTntLabel
          Left = 0
          Top = 3
          Width = 145
          Height = 13
          Caption = '&Time lapse between attempts:'
          FocusControl = txtTime
          Transparent = False
        end
        object lblTime2: TTntLabel
          Left = 0
          Top = 17
          Width = 176
          Height = 14
          Caption = 'Use 0 for a random time interval'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clGray
          Font.Height = -12
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
          Transparent = False
        end
        object lblSeconds: TTntLabel
          Left = 223
          Top = 3
          Width = 40
          Height = 13
          Caption = 'Seconds'
        end
        object txtTime: TExNumericEdit
          Left = 171
          Top = 0
          Width = 45
          Height = 21
          BevelOuter = bvNone
          ParentColor = True
          TabOrder = 0
          Text = '0'
          Min = 0
          Max = 3600
          DesignSize = (
            45
            21)
        end
      end
    end
  end
end
