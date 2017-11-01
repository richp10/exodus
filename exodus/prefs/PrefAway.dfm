inherited frmPrefAway: TfrmPrefAway
  Left = 252
  Top = 255
  Anchors = [akLeft]
  Caption = 'frmPrefAway'
  OldCreateOrder = True
  ExplicitWidth = 394
  ExplicitHeight = 439
  PixelsPerInch = 96
  TextHeight = 13
  object pnlContainer: TExBrandPanel [0]
    AlignWithMargins = True
    Left = 0
    Top = 26
    Width = 362
    Height = 401
    Margins.Left = 0
    Margins.Right = 0
    Margins.Bottom = 0
    Align = alLeft
    BevelOuter = bvNone
    ParentColor = True
    TabOrder = 1
    AutoHide = False
    object chkAutoAway: TExCheckGroupBox
      AlignWithMargins = True
      Left = 0
      Top = 3
      Width = 362
      Height = 162
      Margins.Left = 0
      Margins.Right = 0
      Margins.Bottom = 0
      Align = alTop
      AutoSize = True
      BevelOuter = bvNone
      Caption = 'Enable Auto &Away'
      ParentColor = True
      TabOrder = 0
      AutoHide = True
      Checked = False
      OnCheckChanged = chkAutoAwayCheckChanged
      object pnlAwayTime: TExBrandPanel
        AlignWithMargins = True
        Left = 18
        Top = 18
        Width = 341
        Height = 24
        Margins.Left = 18
        Margins.Top = 0
        Margins.Bottom = 0
        Align = alTop
        BevelOuter = bvNone
        ParentColor = True
        TabOrder = 1
        AutoHide = True
        ExplicitTop = 21
        object lblAwayTime: TTntLabel
          Left = 0
          Top = 3
          Width = 224
          Height = 13
          Margins.Left = 0
          Caption = '&Minutes to wait before setting status to Away:'
          FocusControl = txtAwayTime
        end
        object txtAwayTime: TExNumericEdit
          Left = 287
          Top = 0
          Width = 54
          Height = 24
          Align = alRight
          Anchors = [akLeft]
          BevelOuter = bvNone
          ParentColor = True
          TabOrder = 0
          Text = '5'
          Min = 1
          Max = 600
          DesignSize = (
            54
            24)
        end
      end
      object chkAAReducePri: TTntCheckBox
        AlignWithMargins = True
        Left = 18
        Top = 66
        Width = 341
        Height = 24
        Margins.Left = 18
        Margins.Top = 0
        Margins.Bottom = 0
        Align = alTop
        Caption = 'Reduce &priority to 0 when Away'
        TabOrder = 3
        ExplicitTop = 69
      end
      object chkAwayAutoResponse: TTntCheckBox
        AlignWithMargins = True
        Left = 18
        Top = 90
        Width = 341
        Height = 24
        Margins.Left = 18
        Margins.Top = 0
        Margins.Bottom = 0
        Align = alTop
        Caption = '&Send auto response message when away'
        TabOrder = 4
        ExplicitTop = 93
      end
      object ExBrandPanel2: TExBrandPanel
        AlignWithMargins = True
        Left = 18
        Top = 42
        Width = 341
        Height = 24
        Margins.Left = 18
        Margins.Top = 0
        Margins.Bottom = 0
        Align = alTop
        AutoSize = True
        BevelOuter = bvNone
        ParentColor = True
        TabOrder = 2
        AutoHide = True
        ExplicitTop = 45
        object lblAwayStatus: TTntLabel
          Left = 0
          Top = 3
          Width = 87
          Height = 13
          Caption = 'Away status &text:'
          FocusControl = txtAway
        end
        object txtAway: TTntEdit
          Left = 182
          Top = 0
          Width = 159
          Height = 24
          Align = alRight
          TabOrder = 0
          ExplicitHeight = 21
        end
      end
      object chkAwayScreenSaver: TTntCheckBox
        AlignWithMargins = True
        Left = 18
        Top = 114
        Width = 341
        Height = 24
        Margins.Left = 18
        Margins.Top = 0
        Margins.Bottom = 0
        Align = alTop
        Caption = 'Set status to Away with screen sa&ver activation'
        TabOrder = 5
        ExplicitTop = 117
      end
      object chkAwayFullScreen: TTntCheckBox
        AlignWithMargins = True
        Left = 18
        Top = 138
        Width = 341
        Height = 24
        Margins.Left = 18
        Margins.Top = 0
        Margins.Bottom = 0
        Align = alTop
        Caption = 'Set status to Away with full sc&reen application'
        TabOrder = 6
        ExplicitLeft = 6
        ExplicitTop = 146
      end
    end
    object chkAutoXA: TExCheckGroupBox
      AlignWithMargins = True
      Left = 0
      Top = 171
      Width = 362
      Height = 69
      Margins.Left = 0
      Margins.Top = 6
      Margins.Right = 0
      Margins.Bottom = 0
      Align = alTop
      AutoSize = True
      BevelOuter = bvNone
      Caption = 'Enable Auto E&xtended Away'
      ParentColor = True
      TabOrder = 1
      AutoHide = False
      Checked = False
      OnCheckChanged = chkAutoXACheckChanged
      ExplicitTop = 147
      object ExBrandPanel3: TExBrandPanel
        AlignWithMargins = True
        Left = 18
        Top = 18
        Width = 341
        Height = 24
        Margins.Left = 18
        Margins.Top = 0
        Align = alTop
        AutoSize = True
        BevelOuter = bvNone
        ParentColor = True
        TabOrder = 1
        AutoHide = True
        object lblXATime: TTntLabel
          Left = 0
          Top = 5
          Width = 273
          Height = 13
          Caption = 'Minutes to &wait before setting status to Extended Away:'
          FocusControl = txtXATime
        end
        object txtXATime: TExNumericEdit
          Left = 287
          Top = 0
          Width = 54
          Height = 24
          Align = alRight
          BevelOuter = bvNone
          ParentColor = True
          TabOrder = 0
          Text = '30'
          Min = 1
          Max = 600
          DesignSize = (
            54
            24)
        end
      end
      object ExBrandPanel4: TExBrandPanel
        AlignWithMargins = True
        Left = 18
        Top = 45
        Width = 341
        Height = 24
        Margins.Left = 18
        Margins.Top = 0
        Margins.Bottom = 0
        Align = alTop
        AutoSize = True
        BevelOuter = bvNone
        ParentColor = True
        TabOrder = 2
        AutoHide = True
        object lblXAStatus: TTntLabel
          Left = 0
          Top = 3
          Width = 136
          Height = 13
          Caption = '&Extended Away status text:'
          FocusControl = txtXA
        end
        object txtXA: TTntEdit
          Left = 182
          Top = 0
          Width = 159
          Height = 24
          Align = alRight
          TabOrder = 0
          ExplicitHeight = 21
        end
      end
    end
    object chkAutoDisconnect: TExCheckGroupBox
      AlignWithMargins = True
      Left = 0
      Top = 246
      Width = 362
      Height = 44
      Margins.Left = 0
      Margins.Top = 6
      Margins.Right = 0
      Margins.Bottom = 0
      Align = alTop
      AutoSize = True
      BevelOuter = bvNone
      Caption = 'Enable Auto &Disconnect'
      ParentColor = True
      TabOrder = 2
      AutoHide = False
      Checked = False
      OnCheckChanged = chkAutoDisconnectCheckChanged
      ExplicitTop = 222
      object lblDisconnectTime: TTntLabel
        AlignWithMargins = True
        Left = 18
        Top = 28
        Width = 180
        Height = 13
        Margins.Left = 21
        Margins.Top = 9
        Caption = 'Minutes to wait &before disconnecting:'
        FocusControl = txtDisconnectTime
      end
      object txtDisconnectTime: TExNumericEdit
        Left = 304
        Top = 19
        Width = 54
        Height = 25
        BevelOuter = bvNone
        ParentColor = True
        TabOrder = 1
        Text = '60'
        Min = 1
        Max = 600
        DesignSize = (
          54
          25)
      end
    end
  end
  inherited pnlHeader: TTntPanel
    inherited lblHeader: TTntLabel
      Left = 6
      Width = 69
      Caption = 'Auto Away'
      ExplicitLeft = 6
      ExplicitWidth = 69
    end
  end
end
