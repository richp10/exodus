inherited ManageKeywordsDlg: TManageKeywordsDlg
  BorderStyle = bsDialog
  Caption = 'Manage Keywords'
  ClientHeight = 447
  ClientWidth = 661
  ParentFont = True
  OnCreate = TntFormCreate
  ExplicitWidth = 667
  ExplicitHeight = 485
  PixelsPerInch = 120
  TextHeight = 16
  object pnlVerbiage: TExBrandPanel
    AlignWithMargins = True
    Left = 3
    Top = 3
    Width = 655
    Height = 85
    Align = alTop
    AutoSize = True
    BevelOuter = bvNone
    ParentColor = True
    TabOrder = 0
    AutoHide = True
    object TntLabel1: TTntLabel
      AlignWithMargins = True
      Left = 0
      Top = 3
      Width = 652
      Height = 32
      Margins.Left = 0
      Align = alTop
      Caption = 
        'You can be notified when a keyword appears in conference room. E' +
        'nter in the keywords that you want to look for in messages.'
      WordWrap = True
    end
    object Label1: TTntLabel
      AlignWithMargins = True
      Left = 0
      Top = 66
      Width = 652
      Height = 16
      Margins.Left = 0
      Align = alTop
      Caption = 'The following characters should not be used: ( ) [ ] * + \ ?.'
      ExplicitWidth = 341
    end
    object chkRegex: TTntCheckBox
      AlignWithMargins = True
      Left = 0
      Top = 41
      Width = 652
      Height = 19
      Margins.Left = 0
      Align = alTop
      Caption = 'Use Regular Expressions for Keyword matches'
      TabOrder = 0
      ExplicitTop = 47
    end
  end
  object ExBrandPanel1: TExBrandPanel
    AlignWithMargins = True
    Left = 3
    Top = 94
    Width = 655
    Height = 294
    Align = alTop
    BevelOuter = bvNone
    ParentColor = True
    TabOrder = 1
    AutoHide = True
    ExplicitTop = 103
    object memKeywords: TTntMemo
      Left = 0
      Top = 0
      Width = 655
      Height = 294
      Align = alClient
      TabOrder = 0
      OnKeyPress = memKeywordsKeyPress
    end
  end
  object btnOK: TTntButton
    Left = 466
    Top = 414
    Width = 88
    Height = 29
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 2
    OnClick = btnOKClick
  end
  object btnCancel: TTntButton
    Left = 563
    Top = 414
    Width = 87
    Height = 29
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 3
  end
end
