inherited frmWizard: TfrmWizard
  Left = 496
  Top = 232
  BorderStyle = bsDialog
  Caption = 'Wizard'
  ClientHeight = 358
  ClientWidth = 410
  DefaultMonitor = dmDesktop
  OnCreate = FormCreate
  ExplicitWidth = 416
  ExplicitHeight = 390
  PixelsPerInch = 96
  TextHeight = 13
  object TntPanel1: TTntPanel
    Left = 0
    Top = 317
    Width = 410
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    ParentColor = True
    TabOrder = 0
    object Bevel1: TBevel
      Left = 0
      Top = 0
      Width = 410
      Height = 5
      Align = alTop
      Shape = bsTopLine
    end
    object Panel3: TPanel
      Left = 153
      Top = 5
      Width = 257
      Height = 36
      Align = alRight
      BevelOuter = bvNone
      ParentColor = True
      TabOrder = 0
      object btnBack: TTntButton
        Left = 9
        Top = 5
        Width = 75
        Height = 25
        Caption = '< Back'
        TabOrder = 0
      end
      object btnNext: TTntButton
        Left = 87
        Top = 5
        Width = 75
        Height = 25
        Caption = 'Next >'
        TabOrder = 1
      end
      object btnCancel: TTntButton
        Left = 175
        Top = 5
        Width = 75
        Height = 25
        Cancel = True
        Caption = 'Cancel'
        TabOrder = 2
      end
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 410
    Height = 60
    Align = alTop
    BevelOuter = bvNone
    Ctl3D = False
    ParentBackground = False
    ParentColor = True
    ParentCtl3D = False
    TabOrder = 1
    OnResize = Panel1Resize
    object Bevel2: TBevel
      Left = 0
      Top = 51
      Width = 410
      Height = 9
      Align = alBottom
      Shape = bsBottomLine
    end
    object lblWizardTitle: TTntLabel
      Left = 16
      Top = 5
      Width = 135
      Height = 13
      Align = alCustom
      AutoSize = False
      Caption = 'Wizard Label goes here'
      EllipsisPosition = epEndEllipsis
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      Transparent = True
    end
    object lblWizardDetails: TTntLabel
      Left = 32
      Top = 25
      Width = 331
      Height = 29
      Align = alCustom
      AutoSize = False
      Caption = 'lblWizardDetails'
      EllipsisPosition = epEndEllipsis
      Transparent = True
      WordWrap = True
    end
    object Image1: TImage
      Left = 369
      Top = 0
      Width = 41
      Height = 51
      Align = alRight
      Center = True
      Transparent = True
    end
  end
  object Tabs: TPageControl
    Left = 0
    Top = 60
    Width = 410
    Height = 257
    ActivePage = TabSheet1
    Align = alClient
    Style = tsFlatButtons
    TabOrder = 2
    object TabSheet1: TTabSheet
      Caption = 'TabSheet1'
    end
  end
end
