inherited frmDebug: TfrmDebug
  Left = 318
  Top = 199
  Caption = 'Console'
  ClientHeight = 380
  ClientWidth = 400
  ExplicitWidth = 408
  ExplicitHeight = 414
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnlDock: TTntPanel
    Width = 400
    TabOrder = 1
    ExplicitWidth = 400
    inherited pnlDockTopContainer: TTntPanel
      Width = 400
      ExplicitWidth = 400
      inherited tbDockBar: TToolBar
        Left = 351
        ExplicitLeft = 351
      end
      inherited pnlDockTop: TTntPanel
        Width = 348
        ExplicitWidth = 348
        object pnlTop: TPanel
          Left = 0
          Top = 0
          Width = 348
          Height = 28
          Align = alClient
          BevelOuter = bvNone
          ParentColor = True
          TabOrder = 0
          object lblJID: TTntLabel
            Left = 71
            Top = 9
            Width = 72
            Height = 13
            Cursor = crHandPoint
            Caption = '(Disconnected)'
            OnClick = lblJIDClick
          end
          object lblLabel: TTntLabel
            Left = 6
            Top = 9
            Width = 66
            Height = 13
            Caption = 'Current JID:  '
          end
        end
      end
    end
    inherited pnlDockControlSite: TTntPanel
      Width = 400
      ExplicitWidth = 400
      ExplicitHeight = 5
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 33
    Width = 400
    Height = 347
    Align = alClient
    BevelOuter = bvNone
    BorderWidth = 4
    Caption = 'Panel2'
    Constraints.MinHeight = 50
    ParentColor = True
    TabOrder = 0
    OnResize = Panel2Resize
    object Splitter1: TSplitter
      Left = 4
      Top = 299
      Width = 392
      Height = 4
      Cursor = crVSplit
      Align = alBottom
      ExplicitLeft = 3
      ExplicitTop = 254
      ExplicitWidth = 394
    end
    object MsgDebug: TExRichEdit
      Left = 4
      Top = 4
      Width = 392
      Height = 295
      Align = alClient
      AutoURLDetect = adNone
      CustomURLs = <
        item
          Name = 'e-mail'
          Color = clWindowText
          Cursor = crDefault
          Underline = True
        end
        item
          Name = 'http'
          Color = clWindowText
          Cursor = crDefault
          Underline = True
        end
        item
          Name = 'file'
          Color = clWindowText
          Cursor = crDefault
          Underline = True
        end
        item
          Name = 'mailto'
          Color = clWindowText
          Cursor = crDefault
          Underline = True
        end
        item
          Name = 'ftp'
          Color = clWindowText
          Cursor = crDefault
          Underline = True
        end
        item
          Name = 'https'
          Color = clWindowText
          Cursor = crDefault
          Underline = True
        end
        item
          Name = 'gopher'
          Color = clWindowText
          Cursor = crDefault
          Underline = True
        end
        item
          Name = 'nntp'
          Color = clWindowText
          Cursor = crDefault
          Underline = True
        end
        item
          Name = 'prospero'
          Color = clWindowText
          Cursor = crDefault
          Underline = True
        end
        item
          Name = 'telnet'
          Color = clWindowText
          Cursor = crDefault
          Underline = True
        end
        item
          Name = 'news'
          Color = clWindowText
          Cursor = crDefault
          Underline = True
        end
        item
          Name = 'wais'
          Color = clWindowText
          Cursor = crDefault
          Underline = True
        end>
      ImeMode = imDisable
      LangOptions = [loAutoFont]
      Language = 1033
      ScrollBars = ssVertical
      ShowSelectionBar = False
      TabOrder = 1
      URLColor = clBlue
      URLCursor = crHandPoint
      OnKeyPress = MsgDebugKeyPress
      InputFormat = ifUnicode
      OutputFormat = ofRTF
      SelectedInOut = False
      PlainRTF = False
      UndoLimit = 0
      AllowInPlace = False
    end
    object MemoSend: TExRichEdit
      Left = 4
      Top = 303
      Width = 392
      Height = 40
      Align = alBottom
      AutoURLDetect = adNone
      CustomURLs = <
        item
          Name = 'e-mail'
          Color = clWindowText
          Cursor = crDefault
          Underline = True
        end
        item
          Name = 'http'
          Color = clWindowText
          Cursor = crDefault
          Underline = True
        end
        item
          Name = 'file'
          Color = clWindowText
          Cursor = crDefault
          Underline = True
        end
        item
          Name = 'mailto'
          Color = clWindowText
          Cursor = crDefault
          Underline = True
        end
        item
          Name = 'ftp'
          Color = clWindowText
          Cursor = crDefault
          Underline = True
        end
        item
          Name = 'https'
          Color = clWindowText
          Cursor = crDefault
          Underline = True
        end
        item
          Name = 'gopher'
          Color = clWindowText
          Cursor = crDefault
          Underline = True
        end
        item
          Name = 'nntp'
          Color = clWindowText
          Cursor = crDefault
          Underline = True
        end
        item
          Name = 'prospero'
          Color = clWindowText
          Cursor = crDefault
          Underline = True
        end
        item
          Name = 'telnet'
          Color = clWindowText
          Cursor = crDefault
          Underline = True
        end
        item
          Name = 'news'
          Color = clWindowText
          Cursor = crDefault
          Underline = True
        end
        item
          Name = 'wais'
          Color = clWindowText
          Cursor = crDefault
          Underline = True
        end>
      LangOptions = [loAutoFont]
      Language = 1033
      PopupMenu = PopupMenu1
      ScrollBars = ssVertical
      ShowSelectionBar = False
      TabOrder = 0
      URLColor = clBlue
      URLCursor = crHandPoint
      OnKeyDown = MemoSendKeyDown
      InputFormat = ifRTF
      OutputFormat = ofRTF
      SelectedInOut = False
      PlainRTF = False
      UndoLimit = 0
      AllowInPlace = False
    end
  end
  object PopupMenu1: TTntPopupMenu
    AutoHotkeys = maManual
    Left = 48
    Top = 136
    object Clear1: TTntMenuItem
      Caption = 'Clear '
      ShortCut = 16430
      OnClick = Clear1Click
    end
    object SendXML1: TTntMenuItem
      Caption = 'Send XML'
      ShortCut = 16397
      OnClick = btnSendRawClick
    end
    object Find1: TTntMenuItem
      Caption = 'Find'
      ShortCut = 49222
      OnClick = Find1Click
    end
    object WordWrap1: TTntMenuItem
      Caption = 'Word Wrap'
      Checked = True
      ShortCut = 49239
      OnClick = WordWrap1Click
    end
    object N1: TTntMenuItem
      Caption = '-'
    end
    object popMsg: TTntMenuItem
      Caption = 'Message'
      OnClick = popMsgClick
    end
    object popIQGet: TTntMenuItem
      Caption = 'IQ Get'
      OnClick = popMsgClick
    end
    object popIQSet: TTntMenuItem
      Caption = 'IQ Set'
      OnClick = popMsgClick
    end
    object popPres: TTntMenuItem
      Caption = 'Presence'
      OnClick = popMsgClick
    end
  end
  object FindDialog1: TFindDialog
    Options = [frDown, frHideUpDown]
    OnFind = FindDialog1Find
    Left = 80
    Top = 136
  end
end
