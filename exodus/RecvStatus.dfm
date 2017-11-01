inherited fRecvStatus: TfRecvStatus
  Width = 495
  Height = 90
  ExplicitWidth = 495
  ExplicitHeight = 90
  object Panel3: TPanel
    Left = 0
    Top = 0
    Width = 495
    Height = 45
    Align = alTop
    BevelOuter = bvNone
    BorderWidth = 2
    ParentColor = True
    TabOrder = 0
    object lblFile: TTntLabel
      Left = 2
      Top = 20
      Width = 491
      Height = 18
      Align = alClient
      Caption = 'lblFile'
      Transparent = False
      Layout = tlCenter
      ExplicitWidth = 26
      ExplicitHeight = 13
    end
    object lblFrom: TTntLabel
      Left = 2
      Top = 7
      Width = 491
      Height = 13
      Align = alTop
      Caption = 'lblFrom'
      Transparent = False
      ExplicitWidth = 34
    end
    object Bevel3: TBevel
      Left = 2
      Top = 38
      Width = 491
      Height = 5
      Align = alBottom
      Shape = bsBottomLine
    end
    object Bevel2: TBevel
      Left = 2
      Top = 2
      Width = 491
      Height = 5
      Align = alTop
      Shape = bsTopLine
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 45
    Width = 326
    Height = 45
    Align = alClient
    BevelOuter = bvNone
    BorderWidth = 7
    ParentColor = True
    TabOrder = 1
    object lblStatus: TTntLabel
      Left = 7
      Top = 7
      Width = 312
      Height = 13
      Align = alTop
      Caption = 'Status...'
      ExplicitWidth = 43
    end
    object Bar1: TProgressBar
      Left = 7
      Top = 20
      Width = 312
      Height = 17
      Align = alTop
      TabOrder = 0
    end
  end
  object Panel1: TPanel
    Left = 326
    Top = 45
    Width = 169
    Height = 45
    Align = alRight
    BevelOuter = bvNone
    ParentColor = True
    TabOrder = 2
    object btnRecv: TButton
      Left = 8
      Top = 11
      Width = 75
      Height = 26
      Caption = 'Receive'
      TabOrder = 0
      OnClick = btnRecvClick
    end
    object btnCancel: TButton
      Left = 88
      Top = 10
      Width = 75
      Height = 26
      Caption = 'Cancel'
      TabOrder = 1
      OnClick = btnCancelClick
    end
  end
  object httpClient: TIdHTTP
    MaxLineAction = maException
    AllowCookies = False
    ProxyParams.BasicAuthentication = False
    ProxyParams.ProxyPort = 0
    Request.ContentLength = 0
    Request.ContentRangeEnd = 0
    Request.ContentRangeStart = 0
    Request.ContentType = 'text/html'
    Request.Accept = 'text/html, */*'
    Request.BasicAuthentication = False
    Request.UserAgent = 'Mozilla/3.0 (compatible; Indy Library)'
    HTTPOptions = [hoForceEncodeParams]
    Left = 224
  end
  object tcpClient: TIdTCPClient
    IOHandler = SocksHandler
    MaxLineAction = maException
    Port = 0
    Left = 256
  end
  object SaveDialog1: TSaveDialog
    Left = 192
  end
  object SocksHandler: TIdIOHandlerSocket
    SocksInfo = IdSocksInfo1
    UseNagle = False
    Left = 288
  end
  object IdSocksInfo1: TIdSocksInfo
    Version = svSocks5
    Left = 320
  end
end
