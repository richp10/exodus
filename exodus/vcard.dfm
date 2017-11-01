inherited frmVCard: TfrmVCard
  Left = 201
  Top = 119
  Caption = 'My Profile'
  ClientHeight = 359
  ClientWidth = 442
  DefaultMonitor = dmDesktop
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  ExplicitWidth = 450
  ExplicitHeight = 387
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter1: TSplitter
    Left = 153
    Top = 0
    Height = 325
    ExplicitHeight = 292
  end
  object PageControl1: TTntPageControl
    Left = 156
    Top = 0
    Width = 286
    Height = 325
    ActivePage = TabSheet1
    Align = alClient
    Style = tsFlatButtons
    TabOrder = 0
    object TabSheet1: TTntTabSheet
      Caption = 'General'
      object TntLabel1: TTntLabel
        Left = 4
        Top = 144
        Width = 26
        Height = 13
        Cursor = crHandPoint
        Caption = 'Web:'
      end
      object PaintBox1: TPaintBox
        Left = 56
        Top = 178
        Width = 90
        Height = 90
        OnPaint = PaintBox1Paint
      end
      object Label2: TTntLabel
        Left = 3
        Top = 96
        Width = 23
        Height = 13
        Caption = 'Nick:'
      end
      object lblEmail: TTntLabel
        Left = 4
        Top = 115
        Width = 28
        Height = 13
        Cursor = crHandPoint
        Caption = 'Email:'
      end
      object Label7: TTntLabel
        Left = 2
        Top = 6
        Width = 59
        Height = 13
        Caption = 'First (Given)'
      end
      object Label5: TTntLabel
        Left = 2
        Top = 64
        Width = 61
        Height = 13
        Caption = 'Last (Family)'
      end
      object lblURL: TTntLabel
        Left = 3
        Top = 181
        Width = 37
        Height = 13
        Cursor = crHandPoint
        Caption = 'Picture:'
      end
      object TntLabel2: TTntLabel
        Left = 2
        Top = 37
        Width = 30
        Height = 13
        Caption = 'Middle'
      end
      object btnPicBrowse: TTntButton
        Left = 171
        Top = 176
        Width = 75
        Height = 25
        Caption = 'Browse'
        TabOrder = 6
        OnClick = btnPicBrowseClick
      end
      object txtNick: TTntEdit
        Left = 56
        Top = 88
        Width = 187
        Height = 21
        TabOrder = 3
      end
      object txtPriEmail: TTntEdit
        Left = 56
        Top = 115
        Width = 187
        Height = 21
        TabOrder = 4
      end
      object txtFirst: TTntEdit
        Left = 73
        Top = 5
        Width = 168
        Height = 21
        TabOrder = 0
      end
      object txtLast: TTntEdit
        Left = 73
        Top = 59
        Width = 169
        Height = 21
        TabOrder = 2
      end
      object txtWeb: TTntEdit
        Left = 56
        Top = 141
        Width = 187
        Height = 21
        TabOrder = 5
      end
      object btnPicClear: TTntButton
        Left = 171
        Top = 204
        Width = 75
        Height = 25
        Caption = 'Clear'
        TabOrder = 7
        OnClick = btnPicClearClick
      end
      object txtMiddle: TTntEdit
        Left = 73
        Top = 32
        Width = 169
        Height = 21
        TabOrder = 1
      end
    end
    object TabSheet3: TTntTabSheet
      Caption = 'Personal Info.'
      ImageIndex = 2
      object Label12: TTntLabel
        Left = 4
        Top = 9
        Width = 58
        Height = 13
        Caption = 'Occupation:'
      end
      object Label6: TTntLabel
        Left = 4
        Top = 35
        Width = 44
        Height = 13
        Caption = 'Birthday:'
      end
      object Label28: TTntLabel
        Left = 92
        Top = 56
        Width = 139
        Height = 13
        Caption = 'Typical Format: YYYY-MM-DD'
      end
      object Label8: TTntLabel
        Left = 1
        Top = 86
        Width = 46
        Height = 13
        Caption = 'Voice Tel:'
      end
      object Label9: TTntLabel
        Left = 1
        Top = 113
        Width = 39
        Height = 13
        Caption = 'Fax Tel:'
      end
      object Label1: TTntLabel
        Left = 1
        Top = 137
        Width = 57
        Height = 13
        Caption = 'Description:'
      end
      object cboOcc: TTntComboBox
        Left = 92
        Top = 6
        Width = 150
        Height = 21
        ItemHeight = 13
        TabOrder = 0
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
        Top = 32
        Width = 150
        Height = 21
        TabOrder = 1
      end
      object txtHomeVoice: TTntEdit
        Left = 91
        Top = 83
        Width = 150
        Height = 21
        TabOrder = 2
      end
      object txtHomeFax: TTntEdit
        Left = 91
        Top = 110
        Width = 150
        Height = 21
        TabOrder = 3
      end
      object memDesc: TTntMemo
        Left = 8
        Top = 152
        Width = 289
        Height = 105
        ScrollBars = ssVertical
        TabOrder = 4
      end
    end
    object TabSheet4: TTntTabSheet
      Caption = 'Home'
      ImageIndex = 3
      object Label13: TTntLabel
        Left = 10
        Top = 139
        Width = 43
        Height = 13
        Caption = 'Country:'
      end
      object Label21: TTntLabel
        Left = 10
        Top = 85
        Width = 73
        Height = 13
        Caption = 'State / Region:'
      end
      object Label29: TTntLabel
        Left = 10
        Top = 38
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
        Top = 61
        Width = 69
        Height = 13
        Caption = 'City / Locality:'
      end
      object Label32: TTntLabel
        Left = 10
        Top = 111
        Width = 85
        Height = 13
        Caption = 'Zip / Postal Code:'
      end
      object txtHomeCountry: TTntComboBox
        Left = 102
        Top = 137
        Width = 150
        Height = 21
        ItemHeight = 13
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
          'Cocos (Keeling) '
          'Islands  '
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
      object txtHomeState: TTntEdit
        Left = 102
        Top = 84
        Width = 150
        Height = 21
        TabOrder = 3
      end
      object txtHomeZip: TTntEdit
        Left = 102
        Top = 110
        Width = 150
        Height = 21
        TabOrder = 4
      end
      object txtHomeCity: TTntEdit
        Left = 102
        Top = 58
        Width = 150
        Height = 21
        TabOrder = 2
      end
      object txtHomeStreet2: TTntEdit
        Left = 102
        Top = 32
        Width = 150
        Height = 21
        TabOrder = 1
      end
      object txtHomeStreet1: TTntEdit
        Left = 102
        Top = 6
        Width = 150
        Height = 21
        TabOrder = 0
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
        Top = 35
        Width = 82
        Height = 13
        Caption = 'Org. Unit (Dept):'
      end
      object Label24: TTntLabel
        Left = 10
        Top = 61
        Width = 24
        Height = 13
        Caption = 'Title:'
      end
      object Label19: TTntLabel
        Left = 10
        Top = 91
        Width = 46
        Height = 13
        Caption = 'Voice Tel:'
      end
      object Label20: TTntLabel
        Left = 10
        Top = 117
        Width = 39
        Height = 13
        Caption = 'Fax Tel:'
      end
      object txtOrgName: TTntEdit
        Left = 102
        Top = 6
        Width = 150
        Height = 21
        TabOrder = 0
      end
      object txtOrgUnit: TTntEdit
        Left = 102
        Top = 32
        Width = 150
        Height = 21
        TabOrder = 1
      end
      object txtOrgTitle: TTntEdit
        Left = 102
        Top = 58
        Width = 150
        Height = 21
        TabOrder = 2
      end
      object txtWorkVoice: TTntEdit
        Left = 102
        Top = 88
        Width = 150
        Height = 21
        TabOrder = 3
      end
      object txtWorkFax: TTntEdit
        Left = 102
        Top = 114
        Width = 150
        Height = 21
        TabOrder = 4
      end
    end
    object TabSheet6: TTntTabSheet
      Caption = 'TabSheet6'
      ImageIndex = 5
      object Label15: TTntLabel
        Left = 10
        Top = 83
        Width = 73
        Height = 13
        Caption = 'State / Region:'
      end
      object Label16: TTntLabel
        Left = 10
        Top = 135
        Width = 43
        Height = 13
        Caption = 'Country:'
      end
      object Label17: TTntLabel
        Left = 10
        Top = 36
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
        Top = 59
        Width = 69
        Height = 13
        Caption = 'City / Locality:'
      end
      object Label14: TTntLabel
        Left = 10
        Top = 108
        Width = 85
        Height = 13
        Caption = 'Zip / Postal Code:'
      end
      object txtWorkCountry: TTntComboBox
        Left = 102
        Top = 133
        Width = 150
        Height = 21
        ItemHeight = 13
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
          'Cocos (Keeling) '
          'Islands  '
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
      object txtWorkState: TTntEdit
        Left = 102
        Top = 82
        Width = 150
        Height = 21
        TabOrder = 3
      end
      object txtWorkZip: TTntEdit
        Left = 102
        Top = 107
        Width = 150
        Height = 21
        TabOrder = 4
      end
      object txtWorkCity: TTntEdit
        Left = 102
        Top = 56
        Width = 150
        Height = 21
        TabOrder = 2
      end
      object txtWorkStreet2: TTntEdit
        Left = 102
        Top = 30
        Width = 150
        Height = 21
        TabOrder = 1
      end
      object txtWorkStreet1: TTntEdit
        Left = 102
        Top = 4
        Width = 150
        Height = 21
        TabOrder = 0
      end
    end
  end
  inline frameButtons1: TframeButtons
    Left = 0
    Top = 325
    Width = 442
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
    ExplicitTop = 325
    ExplicitWidth = 442
    ExplicitHeight = 34
    inherited Panel2: TPanel
      Width = 442
      Height = 34
      ExplicitWidth = 442
      ExplicitHeight = 34
      inherited Bevel1: TBevel
        Width = 442
        ExplicitWidth = 442
      end
      inherited Panel1: TPanel
        Left = 282
        Height = 29
        ExplicitLeft = 282
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
    Width = 153
    Height = 325
    Align = alLeft
    BevelWidth = 0
    Indent = 19
    TabOrder = 2
    OnClick = TreeView1Click
  end
  object OpenPic: TOpenPictureDialog
    Filter = 
      'All (*.jpg;*.jpeg;*.jpg;*.jpeg;*.gif, *.bmp)|*.jpg;*.jpeg;*.jpg;' +
      '*.jpeg;*.bmp;*.gif;*.png|JPEG Image File (*.jpg)|*.jpg;*jpeg;|GI' +
      'F Image (*.gif)|*.gif|Bitmaps (*.bmp)|*.bmp|Icons (*.ico)|*.ico|' +
      'PNG Image (*.png)|*.png'
    Left = 335
    Top = 265
  end
end
