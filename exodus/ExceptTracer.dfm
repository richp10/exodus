object frmTracer: TfrmTracer
  Left = 246
  Top = 143
  Width = 420
  Height = 305
  BorderWidth = 4
  Caption = 'Tracer'
  Color = clBtnFace
  DefaultMonitor = dmDesktop
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  inline frameButtons1: TframeButtons
    Left = 0
    Top = 233
    Width = 404
    Height = 30
    Align = alBottom
    AutoScroll = False
    TabOrder = 0
    inherited Bevel1: TBevel
      Width = 404
    end
    inherited Panel1: TPanel
      Left = 244
      inherited btnOK: TButton
        Visible = False
        OnClick = frameButtons1btnOKClick
      end
      inherited btnCancel: TButton
        Caption = 'OK'
        OnClick = frameButtons1btnCancelClick
      end
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 404
    Height = 41
    Align = alTop
    BevelOuter = bvNone
    Caption = 'Exception Tracer'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 1
  end
  object Memo1: TMemo
    Left = 0
    Top = 41
    Width = 404
    Height = 192
    Align = alClient
    ScrollBars = ssBoth
    TabOrder = 2
  end
end
