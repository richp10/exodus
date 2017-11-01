inherited frmRoomProperties: TfrmRoomProperties
  Left = 368
  Top = 225
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsDialog
  Caption = 'Room Properties'
  ClientHeight = 311
  ClientWidth = 515
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  ExplicitWidth = 521
  ExplicitHeight = 343
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter1: TSplitter
    Left = 137
    Top = 0
    Height = 277
    ExplicitHeight = 330
  end
  inline frameButtons1: TframeButtons
    Left = 0
    Top = 277
    Width = 515
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
    TabOrder = 0
    TabStop = True
    ExplicitTop = 277
    ExplicitWidth = 515
    ExplicitHeight = 34
    inherited Panel2: TPanel
      Width = 515
      Height = 34
      ExplicitWidth = 515
      ExplicitHeight = 34
      inherited Bevel1: TBevel
        Width = 515
        ExplicitWidth = 454
      end
      inherited Panel1: TPanel
        Left = 355
        Height = 29
        ExplicitLeft = 355
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
  object TreeView1: TTntTreeView
    Left = 0
    Top = 0
    Width = 137
    Height = 277
    Align = alLeft
    BevelWidth = 0
    Indent = 19
    ReadOnly = True
    TabOrder = 1
    OnChange = TreeView1Change
    OnClick = TreeView1Click
    Items.NodeData = {
      0102000000230000000000000000000000FFFFFFFFFFFFFFFF00000000000000
      000542006100730069006300330000000000000000000000FFFFFFFFFFFFFFFF
      00000000000000000D43006F006E00660069006700750072006100740069006F
      006E00}
    Items.Utf8Data = {
      02000000210000000000000000000000FFFFFFFFFFFFFFFF0000000000000000
      08EFBBBF4261736963290000000000000000000000FFFFFFFFFFFFFFFF000000
      000000000010EFBBBF436F6E66696775726174696F6E}
  end
  object PageControl1: TTntPageControl
    Left = 140
    Top = 0
    Width = 375
    Height = 277
    ActivePage = TabSheet1
    Align = alClient
    Style = tsFlatButtons
    TabOrder = 2
    object TabSheet1: TTntTabSheet
      Caption = 'General'
      object gbRoomProps: TExGroupBox
        Left = 0
        Top = 0
        Width = 367
        Height = 17
        Align = alTop
        BevelOuter = bvNone
        Caption = '<<USER>> properties:'
        ParentColor = True
        TabOrder = 1
        AutoHide = False
      end
      object pnlJID: TTntPanel
        AlignWithMargins = True
        Left = 6
        Top = 17
        Width = 358
        Height = 21
        Margins.Left = 6
        Margins.Top = 0
        Margins.Bottom = 0
        Align = alTop
        BevelOuter = bvNone
        ParentColor = True
        TabOrder = 0
        object TntLabel4: TTntLabel
          AlignWithMargins = True
          Left = 0
          Top = 3
          Width = 51
          Height = 15
          Margins.Left = 0
          Align = alLeft
          Caption = 'Jabber ID:'
          ExplicitHeight = 13
        end
        object lblJID: TTntLabel
          AlignWithMargins = True
          Left = 57
          Top = 3
          Width = 298
          Height = 15
          Align = alClient
          Caption = 'pgmillard@jabber.org'
          ExplicitWidth = 103
          ExplicitHeight = 13
        end
      end
      object pnlSubject: TTntPanel
        AlignWithMargins = True
        Left = 6
        Top = 38
        Width = 358
        Height = 21
        Margins.Left = 6
        Margins.Top = 0
        Margins.Bottom = 0
        Align = alTop
        BevelOuter = bvNone
        ParentColor = True
        TabOrder = 2
        object TntLabel1: TTntLabel
          AlignWithMargins = True
          Left = 0
          Top = 3
          Width = 40
          Height = 15
          Margins.Left = 0
          Align = alLeft
          Caption = 'Subject:'
          ExplicitHeight = 13
        end
        object lblSubject: TTntLabel
          AlignWithMargins = True
          Left = 46
          Top = 3
          Width = 309
          Height = 15
          Align = alClient
          Caption = 'N/A'
          ExplicitWidth = 18
          ExplicitHeight = 13
        end
      end
      object pnlAffiliation: TTntPanel
        AlignWithMargins = True
        Left = 6
        Top = 101
        Width = 358
        Height = 21
        Margins.Left = 6
        Margins.Top = 0
        Margins.Bottom = 0
        Align = alTop
        BevelOuter = bvNone
        ParentColor = True
        TabOrder = 3
        ExplicitTop = 59
        object TntLabel3: TTntLabel
          AlignWithMargins = True
          Left = 0
          Top = 3
          Width = 66
          Height = 15
          Margins.Left = 0
          Align = alLeft
          Caption = 'My Affiliation:'
          ExplicitHeight = 13
        end
        object lblAffiliation: TTntLabel
          AlignWithMargins = True
          Left = 72
          Top = 3
          Width = 283
          Height = 15
          Align = alClient
          Caption = 'N/A'
          ExplicitLeft = 55
          ExplicitWidth = 18
          ExplicitHeight = 13
        end
      end
      object pnlRole: TTntPanel
        AlignWithMargins = True
        Left = 6
        Top = 122
        Width = 358
        Height = 21
        Margins.Left = 6
        Margins.Top = 0
        Margins.Bottom = 0
        Align = alTop
        BevelOuter = bvNone
        ParentColor = True
        TabOrder = 4
        ExplicitTop = 80
        object TntLabel6: TTntLabel
          AlignWithMargins = True
          Left = 0
          Top = 3
          Width = 42
          Height = 15
          Margins.Left = 0
          Align = alLeft
          Caption = 'My Role:'
          ExplicitHeight = 13
        end
        object lblRole: TTntLabel
          AlignWithMargins = True
          Left = 48
          Top = 3
          Width = 307
          Height = 15
          Align = alClient
          Caption = 'N/A'
          ExplicitLeft = 31
          ExplicitWidth = 18
          ExplicitHeight = 13
        end
      end
      object pnlAutoJoin: TTntPanel
        AlignWithMargins = True
        Left = 6
        Top = 143
        Width = 358
        Height = 21
        Margins.Left = 6
        Margins.Top = 0
        Margins.Bottom = 0
        Align = alTop
        BevelOuter = bvNone
        ParentColor = True
        TabOrder = 5
        ExplicitTop = 101
        object chkAutoJoin: TTntCheckBox
          Left = 0
          Top = 0
          Width = 329
          Height = 21
          Align = alLeft
          Caption = 'Auto Join'
          TabOrder = 0
          OnClick = chkAutoJoinClick
        end
      end
      object pnlOccupants: TTntPanel
        AlignWithMargins = True
        Left = 6
        Top = 59
        Width = 358
        Height = 21
        Margins.Left = 6
        Margins.Top = 0
        Margins.Bottom = 0
        Align = alTop
        BevelOuter = bvNone
        ParentColor = True
        TabOrder = 6
        ExplicitTop = 80
        object TntLabel2: TTntLabel
          AlignWithMargins = True
          Left = 0
          Top = 3
          Width = 55
          Height = 15
          Margins.Left = 0
          Align = alLeft
          Caption = 'Occupants:'
          ExplicitHeight = 13
        end
        object lblOccupants: TTntLabel
          AlignWithMargins = True
          Left = 61
          Top = 3
          Width = 294
          Height = 15
          Align = alClient
          Caption = 'N/A'
          ExplicitLeft = 31
          ExplicitWidth = 18
          ExplicitHeight = 13
        end
      end
      object pnlNick: TTntPanel
        AlignWithMargins = True
        Left = 6
        Top = 80
        Width = 358
        Height = 21
        Margins.Left = 6
        Margins.Top = 0
        Margins.Bottom = 0
        Align = alTop
        BevelOuter = bvNone
        ParentColor = True
        TabOrder = 7
        ExplicitTop = 0
        ExplicitWidth = 349
        object TntLabel5: TTntLabel
          AlignWithMargins = True
          Left = 0
          Top = 3
          Width = 66
          Height = 15
          Margins.Left = 0
          Align = alLeft
          Caption = 'My Nickname:'
          ExplicitHeight = 13
        end
        object lblNickname: TTntLabel
          AlignWithMargins = True
          Left = 72
          Top = 3
          Width = 283
          Height = 15
          Align = alClient
          Caption = 'N/A'
          ExplicitLeft = 61
          ExplicitWidth = 18
          ExplicitHeight = 13
        end
      end
    end
    object TabSheet2: TTntTabSheet
      Caption = 'Configuration'
      object gbConfiguration: TExGroupBox
        Left = 0
        Top = 0
        Width = 367
        Height = 17
        Align = alTop
        BevelOuter = bvNone
        Caption = '<<USER>> configuration:'
        ParentColor = True
        TabOrder = 0
        AutoHide = False
      end
      object pnlFeatureList: TTntPanel
        Left = 0
        Top = 38
        Width = 367
        Height = 208
        Margins.Left = 6
        Margins.Top = 0
        Margins.Bottom = 0
        Align = alClient
        BevelOuter = bvNone
        TabOrder = 1
        ExplicitLeft = 48
        ExplicitTop = 96
        ExplicitWidth = 185
        ExplicitHeight = 41
        object lbConfiguration: TTntListBox
          Left = 0
          Top = 0
          Width = 367
          Height = 208
          Align = alClient
          ItemHeight = 13
          TabOrder = 0
          ExplicitLeft = -1
          ExplicitTop = -2
        end
      end
      object TntPanel1: TTntPanel
        AlignWithMargins = True
        Left = 6
        Top = 17
        Width = 358
        Height = 21
        Margins.Left = 6
        Margins.Top = 0
        Margins.Bottom = 0
        Align = alTop
        BevelOuter = bvNone
        ParentColor = True
        TabOrder = 2
        object TntLabel7: TTntLabel
          AlignWithMargins = True
          Left = 0
          Top = 3
          Width = 58
          Height = 15
          Margins.Left = 0
          Align = alLeft
          Caption = 'Feature list:'
          ExplicitHeight = 13
        end
      end
    end
  end
end
