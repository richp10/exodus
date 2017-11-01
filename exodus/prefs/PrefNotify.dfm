inherited frmPrefNotify: TfrmPrefNotify
  Left = 267
  Top = 154
  Caption = 'frmPrefNotify'
  ClientHeight = 585
  ClientWidth = 379
  OldCreateOrder = True
  OnDestroy = TntFormDestroy
  ExplicitWidth = 391
  ExplicitHeight = 597
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnlHeader: TTntPanel
    Width = 379
    ExplicitWidth = 379
    inherited lblHeader: TTntLabel
      Left = 6
      Width = 77
      Caption = 'Notifications'
      ExplicitLeft = 6
      ExplicitWidth = 77
    end
  end
  object pnlContainer: TExBrandPanel
    Left = 0
    Top = 23
    Width = 371
    Height = 562
    Align = alLeft
    BevelOuter = bvNone
    ParentColor = True
    TabOrder = 1
    AutoHide = False
    ExplicitTop = 8
    object pnlAlertSources: TExBrandPanel
      AlignWithMargins = True
      Left = 0
      Top = 44
      Width = 368
      Height = 216
      Margins.Left = 0
      Margins.Top = 0
      Align = alTop
      AutoSize = True
      BevelOuter = bvNone
      ParentColor = True
      TabOrder = 1
      AutoHide = False
      ExplicitLeft = 3
      ExplicitTop = -20
      object lblNotifySources: TTntLabel
        AlignWithMargins = True
        Left = 0
        Top = 6
        Width = 365
        Height = 13
        Margins.Left = 0
        Margins.Top = 6
        Align = alTop
        Caption = '&Notify me when:'
        FocusControl = chkNotify
        ExplicitWidth = 79
      end
      object chkNotify: TTntCheckListBox
        AlignWithMargins = True
        Left = 0
        Top = 25
        Width = 365
        Height = 188
        Margins.Left = 0
        Align = alTop
        ItemHeight = 13
        Items.Strings = (
          'Contact comes online'
          'Contact goes offline'
          'New conversation is initiated'
          'Message is received'
          'Subscription request is received'
          'Invitation to a conference room is received'
          'Keywords appears in a conference room'
          'Activity in a chat window'
          'High priority activity in a chat window'
          'Activity in a conference room'
          'High priority activity in a conference room'
          'Auto response generated')
        TabOrder = 0
        OnClick = chkNotifyClick
      end
    end
    object gbActions: TExGroupBox
      AlignWithMargins = True
      Left = 0
      Top = 269
      Width = 368
      Height = 118
      Margins.Left = 0
      Margins.Top = 6
      Align = alTop
      AutoSize = True
      BevelOuter = bvNone
      Caption = 'Take the following actions'
      ParentColor = True
      TabOrder = 2
      AutoHide = True
      ExplicitTop = 262
      object chkFlash: TTntCheckBox
        AlignWithMargins = True
        Left = 3
        Top = 38
        Width = 362
        Height = 20
        Margins.Top = 0
        Margins.Bottom = 0
        Align = alTop
        Caption = '&Flash taskbar button or Activity List tab'
        TabOrder = 1
        OnClick = chkToastClick
      end
      object chkFront: TTntCheckBox
        AlignWithMargins = True
        Left = 3
        Top = 58
        Width = 362
        Height = 20
        Margins.Top = 0
        Margins.Bottom = 0
        Align = alTop
        Caption = 'Bring &window to front'
        TabOrder = 2
        OnClick = chkToastClick
      end
      object pnlSoundAction: TExBrandPanel
        AlignWithMargins = True
        Left = 3
        Top = 78
        Width = 362
        Height = 20
        Margins.Top = 0
        Margins.Bottom = 0
        Align = alTop
        AutoSize = True
        BevelOuter = bvNone
        ParentColor = True
        TabOrder = 3
        AutoHide = True
        object chkPlaySound: TTntCheckBox
          Left = 0
          Top = 3
          Width = 79
          Height = 14
          Margins.Top = 0
          Caption = '&Play sound:'
          TabOrder = 0
          OnClick = chkToastClick
        end
        object pnlSoundFile: TExBrandPanel
          AlignWithMargins = True
          Left = 82
          Top = 0
          Width = 277
          Height = 20
          Margins.Left = 0
          Margins.Top = 0
          Margins.Bottom = 0
          Align = alRight
          AutoSize = True
          BevelOuter = bvNone
          ParentColor = True
          TabOrder = 1
          AutoHide = True
          object txtSoundFile: TTntEdit
            Left = 0
            Top = 0
            Width = 178
            Height = 21
            ReadOnly = True
            TabOrder = 0
            OnExit = txtSoundFileExit
          end
          object btnPlaySound: TTntBitBtn
            Left = 186
            Top = 0
            Width = 27
            Height = 20
            TabOrder = 1
            OnClick = btnPlaySoundClick
            Glyph.Data = {
              36030000424D3603000000000000360000002800000010000000100000000100
              1800000000000003000000000000000000000000000000000000C8D0D4C8D0D4
              C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0
              D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4806000FFFFFFC8D0D4C8
              D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4
              C8D0D4C8D0D4806000C06000FFFFFFC8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0
              D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4806000C06000C06000FF
              FFFFC8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4
              C8D0D4C8D0D4806000C06000C06000C06000FFFFFFC8D0D4C8D0D4C8D0D4C8D0
              D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4806000C06000C06000C0
              6000C06000FFFFFFC8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4
              C8D0D4C8D0D4806000C06000C06000C06000C06000C06000C8D0D4C8D0D4C8D0
              D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4806000C06000C06000C0
              6000C06000C06000C06000C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4
              C8D0D4C8D0D4806000C06000C06000C06000C06000C06000C06000C8D0D4C8D0
              D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4806000C06000C06000C0
              6000C06000C06000C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4
              C8D0D4C8D0D4806000C06000C06000C06000C06000C8D0D4C8D0D4C8D0D4C8D0
              D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4806000C06000C06000C0
              6000C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4
              C8D0D4C8D0D4806000C06000C06000C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0
              D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4806000C06000C8D0D4C8
              D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4
              C8D0D4C8D0D4806000C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0
              D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8
              D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4}
          end
          object btnBrowse: TTntButton
            Left = 219
            Top = 0
            Width = 58
            Height = 20
            Caption = '&Browse...'
            TabOrder = 2
            OnClick = btnBrowseClick
          end
        end
      end
      object chkTrayNotify: TTntCheckBox
        AlignWithMargins = True
        Left = 3
        Top = 98
        Width = 362
        Height = 20
        Margins.Top = 0
        Margins.Bottom = 0
        Align = alTop
        Caption = 'Flash tray &icon'
        TabOrder = 4
        OnClick = chkToastClick
      end
      object pnlToast: TExBrandPanel
        AlignWithMargins = True
        Left = 3
        Top = 18
        Width = 362
        Height = 20
        Margins.Top = 0
        Margins.Bottom = 0
        Align = alTop
        AutoSize = True
        BevelOuter = bvNone
        ParentColor = True
        TabOrder = 0
        AutoHide = True
        object chkToast: TTntCheckBox
          Left = 0
          Top = 1
          Width = 135
          Height = 18
          Margins.Top = 0
          Caption = 'Show a desktop &alert'
          TabOrder = 0
          OnClick = chkToastClick
        end
        object btnToastSettings: TTntButton
          Left = 142
          Top = 0
          Width = 61
          Height = 20
          Caption = '&Settings...'
          TabOrder = 1
          OnClick = btnToastSettingsClick
        end
      end
    end
    object gbAdvancedPrefs: TExGroupBox
      AlignWithMargins = True
      Left = 0
      Top = 393
      Width = 368
      Height = 110
      Margins.Left = 0
      Align = alTop
      AutoSize = True
      BevelOuter = bvNone
      Caption = 'Advanced notification preferences'
      ParentColor = True
      TabOrder = 3
      AutoHide = True
      ExplicitTop = 386
      object chkNotifyActive: TTntCheckBox
        AlignWithMargins = True
        Left = 3
        Top = 21
        Width = 362
        Height = 17
        Hint = 
          'NOTE: Notifications always occur when the client is in the backg' +
          'round.'
        Align = alTop
        Caption = 'Perform notifications when using the client'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 1
      end
      object chkNotifyActiveWindow: TTntCheckBox
        AlignWithMargins = True
        Left = 3
        Top = 44
        Width = 362
        Height = 17
        Align = alTop
        Caption = 'Perform notifications for the window I'#39'm typing in'
        TabOrder = 2
      end
      object chkFlashInfinite: TTntCheckBox
        AlignWithMargins = True
        Left = 3
        Top = 67
        Width = 362
        Height = 17
        Align = alTop
        Caption = 'Flash taskbar continuously until the client gets focus'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 3
      end
      object chkFlashTabInfinite: TTntCheckBox
        AlignWithMargins = True
        Left = 3
        Top = 90
        Width = 362
        Height = 17
        Align = alTop
        Caption = 'Flash taskbar until all notified tabs are seen'
        TabOrder = 4
      end
    end
    object pnlTop: TExBrandPanel
      AlignWithMargins = True
      Left = 0
      Top = 0
      Width = 365
      Height = 44
      Margins.Left = 0
      Margins.Top = 0
      Margins.Right = 6
      Margins.Bottom = 0
      Align = alTop
      AutoSize = True
      BevelOuter = bvNone
      ParentColor = True
      TabOrder = 0
      AutoHide = False
      object pnlSoundEnable: TExBrandPanel
        Left = 0
        Top = 0
        Width = 154
        Height = 44
        Align = alLeft
        AutoSize = True
        BevelOuter = bvNone
        ParentColor = True
        TabOrder = 0
        AutoHide = True
        ExplicitLeft = -3
        ExplicitTop = 22
        ExplicitHeight = 41
        object imgSound: TImage
          Left = 0
          Top = 3
          Width = 34
          Height = 34
          AutoSize = True
          Center = True
          Picture.Data = {
            07544269746D6170FE080000424DFE0800000000000036040000280000002200
            0000220000000100080000000000C80400000000000000000000000100000000
            000000000000000080000080000000808000800000008000800080800000C0C0
            C000C0DCC000F0CAA6000020400000206000002080000020A0000020C0000020
            E00000400000004020000040400000406000004080000040A0000040C0000040
            E00000600000006020000060400000606000006080000060A0000060C0000060
            E00000800000008020000080400000806000008080000080A0000080C0000080
            E00000A0000000A0200000A0400000A0600000A0800000A0A00000A0C00000A0
            E00000C0000000C0200000C0400000C0600000C0800000C0A00000C0C00000C0
            E00000E0000000E0200000E0400000E0600000E0800000E0A00000E0C00000E0
            E00040000000400020004000400040006000400080004000A0004000C0004000
            E00040200000402020004020400040206000402080004020A0004020C0004020
            E00040400000404020004040400040406000404080004040A0004040C0004040
            E00040600000406020004060400040606000406080004060A0004060C0004060
            E00040800000408020004080400040806000408080004080A0004080C0004080
            E00040A0000040A0200040A0400040A0600040A0800040A0A00040A0C00040A0
            E00040C0000040C0200040C0400040C0600040C0800040C0A00040C0C00040C0
            E00040E0000040E0200040E0400040E0600040E0800040E0A00040E0C00040E0
            E00080000000800020008000400080006000800080008000A0008000C0008000
            E00080200000802020008020400080206000802080008020A0008020C0008020
            E00080400000804020008040400080406000804080008040A0008040C0008040
            E00080600000806020008060400080606000806080008060A0008060C0008060
            E00080800000808020008080400080806000808080008080A0008080C0008080
            E00080A0000080A0200080A0400080A0600080A0800080A0A00080A0C00080A0
            E00080C0000080C0200080C0400080C0600080C0800080C0A00080C0C00080C0
            E00080E0000080E0200080E0400080E0600080E0800080E0A00080E0C00080E0
            E000C0000000C0002000C0004000C0006000C0008000C000A000C000C000C000
            E000C0200000C0202000C0204000C0206000C0208000C020A000C020C000C020
            E000C0400000C0402000C0404000C0406000C0408000C040A000C040C000C040
            E000C0600000C0602000C0604000C0606000C0608000C060A000C060C000C060
            E000C0800000C0802000C0804000C0806000C0808000C080A000C080C000C080
            E000C0A00000C0A02000C0A04000C0A06000C0A08000C0A0A000C0A0C000C0A0
            E000C0C00000C0C02000C0C04000C0C06000C0C08000C0C0A000F0FBFF00A4A0
            A000808080000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFF
            FF00070707070707070707070707070707070707070707070707070707070707
            0707070700000707070707070707070707070707070707070707070707070707
            07070707070707070000070707070707070707070707070707EDF7F7F7F7EDED
            070707070707070707070707000007070707070707070707070707EDF7ACA4A4
            A4A4A4F7F7ED0707070707070707070700000707070707070707070707EDF7A4
            A4A39B9B9B9B9BA3A4F7ED070707070707070707000007070707070707070707
            EDF7A4A39B52525152525A9B9BA4ACF707070707070707070000070707070707
            07070707F7A49B515AA4A4A4A49B49525A9BA3ACED0707070707070700000707
            07070707070707F7A45A52A4F70707070707F79B49529BA3ACED070707070707
            00000707070707070707EDAC5A52A4F7F7F7070707070707A449529BA4F7ED07
            07070707000007070707070707EDF7A352A4F7F7F70707070707070707F7495A
            9BA4F70707070707000007070707070707F7A4529BA4F7F7F7F7070707070707
            0707A4499BA3F7ED070707070000070707070707EDAC9B52A4A4F7F7F7F7F707
            070707070707079B529BA4ED070707070000070707070707F7A4525BA4A4A4A4
            9B9BA4F707070707070707F7499BA4F70707070700000707070707EDF7A3499B
            A4A49B529B9B9B52A4070707070707079B52A3F7ED07070700000707070707ED
            A49B499BA49B529BE4E4E4E49AA4070707070707AC529BACED07070700000707
            070707F79A49529B9B529B9B9B9BA4A4E452F70707070707F7529BA4ED070707
            00000707070707929252525B5B525B9B9B9B9B9BA49B9B0707070707075B9BA4
            ED070707000007070707A392A49B525B5B52A4A4A4A4A49B9B9B52F707070707
            079B9BA4ED0707070000070707F5929BE4A4495B5252A4F7F7F7A4A49B9B92F7
            F707070707A35AA4ED0707070000070707ED92E4EDED49525B52F7070707F7A4
            9B9B52A4F7ED070707A49BACED0707070000070707ED9BED070752525B51F708
            F60807A4A49B52A4F7F70707079B9BF7ED0707070000070707ED9B07F6F6A452
            52529B070807F7A4A45B52F7F7F7F7F7F75BA3F7070707070000070707F59B07
            FFFF0752525249A40707F7A49B525BACF7F7F7F7F752A4ED0707070700000707
            0707DB07FFFFF65B525252499BA4A49B5252A4A4F7F7F7F7A452F7ED07070707
            000007070707EDDB08F6F6F7495252525249524952A4A4A4A4F7F7F75BA3F707
            0707070700000707070707E4E40707079B495252535B5B9B9B9BA4A4A4A4F7A4
            52F70707070707070000070707070707E49B9CA49B495252525B5B5B9B9B9BA4
            A4A4A452A4ED07070707070700000707070707070707E49BE4ED524952525B5B
            5B9B9BA4A49B52A3ED070707070707070000070707070707070707070707075B
            4952525B5B5B9B9B5B52A4070707070707070707000007070707070707070707
            07070707AC5251525252525252F7070707070707070707070000070707070707
            07070707070707070707EDA4A3A3A4ED07070707070707070707070700000707
            0707070707070707070707070707070707070707070707070707070707070707
            0000070707070707070707070707070707070707070707070707070707070707
            0707070700000707070707070707070707070707070707070707070707070707
            07070707070707070000}
          Proportional = True
          Transparent = True
        end
        object chkSound: TTntCheckBox
          AlignWithMargins = True
          Left = 43
          Top = 12
          Width = 108
          Height = 17
          Margins.Left = 6
          Caption = '&Use sound alerts'
          TabOrder = 0
        end
      end
      object chkSuspendDND: TTntCheckBox
        Left = 160
        Top = 12
        Width = 199
        Height = 17
        Caption = 'Stop notifications when &DND'
        TabOrder = 1
      end
    end
  end
  object dlgOpenSoundFile: TTntOpenDialog
    Filter = '*.wav'
    Title = 'Select Sound File'
    Left = 336
    Top = 448
  end
end
