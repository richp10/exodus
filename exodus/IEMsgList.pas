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
unit IEMsgList;



// To use IE (TWebBrowser) as the history window in chats/rooms
// set <msglist_type value="1"/> in the defaults
// or a branding file.  If msglist_type is left at a value of 0, then the
// history window will still be RTF and not HTML even though HTML support is
// compiled in.

interface


uses
//{$UNDEF EXODUS}
{$IFNDEF EXODUS}
    Exodus_TLB,
{$ENDIF}
{$IFDEF EXODUS}
    Session,
{$ENDIF}
    TntMenus,
    JabberMsg,
    Windows,
    Messages,
    SysUtils,
    Variants,
    Classes,
    Graphics,
    Controls,
    Forms,
    Dialogs,
    Regexpr,
    iniFiles,
    BaseMsgList,
    gnugettext,
    unicode,
    XMLTag,
    XMLNode,
    XMLConstants,
    XMLCdata,
    LibXmlParser,
    XMLUtils,
    OleCtrls,
    SHDocVw,
    MSHTML,
    mshtmlevents,
    ActiveX,
    IEMsgListUIHandler;

  function HTMLColor(color_pref: integer) : widestring;

type
    TFileLinkClickInfo = record
    {
      This record contains inforamtion relevant to error
      occured during file transfer.
    }
        Handled: Boolean;
        ExtendedURL:  WideString;
    end;


  TIEMsgListNavigateHandler = procedure(url: widestring; var handled: boolean) of object;
  TIEMsgListOnKeyPressHandler = procedure(const pEvtObj: IHTMLEventObj; var handled: boolean) of object;

  TIEMsgListProcessor = class
  private
    _lastLineClass: WideString;
    _lastMsgNick: WideString;
    _exeName: Widestring;
    _idCount: integer;
    _displayDateSeparator: boolean;
    _lastTimeStamp: TDateTime;
{$IFNDEF EXODUS}
    _controller: IExodusController;
{$ENDIF}

    function _processUnicode(txt: widestring): WideString;
    function _genElementID(): WideString;
    function _getLineClass(Msg: TJabberMessage): WideString; overload;
    function _getLineClass(nick: widestring): WideString; overload;
    function _checkLastNickForMsgGrouping(Msg: TJabberMessage): boolean; overload;
    function _checkLastNickForMsgGrouping(nick: widestring): boolean; overload;

    function _getPrefBool(prefName: Widestring): boolean;
    function _getPrefString(prefName: Widestring): widestring;
//    function _getPrefInt(prefName: Widestring): integer;
  protected
  public
{$IFDEF EXODUS}
    constructor Create();
{$ELSE}
    constructor Create(controller: IExodusController);
{$ENDIF}

    function dateSeparator(const msg: TJabberMessage): widestring;
    function ProcessDisplayMsg(const Msg: TJabberMessage): widestring; overload;
    function ProcessDisplayMsg(const Msg: TJabberMessage; var id:widestring): widestring; overload;
    function ProcessPresenceMsg(const nick: widestring; const txt: Widestring; const timestamp: string): widestring;
    function ProcessComposing(const txt: Widestring): widestring; overload;
    function ProcessComposing(const txt: Widestring; var id:widestring): widestring; overload;
    function ProcessRawText(const txt: Widestring): Widestring;
    procedure Reset();

    property lastLineClass: widestring read _lastLineClass write _lastLineClass;
    property lastMsgNick: widestring read _lastMsgNick write _lastMsgNick;
    property exeName: widestring read _exeName write _exeName;
    property idCount: integer read _idCount write _idCount;
    property displayDateSeparator: boolean read _displayDateSeparator write _displayDateSeparator;
    property lastTimeStamp: TDateTime read _lastTimeStamp write _lastTimeStamp;
  end;

  TfIEMsgList = class(TfBaseMsgList)
    browser: TWebBrowser;
    procedure browserDocumentComplete(Sender: TObject;
      const pDisp: IDispatch; var URL: OleVariant);
    procedure browserBeforeNavigate2(Sender: TObject;
      const pDisp: IDispatch; var URL, Flags, TargetFrameName, PostData,
      Headers: OleVariant; var Cancel: WordBool);
    procedure browserDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure browserDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);

  private
    { Private declarations }
    _msgProcessor: TIEMsgListProcessor;
    _home: WideString;

    _doc: IHTMLDocument2;
    _win: IHTMLWindow2;
    _body: IHTMLElement;
    _style: IHTMLStyleSheet;
    _content: IHTMLElement;
    _content2: IHTMLElement2;
    _lastelement: IHTMLElement;
    _elementID: widestring;

    _we: TMSHTMLHTMLElementEvents;
    _we2: TMSHTMLHTMLElementEvents2;
    _de: TMSHTMLHTMLDocumentEvents;

    _bottom: Boolean;
    _menu:  TTntPopupMenu;
    _queue: TWideStringList;
    _title: WideString;
    _ready: Boolean;
    _composing: integer;
    _msgCount: integer;
    _maxMsgCountHigh: integer;
    _maxMsgCountLow: integer;
    _doMessageLimiting: boolean;

    _dragDrop: TDragDropEvent;
    _dragOver: TDragOverEvent;

    _font_name: widestring;
    _font_size: widestring;
    _font_color: integer;
    _color_bg: integer;
    _color_alt_bg: integer;
    _color_date_bg: integer;
    _color_date: integer;
    _color_me: integer;
    _color_other: integer;
    _color_time: integer;
    _color_action: integer;
    _color_server: integer;
    _color_composing: integer;
    _color_presence: integer;
    _color_alert: integer;
    _font_bold: boolean;
    _font_italic: boolean;
    _font_underline: boolean;
{$IFDEF EXODUS}
    _stylesheet_name: widestring;
{$ELSE}
    _stylesheet_raw: widestring;
{$ENDIF}
    _webBrowserUI: TWebBrowserUIObject;

    _ForceIgnoreScrollToBottom: boolean;
    _Clearing: boolean;
    _ClearingMsgCache: TWidestringList;
    _IgnoreMsgLimiting: boolean;
    _InMessageDumpMode: boolean;
    _MessageDumpModeHTML: Widestring;

     _fileLinkInfo: TFileLinkClickInfo;
     _filelink_callback: integer;
     
    procedure onScroll(Sender: TObject);
    procedure onResize(Sender: TObject);

    function onDrop(Sender: TObject): WordBool;
    function onDragOver(Sender: TObject): WordBool;
    function onContextMenu(Sender: TObject): WordBool;
    function onKeyPress(Sender: TObject; const pEvtObj: IHTMLEventObj): WordBool;
    procedure onKeyDown(Sender: TObject; const pEvtObj: IHTMLEventObj);
    function copyMenuEnabled(): boolean;

    procedure _ClearOldMessages();
    function _getHistory(includeState: boolean = true): WideString;
    procedure _SetInMessageDumpMode(value: boolean);

  protected
    procedure ProcessNavigate(Sender: TObject;
              const pDisp: IDispatch; var URL, Flags, TargetFrameName, PostData,
              Headers: OleVariant; var Cancel: WordBool);virtual;
    procedure OnFileLinkCallback(event: string; tag: TXMLTag); virtual;
  public
    { Public declarations }
    NavigateHandler: TIEMsgListNavigateHandler;
{$IFNDEF EXODUS}
    OnKeyPressHandler: TIEMsgListOnKeyPressHandler;
{$ENDIF}


{$IFDEF EXODUS}
    constructor Create(Owner: TComponent); override;
{$ELSE}
    constructor Create(Owner: TComponent; controller: IExodusController);reintroduce; overload;
{$ENDIF}
    destructor Destroy; override;

    procedure Invalidate(); override;
    procedure CopyAll(); override;
    procedure Copy(); override;
    procedure ScrollToBottom(); override;
    procedure ScrollToTop();
    procedure Clear(); override;
    procedure Reset(); override;
    procedure setContextMenu(popup: TTntPopupMenu); override;
    procedure setDragOver(event: TDragOverEvent); override;
    procedure setDragDrop(event: TDragDropEvent); override;
    procedure DisplayMsg(Msg: TJabberMessage; AutoScroll: boolean = true); override;
    procedure DisplayPresence(nick, txt: Widestring; timestamp: string; dtTimestamp: TDateTime); override;
    function  getHandle(): THandle; override;
    function  getObject(): TObject; override;
    function  empty(): boolean; override;
    function  getHistory(): Widestring; override;
    procedure Save(fn: string); override;
    procedure populate(history: Widestring); override;
    procedure setupPrefs(); override;
    procedure setTitle(title: Widestring); override;
    procedure ready(); override;
    procedure refresh(); override;
    procedure DisplayComposing(msg: Widestring); override;
    procedure HideComposing(); override;
    function  isComposing(): boolean; override;
    procedure DisplayRawText(txt: Widestring); override;

{$IFDEF EXODUS}
    procedure ChangeStylesheet( resname: WideString);
{$ELSE}
    procedure SetStylesheet(stylesheet: WideString);
{$ENDIF}
    procedure ResetStylesheet();
    procedure print(ShowDialog: boolean);
    procedure writeHTML(html: WideString);
    procedure DefaultNavHandler(url: widestring; var handled: boolean);

    property font_name: widestring read _font_name write _font_name;
    property font_size: widestring read _font_size write _font_size;
    property font_color: integer read _font_color write _font_color;
    property color_bg: integer read _color_bg write _color_bg;
    property color_alt_bg: integer read _color_alt_bg write _color_alt_bg;
    property color_date_bg: integer read _color_date_bg write _color_date_bg;
    property color_date: integer read _color_date write _color_date;
    property color_me: integer read _color_me write _color_me;
    property color_other: integer read _color_other write _color_other;
    property color_time: integer read _color_time write _color_time;
    property color_action: integer read _color_action write _color_action;
    property color_server: integer read _color_server write _color_server;
    property color_composing: integer read _color_composing write _color_composing;
    property color_presence: integer read _color_presence write _color_presence;
    property color_alert: integer read _color_alert write _color_alert;
{$IFDEF EXODUS}
    property stylesheet_name: widestring read _stylesheet_name write _stylesheet_name;
{$ELSE}
    property stylesheet_raw: widestring read _stylesheet_raw write _stylesheet_raw;
{$ENDIF}
    property font_bold: boolean read _font_bold write _font_bold;
    property font_italic: boolean read _font_italic write _font_italic;
    property font_underline: boolean read _font_underline write _font_underline;
    property ForceIgnoreScrollToBottom: boolean read _ForceIgnoreScrollToBottom write _ForceIgnoreScrollToBottom;
    property IgnoreMsgLimiting: boolean read _IgnoreMsgLimiting write _IgnoreMsgLimiting;
    property InMessageDumpMode: boolean read _InMessageDumpMode write _SetInMessageDumpMode;
    property msgProcessor: TIEMsgListProcessor read _msgProcessor;

  end;

var
  fIEMsgList: TfIEMsgList;
  xp_xhtml: TXPLite;
  ok_tags: THashedStringList;
  style_tags: THashedStringList;
  style_props: THashedStringList;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
implementation


uses
    JabberConst,
{$IFDEF EXODUS}
    Jabber1,
    BaseChat,
    PrefController,
    ExUtils,
    ChatWin,
    Room,
{$ENDIF}
    FontConsts,
    RT_XIMConversion,
    JabberUtils,
    ShellAPI,
    Emote,
    StrUtils,
    Registry,
    TntSysUtils;

{$R *.dfm}

type
  TReplaceURLHandler = class
  public
    function Replace(re: TRegExpr): RegExprString;

  end;
var
    ReplaceURLs: TReplaceURLHandler;

{---------------------------------------}
function HTMLColor(color_pref: integer) : widestring;
var
    color: TColor;
begin
    color := TColor(color_pref);
    Result := IntToHex(GetRValue(color), 2) +
              IntToHex(GetGValue(color), 2) +
              IntToHex(GetBValue(color), 2);
end;

{---------------------------------------}
function TReplaceURLHandler.Replace(re: TRegExpr): RegExprString;
var
    url, val, rem: string;
    len: Integer;
    last: Char;
begin
    val :=  Copy(re.InputString, re.MatchPos[0], re.MatchLen[0]);

    //more clean up
    val := XML_UnEscapeChars(val);
    rem := '';
    len := Length(val);
    last := val[len];
    if (last = '>') or (last = '<') or (last = '\') then begin
        val := Copy(val, 1, len - 1);
        rem := last;
    end;

    val := XML_EscapeChars(val);
    if Pos('www.', val) = 1 then
        url := 'http://' + val
    else
        url := val;

    Result := '<a href="' + url + '">' + val + '</a>' + rem;
end;

{---------------------------------------}
function ProcessTag(parent: TXMLTag; n: TXMLNode): WideString;
var
    nodes: TXMLNodeList;
    i, j: integer;
    attrs: TAttrList;
    attr: TAttr;
    tag: TXMLTag;
    chunks: TWideStringList;
    nv : TWideStringList;
    started: boolean;
    str: WideString;
    tag_name: WideString;
    aname: WideString;
begin
    // See JEP-71 (http://www.jabber.org/jeps/jep-0071.html) for details.
    result := '';

    // any tag not in the good list should be deleted, but everything else
    // around it should stay.
    // opted to do own serialization for efficiency; didn't want to have to
    // make many passes over the same data.
    if (n.NodeType = xml_Tag) then begin
        tag := TXMLTag(n);
        tag_name := lowercase(tag.Name);

        if (ok_tags.IndexOf(tag_name) < 0) then
            exit;

        result := result + '<' + tag_name;

        nv := TWideStringList.Create();
        chunks := TWideStringList.Create();
        attrs := tag.Attributes;
        for i := 0 to attrs.Count - 1 do begin
            attr := TAttr(attrs[i]);
            aname := lowercase(attr.Name);
            if (aname = 'style') then begin
                // style attribute only allowed on style_tags.
                if (style_tags.IndexOf(tag_name) >= 0) then begin
                    //  remove any style properties that aren't in the allowed list
                    chunks.Clear();
                    split(attr.value, chunks, ';');
                    started := false;
                    for j := 0 to chunks.Count - 1 do begin
                        nv.Clear();
                        split(chunks[j], nv, ':');
                        if (nv.Count < 1) then
                            continue;
                        if (style_props.IndexOf(nv[0]) >= 0) then begin
                            if (not started) then begin
                                started := true;
                                result := result + ' style="';
                            end;
                            result := result + HTML_EscapeChars(chunks[j], false, true) + ';';
                        end;
                    end;
                    if (started) then
                        result := result + '"';
                end;
            end
            else if (tag_name = 'a') then begin
                if (aname = 'href') then
                    result := result + ' ' +
                        attr.Name + '="' + HTML_EscapeChars(attr.Value, false, true) + '"';
            end
            else if (tag_name = 'img') then begin
                if ((aname = 'alt') or
                    (aname = 'height') or
                    (aname = 'longdesc') or
                    (aname = 'src') or
                    (aname = 'width')) then begin
                    result := result + ' ' +
                        aname + '="' + HTML_EscapeChars(attr.Value, false, true) + '"';
                end;
            end
        end;
        nv.Free();
        chunks.Free();

        nodes := tag.Nodes;
        if (nodes.Count = 0) then
            result := result + '/>'
        else begin
            // iterate over all the children
            result := result + '>';
            for i := 0 to nodes.Count - 1 do
                result := result + ProcessTag(tag, TXMLNode(nodes[i]));
            result := result + '</' + tag.name + '>';
        end;
    end
    else if (n.NodeType = xml_CDATA) then begin
        // Check for URLs
        if ((parent = nil) or (parent.Name <> 'a')) then begin
            str := REGEX_URL.ReplaceEx(TXMLCData(n).XML, ReplaceURLs.Replace);
            // Look for and replace &APOS; as HTML doesn't understand this escaping.
            str := Tnt_WideStringReplace(str, '&apos;', '''', [rfReplaceAll]);
            result := result + ProcessIEEmoticons(str);
        end
        else
            result := result + TXMLCData(n).Data;
    end;
end;

{---------------------------------------}
{---------------------------------------}
{$IFDEF EXODUS}
constructor TIEMsgListProcessor.Create();
{$ELSE}
constructor TIEMsgListProcessor.Create(controller: IExodusController);
{$ENDIF}
begin
{$IFNDEF EXODUS}
    _controller := controller;
{$ENDIF}
    _displayDateSeparator := _getPrefBool('display_date_separator');
    _exeName := _getPrefString('exe_FullPath');
end;

{---------------------------------------}
function TIEMsgListProcessor._checkLastNickForMsgGrouping(nick: widestring): boolean;
var
    tmsg: TJabberMessage;
begin
    Result := false;

    if (nick <> '') then begin
        tmsg := TJabberMessage.Create();
        if (tmsg <> nil) then begin
            tmsg.Nick := nick;
            Result := _checkLastNickForMsgGrouping(tmsg);
            tmsg.Free();
        end;
    end;
end;

{---------------------------------------}
function TIEMsgListProcessor._checkLastNickForMsgGrouping(Msg: TJabberMessage): boolean;
begin
    if (Msg.Nick = _lastMsgNick) then begin
        Result := true;
    end
    else begin
        Result := false;
    end;
end;

{---------------------------------------}
function TIEMsgListProcessor._getLineClass(nick: widestring): WideString;
var
    tmsg: TJabberMessage;
begin
    Result := 'line1';

    if (nick <> '') then begin;
        tmsg := TJabberMessage.Create();
        if (tmsg <> nil) then begin
            tmsg.Nick := nick;
            Result := _getLineClass(tmsg);
            tmsg.Free();
        end;
    end;
end;

{---------------------------------------}
function TIEMsgListProcessor._getLineClass(Msg: TJabberMessage): WideString;
begin
    if (_checkLastNickForMsgGrouping(Msg)) then begin
        Result := _lastLineClass;
        exit;
    end;

    if (_lastLineClass = 'line1') then begin
        _lastLineClass := 'line2';
        Result := _lastLineClass;
    end
    else begin
        _lastLineClass := 'line1';
        Result := _lastLineClass;
    end;
end;

{---------------------------------------}
function TIEMsgListProcessor.ProcessDisplayMsg(const Msg: TJabberMessage): widestring;
var
    id: widestring;
begin
    id := '';
    Result := ProcessDisplayMsg(Msg, id);
end;

{---------------------------------------}
function TIEMsgListProcessor.ProcessDisplayMsg(const Msg: TJabberMessage; var id: widestring): widestring;
var
    dv: widestring;
    txt: widestring;
    tmp: Widestring;
    cleanXIM: TXmlTag;
    nodes: TXMLNodeList;
    i: integer;
    body, err: TXmlTag;
begin
    Result := '';
    if (Msg = nil) then exit;

    if ((not Msg.Action) and
        (_getPrefBool('richtext_enabled'))) then begin
        // ignore HTML for actions.  it's harder than you think.
        body := Msg.Tag.QueryXPTag(xp_xhtml);

        if (body <> nil) then begin
            // Strip out font tags we wish to ignore
{$IFDEF EXODUS}
            cleanXIM := cleanXIMTag(body);
{$ELSE}
            cleanXIM := cleanXIMTag(_controller, body);
{$ENDIF}
            if (cleanXIM <> nil) then begin
                // if first node is a p tag, make it a span...
                if ((cleanXIM.Nodes.Count > 0) and
                    (TXMLTag(cleanXIM.Nodes[0]).NodeType = xml_tag) and
                    (TXMLTag(cleanXIM.Nodes[0]).Name = 'p')) then
                    TXMLTag(cleanXIM.Nodes[0]).Name := 'span';

                nodes := cleanXIM.nodes;
                for i := 0 to nodes.Count - 1 do
                    txt := txt + ProcessTag(cleanXIM, TXMLNode(nodes[i]));
            end;
            cleanXIM.Free();
        end;
    end;

    if (txt = '') then begin
        txt := HTML_EscapeChars(Msg.Body, false, false);
        txt := _processUnicode(txt); //StringReplace() cannot handle
        // Make sure the spaces are preserved
        // txt := StringReplace(txt, ' ', '&ensp;', [rfReplaceAll]); // Doesn't work well with some versions of IE
        // Detect URLs in text
        txt := REGEX_URL.ReplaceEx(txt, ReplaceURLs.Replace);
        // Change CRLF to HTML equiv
        txt := REGEX_CRLF.Replace(txt, '<br />', true);
    end;

    // build up a string, THEN call writeHTML, since IE is being "helpful" by
    // canonicalizing HTML as it gets inserted.
    id := _genElementID();
    dv := '<div id="' + id + '" class="' + _getLineClass(Msg) + '">';

    // Author Stamp
    if (Msg.Nick = '') then begin
        dv := dv + '<span class="svr">' + HTML_EscapeChars(_('System Message'), false, true) + '</span>';
    end
    else begin
        // This is a normal message
        if (not _checkLastNickForMsgGrouping(Msg)) then begin
            if Msg.isMe then begin
                // Our own msgs
                dv := dv + '<span class="me">' + HTML_EscapeChars(Msg.Nick, false, true) + '</span>';
            end
            else begin
                // Msgs from "others"
                dv := dv + '<span class="other">' + HTML_EscapeChars(Msg.Nick, false, true) + '</span>';
            end;
        end;
    end;

    _lastMsgNick := Msg.Nick;

    // Wrap msg and time stamp for css
    dv := dv + '<div class="msgts">';

    // Timestamp
    if (_getPrefBool('timestamp')) then begin
        try
            dv := dv + '<span class="ts">' +
                HTML_EscapeChars(FormatDateTime(_getPrefString('timestamp_format'), Msg.Time), false, true) +
                '</span> ';
        except
            on EConvertError do begin
                dv := dv + '<span class="ts">' +
                    HTML_EscapeChars(FormatDateTime(_getPrefString('timestamp_format'), Now()), false, true) +
                    '</span> ';
            end;
        end;
    end;

    // MSG Content
    if (Msg.MsgType = 'error') then begin
        err := Msg.Tag.GetFirstTag('error');
        if (err <> nil) and (err.getAttribute('code') <> '') then begin
            tmp := _('Undeliverable message (Error Code: %s): ');
            tmp := Format(tmp, [err.getAttribute('code')]);
            txt := HTML_EscapeChars(tmp, false, true) +
                txt;
        end
        else begin
            tmp := _('Undeliverable message (Unknown Reason): ');
            txt := HTML_EscapeChars(tmp, false, true) +
                txt;
        end;
        dv := dv + '<span class="error">' + txt + '</span>';
    end
    else if (Msg.Nick = '') then begin
        // Server generated msgs (mostly in TC Rooms)
        dv := dv + '<span class="svr">' + txt + '</span>';
    end
    else if not Msg.Action then begin
        if (_exeName <> '') then begin
{$IFDEF EXODUS}
            if (MainSession.Prefs.getBool('show_priority')) then
{$ELSE}
            if ((_controller <> nil) and (_controller.GetPrefAsBool('show_priority'))) then
{$ENDIF}
            begin
                if (Msg.Priority = high) then begin
                    dv := dv +
                          '<img class="priorityimg" src="res://' +
                          _exeName +
                          '/GIF/HIGH_PRI" alt="' +
                          _('High Priority') +
                          '" />';
                end
                else if (Msg.Priority = low) then begin
                    dv := dv +
                          '<img class="priorityimg" src="res://' +
                          _exeName +
                          '/GIF/LOW_PRI" alt="' +
                          _('Low Priority') +
                          '" />';
                end;
            end;
        end;

        if (Msg.Highlight) then
            dv := dv + '<span class="alert"> ' + txt + '</span>'
        else
            dv := dv + '<span class="msg">' + txt + '</span>';
    end
    else begin
        // This is an action
        dv := dv + '<span class="action"> * ' + HTML_EscapeChars(Msg.Nick, false, true) + ' ' + txt + '</span>';
    end;

    // Close off msgts and line1/2 div tags
    dv := dv + '</div></div>';

    Result := dv;
end;

{---------------------------------------}
function TIEMsgListProcessor._genElementID(): WideString;
begin
    Result := 'msg_id_' + IntToStr(_idCount);
    Inc(_idCount);
end;

{---------------------------------------}
function TIEMsgListProcessor._processUnicode(txt: widestring): WideString;
var
    i: integer;
begin
    Result := '';
    for i := 1 to Length(txt) do begin
        if (Ord(txt[i]) > 126) then begin
            // This looks to be a non-ascii char so represent in HTML escaped notation
            try
                Result := Result + '&#' + IntToStr(Ord(txt[i])) + ';';
            except
                exit;
            end;
        end
        else begin
            Result := Result + txt[i];
        end;
    end;
end;

{---------------------------------------}
function TIEMsgListProcessor.dateSeparator(const msg: TJabberMessage): widestring;
var
    t: TDateTime;
begin
    Result := '';
    if (msg = nil) then exit;

    try
        if (_displayDateSeparator) then begin
            t := msg.Time;
            if ((Trunc(t) <> Trunc(_lastTimeStamp)) and
                (msg.Subject = '')) then begin
                Result := '<div class="date">' +
                       '<span>' +
                       HTML_EscapeChars(FormatDateTime(_getPrefString('date_separator_format'), t), false, true) +
                       '</span>' +
                       '</div>';

                _lastTimeStamp := msg.Time;
                _lastMsgNick := '';
            end;
        end;
    except
    end;
end;

{---------------------------------------}
procedure TIEMsgListProcessor.Reset();
begin
    _lastTimeStamp := 0;
    _lastLineClass := '';
    _lastMsgNick := '';
end;

{---------------------------------------}
function TIEMsgListProcessor.ProcessPresenceMsg(const nick: widestring; const txt: Widestring; const timestamp: string): widestring;
var
    htmlout: widestring;
begin
    htmlout := '<div class="' + _getLineClass(nick) + '">';
    if ((not _checkLastNickForMsgGrouping(nick)) and
        (nick <> '')) then begin
        // Must NOT be a "me" message
        htmlout := htmlout + '<span class="other">' + HTML_EscapeChars(nick, false, true) + '</span>';
    end;

    // Put presence Icon in with the presence message
    // How to get image from image list and not resource?
{    if (_exeName <> '') then begin
        htmlout := htmlout +
              '<img class="priorityimg" src="res://' +
              _exeName +
              '/GIF/HIGH_PRI"/>';
    end;    }

    if (timestamp <> '') then begin
        htmlout := htmlout + '<div class="msgts"><span class="ts">' + HTML_EscapeChars(timestamp, false, true) + '</span><span class="pres">' + HTML_EscapeChars(txt, false, true) + '</span></div></div>';
    end
    else begin
        if (nick <> '') then begin
            htmlout := htmlout + '<div class="' + _getLineClass(nick) + '"><div class="msgts"><span class="pres">' + HTML_EscapeChars(txt, false, true) + '</span></div></div>';
        end
        else begin
            htmlout := htmlout + '<div class="' + _getLineClass(nick) + '"><span class="pres">' + HTML_EscapeChars(txt, false, true) + '</span></div>';
        end;
    end;

    _lastMsgNick := nick;

    Result := htmlout;
end;

{---------------------------------------}
function TIEMsgListProcessor.ProcessComposing(const txt: Widestring): widestring;
var
    id: widestring;
begin
    id := '';
    Result := ProcessComposing(txt, id);
end;

{---------------------------------------}
function TIEMsgListProcessor.ProcessComposing(const txt: Widestring; var id:widestring): widestring;
begin
    id := _genElementID();
    Result := '<div id="' +
                 id +
                 '"><br /><span class="composing">' +
                 HTML_EscapeChars(txt, false, false) +
                 '</span><br /></div>';
end;

{---------------------------------------}
function TIEMsgListProcessor.ProcessRawText(const txt: Widestring): Widestring;
begin
    Result := HTML_EscapeChars(txt, false, false);
end;

{---------------------------------------}
function TIEMsgListProcessor._getPrefBool(prefName: Widestring): boolean;
begin
{$IFDEF EXODUS}
    Result := MainSession.Prefs.getBool(prefName);
{$ELSE}
    Result := false;
    if (_controller = nil) then exit;

    Result := _controller.GetPrefAsBool(prefName);
{$ENDIF}
end;

{---------------------------------------}
function TIEMsgListProcessor._getPrefString(prefName: Widestring): widestring;
begin
{$IFDEF EXODUS}
    Result := MainSession.Prefs.getString(prefName);
{$ELSE}
    Result := '';
    if (_controller = nil) then exit;

    Result := _controller.GetPrefAsString(prefName);
{$ENDIF}
end;

{---------------------------------------}
//function TIEMsgListProcessor._getPrefInt(prefName: Widestring): integer;
//begin
{$IFDEF EXODUS}
//    Result := MainSession.Prefs.getInt(prefName);
{$ELSE}
//    Result := 0;
//    if (_controller = nil) then exit;
//
//    Result := _controller.GetPrefAsInt(prefName);
{$ENDIF}
//end;


{---------------------------------------}
{---------------------------------------}
{$IFDEF EXODUS}
constructor TfIEMsgList.Create(Owner: TComponent);
{$ELSE}
constructor TfIEMsgList.Create(Owner: TComponent; controller: IExodusController);
{$ENDIF}
var
    OleObj: IOleObject;
    reg: TRegistry;
    IEOverrideReg: widestring;
    tstring: widestring;
begin
    inherited;
    NavigateHandler := Self.DefaultNavHandler;
{$IFDEF EXODUS}
    _msgProcessor := TIEMsgListProcessor.Create();
{$ELSE}
    _msgProcessor := TIEMsgListProcessor.Create(_controller);
{$ENDIF}
    _queue := TWideStringList.Create();
    _ready := true;
    _composing := -1;
    _msgCount := 0;
    _doMessageLimiting := false;
    _IgnoreMsgLimiting := false;
    _Clearing := false;
    _ClearingMsgCache := TWidestringList.Create();

    // Setup registry to override IE settings
    try
        reg := TRegistry.Create();
        if (reg <> nil) then begin
            IEOverrideReg := '\Software\Jabber\' +
                             _getPrefString('appID') +
                             '\IEMsgList';

            tstring := IEOverrideReg + '\Settings';
            reg.RootKey := HKEY_CURRENT_USER;
            reg.OpenKey(tstring, true);
            reg.WriteInteger('Always Use My Colors', 0);
            reg.WriteInteger('Always Use My Font Face', 0);
            reg.WriteInteger('Always Use My Font Size', 0);
            reg.CloseKey();

            tstring := IEOverrideReg + '\Styles';
            reg.RootKey := HKEY_CURRENT_USER;
            reg.OpenKey(tstring, true);
            reg.WriteInteger('Use My Stylesheet', 0);
            reg.CloseKey();

            reg.Free();
        end;
    except
    end;

    _maxMsgCountHigh := _getPrefInt('maximum_displayed_messages');
    _maxMsgCountLow := _getPrefInt('maximum_displayed_messages_drop_down_to');
    if ((_maxMsgCountHigh <> 0) and
        (_maxMsgCountHigh >= _maxMsgCountLow)) then begin
        _doMessageLimiting := true;
        if (_maxMsgCountLow <= 0) then begin
            // High water mark set, but low water mark not set.
            // So, we will make the low water mark equal to the  high water mark.
            // This will only drop 1 message at a time.
            _maxMsgCountLow := _maxMsgCountHigh;
        end;
    end;

{$IFDEF EXODUS}
    _stylesheet_name := _getPrefString('ie_css');
{$ELSE}
    _stylesheet_raw := '';
{$ENDIF}
    _font_name := _getPrefString(P_FONT_NAME);
    _font_size := _getPrefString(P_FONT_SIZE);
    _font_bold := _getPrefBool(P_FONT_BOLD);
    _font_italic := _getPrefBool(P_FONT_ITALIC);
    _font_underline := _getPrefBool(P_FONT_ULINE);
    _font_color := _getPrefInt(P_FONT_COLOR);
    _color_bg := _getPrefInt(P_COLOR_BG);
    _color_alt_bg := _getPrefInt(P_COLOR_ALT_BG);
    _color_date_bg := _getPrefInt(P_COLOR_DATE_BG);
    _color_date := _getPrefInt(P_COLOR_DATE);
    _color_me := _getPrefInt(P_COLOR_ME);
    _color_other := _getPrefInt(P_COLOR_OTHER);
    _color_time := _getPrefInt(P_COLOR_TIME);
    _color_action := _getPrefInt(P_COLOR_ACTION);
    _color_server := _getPrefInt(P_COLOR_SERVER);
    _color_composing := _getPrefInt(P_COLOR_COMPOSING);
    _color_presence := _getPrefInt(P_COLOR_PRESENCE);
    _color_alert := _getPrefInt(P_COLOR_ALERT);

    // Set IDocHostUIHandler interface to handle override of IE settings
    try
        if (browser <> nil) then begin
            if (Supports(browser.DefaultInterface, IOleObject, OleObj)) then begin
                _webBrowserUI.Free();
{$IFDEF EXODUS}
                _webBrowserUI := TWebBrowserUIObject.Create();
{$ELSE}
                _webBrowserUI := TWebBrowserUIObject.Create(_controller);
{$ENDIF}
                OleObj.SetClientSite(_webBrowserUI as IOleClientSite);
            end
            else begin
                _webBrowserUI := nil;
                raise Exception.Create('MsgList interface does not support IOleObject');
            end;
            browser.OnBeforeNavigate2 := ProcessNavigate;
        end;
    except

    end;
{$IFDEF EXODUS}
    _filelink_callback := MainSession.RegisterCallback(OnFileLinkCallback, '/session/filelink/click/response');
{$ELSE}
    _filelink_callback := -1; // TODO, allow plugins to register for file links Controller.RegisterCallback('/session/filelink/click/response', nil);
{$ENDIF}
end;

{---------------------------------------}
destructor TfIEMsgList.Destroy;
begin
    try
        _ClearingMsgCache.Clear();
        _ClearingMsgCache.Free();

        _queue.Free();

{$IFDEF EXODUS}
        MainSession.UnRegisterCallback(_filelink_callback);
{$ELSE}
        _msgProcessor._controller.UnRegisterCallback(_filelink_callback);
{$ENDIF}
        _msgProcessor.Free();

        FreeAndNil(_webBrowserUI);
    except
    end;
    inherited;
end;

{---------------------------------------}
procedure TfIEMsgList.writeHTML(html: WideString);
begin
    if (html = '') then exit;

    if (_content = nil) then begin
        assert(_queue <> nil);
        _queue.Add(html);
        exit;
    end;

    if (_Clearing) then begin
        _ClearingMsgCache.Add(html);
    end
    else begin
        if (_InMessageDumpMode) then begin
            _MessageDumpModeHTML := _MessageDumpModeHTML + html;
        end
        else begin
            // For some reason, the _content that is set
            // elsewhere is causing exceptions
            _content := _doc.all.item('content', 0) as IHTMLElement;
            _content.insertAdjacentHTML('beforeEnd', html);
        end;
    end;
end;

{---------------------------------------}
procedure TfIEMsgList.Invalidate();
begin
//    browser.Invalidate();
end;

{---------------------------------------}
procedure TfIEMsgList.CopyAll();
begin
    _doc.execCommand('SelectAll', false, varNull);
    _doc.execCommand('Copy', true, varNull);
    _doc.execCommand('Unselect', false, varNull);
end;

{---------------------------------------}
procedure TfIEMsgList.Copy();
begin
    _doc.execCommand('Copy', true, varNull);
end;

{---------------------------------------}
procedure TfIEMsgList.ScrollToBottom();
var
    tags: IHTMLElementCollection;
    last: IHTMLElement;
begin
    if (_win = nil) then exit;
    if (_ForceIgnoreScrollToBottom) then exit;
    

    // this is a slowness for large histories, I think, but it is the only
    // thing that seems to work, since we are now scrolling the _content
    // element, rather than the window, as Bill intended.
    tags := _content.children as IHTMLElementCollection;
    if (tags.length > 0) then begin
        last := tags.Item(tags.length - 1, 0) as IHTMLElement;
        last.ScrollIntoView(false);
    end;
end;

{---------------------------------------}
procedure TfIEMsgList.ScrollToTop();
var
    tags: IHTMLElementCollection;
    first: IHTMLElement;
begin
    if (_win = nil) then exit;

    // this is a slowness for large histories, I think, but it is the only
    // thing that seems to work, since we are now scrolling the _content
    // element, rather than the window, as Bill intended.
    tags := _content.children as IHTMLElementCollection;
    if (tags.length > 0) then begin
        first := tags.Item(0, 0) as IHTMLElement;
        first.ScrollIntoView(false);
    end;
end;     

{---------------------------------------}
procedure TfIEMsgList.Clear();
begin
    try
        _ready := true;
        _home := 'res://' + URL_EscapeChars(Application.ExeName);
        _Clearing := true;
        browser.Navigate(_home + '/iemsglist');
    except
    end;
end;

{---------------------------------------}
procedure TfIEMsgList.Reset();
begin
    _msgProcessor.Reset();
    _IgnoreMsgLimiting := false;
    Clear();
end;


{---------------------------------------}
procedure TfIEMsgList.setContextMenu(popup: TTntPopupMenu);
begin
    _menu := popup;
end;

{---------------------------------------}
function TfIEMsgList.getHandle(): THandle;
begin
    Result := 0; //Browser.Handle;
end;

{---------------------------------------}
function TfIEMsgList.getObject(): TObject;
begin
    // Result := Browser;
    result := nil;
end;

{---------------------------------------}
procedure TfIEMsgList.DisplayMsg(Msg: TJabberMessage; AutoScroll: boolean = true);
var
    txt: WideString;
    id: widestring;
begin
    if (msg = nil) then exit;

    txt := _msgProcessor.dateSeparator(msg);
    if ((_doMessageLimiting) and (txt <> '')) then begin
        Inc(_msgCount);
    end;
    writeHTML(txt);
    txt := '';

    _clearOldMessages();

    txt := _msgProcessor.ProcessDisplayMsg(Msg, id);
    writeHTML(txt);
    txt := '';

    if (_doc <> nil) then begin
        _lastelement := _doc.all.item(id, 0) as IHTMLElement;
    end
    else begin
        _lastelement := nil;
    end;

    if (_doMessageLimiting) then
        Inc(_msgCount);

    if (_bottom) then
        ScrollToBottom();
end;

{---------------------------------------}
procedure TfIEMsgList.DisplayPresence(nick, txt: Widestring; timestamp: string; dtTimestamp: TDateTime);
var
    pt : integer;
    tags: IHTMLElementCollection;
    dv : IHTMLElement;
    linedv : IHTMLElement;
    sp : IHTMLElement;
    i : integer;
    htmlout: widestring;
    tmsg : TJabberMessage;
    ds: widestring;
begin
    pt := _getPrefInt('pres_tracking');
    if (pt = 2) then exit;

    if ((pt = 1) and (_content <> nil)) then begin
        // if previous is a presence, replace with this one.
        // Pres looks like:
        // <DIV class=line1>
        //     <SPAN class=other>user</SPAN>
        //     <DIV class=msgts>
        //         <SPAN class=ts>9:32 am</SPAN>
        //         <SPAN class=pres>user is now available.</SPAN>
        //     </DIV>
        // </DIV>
        tags := _content.children as IHTMLElementCollection;
        if (tags.length > 0) then begin
            linedv := tags.Item(tags.length - 1, 0) as IHTMLElement; // class=line1 div
            tags := linedv.children as IHTMLElementCollection;
            dv := tags.item(tags.length - 1, 0) as IHTMLElement; // class=msgts div
            tags := dv.children as IHTMLElementCollection;
            for i := 0 to tags.length - 1 do begin
                sp := tags.Item(i, 0) as IHTMLElement; // class=ts, class=pres span
                if (sp.className = 'pres') then begin
                    linedv.outerHTML := ''; // clear div
                    if (_doMessageLimiting) then begin
                        Dec(_msgCount);
                    end;
                    break;
                end;
            end;
        end;
    end;

    if (timestamp <> '') then begin
        if (dtTimestamp > 0) then begin
            tmsg := TJabberMessage.Create();
            tmsg.Time := dtTimestamp;
            tmsg.Subject := '';
            tmsg.Nick := nick;
            ds := _msgProcessor.dateSeparator(tmsg);
            if (ds <> '') then begin
                writeHTML(ds);
            end;
            tmsg.Free();
        end;
    end;

    htmlout := _msgProcessor.ProcessPresenceMsg(nick, txt, timestamp);

    writeHTML(htmlout);

    if (_bottom) then
        ScrollToBottom();

    if (_doMessageLimiting) then
        Inc(_msgCount);
end;

{---------------------------------------}
procedure TfIEMsgList.Save(fn: string);
var
    txt: widestring;
    elem: IHTMLElement;
    byteorder_marker: Word;
    fs: TFileStream;
begin
    fs := nil;

    // Save out the HTML to a file using widestring
    // This means that it is UTF-16
    if (browser = nil) then exit;

    elem := _doc.body.parentElement;
    if (elem = nil) then exit;

    try
        try
            fs := TFileStream.Create(fn, fmCreate);
            byteorder_marker := $FEFF; // Unicode marker for file.
            txt := elem.outerHTML;
            fs.WriteBuffer(byteorder_marker, sizeof(byteorder_marker));
            fs.WriteBuffer(txt[1], Length(txt)*sizeof(txt[1]));
        except

        end;
    finally
        fs.free;
    end;
end;


{---------------------------------------}
procedure TfIEMsgList.setupPrefs();
begin
{$IFDEF EXODUS}
    _stylesheet_name := _getPrefString('ie_css');
{$ELSE}
    _stylesheet_raw := '';
{$ENDIF}
    _color_me := _getPrefInt(P_COLOR_ME);
    _color_other := _getPrefInt(P_COLOR_OTHER);
    _color_action := _getPrefInt(P_COLOR_ACTION);
    _color_server := _getPrefInt(P_COLOR_SERVER);
    _color_time := _getPrefInt(P_COLOR_TIME);
    _color_bg := _getPrefInt(P_COLOR_BG);
    _color_alt_bg := _getPrefInt(P_COLOR_ALT_BG);
    _color_date_bg := _getPrefInt(P_COLOR_DATE_BG);
    _color_date := _getPrefInt(P_COLOR_DATE);
    _font_name := _getPrefString(P_FONT_NAME);
    _font_size := IntToStr(_getPrefInt(P_FONT_SIZE));
    _font_bold := _getPrefBool(P_FONT_BOLD);
    _font_italic := _getPrefBool(P_FONT_ITALIC);
    _font_underline := _getPrefBool(P_FONT_ULINE);
    _font_color := _getPrefInt(P_FONT_COLOR);
    _color_composing := _getPrefInt(P_COLOR_COMPOSING);
    _color_presence := _getPrefInt(P_COLOR_PRESENCE);
    _color_alert := _getPrefInt(P_COLOR_ALERT);
end;

{---------------------------------------}
function TfIEMsgList.empty(): boolean;
begin
    if (_content = nil) then
        Result := true
    else
        Result := (_content.innerHTML = '');
end;

{---------------------------------------}
function TfIEMsgList.getHistory(): Widestring;
begin
    Result := _getHistory();
end;

{---------------------------------------}
function TfIEMsgList._getHistory(includeState: boolean): WideString;
var
    tstr: widestring;
    ts: TTimeStamp;
begin
    Result := '';
    //hide "is replying", don't keep that html around
    HideComposing();
    if (_content <> nil) then
        Result := _content.innerHTML + Result;

    if (includeState) then
    begin
        ts := DateTimeToTimeStamp(_msgProcessor.lastTimeStamp);
        tstr := '<state>';
        tstr := tstr + '<lastts-date>' + IntToStr(ts.Date) + '</lastts-date>';
        tstr := tstr + '<lastts-time>' + IntToStr(ts.Time) + '</lastts-time>';
        tstr := tstr + '<lastnick>' + _msgProcessor.lastMsgNick + '</lastnick>';
        tstr := tstr + '<msgcount>' + IntToStr(_msgCount) + '</msgcount>';
        tstr := tstr + '<lastlineclass>' + _msgProcessor.lastLineClass + '</lastlineclass>';
        tstr := tstr + '<idcount>' + IntToStr(_msgProcessor.idCount) + '</idcount>';
        tstr := tstr + '</state>';
        Result := '<!--' + tstr + '-->' + Result;
    end;
end;

{---------------------------------------}
procedure TfIEMsgList.populate(history: Widestring);
var
    txt: widestring;
    p: integer;
    stag: TXMLtag;
    ts: TTimeStamp;
begin
    p := pos('-->', history);
    if ((p > 0) and
        (LeftStr(history, 4) = '<!--')) then
    begin
        txt := LeftStr(history, p - 1);
        txt := MidStr(txt, 5, Length(txt));
        stag := StringToXMLTag(txt);
        txt := MidStr(history, p + 3, Length(history));
    end
    else txt := history;

    //state info was passed along with history
    if (stag <> nil) then
    begin
        try
            ts.date := StrToInt(stag.GetBasicText('lastts-date'));
            ts.time := StrToInt(stag.GetBasicText('lastts-time'));
        except
            ts.Date := 0;
            ts.Time := 0;
        end;
        _msgProcessor.lastTimeStamp := TimeStampToDateTime(ts);

        _msgProcessor.lastMsgNick := stag.GetBasicText('lastnick');
        if (_doMessageLimiting) then begin
            try
                _msgCount := StrToInt(stag.GetBasicText('msgcount'));
            except
                _msgCount := 0;
            end;
        end;
        _msgProcessor.lastLineClass := stag.GetBasicText('lastlineclass');
        _msgProcessor.idCount := StrToInt(stag.GetBasicText('idcount'));
        stag.Free();
    end;

    writeHTML(txt);

    if (_doMessageLimiting) then begin
        _clearOldMessages();
    end;
end;

{---------------------------------------}
procedure TfIEMsgList.setDragOver(event: TDragOverEvent);
begin
    _dragOver := event;
end;

{---------------------------------------}
procedure TfIEMsgList.setDragDrop(event: TDragDropEvent);
begin
    _dragDrop := event;
end;

{---------------------------------------}
{$IFDEF EXODUS}
procedure TfIEMsgList.ChangeStylesheet(resname: WideString);
begin
    _stylesheet_name := resname;
    ResetStylesheet();
end;
{$ELSE}
procedure TfIEMsgList.SetStylesheet(stylesheet: WideString);
begin
    _stylesheet_raw := stylesheet;
    ResetStylesheet();
end;
{$ENDIF}

{---------------------------------------}
procedure TfIEMsgList.ResetStylesheet();
    function replaceString(source, key, newtxt: Widestring): widestring;
    var
        offset: integer;
    begin
        if ((source = '') or
            (key = '')) then
            exit;

        Result := '';
        offset := Pos(key, source);
        while (offset > 0) do begin
            Result := Result + LeftStr(source, offset - 1);
            Result := Result + newtxt;
            source := MidStr(source, offset + Length(key), Length(source));
            offset := Pos(key, source);
        end;
        Result := Result + source;
    end;
var
    stream: TResourceStream;
    tmp: TWideStringList;
    css: Widestring;
    i: integer;
begin
    try
{$IFDEF EXODUS}
        // Get CSS template from resouce
        stream := TResourceStream.Create(HInstance, _stylesheet_name, 'CSS');

        tmp := TWideStringList.Create;
        tmp.LoadFromStream(stream);
        css := '';
        for i := 0 to tmp.Count - 1 do
            css := css + tmp.Strings[i];
        tmp.Clear;
        tmp.Free;
        stream.Free();
{$ELSE}
        css := _stylesheet_raw;
{$ENDIF}

        // Place colors in CSS
        if (css <> '') then begin
            css := replaceString(css, '/*font_name*/', _font_name);
            css := replaceString(css, '/*font_size*/', _font_size + 'pt');
            if (_font_bold) then begin
                css := replaceString(css, '/*font_weight*/', 'bold');
            end
            else begin
                css := replaceString(css, '/*font_weight*/', 'normal');
            end;
            if (_font_italic) then begin
                css := replaceString(css, '/*font_style*/', 'italic');
            end
            else begin
                css := replaceString(css, '/*font_style*/', 'normal');
            end;
            if (_font_underline) then begin
                css := replaceString(css, '/*text_decoration*/', 'underline');
            end
            else begin
                css := replaceString(css, '/*text_decoration*/', 'none');
            end; 
            css := replaceString(css, '/*font_color*/', HTMLColor(_font_color));
            css := replaceString(css, '/*color_bg*/', HTMLColor(_color_bg));
            css := replaceString(css, '/*color_alt_bg*/', HTMLColor(_color_alt_bg));
            css := replaceString(css, '/*color_date_bg*/', HTMLColor(_color_date_bg));
            css := replaceString(css, '/*color_date*/', HTMLColor(_color_date));
            css := replaceString(css, '/*color_me*/', HTMLColor(_color_me));
            css := replaceString(css, '/*color_other*/', HTMLColor(_color_other));
            css := replaceString(css, '/*color_time*/', HTMLColor(_color_time));
            css := replaceString(css, '/*color_action*/', HTMLColor(_color_action));
            css := replaceString(css, '/*color_server*/', HTMLColor(_color_server));
            css := replaceString(css, '/*color_composing*/', HTMLColor(_color_composing));
            css := replaceString(css, '/*color_presence*/', HTMLColor(_color_presence));
            css := replaceString(css, '/*color_alert*/', HTMLColor(_color_alert));
        end;

        // put CSS into page
        if ((css <> '') and
            (_doc <> nil)) then begin
            _style := _doc.createStyleSheet('', 0);
            _style.cssText := css;
            _style.disabled := false;
        end;
    except
    end;
end;

{---------------------------------------}
procedure TfIEMsgList.onScroll(Sender: TObject);
begin
    if _content2 = nil then
        _bottom := true
    else
    _bottom :=
        ((_content2.scrollTop + _content2.clientHeight) >= _content2.scrollHeight);
end;

{---------------------------------------}
procedure TfIEMsgList.onResize(Sender: TObject);
begin
//    if (_bottom) then
//         ScrollToBottom();
end;

{---------------------------------------}
function TfIEMsgList.onContextMenu(Sender: TObject): WordBool;
begin
    if (_menu <> nil) then
    begin
        _menu.Popup(_win.event.screenX, _win.event.screeny);
    end;
    result := false;
end;

{---------------------------------------}
{$IFDEF EXODUS}

//hack to get outflow working for release. Check to see if copy pop munues have been
//disabled and prevent all copies/cuts and prints if so
function TfIEMsgList.copyMenuEnabled(): boolean;
var
    i: integer;
begin
    Result := true;
    //allow cut/copy only if context men item exists and is enabled.
    if (_menu <> nil) then
    begin
        for i := 0 to _menu.Items.Count - 1 do
        begin
            if (_menu.Items[i].Name = 'Copy1') or (_menu.Items[i].Name = 'popCopy') then
            begin
                //found a copy menu item, copy allowed only when enabled
                Result := _menu.Items[i].Enabled;
                exit;
            end;
        end;
    end;
end;

procedure TfIEMsgList.onKeyDown(Sender: TObject; const pEvtObj: IHTMLEventObj);
begin
    //eat ctrl c,p and x appropriately
    if (pEvtObj.ctrlKey and
       ((pEvtObj.keyCode = 67) or (pEvtObj.keyCode = 80) or (pEvtObj.keyCode = 88))) then
    begin
        if (not CopyMenuEnabled()) then
        begin
            pEvtObj.returnValue := false;
            pEvtObj.keyCode := 0;
        end;
    end;
end;

function TfIEMsgList.onKeyPress(Sender: TObject; const pEvtObj: IHTMLEventObj): WordBool;
var
    bc: TfrmBaseChat;
    key: integer;
    CharKey: char;
begin
    Result := false;
    // If typing starts on the MsgList, then bump it to the outgoing
    // text box.

    if (not (_base is TfrmBaseChat)) then exit;//why not owner here, why "_base", does owner change?

    bc := TfrmBaseChat(_base);
    key := pEvtObj.keyCode;

    pEvtObj.returnValue := false;

    if ((_getPrefBool('esc_close')) and (key = 27)) then
        bc.Close()
    else if (bc.MsgOut.CanFocus()) and (not bc.MsgOut.ReadOnly) then
    begin
        if (key = 22) then
            bc.MsgOut.PasteFromClipboard()  // paste, Ctrl-V
        else if (key >= 32) then
            bc.MsgOut.WideSelText := WideChar(Key);
        try
            bc.MsgOut.SetFocus();
            CharKey := Chr(Key);
            if (_base is TfrmChat) then
                TfrmChat(_base).MsgOutKeyPress(Self, CharKey)
            else if (_base is TfrmRoom) then
                TfrmRoom(_base).MsgOutKeyPress(Self, CharKey);
        except
            on E:Exception do
            begin
                ExUtils.DebugMsg('Exception trying to set focus to composer (' + E.Message + ')', true);
            end;
        end;
        // This shouldn't be needed, but the TWebbrowser control takes back focus.
        // You would think that the SetFocus() calls above wouldn't be necessary then
        // but for some reason the Post doesn't work if they aren't called?
        PostMessage(bc.Handle, WM_SETFOCUS, 0, 0);
    end;
end;

{$ELSE}
function TfIEMsgList.onKeyPress(Sender: TObject; const pEvtObj: IHTMLEventObj): WordBool;
var
    handled: boolean;
begin
    handled := false;

    try
        OnKeyPressHandler(pEvtObj, handled);
    except
        handled := false;
    end;

    Result := handled;
end;

procedure TfIEMsgList.onKeyDown(Sender: TObject; const pEvtObj: IHTMLEventObj);
begin
    //nop
end;

function TfIEMsgList.copyMenuEnabled(): boolean;
begin
    Result := true;
end;
{$ENDIF}

{---------------------------------------}
function TfIEMsgList.onDrop(Sender: TObject): WordBool;
begin
    _dragDrop(sender, browser, _win.event.x, _win.event.y);
    result := false;
end;

{---------------------------------------}
function TfIEMsgList.onDragOver(Sender: TObject): WordBool;
var
    accept: boolean;
begin
    accept := true;
    _dragOver(sender, browser, _win.event.x, _win.event.y, dsDragMove, accept);
    result := accept;
end;

{---------------------------------------}
procedure TfIEMsgList.browserDocumentComplete(Sender: TObject;
  const pDisp: IDispatch; var URL: OleVariant);
var
    i: integer;
begin
    inherited;
    try
        _Clearing := false;

        if ((not _ready) or (browser.Document = nil)) then
            exit;

        _ready := false;
        _doc := browser.Document as IHTMLDocument2;

        ResetStylesheet();
        
        _content := _doc.all.item('content', 0) as IHTMLElement;
        _content2 := _content as IHTMLElement2;
        _body := _doc.body;
        _bottom := true;

        _win := _doc.parentWindow;
        if (_we <> nil) then
            _we.Free();
        if (_we2 <> nil) then
            _we2.Free();

        _we := TMSHTMLHTMLElementEvents.Create(self);
        _we.Connect(_content);
        _we.onscroll   := onscroll;
        _we.onresize   := onresize;
        //_we.ondrop     := ondrop;
        _we.ondragover := ondragover;
        _we2 := TMSHTMLHTMLElementEvents2.Create(self);
        _we2.Connect(_content);
        _we2.onkeypress := onkeypress;
        _we2.onkeydown := onkeydown; 
        if (_de <> nil) then
            _de.Free();
        _de := TMSHTMLHTMLDocumentEvents.Create(self);
        _de.Connect(_doc);
        _de.oncontextmenu := onContextMenu;

        assert (_queue <> nil);
        for i := 0 to _queue.Count - 1 do begin
            writeHTML(_queue.Strings[i]);
        end;
        _queue.Clear();
        if (_title <> '') then begin
            setTitle(_title);
        end;

        InMessageDumpMode := true;
        for i := 0 to _ClearingMsgCache.Count - 1 do begin
            writeHTML(_ClearingMsgCache.Strings[i]);
        end;
        _ClearingMsgCache.Clear();
        InMessageDumpMode := false;

        ScrollToBottom();
    except
        // When Undocking, the browser.Document becomes bad and
        // throws an exception.  Call Clear() to force a re-navigation
        // to reset browser.Document.
        Clear();
    end;
end;

{---------------------------------------}
procedure TfIEMsgList.browserBeforeNavigate2(Sender: TObject;
  const pDisp: IDispatch; var URL, Flags, TargetFrameName, PostData,
  Headers: OleVariant; var Cancel: WordBool);
var
    u: string;
    handled: boolean;
begin
    u := URL;
    // If this navigate is NOT for the internal blank page,
    // try to handle it.
    if (u <> _home + '/iemsglist') then begin
        handled := false;

        try
            NavigateHandler(u, handled);
        except
            handled := true;
        end;

        if (not handled) then
        begin
            ShellExecute(Application.Handle, 'open', pAnsiChar(u), '', '', SW_SHOW);
        end;

        cancel := true;
    end;
    inherited;
end;

{---------------------------------------}
procedure TfIEMsgList.setTitle(title: Widestring);
//var
//    splash : IHTMLElement;
begin
//    if (_doc = nil) then begin
//        _title := title;
//        exit;
//    end;
//
//    splash :=  _doc.all.item('splash', 0) as IHTMLElement;
//    if (splash = nil) then exit;
//
//    splash.innerText := _title;
end;

{---------------------------------------}
procedure TfIEMsgList.ready();
begin
//    _ready := true;
//    Clear();
end;

{---------------------------------------}
procedure TfIEMsgList.refresh();
begin
    _queue.Add(_getHistory(false));
    Clear();
end;

{---------------------------------------}
procedure TfIEMsgList.browserDragDrop(Sender, Source: TObject; X,
  Y: Integer);
begin
    _dragDrop(sender, source, x, y);
//  inherited;
end;

{---------------------------------------}
procedure TfIEMsgList.browserDragOver(Sender, Source: TObject; X,
  Y: Integer; State: TDragState; var Accept: Boolean);
begin
    _dragOver(sender, source, x, y, state, accept);
//   inherited;
end;

{---------------------------------------}
procedure TfIEMsgList.DisplayComposing(msg: Widestring);
var
    outstring: Widestring;
    id: widestring;
begin
    HideComposing();
    _composing := 1;
    id := '';

    outstring := _msgProcessor.ProcessComposing(msg, id);
    writeHTML(outstring);
    _elementID := id;

    ScrollToBottom();
end;

{---------------------------------------}
procedure TfIEMsgList.HideComposing();
var
    composingelement: IHTMLElement;
begin
    if (_composing = -1) then exit;

    try
        composingelement := _doc.all.item(_elementID, 0) as IHTMLElement;
        if (composingelement <> nil) then begin
            composingelement.outerHTML := '';
        end;
    except
    end;

    _elementID := '';
    _composing := -1;
end;

{---------------------------------------}
procedure TfIEMsgList.DisplayRawText(txt: Widestring);
var
    processedTxt: Widestring;
begin
    processedTxt := _msgProcessor.ProcessRawText(txt);
    writeHTML(processedTxt);
end;

{---------------------------------------}
function TfIEMsgList.isComposing(): boolean;
begin
    Result := (_composing >= 0);
end;

{---------------------------------------}
procedure TfIEMsgList.print(ShowDialog: boolean);
var
   vIn, vOut: OleVariant;
begin
    if (browser = nil) then exit;

    if (ShowDialog) then begin
        browser.ControlInterface.ExecWB(OLECMDID_PRINT, OLECMDEXECOPT_PROMPTUSER, vIn, vOut);
    end
    else begin
        browser.ControlInterface.ExecWB(OLECMDID_PRINT, OLECMDEXECOPT_DONTPROMPTUSER, vIn, vOut);
    end;
end;


{---------------------------------------}
procedure TfIEMsgList._clearOldMessages();
var
    children: IHTMLElementCollection;
    elem: IHTMLElement;
begin
    if ((_doMessageLimiting) and
        (not _IgnoreMsgLimiting) and
        (_msgCount >= _maxMsgCountHigh) and
        (_content <> nil)) then begin
        while (_msgCount >= _maxMsgCountLow) do begin
            children := _content.children as IHTMLElementCollection;
            if (children <> nil) then begin
                elem := children.item(0, 0) as IHTMLElement;
                if (elem <> nil) then begin
                    elem.outerHTML := '';
                    Dec(_msgCount);
                end;
            end;
        end;
    end;
end;

{---------------------------------------}
procedure TfIEMsgList._SetInMessageDumpMode(value: boolean);
begin
    _InMessageDumpMode := value;

    if (not value) then begin
        // Coming out of Message Dump mode, so Display the HTML
        if (_MessageDumpModeHTML <> '') then begin
            writeHTML(_MessageDumpModeHTML);
        end;
        _MessageDumpModeHTML := '';
    end;
end;

{---------------------------------------}
procedure TfIEMsgList.DefaultNavHandler(url: widestring; var handled: boolean);
begin
    handled := false;
end;

{---------------------------------------}
procedure TfIEMsgList.OnFileLinkCallback(event: string; tag: TXMLTag);
begin
    if (event <> '/session/filelink/click/response') then exit;
    if (_fileLinkInfo.ExtendedURL <> tag.Data) then exit;
    _fileLinkInfo.Handled := true;
end;

procedure TfIEMsgList.ProcessNavigate(Sender: TObject; const pDisp: IDispatch; var URL, Flags, TargetFrameName, PostData,
Headers: OleVariant; var Cancel: WordBool);
var
   Tag: TXMLTag;
begin
    try
        _fileLinkInfo.ExtendedURL := URL;
        _fileLinkInfo.Handled := false;

        Tag := TXMLTag.Create('filelink', _fileLinkInfo.ExtendedURL);
{$IFDEF EXODUS}
        MainSession.fireEvent('/session/filelink/click', Tag);
{$ELSE}
        _msgProcessor._Controller.fireEvent('/session/filelink/click', Tag.XML, '');
{$ENDIF}

        if ( _fileLinkInfo.Handled) then
            Cancel := true
        else
            browserBeforeNavigate2(Sender, pDisp, URL, Flags,  TargetFrameName, PostData, Headers, Cancel);
    finally
        Tag.Free();
    end;
end;

initialization
    TP_GlobalIgnoreClassProperty(TWebBrowser, 'StatusText');

    ReplaceURLs := TReplaceURLHandler.Create();

    xp_xhtml := TXPLite.Create('/message/html/body');

    ok_tags := THashedStringList.Create();
    ok_tags.Add('blockquote');
    ok_tags.Add('br');
    ok_tags.Add('cite');
    ok_tags.Add('code');
    ok_tags.Add('div');
    ok_tags.Add('em');
    ok_tags.Add('h1');
    ok_tags.Add('h2');
    ok_tags.Add('h3');
    ok_tags.Add('p');
    ok_tags.Add('pre');
    ok_tags.Add('q');
    ok_tags.Add('span');
    ok_tags.Add('strong');
    ok_tags.Add('a');
    ok_tags.Add('ol');
    ok_tags.Add('ul');
    ok_tags.Add('li');
    ok_tags.Add('img');

    style_tags := THashedStringList.Create();
    style_tags.Add('blockquote');
    style_tags.Add('body');
    style_tags.Add('div');
    style_tags.Add('h1');
    style_tags.Add('h2');
    style_tags.Add('h3');
    style_tags.Add('li');
    style_tags.Add('ol');
    style_tags.Add('p');
    style_tags.Add('pre');
    style_tags.Add('q');
    style_tags.Add('span');
    style_tags.Add('ul');

    style_props := THashedStringList.Create();
    style_props.Add('color');
    style_props.Add('font-family');
    style_props.Add('font-size');
    style_props.Add('font-style');
    style_props.Add('font-weight');
    style_props.Add('text-align');
    style_props.Add('text-decoration');

finalization
    xp_xhtml.Free();
    ok_tags.Free();
    style_tags.Free();
    style_props.Free();


end.


