object frmView: TfrmView
  Left = 289
  Top = 145
  Width = 595
  Height = 459
  BorderWidth = 5
  Caption = 'frmView'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 577
    Height = 78
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    object TntLabel1: TTntLabel
      Left = 5
      Top = 4
      Width = 89
      Height = 13
      Caption = 'Contact Jabber ID:'
    end
    object TntLabel2: TTntLabel
      Left = 5
      Top = 54
      Width = 49
      Height = 13
      Caption = 'Keywords:'
    end
    object TntLabel3: TTntLabel
      Left = 5
      Top = 28
      Width = 51
      Height = 13
      Caption = 'Date Filter:'
    end
    object cboJid: TTntComboBox
      Left = 112
      Top = 0
      Width = 217
      Height = 21
      ItemHeight = 13
      ItemIndex = 0
      TabOrder = 0
      Text = '<ALL CONTACTS>'
      OnChange = cboJidChange
      OnSelect = cboJidSelect
      Items.Strings = (
        '<ALL CONTACTS>')
    end
    object txtWords: TTntEdit
      Left = 112
      Top = 51
      Width = 217
      Height = 21
      TabOrder = 1
    end
    object btnSearch: TTntButton
      Left = 337
      Top = 49
      Width = 75
      Height = 25
      Caption = 'Search'
      Default = True
      TabOrder = 2
      OnClick = btnSearchClick
    end
    object cboDateFilter: TTntComboBox
      Left = 112
      Top = 24
      Width = 217
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      ItemIndex = 0
      TabOrder = 3
      Text = 'Selected Day'
      OnChange = cboDateFilterChange
      Items.Strings = (
        'Selected Day'
        'Current Month'
        'All Dates')
    end
    object btnDetails: TTntButton
      Left = 419
      Top = 49
      Width = 75
      Height = 25
      Caption = 'Show SQL'
      TabOrder = 4
      OnClick = btnDetailsClick
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 153
    Width = 197
    Height = 266
    Align = alLeft
    BevelOuter = bvNone
    TabOrder = 1
    object pnlCal: TPanel
      Left = 0
      Top = 0
      Width = 197
      Height = 189
      Align = alTop
      BevelOuter = bvNone
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial Unicode MS'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      object pnlToday: TTntPanel
        Left = 0
        Top = 164
        Width = 197
        Height = 25
        Align = alBottom
        Caption = 'Today: 4/30/2004'
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Arial Unicode MS'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        DesignSize = (
          197
          25)
        object btnPrevMonth: TSpeedButton
          Left = 4
          Top = 5
          Width = 23
          Height = 15
          Flat = True
          Glyph.Data = {
            F6000000424DF600000000000000760000002800000010000000100000000100
            04000000000080000000120B0000120B00001000000010000000000000000000
            8000008000000080800080000000800080008080000080808000C0C0C0000000
            FF00C0C0C00000FFFF00FF000000C0C0C000FFFF0000FFFFFF00DADADADADADA
            DADAADADADADADADADADDADADADADADADADAADADADADADADADADDADADADAD1DA
            DADAADADADAD11ADADADDADADAD111DADADAADADAD1111ADADADDADAD11111DA
            DADAADADAD1111ADADADDADADAD111DADADAADADADAD11ADADADDADADADAD1DA
            DADAADADADADADADADADDADADADADADADADAADADADADADADADAD}
          OnClick = btnNextMonthClick
        end
        object btnNextMonth: TSpeedButton
          Left = 170
          Top = 5
          Width = 23
          Height = 15
          Anchors = [akTop, akRight]
          Flat = True
          Glyph.Data = {
            F6000000424DF600000000000000760000002800000010000000100000000100
            04000000000080000000120B0000120B00001000000010000000000000000000
            8000008000000080800080000000800080008080000080808000C0C0C0000000
            FF00C0C0C00000FFFF00FF000000C0C0C000FFFF0000FFFFFF00DADADADADADA
            DADAADADADADADADADADDADADADADADADADAADADADADADADADADDADADA1ADADA
            DADAADADAD11ADADADADDADADA111ADADADAADADAD1111ADADADDADADA11111A
            DADAADADAD1111ADADADDADADA111ADADADAADADAD11ADADADADDADADA1ADADA
            DADAADADADADADADADADDADADADADADADADAADADADADADADADAD}
          OnClick = btnNextMonthClick
        end
      end
      object pnlCalHeader: TTntPanel
        Left = 0
        Top = 0
        Width = 197
        Height = 21
        Align = alTop
        BevelInner = bvRaised
        BevelOuter = bvLowered
        Caption = 'April, 2004'
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Arial Unicode MS'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 1
      end
      object gridCal: TTntStringGrid
        Left = 0
        Top = 21
        Width = 197
        Height = 143
        Align = alClient
        BorderStyle = bsNone
        ColCount = 7
        DefaultColWidth = 27
        DefaultRowHeight = 17
        DefaultDrawing = False
        FixedCols = 0
        RowCount = 7
        Options = [goFixedHorzLine, goVertLine, goHorzLine]
        ScrollBars = ssNone
        TabOrder = 2
        OnDrawCell = gridCalDrawCell
        OnSelectCell = gridCalSelectCell
        ColWidths = (
          27
          27
          27
          27
          27
          27
          27)
      end
    end
  end
  object pnlRight: TPanel
    Left = 197
    Top = 153
    Width = 380
    Height = 266
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 2
    object Splitter1: TSplitter
      Left = 0
      Top = 111
      Width = 380
      Height = 3
      Cursor = crVSplit
      Align = alTop
    end
    object MsgList: TExRichEdit
      Left = 0
      Top = 114
      Width = 380
      Height = 152
      Align = alClient
      AutoURLDetect = adDefault
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
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial Unicode MS'
      Font.Style = []
      LangOptions = [loAutoFont]
      Language = 1033
      ParentFont = False
      ScrollBars = ssVertical
      ShowSelectionBar = False
      TabOrder = 0
      URLColor = clBlue
      URLCursor = crHandPoint
      InputFormat = ifRTF
      OutputFormat = ofRTF
      SelectedInOut = False
      PlainRTF = False
      UndoLimit = 0
      AllowInPlace = False
    end
    object lstConv: TTntListView
      Left = 0
      Top = 0
      Width = 380
      Height = 111
      Align = alTop
      BevelInner = bvNone
      BevelWidth = 2
      Columns = <
        item
          Caption = 'Date/Time'
          Width = 100
        end
        item
          Caption = '# Msgs'
        end
        item
          Caption = 'Contact'
          Width = 150
        end>
      ColumnClick = False
      MultiSelect = True
      OwnerData = True
      ReadOnly = True
      RowSelect = True
      TabOrder = 1
      ViewStyle = vsReport
      OnData = lstConvData
      OnDataStateChange = lstConvDataStateChange
      OnDblClick = lstConvDblClick
      OnSelectItem = lstConvSelectItem
    end
  end
  object pnlSQL: TPanel
    Left = 0
    Top = 78
    Width = 577
    Height = 75
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 3
    Visible = False
    object lblSQL: TTntLabel
      Left = 0
      Top = 0
      Width = 577
      Height = 75
      Align = alClient
      AutoSize = False
      WordWrap = True
    end
  end
end
