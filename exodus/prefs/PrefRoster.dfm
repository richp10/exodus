inherited frmPrefRoster: TfrmPrefRoster
  Left = 254
  Top = 162
  Caption = 'frmPrefRoster'
  ClientHeight = 837
  ClientWidth = 458
  OldCreateOrder = True
  OnDestroy = TntFormDestroy
  ExplicitWidth = 470
  ExplicitHeight = 849
  PixelsPerInch = 120
  TextHeight = 16
  inherited pnlHeader: TTntPanel
    Width = 458
    ExplicitWidth = 458
    inherited lblHeader: TTntLabel
      Left = 6
      Width = 89
      Height = 19
      Caption = 'Contact List'
      ExplicitLeft = 6
      ExplicitWidth = 89
    end
  end
  object ExGroupBox1: TExBrandPanel
    AlignWithMargins = True
    Left = 0
    Top = 31
    Width = 434
    Height = 806
    Margins.Left = 0
    Margins.Right = 0
    Margins.Bottom = 0
    Align = alLeft
    BevelOuter = bvNone
    ParentColor = True
    TabOrder = 1
    AutoHide = True
    object pnlRosterPrefs: TExBrandPanel
      AlignWithMargins = True
      Left = 0
      Top = 66
      Width = 434
      Height = 92
      Margins.Left = 0
      Margins.Top = 6
      Margins.Right = 0
      Margins.Bottom = 0
      Align = alTop
      AutoSize = True
      BevelOuter = bvNone
      ParentColor = True
      TabOrder = 2
      AutoHide = True
      object chkInlineStatus: TTntCheckBox
        AlignWithMargins = True
        Left = 0
        Top = 0
        Width = 431
        Height = 20
        Margins.Left = 0
        Margins.Top = 0
        Align = alTop
        Caption = 'Show &contact status'
        TabOrder = 0
      end
      object chkUseProfileDN: TTntCheckBox
        AlignWithMargins = True
        Left = 0
        Top = 23
        Width = 431
        Height = 20
        Margins.Left = 0
        Margins.Top = 0
        Align = alTop
        Caption = 'Get &display name from contact profile'
        TabOrder = 1
      end
      object chkHideBlocked: TTntCheckBox
        AlignWithMargins = True
        Left = 0
        Top = 46
        Width = 431
        Height = 21
        Margins.Left = 0
        Margins.Top = 0
        Align = alTop
        Caption = '&Hide blocked contacts '
        TabOrder = 2
      end
      object chkGroupCounts: TTntCheckBox
        AlignWithMargins = True
        Left = 0
        Top = 70
        Width = 431
        Height = 19
        Margins.Left = 0
        Margins.Top = 0
        Align = alTop
        Caption = 
          'Sho&w the number of online contacts for each group (5 of 10 onli' +
          'ne)'
        TabOrder = 3
      end
    end
    object pnlManageBtn: TExBrandPanel
      AlignWithMargins = True
      Left = 0
      Top = 161
      Width = 431
      Height = 26
      Margins.Left = 0
      Align = alTop
      AutoSize = True
      BevelOuter = bvNone
      ParentColor = True
      TabOrder = 3
      AutoHide = True
      object btnManageBlocked: TTntButton
        Left = 21
        Top = 0
        Width = 194
        Height = 26
        Caption = 'Manage &Blocked Contacts...'
        TabOrder = 0
        OnClick = btnManageBlockedClick
      end
    end
    object grpAdvanced: TExGroupBox
      AlignWithMargins = True
      Left = 0
      Top = 196
      Width = 434
      Height = 130
      Margins.Left = 0
      Margins.Top = 6
      Margins.Right = 0
      Align = alTop
      AutoSize = True
      BevelOuter = bvNone
      Caption = 'Advanced contact list preferences'
      ParentColor = True
      TabOrder = 4
      AutoHide = True
      object pnlStatusColor: TExBrandPanel
        AlignWithMargins = True
        Left = 0
        Top = 21
        Width = 431
        Height = 22
        Margins.Left = 0
        Margins.Bottom = 0
        Align = alTop
        AutoSize = True
        BevelOuter = bvNone
        ParentColor = True
        TabOrder = 1
        AutoHide = True
        DesignSize = (
          431
          22)
        object lblStatusColor: TTntLabel
          Left = 0
          Top = 2
          Width = 118
          Height = 16
          Caption = 'Contact s&tatus color:'
        end
        object cboStatusColor: TColorBox
          Left = 183
          Top = 0
          Width = 224
          Height = 22
          DefaultColorColor = clBlue
          Selected = clBlue
          Style = [cbStandardColors, cbExtendedColors, cbSystemColors, cbIncludeDefault, cbCustomColor, cbPrettyNames]
          Anchors = [akLeft, akTop, akRight]
          DropDownCount = 12
          ItemHeight = 16
          TabOrder = 0
        end
      end
      object pnlDNFields: TExBrandPanel
        AlignWithMargins = True
        Left = 0
        Top = 46
        Width = 431
        Height = 24
        Margins.Left = 0
        Margins.Bottom = 0
        Align = alTop
        AutoSize = True
        BevelOuter = bvNone
        ParentColor = True
        TabOrder = 2
        AutoHide = True
        DesignSize = (
          431
          24)
        object lblDNProfileMap: TTntLabel
          Left = 0
          Top = 2
          Width = 155
          Height = 16
          Caption = 'Display name &profile fields:'
        end
        object txtDNProfileMap: TTntEdit
          Left = 183
          Top = 0
          Width = 224
          Height = 24
          Anchors = [akLeft, akTop, akRight]
          TabOrder = 0
        end
      end
      object chkShowPending: TTntCheckBox
        Left = 0
        Top = 70
        Width = 434
        Height = 20
        Align = alTop
        Caption = '&Show contacts I have asked to add as "Pending"'
        TabOrder = 3
      end
      object chkHover: TTntCheckBox
        Left = 0
        Top = 110
        Width = 434
        Height = 20
        Align = alTop
        Caption = 'Show contact list &popup'
        TabOrder = 4
      end
      object chkObservers: TTntCheckBox
        Left = 0
        Top = 90
        Width = 434
        Height = 20
        Align = alTop
        Caption = 'Show obser&vers'
        TabOrder = 5
      end
    end
    object gbDepricated: TExGroupBox
      AlignWithMargins = True
      Left = 0
      Top = 335
      Width = 434
      Height = 462
      Margins.Left = 0
      Margins.Top = 6
      Margins.Right = 0
      Margins.Bottom = 0
      Align = alTop
      BevelOuter = bvNone
      Caption = 'Depricated preferences (may not be supported)'
      ParentColor = True
      TabOrder = 5
      AutoHide = True
      object chkSort: TTntCheckBox
        Left = 0
        Top = 18
        Width = 434
        Height = 20
        Align = alTop
        Caption = 'Sort Contacts by their availability'
        TabOrder = 1
      end
      object chkOfflineGrp: TTntCheckBox
        Left = 0
        Top = 38
        Width = 434
        Height = 18
        Align = alTop
        Caption = 'Show offline contacts in an Offline group'
        TabOrder = 2
      end
      object pnlMinStatus: TExBrandPanel
        AlignWithMargins = True
        Left = 0
        Top = 173
        Width = 431
        Height = 24
        Margins.Left = 0
        Align = alTop
        AutoSize = True
        BevelOuter = bvNone
        ParentColor = True
        TabOrder = 3
        AutoHide = True
        object lblFilter: TTntLabel
          Left = 0
          Top = 2
          Width = 146
          Height = 16
          Caption = '"Online" minimum status: '
          WordWrap = True
        end
        object cboVisible: TTntComboBox
          Left = 176
          Top = 0
          Width = 191
          Height = 24
          Style = csDropDownList
          ItemHeight = 16
          TabOrder = 0
          Items.Strings = (
            'Do Not Disturb'
            'Ext. Away'
            'Away'
            'Available')
        end
      end
      object pnlGatewayGroup: TExBrandPanel
        AlignWithMargins = True
        Left = 0
        Top = 203
        Width = 431
        Height = 24
        Margins.Left = 0
        Align = alTop
        AutoSize = True
        BevelOuter = bvNone
        ParentColor = True
        TabOrder = 4
        AutoHide = True
        object lblGatewayGrp: TTntLabel
          Left = 0
          Top = 2
          Width = 91
          Height = 16
          Caption = 'Gateway group:'
        end
        object txtGatewayGrp: TTntComboBox
          Left = 176
          Top = 0
          Width = 191
          Height = 24
          ItemHeight = 16
          TabOrder = 0
        end
      end
      object chkPresErrors: TTntCheckBox
        Left = 0
        Top = 113
        Width = 434
        Height = 20
        Align = alTop
        Caption = 'Detect contacts which are unreachable or no longer exist'
        TabOrder = 5
        Visible = False
      end
      object chkShowUnsubs: TTntCheckBox
        Left = 0
        Top = 152
        Width = 434
        Height = 18
        Align = alTop
        Caption = 'Show contacts which I do not have a subscription to'
        TabOrder = 6
      end
      object chkRosterUnicode: TTntCheckBox
        Left = 0
        Top = 75
        Width = 434
        Height = 18
        Align = alTop
        Caption = 
          'Allow Unicode characters in the contact list (requires 2000, ME,' +
          ' XP).'
        TabOrder = 7
      end
      object chkRosterAvatars: TTntCheckBox
        Left = 0
        Top = 133
        Width = 434
        Height = 19
        Align = alTop
        Caption = 'Show Avatars in the contact list'
        TabOrder = 8
      end
      object pnlDblClickAction: TExBrandPanel
        AlignWithMargins = True
        Left = 0
        Top = 233
        Width = 431
        Height = 24
        Margins.Left = 0
        Align = alTop
        AutoSize = True
        BevelOuter = bvNone
        ParentColor = True
        TabOrder = 9
        AutoHide = True
        object lblDblClick: TTntLabel
          Left = 0
          Top = 2
          Width = 128
          Height = 16
          Caption = 'Default dblclick action:'
        end
        object cboDblClick: TTntComboBox
          Left = 176
          Top = 0
          Width = 191
          Height = 24
          Style = csDropDownList
          ItemHeight = 16
          TabOrder = 0
          Items.Strings = (
            'A new one to one chat window'
            'An instant message window'
            'A new or existing chat window')
        end
      end
      object pnlGroupSeparator: TExBrandPanel
        AlignWithMargins = True
        Left = 0
        Top = 263
        Width = 431
        Height = 24
        Margins.Left = 0
        Align = alTop
        AutoSize = True
        BevelOuter = bvNone
        ParentColor = True
        TabOrder = 10
        AutoHide = True
        object lblGrpSeparator: TTntLabel
          Left = 0
          Top = 2
          Width = 140
          Height = 16
          Caption = 'Nested group seperator:'
        end
        object txtGrpSeparator: TTntEdit
          Left = 176
          Top = 0
          Width = 191
          Height = 24
          TabOrder = 0
        end
      end
      object pnlAlpha: TExBrandPanel
        Left = 0
        Top = 290
        Width = 434
        Height = 56
        Align = alTop
        AutoSize = True
        BevelOuter = bvNone
        ParentColor = True
        TabOrder = 11
        AutoHide = True
        object chkRosterAlpha: TTntCheckBox
          Left = 0
          Top = 0
          Width = 239
          Height = 18
          Caption = 'Use Alpha Blending'
          TabOrder = 1
          OnClick = chkRosterAlphaClick
        end
        object trkRosterAlpha: TTrackBar
          Left = 9
          Top = 28
          Width = 162
          Height = 20
          Enabled = False
          Max = 255
          Min = 100
          PageSize = 15
          Frequency = 15
          Position = 255
          TabOrder = 2
          ThumbLength = 15
          TickStyle = tsNone
          OnChange = trkRosterAlphaChange
        end
        object txtRosterAlpha: TExNumericEdit
          Left = 176
          Top = 25
          Width = 65
          Height = 31
          BevelOuter = bvNone
          Enabled = False
          ParentColor = True
          TabOrder = 0
          Text = '255'
          Min = 100
          Max = 255
          OnChange = txtRosterAlphaChange
          DesignSize = (
            65
            31)
        end
      end
      object chkCollapsed: TTntCheckBox
        Left = 0
        Top = 56
        Width = 434
        Height = 19
        Align = alTop
        Caption = 'Collapse &all contact groups initially'
        TabOrder = 12
      end
      object chkNestedGrps: TTntCheckBox
        Left = 0
        Top = 93
        Width = 434
        Height = 20
        Margins.Left = 0
        Margins.Bottom = 0
        Align = alTop
        Caption = '&Use nested groups'
        TabOrder = 13
      end
    end
    object pnlDefaultNIck: TExBrandPanel
      AlignWithMargins = True
      Left = 0
      Top = 6
      Width = 431
      Height = 24
      Margins.Left = 0
      Margins.Top = 6
      Margins.Bottom = 0
      Align = alTop
      AutoSize = True
      BevelOuter = bvNone
      ParentColor = True
      TabOrder = 0
      AutoHide = True
      DesignSize = (
        431
        24)
      object lblDefaultNick: TTntLabel
        Left = 0
        Top = 4
        Width = 157
        Height = 16
        Margins.Left = 0
        Caption = 'Default &nickname for chats:'
        FocusControl = txtDefaultNick
      end
      object txtDefaultNick: TTntEdit
        Left = 171
        Top = 0
        Width = 260
        Height = 24
        Anchors = [akLeft, akTop, akRight]
        TabOrder = 0
      end
    end
    object pnlDefaultGroup: TExBrandPanel
      AlignWithMargins = True
      Left = 0
      Top = 36
      Width = 431
      Height = 24
      Margins.Left = 0
      Margins.Top = 6
      Margins.Bottom = 0
      Align = alTop
      AutoSize = True
      BevelOuter = bvNone
      ParentColor = True
      TabOrder = 1
      AutoHide = True
      DesignSize = (
        431
        24)
      object lblDefaultGrp: TTntLabel
        Left = 0
        Top = 4
        Width = 165
        Height = 16
        Caption = 'Default &group for new items:'
        FocusControl = txtDefaultGrp
      end
      object txtDefaultGrp: TTntComboBox
        Left = 171
        Top = 0
        Width = 260
        Height = 24
        Anchors = [akLeft, akTop, akRight]
        ItemHeight = 16
        TabOrder = 0
      end
    end
  end
end
