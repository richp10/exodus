inherited fSendStatus: TfSendStatus
  Width = 402
  Height = 89
  ExplicitWidth = 402
  ExplicitHeight = 89
  object Panel1: TPanel
    Left = 313
    Top = 45
    Width = 89
    Height = 44
    Align = alRight
    BevelOuter = bvNone
    ParentColor = True
    TabOrder = 0
    object btnCancel: TButton
      Left = 8
      Top = 11
      Width = 75
      Height = 26
      Caption = 'Cancel'
      TabOrder = 0
      OnClick = btnCancelClick
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 45
    Width = 313
    Height = 44
    Align = alClient
    BevelOuter = bvNone
    BorderWidth = 7
    ParentColor = True
    TabOrder = 1
    object lblStatus: TTntLabel
      Left = 7
      Top = 7
      Width = 299
      Height = 13
      Align = alTop
      Caption = 'Status...'
      ExplicitWidth = 43
    end
    object Bar1: TProgressBar
      Left = 7
      Top = 20
      Width = 299
      Height = 17
      Align = alTop
      TabOrder = 0
    end
  end
  object Panel3: TPanel
    Left = 0
    Top = 0
    Width = 402
    Height = 45
    Align = alTop
    BevelOuter = bvNone
    BorderWidth = 2
    ParentColor = True
    TabOrder = 2
    object lblFile: TTntLabel
      Left = 2
      Top = 20
      Width = 398
      Height = 13
      Align = alTop
      Caption = 'lblFile'
      Transparent = False
      Layout = tlCenter
      ExplicitWidth = 26
    end
    object lblTo: TTntLabel
      Left = 2
      Top = 7
      Width = 398
      Height = 13
      Align = alTop
      Caption = 'lblTo'
      Transparent = False
      ExplicitWidth = 22
    end
    object Bevel1: TBevel
      Left = 2
      Top = 38
      Width = 398
      Height = 5
      Align = alBottom
      Shape = bsBottomLine
    end
    object Bevel2: TBevel
      Left = 2
      Top = 2
      Width = 398
      Height = 5
      Align = alTop
      Shape = bsTopLine
    end
  end
  object httpClient: TIdHTTP
    MaxLineAction = maException
    AllowCookies = True
    ProxyParams.BasicAuthentication = False
    ProxyParams.ProxyPort = 0
    Request.ContentLength = -1
    Request.ContentRangeEnd = 0
    Request.ContentRangeStart = 0
    Request.ContentType = 'text/html'
    Request.Accept = 'text/html, */*'
    Request.BasicAuthentication = False
    Request.UserAgent = 'Mozilla/3.0 (compatible; Indy Library)'
    HTTPOptions = [hoForceEncodeParams]
    Left = 248
  end
  object tcpClient: TIdTCPClient
    IOHandler = SocksHandler
    MaxLineAction = maException
    Port = 0
    Left = 216
  end
  object SocksHandler: TIdIOHandlerSocket
    SocksInfo = IdSocksInfo1
    UseNagle = False
    Left = 184
  end
  object IdSocksInfo1: TIdSocksInfo
    Version = svSocks5
    Left = 280
  end
end
