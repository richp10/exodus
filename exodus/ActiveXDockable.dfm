inherited frmActiveXDockable: TfrmActiveXDockable
  Left = 414
  Top = 474
  ClientHeight = 260
  ClientWidth = 415
  OnDestroy = FormDestroy
  ExplicitWidth = 519
  ExplicitHeight = 353
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnlDock: TTntPanel
    Width = 415
    TabOrder = 1
    ExplicitWidth = 415
    inherited pnlDockTopContainer: TTntPanel
      Width = 415
      ExplicitLeft = 1
      ExplicitTop = 1
      ExplicitWidth = 415
      inherited tbDockBar: TToolBar
        Left = 461
        ExplicitLeft = 461
      end
      inherited pnlDockTop: TTntPanel
        Width = 371
        Caption = 'pnlDockTop'
        ExplicitWidth = 371
      end
    end
    inherited pnlDockControlSite: TTntPanel
      Width = 415
      ExplicitLeft = 1
      ExplicitTop = 29
      ExplicitWidth = 415
      ExplicitHeight = 25
    end
  end
  object pnlMsgList: TPanel
    Left = 0
    Top = 55
    Width = 415
    Height = 205
    Align = alClient
    BevelOuter = bvNone
    BorderWidth = 4
    ParentColor = True
    TabOrder = 0
    ExplicitTop = 79
    ExplicitHeight = 181
  end
end
