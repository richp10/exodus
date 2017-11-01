inherited frmNewUser: TfrmNewUser
  Left = 216
  Top = 120
  Caption = 'New User Registration Wizard'
  OldCreateOrder = True
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 12
  inherited TntPanel1: TTntPanel
    inherited Panel3: TPanel
      inherited btnBack: TTntButton
        OnClick = btnBackClick
      end
      inherited btnNext: TTntButton
        Left = 83
        Top = 6
        OnClick = btnNextClick
        ExplicitLeft = 83
        ExplicitTop = 6
      end
      inherited btnCancel: TTntButton
        OnClick = btnCancelClick
      end
    end
  end
  inherited Panel1: TPanel
    inherited lblWizardTitle: TTntLabel
      Width = 99
      Caption = 'New User Wizard'
      ExplicitWidth = 99
    end
    inherited lblWizardDetails: TTntLabel
      Caption = 'This wizard will create a new jabber account for you.'
    end
  end
  inherited Tabs: TPageControl
    inherited TabSheet1: TTabSheet
      ExplicitLeft = 4
      ExplicitTop = 27
      ExplicitWidth = 402
      ExplicitHeight = 226
      object TntLabel1: TTntLabel
        Left = 0
        Top = 0
        Width = 360
        Height = 36
        Align = alTop
        Caption = 
          'You must select a server to use for your jabber account. This se' +
          'rver may be a local server provided by your internet service pro' +
          'vider, or you may use one of the public jabber servers.'
        WordWrap = True
      end
      object cboServer: TTntComboBox
        Left = 37
        Top = 74
        Width = 230
        Height = 21
        ItemHeight = 0
        TabOrder = 0
        Text = 'jabber.org'
      end
      object optServer: TTntRadioButton
        Left = 15
        Top = 55
        Width = 296
        Height = 16
        Caption = 'Select a Jabber Server'
        Checked = True
        TabOrder = 1
        TabStop = True
      end
      object optPublic: TTntRadioButton
        Left = 15
        Top = 114
        Width = 296
        Height = 16
        Caption = 'Get a list of public Jabber Servers'
        TabOrder = 2
      end
    end
    object tbsUser: TTabSheet
      Caption = 'tbsUser'
      ImageIndex = 5
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object lblUsername: TTntLabel
        Left = 15
        Top = 59
        Width = 134
        Height = 12
        Caption = 'Enter your desired username:'
        Visible = False
      end
      object lblPassword: TTntLabel
        Left = 15
        Top = 112
        Width = 134
        Height = 12
        Caption = 'Enter your desired password:'
        Visible = False
      end
      object txtUsername: TTntEdit
        Left = 38
        Top = 74
        Width = 229
        Height = 21
        TabOrder = 0
        Visible = False
      end
      object txtPassword: TTntEdit
        Left = 38
        Top = 126
        Width = 229
        Height = 21
        PasswordChar = '*'
        TabOrder = 1
        Visible = False
      end
      object optNewAccount: TTntRadioButton
        Left = 15
        Top = 7
        Width = 281
        Height = 16
        Caption = 'I need to create a new Jabber account'
        Checked = True
        TabOrder = 2
        TabStop = True
        OnClick = optExistingAccountClick
      end
      object optExistingAccount: TTntRadioButton
        Left = 15
        Top = 30
        Width = 281
        Height = 15
        Caption = 'I already have a Jabber account'
        TabOrder = 3
        OnClick = optExistingAccountClick
      end
    end
    object tbsWait: TTabSheet
      Caption = 'tbsWait'
      ImageIndex = 1
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object lblWait: TTntLabel
        Left = 0
        Top = 0
        Width = 57
        Height = 12
        Align = alTop
        Caption = 'Please wait...'
        WordWrap = True
      end
      object aniWait: TAnimate
        Left = 0
        Top = 12
        Width = 371
        Height = 46
        Align = alTop
        CommonAVI = aviFindFolder
        StopFrame = 29
      end
    end
    object tbsXData: TTabSheet
      Caption = 'tbsXData'
      ImageIndex = 2
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      inline xData: TframeXData
        Left = 0
        Top = 0
        Width = 370
        Height = 208
        Align = alClient
        Color = 13681583
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -9
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        TabOrder = 0
        TabStop = True
        ExplicitWidth = 371
        ExplicitHeight = 209
        inherited Panel1: TPanel
          Width = 370
          Height = 208
          ExplicitWidth = 371
          ExplicitHeight = 209
          inherited ScrollBox1: TScrollBox
            Width = 360
            Height = 198
            ExplicitWidth = 361
            ExplicitHeight = 199
          end
        end
      end
    end
    object tbsReg: TTabSheet
      Caption = 'tbsReg'
      ImageIndex = 3
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
    end
    object tbsFinish: TTabSheet
      Caption = 'tbsFinish'
      ImageIndex = 4
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object lblBad: TTntLabel
        Left = 0
        Top = 60
        Width = 371
        Height = 83
        Align = alTop
        AutoSize = False
        Caption = 
          'Your Registration to this service has Failed! Press Back and ver' +
          'ify that all of the parameters have been filled in correctly. Pr' +
          'ess Cancel to close this wizard.'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Visible = False
        WordWrap = True
      end
      object lblOK: TTntLabel
        Left = 0
        Top = 0
        Width = 371
        Height = 60
        Align = alTop
        AutoSize = False
        Caption = 
          'Your Registration to this service has been completed Successfull' +
          'y. You can now add contacts to your Contact List by selecting To' +
          'ols | Contacts from the main menu.'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Visible = False
        WordWrap = True
      end
    end
  end
end
