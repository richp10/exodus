inherited frmPrefDisplay: TfrmPrefDisplay
  Left = 400
  Top = 120
  Caption = 'frmPrefFont'
  ClientHeight = 639
  ClientWidth = 418
  OldCreateOrder = True
  Position = poDesigned
  ShowHint = True
  OnClose = FormClose
  ExplicitWidth = 430
  ExplicitHeight = 651
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnlHeader: TTntPanel
    Width = 418
    ExplicitWidth = 418
    inherited lblHeader: TTntLabel
      Left = 6
      Width = 43
      Caption = 'Display'
      ExplicitLeft = 6
      ExplicitWidth = 43
    end
  end
  object TntScrollBox1: TTntScrollBox
    Left = 0
    Top = 23
    Width = 418
    Height = 616
    Align = alClient
    BevelInner = bvNone
    BevelOuter = bvNone
    BorderStyle = bsNone
    TabOrder = 1
    object pnlContainer: TExBrandPanel
      AlignWithMargins = True
      Left = 0
      Top = 3
      Width = 398
      Height = 566
      Margins.Left = 0
      Margins.Bottom = 0
      Align = alTop
      AutoSize = True
      BevelOuter = bvNone
      ParentColor = True
      TabOrder = 0
      AutoHide = True
      object gbContactList: TExGroupBox
        AlignWithMargins = True
        Left = 0
        Top = 3
        Width = 398
        Height = 163
        Margins.Left = 0
        Margins.Right = 0
        Margins.Bottom = 0
        Align = alTop
        AutoSize = True
        BevelOuter = bvNone
        Caption = 'Contact list'
        ParentColor = True
        TabOrder = 0
        AutoHide = True
        object lblRosterBG: TTntLabel
          Left = 3
          Top = 24
          Width = 86
          Height = 13
          Margins.Left = 0
          Caption = '&Background color:'
          FocusControl = cbRosterBG
        end
        object lblRosterFG: TTntLabel
          Left = 3
          Top = 76
          Width = 52
          Height = 13
          Margins.Left = 0
          Caption = '&Font color:'
          FocusControl = cbRosterFont
        end
        object lblRosterPreview: TTntLabel
          Left = 171
          Top = 24
          Width = 42
          Height = 13
          Caption = '&Preview:'
          FocusControl = colorRoster
        end
        object cbRosterBG: TColorBox
          Left = 3
          Top = 43
          Width = 154
          Height = 22
          Margins.Left = 0
          Margins.Top = 0
          Margins.Bottom = 0
          DefaultColorColor = clBlue
          Selected = clBlue
          Style = [cbStandardColors, cbExtendedColors, cbIncludeDefault, cbCustomColor, cbPrettyNames]
          DropDownCount = 12
          ItemHeight = 16
          TabOrder = 1
          OnChange = cbRosterBGChange
        end
        object cbRosterFont: TColorBox
          Left = 3
          Top = 99
          Width = 154
          Height = 22
          Margins.Left = 0
          DefaultColorColor = clBlue
          Selected = clBlue
          Style = [cbStandardColors, cbExtendedColors, cbIncludeDefault, cbCustomColor, cbPrettyNames]
          DropDownCount = 12
          ItemHeight = 16
          TabOrder = 2
          OnChange = cbRosterFontChange
        end
        object btnRosterFont: TTntButton
          AlignWithMargins = True
          Left = 3
          Top = 132
          Width = 69
          Height = 22
          Margins.Left = 0
          Caption = 'F&ont...'
          TabOrder = 3
          OnClick = btnRosterFontClick
        end
        object colorRoster: TTntTreeView
          Left = 171
          Top = 46
          Width = 178
          Height = 86
          BevelWidth = 10
          Indent = 19
          ReadOnly = True
          ShowButtons = False
          ShowLines = False
          TabOrder = 4
        end
        object btnManageTabs: TTntButton
          AlignWithMargins = True
          Left = 171
          Top = 137
          Width = 82
          Height = 23
          Margins.Left = 0
          Caption = '&Manage tabs...'
          TabOrder = 5
          OnClick = btnManageTabsClick
        end
      end
      object gbActivityWindow: TExGroupBox
        AlignWithMargins = True
        Left = 0
        Top = 169
        Width = 398
        Height = 200
        Margins.Left = 0
        Margins.Right = 0
        Margins.Bottom = 0
        Align = alTop
        AutoSize = True
        BevelOuter = bvNone
        Caption = 'Activity list'
        ParentColor = True
        TabOrder = 1
        AutoHide = True
        object lblChatPreview: TTntLabel
          Left = 171
          Top = 21
          Width = 42
          Height = 13
          Caption = 'Pre&view:'
          FocusControl = colorChat
        end
        object Label5: TTntLabel
          Left = 173
          Top = 145
          Width = 307
          Height = 14
          Caption = 'Elements can also be directly selected from the preview'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clGray
          Font.Height = -12
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
        end
        object lblChatWindowElement: TTntLabel
          Left = 3
          Top = 21
          Width = 129
          Height = 13
          Margins.Left = 0
          Caption = 'Choose &element to format:'
          FocusControl = cboChatElement
        end
        object lblChatFG: TTntLabel
          Left = 15
          Top = 73
          Width = 52
          Height = 13
          Caption = 'Font &color:'
          FocusControl = cbChatFont
        end
        object lblChatBG: TTntLabel
          Left = 3
          Top = 158
          Width = 86
          Height = 13
          Margins.Left = 0
          Caption = 'B&ackground color:'
          FocusControl = cbChatBG
        end
        object colorChat: TExRichEdit
          Left = 171
          Top = 41
          Width = 316
          Height = 98
          AutoURLDetect = adNone
          CustomURLs = <
            item
              Name = 'e-mail'
              Color = clWindowText
              Cursor = crDefault
              Underline = True
            end
            item
              Name = 'http'
              Color = clWindowText
              Cursor = crDefault
              Underline = True
            end
            item
              Name = 'file'
              Color = clWindowText
              Cursor = crDefault
              Underline = True
            end
            item
              Name = 'mailto'
              Color = clWindowText
              Cursor = crDefault
              Underline = True
            end
            item
              Name = 'ftp'
              Color = clWindowText
              Cursor = crDefault
              Underline = True
            end
            item
              Name = 'https'
              Color = clWindowText
              Cursor = crDefault
              Underline = True
            end
            item
              Name = 'gopher'
              Color = clWindowText
              Cursor = crDefault
              Underline = True
            end
            item
              Name = 'nntp'
              Color = clWindowText
              Cursor = crDefault
              Underline = True
            end
            item
              Name = 'prospero'
              Color = clWindowText
              Cursor = crDefault
              Underline = True
            end
            item
              Name = 'telnet'
              Color = clWindowText
              Cursor = crDefault
              Underline = True
            end
            item
              Name = 'news'
              Color = clWindowText
              Cursor = crDefault
              Underline = True
            end
            item
              Name = 'wais'
              Color = clWindowText
              Cursor = crDefault
              Underline = True
            end>
          LangOptions = [loAutoFont]
          Language = 1033
          ReadOnly = True
          ScrollBars = ssBoth
          ShowSelectionBar = False
          TabOrder = 1
          URLColor = clBlue
          URLCursor = crHandPoint
          WordWrap = False
          OnMouseDown = colorChatMouseDown
          InputFormat = ifRTF
          OutputFormat = ofRTF
          SelectedInOut = False
          PlainRTF = False
          UndoLimit = 0
          AllowInPlace = False
        end
        object cboChatElement: TTntComboBox
          Left = 3
          Top = 41
          Width = 154
          Height = 21
          Margins.Left = 0
          Style = csDropDownList
          ItemHeight = 13
          TabOrder = 2
          OnChange = cboChatElementChange
        end
        object btnChatFont: TTntButton
          AlignWithMargins = True
          Left = 15
          Top = 129
          Width = 67
          Height = 20
          Caption = 'Fo&nt...'
          TabOrder = 3
          OnClick = btnFontClick
        end
        object cbChatFont: TColorBox
          Left = 15
          Top = 95
          Width = 142
          Height = 22
          DefaultColorColor = clBlue
          Selected = clBlue
          Style = [cbStandardColors, cbExtendedColors, cbIncludeDefault, cbCustomColor, cbPrettyNames]
          DropDownCount = 12
          ItemHeight = 16
          TabOrder = 4
          OnChange = cbChatFontChange
        end
        object cbChatBG: TColorBox
          Left = 3
          Top = 178
          Width = 154
          Height = 22
          Margins.Left = 0
          Margins.Top = 0
          Margins.Bottom = 0
          DefaultColorColor = clBlue
          Selected = clBlue
          Style = [cbStandardColors, cbExtendedColors, cbIncludeDefault, cbCustomColor, cbPrettyNames]
          DropDownCount = 12
          ItemHeight = 16
          TabOrder = 5
          OnChange = cbChatBGChange
        end
      end
      object gbOtherPrefs: TExGroupBox
        AlignWithMargins = True
        Left = 0
        Top = 375
        Width = 395
        Height = 191
        Margins.Left = 0
        Margins.Top = 6
        Margins.Bottom = 0
        Align = alTop
        AutoSize = True
        BevelOuter = bvNone
        Caption = 'Other display preferences'
        ParentColor = True
        TabOrder = 2
        AutoHide = True
        object chkRTEnabled: TTntCheckBox
          AlignWithMargins = True
          Left = 3
          Top = 18
          Width = 389
          Height = 21
          Hint = 'Send and display messages with different fonts, colors etc.'
          Margins.Top = 0
          Margins.Bottom = 0
          Align = alTop
          Caption = 'Enable &rich text formatting'
          TabOrder = 0
          OnClick = chkRTEnabledClick
          ExplicitTop = 21
        end
        object pnlTimeStamp: TExBrandPanel
          AlignWithMargins = True
          Left = 3
          Top = 149
          Width = 389
          Height = 42
          Margins.Top = 0
          Margins.Bottom = 0
          Align = alTop
          AutoSize = True
          BevelOuter = bvNone
          ParentColor = True
          TabOrder = 4
          AutoHide = True
          ExplicitTop = 110
          object lblTimestampFmt: TTntLabel
            Left = 26
            Top = 25
            Width = 38
            Height = 13
            Caption = 'Forma&t:'
            FocusControl = txtTimestampFmt
          end
          object chkTimestamp: TTntCheckBox
            Left = 0
            Top = 0
            Width = 389
            Height = 21
            Margins.Top = 0
            Margins.Bottom = 0
            Align = alTop
            Caption = 'Show timestamp &with messages'
            TabOrder = 0
          end
          object txtTimestampFmt: TTntComboBox
            Left = 77
            Top = 21
            Width = 177
            Height = 21
            ItemHeight = 13
            TabOrder = 1
            Text = 'h:mm am/pm'
            Items.Strings = (
              'm/d/y h:mm am/pm'
              'mm/dd/yy hh:mm:ss'
              'h:mm am/pm'
              'hh:mm:ss')
          end
        end
        object chkShowPriority: TTntCheckBox
          AlignWithMargins = True
          Left = 3
          Top = 86
          Width = 389
          Height = 21
          Margins.Top = 0
          Margins.Bottom = 0
          Align = alTop
          Caption = 'Show &message priority in chat windows'
          TabOrder = 3
          ExplicitTop = 89
        end
        object chkChatAvatars: TTntCheckBox
          AlignWithMargins = True
          Left = 3
          Top = 39
          Width = 389
          Height = 21
          Margins.Top = 0
          Margins.Bottom = 0
          Align = alTop
          Caption = '&Show avatars in chat windows'
          TabOrder = 1
          ExplicitTop = 42
        end
        object pnlEmoticons: TExBrandPanel
          AlignWithMargins = True
          Left = 3
          Top = 60
          Width = 389
          Height = 26
          Margins.Top = 0
          Margins.Bottom = 0
          Align = alTop
          AutoSize = True
          BevelOuter = bvNone
          ParentColor = True
          TabOrder = 2
          AutoHide = True
          ExplicitTop = 63
          object chkEmoticons: TTntCheckBox
            AlignWithMargins = True
            Left = 0
            Top = 3
            Width = 164
            Height = 19
            Margins.Left = 0
            Caption = 'Auto &detect emoticons'
            TabOrder = 0
            OnClick = chkEmoticonsClick
          end
          object btnEmoSettings: TTntButton
            Left = 170
            Top = 2
            Width = 78
            Height = 24
            Caption = 'Settings...'
            TabOrder = 1
            OnClick = btnEmoSettingsClick
          end
        end
        object pnlDateSeparator: TExBrandPanel
          AlignWithMargins = True
          Left = 3
          Top = 107
          Width = 389
          Height = 42
          Margins.Top = 0
          Margins.Bottom = 0
          Align = alTop
          AutoSize = True
          BevelOuter = bvNone
          ParentColor = True
          TabOrder = 6
          AutoHide = True
          object lblDateSeparatorFmt: TTntLabel
            Left = 26
            Top = 25
            Width = 38
            Height = 13
            Caption = 'Forma&t:'
            FocusControl = txtDateSeparatorFmt
          end
          object chkDateSeparator: TTntCheckBox
            Left = 0
            Top = 0
            Width = 389
            Height = 21
            Margins.Top = 0
            Margins.Bottom = 0
            Align = alTop
            Caption = 'Show date se&parator with messages'
            TabOrder = 0
          end
          object txtDateSeparatorFmt: TTntComboBox
            Left = 77
            Top = 21
            Width = 177
            Height = 21
            ItemHeight = 13
            TabOrder = 1
            Text = 'MM/dd/yyyy'
            Items.Strings = (
              'M/d/yyyy'
              'M/d/yy'
              'MM/dd/yy'
              'MM/dd/yyyy'
              'yy/MM/dd'
              'yyyy-MM-dd'
              'dd-MMM-yy')
          end
        end
      end
    end
    object gbAdvancedPrefs: TExGroupBox
      AlignWithMargins = True
      Left = 0
      Top = 575
      Width = 398
      Height = 326
      Margins.Left = 0
      Margins.Top = 6
      Margins.Bottom = 0
      Align = alTop
      AutoSize = True
      BevelOuter = bvNone
      Caption = 'Advanced display preferences'
      ParentColor = True
      TabOrder = 1
      AutoHide = True
      object pnlAdvancedLeft: TExBrandPanel
        AlignWithMargins = True
        Left = 3
        Top = 120
        Width = 343
        Height = 203
        Align = alLeft
        BevelOuter = bvNone
        ParentColor = True
        TabOrder = 1
        AutoHide = True
        object gbRTIncludes: TExGroupBox
          AlignWithMargins = True
          Left = 0
          Top = 3
          Width = 340
          Height = 85
          Margins.Left = 0
          Margins.Bottom = 0
          Align = alTop
          AutoSize = True
          BevelOuter = bvNone
          Caption = 'Messages may include:'
          ParentColor = True
          TabOrder = 0
          AutoHide = True
          object chkAllowFontFamily: TTntCheckBox
            AlignWithMargins = True
            Left = 0
            Top = 21
            Width = 337
            Height = 16
            Margins.Left = 0
            Align = alTop
            Caption = 'Multip&le fonts'
            TabOrder = 0
            OnClick = chkAllowFontFamilyClick
          end
          object chkAllowFontSize: TTntCheckBox
            AlignWithMargins = True
            Left = 0
            Top = 43
            Width = 337
            Height = 16
            Margins.Left = 0
            Align = alTop
            Caption = 'Different si&zed text'
            TabOrder = 1
            OnClick = chkAllowFontFamilyClick
          end
          object chkAllowFontColor: TTntCheckBox
            AlignWithMargins = True
            Left = 0
            Top = 65
            Width = 337
            Height = 17
            Margins.Left = 0
            Align = alTop
            Caption = 'Different colored te&xt'
            TabOrder = 2
            OnClick = chkAllowFontFamilyClick
          end
        end
        object gbChatOptions: TExGroupBox
          AlignWithMargins = True
          Left = 0
          Top = 91
          Width = 340
          Height = 155
          Margins.Left = 0
          Align = alTop
          AutoSize = True
          BevelOuter = bvNone
          Caption = 'Chat Preferences'
          ParentColor = True
          TabOrder = 1
          AutoHide = True
          object chkBusy: TTntCheckBox
            Left = 0
            Top = 18
            Width = 340
            Height = 19
            Align = alTop
            Caption = 'Warn when trying to close busy chat windows'
            TabOrder = 1
          end
          object chkEscClose: TTntCheckBox
            Left = 0
            Top = 37
            Width = 340
            Height = 18
            Align = alTop
            Caption = 'Use ESC key to close chat windows'
            TabOrder = 2
          end
          object pnlChatHotkey: TExBrandPanel
            AlignWithMargins = True
            Left = 0
            Top = 58
            Width = 337
            Height = 41
            Margins.Left = 0
            Align = alTop
            AutoSize = True
            BevelOuter = bvNone
            ParentColor = True
            TabOrder = 3
            AutoHide = True
            object lblClose: TTntLabel
              Left = 0
              Top = 0
              Width = 235
              Height = 13
              Caption = 'Use this hotkey sequence to close chat windows:'
            end
            object txtCloseHotkey: THotKey
              Left = 0
              Top = 20
              Width = 158
              Height = 21
              HotKey = 57431
              InvalidKeys = []
              Modifiers = [hkShift, hkCtrl, hkAlt]
              TabOrder = 0
            end
          end
          object pnlChatMemory: TExBrandPanel
            AlignWithMargins = True
            Left = 0
            Top = 111
            Width = 337
            Height = 41
            Margins.Left = 0
            Margins.Top = 9
            Align = alTop
            AutoSize = True
            BevelOuter = bvNone
            ParentColor = True
            TabOrder = 4
            AutoHide = True
            object lblMem1: TTntLabel
              Left = 0
              Top = 0
              Width = 337
              Height = 13
              Align = alTop
              Caption = 
                'Minutes to keep displayed chat history (0 to destroy immediately' +
                '):'
              ExplicitWidth = 317
            end
            object trkChatMemory: TTrackBar
              Left = -5
              Top = 20
              Width = 150
              Height = 21
              Max = 120
              PageSize = 15
              Frequency = 15
              Position = 60
              TabOrder = 1
              ThumbLength = 15
              TickStyle = tsNone
              OnChange = trkChatMemoryChange
            end
            object txtChatMemory: TExNumericEdit
              Left = 151
              Top = 15
              Width = 62
              Height = 25
              BevelOuter = bvNone
              ParentColor = True
              TabOrder = 0
              Text = '60'
              Min = 0
              Max = 360
              OnChange = txtChatMemoryChange
              DesignSize = (
                62
                25)
            end
          end
        end
      end
      object pnlSnapTo: TExBrandPanel
        AlignWithMargins = True
        Left = 0
        Top = 71
        Width = 395
        Height = 46
        Margins.Left = 0
        Margins.Bottom = 0
        Align = alTop
        AutoSize = True
        BevelOuter = bvNone
        ParentColor = True
        TabOrder = 2
        AutoHide = True
        object chkSnap: TTntCheckBox
          Left = 3
          Top = 0
          Width = 300
          Height = 19
          Caption = 'Make the main window snap to screen edges'
          TabOrder = 1
          OnClick = chkSnapClick
        end
        object trkSnap: TTrackBar
          Left = 20
          Top = 24
          Width = 150
          Height = 22
          Enabled = False
          Max = 120
          Min = 10
          PageSize = 15
          Frequency = 15
          Position = 15
          TabOrder = 2
          ThumbLength = 15
          TickStyle = tsNone
          OnChange = trkSnapChange
        end
        object txtSnap: TExNumericEdit
          Left = 176
          Top = 20
          Width = 61
          Height = 25
          BevelOuter = bvNone
          Enabled = False
          ParentColor = True
          TabOrder = 0
          Text = '15'
          Min = 10
          Max = 120
          OnChange = txtSnapChange
          DesignSize = (
            61
            25)
        end
      end
      object pnlGlueWindows: TExBrandPanel
        AlignWithMargins = True
        Left = 0
        Top = 21
        Width = 395
        Height = 47
        Margins.Left = 0
        Margins.Bottom = 0
        Align = alTop
        AutoSize = True
        BevelOuter = bvNone
        ParentColor = True
        TabOrder = 3
        AutoHide = True
        object chkGlue: TTntCheckBox
          Left = 3
          Top = 0
          Width = 300
          Height = 19
          Caption = 'Make the activity window snap to the main window'
          TabOrder = 1
          OnClick = chkGlueClick
        end
        object trkGlue: TTrackBar
          Left = 20
          Top = 25
          Width = 150
          Height = 22
          Enabled = False
          Max = 50
          Min = 1
          PageSize = 15
          Frequency = 15
          Position = 15
          TabOrder = 2
          ThumbLength = 15
          TickStyle = tsNone
          OnChange = trkGlueChange
        end
        object txtGlue: TExNumericEdit
          Left = 176
          Top = 20
          Width = 61
          Height = 25
          BevelOuter = bvNone
          Enabled = False
          ParentColor = True
          TabOrder = 0
          Text = '15'
          Min = 1
          Max = 50
          OnChange = txtGlueChange
          DesignSize = (
            61
            25)
        end
      end
    end
  end
  object FontDialog1: TFontDialog
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    Options = []
    Left = 453
    Top = 51
  end
end
