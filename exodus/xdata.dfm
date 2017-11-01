inherited frmXData: TfrmXData
  Left = 273
  Top = 154
  Caption = 'Jabber Form'
  ClientHeight = 416
  ClientWidth = 492
  OldCreateOrder = True
  OnClose = FormClose
  ExplicitWidth = 500
  ExplicitHeight = 444
  PixelsPerInch = 96
  TextHeight = 13
  inline frameButtons1: TframeButtons
    Left = 0
    Top = 382
    Width = 492
    Height = 34
    Align = alBottom
    Color = 13681583
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentColor = False
    ParentFont = False
    TabOrder = 0
    TabStop = True
    ExplicitTop = 382
    ExplicitWidth = 492
    ExplicitHeight = 34
    inherited Panel2: TPanel
      Width = 492
      Height = 34
      ExplicitWidth = 492
      ExplicitHeight = 34
      inherited Bevel1: TBevel
        Width = 492
        ExplicitWidth = 492
      end
      inherited Panel1: TPanel
        Left = 332
        Height = 29
        ExplicitLeft = 332
        ExplicitHeight = 29
        inherited btnOK: TTntButton
          OnClick = frameButtons1btnOKClick
        end
        inherited btnCancel: TTntButton
          OnClick = frameButtons1btnCancelClick
        end
      end
    end
  end
  inline frameXData: TframeXData
    Left = 0
    Top = 0
    Width = 492
    Height = 382
    Align = alClient
    Color = 13681583
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentColor = False
    ParentFont = False
    TabOrder = 1
    TabStop = True
    ExplicitWidth = 492
    ExplicitHeight = 382
    inherited Panel1: TPanel
      Width = 492
      Height = 382
      ExplicitWidth = 492
      ExplicitHeight = 382
      inherited ScrollBox1: TScrollBox
        Width = 482
        Height = 372
        ExplicitWidth = 482
        ExplicitHeight = 372
      end
    end
  end
end
