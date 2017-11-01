inherited frmDockWindow: TfrmDockWindow
  Caption = 'frmDockWindow'
  ClientHeight = 412
  ClientWidth = 638
  DockSite = True
  ParentFont = False
  OnDockDrop = FormDockDrop
  OnHide = FormHide
  OnResize = FormResize
  OnShow = FormShow
  ExplicitWidth = 646
  ExplicitHeight = 446
  PixelsPerInch = 96
  TextHeight = 13
  object splAW: TTntSplitter
    Left = 185
    Top = 0
    Height = 412
    ResizeStyle = rsUpdate
  end
  object pnlActivityList: TPanel
    Left = 0
    Top = 0
    Width = 185
    Height = 412
    Align = alLeft
    BevelOuter = bvNone
    Constraints.MinWidth = 30
    ParentColor = True
    TabOrder = 0
    OnDockDrop = FormDockDrop
  end
  object pnlTabControl: TPanel
    Left = 188
    Top = 0
    Width = 450
    Height = 412
    Align = alClient
    BevelOuter = bvNone
    ParentColor = True
    TabOrder = 1
    OnResize = pnlTabControlResize
    object AWTabControl: TPageControl
      Left = 0
      Top = -1
      Width = 450
      Height = 462
      DockSite = True
      OwnerDraw = True
      Style = tsButtons
      TabHeight = 1
      TabOrder = 0
      TabStop = False
      OnDockDrop = AWTabControlDockDrop
      OnUnDock = AWTabControlUnDock
    end
  end
end
