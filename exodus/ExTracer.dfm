object frmException: TfrmException
  Left = 249
  Top = 204
  Caption = 'frmException'
  ClientHeight = 327
  ClientWidth = 393
  OldCreateOrder = False
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object mmLog: TMemo
    Left = 0
    Top = 0
    Width = 393
    Height = 293
    Align = alClient
    ScrollBars = ssBoth
    TabOrder = 0
    WordWrap = False
  end
  inline frameButtons1: TframeButtons
    Left = 0
    Top = 293
    Width = 393
    Height = 34
    Align = alBottom
    Color = 13681583
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentColor = False
    ParentFont = False
    TabOrder = 1
    TabStop = True
    ExplicitTop = 293
    ExplicitWidth = 393
    ExplicitHeight = 34
    inherited Panel2: TPanel
      Width = 393
      Height = 34
      ExplicitWidth = 393
      ExplicitHeight = 34
      inherited Bevel1: TBevel
        Width = 393
        ExplicitWidth = 393
      end
      inherited Panel1: TPanel
        Left = 233
        Height = 29
        ExplicitLeft = 233
        ExplicitHeight = 29
        inherited btnOK: TTntButton
          Visible = False
        end
        inherited btnCancel: TTntButton
          Caption = 'Close'
          OnClick = frameButtons1btnCancelClick
        end
      end
    end
  end
end
