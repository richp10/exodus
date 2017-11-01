inherited frmRosterWindow: TfrmRosterWindow
  Left = 271
  Top = 186
  AlphaBlendValue = 220
  BorderIcons = [biSystemMenu, biMinimize]
  Caption = 'contact list - Exodus'
  ClientHeight = 502
  ClientWidth = 238
  Constraints.MinWidth = 130
  DefaultMonitor = dmDesktop
  DragKind = dkDock
  OnActivate = FormActivate
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnResize = FormResize
  ExplicitWidth = 246
  ExplicitHeight = 536
  PixelsPerInch = 96
  TextHeight = 13
  object imgAd: TImage
    Left = 0
    Top = 472
    Width = 238
    Height = 9
    Align = alBottom
    AutoSize = True
    Center = True
    ParentShowHint = False
    ShowHint = False
    Transparent = True
    Visible = False
    OnClick = imgAdClick
  end
  object pnlFind: TPanel
    Left = 0
    Top = 0
    Width = 238
    Height = 49
    Align = alTop
    BevelOuter = bvNone
    ParentColor = True
    TabOrder = 4
    Visible = False
    object lblFind: TTntLabel
      Left = 3
      Top = 4
      Width = 24
      Height = 13
      Caption = 'Find:'
    end
    object btnFindClose: TSpeedButton
      Left = 163
      Top = 2
      Width = 22
      Height = 21
      Caption = 'X'
      Flat = True
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = btnFindCloseClick
    end
    object txtFind: TTntEdit
      Left = 56
      Top = 1
      Width = 101
      Height = 21
      Hint = 'Esc to quit, Enter to select current,  F3 to search again'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      OnChange = txtFindChange
      OnKeyUp = txtFindKeyUp
    end
    object radJID: TTntRadioButton
      Left = 54
      Top = 25
      Width = 41
      Height = 17
      Caption = 'JID'
      TabOrder = 1
    end
    object radNick: TTntRadioButton
      Left = 102
      Top = 25
      Width = 80
      Height = 17
      Caption = 'Nickname'
      Checked = True
      TabOrder = 2
      TabStop = True
    end
  end
  object StatBar: TStatusBar
    Left = 0
    Top = 481
    Width = 238
    Height = 21
    Panels = <
      item
        Alignment = taCenter
        Text = 'foo@jabber.org'
        Width = 50
      end>
    ParentColor = True
    ParentFont = True
    UseSystemFont = False
  end
  object pnlShow: TPanel
    Left = 0
    Top = 447
    Width = 238
    Height = 25
    Align = alBottom
    BevelOuter = bvNone
    BorderWidth = 2
    ParentColor = True
    TabOrder = 1
    Visible = False
    object imgStatus: TPaintBox
      Left = 2
      Top = 2
      Width = 23
      Height = 21
      Align = alLeft
      ParentShowHint = False
      ShowHint = True
      OnPaint = imgStatusPaint
    end
    object imgSSL: TImage
      Left = 220
      Top = 2
      Width = 19
      Height = 21
      Align = alRight
      Center = True
      Picture.Data = {
        07544269746D617036030000424D360300000000000036000000280000001000
        0000100000000100180000000000000300000000000000000000000000000000
        000080FFFF80FFFF80FFFF80FFFF80FFFF80FFFF80FFFF80FFFF80FFFF80FFFF
        80FFFF80FFFF80FFFF80FFFF80FFFF80FFFF80FFFF80FFFF80FFFF80FFFF80FF
        FF80FFFF80FFFF80FFFF80FFFF80FFFF80FFFF80FFFF80FFFF80FFFF80FFFF80
        FFFF80FFFF2699D0007DC2007DC2007DC2007DC2007DC200629B00629B00629B
        00629B00478900478900478980FFFF80FFFF80FFFF08A5EF4ACEFF4ACEFF4ACE
        FF15B4FD15B4FD15B4FD15B4FD15B4FD15B4FD15B4FD0799DE00478980FFFF80
        FFFF80FFFF08A5EF4ACEFF15B4FD15B4FD15B4FD15B4FD15B4FD15B4FD0799DE
        0799DE067EB7067EB700478980FFFF80FFFF80FFFF08A5EF4ACEFF4ACEFF4ACE
        FF4ACEFF15B4FD15B4FD15B4FD15B4FD15B4FD15B4FD15B4FD00478980FFFF80
        FFFF80FFFF08A5EF4ACEFF15B4FD15B4FD15B4FD15B4FD15B4FD15B4FD15B4FD
        15B4FD0799DE067EB700478980FFFF80FFFF80FFFF08A5EF4ACEFF4ACEFF4ACE
        FF4ACEFF4ACEFF15B4FD15B4FD15B4FD00B5FF15B4FD15B4FD00478980FFFF80
        FFFF80FFFF08A5EF08A5EF08A5EF08A5EF0799DE0799DE0799DE0799DE067EB7
        067EB7067EB7067EB700629B80FFFF80FFFF80FFFF80FFFF90917ADFE1BD7576
        5F80FFFF80FFFF80FFFF80FFFF80FFFF90917AC9CBAB75765F80FFFF80FFFF80
        FFFF80FFFF80FFFFA6A883EBEDC775765F80FFFF80FFFF80FFFF80FFFF80FFFF
        90917AC9CBAB75765F80FFFF80FFFF80FFFF80FFFF80FFFFAFB370EBEDC79498
        5580FFFF80FFFF80FFFF80FFFF80FFFF90917ADFE1BD75765F80FFFF80FFFF80
        FFFF80FFFF80FFFFAFB370EBEDC7C4C6A294985575765F75765F75765F90917A
        EBEDC7DFE1BD90917A80FFFF80FFFF80FFFF80FFFF80FFFF80FFFFAFB370EBED
        C7EBEDC7EBEDC7EBEDC7EBEDC7EBEDC7DFE1BD90917A80FFFF80FFFF80FFFF80
        FFFF80FFFF80FFFF80FFFF80FFFFAFB370AFB370A9AC78A9AC7890917A90917A
        90917A80FFFF80FFFF80FFFF80FFFF80FFFF80FFFF80FFFF80FFFF80FFFF80FF
        FF80FFFF80FFFF80FFFF80FFFF80FFFF80FFFF80FFFF80FFFF80FFFF80FFFF80
        FFFF}
      Transparent = True
      Visible = False
    end
    object pnlStatus: TTntPanel
      Left = 25
      Top = 2
      Width = 195
      Height = 21
      Cursor = crArrow
      Align = alClient
      Alignment = taLeftJustify
      AutoSize = True
      BevelOuter = bvNone
      BevelWidth = 0
      ParentColor = True
      TabOrder = 0
      object lblStatusLink: TTntLabel
        Left = 0
        Top = 0
        Width = 32
        Height = 13
        Cursor = crHandPoint
        Align = alLeft
        Caption = 'Offline'
        Transparent = False
        Layout = tlCenter
        OnClick = pnlStatusClick
      end
    end
  end
  object pnlConnect: TPanel
    Left = 0
    Top = 49
    Width = 238
    Height = 296
    Align = alTop
    BevelOuter = bvLowered
    BorderWidth = 4
    Ctl3D = True
    ParentBackground = False
    ParentColor = True
    ParentCtl3D = False
    TabOrder = 2
    object lblStatus: TTntLabel
      Left = 5
      Top = 49
      Width = 228
      Height = 32
      Align = alTop
      Alignment = taCenter
      AutoSize = False
      Caption = 'You are currently disconnected.'
      Transparent = False
      Layout = tlCenter
      WordWrap = True
      ExplicitLeft = 4
      ExplicitTop = 48
      ExplicitWidth = 230
    end
    object lblConnect: TTntLabel
      Left = 5
      Top = 81
      Width = 228
      Height = 23
      Cursor = crHandPoint
      Align = alTop
      Alignment = taCenter
      AutoSize = False
      Caption = 'Click a profile to connect'
      Transparent = False
      Layout = tlCenter
      WordWrap = True
      OnClick = lblConnectClick
      ExplicitLeft = 4
      ExplicitTop = 80
      ExplicitWidth = 230
    end
    object pnlAnimation: TPanel
      Left = 5
      Top = 5
      Width = 228
      Height = 44
      Align = alTop
      BevelOuter = bvNone
      ParentColor = True
      TabOrder = 0
      ExplicitLeft = 4
      ExplicitTop = 4
      ExplicitWidth = 230
      object aniWait: TAnimate
        Left = 48
        Top = 3
        Width = 30
        Height = 30
        Color = clWhite
        ParentColor = False
        StopFrame = 12
        Visible = False
      end
    end
    object lstProfiles: TTntListView
      Left = 5
      Top = 104
      Width = 228
      Height = 37
      Align = alClient
      BorderStyle = bsNone
      Columns = <
        item
          AutoSize = True
        end>
      HotTrackStyles = [htHandPoint, htUnderlineHot]
      ParentColor = True
      ParentShowHint = False
      PopupMenu = popProfiles
      ShowColumnHeaders = False
      ShowHint = False
      SmallImages = frmExodus.ImageList1
      TabOrder = 1
      ViewStyle = vsReport
      OnClick = lblConnectClick
      OnDblClick = lblConnectClick
      OnInfoTip = lstProfilesInfoTip
      OnKeyPress = lstProfilesKeyPress
      OnSelectItem = lstProfilesSelectItem
      ExplicitLeft = 4
      ExplicitTop = 103
      ExplicitWidth = 230
      ExplicitHeight = 40
    end
    object pnlConnectLogo: TPanel
      Left = 5
      Top = 141
      Width = 228
      Height = 150
      Align = alBottom
      BevelOuter = bvNone
      ParentColor = True
      TabOrder = 2
      OnResize = pnlConnectLogoResize
      ExplicitLeft = 4
      ExplicitTop = 143
      ExplicitWidth = 230
      object ImageLogo: TImage
        Left = 0
        Top = 0
        Width = 228
        Height = 33
        Align = alTop
        Center = True
        ExplicitWidth = 230
      end
      object lblNewUser: TTntLabel
        Left = 0
        Top = 124
        Width = 228
        Height = 13
        Cursor = crHandPoint
        Align = alBottom
        Caption = 'Run the New User Wizard'
        Transparent = False
        OnClick = lblNewUserClick
        ExplicitWidth = 123
      end
      object lblCreate: TTntLabel
        Left = 0
        Top = 137
        Width = 228
        Height = 13
        Cursor = crHandPoint
        Align = alBottom
        Caption = 'Create a New Profile'
        Transparent = False
        OnClick = lblCreateClick
        ExplicitWidth = 99
      end
      object txtDisclaimer: TExRichEdit
        Left = 0
        Top = 33
        Width = 228
        Height = 40
        Align = alTop
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
        LangOptions = [loAutoFont]
        Language = 1033
        ParentColor = True
        ReadOnly = True
        ScrollBars = ssVertical
        ShowSelectionBar = False
        TabOrder = 0
        URLColor = clBlue
        URLCursor = crHandPoint
        OnURLClick = txtDisclaimerURLClick
        InputFormat = ifRTF
        OutputFormat = ofRTF
        SelectedInOut = False
        PlainRTF = False
        UndoLimit = 0
        AllowInPlace = False
      end
    end
  end
  object treeRoster: TTntTreeView
    Left = 0
    Top = 345
    Width = 238
    Height = 102
    Cursor = crArrow
    Hint = 'Contact List Hint'
    Align = alClient
    BevelInner = bvNone
    BevelOuter = bvNone
    Ctl3D = True
    DragMode = dmAutomatic
    HideSelection = False
    Images = frmExodus.ImageList1
    Indent = 19
    MultiSelect = True
    MultiSelectStyle = [msControlSelect, msShiftSelect, msVisibleOnly]
    ParentCtl3D = False
    ParentShowHint = False
    PopupMenu = popRoster
    RowSelect = True
    ShowButtons = False
    ShowHint = True
    ShowLines = False
    ShowRoot = False
    SortType = stData
    TabOrder = 0
    ToolTips = False
    Visible = False
    OnChange = treeRosterChange
    OnCollapsed = treeRosterCollapsed
    OnCompare = treeRosterCompare
    OnContextPopup = treeRosterContextPopup
    OnCustomDrawItem = treeRosterCustomDrawItem
    OnDblClick = treeRosterDblClick
    OnDragDrop = treeRosterDragDrop
    OnDragOver = treeRosterDragOver
    OnEditing = treeRosterEditing
    OnEndDrag = treeRosterEndDrag
    OnExit = treeRosterExit
    OnExpanded = treeRosterExpanded
    OnKeyPress = treeRosterKeyPress
    OnMouseDown = treeRosterMouseDown
    OnMouseMove = treeRosterMouseMove
    OnMouseUp = treeRosterMouseUp
    OnStartDrag = treeRosterStartDrag
  end
  object popRoster: TTntPopupMenu
    AutoHotkeys = maManual
    OnPopup = popRosterPopup
    Left = 8
    Top = 344
    object popChat: TTntMenuItem
      Caption = 'Chat...'
      OnClick = popChatClick
    end
    object popMsg: TTntMenuItem
      Caption = 'Send Message...'
      OnClick = popMsgClick
    end
    object popHistory: TTntMenuItem
      Caption = 'View History...'
      OnClick = popHistoryClick
    end
    object popSendFile: TTntMenuItem
      Caption = 'Send File...'
      OnClick = popSendFileClick
    end
    object popInvite: TTntMenuItem
      Caption = 'Invite to Conference...'
      OnClick = popInviteClick
    end
    object popSendContacts: TTntMenuItem
      Caption = 'Send Contact To...'
      OnClick = popSendContactsClick
    end
    object popClientInfo: TTntMenuItem
      Caption = 'Client Info'
      object popVersion: TTntMenuItem
        Caption = 'Version Request'
        OnClick = popVersionClick
      end
      object popTime: TTntMenuItem
        Caption = 'Time Request'
        OnClick = popVersionClick
      end
      object popLast: TTntMenuItem
        Caption = 'Last Activity'
        OnClick = popVersionClick
      end
    end
    object popPresence: TTntMenuItem
      Caption = 'Presence'
      object popSendPres: TTntMenuItem
        Caption = 'Send Visible'
        Visible = False
        OnClick = popSendPresClick
      end
      object popSendInvisible: TTntMenuItem
        Caption = 'Send Invisible'
        Visible = False
        OnClick = popSendPresClick
      end
      object N2: TTntMenuItem
        Caption = '-'
        Visible = False
      end
      object popSendSubscribe: TTntMenuItem
        Caption = 'Subscribe Again'
        OnClick = popSendSubscribeClick
      end
    end
    object popRename: TTntMenuItem
      Caption = 'Rename Contact...'
      OnClick = popRenameClick
    end
    object N1: TTntMenuItem
      Caption = '-'
    end
    object popBlock: TTntMenuItem
      Caption = 'Block Contact'
      OnClick = popBlockClick
    end
    object popRemove: TTntMenuItem
      Caption = 'Delete Contact'
      OnClick = popRemoveClick
    end
    object popProperties: TTntMenuItem
      Caption = 'Contact Properties...'
      OnClick = popPropertiesClick
    end
    object N7: TTntMenuItem
      Caption = '-'
    end
  end
  object popStatus: TTntPopupMenu
    AutoHotkeys = maManual
    Images = frmExodus.ImageList1
    Left = 8
    Top = 376
    object presOnline: TTntMenuItem
      Caption = 'Available'
      ImageIndex = 1
      OnClick = presDNDClick
    end
    object presChat: TTntMenuItem
      Tag = 1
      Caption = 'Free to Chat'
      ImageIndex = 4
      OnClick = presDNDClick
    end
    object presAway: TTntMenuItem
      Tag = 2
      Caption = 'Away'
      ImageIndex = 2
      OnClick = presDNDClick
    end
    object presXA: TTntMenuItem
      Tag = 3
      Caption = 'Xtended Away'
      ImageIndex = 10
      OnClick = presDNDClick
    end
    object presDND: TTntMenuItem
      Tag = 4
      Caption = 'Do Not Disturb'
      ImageIndex = 3
      OnClick = presDNDClick
    end
    object N8: TTntMenuItem
      Tag = 99
      Caption = '-'
    end
    object Custom1: TTntMenuItem
      Tag = 99
      Caption = 'Custom ...'
      OnClick = presCustomClick
    end
    object N11: TTntMenuItem
      Tag = 99
      Caption = '-'
    end
  end
  object ImageList1: TImageList
    BkColor = clWhite
    ShareImages = True
    Left = 104
    Top = 410
    Bitmap = {
      494C010102000400040010001000FFFFFF00FF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000001000000001002000000000000010
      000000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF0000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF0000000000848484008484840084848400848484008484840000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00000000008484840000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF000000000084848400848484008484840000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF000000000084848400848484008484840000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00000000008484840000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF0000000000848484008484840084848400848484008484840000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF0000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000100000000100010000000000800000000000000000000000
      000000000000000000000000FFFFFF00FFFFFFFF00000000FFFFFFFF00000000
      FFFFFFFF00000000FFFFFFFF00000000FFFFFFFF00000000FFFFE00F00000000
      FEFFF01F00000000FC7FF83F00000000F83FFC7F00000000F01FFEFF00000000
      E00FFFFF00000000FFFFFFFF00000000FFFFFFFF00000000FFFFFFFF00000000
      FFFFFFFF00000000FFFFFFFF0000000000000000000000000000000000000000
      000000000000}
  end
  object popActions: TTntPopupMenu
    AutoHotkeys = maManual
    Left = 40
    Top = 344
    object popAddContact: TTntMenuItem
      Caption = 'Add Contact'
      OnClick = popAddContactClick
    end
    object popAddGroup: TTntMenuItem
      Caption = 'Add Group'
      OnClick = popAddGroupClick
    end
    object N9: TTntMenuItem
      Caption = '-'
    end
  end
  object popGroup: TTntPopupMenu
    AutoHotkeys = maManual
    Left = 40
    Top = 376
    object popGrpPresence: TTntMenuItem
      Caption = 'Send Presence'
      object popGrpAvailable: TTntMenuItem
        Caption = 'Visible'
        OnClick = popSendPresClick
      end
      object popGrpInvisible: TTntMenuItem
        Caption = 'Invisible'
        OnClick = popSendPresClick
      end
    end
    object popGrpInvite: TTntMenuItem
      Caption = 'Invite to Conference'
      OnClick = popGrpInviteClick
    end
    object BroadcastMessage1: TTntMenuItem
      Caption = 'Send Message'
      OnClick = BroadcastMessage1Click
    end
    object SendContactsTo1: TTntMenuItem
      Caption = 'Send Contacts To...'
      OnClick = popSendContactsClick
    end
    object MoveorCopyContacts1: TTntMenuItem
      Caption = 'Move or Copy Contacts...'
      OnClick = MoveorCopyContacts1Click
    end
    object N3: TTntMenuItem
      Caption = '-'
    end
    object popGroupBlock: TTntMenuItem
      Caption = 'Block Group'
      OnClick = popBlockClick
    end
    object popGroupUnBlock: TTntMenuItem
      Caption = 'UnBlock Group'
    end
    object N15: TTntMenuItem
      Caption = '-'
    end
    object popGrpRename: TTntMenuItem
      Caption = 'Rename Group'
      OnClick = popGrpRenameClick
    end
    object popGrpRemove: TTntMenuItem
      Caption = 'Delete Group'
      OnClick = popGrpRemoveClick
    end
    object N4: TTntMenuItem
      Caption = '-'
    end
    object NewGroup1: TTntMenuItem
      Caption = 'New Group'
      OnClick = popAddGroupClick
    end
    object N12: TTntMenuItem
      Caption = '-'
    end
  end
  object popBookmark: TTntPopupMenu
    AutoHotkeys = maManual
    Left = 8
    Top = 408
    object Join1: TTntMenuItem
      Caption = 'Join Group'
      OnClick = treeRosterDblClick
    end
    object N5: TTntMenuItem
      Caption = '-'
    end
    object Delete1: TTntMenuItem
      Caption = 'Remove'
      ShortCut = 46
      OnClick = popRemoveClick
    end
    object Properties1: TTntMenuItem
      Caption = 'Properties'
      OnClick = popPropertiesClick
    end
    object N13: TTntMenuItem
      Caption = '-'
    end
  end
  object popTransport: TTntPopupMenu
    AutoHotkeys = maManual
    Left = 40
    Top = 408
    object popTransLogoff: TTntMenuItem
      Caption = 'Log Off'
      OnClick = popTransLogoffClick
    end
    object popTransLogon: TTntMenuItem
      Caption = 'Log On'
      OnClick = popTransLogoffClick
    end
    object N6: TTntMenuItem
      Caption = '-'
    end
    object popTransProperties: TTntMenuItem
      Caption = 'Rename ...'
      OnClick = popRenameClick
    end
    object popTransEdit: TTntMenuItem
      Caption = 'Properties ...'
      OnClick = popTransEditClick
    end
    object popTransUnRegister: TTntMenuItem
      Caption = 'Remove'
      OnClick = popTransUnRegisterClick
    end
    object N14: TTntMenuItem
      Caption = '-'
    end
  end
  object autoScroll: TTimer
    Enabled = False
    Interval = 100
    OnTimer = autoScrollTimer
    Left = 72
    Top = 408
  end
  object popProfiles: TTntPopupMenu
    Left = 72
    Top = 344
    object ModifyProfile1: TTntMenuItem
      Caption = 'Modify Profile'
      OnClick = lblModifyClick
    end
    object RenameProfile1: TTntMenuItem
      Caption = 'Rename Profile'
      OnClick = RenameProfile1Click
    end
    object DeleteProfile1: TTntMenuItem
      Caption = 'Delete Profile'
      OnClick = lblDeleteClick
    end
    object N10: TTntMenuItem
      Caption = '-'
    end
  end
  object popBookmarkGrp: TTntPopupMenu
    Left = 72
    Top = 376
    object JoinAllRooms1: TTntMenuItem
      Caption = 'Join All Rooms'
      OnClick = JoinAllRooms1Click
    end
    object N16: TTntMenuItem
      Caption = '-'
    end
  end
end
