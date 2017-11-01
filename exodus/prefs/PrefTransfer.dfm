inherited frmPrefTransfer: TfrmPrefTransfer
  Left = 243
  Top = 168
  Caption = 'frmPrefTransfer'
  ClientHeight = 551
  OldCreateOrder = True
  ExplicitHeight = 563
  PixelsPerInch = 96
  TextHeight = 13
  object lblXferPath: TTntLabel [0]
    Left = 0
    Top = 35
    Width = 157
    Height = 13
    Caption = 'File transfer download directory:'
  end
  object lblXferDefault: TTntLabel [1]
    Left = 0
    Top = 320
    Width = 193
    Height = 13
    Cursor = crHandPoint
    Caption = 'Reset all file transfer options to defaults'
    OnClick = lblXferDefaultClick
  end
  object lblXferMethod: TTntLabel [2]
    Left = 0
    Top = 83
    Width = 132
    Height = 13
    Caption = 'Send file using this method:'
  end
  inherited pnlHeader: TTntPanel
    Caption = 'File Transfers'
    TabOrder = 6
    inherited lblHeader: TTntLabel
      Height = 12
    end
  end
  object grpWebDav: TGroupBox
    Left = 8
    Top = 128
    Width = 281
    Height = 178
    TabOrder = 4
    Visible = False
    object lblDavHost: TTntLabel
      Left = 8
      Top = 16
      Width = 51
      Height = 13
      Caption = 'Web Host:'
    end
    object lblDavPort: TTntLabel
      Left = 8
      Top = 56
      Width = 24
      Height = 13
      Caption = 'Port:'
    end
    object lblDavPath: TTntLabel
      Left = 8
      Top = 80
      Width = 51
      Height = 13
      Caption = 'Web Path:'
    end
    object lblDavPath2: TTntLabel
      Left = 85
      Top = 99
      Width = 132
      Height = 13
      Caption = 'Example: /~foo/public_html'
    end
    object lblDavUsername: TTntLabel
      Left = 8
      Top = 128
      Width = 52
      Height = 13
      Caption = 'Username:'
    end
    object lblDavPassword: TTntLabel
      Left = 8
      Top = 152
      Width = 50
      Height = 13
      Caption = 'Password:'
    end
    object lblDavHost2: TTntLabel
      Left = 85
      Top = 35
      Width = 155
      Height = 13
      Caption = 'Example: http://dav.server.com'
    end
    object txtDavHost: TTntEdit
      Left = 85
      Top = 13
      Width = 180
      Height = 21
      TabOrder = 0
    end
    object txtDavPort: TTntEdit
      Left = 85
      Top = 53
      Width = 180
      Height = 21
      TabOrder = 1
    end
    object txtDavPath: TTntEdit
      Left = 85
      Top = 77
      Width = 180
      Height = 21
      TabOrder = 2
    end
    object txtDavUsername: TTntEdit
      Left = 85
      Top = 125
      Width = 180
      Height = 21
      TabOrder = 3
    end
    object txtDavPassword: TTntEdit
      Left = 85
      Top = 149
      Width = 180
      Height = 21
      PasswordChar = '*'
      TabOrder = 4
    end
  end
  object txtXFerPath: TTntEdit
    Left = 21
    Top = 51
    Width = 188
    Height = 21
    TabOrder = 0
  end
  object btnTransferBrowse: TTntButton
    Left = 214
    Top = 49
    Width = 75
    Height = 25
    Caption = 'Browse'
    TabOrder = 1
    OnClick = btnTransferBrowseClick
  end
  object grpPeer: TGroupBox
    Left = 8
    Top = 128
    Width = 281
    Height = 113
    TabOrder = 3
    Visible = False
    object lblXferPort: TTntLabel
      Left = 9
      Top = 12
      Width = 166
      Height = 13
      Caption = 'Port to use for HTTP file transfers:'
    end
    object txtXferPort: TTntEdit
      Left = 30
      Top = 29
      Width = 140
      Height = 21
      TabOrder = 0
    end
    object chkXferIP: TTntCheckBox
      Left = 9
      Top = 57
      Width = 249
      Height = 17
      Caption = 'Use a custom IP address for HTTP transfers'
      TabOrder = 1
      OnClick = chkXferIPClick
    end
    object txtXferIP: TTntEdit
      Left = 30
      Top = 77
      Width = 140
      Height = 21
      TabOrder = 2
    end
  end
  object cboXferMode: TTntComboBox
    Left = 8
    Top = 99
    Width = 281
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 2
    OnChange = cboXferModeChange
    Items.Strings = (
      'Discover a file transfer component using my server.'
      'Always use a specific file transfer component.'
      'Send files directly from my machine to the recipient.'
      'Use a web server to host the files which I send.')
  end
  object grpProxy: TGroupBox
    Left = 8
    Top = 128
    Width = 281
    Height = 79
    TabOrder = 5
    object lbl65Proxy: TTntLabel
      Left = 8
      Top = 16
      Width = 190
      Height = 13
      Caption = 'Jabber Address of File Transfer Server:'
    end
    object txt65Proxy: TTntEdit
      Left = 8
      Top = 32
      Width = 257
      Height = 21
      TabOrder = 0
    end
  end
  object gbProxy: TExGroupBox
    AlignWithMargins = True
    Left = 0
    Top = 338
    Width = 315
    Height = 209
    Margins.Left = 0
    AutoSize = True
    BevelOuter = bvNone
    Caption = 'Proxy type:'
    ParentColor = True
    TabOrder = 7
    AutoHide = True
    object rbIE: TTntRadioButton
      AlignWithMargins = True
      Left = 0
      Top = 21
      Width = 312
      Height = 14
      Margins.Left = 0
      Align = alTop
      Caption = 'Use IE settings'
      TabOrder = 1
      OnClick = rbIEClick
    end
    object rbNone: TTntRadioButton
      AlignWithMargins = True
      Left = 0
      Top = 41
      Width = 312
      Height = 14
      Margins.Left = 0
      Align = alTop
      Caption = 'No HTTP proxy'
      TabOrder = 2
    end
    object rbCustom: TTntRadioButton
      AlignWithMargins = True
      Left = 0
      Top = 61
      Width = 312
      Height = 13
      Margins.Left = 0
      Align = alTop
      Caption = 'Custom proxy'
      TabOrder = 3
    end
    object pnlProxyInfo: TExBrandPanel
      AlignWithMargins = True
      Left = 6
      Top = 86
      Width = 306
      Height = 48
      Margins.Left = 6
      Margins.Top = 9
      Align = alTop
      AutoSize = True
      BevelOuter = bvNone
      ParentColor = True
      TabOrder = 4
      AutoHide = True
      object lblProxyHost: TTntLabel
        Left = 0
        Top = 2
        Width = 56
        Height = 13
        Caption = 'Proxy host:'
        Transparent = False
      end
      object lblProxyPort: TTntLabel
        Left = 0
        Top = 27
        Width = 55
        Height = 13
        Caption = 'Proxy port:'
        Transparent = True
      end
      object txtProxyHost: TTntEdit
        Left = 57
        Top = 0
        Width = 149
        Height = 21
        TabOrder = 0
      end
      object txtProxyPort: TTntEdit
        Left = 59
        Top = 24
        Width = 43
        Height = 21
        TabOrder = 1
      end
    end
    object pnlAuthInfo: TExBrandPanel
      AlignWithMargins = True
      Left = 0
      Top = 146
      Width = 312
      Height = 69
      Margins.Left = 0
      Margins.Top = 9
      Align = alTop
      AutoSize = True
      BevelOuter = bvNone
      ParentColor = True
      TabOrder = 5
      AutoHide = True
      object lblProxyUsername: TTntLabel
        Left = 22
        Top = 23
        Width = 55
        Height = 13
        Caption = 'User name:'
        Transparent = False
      end
      object lblProxyPassword: TTntLabel
        Left = 22
        Top = 47
        Width = 50
        Height = 13
        Caption = 'Password:'
        Transparent = False
      end
      object chkProxyAuth: TTntCheckBox
        Left = 5
        Top = 0
        Width = 174
        Height = 17
        Caption = 'Authentication requested'
        Enabled = False
        TabOrder = 0
        OnClick = chkProxyAuthClick
      end
      object txtProxyUsername: TTntEdit
        Left = 81
        Top = 20
        Width = 130
        Height = 21
        TabOrder = 1
      end
      object txtProxyPassword: TTntEdit
        Left = 81
        Top = 45
        Width = 130
        Height = 21
        PasswordChar = '*'
        TabOrder = 2
      end
    end
  end
end
