inherited frmDockContainer: TfrmDockContainer
  Caption = ''
  OldCreateOrder = True
  OnShow = TntFormShow
  PixelsPerInch = 120
  TextHeight = 16
  inherited pnlDock: TTntPanel
    inherited pnlDockTopContainer: TTntPanel
      inherited pnlDockTop: TTntPanel
        Caption = 'pnlDockTop'
      end
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 97
    Width = 251
    Height = 104
    Align = alClient
    Caption = 'Panel1'
    TabOrder = 1
    object WebBrowser1: TWebBrowser
      Left = 1
      Top = 1
      Width = 249
      Height = 102
      Align = alClient
      TabOrder = 0
      ExplicitWidth = 253
      ExplicitHeight = 166
      ControlData = {
        4C000000971400006F0800000100000001020000000000000000000000000000
        000000004C000000000000000000000001000000E0D057007335CF11AE690800
        2B2E126202000000000000004C0000000114020000000000C000000000000046
        8000000000000000000000000000000000000000000000000000000000000000
        00000000000000000100000000000000000000000000000000000000}
    end
  end
end
