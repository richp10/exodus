inherited frmBaseChat: TfrmBaseChat
  Left = 414
  Top = 474
  ClientHeight = 260
  ClientWidth = 415
  OnResize = FormResize
  ExplicitWidth = 423
  ExplicitHeight = 294
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter1: TSplitter [0]
    AlignWithMargins = True
    Left = 4
    Top = 191
    Width = 407
    Height = 4
    Cursor = crVSplit
    Margins.Left = 4
    Margins.Top = 0
    Margins.Right = 4
    Margins.Bottom = 0
    Align = alBottom
    AutoSnap = False
    Beveled = True
    OnMoved = Splitter1Moved
    ExplicitLeft = 3
    ExplicitWidth = 409
  end
  inherited pnlDock: TTntPanel
    Width = 415
    TabOrder = 2
    ExplicitWidth = 415
    inherited pnlDockTopContainer: TTntPanel
      Width = 415
      ExplicitWidth = 415
      inherited tbDockBar: TToolBar
        Left = 366
        Height = 22
        ExplicitLeft = 366
        inherited btnDockToggle: TToolButton
          ParentShowHint = False
          ShowHint = True
        end
        inherited btnCloseDock: TToolButton
          ParentShowHint = False
          ShowHint = True
        end
      end
      inherited pnlDockTop: TTntPanel
        Width = 363
        AutoSize = True
        ExplicitWidth = 363
        object pnlChatTop: TTntPanel
          Left = 0
          Top = 0
          Width = 363
          Height = 28
          Align = alClient
          BevelOuter = bvNone
          ParentColor = True
          TabOrder = 0
        end
      end
    end
    inherited pnlDockControlSite: TTntPanel
      Left = 4
      Width = 407
      ExplicitWidth = 407
    end
  end
  object pnlMsgList: TPanel
    Left = 0
    Top = 33
    Width = 415
    Height = 158
    Align = alClient
    BevelOuter = bvNone
    BorderWidth = 4
    Constraints.MinHeight = 20
    ParentColor = True
    TabOrder = 0
  end
  object pnlInput: TPanel
    AlignWithMargins = True
    Left = 2
    Top = 195
    Width = 411
    Height = 65
    Margins.Left = 2
    Margins.Top = 0
    Margins.Right = 2
    Margins.Bottom = 0
    Align = alBottom
    BevelOuter = bvNone
    BorderWidth = 2
    ParentColor = True
    TabOrder = 1
    object MsgOut: TExRichEdit
      Left = 2
      Top = 25
      Width = 407
      Height = 38
      Align = alClient
      AutoURLDetect = adNone
      Ctl3D = True
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
      ParentCtl3D = False
      PopupMenu = popOut
      ScrollBars = ssVertical
      ShowSelectionBar = False
      TabOrder = 0
      URLColor = clBlue
      URLCursor = crHandPoint
      WantTabs = True
      WordWrap = False
      OnEnter = MsgOutOnEnter
      OnKeyDown = MsgOutKeyDown
      OnKeyPress = MsgOutKeyPress
      OnKeyUp = MsgOutKeyUp
      OnSelectionChange = MsgOutSelectionChange
      AutoVerbMenu = False
      InputFormat = ifUnicode
      OutputFormat = ofUnicode
      SelectedInOut = False
      PlainRTF = False
      UndoLimit = 0
      AllowInPlace = False
    end
    object pnlToolbar: TPanel
      Left = 2
      Top = 2
      Width = 407
      Height = 23
      Align = alTop
      BevelOuter = bvNone
      ParentColor = True
      TabOrder = 1
      object tbMsgOutToolbar: TTntToolBar
        Left = 0
        Top = 0
        Width = 321
        Height = 23
        Align = alLeft
        AutoSize = True
        ButtonWidth = 25
        Images = frmExodus.ImageList1
        TabOrder = 0
        Transparent = True
        object ChatToolbarButtonBold: TTntToolButton
          Left = 0
          Top = 0
          Hint = 'Bold'
          AllowAllUp = True
          ImageIndex = 70
          ParentShowHint = False
          ShowHint = True
          Style = tbsCheck
          OnClick = ChatToolbarButtonBoldClick
        end
        object ChatToolbarButtonUnderline: TTntToolButton
          Left = 25
          Top = 0
          Hint = 'Underline'
          AllowAllUp = True
          Caption = 'Underline'
          ImageIndex = 71
          ParentShowHint = False
          ShowHint = True
          Style = tbsCheck
          OnClick = ChatToolbarButtonUnderlineClick
        end
        object ChatToolbarButtonItalics: TTntToolButton
          Left = 50
          Top = 0
          Hint = 'Italics'
          AllowAllUp = True
          Caption = 'Color'
          ImageIndex = 72
          ParentShowHint = False
          ShowHint = True
          Style = tbsCheck
          Visible = False
          OnClick = ItalicsClick
        end
        object ChatToolbarButtonColors: TTntToolButton
          Left = 75
          Top = 0
          Hint = 'Colors'
          AllowAllUp = True
          Caption = 'Color'
          ImageIndex = 84
          ParentShowHint = False
          ShowHint = True
          OnClick = ChatToolbarButtonColorsClick
        end
        object ChatToolbarButtonSeparator1: TTntToolButton
          Left = 100
          Top = 0
          Width = 8
          Style = tbsSeparator
        end
        object ChatToolbarButtonCut: TTntToolButton
          Left = 108
          Top = 0
          Hint = 'Cut'
          Caption = 'Cut'
          ImageIndex = 73
          ParentShowHint = False
          ShowHint = True
          OnClick = Copy2Click
        end
        object ChatToolbarButtonCopy: TTntToolButton
          Left = 133
          Top = 0
          Hint = 'Copy'
          Caption = 'Copy'
          ImageIndex = 74
          ParentShowHint = False
          ShowHint = True
          OnClick = Copy3Click
        end
        object ChatToolbarButtonPaste: TTntToolButton
          Left = 158
          Top = 0
          Hint = 'Paste'
          Caption = 'Paste'
          ImageIndex = 75
          ParentShowHint = False
          ShowHint = True
          OnClick = Paste1Click
        end
        object ChatToolbarButtonSeparator2: TTntToolButton
          Left = 183
          Top = 0
          Width = 8
          Style = tbsSeparator
        end
        object ChatToolbarButtonEmoticons: TTntToolButton
          Left = 191
          Top = 0
          Hint = 'Emoticons'
          Caption = 'Emoticons'
          ImageIndex = 76
          ParentShowHint = False
          ShowHint = True
          OnClick = Emoticons1Click
        end
        object ChatToolbarButtonHotkeys: TTntToolButton
          Left = 216
          Top = 0
          Hint = 'Hotkeys'
          Caption = 'Hotkeys'
          ImageIndex = 77
          ParentShowHint = False
          PopupMenu = popHotkeys
          ShowHint = True
          OnClick = ChatToolbarButtonHotkeysClick
        end
        object TntToolButton1: TTntToolButton
          Left = 241
          Top = 0
          Width = 8
          Caption = 'TntToolButton1'
          Style = tbsSeparator
        end
        object cmbPriority: TTntComboBox
          Left = 249
          Top = 0
          Width = 72
          Height = 21
          Hint = 'Hotkeys'
          Style = csDropDownList
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ItemHeight = 13
          ParentFont = False
          ParentShowHint = False
          ShowHint = True
          TabOrder = 0
        end
      end
      object pnlControlSite: TPanel
        Left = 321
        Top = 0
        Width = 86
        Height = 23
        Align = alClient
        BevelOuter = bvNone
        ParentColor = True
        TabOrder = 1
      end
    end
  end
  object popMsgList: TTntPopupMenu
    Left = 16
    Top = 120
    object Copy1: TTntMenuItem
      Caption = 'Copy'
      OnClick = Copy1Click
    end
    object CopyAll1: TTntMenuItem
      Caption = 'Copy All'
      OnClick = CopyAll1Click
    end
    object Clear1: TTntMenuItem
      Caption = 'Clear'
      OnClick = Clear1Click
    end
  end
  object popOut: TTntPopupMenu
    Left = 48
    Top = 120
    object Copy2: TTntMenuItem
      Caption = 'Cut'
      OnClick = Copy2Click
    end
    object Copy3: TTntMenuItem
      Caption = 'Copy'
      OnClick = Copy3Click
    end
    object Paste2: TTntMenuItem
      Caption = 'Paste '
      OnClick = Paste1Click
    end
    object N2: TTntMenuItem
      Caption = '-'
    end
    object Emoticons2: TTntMenuItem
      Caption = 'Emoticons'
      ShortCut = 16453
      OnClick = Emoticons1Click
    end
    object emot_sep: TTntMenuItem
      Caption = '-'
    end
  end
  object popHotkeys: TTntPopupMenu
    Left = 80
    Top = 120
    object popHotkeys_sep1: TTntMenuItem
      Caption = '-'
    end
    object Customize1: TTntMenuItem
      Caption = 'Customize...'
      OnClick = Customize1Click
    end
  end
  object AppEvents: TApplicationEvents
    OnShortCut = AppEventsShortCut
    Left = 104
    Top = 120
  end
end
