inherited frmProfile: TfrmProfile
  Left = 368
  Top = 225
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsDialog
  Caption = 'Contact Properties'
  ClientHeight = 428
  ClientWidth = 515
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  ExplicitWidth = 521
  ExplicitHeight = 454
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter1: TSplitter
    Left = 137
    Top = 0
    Height = 394
    ExplicitHeight = 330
  end
  inline frameButtons1: TframeButtons
    Left = 0
    Top = 394
    Width = 515
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
    TabOrder = 0
    TabStop = True
    ExplicitTop = 394
    ExplicitWidth = 515
    ExplicitHeight = 34
    inherited Panel2: TPanel
      Width = 515
      Height = 34
      ExplicitWidth = 515
      ExplicitHeight = 34
      inherited Bevel1: TBevel
        Width = 515
        ExplicitWidth = 454
      end
      inherited Panel1: TPanel
        Left = 355
        Height = 29
        ExplicitLeft = 355
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
  object TreeView1: TTntTreeView
    Left = 0
    Top = 0
    Width = 137
    Height = 394
    Align = alLeft
    BevelWidth = 0
    Indent = 19
    ReadOnly = True
    TabOrder = 1
    OnChange = TreeView1Change
    OnClick = TreeView1Click
    Items.NodeData = {
      0103000000230000000000000000000000FFFFFFFFFFFFFFFF00000000000000
      000542006100730069006300410000000000000000000000FFFFFFFFFFFFFFFF
      00000000010000001450006500720073006F006E0061006C00200049006E0066
      006F0072006D006100740069006F006E00270000000000000000000000FFFFFF
      FFFFFFFFFF000000000000000007410064006400720065007300730039000000
      0000000000000000FFFFFFFFFFFFFFFF00000000010000001057006F0072006B
      00200049006E0066006F0072006D006100740069006F006E0027000000000000
      0000000000FFFFFFFFFFFFFFFF00000000000000000741006400640072006500
      73007300}
    Items.Utf8Data = {
      03000000210000000000000000000000FFFFFFFFFFFFFFFF0000000000000000
      08EFBBBF4261736963300000000000000000000000FFFFFFFFFFFFFFFF000000
      000100000017EFBBBF506572736F6E616C20496E666F726D6174696F6E230000
      000000000000000000FFFFFFFFFFFFFFFF00000000000000000AEFBBBF416464
      726573732C0000000000000000000000FFFFFFFFFFFFFFFF0000000001000000
      13EFBBBF576F726B20496E666F726D6174696F6E230000000000000000000000
      FFFFFFFFFFFFFFFF00000000000000000AEFBBBF41646472657373}
  end
  object PageControl1: TTntPageControl
    Left = 140
    Top = 0
    Width = 375
    Height = 394
    ActivePage = TabSheet1
    Align = alClient
    Style = tsFlatButtons
    TabOrder = 2
    object TabSheet1: TTntTabSheet
      Caption = 'General'
      object lblSubState: TTntLabel
        AlignWithMargins = True
        Left = 6
        Top = 144
        Width = 358
        Height = 13
        Margins.Left = 6
        Margins.Top = 0
        Align = alTop
        Caption = 'lblSubState'
        ExplicitWidth = 54
      end
      object TntPanel1: TTntPanel
        AlignWithMargins = True
        Left = 6
        Top = 17
        Width = 358
        Height = 21
        Margins.Left = 6
        Margins.Top = 0
        Margins.Bottom = 0
        Align = alTop
        BevelOuter = bvNone
        ParentColor = True
        TabOrder = 0
        object TntLabel4: TTntLabel
          AlignWithMargins = True
          Left = 0
          Top = 3
          Width = 51
          Height = 15
          Margins.Left = 0
          Align = alLeft
          Caption = 'Jabber ID:'
          ExplicitHeight = 13
        end
        object lblJID: TTntLabel
          AlignWithMargins = True
          Left = 57
          Top = 3
          Width = 282
          Height = 15
          Align = alClient
          Caption = 'pgmillard@jabber.org'
          ExplicitWidth = 103
          ExplicitHeight = 13
        end
        object aniProfile: TAnimate
          Left = 342
          Top = 0
          Width = 16
          Height = 21
          Align = alRight
          CommonAVI = aviFindFile
          StopFrame = 8
          Visible = False
        end
      end
      object TntPanel2: TTntPanel
        AlignWithMargins = True
        Left = 6
        Top = 38
        Width = 358
        Height = 103
        Margins.Left = 6
        Margins.Top = 0
        Align = alTop
        AutoSize = True
        BevelOuter = bvNone
        ParentColor = True
        TabOrder = 1
        object pnlAllResources: TTntPanel
          AlignWithMargins = True
          Left = 0
          Top = 3
          Width = 352
          Height = 100
          Margins.Left = 0
          Margins.Right = 6
          Margins.Bottom = 0
          Align = alTop
          BevelOuter = bvNone
          TabOrder = 0
          object gridResources: TTntStringGrid
            Left = 0
            Top = 0
            Width = 352
            Height = 100
            Margins.Right = 6
            Align = alClient
            Color = clBtnHighlight
            ColCount = 2
            DefaultRowHeight = 18
            FixedCols = 0
            Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goColSizing]
            TabOrder = 0
            ColWidths = (
              142
              203)
          end
        end
      end
      object ExGroupBox1: TExGroupBox
        AlignWithMargins = True
        Left = 6
        Top = 209
        Width = 355
        Height = 104
        Margins.Left = 6
        Margins.Right = 6
        Align = alTop
        AutoSize = True
        BevelOuter = bvNone
        Caption = 'Basic contact information:'
        ParentColor = True
        TabOrder = 2
        AutoHide = False
        object Label7: TTntLabel
          Left = 1
          Top = 21
          Width = 25
          Height = 13
          Caption = 'First:'
        end
        object Label4: TTntLabel
          Left = 111
          Top = 21
          Width = 34
          Height = 13
          Caption = 'Middle:'
        end
        object Label5: TTntLabel
          Left = 162
          Top = 21
          Width = 24
          Height = 13
          Caption = 'Last:'
        end
        object lblEmail: TTntLabel
          Left = 1
          Top = 67
          Width = 28
          Height = 13
          Cursor = crHandPoint
          Caption = 'Email:'
          OnClick = lblEmailClick
        end
        object picBox: TPaintBox
          AlignWithMargins = True
          Left = 287
          Top = 40
          Width = 64
          Height = 64
          Margins.Top = 0
          Margins.Right = 6
          Margins.Bottom = 0
          OnPaint = picBoxPaint
        end
        object TntLabel1: TTntLabel
          Left = 289
          Top = 21
          Width = 37
          Height = 13
          Caption = 'Avatar:'
        end
        object txtFirst: TTntEdit
          Left = 1
          Top = 40
          Width = 107
          Height = 21
          ParentColor = True
          ReadOnly = True
          TabOrder = 1
        end
        object txtMiddle: TTntEdit
          Left = 112
          Top = 40
          Width = 46
          Height = 21
          ParentColor = True
          ReadOnly = True
          TabOrder = 2
        end
        object txtLast: TTntEdit
          Left = 162
          Top = 40
          Width = 113
          Height = 21
          ParentColor = True
          ReadOnly = True
          TabOrder = 3
        end
        object txtPriEmail: TTntEdit
          Left = 0
          Top = 81
          Width = 275
          Height = 21
          ParentColor = True
          ReadOnly = True
          TabOrder = 4
        end
      end
      object TntPanel4: TTntPanel
        AlignWithMargins = True
        Left = 6
        Top = 163
        Width = 355
        Height = 40
        Margins.Left = 6
        Margins.Right = 6
        Align = alTop
        AutoSize = True
        BevelOuter = bvNone
        ParentColor = True
        TabOrder = 3
        object Label2: TTntLabel
          Left = 1
          Top = 0
          Width = 49
          Height = 13
          Caption = 'Nickname:'
        end
        object txtNick: TTntEdit
          Left = 1
          Top = 17
          Width = 280
          Height = 21
          ParentColor = True
          ReadOnly = True
          TabOrder = 0
        end
        object btnChangeNick: TTntButton
          Left = 287
          Top = 15
          Width = 64
          Height = 25
          Caption = 'Change...'
          TabOrder = 1
          Visible = False
        end
      end
      object gbUserProps: TExGroupBox
        Left = 0
        Top = 0
        Width = 367
        Height = 17
        Align = alTop
        BevelOuter = bvNone
        Caption = '<<USER>> properties:'
        ParentColor = True
        TabOrder = 4
        AutoHide = False
      end
    end
    object TabSheet3: TTntTabSheet
      Caption = 'Personal Info.'
      ImageIndex = 2
      object lblURL: TTntLabel
        Left = 10
        Top = 9
        Width = 67
        Height = 13
        Cursor = crHandPoint
        Caption = 'Personal URL:'
        OnClick = lblEmailClick
      end
      object Label12: TTntLabel
        Left = 10
        Top = 33
        Width = 58
        Height = 13
        Caption = 'Occupation:'
      end
      object Label6: TTntLabel
        Left = 10
        Top = 57
        Width = 44
        Height = 13
        Caption = 'Birthday:'
      end
      object Label28: TTntLabel
        Left = 92
        Top = 78
        Width = 139
        Height = 13
        Caption = 'Typical Format: YYYY-MM-DD'
      end
      object Label8: TTntLabel
        Left = 7
        Top = 102
        Width = 46
        Height = 13
        Caption = 'Voice Tel:'
      end
      object Label9: TTntLabel
        Left = 7
        Top = 126
        Width = 39
        Height = 13
        Caption = 'Fax Tel:'
      end
      object Label3: TTntLabel
        Left = 9
        Top = 145
        Width = 57
        Height = 13
        Caption = 'Description:'
      end
      object txtWeb: TTntEdit
        Left = 92
        Top = 6
        Width = 269
        Height = 21
        ParentColor = True
        ReadOnly = True
        TabOrder = 0
      end
      object cboOcc: TTntComboBox
        Left = 92
        Top = 30
        Width = 269
        Height = 21
        Enabled = False
        ItemHeight = 13
        ParentColor = True
        TabOrder = 1
        Items.Strings = (
          'Accounting/Finance'
          'Computer related (IS, MIS, DP)'
          'Computer related (WWW)'
          'Consulting'
          'Education/training'
          'Engineering'
          'Executive/senior management'
          'General administrative/supervisory'
          'Government/Military'
          'Manufacturing/production/operations'
          'Professional services (medical, legal, etc.)'
          'Research and development'
          'Retired'
          'Sales/marketing/advertising'
          'Self-employed/owner'
          'Student'
          'Unemployed/Between Jobs')
      end
      object txtBDay: TTntEdit
        Left = 92
        Top = 54
        Width = 269
        Height = 21
        ParentColor = True
        ReadOnly = True
        TabOrder = 2
      end
      object txtHomeVoice: TTntEdit
        Left = 91
        Top = 99
        Width = 269
        Height = 21
        ParentColor = True
        ReadOnly = True
        TabOrder = 3
      end
      object txtHomeFax: TTntEdit
        Left = 91
        Top = 123
        Width = 269
        Height = 21
        ParentColor = True
        ReadOnly = True
        TabOrder = 4
      end
      object memDesc: TTntMemo
        Left = 10
        Top = 164
        Width = 351
        Height = 97
        ParentColor = True
        ReadOnly = True
        ScrollBars = ssVertical
        TabOrder = 5
        WantTabs = True
      end
    end
    object TabSheet4: TTntTabSheet
      Caption = 'Home'
      ImageIndex = 3
      object Label13: TTntLabel
        Left = 10
        Top = 129
        Width = 43
        Height = 13
        Caption = 'Country:'
      end
      object Label21: TTntLabel
        Left = 10
        Top = 79
        Width = 73
        Height = 13
        Caption = 'State / Region:'
      end
      object Label29: TTntLabel
        Left = 10
        Top = 36
        Width = 52
        Height = 13
        Caption = 'Address 2:'
      end
      object Label30: TTntLabel
        Left = 10
        Top = 12
        Width = 52
        Height = 13
        Caption = 'Address 1:'
      end
      object Label31: TTntLabel
        Left = 10
        Top = 57
        Width = 69
        Height = 13
        Caption = 'City / Locality:'
      end
      object Label32: TTntLabel
        Left = 10
        Top = 103
        Width = 85
        Height = 13
        Caption = 'Zip / Postal Code:'
      end
      object txtHomeState: TTntEdit
        Left = 102
        Top = 78
        Width = 259
        Height = 21
        ParentColor = True
        ReadOnly = True
        TabOrder = 0
      end
      object txtHomeZip: TTntEdit
        Left = 102
        Top = 102
        Width = 259
        Height = 21
        ParentColor = True
        ReadOnly = True
        TabOrder = 1
      end
      object txtHomeCity: TTntEdit
        Left = 102
        Top = 54
        Width = 259
        Height = 21
        ParentColor = True
        ReadOnly = True
        TabOrder = 2
      end
      object txtHomeStreet2: TTntEdit
        Left = 102
        Top = 30
        Width = 259
        Height = 21
        ParentColor = True
        ReadOnly = True
        TabOrder = 3
      end
      object txtHomeStreet1: TTntEdit
        Left = 102
        Top = 6
        Width = 259
        Height = 21
        ParentColor = True
        ReadOnly = True
        TabOrder = 4
      end
      object txtHomeCountry: TTntComboBox
        Left = 102
        Top = 127
        Width = 259
        Height = 21
        Enabled = False
        ItemHeight = 13
        ParentColor = True
        TabOrder = 5
        Text = 'United States  '
        Items.Strings = (
          'Afghanistan  '
          'Albania  '
          'Algeria  '
          'American Samoa  '
          'Andorra  '
          'Angola  '
          'Anguilla  '
          'Antarctica  '
          'Antigua and Barbuda  '
          'Argentina  '
          'Armenia  '
          'Aruba  '
          'Australia  '
          'Austria  '
          'Azerbaijan  '
          'Bahamas  '
          'Bahrain  '
          'Bangladesh  '
          'Barbados  '
          'Belarus  '
          'Belgium  '
          'Belize  '
          'Benin  '
          'Bermuda  '
          'Bhutan  '
          'Bolivia  '
          'Bosnia and Herzogovina  '
          'Botswana  '
          'Bouvet Island  '
          'Brazil  '
          'British Indian Ocean Territory  '
          'Brunei Darussalam  '
          'Bulgaria  '
          'Burkina Faso  '
          'Burundi  '
          'Cambodia  '
          'Cameroon  '
          'Canada  '
          'Cape Verde  '
          'Cayman Islands  '
          'Central African Republic  '
          'Chad  '
          'Chile  '
          'China  '
          'Christmas Island  '
          'Cocos (Keeling) Islands  '
          'Columbia  '
          'Comoros  '
          'Congo (Republic of) '
          'Congo (Democratic Republic of) '
          'Cook Islands  '
          'Costa Rica  '
          'Cote d'#39'Ivoire  '
          'Croatia  '
          'Cuba  '
          'Cyprus  '
          'Czech Republic  '
          'Denmark  '
          'Djibouti  '
          'Dominica  '
          'Dominican Republic  '
          'East Timor  '
          'Ecuador  '
          'Egypt  '
          'El Salvador  '
          'Equatorial Guinea  '
          'Eritrea  '
          'Estonia  '
          'Ethiopia  '
          'Falkland Islands (Malvinas) '
          'Faroe Islands  '
          'Fiji  '
          'Finland  '
          'France  '
          'French Guiana  '
          'French Polynesia  '
          'French Southern Territories  '
          'Gabon  '
          'Gambia  '
          'Georgia  '
          'Germany  '
          'Ghana  '
          'Gibraltar  '
          'Greece  '
          'Greenland  '
          'Grenada  '
          'Guadeloupe  '
          'Guam  '
          'Guatemala  '
          'Guinea  '
          'Guinea-Bissau  '
          'Guyana  '
          'Haiti  '
          'Heard Island and McDonald Islands  '
          'Holy See (Vatican City State) '
          'Honduras  '
          'Hong Kong  '
          'Hungary  '
          'Iceland  '
          'India  '
          'Indonesia  '
          'Iran, Islamic Republic of  '
          'Iraq  '
          'Ireland  '
          'Israel  '
          'Italy  '
          'Jamaica  '
          'Japan  '
          'Jordan  '
          'Kazakhstan  '
          'Kenya  '
          'Kiribati  '
          'Korea, Democratic People'#39's Republic of  '
          'Korea, Republic of  '
          'Kuwait  '
          'Kyrgyzstan  '
          'Lao People'#39's Democratic Republic  '
          'Latvia  '
          'Lebanon  '
          'Lesotho  '
          'Liberia  '
          'Libyan Arab Jamahiriya  '
          'Liechtenstein  '
          'Lithuania  '
          'Luxembourg  '
          'Macau  '
          'Macedonia  '
          'Madagascar  '
          'Malawi  '
          'Malaysia  '
          'Maldives  '
          'Mali  '
          'Malta  '
          'Marshall Islands  '
          'Martinique  '
          'Mauritania  '
          'Mauritius  '
          'Mayotte  '
          'Mexico  '
          'Micronesia, Federated States of  '
          'Moldova, Republic of  '
          'Monaco  '
          'Mongolia  '
          'Montserrat  '
          'Morocco  '
          'Mozambique  '
          'Myanmar  '
          'Namibia  '
          'Nauru  '
          'Nepal  '
          'Netherlands  '
          'Netherlands Antilles  '
          'New Caledonia  '
          'New Zealand  '
          'Nicaragua  '
          'Niger  '
          'Nigeria  '
          'Niue  '
          'Norfolk Island  '
          'Nothern Mariana Islands  '
          'Norway  '
          'Oman  '
          'Pakistan  '
          'Palau  '
          'Palestinian Territory, Occupied  '
          'Panama  '
          'Papua New Guinea  '
          'Paraguay  '
          'Peru  '
          'Philippines  '
          'Pitcairn  '
          'Poland  '
          'Portugal  '
          'Puerto Rico  '
          'Qatar  '
          'Reunion  '
          'Romania  '
          'Russian Federation  '
          'Rwanda  '
          'Saint Helena  '
          'Saint Kitts and Nevis  '
          'Saint Lucia  '
          'Saint Pierre and Miquelon  '
          'Saint Vincent and the Grenadines  '
          'Samoa  '
          'San Marino  '
          'Sao Tome and Principe  '
          'Saudi Arabia  '
          'Senegal  '
          'Seychelles  '
          'Sierra Leone  '
          'Singapore  '
          'Slovakia  '
          'Slovenia  '
          'Solomon Islands  '
          'Somalia  '
          'South Africa  '
          'South Georgia and the South Sandwich Islands  '
          'Spain  '
          'Sri Lanka  '
          'Sudan  '
          'Suriname  '
          'Svalbard and Jan Mayen Islands  '
          'Swaziland  '
          'Sweden  '
          'Switzerland  '
          'Syrian Arab Republic  '
          'Taiwan, Province of China  '
          'Tajikistan  '
          'Tanzania, United Republic of  '
          'Thailand  '
          'Togo  '
          'Tokelau  '
          'Tonga  '
          'Trinidad and Tobago  '
          'Tunisia  '
          'Turkey  '
          'Turkmenistan  '
          'Turks and Caicos Islands  '
          'Tuvalu  '
          'Uganda  '
          'Ukraine  '
          'United Arab Emirates  '
          'United Kingdom  '
          'United States  '
          'United States Minor Outlying Islands  '
          'Uruguay  '
          'Uzbekistan  '
          'Vanuatu  '
          'Venezuela  '
          'Vietnam  '
          'Virgin Islands, British  '
          'Virgin Islands, U.S.  '
          'Wallis and Futuna  '
          'Western Sahara  '
          'Yemen  '
          'Yugoslavia  '
          'Zambia  '
          'Zimbabwe  ')
      end
    end
    object TabSheet5: TTntTabSheet
      Caption = 'Work'
      ImageIndex = 4
      object Label22: TTntLabel
        Left = 10
        Top = 9
        Width = 79
        Height = 13
        Caption = 'Company Name:'
      end
      object Label23: TTntLabel
        Left = 10
        Top = 33
        Width = 82
        Height = 13
        Caption = 'Org. Unit (Dept):'
      end
      object Label24: TTntLabel
        Left = 10
        Top = 57
        Width = 24
        Height = 13
        Caption = 'Title:'
      end
      object Label19: TTntLabel
        Left = 10
        Top = 87
        Width = 46
        Height = 13
        Caption = 'Voice Tel:'
      end
      object Label20: TTntLabel
        Left = 10
        Top = 111
        Width = 39
        Height = 13
        Caption = 'Fax Tel:'
      end
      object txtOrgName: TTntEdit
        Left = 102
        Top = 6
        Width = 259
        Height = 21
        ParentColor = True
        ReadOnly = True
        TabOrder = 0
      end
      object txtOrgUnit: TTntEdit
        Left = 102
        Top = 30
        Width = 259
        Height = 21
        ParentColor = True
        ReadOnly = True
        TabOrder = 1
      end
      object txtOrgTitle: TTntEdit
        Left = 102
        Top = 54
        Width = 259
        Height = 21
        ParentColor = True
        ReadOnly = True
        TabOrder = 2
      end
      object txtWorkVoice: TTntEdit
        Left = 102
        Top = 84
        Width = 259
        Height = 21
        ParentColor = True
        ReadOnly = True
        TabOrder = 3
      end
      object txtWorkFax: TTntEdit
        Left = 102
        Top = 108
        Width = 259
        Height = 21
        ParentColor = True
        ReadOnly = True
        TabOrder = 4
      end
    end
    object TabSheet6: TTntTabSheet
      Caption = 'Address'
      ImageIndex = 5
      object Label15: TTntLabel
        Left = 10
        Top = 77
        Width = 73
        Height = 13
        Caption = 'State / Region:'
      end
      object Label16: TTntLabel
        Left = 10
        Top = 127
        Width = 43
        Height = 13
        Caption = 'Country:'
      end
      object Label17: TTntLabel
        Left = 10
        Top = 34
        Width = 52
        Height = 13
        Caption = 'Address 2:'
      end
      object Label18: TTntLabel
        Left = 10
        Top = 10
        Width = 52
        Height = 13
        Caption = 'Address 1:'
      end
      object Label26: TTntLabel
        Left = 10
        Top = 55
        Width = 69
        Height = 13
        Caption = 'City / Locality:'
      end
      object Label14: TTntLabel
        Left = 10
        Top = 101
        Width = 85
        Height = 13
        Caption = 'Zip / Postal Code:'
      end
      object txtWorkState: TTntEdit
        Left = 102
        Top = 76
        Width = 259
        Height = 21
        ParentColor = True
        ReadOnly = True
        TabOrder = 0
      end
      object txtWorkZip: TTntEdit
        Left = 102
        Top = 100
        Width = 259
        Height = 21
        ParentColor = True
        ReadOnly = True
        TabOrder = 1
      end
      object txtWorkCity: TTntEdit
        Left = 102
        Top = 52
        Width = 259
        Height = 21
        ParentColor = True
        ReadOnly = True
        TabOrder = 2
      end
      object txtWorkStreet2: TTntEdit
        Left = 102
        Top = 28
        Width = 259
        Height = 21
        ParentColor = True
        ReadOnly = True
        TabOrder = 3
      end
      object txtWorkStreet1: TTntEdit
        Left = 102
        Top = 4
        Width = 259
        Height = 21
        ParentColor = True
        ReadOnly = True
        TabOrder = 4
      end
      object txtWorkCountry: TTntComboBox
        Left = 102
        Top = 125
        Width = 259
        Height = 21
        Enabled = False
        ItemHeight = 13
        ParentColor = True
        TabOrder = 5
        Text = 'United States  '
        Items.Strings = (
          'Afghanistan  '
          'Albania  '
          'Algeria  '
          'American Samoa  '
          'Andorra  '
          'Angola  '
          'Anguilla  '
          'Antarctica  '
          'Antigua and Barbuda  '
          'Argentina  '
          'Armenia  '
          'Aruba  '
          'Australia  '
          'Austria  '
          'Azerbaijan  '
          'Bahamas  '
          'Bahrain  '
          'Bangladesh  '
          'Barbados  '
          'Belarus  '
          'Belgium  '
          'Belize  '
          'Benin  '
          'Bermuda  '
          'Bhutan  '
          'Bolivia  '
          'Bosnia and Herzogovina  '
          'Botswana  '
          'Bouvet Island  '
          'Brazil  '
          'British Indian Ocean Territory  '
          'Brunei Darussalam  '
          'Bulgaria  '
          'Burkina Faso  '
          'Burundi  '
          'Cambodia  '
          'Cameroon  '
          'Canada  '
          'Cape Verde  '
          'Cayman Islands  '
          'Central African Republic  '
          'Chad  '
          'Chile  '
          'China  '
          'Christmas Island  '
          'Cocos (Keeling) Islands  '
          'Columbia  '
          'Comoros  '
          'Congo (Republic of) '
          'Congo (Democratic Republic of) '
          'Cook Islands  '
          'Costa Rica  '
          'Cote d'#39'Ivoire  '
          'Croatia  '
          'Cuba  '
          'Cyprus  '
          'Czech Republic  '
          'Denmark  '
          'Djibouti  '
          'Dominica  '
          'Dominican Republic  '
          'East Timor  '
          'Ecuador  '
          'Egypt  '
          'El Salvador  '
          'Equatorial Guinea  '
          'Eritrea  '
          'Estonia  '
          'Ethiopia  '
          'Falkland Islands (Malvinas) '
          'Faroe Islands  '
          'Fiji  '
          'Finland  '
          'France  '
          'French Guiana  '
          'French Polynesia  '
          'French Southern Territories  '
          'Gabon  '
          'Gambia  '
          'Georgia  '
          'Germany  '
          'Ghana  '
          'Gibraltar  '
          'Greece  '
          'Greenland  '
          'Grenada  '
          'Guadeloupe  '
          'Guam  '
          'Guatemala  '
          'Guinea  '
          'Guinea-Bissau  '
          'Guyana  '
          'Haiti  '
          'Heard Island and McDonald Islands  '
          'Holy See (Vatican City State) '
          'Honduras  '
          'Hong Kong  '
          'Hungary  '
          'Iceland  '
          'India  '
          'Indonesia  '
          'Iran, Islamic Republic of  '
          'Iraq  '
          'Ireland  '
          'Israel  '
          'Italy  '
          'Jamaica  '
          'Japan  '
          'Jordan  '
          'Kazakhstan  '
          'Kenya  '
          'Kiribati  '
          'Korea, Democratic People'#39's Republic of  '
          'Korea, Republic of  '
          'Kuwait  '
          'Kyrgyzstan  '
          'Lao People'#39's Democratic Republic  '
          'Latvia  '
          'Lebanon  '
          'Lesotho  '
          'Liberia  '
          'Libyan Arab Jamahiriya  '
          'Liechtenstein  '
          'Lithuania  '
          'Luxembourg  '
          'Macau  '
          'Macedonia  '
          'Madagascar  '
          'Malawi  '
          'Malaysia  '
          'Maldives  '
          'Mali  '
          'Malta  '
          'Marshall Islands  '
          'Martinique  '
          'Mauritania  '
          'Mauritius  '
          'Mayotte  '
          'Mexico  '
          'Micronesia, Federated States of  '
          'Moldova, Republic of  '
          'Monaco  '
          'Mongolia  '
          'Montserrat  '
          'Morocco  '
          'Mozambique  '
          'Myanmar  '
          'Namibia  '
          'Nauru  '
          'Nepal  '
          'Netherlands  '
          'Netherlands Antilles  '
          'New Caledonia  '
          'New Zealand  '
          'Nicaragua  '
          'Niger  '
          'Nigeria  '
          'Niue  '
          'Norfolk Island  '
          'Nothern Mariana Islands  '
          'Norway  '
          'Oman  '
          'Pakistan  '
          'Palau  '
          'Palestinian Territory, Occupied  '
          'Panama  '
          'Papua New Guinea  '
          'Paraguay  '
          'Peru  '
          'Philippines  '
          'Pitcairn  '
          'Poland  '
          'Portugal  '
          'Puerto Rico  '
          'Qatar  '
          'Reunion  '
          'Romania  '
          'Russian Federation  '
          'Rwanda  '
          'Saint Helena  '
          'Saint Kitts and Nevis  '
          'Saint Lucia  '
          'Saint Pierre and Miquelon  '
          'Saint Vincent and the Grenadines  '
          'Samoa  '
          'San Marino  '
          'Sao Tome and Principe  '
          'Saudi Arabia  '
          'Senegal  '
          'Seychelles  '
          'Sierra Leone  '
          'Singapore  '
          'Slovakia  '
          'Slovenia  '
          'Solomon Islands  '
          'Somalia  '
          'South Africa  '
          'South Georgia and the South Sandwich Islands  '
          'Spain  '
          'Sri Lanka  '
          'Sudan  '
          'Suriname  '
          'Svalbard and Jan Mayen Islands  '
          'Swaziland  '
          'Sweden  '
          'Switzerland  '
          'Syrian Arab Republic  '
          'Taiwan, Province of China  '
          'Tajikistan  '
          'Tanzania, United Republic of  '
          'Thailand  '
          'Togo  '
          'Tokelau  '
          'Tonga  '
          'Trinidad and Tobago  '
          'Tunisia  '
          'Turkey  '
          'Turkmenistan  '
          'Turks and Caicos Islands  '
          'Tuvalu  '
          'Uganda  '
          'Ukraine  '
          'United Arab Emirates  '
          'United Kingdom  '
          'United States  '
          'United States Minor Outlying Islands  '
          'Uruguay  '
          'Uzbekistan  '
          'Vanuatu  '
          'Venezuela  '
          'Vietnam  '
          'Virgin Islands, British  '
          'Virgin Islands, U.S.  '
          'Wallis and Futuna  '
          'Western Sahara  '
          'Yemen  '
          'Yugoslavia  '
          'Zambia  '
          'Zimbabwe  ')
      end
    end
  end
end
