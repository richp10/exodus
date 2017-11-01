object frmIRC: TfrmIRC
  Left = 248
  Top = 144
  Width = 408
  Height = 267
  BorderWidth = 3
  Caption = 'IRC Session'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Status: TMemo
    Left = 0
    Top = 0
    Width = 298
    Height = 227
    Align = alClient
    TabOrder = 0
  end
  object Panel1: TPanel
    Left = 298
    Top = 0
    Width = 96
    Height = 227
    Align = alRight
    BevelOuter = bvNone
    TabOrder = 1
    object btnDisconnect: TButton
      Left = 8
      Top = 40
      Width = 75
      Height = 25
      Caption = 'Disconnect'
      Enabled = False
      TabOrder = 0
      OnClick = btnDisconnectClick
    end
    object btnJoin: TButton
      Left = 8
      Top = 72
      Width = 75
      Height = 25
      Caption = 'Join Channel'
      Enabled = False
      TabOrder = 1
      OnClick = btnJoinClick
    end
    object btnConnect: TButton
      Left = 8
      Top = 8
      Width = 75
      Height = 25
      Caption = 'Connect'
      TabOrder = 2
      OnClick = btnConnectClick
    end
    object Button1: TButton
      Left = 8
      Top = 104
      Width = 75
      Height = 25
      Caption = 'Button1'
      TabOrder = 3
    end
  end
  object IRC: TIdIRC
    OnStatus = IRCStatus
    MaxLineAction = maException
    ReadTimeout = 0
    OnDisconnected = IRCDisconnected
    OnConnected = IRCConnected
    Nick = 'Nick'
    AltNick = 'OtherNick'
    Username = 'exodus'
    RealName = 'Exodus User'
    Replies.Version = 'TIdIRC 1.061 by Steve Williams'
    Replies.ClientInfo = 'Exodus IRC Plugin'
    UserMode = []
    OnMessage = IRCMessage
    OnAction = IRCAction
    OnConnect = IRCConnect
    OnJoined = IRCJoined
    OnPart = IRCPart
    OnNames = IRCNames
    OnSystem = IRCSystem
    OnRaw = IRCRaw
    OnReceive = IRCReceive
    Left = 306
    Top = 168
  end
end
