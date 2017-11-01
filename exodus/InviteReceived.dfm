inherited frmInviteReceived: TfrmInviteReceived
  AutoSize = True
  BorderStyle = bsDialog
  Caption = 'Conference Room Invitation'
  ClientHeight = 160
  ClientWidth = 436
  DefaultMonitor = dmMainForm
  Position = poDefault
  OnClose = TntFormClose
  OnCreate = TntFormCreate
  OnDestroy = TntFormDestroy
  OnShow = TntFormShow
  ExplicitWidth = 442
  ExplicitHeight = 186
  PixelsPerInch = 96
  TextHeight = 13
  object pnlHeader: TFlowPanel
    AlignWithMargins = True
    Left = 9
    Top = 9
    Width = 418
    Height = 16
    Margins.Left = 9
    Margins.Top = 9
    Margins.Right = 9
    Align = alTop
    AutoSize = True
    BevelOuter = bvNone
    ParentColor = True
    TabOrder = 0
    object lblInvitor: TTntLabel
      AlignWithMargins = True
      Left = 6
      Top = 0
      Width = 59
      Height = 13
      Margins.Left = 6
      Margins.Top = 0
      Align = alLeft
      Caption = '<<Name>>'
      ParentShowHint = False
      ShowHint = True
      OnClick = lblInvitorClick
    end
    object lblFiller1: TTntLabel
      Left = 68
      Top = 0
      Width = 131
      Height = 13
      Align = alLeft
      Caption = ' has invited you to join the '
    end
    object lblRoom: TTntLabel
      Left = 199
      Top = 0
      Width = 59
      Height = 13
      Align = alLeft
      Caption = '<<Room>>'
      Constraints.MaxWidth = 435
      ParentShowHint = False
      ShowAccelChar = False
      ShowHint = True
    end
    object TntLabel1: TTntLabel
      Left = 258
      Top = 0
      Width = 88
      Height = 13
      Caption = ' conference room.'
    end
  end
  object TntPanel4: TTntPanel
    AlignWithMargins = True
    Left = 3
    Top = 126
    Width = 430
    Height = 28
    Margins.Top = 12
    Margins.Bottom = 6
    Align = alTop
    AutoSize = True
    BevelOuter = bvNone
    ParentColor = True
    TabOrder = 1
    object btnAccept: TTntButton
      Left = 210
      Top = 0
      Width = 68
      Height = 28
      Caption = '&Join'
      Default = True
      TabOrder = 0
      OnClick = btnAcceptClick
    end
    object btnDecline: TTntButton
      Left = 284
      Top = 0
      Width = 68
      Height = 28
      Caption = '&Decline'
      TabOrder = 1
      OnClick = btnDeclineClick
    end
    object btnIgnore: TTntButton
      Left = 359
      Top = 0
      Width = 68
      Height = 28
      Margins.Right = 6
      Caption = '&Ignore'
      TabOrder = 2
      OnClick = btnIgnoreClick
    end
  end
  object ExGroupBox1: TExGroupBox
    AlignWithMargins = True
    Left = 24
    Top = 37
    Width = 406
    Height = 31
    Margins.Left = 24
    Margins.Top = 9
    Margins.Right = 6
    Margins.Bottom = 9
    Align = alTop
    AutoSize = True
    BevelOuter = bvNone
    Caption = 'Invitation message:'
    ParentColor = True
    TabOrder = 2
    AutoHide = False
    object lblInviteMessage: TTntLabel
      Left = 0
      Top = 18
      Width = 406
      Height = 13
      Align = alTop
      Caption = 'No message was specified'
      Transparent = True
      WordWrap = True
      ExplicitWidth = 125
    end
  end
  object ExGroupBox2: TExGroupBox
    AlignWithMargins = True
    Left = 24
    Top = 77
    Width = 406
    Height = 37
    Margins.Left = 24
    Margins.Top = 0
    Margins.Right = 6
    Margins.Bottom = 0
    Align = alTop
    AutoSize = True
    BevelOuter = bvNone
    Caption = '&Reason for declining:'
    ParentColor = True
    TabOrder = 3
    AutoHide = False
    object txtReason: TTntEdit
      Left = 0
      Top = 18
      Width = 406
      Height = 19
      Margins.Left = 24
      Margins.Right = 24
      Align = alTop
      AutoSize = False
      TabOrder = 1
      Text = 'Sorry, I'#39'm not interested in joining right now.'
    end
  end
end
