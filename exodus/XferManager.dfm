inherited frmXferManager: TfrmXferManager
  Left = 251
  Top = 229
  Caption = 'File Transfer Manager'
  ClientWidth = 560
  OldCreateOrder = True
  OnDestroy = FormDestroy
  ExplicitWidth = 568
  PixelsPerInch = 120
  TextHeight = 16
  inherited pnlDock: TTntPanel
    Width = 560
    TabOrder = 1
    inherited pnlDockTopContainer: TTntPanel
      Width = 560
      inherited tbDockBar: TToolBar
        Left = 510
        ExplicitLeft = 510
      end
      inherited pnlDockTop: TTntPanel
        Width = 506
        ExplicitWidth = 506
        object Panel1: TPanel
          Left = 1
          Top = 1
          Width = 504
          Height = 42
          Align = alClient
          BevelOuter = bvNone
          BorderWidth = 5
          ParentColor = True
          TabOrder = 0
          object pnlCaption: TTntPanel
            Left = 5
            Top = 5
            Width = 494
            Height = 32
            Align = alClient
            BevelOuter = bvLowered
            Caption = 'File Transfers'
            Color = clHighlight
            ParentBackground = False
            TabOrder = 0
          end
        end
      end
    end
    inherited pnlDockControlSite: TTntPanel
      Width = 560
    end
  end
  object box: TScrollBox
    Left = 0
    Top = 97
    Width = 560
    Height = 104
    Align = alClient
    BevelInner = bvNone
    BevelOuter = bvNone
    BorderStyle = bsNone
    TabOrder = 0
  end
  object httpServer: TIdHTTPServer
    Bindings = <>
    CommandHandlers = <>
    DefaultPort = 5280
    Greeting.NumericCode = 0
    ListenQueue = 1
    MaxConnectionReply.NumericCode = 0
    OnDisconnect = httpServerDisconnect
    ReplyExceptionCode = 0
    ReplyTexts = <>
    ReplyUnknownCommand.NumericCode = 0
    OnCommandGet = httpServerCommandGet
    Left = 40
    Top = 40
  end
  object tcpServer: TIdTCPServer
    Bindings = <>
    CommandHandlers = <>
    DefaultPort = 5347
    Greeting.NumericCode = 0
    MaxConnectionReply.NumericCode = 0
    OnConnect = tcpServerConnect
    OnExecute = tcpServerExecute
    OnDisconnect = tcpServerDisconnect
    ReplyExceptionCode = 0
    ReplyTexts = <>
    ReplyUnknownCommand.NumericCode = 0
    Left = 72
    Top = 40
  end
  object OpenDialog1: TOpenDialog
    Filter = 'All Files|*.*'
    Left = 8
    Top = 40
  end
end
