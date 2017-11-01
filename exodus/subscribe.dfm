inherited frmSubscribe: TfrmSubscribe
  Left = 250
  Top = 165
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  BorderWidth = 3
  Caption = 'Subscription Request'
  ClientHeight = 216
  ClientWidth = 328
  Position = poMainFormCenter
  OnClose = FormClose
  ExplicitWidth = 340
  ExplicitHeight = 248
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TTntLabel
    Left = 0
    Top = 35
    Width = 328
    Height = 26
    Align = alTop
    Caption = 
      'This person or agent would like to see your online presence and ' +
      'add you to their contact list.'
    WordWrap = True
    ExplicitWidth = 326
  end
  object Bevel1: TBevel
    Left = 0
    Top = 33
    Width = 328
    Height = 2
    Align = alTop
  end
  object chkSubscribe: TTntCheckBox
    Left = 8
    Top = 69
    Width = 217
    Height = 17
    Caption = 'Add this person to my contact list'
    Checked = True
    State = cbChecked
    TabOrder = 0
    OnClick = chkSubscribeClick
  end
  object boxAdd: TGroupBox
    Left = 24
    Top = 88
    Width = 301
    Height = 81
    TabOrder = 1
    object lblNickname: TTntLabel
      Left = 8
      Top = 19
      Width = 49
      Height = 13
      Caption = 'Nickname:'
    end
    object lblGroup: TTntLabel
      Left = 8
      Top = 51
      Width = 33
      Height = 13
      Caption = 'Group:'
    end
    object txtNickname: TTntEdit
      Left = 70
      Top = 17
      Width = 221
      Height = 21
      TabOrder = 0
    end
    object cboGroup: TTntComboBox
      Left = 70
      Top = 47
      Width = 221
      Height = 21
      ItemHeight = 13
      Sorted = True
      TabOrder = 1
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 328
    Height = 33
    Align = alTop
    BevelOuter = bvNone
    ParentColor = True
    TabOrder = 2
    object imgIdent: TImage
      Left = 0
      Top = 0
      Width = 33
      Height = 33
      Align = alLeft
      Center = True
      Transparent = True
    end
    object lblJID: TTntLabel
      Left = 33
      Top = 0
      Width = 295
      Height = 33
      Cursor = crHandPoint
      Align = alClient
      AutoSize = False
      Caption = 'lblJID'
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlue
      Font.Height = -15
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsUnderline]
      ParentFont = False
      Transparent = False
      Layout = tlCenter
      OnClick = lblJIDClick
    end
  end
  object pnlButtons: TTntPanel
    Left = 0
    Top = 179
    Width = 328
    Height = 37
    Align = alBottom
    BevelOuter = bvNone
    ParentColor = True
    TabOrder = 3
    ExplicitTop = 184
    object TntBevel1: TTntBevel
      Left = 0
      Top = 0
      Width = 328
      Height = 50
      Align = alTop
      Shape = bsTopLine
      ExplicitLeft = -1
    end
    object btnAccept: TTntButton
      Left = 88
      Top = 9
      Width = 75
      Height = 25
      Caption = '&Accept'
      Default = True
      ModalResult = 1
      TabOrder = 0
      OnClick = frameButtons1btnOKClick
    end
    object btnDeny: TTntButton
      Left = 169
      Top = 9
      Width = 75
      Height = 25
      Cancel = True
      Caption = '&Deny'
      ModalResult = 2
      TabOrder = 1
      OnClick = frameButtons1btnCancelClick
    end
    object btnBlock: TTntButton
      Left = 250
      Top = 9
      Width = 75
      Height = 25
      Caption = '&Block'
      TabOrder = 2
      OnClick = btnBlockClick
    end
  end
  object PopupMenu1: TTntPopupMenu
    Left = 208
    Top = 56
    object mnuProfile: TTntMenuItem
      Caption = 'Show Profile'
      OnClick = mnuProfileClick
    end
    object mnuChat: TTntMenuItem
      Caption = 'Start Chat'
      OnClick = mnuChatClick
    end
  end
end
