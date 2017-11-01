inherited frmAutoUpdateStatus: TfrmAutoUpdateStatus
  Left = 236
  Top = 562
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  BorderWidth = 5
  Caption = 'Auto Update'
  ClientHeight = 108
  ClientWidth = 291
  DefaultMonitor = dmDesktop
  FormStyle = fsStayOnTop
  Position = poMainFormCenter
  OnClose = FormClose
  OnCreate = FormCreate
  ExplicitWidth = 307
  ExplicitHeight = 150
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TTntLabel
    Left = 40
    Top = 0
    Width = 178
    Height = 26
    Caption = 
      'A new version of Exodus is available.  Would you like to install' +
      ' it?'
    WordWrap = True
  end
  object Image1: TImage
    Left = 3
    Top = 3
    Width = 32
    Height = 32
  end
  object TntLabel1: TTntLabel
    Left = 40
    Top = 31
    Width = 64
    Height = 13
    Cursor = crHandPoint
    Caption = 'What'#39's New?'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsUnderline]
    ParentFont = False
    OnClick = TntLabel1Click
  end
  object ProgressBar1: TProgressBar
    Left = 0
    Top = 54
    Width = 291
    Height = 17
    Align = alBottom
    Max = 1
    TabOrder = 0
    Visible = False
  end
  object Panel1: TPanel
    Left = 0
    Top = 71
    Width = 291
    Height = 37
    Align = alBottom
    BevelOuter = bvNone
    BorderWidth = 1
    ParentColor = True
    TabOrder = 1
    object Bevel1: TBevel
      Left = 1
      Top = 1
      Width = 289
      Height = 4
      Align = alTop
      Shape = bsBottomLine
    end
    object Panel2: TPanel
      Left = 40
      Top = 5
      Width = 250
      Height = 31
      Align = alRight
      BevelOuter = bvNone
      ParentColor = True
      TabOrder = 0
      object btnOK: TTntButton
        Left = 10
        Top = 5
        Width = 75
        Height = 25
        Caption = 'OK'
        Default = True
        TabOrder = 0
        OnClick = frameButtons1btnOKClick
      end
      object btnSkip: TTntButton
        Left = 90
        Top = 5
        Width = 75
        Height = 25
        Caption = 'Skip'
        TabOrder = 1
        OnClick = btnSkipClick
      end
      object btnCancel: TTntButton
        Left = 170
        Top = 5
        Width = 75
        Height = 25
        Cancel = True
        Caption = 'Cancel'
        TabOrder = 2
        OnClick = frameButtons1btnCancelClick
      end
    end
  end
  object HttpClient: TIdHTTP
    MaxLineAction = maException
    OnWork = HttpClientWork
    OnWorkBegin = HttpClientWorkBegin
    AllowCookies = True
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
    Left = 6
    Top = 41
  end
end
