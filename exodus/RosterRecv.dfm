inherited frmRosterRecv: TfrmRosterRecv
  Left = 228
  Top = 192
  Caption = 'Receiving Contacts'
  ClientHeight = 353
  ClientWidth = 460
  ExplicitWidth = 468
  ExplicitHeight = 393
  PixelsPerInch = 120
  TextHeight = 16
  object Splitter1: TSplitter [0]
    Left = 0
    Top = 116
    Width = 460
    Height = 3
    Cursor = crVSplit
    Align = alTop
  end
  inherited pnlDock: TTntPanel
    Width = 460
    TabOrder = 4
    inherited pnlDockTopContainer: TTntPanel
      Width = 460
      inherited tbDockBar: TToolBar
        ExplicitLeft = 411
        inherited btnCloseDock: TToolButton
          Visible = False
        end
      end
      inherited pnlDockTop: TTntPanel
        ExplicitWidth = 408
        object pnlFrom: TTntPanel
          Left = 0
          Top = 0
          Width = 199
          Height = 34
          Align = alClient
          BevelOuter = bvNone
          BorderWidth = 2
          ParentColor = True
          TabOrder = 0
          ExplicitWidth = 408
          object StaticText1: TTntStaticText
            Left = 2
            Top = 2
            Width = 55
            Height = 30
            Align = alLeft
            Caption = 'From:    '
            TabOrder = 0
            ExplicitHeight = 20
          end
          object txtFrom: TTntStaticText
            Left = 57
            Top = 2
            Width = 140
            Height = 30
            Align = alClient
            Caption = '<JID>'
            TabOrder = 1
            ExplicitWidth = 39
            ExplicitHeight = 20
          end
        end
      end
    end
    inherited pnlDockControlSite: TTntPanel
      Width = 460
    end
  end
  inline frameButtons1: TframeButtons
    Left = 0
    Top = 311
    Width = 460
    Height = 42
    Align = alBottom
    Color = 13681583
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentColor = False
    ParentFont = False
    TabOrder = 0
    TabStop = True
    ExplicitTop = 311
    ExplicitWidth = 460
    ExplicitHeight = 42
    inherited Panel2: TPanel
      Width = 460
      Height = 42
      ExplicitWidth = 460
      ExplicitHeight = 42
      inherited Bevel1: TBevel
        Width = 460
        Height = 6
        ExplicitWidth = 460
        ExplicitHeight = 6
      end
      inherited Panel1: TPanel
        Left = 263
        Top = 6
        Width = 197
        Height = 36
        ExplicitLeft = 263
        ExplicitTop = 6
        ExplicitWidth = 197
        ExplicitHeight = 36
        inherited btnOK: TTntButton
          Left = 5
          Width = 92
          Height = 31
          Caption = 'Add Contacts'
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
          OnClick = frameButtons1btnCancelClick
          ExplicitLeft = 101
          ExplicitWidth = 92
          ExplicitHeight = 31
        end
      end
    end
  end
  object txtMsg: TExRichEdit
    Left = 0
    Top = 41
    Width = 460
    Height = 75
    Align = alTop
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
    ShowSelectionBar = False
    TabOrder = 1
    URLColor = clBlue
    URLCursor = crHandPoint
    InputFormat = ifRTF
    OutputFormat = ofRTF
    SelectedInOut = False
    PlainRTF = False
    UndoLimit = 0
    AllowInPlace = False
  end
  object lvContacts: TTntListView
    Left = 0
    Top = 155
    Width = 460
    Height = 156
    Align = alClient
    Checkboxes = True
    Columns = <
      item
        Caption = 'Nickname'
        Width = 123
      end
      item
        Caption = 'Jabber ID'
        Width = 185
      end>
    TabOrder = 2
    ViewStyle = vsReport
  end
  object Panel1: TTntPanel
    Left = 0
    Top = 119
    Width = 460
    Height = 36
    Align = alTop
    BevelOuter = bvNone
    ParentColor = True
    TabOrder = 3
    object Label2: TTntLabel
      Left = 4
      Top = 9
      Width = 154
      Height = 16
      Caption = 'Add contacts to this group:'
    end
    object cboGroup: TTntComboBox
      Left = 177
      Top = 4
      Width = 257
      Height = 24
      ItemHeight = 16
      Sorted = True
      TabOrder = 0
    end
  end
end
