{
    Copyright 2001-2008, Estate of Peter Millard
	
	This file is part of Exodus.
	
	Exodus is free software; you can redistribute it and/or modify
	it under the terms of the GNU General Public License as published by
	the Free Software Foundation; either version 2 of the License, or
	(at your option) any later version.
	
	Exodus is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU General Public License for more details.
	
	You should have received a copy of the GNU General Public License
	along with Exodus; if not, write to the Free Software
	Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
}
unit PrefDisplay;


interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, PrefPanel, StdCtrls, ComCtrls, RichEdit2, ExRichEdit, ExtCtrls,
  TntStdCtrls, TntExtCtrls, TntComCtrls, ExGroupBox, TntForms, ExFrame,
  ExBrandPanel, ExNumericEdit, IEMsgList;

type
  TfrmPrefDisplay = class(TfrmPrefPanel)
    FontDialog1: TFontDialog;
    TntScrollBox1: TTntScrollBox;
    pnlContainer: TExBrandPanel;
    gbContactList: TExGroupBox;
    lblRosterBG: TTntLabel;
    lblRosterFG: TTntLabel;
    lblRosterPreview: TTntLabel;
    cbRosterBG: TColorBox;
    cbRosterFont: TColorBox;
    btnRosterFont: TTntButton;
    colorRoster: TTntTreeView;
    gbActivityWindow: TExGroupBox;
    lblChatPreview: TTntLabel;
    Label5: TTntLabel;
    lblChatWindowElement: TTntLabel;
    lblChatFG: TTntLabel;
    colorChat: TExRichEdit;
    cboChatElement: TTntComboBox;
    btnChatFont: TTntButton;
    cbChatFont: TColorBox;
    gbOtherPrefs: TExGroupBox;
    chkRTEnabled: TTntCheckBox;
    pnlTimeStamp: TExBrandPanel;
    lblTimestampFmt: TTntLabel;
    chkTimestamp: TTntCheckBox;
    txtTimestampFmt: TTntComboBox;
    chkShowPriority: TTntCheckBox;
    chkChatAvatars: TTntCheckBox;
    pnlEmoticons: TExBrandPanel;
    chkEmoticons: TTntCheckBox;
    btnEmoSettings: TTntButton;
    gbAdvancedPrefs: TExGroupBox;
    pnlAdvancedLeft: TExBrandPanel;
    gbRTIncludes: TExGroupBox;
    chkAllowFontFamily: TTntCheckBox;
    chkAllowFontSize: TTntCheckBox;
    chkAllowFontColor: TTntCheckBox;
    gbChatOptions: TExGroupBox;
    chkBusy: TTntCheckBox;
    chkEscClose: TTntCheckBox;
    pnlChatHotkey: TExBrandPanel;
    lblClose: TTntLabel;
    txtCloseHotkey: THotKey;
    pnlChatMemory: TExBrandPanel;
    lblMem1: TTntLabel;
    trkChatMemory: TTrackBar;
    txtChatMemory: TExNumericEdit;
    pnlSnapTo: TExBrandPanel;
    chkSnap: TTntCheckBox;
    trkSnap: TTrackBar;
    txtSnap: TExNumericEdit;
    lblChatBG: TTntLabel;
    cbChatBG: TColorBox;
    btnManageTabs: TTntButton;
    pnlGlueWindows: TExBrandPanel;
    chkGlue: TTntCheckBox;
    trkGlue: TTrackBar;
    txtGlue: TExNumericEdit;
    pnlDateSeparator: TExBrandPanel;
    lblDateSeparatorFmt: TTntLabel;
    chkDateSeparator: TTntCheckBox;
    txtDateSeparatorFmt: TTntComboBox;
    procedure btnEmoSettingsClick(Sender: TObject);
    procedure chkEmoticonsClick(Sender: TObject);
    procedure txtChatMemoryChange(Sender: TObject);
    procedure trkChatMemoryChange(Sender: TObject);
    procedure txtSnapChange(Sender: TObject);
    procedure trkSnapChange(Sender: TObject);
    procedure chkSnapClick(Sender: TObject);
    procedure btnRosterFontClick(Sender: TObject);
    procedure cbChatFontChange(Sender: TObject);
    procedure cbChatBGChange(Sender: TObject);
    procedure cbRosterFontChange(Sender: TObject);
    procedure cbRosterBGChange(Sender: TObject);
    procedure btnFontClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure colorChatSelectionChange(Sender: TObject);
    procedure colorChatMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure chkRTEnabledClick(Sender: TObject);
    procedure chkAllowFontFamilyClick(Sender: TObject);
    procedure cboChatElementChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnManageTabsClick(Sender: TObject);
    procedure chkGlueClick(Sender: TObject);
    procedure trkGlueChange(Sender: TObject);
    procedure txtGlueChange(Sender: TObject);
  private
    _color_me: integer;
    _color_other: integer;
    _color_action: integer;
    _color_server: integer;
    _font_color: integer;
    _color_time: integer;
    _color_priority: integer;
    _color_bg: integer;
    _color_alt_bg: integer;
    _color_date: integer;
    _color_date_bg: integer;

    _roster_bg: integer;
    _roster_font_color: integer;

    _lastAllowFont: boolean;
    _lastAllowSize: boolean;
    _lastAllowColor: boolean;

    _msglist_type: integer;
    _htmlmsglist: TfIEMsgList;
    _HTMLContentAlreadyShowing: boolean;

    type TRange = record
       Min: Integer;
       Max: Integer;
    end;

    type _ranges = array of TRange;

    var _time_ranges: _ranges;
    var _other_ranges: _ranges;
    var _me_ranges: _ranges;
    var _action_ranges: _ranges;
    var _server_ranges: _ranges;
    var _font_ranges: _ranges;
    var _priority_ranges: _ranges;


    procedure redrawChat();
    procedure loadAllowedFontProps();

    function getChatElementSelection(): WideString;
  public
    { Public declarations }
    procedure LoadPrefs(); override;
    procedure SavePrefs(); override;
  end;


const
    sActionText = 'Action text';
    sBGColor1 = 'Background color 1';
    sBGColor2 = 'Background color 2';
    sDateSeparator = 'Date separator';
    sDateSeparatorBG = 'Date separator background';
    sMessageLabelMe = 'Messages from me';
    sMessageLabelOthers = 'Messages from others';
    sMessagePriority = 'Message priority';
    sMessageText = 'Message text';
    sSystemMessages = 'System messages';
    sTimestamp = 'Timestamp';

    sBackgroundColorFG = 'Background &color:';
    sFontColorFG = 'Font &color:';

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
implementation
{$R *.dfm}
uses
    ShellAPI,
    PrefFile,
    PrefController,
    Unicode,
    PrefEmoteDlg,
    JabberUtils,
    ExUtils,
    GnuGetText,
    JabberMsg,
    MsgDisplay,
    Session,
    Dateutils,
    TypInfo,
    ManageTabsDlg,
    FontConsts;

const
    RTF_MSGLIST = 0;
    HTML_MSGLIST = 1;


{---------------------------------------}
procedure TfrmPrefDisplay.LoadPrefs();
var
    n: TTntTreeNode;
    s: TPrefState;
    tstr: WideString;
    date_time_formats: TWideStringList;
begin
    cboChatElement.AddItem(sActionText, nil);
    case _msglist_type of
        HTML_MSGLIST: begin
            cboChatElement.AddItem(sBGColor1, nil);
            cboChatElement.AddItem(sBGColor2, nil);
            cboChatElement.AddItem(sDateSeparator, nil);
            cboChatElement.AddItem(sDateSeparatorBG, nil);
        end;
    end;
    cboChatElement.AddItem(sMessageLabelMe, nil);
    cboChatElement.AddItem(sMessageLabelOthers, nil);
    //woot, special casing ftw
    if (_msglist_type = RTF_MSGLIST) then
        cboChatElement.AddItem(sMessagePriority, nil);

    cboChatElement.AddItem(sMessageText, nil);
    cboChatElement.AddItem(sSystemMessages, nil);
    cboChatElement.AddItem(sTimestamp, nil);


    tstr := MainSession.Prefs.getString('richtext_ignored_font_styles');
    _lastAllowFont := Pos('font-family;', tstr) = 0;
    _lastAllowSize := Pos('font-size;', tstr) = 0;
    _lastAllowColor := Pos('color;', tstr) = 0;

    inherited; //inherited will set rtenabled, which will end up using _last* vars

    date_time_formats := TWideStringList.Create;
    MainSession.Prefs.fillStringlist('date_time_formats', date_time_formats);
    if (date_time_formats.Count > 0) then begin
       AssignTntStrings(date_time_formats, txtTimestampFmt.Items);
    end;
    date_time_formats.free();

    n := colorRoster.Items.AddChild(nil, _('Sample Group'));
    colorRoster.Items.AddChild(n, _('Peter M.'));
    colorRoster.Items.AddChild(n, _('Cowboy Neal'));

    //hide/disable entire contact or activity groups if needed
    s := GetPrefState('roster_font_name');
    gbContactList.Visible:= (s <> psInvisible);
    gbContactList.CanShow := (s <> psInvisible);
    gbContactList.Enabled := (s <> psReadOnly);
    gbContactList.CanEnabled := (s <> psReadOnly);

    s := GetPrefState(P_FONT_NAME);
    gbActivityWindow.Visible:= (s <> psInvisible);
    gbActivityWindow.CanShow := (s <> psInvisible);
    gbActivityWindow.Enabled := (s <> psReadOnly);
    gbActivityWindow.CanEnabled := (s <> psReadOnly);
    
    with MainSession.Prefs do begin
        _color_me := getInt(P_COLOR_ME);
        _color_other := getInt(P_COLOR_OTHER);
        _color_action := getInt(P_COLOR_ACTION);
        _color_server := getInt(P_COLOR_SERVER);
        _font_color := getInt(P_FONT_COLOR);
        _color_time := getInt(P_COLOR_TIME);
        _color_priority := getInt(P_COLOR_PRIORITY);
        _color_bg := getInt(P_COLOR_BG);
        _color_alt_bg := getInt(P_COLOR_ALT_BG);
        _color_date_bg := getInt(P_COLOR_DATE_BG);
        _color_date := getInt(P_COLOR_DATE);

        _roster_bg := getInt(P_ROSTER_BG);
        _roster_font_color := getInt(P_ROSTER_FONT_COLOR);

        with colorChat do begin
            Font.Name := getString(P_FONT_NAME);
            Font.Size := getInt(P_FONT_SIZE);
            Font.Color := TColor(_font_color);
            Font.Charset := getInt(P_FONT_CHARSET);
            if (Font.Charset = 0) then Font.Charset := 1;

            Font.Style := [];
            if (getBool(P_FONT_BOLD)) then Font.Style := Font.Style + [fsBold];
            if (getBool(P_FONT_ITALIC)) then Font.Style := Font.Style + [fsItalic];
            if (getBool(P_FONT_ULINE)) then Font.Style := Font.Style + [fsUnderline];
            Color := TColor(_color_bg);
            Self.redrawChat();
        end;

        with colorRoster do begin
            Items[0].Expand(true);
            Color := TColor(_roster_bg);
            Font.Color := TColor(_roster_font_color);
            Font.Name := getString(P_ROSTER_FONT_NAME);
            Font.Size := getInt(P_ROSTER_FONT_SIZE);
            Font.Charset := getInt(P_ROSTER_FONT_CHARSET);
            if (Font.Charset = 0) then Font.Charset := 1;
            Font.Style := [];
            if (getBool(P_ROSTER_FONT_BOLD)) then Font.Style := Font.Style + [fsBold];
            if (getBool(P_ROSTER_FONT_ITALIC)) then Font.Style := Font.Style + [fsItalic];
            if (getBool(P_ROSTER_FONT_UNDERLINE)) then Font.Style := Font.Style + [fsUnderline];
        end;

        btnChatFont.Enabled := true;
        cbChatBG.Selected := TColor(_color_bg);
        cbChatFont.Selected := TColor(_font_color);

        //don't show font props if rt is disabl;ed and locked down
        s := PrefController.getPrefState('richtext_enabled');
        if ((not GetBool('richtext_enabled')) and
           ((s = psInvisible) or ( s = psReadOnly))) then begin
            chkAllowFontFamily.visible := false;
            chkAllowFontSize.visible := false;
            chkAllowFontColor.visible := false;
        end
        else loadAllowedFontProps();

        cbRosterBG.Selected := _roster_bg;
        cbRosterFont.Selected := _roster_font_color;
        
        chkShowPriority.Visible := getBool('branding_priority_notifications');
    end;
//    colorChatSelectionChange(nil);
    cboChatElement.ItemIndex := cboChatElement.Items.IndexOf(sMessageText);
    cboChatElement.Text := sMessageText;
    cboChatElementChange(nil);

    trkSnap.Visible := chkSnap.Visible;
    txtSnap.Visible := chkSnap.Visible;
    if (chkSnap.Visible) then
      chkSnapClick(Self);

    trkGlue.Visible := chkGlue.Visible;
    txtGlue.Visible := chkGlue.Visible;
    if (chkGlue.Visible) then
      chkGlueClick(Self);

    s := GetPrefState('custom_icondefs');
    btnEmoSettings.Visible := ((s <> psInvisible) and chkEmoticons.Visible);
    btnEmoSettings.enabled := ((s <> psReadOnly) and chkEmoticons.enabled);

    pnlContainer.captureChildStates();
    gbAdvancedPrefs.CaptureChildStates();
    btnEmoSettings.Enabled := btnEmoSettings.Enabled and chkEmoticons.Checked;
    pnlContainer.checkAutoHide();
    gbAdvancedPrefs.CheckAutoHide();
end;

{---------------------------------------}
procedure TfrmPrefDisplay.SavePrefs();
var
    tstr: WideString;
begin
    if (Trim(txtTimestampFmt.Text) <> '') then
       if (txtTimestampFmt.Items.IndexOf(txtTimestampFmt.Text) < 0) then
         txtTimestampFmt.Items.Add(txtTimestampFmt.Text);
    MainSession.Prefs.setStringList('date_time_formats', txtTimestampFmt.Items);

    inherited;
    with MainSession.prefs do begin
        setInt(P_COLOR_ME, _color_me);
        setInt(P_COLOR_OTHER, _color_other);
        setInt(P_COLOR_ACTION, _color_action);
        setInt(P_COLOR_SERVER, _color_server);
        setInt(P_FONT_COLOR, _font_color);
        setInt(P_COLOR_TIME, _color_time);
        setInt(P_COLOR_PRIORITY, _color_priority);
        setInt(P_COLOR_BG, _color_bg);
        setInt(P_COLOR_ALT_BG, _color_alt_bg);
        setInt(P_COLOR_DATE_BG, _color_date_bg);
        setInt(P_COLOR_DATE, _color_date);

        setInt(P_ROSTER_BG, _roster_bg);
        setInt(P_ROSTER_FONT_COLOR, _roster_font_color);
        tstr := ' ';
        if (not _lastAllowFont) then
            tstr := tstr + 'font-family;';
        if (not _lastAllowSize) then
            tstr := tstr + 'font-size;';
        if (not _lastAllowColor) then
            tstr := tstr + 'color;';
        setString('richtext_ignored_font_styles', tstr);


        setString(P_ROSTER_FONT_NAME, colorRoster.Font.Name);
        setInt(P_ROSTER_FONT_CHARSET, colorRoster.Font.Charset);
        setInt(P_ROSTER_FONT_SIZE, colorRoster.Font.Size);
        setBool(P_ROSTER_FONT_BOLD, (fsBold in colorRoster.Font.Style));
        setBool(P_ROSTER_FONT_ITALIC, (fsItalic in colorRoster.Font.Style));
        setBool(P_ROSTER_FONT_UNDERLINE, (fsUnderline in colorRoster.Font.Style));
        
        setString(P_FONT_NAME, colorChat.Font.Name);
        setInt(P_FONT_CHARSET, colorChat.Font.Charset);
        setInt(P_FONT_SIZE, colorChat.Font.Size);
        setBool(P_FONT_BOLD, (fsBold in colorChat.Font.Style));
        setBool(P_FONT_ITALIC, (fsItalic in colorChat.Font.Style));
        setBool(P_FONT_ULINE, (fsUnderline in colorChat.Font.Style));
    end;

end;

procedure TfrmPrefDisplay.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
    inherited;
    _htmlmsglist.Free();
end;

procedure TfrmPrefDisplay.trkChatMemoryChange(Sender: TObject);
begin
    inherited;
    txtChatMemory.Text := IntToStr(trkChatMemory.Position);
end;

procedure TfrmPrefDisplay.trkGlueChange(Sender: TObject);
begin
    inherited;
    txtGlue.Text := IntToStr(trkGlue.Position);
end;

procedure TfrmPrefDisplay.trkSnapChange(Sender: TObject);
begin
    inherited;
    txtSnap.Text := IntToStr(trkSnap.Position);
end;

procedure TfrmPrefDisplay.txtChatMemoryChange(Sender: TObject);
begin
    inherited;
    try
        trkChatMemory.Position := StrToInt(txtChatMemory.Text);
    except
    end;
end;

procedure TfrmPrefDisplay.txtGlueChange(Sender: TObject);
begin
    inherited;
    try
        trkGlue.Position := StrToInt(txtGlue.Text);
    except
    end;
end;

procedure TfrmPrefDisplay.txtSnapChange(Sender: TObject);
begin
    inherited;
    try
        trkSnap.Position := StrToInt(txtSnap.Text);
    except
    end;
end;

procedure TfrmPrefDisplay.loadAllowedFontProps();
var
    s: TprefState;
begin
    s := PrefController.getPrefState('richtext_ignored_font_styles');

    chkAllowFontFamily.visible := (s <> psInvisible);
    chkAllowFontSize.visible := (s <> psInvisible);
    chkAllowFontColor.visible := (s <> psInvisible);
    
    if (chkRTEnabled.Checked) then begin
        chkAllowFontFamily.enabled := (s <> psReadOnly);
        chkAllowFontSize.enabled := (s <> psReadOnly);
        chkAllowFontColor.enabled := (s <> psReadOnly);

        chkAllowFontFamily.Checked := _lastAllowFont;
        chkAllowFontSize.Checked := _lastAllowSize;
        chkAllowFontColor.Checked := _lastAllowColor;
    end
    else begin
        chkAllowFontFamily.enabled := false;
        chkAllowFontSize.enabled := false;
        chkAllowFontColor.enabled := false;
        chkAllowFontFamily.Checked := false;
        chkAllowFontSize.Checked := false;
        chkAllowFontColor.Checked := false;
    end;
end;


{---------------------------------------}
procedure TfrmPrefDisplay.btnEmoSettingsClick(Sender: TObject);
var
    tdlg: TfrmPrefEmoteDlg;
begin
    inherited;
    tdlg := TfrmPrefEmoteDlg.Create(Self);
    tdlg.ShowModal();
    tdlg.Free();
end;

procedure TfrmPrefDisplay.btnFontClick(Sender: TObject);
begin
  inherited;
    // Change the roster font
    with FontDialog1 do begin
        Font.Assign(colorChat.Font);

        if Execute then begin
            colorChat.Font.Assign(Font);
            redrawChat();
        end;
    end;
end;

procedure TfrmPrefDisplay.btnManageTabsClick(Sender: TObject);
begin
  inherited;
  ShowManageTabsDlg(Self);
end;


{---------------------------------------}
procedure TfrmPrefDisplay.redrawChat();
var
    m: TJabberMessage;
    n: TDateTime;
    dl : integer;
    my_nick: WideString;
begin
    SetLength(_time_ranges, 4);
    SetLength(_me_ranges, 1);
    SetLength(_other_ranges, 1);    
    SetLength(_action_ranges, 1);
    SetLength(_server_ranges, 1);
    SetLength(_font_ranges, 1);
    SetLength(_priority_ranges, 2);



    n := Now();
    dl := length(FormatDateTime(MainSession.Prefs.getString('timestamp_format'), n)) + 2;
    my_nick := MainSession.getDisplayUsername();


    case _msglist_type of
        RTF_MSGLIST: begin
            with colorChat do begin
                Lines.Clear;

                _time_ranges[0].Min := 0;
                _time_ranges[0].Max := _time_ranges[0].Min + dl - 1;


                m := TJabberMessage.Create();
                with m do begin
                    Body := _('Some text from me');
                    isMe := true;
                    Nick := my_nick;
                    Time := n;
                    Priority := High;
                end;

                _priority_ranges[0].Min := _time_ranges[0].Max + 1;
                _priority_ranges[0].Max := _priority_ranges[0].Min + length(GetDisplayPriority(m.Priority)) + 2 - 1;
                _me_ranges[0].Min := _priority_ranges[0].Max + 1;
                _me_ranges[0].Max := _me_ranges[0].Min + length(my_nick) + 2 - 1;
                DisplayRTFMsg(colorChat, m, true, _color_time, _color_priority, _color_server, _color_action, _color_me, _color_other, _font_color);
                m.Free();

                _time_ranges[1].Min := Length(WideLines.Text) - WideLines.Count;
                _time_ranges[1].Max :=  _time_ranges[1].Min + dl - 1;


                m := TJabberMessage.Create();
                with m do begin
                    Body := _('Some reply text');
                    isMe := false;
                    Nick := _('Friend');
                    Time := n;
                    Priority := High;
                end;

                _priority_ranges[1].Min := _time_ranges[1].Max + 1;
                _priority_ranges[1].Max := _priority_ranges[1].Min + length(GetDisplayPriority(m.Priority)) + 2 - 1;
                _other_ranges[0].Min := _priority_ranges[1].Max + 1;
                _other_ranges[0].Max :=  _other_ranges[0].Min + length(_('Friend')) + 2 - 1;
                DisplayRTFMsg(colorChat, m, true, _color_time, _color_priority, _color_server, _color_action, _color_me, _color_other, _font_color);
                m.Free();

                _time_ranges[2].Min := Length(WideLines.Text) - WideLines.Count;
                _time_ranges[2].Max := _time_ranges[2].Min + dl - 1;

                _action_ranges[0].Min := _time_ranges[2].Max + 1;

                m := TJabberMessage.Create();
                with m do begin
                    Body := _('/me does action');
                    Nick := my_nick;
                    Time := n;
                end;
                DisplayRTFMsg(colorChat, m, true, _color_time, _color_priority, _color_server, _color_action, _color_me, _color_other, _font_color);
                m.Free();

                _action_ranges[0].Max := Length(WideLines.Text) - WideLines.Count;
                _time_ranges[3].Min :=_action_ranges[0].Max + 1;
                _time_ranges[3].Max := _time_ranges[3].Min + dl - 1;

                m := TJabberMessage.Create();
                _server_ranges[0].Min := _time_ranges[3].Max + 1;
                with m do begin
                    Body := _('Server says something');
                    Nick := '';
                    Time := n;
                end;
                DisplayRTFMsg(colorChat, m, true, _color_time, _color_priority, _color_server, _color_action, _color_me, _color_other, _font_color);
                _server_ranges[0].Max := Length(WideLines.Text) - WideLines.Count;
                m.Free();
            end;
        end;
        HTML_MSGLIST: begin
            with _htmlmsglist do begin
                font_name := colorChat.Font.Name;
                font_size := IntToStr(colorChat.Font.Size);
                font_bold := (fsBold in colorChat.Font.Style);
                font_italic := (fsItalic in colorChat.Font.Style);
                font_underline := (fsUnderline in colorChat.Font.Style);
                font_color :=  _font_color;
                color_bg := _color_bg;
                color_alt_bg := _color_alt_bg;
                color_date_bg := _color_date_bg;
                color_date := _color_date;
                color_me := _color_me;
                color_other := _color_other;
                color_time := _color_time;
                color_action := _color_action;
                color_server := _color_server;
                ResetStylesheet();

                if (not _HTMLContentAlreadyShowing) then begin
                    ForceIgnoreScrollToBottom := true;
                    _HTMLContentAlreadyShowing := true;

                    m := TJabberMessage.Create();
                    with m do begin
                        Body := _('Some text from me');
                        isMe := true;
                        Nick := my_nick;
                        Time := n;
                        Priority := High;
                    end;

                    DisplayMsg(m, false);
                    m.Free();

                    m := TJabberMessage.Create();
                    with m do begin
                        Body := _('/me does action');
                        Nick := my_nick;
                        Time := n;
                    end;
                    DisplayMsg(m, false);
                    m.Free();

                    m := TJabberMessage.Create();
                    with m do begin
                        Body := _('Some reply text');
                        isMe := false;
                        Nick := _('Friend');
                        Time := n;
                        Priority := medium;
                    end;

                    DisplayMsg(m, false);
                    m.Free();

                    m := TJabberMessage.Create();
                    with m do begin
                        Body := _('Server says something');
                        Nick := '';
                        Time := n;
                    end;
                    DisplayMsg(m, false);
                    m.Free();
                end;

                refresh();
            end;
        end;
    end;
end;

{---------------------------------------}
procedure TfrmPrefDisplay.FormCreate(Sender: TObject);
begin
    _msglist_type := MainSession.Prefs.getInt('msglist_type');
    case _msglist_type of
        RTF_MSGLIST: begin
            _htmlmsglist := nil;
        end;
        HTML_MSGLIST: begin
            colorChat.Visible := false;
            Label5.Visible := false;
            cbChatBG.Visible := false;
            lblChatBG.Visible := false;

            _htmlmsglist := TfIEMsgList.Create(Self);
            if (_htmlmsglist <> nil) then begin
                with _htmlmsglist do begin
                    Left := colorChat.Left;
                    Top := colorChat.Top;
                    Height := colorChat.Height;
                    Width := colorChat.Width;
                    Parent := colorChat.Parent;
                    Visible := true;
                end;
            end;
        end;
    end;

    inherited;

    AssignUnicodeFont(Self);
end;

{---------------------------------------}
procedure TfrmPrefDisplay.btnRosterFontClick(Sender: TObject);
begin
  inherited;
    with FontDialog1 do begin
        Font.Assign(colorRoster.Font);
        if Execute then begin
            colorRoster.Font.Assign(Font);
        end;
    end;
end;

procedure TfrmPrefDisplay.cbChatBGChange(Sender: TObject);
begin
    inherited;
    _color_bg := Integer(cbChatBG.Selected);
    colorChat.Color := cbChatBG.Selected;
    redrawChat();
end;

procedure TfrmPrefDisplay.cbChatFontChange(Sender: TObject);
var
    currElement: widestring;
begin
    inherited;
    // change the font color
    currElement := getChatElementSelection();
    if (currElement = 'color_me') then begin
        _color_me := integer(cbChatFont.Selected);
    end
    else if (currElement = 'color_other') then begin
        _color_other := integer(cbChatFont.Selected);
    end
    else if (currElement = 'color_action') then begin
        _color_action := integer(cbChatFont.Selected);
    end
    else if (currElement = 'color_server') then begin
        _color_server := integer(cbChatFont.Selected);
    end
    else if (currElement = 'font_color') then begin
        _font_color := integer(cbChatFont.Selected);
    end
    else if (currElement = 'color_time') then begin
        _color_time := integer(cbChatFont.Selected);
    end
    else if (currElement = 'color_priority') then begin
        _color_priority := integer(cbChatFont.Selected);
    end
    else if (currElement = 'color_bg') then begin
        _color_bg := integer(cbChatFont.Selected);
    end
    else if (currElement = 'color_alt_bg') then begin
        _color_alt_bg := integer(cbChatFont.Selected);
    end
    else if (currElement = 'color_date') then begin
        _color_date := integer(cbChatFont.Selected);
    end
    else if (currElement = 'color_date_bg') then begin
        _color_date_bg := integer(cbChatFont.Selected);
    end;
    
    redrawChat();
end;

function TfrmPrefDisplay.getChatElementSelection(): WideString;
var
    index: integer;
begin
    Result := '';
    index := cboChatElement.ItemIndex;
    if (index = cboChatElement.Items.IndexOf(sTimestamp)) then begin
        Result := 'color_time';
    end
    else if(index = cboChatElement.Items.IndexOf(sMessageLabelMe)) then begin
        // on <pgm>, color-me
        Result := 'color_me';
    end
    else if(index = cboChatElement.Items.IndexOf(sMessagePriority)) then begin
        // on <pgm>, color-me
        Result := 'color_priority';
    end
    else if(index = cboChatElement.Items.IndexOf(sMessageLabelOthers)) then begin
        Result := 'color_other';
    end
    else if(index = cboChatElement.Items.IndexOf(sActionText)) then begin
        Result := 'color_action';
    end
    else if(index = cboChatElement.Items.IndexOf(sSystemMessages)) then begin
        Result := 'color_server';
    end
    else if(index = cboChatElement.Items.IndexOf(sMessageText)) then begin
        // normal window, font_color
       Result := 'font_color';
    end
    else if(index = cboChatElement.Items.IndexOf(sBGColor1)) then begin
        // normal window, font_color
       Result := 'color_bg';
    end
    else if(index = cboChatElement.Items.IndexOf(sBGColor2)) then begin
        // normal window, font_color
       Result := 'color_alt_bg';
    end
    else if(index = cboChatElement.Items.IndexOf(sDateSeparator)) then begin
        // normal window, font_color
       Result := 'color_date';
    end
    else if(index = cboChatElement.Items.IndexOf(sDateSeparatorBG)) then begin
        // normal window, font_color
       Result := 'color_date_bg';
    end
end;

procedure TfrmPrefDisplay.cboChatElementChange(Sender: TObject);
var
    index: integer;
begin
  inherited;

    index := cboChatElement.ItemIndex;
    btnChatFont.enabled := false;
    lblChatFG.Caption := sFontColorFG;
    if (index = cboChatElement.Items.IndexOf(sTimestamp)) then begin
        cbChatFont.Selected := TColor(_color_time);
    end
    else if(index = cboChatElement.Items.IndexOf(sMessageLabelMe)) then begin
        // on <pgm>, color-me
        cbChatFont.Selected := TColor(_color_me);
    end
    else if(index = cboChatElement.Items.IndexOf(sMessagePriority)) then begin
        // on <pgm>, color-me
        cbChatFont.Selected := TColor(_color_priority);
    end
    else if(index = cboChatElement.Items.IndexOf(sMessageLabelOthers)) then begin
        cbChatFont.Selected := TColor(_color_other);
    end
    else if(index = cboChatElement.Items.IndexOf(sActionText)) then begin
        cbChatFont.Selected := TColor(_color_action);
    end
    else if(index = cboChatElement.Items.IndexOf(sSystemMessages)) then begin
        cbChatFont.Selected := TColor(_color_server);
    end
    else if(index = cboChatElement.Items.IndexOf(sMessageText)) then begin
        // normal window, font_color
       cbChatFont.Selected := TColor(_font_color);
       btnChatFont.enabled := true;
    end
    else if(index = cboChatElement.Items.IndexOf(sBGColor1)) then begin
        cbChatFont.Selected := TColor(_color_bg);
        lblChatFG.Caption := sBackgroundColorFG;
    end
    else if(index = cboChatElement.Items.IndexOf(sBGColor2)) then begin
        cbChatFont.Selected := TColor(_color_alt_bg);
        lblChatFG.Caption := sBackgroundColorFG;
    end
    else if(index = cboChatElement.Items.IndexOf(sDateSeparator)) then begin
        cbChatFont.Selected := TColor(_color_date);
        lblChatFG.Caption := sFontColorFG;
    end
    else if(index = cboChatElement.Items.IndexOf(sDateSeparatorBG)) then begin
        cbChatFont.Selected := TColor(_color_date_bg);
        lblChatFG.Caption := sBackgroundColorFG;
    end;
end;

procedure TfrmPrefDisplay.cbRosterBGChange(Sender: TObject);
begin
  inherited;
  _roster_bg := Integer(cbRosterBG.Selected);
  colorRoster.Color := cbRosterBG.Selected;
end;

procedure TfrmPrefDisplay.cbRosterFontChange(Sender: TObject);
begin
    inherited;
    _roster_font_color := Integer(cbRosterFont.Selected);
    colorRoster.Font.Color := cbRosterFont.Selected;
end;

procedure TfrmPrefDisplay.chkAllowFontFamilyClick(Sender: TObject);
begin
    inherited;
    if (sender.InheritsFrom(TWinControl) and (TWinControl(Sender).Enabled)) then begin
        if (sender = chkAllowFontFamily) then
            _lastAllowFont := chkAllowFontFamily.Checked
        else if (sender = chkAllowFontSize) then
            _lastAllowSize := chkAllowFontSize.Checked
        else if (sender = chkAllowFontColor) then
            _lastAllowColor := chkAllowFontColor.Checked;
    end;
end;

procedure TfrmPrefDisplay.chkEmoticonsClick(Sender: TObject);
begin
    inherited;
    if (btnEmoSettings.Visible) then begin
        btnEmoSettings.Enabled := chkEmoticons.Checked and
                                  (GetPrefState('custom_icondefs') <> psReadOnly);
    end;
end;

procedure TfrmPrefDisplay.chkGlueClick(Sender: TObject);
begin
    inherited;
    txtGlue.Enabled := chkGlue.Checked;
    trkGlue.Enabled := chkGlue.Checked;
end;

procedure TfrmPrefDisplay.chkRTEnabledClick(Sender: TObject);
begin
    inherited;
    loadAllowedFontProps();
end;

procedure TfrmPrefDisplay.chkSnapClick(Sender: TObject);
begin
    inherited;
    txtSnap.Enabled := chkSnap.Checked;
    trkSnap.Enabled := chkSnap.Checked;
end;

{---------------------------------------}
procedure TfrmPrefDisplay.colorChatMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  inherited;
    // find the "thing" that we clicked on in the window..
//    lblChatWindowElement.Enabled := true;
//    cboChatElement.Enabled := true;
//    cbChatBG.Enabled := true;
//    cbChatFont.Enabled := true;

    btnChatFont.Enabled := false;
    cbChatBG.Selected := TColor(_color_bg);
    cbChatFont.Selected := TColor(_font_color);
    colorChatSelectionChange(nil);
end;

{---------------------------------------}
procedure TfrmPrefDisplay.colorChatSelectionChange(Sender: TObject);
var
    start: integer;
    idx: integer;
//    priorityUsed: boolean;
begin
    inherited;
//    priorityUsed := MainSession.Prefs.getBool('show_priority');
    // Select the chat window
    btnChatFont.Enabled := false;
    cbChatBG.Selected := TColor(_color_bg);

    start := colorChat.SelStart;

    for idx := 0 to Length(_time_ranges) - 1 do begin
      if ((start >= _time_ranges[idx].Min) and (start <= _time_ranges[idx].Max)) then
        begin
          cbChatFont.Selected := TColor(_color_time);
          cboChatElement.ItemIndex := cboChatElement.Items.IndexOf(sTimestamp);
          exit;
        end;
    end;

    for idx := 0 to Length(_me_ranges) - 1 do begin
      if ((start >= _me_ranges[idx].Min) and (start <= _me_ranges[idx].Max)) then
        begin
          // on <pgm>, color-me
          cbChatFont.Selected := TColor(_color_me);
          cboChatElement.ItemIndex := cboChatElement.Items.IndexOf(sMessageLabelMe);
          exit;
        end;
    end;

    for idx := 0 to Length(_priority_ranges) - 1 do begin
      if ((start >= _priority_ranges[idx].Min) and (start <= _priority_ranges[idx].Max)) then
        begin
          // on <pgm>, color-me
          cbChatFont.Selected := TColor(_color_priority);
          cboChatElement.ItemIndex := cboChatElement.Items.IndexOf(sMessagePriority);
          exit;
        end;
     end;


    for idx := 0 to Length(_other_ranges) - 1 do begin
      if ((start >= _other_ranges[idx].Min) and (start <= _other_ranges[idx].Max)) then
        begin
          cbChatFont.Selected := TColor(_color_other);
          cboChatElement.ItemIndex := cboChatElement.Items.IndexOf(sMessageLabelOthers);
          exit;
        end;
    end;

    for idx := 0 to Length(_action_ranges) - 1 do begin
      if ((start >= _action_ranges[idx].Min) and (start <= _action_ranges[idx].Max)) then
        begin
          cbChatFont.Selected := TColor(_color_action);
          cboChatElement.ItemIndex := cboChatElement.Items.IndexOf(sActionText);
          exit;
        end;
    end;

    for idx := 0 to Length(_server_ranges) - 1 do begin
      if ((start >= _server_ranges[idx].Min) and (start <= _server_ranges[idx].Max)) then
        begin
          cbChatFont.Selected := TColor(_color_server);
          cboChatElement.ItemIndex := cboChatElement.Items.IndexOf(sSystemMessages);
          exit;
        end;
    end;

    // normal window, font_color
   cbChatFont.Selected := TColor(_font_color);
   btnChatFont.Enabled := true;
   cboChatElement.ItemIndex := cboChatElement.Items.IndexOf(sMessageText);
end;

end.
