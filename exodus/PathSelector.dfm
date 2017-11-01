object frmPathSelector: TfrmPathSelector
  Left = 246
  Top = 143
  Width = 295
  Height = 298
  BorderIcons = [biSystemMenu]
  BorderWidth = 3
  Caption = 'Browse for Folder'
  Color = clBtnFace
  DefaultMonitor = dmDesktop
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TTntLabel
    Left = 0
    Top = 0
    Width = 281
    Height = 33
    Align = alTop
    AutoSize = False
    Caption = 'Directories'
    Color = clBtnFace
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentColor = False
    ParentFont = False
    Layout = tlCenter
  end
  inline frameButtons1: TframeButtons
    Left = 0
    Top = 233
    Width = 281
    Height = 30
    Align = alBottom
    AutoScroll = False
    TabOrder = 0
    inherited Panel2: TPanel
      Width = 281
      Height = 30
      inherited Bevel1: TBevel
        Width = 281
      end
      inherited Panel1: TPanel
        Left = 121
        Height = 25
      end
    end
  end
  object Folders: TShellTreeView
    Left = 0
    Top = 33
    Width = 281
    Height = 200
    ObjectTypes = [otFolders]
    Root = 'rfDesktop'
    UseShellImages = True
    Align = alClient
    AutoRefresh = False
    Indent = 19
    ParentColor = False
    ParentShowHint = False
    RightClickSelect = True
    ShowHint = False
    ShowRoot = False
    TabOrder = 1
  end
end
