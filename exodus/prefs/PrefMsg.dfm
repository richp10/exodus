inherited frmPrefMsg: TfrmPrefMsg
  Left = 282
  Top = 230
  Caption = 'frmPrefMsg'
  ClientHeight = 491
  ClientWidth = 388
  OldCreateOrder = True
  ExplicitWidth = 400
  ExplicitHeight = 503
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnlHeader: TTntPanel
    Width = 388
    ExplicitWidth = 388
    inherited lblHeader: TTntLabel
      Left = 6
      Width = 52
      Caption = 'Message'
      ExplicitLeft = 6
      ExplicitWidth = 52
    end
  end
  object pnlContainer: TExBrandPanel
    Left = 0
    Top = 23
    Width = 319
    Height = 468
    Align = alLeft
    BevelOuter = bvNone
    ParentColor = True
    TabOrder = 1
    AutoHide = True
    object gbSubscriptions: TExGroupBox
      AlignWithMargins = True
      Left = 0
      Top = 3
      Width = 316
      Height = 112
      Margins.Left = 0
      Align = alTop
      AutoSize = True
      BevelOuter = bvNone
      Caption = 'Incoming subscription request handling'
      ParentColor = True
      TabOrder = 0
      AutoHide = True
      object chkIncomingS10nAdd: TTntCheckBox
        AlignWithMargins = True
        Left = 3
        Top = 92
        Width = 310
        Height = 17
        Margins.Top = 0
        Align = alTop
        Caption = 'Add &requestor to default contact list group when accepted'
        TabOrder = 2
      end
      object pnlS10NOpts: TExBrandPanel
        AlignWithMargins = True
        Left = 0
        Top = 21
        Width = 313
        Height = 68
        Margins.Left = 0
        Align = alTop
        AutoSize = True
        BevelOuter = bvNone
        ParentColor = True
        TabOrder = 1
        AutoHide = False
        object rbAcceptAll: TTntRadioButton
          AlignWithMargins = True
          Left = 3
          Top = 34
          Width = 307
          Height = 14
          Margins.Top = 0
          Align = alTop
          Caption = 'Auto &accept all requests'
          TabOrder = 2
          TabStop = True
        end
        object rbAcceptContacts: TTntRadioButton
          AlignWithMargins = True
          Left = 3
          Top = 17
          Width = 307
          Height = 14
          Margins.Top = 0
          Align = alTop
          Caption = 'Auto accept requests from &contacts in my contact list'
          TabOrder = 1
          TabStop = True
        end
        object rbDenyAll: TTntRadioButton
          AlignWithMargins = True
          Left = 3
          Top = 51
          Width = 307
          Height = 14
          Margins.Top = 0
          Align = alTop
          Caption = 'Auto &deny all requests'
          TabOrder = 3
          TabStop = True
        end
        object rbPromptAll: TTntRadioButton
          AlignWithMargins = True
          Left = 3
          Top = 0
          Width = 307
          Height = 14
          Margins.Top = 0
          Align = alTop
          Caption = '&Prompt for all requests'
          TabOrder = 0
          TabStop = True
        end
      end
    end
    object pnlOtherPrefs: TExGroupBox
      AlignWithMargins = True
      Left = 0
      Top = 121
      Width = 316
      Height = 52
      Margins.Left = 0
      Align = alTop
      AutoSize = True
      BevelOuter = bvNone
      Caption = 'Other message handling options'
      ParentColor = True
      TabOrder = 1
      AutoHide = True
      object chkInviteAutoJoin: TTntCheckBox
        AlignWithMargins = True
        Left = 3
        Top = 18
        Width = 310
        Height = 14
        Margins.Top = 0
        Align = alTop
        Caption = 'Automatically &join when receiving a conference invitation'
        TabOrder = 1
      end
      object chkBlockNonRoster: TTntCheckBox
        AlignWithMargins = True
        Left = 3
        Top = 35
        Width = 310
        Height = 14
        Margins.Top = 0
        Align = alTop
        Caption = '&Block messages from people not on my contact list'
        TabOrder = 2
      end
    end
    object gbAdvancedPrefs: TExGroupBox
      AlignWithMargins = True
      Left = 0
      Top = 185
      Width = 316
      Height = 38
      Margins.Left = 0
      Margins.Top = 9
      Align = alTop
      AutoSize = True
      BevelOuter = bvNone
      Caption = 'Advanced message handling options'
      ParentColor = True
      TabOrder = 2
      AutoHide = True
      object btnManageKeywords: TTntButton
        Left = 2
        Top = 18
        Width = 131
        Height = 20
        Caption = 'Manage &Keywords...'
        TabOrder = 1
        OnClick = btnManageKeywordsClick
      end
    end
  end
end
