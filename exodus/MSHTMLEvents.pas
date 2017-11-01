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
{ *****************************************************************************
  WARNING: This component file was generated using the EventSinkImp utility.
           The contents of this file will be overwritten everytime EventSinkImp
           is asked to regenerate this sink component.

  NOTE:    When using this component at the same time with the XXX_TLB.pas in
           your Delphi projects, make sure you always put the XXX_TLB unit name
           AFTER this component unit name in the USES clause of the interface
           section of your unit; otherwise you may get interface conflict
           errors from the Delphi compiler.

           EventSinkImp is written by Binh Ly (bly@techvanguards.com)
  *****************************************************************************
  //Sink Classes//
  TMSHTMLHTMLElementEvents
  TMSHTMLHTMLElementEvents2
  TMSHTMLHTMLButtonElementEvents2
  TMSHTMLHTMLWindowEvents
  TMSHTMLHTMLWindowEvents2
  TMSHTMLHTMLDocumentEvents
  TMSHTMLHTMLDocumentEvents2
  TMSHTMLHTMLStyleElementEvents
  TMSHTMLHTMLStyleElementEvents2
}

{$IFDEF VER100}
{$DEFINE D3}
{$ENDIF}

{$WARN SYMBOL_PLATFORM OFF}

//SinkUnitName//
unit MSHTMLEvents;

interface


uses
  Windows, ActiveX, Classes, ComObj, OleCtrls
  //SinkUses//
  , StdVCL
  , MSHTML
  ;

type
  { backward compatibility types }
  {$IFDEF D3}
  OLE_COLOR = TOleColor;
  {$ENDIF}

  TMSHTMLEventsBaseSink = class (TComponent, IUnknown, IDispatch)
  protected
    { IUnknown }
    function QueryInterface(const IID: TGUID; out Obj): HResult; {$IFNDEF D3} override; {$ENDIF} stdcall;
    function _AddRef: Integer; stdcall;
    function _Release: Integer; stdcall;

    { IDispatch }
    function GetIDsOfNames(const IID: TGUID; Names: Pointer;
      NameCount, LocaleID: Integer; DispIDs: Pointer): HResult; virtual; stdcall;
    function GetTypeInfo(Index, LocaleID: Integer; out TypeInfo): HResult; virtual; stdcall;
    function GetTypeInfoCount(out Count: Integer): HResult; virtual; stdcall;
    function Invoke(DispID: Integer; const IID: TGUID; LocaleID: Integer;
      Flags: Word; var Params; VarResult, ExcepInfo, ArgErr: Pointer): HResult; virtual; stdcall;
  protected
    FCookie: integer;
    FCP: IConnectionPoint;
    FSinkIID: TGUID;
    FSource: IUnknown;
    function DoInvoke (DispID: Integer; const IID: TGUID; LocaleID: Integer;
      Flags: Word; var dps: TDispParams; pDispIds: PDispIdList;
      VarResult, ExcepInfo, ArgErr: Pointer): HResult; virtual; abstract;
  public
    destructor Destroy; override;
    procedure Connect (const ASource: IUnknown);
    procedure Disconnect;
    property SinkIID: TGUID read FSinkIID write FSinkIID;
    property Source: IUnknown read FSource;
  end;

  //SinkImportsForwards//

  //SinkImports//

  //SinkIntfStart//

  //SinkEventsForwards//
  THTMLElementEventsonhelpEvent = function (Sender: TObject): WordBool of object;
  THTMLElementEventsonclickEvent = function (Sender: TObject): WordBool of object;
  THTMLElementEventsondblclickEvent = function (Sender: TObject): WordBool of object;
  THTMLElementEventsonkeypressEvent = function (Sender: TObject): WordBool of object;
  THTMLElementEventsonkeydownEvent = procedure (Sender: TObject) of object;
  THTMLElementEventsonkeyupEvent = procedure (Sender: TObject) of object;
  THTMLElementEventsonmouseoutEvent = procedure (Sender: TObject) of object;
  THTMLElementEventsonmouseoverEvent = procedure (Sender: TObject) of object;
  THTMLElementEventsonmousemoveEvent = procedure (Sender: TObject) of object;
  THTMLElementEventsonmousedownEvent = procedure (Sender: TObject) of object;
  THTMLElementEventsonmouseupEvent = procedure (Sender: TObject) of object;
  THTMLElementEventsonselectstartEvent = function (Sender: TObject): WordBool of object;
  THTMLElementEventsonfilterchangeEvent = procedure (Sender: TObject) of object;
  THTMLElementEventsondragstartEvent = function (Sender: TObject): WordBool of object;
  THTMLElementEventsonbeforeupdateEvent = function (Sender: TObject): WordBool of object;
  THTMLElementEventsonafterupdateEvent = procedure (Sender: TObject) of object;
  THTMLElementEventsonerrorupdateEvent = function (Sender: TObject): WordBool of object;
  THTMLElementEventsonrowexitEvent = function (Sender: TObject): WordBool of object;
  THTMLElementEventsonrowenterEvent = procedure (Sender: TObject) of object;
  THTMLElementEventsondatasetchangedEvent = procedure (Sender: TObject) of object;
  THTMLElementEventsondataavailableEvent = procedure (Sender: TObject) of object;
  THTMLElementEventsondatasetcompleteEvent = procedure (Sender: TObject) of object;
  THTMLElementEventsonlosecaptureEvent = procedure (Sender: TObject) of object;
  THTMLElementEventsonpropertychangeEvent = procedure (Sender: TObject) of object;
  THTMLElementEventsonscrollEvent = procedure (Sender: TObject) of object;
  THTMLElementEventsonfocusEvent = procedure (Sender: TObject) of object;
  THTMLElementEventsonblurEvent = procedure (Sender: TObject) of object;
  THTMLElementEventsonresizeEvent = procedure (Sender: TObject) of object;
  THTMLElementEventsondragEvent = function (Sender: TObject): WordBool of object;
  THTMLElementEventsondragendEvent = procedure (Sender: TObject) of object;
  THTMLElementEventsondragenterEvent = function (Sender: TObject): WordBool of object;
  THTMLElementEventsondragoverEvent = function (Sender: TObject): WordBool of object;
  THTMLElementEventsondragleaveEvent = procedure (Sender: TObject) of object;
  THTMLElementEventsondropEvent = function (Sender: TObject): WordBool of object;
  THTMLElementEventsonbeforecutEvent = function (Sender: TObject): WordBool of object;
  THTMLElementEventsoncutEvent = function (Sender: TObject): WordBool of object;
  THTMLElementEventsonbeforecopyEvent = function (Sender: TObject): WordBool of object;
  THTMLElementEventsoncopyEvent = function (Sender: TObject): WordBool of object;
  THTMLElementEventsonbeforepasteEvent = function (Sender: TObject): WordBool of object;
  THTMLElementEventsonpasteEvent = function (Sender: TObject): WordBool of object;
  THTMLElementEventsoncontextmenuEvent = function (Sender: TObject): WordBool of object;
  THTMLElementEventsonrowsdeleteEvent = procedure (Sender: TObject) of object;
  THTMLElementEventsonrowsinsertedEvent = procedure (Sender: TObject) of object;
  THTMLElementEventsoncellchangeEvent = procedure (Sender: TObject) of object;
  THTMLElementEventsonreadystatechangeEvent = procedure (Sender: TObject) of object;
  THTMLElementEventsonbeforeeditfocusEvent = procedure (Sender: TObject) of object;
  THTMLElementEventsonlayoutcompleteEvent = procedure (Sender: TObject) of object;
  THTMLElementEventsonpageEvent = procedure (Sender: TObject) of object;
  THTMLElementEventsonbeforedeactivateEvent = function (Sender: TObject): WordBool of object;
  THTMLElementEventsonbeforeactivateEvent = function (Sender: TObject): WordBool of object;
  THTMLElementEventsonmoveEvent = procedure (Sender: TObject) of object;
  THTMLElementEventsoncontrolselectEvent = function (Sender: TObject): WordBool of object;
  THTMLElementEventsonmovestartEvent = function (Sender: TObject): WordBool of object;
  THTMLElementEventsonmoveendEvent = procedure (Sender: TObject) of object;
  THTMLElementEventsonresizestartEvent = function (Sender: TObject): WordBool of object;
  THTMLElementEventsonresizeendEvent = procedure (Sender: TObject) of object;
  THTMLElementEventsonmouseenterEvent = procedure (Sender: TObject) of object;
  THTMLElementEventsonmouseleaveEvent = procedure (Sender: TObject) of object;
  THTMLElementEventsonmousewheelEvent = function (Sender: TObject): WordBool of object;
  THTMLElementEventsonactivateEvent = procedure (Sender: TObject) of object;
  THTMLElementEventsondeactivateEvent = procedure (Sender: TObject) of object;
  THTMLElementEventsonfocusinEvent = procedure (Sender: TObject) of object;
  THTMLElementEventsonfocusoutEvent = procedure (Sender: TObject) of object;

  //SinkComponent//
  TMSHTMLHTMLElementEvents = class (TMSHTMLEventsBaseSink
    //ISinkInterface//
  )
  protected
    function DoInvoke (DispID: Integer; const IID: TGUID; LocaleID: Integer;
      Flags: Word; var dps: TDispParams; pDispIds: PDispIdList;
      VarResult, ExcepInfo, ArgErr: Pointer): HResult; override;

    //ISinkInterfaceMethods//
  public
    { system methods }
    constructor Create (AOwner: TComponent); override;
  protected
    //SinkInterface//
    function Doonhelp: WordBool; safecall;
    function Doonclick: WordBool; safecall;
    function Doondblclick: WordBool; safecall;
    function Doonkeypress: WordBool; safecall;
    procedure Doonkeydown; safecall;
    procedure Doonkeyup; safecall;
    procedure Doonmouseout; safecall;
    procedure Doonmouseover; safecall;
    procedure Doonmousemove; safecall;
    procedure Doonmousedown; safecall;
    procedure Doonmouseup; safecall;
    function Doonselectstart: WordBool; safecall;
    procedure Doonfilterchange; safecall;
    function Doondragstart: WordBool; safecall;
    function Doonbeforeupdate: WordBool; safecall;
    procedure Doonafterupdate; safecall;
    function Doonerrorupdate: WordBool; safecall;
    function Doonrowexit: WordBool; safecall;
    procedure Doonrowenter; safecall;
    procedure Doondatasetchanged; safecall;
    procedure Doondataavailable; safecall;
    procedure Doondatasetcomplete; safecall;
    procedure Doonlosecapture; safecall;
    procedure Doonpropertychange; safecall;
    procedure Doonscroll; safecall;
    procedure Doonfocus; safecall;
    procedure Doonblur; safecall;
    procedure Doonresize; safecall;
    function Doondrag: WordBool; safecall;
    procedure Doondragend; safecall;
    function Doondragenter: WordBool; safecall;
    function Doondragover: WordBool; safecall;
    procedure Doondragleave; safecall;
    function Doondrop: WordBool; safecall;
    function Doonbeforecut: WordBool; safecall;
    function Dooncut: WordBool; safecall;
    function Doonbeforecopy: WordBool; safecall;
    function Dooncopy: WordBool; safecall;
    function Doonbeforepaste: WordBool; safecall;
    function Doonpaste: WordBool; safecall;
    function Dooncontextmenu: WordBool; safecall;
    procedure Doonrowsdelete; safecall;
    procedure Doonrowsinserted; safecall;
    procedure Dooncellchange; safecall;
    procedure Doonreadystatechange; safecall;
    procedure Doonbeforeeditfocus; safecall;
    procedure Doonlayoutcomplete; safecall;
    procedure Doonpage; safecall;
    function Doonbeforedeactivate: WordBool; safecall;
    function Doonbeforeactivate: WordBool; safecall;
    procedure Doonmove; safecall;
    function Dooncontrolselect: WordBool; safecall;
    function Doonmovestart: WordBool; safecall;
    procedure Doonmoveend; safecall;
    function Doonresizestart: WordBool; safecall;
    procedure Doonresizeend; safecall;
    procedure Doonmouseenter; safecall;
    procedure Doonmouseleave; safecall;
    function Doonmousewheel: WordBool; safecall;
    procedure Doonactivate; safecall;
    procedure Doondeactivate; safecall;
    procedure Doonfocusin; safecall;
    procedure Doonfocusout; safecall;
  protected
    //SinkEventsProtected//
    Fonhelp: THTMLElementEventsonhelpEvent;
    Fonclick: THTMLElementEventsonclickEvent;
    Fondblclick: THTMLElementEventsondblclickEvent;
    Fonkeypress: THTMLElementEventsonkeypressEvent;
    Fonkeydown: THTMLElementEventsonkeydownEvent;
    Fonkeyup: THTMLElementEventsonkeyupEvent;
    Fonmouseout: THTMLElementEventsonmouseoutEvent;
    Fonmouseover: THTMLElementEventsonmouseoverEvent;
    Fonmousemove: THTMLElementEventsonmousemoveEvent;
    Fonmousedown: THTMLElementEventsonmousedownEvent;
    Fonmouseup: THTMLElementEventsonmouseupEvent;
    Fonselectstart: THTMLElementEventsonselectstartEvent;
    Fonfilterchange: THTMLElementEventsonfilterchangeEvent;
    Fondragstart: THTMLElementEventsondragstartEvent;
    Fonbeforeupdate: THTMLElementEventsonbeforeupdateEvent;
    Fonafterupdate: THTMLElementEventsonafterupdateEvent;
    Fonerrorupdate: THTMLElementEventsonerrorupdateEvent;
    Fonrowexit: THTMLElementEventsonrowexitEvent;
    Fonrowenter: THTMLElementEventsonrowenterEvent;
    Fondatasetchanged: THTMLElementEventsondatasetchangedEvent;
    Fondataavailable: THTMLElementEventsondataavailableEvent;
    Fondatasetcomplete: THTMLElementEventsondatasetcompleteEvent;
    Fonlosecapture: THTMLElementEventsonlosecaptureEvent;
    Fonpropertychange: THTMLElementEventsonpropertychangeEvent;
    Fonscroll: THTMLElementEventsonscrollEvent;
    Fonfocus: THTMLElementEventsonfocusEvent;
    Fonblur: THTMLElementEventsonblurEvent;
    Fonresize: THTMLElementEventsonresizeEvent;
    Fondrag: THTMLElementEventsondragEvent;
    Fondragend: THTMLElementEventsondragendEvent;
    Fondragenter: THTMLElementEventsondragenterEvent;
    Fondragover: THTMLElementEventsondragoverEvent;
    Fondragleave: THTMLElementEventsondragleaveEvent;
    Fondrop: THTMLElementEventsondropEvent;
    Fonbeforecut: THTMLElementEventsonbeforecutEvent;
    Foncut: THTMLElementEventsoncutEvent;
    Fonbeforecopy: THTMLElementEventsonbeforecopyEvent;
    Foncopy: THTMLElementEventsoncopyEvent;
    Fonbeforepaste: THTMLElementEventsonbeforepasteEvent;
    Fonpaste: THTMLElementEventsonpasteEvent;
    Foncontextmenu: THTMLElementEventsoncontextmenuEvent;
    Fonrowsdelete: THTMLElementEventsonrowsdeleteEvent;
    Fonrowsinserted: THTMLElementEventsonrowsinsertedEvent;
    Foncellchange: THTMLElementEventsoncellchangeEvent;
    Fonreadystatechange: THTMLElementEventsonreadystatechangeEvent;
    Fonbeforeeditfocus: THTMLElementEventsonbeforeeditfocusEvent;
    Fonlayoutcomplete: THTMLElementEventsonlayoutcompleteEvent;
    Fonpage: THTMLElementEventsonpageEvent;
    Fonbeforedeactivate: THTMLElementEventsonbeforedeactivateEvent;
    Fonbeforeactivate: THTMLElementEventsonbeforeactivateEvent;
    Fonmove: THTMLElementEventsonmoveEvent;
    Foncontrolselect: THTMLElementEventsoncontrolselectEvent;
    Fonmovestart: THTMLElementEventsonmovestartEvent;
    Fonmoveend: THTMLElementEventsonmoveendEvent;
    Fonresizestart: THTMLElementEventsonresizestartEvent;
    Fonresizeend: THTMLElementEventsonresizeendEvent;
    Fonmouseenter: THTMLElementEventsonmouseenterEvent;
    Fonmouseleave: THTMLElementEventsonmouseleaveEvent;
    Fonmousewheel: THTMLElementEventsonmousewheelEvent;
    Fonactivate: THTMLElementEventsonactivateEvent;
    Fondeactivate: THTMLElementEventsondeactivateEvent;
    Fonfocusin: THTMLElementEventsonfocusinEvent;
    Fonfocusout: THTMLElementEventsonfocusoutEvent;
  published
    //SinkEventsPublished//
    property onhelp: THTMLElementEventsonhelpEvent read Fonhelp write Fonhelp;
    property onclick: THTMLElementEventsonclickEvent read Fonclick write Fonclick;
    property ondblclick: THTMLElementEventsondblclickEvent read Fondblclick write Fondblclick;
    property onkeypress: THTMLElementEventsonkeypressEvent read Fonkeypress write Fonkeypress;
    property onkeydown: THTMLElementEventsonkeydownEvent read Fonkeydown write Fonkeydown;
    property onkeyup: THTMLElementEventsonkeyupEvent read Fonkeyup write Fonkeyup;
    property onmouseout: THTMLElementEventsonmouseoutEvent read Fonmouseout write Fonmouseout;
    property onmouseover: THTMLElementEventsonmouseoverEvent read Fonmouseover write Fonmouseover;
    property onmousemove: THTMLElementEventsonmousemoveEvent read Fonmousemove write Fonmousemove;
    property onmousedown: THTMLElementEventsonmousedownEvent read Fonmousedown write Fonmousedown;
    property onmouseup: THTMLElementEventsonmouseupEvent read Fonmouseup write Fonmouseup;
    property onselectstart: THTMLElementEventsonselectstartEvent read Fonselectstart write Fonselectstart;
    property onfilterchange: THTMLElementEventsonfilterchangeEvent read Fonfilterchange write Fonfilterchange;
    property ondragstart: THTMLElementEventsondragstartEvent read Fondragstart write Fondragstart;
    property onbeforeupdate: THTMLElementEventsonbeforeupdateEvent read Fonbeforeupdate write Fonbeforeupdate;
    property onafterupdate: THTMLElementEventsonafterupdateEvent read Fonafterupdate write Fonafterupdate;
    property onerrorupdate: THTMLElementEventsonerrorupdateEvent read Fonerrorupdate write Fonerrorupdate;
    property onrowexit: THTMLElementEventsonrowexitEvent read Fonrowexit write Fonrowexit;
    property onrowenter: THTMLElementEventsonrowenterEvent read Fonrowenter write Fonrowenter;
    property ondatasetchanged: THTMLElementEventsondatasetchangedEvent read Fondatasetchanged write Fondatasetchanged;
    property ondataavailable: THTMLElementEventsondataavailableEvent read Fondataavailable write Fondataavailable;
    property ondatasetcomplete: THTMLElementEventsondatasetcompleteEvent read Fondatasetcomplete write Fondatasetcomplete;
    property onlosecapture: THTMLElementEventsonlosecaptureEvent read Fonlosecapture write Fonlosecapture;
    property onpropertychange: THTMLElementEventsonpropertychangeEvent read Fonpropertychange write Fonpropertychange;
    property onscroll: THTMLElementEventsonscrollEvent read Fonscroll write Fonscroll;
    property onfocus: THTMLElementEventsonfocusEvent read Fonfocus write Fonfocus;
    property onblur: THTMLElementEventsonblurEvent read Fonblur write Fonblur;
    property onresize: THTMLElementEventsonresizeEvent read Fonresize write Fonresize;
    property ondrag: THTMLElementEventsondragEvent read Fondrag write Fondrag;
    property ondragend: THTMLElementEventsondragendEvent read Fondragend write Fondragend;
    property ondragenter: THTMLElementEventsondragenterEvent read Fondragenter write Fondragenter;
    property ondragover: THTMLElementEventsondragoverEvent read Fondragover write Fondragover;
    property ondragleave: THTMLElementEventsondragleaveEvent read Fondragleave write Fondragleave;
    property ondrop: THTMLElementEventsondropEvent read Fondrop write Fondrop;
    property onbeforecut: THTMLElementEventsonbeforecutEvent read Fonbeforecut write Fonbeforecut;
    property oncut: THTMLElementEventsoncutEvent read Foncut write Foncut;
    property onbeforecopy: THTMLElementEventsonbeforecopyEvent read Fonbeforecopy write Fonbeforecopy;
    property oncopy: THTMLElementEventsoncopyEvent read Foncopy write Foncopy;
    property onbeforepaste: THTMLElementEventsonbeforepasteEvent read Fonbeforepaste write Fonbeforepaste;
    property onpaste: THTMLElementEventsonpasteEvent read Fonpaste write Fonpaste;
    property oncontextmenu: THTMLElementEventsoncontextmenuEvent read Foncontextmenu write Foncontextmenu;
    property onrowsdelete: THTMLElementEventsonrowsdeleteEvent read Fonrowsdelete write Fonrowsdelete;
    property onrowsinserted: THTMLElementEventsonrowsinsertedEvent read Fonrowsinserted write Fonrowsinserted;
    property oncellchange: THTMLElementEventsoncellchangeEvent read Foncellchange write Foncellchange;
    property onreadystatechange: THTMLElementEventsonreadystatechangeEvent read Fonreadystatechange write Fonreadystatechange;
    property onbeforeeditfocus: THTMLElementEventsonbeforeeditfocusEvent read Fonbeforeeditfocus write Fonbeforeeditfocus;
    property onlayoutcomplete: THTMLElementEventsonlayoutcompleteEvent read Fonlayoutcomplete write Fonlayoutcomplete;
    property onpage: THTMLElementEventsonpageEvent read Fonpage write Fonpage;
    property onbeforedeactivate: THTMLElementEventsonbeforedeactivateEvent read Fonbeforedeactivate write Fonbeforedeactivate;
    property onbeforeactivate: THTMLElementEventsonbeforeactivateEvent read Fonbeforeactivate write Fonbeforeactivate;
    property onmove: THTMLElementEventsonmoveEvent read Fonmove write Fonmove;
    property oncontrolselect: THTMLElementEventsoncontrolselectEvent read Foncontrolselect write Foncontrolselect;
    property onmovestart: THTMLElementEventsonmovestartEvent read Fonmovestart write Fonmovestart;
    property onmoveend: THTMLElementEventsonmoveendEvent read Fonmoveend write Fonmoveend;
    property onresizestart: THTMLElementEventsonresizestartEvent read Fonresizestart write Fonresizestart;
    property onresizeend: THTMLElementEventsonresizeendEvent read Fonresizeend write Fonresizeend;
    property onmouseenter: THTMLElementEventsonmouseenterEvent read Fonmouseenter write Fonmouseenter;
    property onmouseleave: THTMLElementEventsonmouseleaveEvent read Fonmouseleave write Fonmouseleave;
    property onmousewheel: THTMLElementEventsonmousewheelEvent read Fonmousewheel write Fonmousewheel;
    property onactivate: THTMLElementEventsonactivateEvent read Fonactivate write Fonactivate;
    property ondeactivate: THTMLElementEventsondeactivateEvent read Fondeactivate write Fondeactivate;
    property onfocusin: THTMLElementEventsonfocusinEvent read Fonfocusin write Fonfocusin;
    property onfocusout: THTMLElementEventsonfocusoutEvent read Fonfocusout write Fonfocusout;
  end;


  //SinkEventsForwards//
  THTMLElementEvents2onhelpEvent = function (Sender: TObject; const pEvtObj: IHTMLEventObj): WordBool of object;
  THTMLElementEvents2onclickEvent = function (Sender: TObject; const pEvtObj: IHTMLEventObj): WordBool of object;
  THTMLElementEvents2ondblclickEvent = function (Sender: TObject; const pEvtObj: IHTMLEventObj): WordBool of object;
  THTMLElementEvents2onkeypressEvent = function (Sender: TObject; const pEvtObj: IHTMLEventObj): WordBool of object;
  THTMLElementEvents2onkeydownEvent = procedure (Sender: TObject; const pEvtObj: IHTMLEventObj) of object;
  THTMLElementEvents2onkeyupEvent = procedure (Sender: TObject; const pEvtObj: IHTMLEventObj) of object;
  THTMLElementEvents2onmouseoutEvent = procedure (Sender: TObject; const pEvtObj: IHTMLEventObj) of object;
  THTMLElementEvents2onmouseoverEvent = procedure (Sender: TObject; const pEvtObj: IHTMLEventObj) of object;
  THTMLElementEvents2onmousemoveEvent = procedure (Sender: TObject; const pEvtObj: IHTMLEventObj) of object;
  THTMLElementEvents2onmousedownEvent = procedure (Sender: TObject; const pEvtObj: IHTMLEventObj) of object;
  THTMLElementEvents2onmouseupEvent = procedure (Sender: TObject; const pEvtObj: IHTMLEventObj) of object;
  THTMLElementEvents2onselectstartEvent = function (Sender: TObject; const pEvtObj: IHTMLEventObj): WordBool of object;
  THTMLElementEvents2onfilterchangeEvent = procedure (Sender: TObject; const pEvtObj: IHTMLEventObj) of object;
  THTMLElementEvents2ondragstartEvent = function (Sender: TObject; const pEvtObj: IHTMLEventObj): WordBool of object;
  THTMLElementEvents2onbeforeupdateEvent = function (Sender: TObject; const pEvtObj: IHTMLEventObj): WordBool of object;
  THTMLElementEvents2onafterupdateEvent = procedure (Sender: TObject; const pEvtObj: IHTMLEventObj) of object;
  THTMLElementEvents2onerrorupdateEvent = function (Sender: TObject; const pEvtObj: IHTMLEventObj): WordBool of object;
  THTMLElementEvents2onrowexitEvent = function (Sender: TObject; const pEvtObj: IHTMLEventObj): WordBool of object;
  THTMLElementEvents2onrowenterEvent = procedure (Sender: TObject; const pEvtObj: IHTMLEventObj) of object;
  THTMLElementEvents2ondatasetchangedEvent = procedure (Sender: TObject; const pEvtObj: IHTMLEventObj) of object;
  THTMLElementEvents2ondataavailableEvent = procedure (Sender: TObject; const pEvtObj: IHTMLEventObj) of object;
  THTMLElementEvents2ondatasetcompleteEvent = procedure (Sender: TObject; const pEvtObj: IHTMLEventObj) of object;
  THTMLElementEvents2onlosecaptureEvent = procedure (Sender: TObject; const pEvtObj: IHTMLEventObj) of object;
  THTMLElementEvents2onpropertychangeEvent = procedure (Sender: TObject; const pEvtObj: IHTMLEventObj) of object;
  THTMLElementEvents2onscrollEvent = procedure (Sender: TObject; const pEvtObj: IHTMLEventObj) of object;
  THTMLElementEvents2onfocusEvent = procedure (Sender: TObject; const pEvtObj: IHTMLEventObj) of object;
  THTMLElementEvents2onblurEvent = procedure (Sender: TObject; const pEvtObj: IHTMLEventObj) of object;
  THTMLElementEvents2onresizeEvent = procedure (Sender: TObject; const pEvtObj: IHTMLEventObj) of object;
  THTMLElementEvents2ondragEvent = function (Sender: TObject; const pEvtObj: IHTMLEventObj): WordBool of object;
  THTMLElementEvents2ondragendEvent = procedure (Sender: TObject; const pEvtObj: IHTMLEventObj) of object;
  THTMLElementEvents2ondragenterEvent = function (Sender: TObject; const pEvtObj: IHTMLEventObj): WordBool of object;
  THTMLElementEvents2ondragoverEvent = function (Sender: TObject; const pEvtObj: IHTMLEventObj): WordBool of object;
  THTMLElementEvents2ondragleaveEvent = procedure (Sender: TObject; const pEvtObj: IHTMLEventObj) of object;
  THTMLElementEvents2ondropEvent = function (Sender: TObject; const pEvtObj: IHTMLEventObj): WordBool of object;
  THTMLElementEvents2onbeforecutEvent = function (Sender: TObject; const pEvtObj: IHTMLEventObj): WordBool of object;
  THTMLElementEvents2oncutEvent = function (Sender: TObject; const pEvtObj: IHTMLEventObj): WordBool of object;
  THTMLElementEvents2onbeforecopyEvent = function (Sender: TObject; const pEvtObj: IHTMLEventObj): WordBool of object;
  THTMLElementEvents2oncopyEvent = function (Sender: TObject; const pEvtObj: IHTMLEventObj): WordBool of object;
  THTMLElementEvents2onbeforepasteEvent = function (Sender: TObject; const pEvtObj: IHTMLEventObj): WordBool of object;
  THTMLElementEvents2onpasteEvent = function (Sender: TObject; const pEvtObj: IHTMLEventObj): WordBool of object;
  THTMLElementEvents2oncontextmenuEvent = function (Sender: TObject; const pEvtObj: IHTMLEventObj): WordBool of object;
  THTMLElementEvents2onrowsdeleteEvent = procedure (Sender: TObject; const pEvtObj: IHTMLEventObj) of object;
  THTMLElementEvents2onrowsinsertedEvent = procedure (Sender: TObject; const pEvtObj: IHTMLEventObj) of object;
  THTMLElementEvents2oncellchangeEvent = procedure (Sender: TObject; const pEvtObj: IHTMLEventObj) of object;
  THTMLElementEvents2onreadystatechangeEvent = procedure (Sender: TObject; const pEvtObj: IHTMLEventObj) of object;
  THTMLElementEvents2onlayoutcompleteEvent = procedure (Sender: TObject; const pEvtObj: IHTMLEventObj) of object;
  THTMLElementEvents2onpageEvent = procedure (Sender: TObject; const pEvtObj: IHTMLEventObj) of object;
  THTMLElementEvents2onmouseenterEvent = procedure (Sender: TObject; const pEvtObj: IHTMLEventObj) of object;
  THTMLElementEvents2onmouseleaveEvent = procedure (Sender: TObject; const pEvtObj: IHTMLEventObj) of object;
  THTMLElementEvents2onactivateEvent = procedure (Sender: TObject; const pEvtObj: IHTMLEventObj) of object;
  THTMLElementEvents2ondeactivateEvent = procedure (Sender: TObject; const pEvtObj: IHTMLEventObj) of object;
  THTMLElementEvents2onbeforedeactivateEvent = function (Sender: TObject; const pEvtObj: IHTMLEventObj): WordBool of object;
  THTMLElementEvents2onbeforeactivateEvent = function (Sender: TObject; const pEvtObj: IHTMLEventObj): WordBool of object;
  THTMLElementEvents2onfocusinEvent = procedure (Sender: TObject; const pEvtObj: IHTMLEventObj) of object;
  THTMLElementEvents2onfocusoutEvent = procedure (Sender: TObject; const pEvtObj: IHTMLEventObj) of object;
  THTMLElementEvents2onmoveEvent = procedure (Sender: TObject; const pEvtObj: IHTMLEventObj) of object;
  THTMLElementEvents2oncontrolselectEvent = function (Sender: TObject; const pEvtObj: IHTMLEventObj): WordBool of object;
  THTMLElementEvents2onmovestartEvent = function (Sender: TObject; const pEvtObj: IHTMLEventObj): WordBool of object;
  THTMLElementEvents2onmoveendEvent = procedure (Sender: TObject; const pEvtObj: IHTMLEventObj) of object;
  THTMLElementEvents2onresizestartEvent = function (Sender: TObject; const pEvtObj: IHTMLEventObj): WordBool of object;
  THTMLElementEvents2onresizeendEvent = procedure (Sender: TObject; const pEvtObj: IHTMLEventObj) of object;
  THTMLElementEvents2onmousewheelEvent = function (Sender: TObject; const pEvtObj: IHTMLEventObj): WordBool of object;

  //SinkComponent//
  TMSHTMLHTMLElementEvents2 = class (TMSHTMLEventsBaseSink
    //ISinkInterface//
  )
  protected
    function DoInvoke (DispID: Integer; const IID: TGUID; LocaleID: Integer;
      Flags: Word; var dps: TDispParams; pDispIds: PDispIdList;
      VarResult, ExcepInfo, ArgErr: Pointer): HResult; override;

    //ISinkInterfaceMethods//
  public
    { system methods }
    constructor Create (AOwner: TComponent); override;
  protected
    //SinkInterface//
    function Doonhelp(const pEvtObj: IHTMLEventObj): WordBool; safecall;
    function Doonclick(const pEvtObj: IHTMLEventObj): WordBool; safecall;
    function Doondblclick(const pEvtObj: IHTMLEventObj): WordBool; safecall;
    function Doonkeypress(const pEvtObj: IHTMLEventObj): WordBool; safecall;
    procedure Doonkeydown(const pEvtObj: IHTMLEventObj); safecall;
    procedure Doonkeyup(const pEvtObj: IHTMLEventObj); safecall;
    procedure Doonmouseout(const pEvtObj: IHTMLEventObj); safecall;
    procedure Doonmouseover(const pEvtObj: IHTMLEventObj); safecall;
    procedure Doonmousemove(const pEvtObj: IHTMLEventObj); safecall;
    procedure Doonmousedown(const pEvtObj: IHTMLEventObj); safecall;
    procedure Doonmouseup(const pEvtObj: IHTMLEventObj); safecall;
    function Doonselectstart(const pEvtObj: IHTMLEventObj): WordBool; safecall;
    procedure Doonfilterchange(const pEvtObj: IHTMLEventObj); safecall;
    function Doondragstart(const pEvtObj: IHTMLEventObj): WordBool; safecall;
    function Doonbeforeupdate(const pEvtObj: IHTMLEventObj): WordBool; safecall;
    procedure Doonafterupdate(const pEvtObj: IHTMLEventObj); safecall;
    function Doonerrorupdate(const pEvtObj: IHTMLEventObj): WordBool; safecall;
    function Doonrowexit(const pEvtObj: IHTMLEventObj): WordBool; safecall;
    procedure Doonrowenter(const pEvtObj: IHTMLEventObj); safecall;
    procedure Doondatasetchanged(const pEvtObj: IHTMLEventObj); safecall;
    procedure Doondataavailable(const pEvtObj: IHTMLEventObj); safecall;
    procedure Doondatasetcomplete(const pEvtObj: IHTMLEventObj); safecall;
    procedure Doonlosecapture(const pEvtObj: IHTMLEventObj); safecall;
    procedure Doonpropertychange(const pEvtObj: IHTMLEventObj); safecall;
    procedure Doonscroll(const pEvtObj: IHTMLEventObj); safecall;
    procedure Doonfocus(const pEvtObj: IHTMLEventObj); safecall;
    procedure Doonblur(const pEvtObj: IHTMLEventObj); safecall;
    procedure Doonresize(const pEvtObj: IHTMLEventObj); safecall;
    function Doondrag(const pEvtObj: IHTMLEventObj): WordBool; safecall;
    procedure Doondragend(const pEvtObj: IHTMLEventObj); safecall;
    function Doondragenter(const pEvtObj: IHTMLEventObj): WordBool; safecall;
    function Doondragover(const pEvtObj: IHTMLEventObj): WordBool; safecall;
    procedure Doondragleave(const pEvtObj: IHTMLEventObj); safecall;
    function Doondrop(const pEvtObj: IHTMLEventObj): WordBool; safecall;
    function Doonbeforecut(const pEvtObj: IHTMLEventObj): WordBool; safecall;
    function Dooncut(const pEvtObj: IHTMLEventObj): WordBool; safecall;
    function Doonbeforecopy(const pEvtObj: IHTMLEventObj): WordBool; safecall;
    function Dooncopy(const pEvtObj: IHTMLEventObj): WordBool; safecall;
    function Doonbeforepaste(const pEvtObj: IHTMLEventObj): WordBool; safecall;
    function Doonpaste(const pEvtObj: IHTMLEventObj): WordBool; safecall;
    function Dooncontextmenu(const pEvtObj: IHTMLEventObj): WordBool; safecall;
    procedure Doonrowsdelete(const pEvtObj: IHTMLEventObj); safecall;
    procedure Doonrowsinserted(const pEvtObj: IHTMLEventObj); safecall;
    procedure Dooncellchange(const pEvtObj: IHTMLEventObj); safecall;
    procedure Doonreadystatechange(const pEvtObj: IHTMLEventObj); safecall;
    procedure Doonlayoutcomplete(const pEvtObj: IHTMLEventObj); safecall;
    procedure Doonpage(const pEvtObj: IHTMLEventObj); safecall;
    procedure Doonmouseenter(const pEvtObj: IHTMLEventObj); safecall;
    procedure Doonmouseleave(const pEvtObj: IHTMLEventObj); safecall;
    procedure Doonactivate(const pEvtObj: IHTMLEventObj); safecall;
    procedure Doondeactivate(const pEvtObj: IHTMLEventObj); safecall;
    function Doonbeforedeactivate(const pEvtObj: IHTMLEventObj): WordBool; safecall;
    function Doonbeforeactivate(const pEvtObj: IHTMLEventObj): WordBool; safecall;
    procedure Doonfocusin(const pEvtObj: IHTMLEventObj); safecall;
    procedure Doonfocusout(const pEvtObj: IHTMLEventObj); safecall;
    procedure Doonmove(const pEvtObj: IHTMLEventObj); safecall;
    function Dooncontrolselect(const pEvtObj: IHTMLEventObj): WordBool; safecall;
    function Doonmovestart(const pEvtObj: IHTMLEventObj): WordBool; safecall;
    procedure Doonmoveend(const pEvtObj: IHTMLEventObj); safecall;
    function Doonresizestart(const pEvtObj: IHTMLEventObj): WordBool; safecall;
    procedure Doonresizeend(const pEvtObj: IHTMLEventObj); safecall;
    function Doonmousewheel(const pEvtObj: IHTMLEventObj): WordBool; safecall;
  protected
    //SinkEventsProtected//
    Fonhelp: THTMLElementEvents2onhelpEvent;
    Fonclick: THTMLElementEvents2onclickEvent;
    Fondblclick: THTMLElementEvents2ondblclickEvent;
    Fonkeypress: THTMLElementEvents2onkeypressEvent;
    Fonkeydown: THTMLElementEvents2onkeydownEvent;
    Fonkeyup: THTMLElementEvents2onkeyupEvent;
    Fonmouseout: THTMLElementEvents2onmouseoutEvent;
    Fonmouseover: THTMLElementEvents2onmouseoverEvent;
    Fonmousemove: THTMLElementEvents2onmousemoveEvent;
    Fonmousedown: THTMLElementEvents2onmousedownEvent;
    Fonmouseup: THTMLElementEvents2onmouseupEvent;
    Fonselectstart: THTMLElementEvents2onselectstartEvent;
    Fonfilterchange: THTMLElementEvents2onfilterchangeEvent;
    Fondragstart: THTMLElementEvents2ondragstartEvent;
    Fonbeforeupdate: THTMLElementEvents2onbeforeupdateEvent;
    Fonafterupdate: THTMLElementEvents2onafterupdateEvent;
    Fonerrorupdate: THTMLElementEvents2onerrorupdateEvent;
    Fonrowexit: THTMLElementEvents2onrowexitEvent;
    Fonrowenter: THTMLElementEvents2onrowenterEvent;
    Fondatasetchanged: THTMLElementEvents2ondatasetchangedEvent;
    Fondataavailable: THTMLElementEvents2ondataavailableEvent;
    Fondatasetcomplete: THTMLElementEvents2ondatasetcompleteEvent;
    Fonlosecapture: THTMLElementEvents2onlosecaptureEvent;
    Fonpropertychange: THTMLElementEvents2onpropertychangeEvent;
    Fonscroll: THTMLElementEvents2onscrollEvent;
    Fonfocus: THTMLElementEvents2onfocusEvent;
    Fonblur: THTMLElementEvents2onblurEvent;
    Fonresize: THTMLElementEvents2onresizeEvent;
    Fondrag: THTMLElementEvents2ondragEvent;
    Fondragend: THTMLElementEvents2ondragendEvent;
    Fondragenter: THTMLElementEvents2ondragenterEvent;
    Fondragover: THTMLElementEvents2ondragoverEvent;
    Fondragleave: THTMLElementEvents2ondragleaveEvent;
    Fondrop: THTMLElementEvents2ondropEvent;
    Fonbeforecut: THTMLElementEvents2onbeforecutEvent;
    Foncut: THTMLElementEvents2oncutEvent;
    Fonbeforecopy: THTMLElementEvents2onbeforecopyEvent;
    Foncopy: THTMLElementEvents2oncopyEvent;
    Fonbeforepaste: THTMLElementEvents2onbeforepasteEvent;
    Fonpaste: THTMLElementEvents2onpasteEvent;
    Foncontextmenu: THTMLElementEvents2oncontextmenuEvent;
    Fonrowsdelete: THTMLElementEvents2onrowsdeleteEvent;
    Fonrowsinserted: THTMLElementEvents2onrowsinsertedEvent;
    Foncellchange: THTMLElementEvents2oncellchangeEvent;
    Fonreadystatechange: THTMLElementEvents2onreadystatechangeEvent;
    Fonlayoutcomplete: THTMLElementEvents2onlayoutcompleteEvent;
    Fonpage: THTMLElementEvents2onpageEvent;
    Fonmouseenter: THTMLElementEvents2onmouseenterEvent;
    Fonmouseleave: THTMLElementEvents2onmouseleaveEvent;
    Fonactivate: THTMLElementEvents2onactivateEvent;
    Fondeactivate: THTMLElementEvents2ondeactivateEvent;
    Fonbeforedeactivate: THTMLElementEvents2onbeforedeactivateEvent;
    Fonbeforeactivate: THTMLElementEvents2onbeforeactivateEvent;
    Fonfocusin: THTMLElementEvents2onfocusinEvent;
    Fonfocusout: THTMLElementEvents2onfocusoutEvent;
    Fonmove: THTMLElementEvents2onmoveEvent;
    Foncontrolselect: THTMLElementEvents2oncontrolselectEvent;
    Fonmovestart: THTMLElementEvents2onmovestartEvent;
    Fonmoveend: THTMLElementEvents2onmoveendEvent;
    Fonresizestart: THTMLElementEvents2onresizestartEvent;
    Fonresizeend: THTMLElementEvents2onresizeendEvent;
    Fonmousewheel: THTMLElementEvents2onmousewheelEvent;
  published
    //SinkEventsPublished//
    property onhelp: THTMLElementEvents2onhelpEvent read Fonhelp write Fonhelp;
    property onclick: THTMLElementEvents2onclickEvent read Fonclick write Fonclick;
    property ondblclick: THTMLElementEvents2ondblclickEvent read Fondblclick write Fondblclick;
    property onkeypress: THTMLElementEvents2onkeypressEvent read Fonkeypress write Fonkeypress;
    property onkeydown: THTMLElementEvents2onkeydownEvent read Fonkeydown write Fonkeydown;
    property onkeyup: THTMLElementEvents2onkeyupEvent read Fonkeyup write Fonkeyup;
    property onmouseout: THTMLElementEvents2onmouseoutEvent read Fonmouseout write Fonmouseout;
    property onmouseover: THTMLElementEvents2onmouseoverEvent read Fonmouseover write Fonmouseover;
    property onmousemove: THTMLElementEvents2onmousemoveEvent read Fonmousemove write Fonmousemove;
    property onmousedown: THTMLElementEvents2onmousedownEvent read Fonmousedown write Fonmousedown;
    property onmouseup: THTMLElementEvents2onmouseupEvent read Fonmouseup write Fonmouseup;
    property onselectstart: THTMLElementEvents2onselectstartEvent read Fonselectstart write Fonselectstart;
    property onfilterchange: THTMLElementEvents2onfilterchangeEvent read Fonfilterchange write Fonfilterchange;
    property ondragstart: THTMLElementEvents2ondragstartEvent read Fondragstart write Fondragstart;
    property onbeforeupdate: THTMLElementEvents2onbeforeupdateEvent read Fonbeforeupdate write Fonbeforeupdate;
    property onafterupdate: THTMLElementEvents2onafterupdateEvent read Fonafterupdate write Fonafterupdate;
    property onerrorupdate: THTMLElementEvents2onerrorupdateEvent read Fonerrorupdate write Fonerrorupdate;
    property onrowexit: THTMLElementEvents2onrowexitEvent read Fonrowexit write Fonrowexit;
    property onrowenter: THTMLElementEvents2onrowenterEvent read Fonrowenter write Fonrowenter;
    property ondatasetchanged: THTMLElementEvents2ondatasetchangedEvent read Fondatasetchanged write Fondatasetchanged;
    property ondataavailable: THTMLElementEvents2ondataavailableEvent read Fondataavailable write Fondataavailable;
    property ondatasetcomplete: THTMLElementEvents2ondatasetcompleteEvent read Fondatasetcomplete write Fondatasetcomplete;
    property onlosecapture: THTMLElementEvents2onlosecaptureEvent read Fonlosecapture write Fonlosecapture;
    property onpropertychange: THTMLElementEvents2onpropertychangeEvent read Fonpropertychange write Fonpropertychange;
    property onscroll: THTMLElementEvents2onscrollEvent read Fonscroll write Fonscroll;
    property onfocus: THTMLElementEvents2onfocusEvent read Fonfocus write Fonfocus;
    property onblur: THTMLElementEvents2onblurEvent read Fonblur write Fonblur;
    property onresize: THTMLElementEvents2onresizeEvent read Fonresize write Fonresize;
    property ondrag: THTMLElementEvents2ondragEvent read Fondrag write Fondrag;
    property ondragend: THTMLElementEvents2ondragendEvent read Fondragend write Fondragend;
    property ondragenter: THTMLElementEvents2ondragenterEvent read Fondragenter write Fondragenter;
    property ondragover: THTMLElementEvents2ondragoverEvent read Fondragover write Fondragover;
    property ondragleave: THTMLElementEvents2ondragleaveEvent read Fondragleave write Fondragleave;
    property ondrop: THTMLElementEvents2ondropEvent read Fondrop write Fondrop;
    property onbeforecut: THTMLElementEvents2onbeforecutEvent read Fonbeforecut write Fonbeforecut;
    property oncut: THTMLElementEvents2oncutEvent read Foncut write Foncut;
    property onbeforecopy: THTMLElementEvents2onbeforecopyEvent read Fonbeforecopy write Fonbeforecopy;
    property oncopy: THTMLElementEvents2oncopyEvent read Foncopy write Foncopy;
    property onbeforepaste: THTMLElementEvents2onbeforepasteEvent read Fonbeforepaste write Fonbeforepaste;
    property onpaste: THTMLElementEvents2onpasteEvent read Fonpaste write Fonpaste;
    property oncontextmenu: THTMLElementEvents2oncontextmenuEvent read Foncontextmenu write Foncontextmenu;
    property onrowsdelete: THTMLElementEvents2onrowsdeleteEvent read Fonrowsdelete write Fonrowsdelete;
    property onrowsinserted: THTMLElementEvents2onrowsinsertedEvent read Fonrowsinserted write Fonrowsinserted;
    property oncellchange: THTMLElementEvents2oncellchangeEvent read Foncellchange write Foncellchange;
    property onreadystatechange: THTMLElementEvents2onreadystatechangeEvent read Fonreadystatechange write Fonreadystatechange;
    property onlayoutcomplete: THTMLElementEvents2onlayoutcompleteEvent read Fonlayoutcomplete write Fonlayoutcomplete;
    property onpage: THTMLElementEvents2onpageEvent read Fonpage write Fonpage;
    property onmouseenter: THTMLElementEvents2onmouseenterEvent read Fonmouseenter write Fonmouseenter;
    property onmouseleave: THTMLElementEvents2onmouseleaveEvent read Fonmouseleave write Fonmouseleave;
    property onactivate: THTMLElementEvents2onactivateEvent read Fonactivate write Fonactivate;
    property ondeactivate: THTMLElementEvents2ondeactivateEvent read Fondeactivate write Fondeactivate;
    property onbeforedeactivate: THTMLElementEvents2onbeforedeactivateEvent read Fonbeforedeactivate write Fonbeforedeactivate;
    property onbeforeactivate: THTMLElementEvents2onbeforeactivateEvent read Fonbeforeactivate write Fonbeforeactivate;
    property onfocusin: THTMLElementEvents2onfocusinEvent read Fonfocusin write Fonfocusin;
    property onfocusout: THTMLElementEvents2onfocusoutEvent read Fonfocusout write Fonfocusout;
    property onmove: THTMLElementEvents2onmoveEvent read Fonmove write Fonmove;
    property oncontrolselect: THTMLElementEvents2oncontrolselectEvent read Foncontrolselect write Foncontrolselect;
    property onmovestart: THTMLElementEvents2onmovestartEvent read Fonmovestart write Fonmovestart;
    property onmoveend: THTMLElementEvents2onmoveendEvent read Fonmoveend write Fonmoveend;
    property onresizestart: THTMLElementEvents2onresizestartEvent read Fonresizestart write Fonresizestart;
    property onresizeend: THTMLElementEvents2onresizeendEvent read Fonresizeend write Fonresizeend;
    property onmousewheel: THTMLElementEvents2onmousewheelEvent read Fonmousewheel write Fonmousewheel;
  end;


  //SinkEventsForwards//
  THTMLButtonElementEvents2onhelpEvent = function (Sender: TObject; const pEvtObj: IHTMLEventObj): WordBool of object;
  THTMLButtonElementEvents2onclickEvent = function (Sender: TObject; const pEvtObj: IHTMLEventObj): WordBool of object;
  THTMLButtonElementEvents2ondblclickEvent = function (Sender: TObject; const pEvtObj: IHTMLEventObj): WordBool of object;
  THTMLButtonElementEvents2onkeypressEvent = function (Sender: TObject; const pEvtObj: IHTMLEventObj): WordBool of object;
  THTMLButtonElementEvents2onkeydownEvent = procedure (Sender: TObject; const pEvtObj: IHTMLEventObj) of object;
  THTMLButtonElementEvents2onkeyupEvent = procedure (Sender: TObject; const pEvtObj: IHTMLEventObj) of object;
  THTMLButtonElementEvents2onmouseoutEvent = procedure (Sender: TObject; const pEvtObj: IHTMLEventObj) of object;
  THTMLButtonElementEvents2onmouseoverEvent = procedure (Sender: TObject; const pEvtObj: IHTMLEventObj) of object;
  THTMLButtonElementEvents2onmousemoveEvent = procedure (Sender: TObject; const pEvtObj: IHTMLEventObj) of object;
  THTMLButtonElementEvents2onmousedownEvent = procedure (Sender: TObject; const pEvtObj: IHTMLEventObj) of object;
  THTMLButtonElementEvents2onmouseupEvent = procedure (Sender: TObject; const pEvtObj: IHTMLEventObj) of object;
  THTMLButtonElementEvents2onselectstartEvent = function (Sender: TObject; const pEvtObj: IHTMLEventObj): WordBool of object;
  THTMLButtonElementEvents2onfilterchangeEvent = procedure (Sender: TObject; const pEvtObj: IHTMLEventObj) of object;
  THTMLButtonElementEvents2ondragstartEvent = function (Sender: TObject; const pEvtObj: IHTMLEventObj): WordBool of object;
  THTMLButtonElementEvents2onbeforeupdateEvent = function (Sender: TObject; const pEvtObj: IHTMLEventObj): WordBool of object;
  THTMLButtonElementEvents2onafterupdateEvent = procedure (Sender: TObject; const pEvtObj: IHTMLEventObj) of object;
  THTMLButtonElementEvents2onerrorupdateEvent = function (Sender: TObject; const pEvtObj: IHTMLEventObj): WordBool of object;
  THTMLButtonElementEvents2onrowexitEvent = function (Sender: TObject; const pEvtObj: IHTMLEventObj): WordBool of object;
  THTMLButtonElementEvents2onrowenterEvent = procedure (Sender: TObject; const pEvtObj: IHTMLEventObj) of object;
  THTMLButtonElementEvents2ondatasetchangedEvent = procedure (Sender: TObject; const pEvtObj: IHTMLEventObj) of object;
  THTMLButtonElementEvents2ondataavailableEvent = procedure (Sender: TObject; const pEvtObj: IHTMLEventObj) of object;
  THTMLButtonElementEvents2ondatasetcompleteEvent = procedure (Sender: TObject; const pEvtObj: IHTMLEventObj) of object;
  THTMLButtonElementEvents2onlosecaptureEvent = procedure (Sender: TObject; const pEvtObj: IHTMLEventObj) of object;
  THTMLButtonElementEvents2onpropertychangeEvent = procedure (Sender: TObject; const pEvtObj: IHTMLEventObj) of object;
  THTMLButtonElementEvents2onscrollEvent = procedure (Sender: TObject; const pEvtObj: IHTMLEventObj) of object;
  THTMLButtonElementEvents2onfocusEvent = procedure (Sender: TObject; const pEvtObj: IHTMLEventObj) of object;
  THTMLButtonElementEvents2onblurEvent = procedure (Sender: TObject; const pEvtObj: IHTMLEventObj) of object;
  THTMLButtonElementEvents2onresizeEvent = procedure (Sender: TObject; const pEvtObj: IHTMLEventObj) of object;
  THTMLButtonElementEvents2ondragEvent = function (Sender: TObject; const pEvtObj: IHTMLEventObj): WordBool of object;
  THTMLButtonElementEvents2ondragendEvent = procedure (Sender: TObject; const pEvtObj: IHTMLEventObj) of object;
  THTMLButtonElementEvents2ondragenterEvent = function (Sender: TObject; const pEvtObj: IHTMLEventObj): WordBool of object;
  THTMLButtonElementEvents2ondragoverEvent = function (Sender: TObject; const pEvtObj: IHTMLEventObj): WordBool of object;
  THTMLButtonElementEvents2ondragleaveEvent = procedure (Sender: TObject; const pEvtObj: IHTMLEventObj) of object;
  THTMLButtonElementEvents2ondropEvent = function (Sender: TObject; const pEvtObj: IHTMLEventObj): WordBool of object;
  THTMLButtonElementEvents2onbeforecutEvent = function (Sender: TObject; const pEvtObj: IHTMLEventObj): WordBool of object;
  THTMLButtonElementEvents2oncutEvent = function (Sender: TObject; const pEvtObj: IHTMLEventObj): WordBool of object;
  THTMLButtonElementEvents2onbeforecopyEvent = function (Sender: TObject; const pEvtObj: IHTMLEventObj): WordBool of object;
  THTMLButtonElementEvents2oncopyEvent = function (Sender: TObject; const pEvtObj: IHTMLEventObj): WordBool of object;
  THTMLButtonElementEvents2onbeforepasteEvent = function (Sender: TObject; const pEvtObj: IHTMLEventObj): WordBool of object;
  THTMLButtonElementEvents2onpasteEvent = function (Sender: TObject; const pEvtObj: IHTMLEventObj): WordBool of object;
  THTMLButtonElementEvents2oncontextmenuEvent = function (Sender: TObject; const pEvtObj: IHTMLEventObj): WordBool of object;
  THTMLButtonElementEvents2onrowsdeleteEvent = procedure (Sender: TObject; const pEvtObj: IHTMLEventObj) of object;
  THTMLButtonElementEvents2onrowsinsertedEvent = procedure (Sender: TObject; const pEvtObj: IHTMLEventObj) of object;
  THTMLButtonElementEvents2oncellchangeEvent = procedure (Sender: TObject; const pEvtObj: IHTMLEventObj) of object;
  THTMLButtonElementEvents2onreadystatechangeEvent = procedure (Sender: TObject; const pEvtObj: IHTMLEventObj) of object;
  THTMLButtonElementEvents2onlayoutcompleteEvent = procedure (Sender: TObject; const pEvtObj: IHTMLEventObj) of object;
  THTMLButtonElementEvents2onpageEvent = procedure (Sender: TObject; const pEvtObj: IHTMLEventObj) of object;
  THTMLButtonElementEvents2onmouseenterEvent = procedure (Sender: TObject; const pEvtObj: IHTMLEventObj) of object;
  THTMLButtonElementEvents2onmouseleaveEvent = procedure (Sender: TObject; const pEvtObj: IHTMLEventObj) of object;
  THTMLButtonElementEvents2onactivateEvent = procedure (Sender: TObject; const pEvtObj: IHTMLEventObj) of object;
  THTMLButtonElementEvents2ondeactivateEvent = procedure (Sender: TObject; const pEvtObj: IHTMLEventObj) of object;
  THTMLButtonElementEvents2onbeforedeactivateEvent = function (Sender: TObject; const pEvtObj: IHTMLEventObj): WordBool of object;
  THTMLButtonElementEvents2onbeforeactivateEvent = function (Sender: TObject; const pEvtObj: IHTMLEventObj): WordBool of object;
  THTMLButtonElementEvents2onfocusinEvent = procedure (Sender: TObject; const pEvtObj: IHTMLEventObj) of object;
  THTMLButtonElementEvents2onfocusoutEvent = procedure (Sender: TObject; const pEvtObj: IHTMLEventObj) of object;
  THTMLButtonElementEvents2onmoveEvent = procedure (Sender: TObject; const pEvtObj: IHTMLEventObj) of object;
  THTMLButtonElementEvents2oncontrolselectEvent = function (Sender: TObject; const pEvtObj: IHTMLEventObj): WordBool of object;
  THTMLButtonElementEvents2onmovestartEvent = function (Sender: TObject; const pEvtObj: IHTMLEventObj): WordBool of object;
  THTMLButtonElementEvents2onmoveendEvent = procedure (Sender: TObject; const pEvtObj: IHTMLEventObj) of object;
  THTMLButtonElementEvents2onresizestartEvent = function (Sender: TObject; const pEvtObj: IHTMLEventObj): WordBool of object;
  THTMLButtonElementEvents2onresizeendEvent = procedure (Sender: TObject; const pEvtObj: IHTMLEventObj) of object;
  THTMLButtonElementEvents2onmousewheelEvent = function (Sender: TObject; const pEvtObj: IHTMLEventObj): WordBool of object;

  //SinkComponent//
  TMSHTMLHTMLButtonElementEvents2 = class (TMSHTMLEventsBaseSink
    //ISinkInterface//
  )
  protected
    function DoInvoke (DispID: Integer; const IID: TGUID; LocaleID: Integer;
      Flags: Word; var dps: TDispParams; pDispIds: PDispIdList;
      VarResult, ExcepInfo, ArgErr: Pointer): HResult; override;

    //ISinkInterfaceMethods//
  public
    { system methods }
    constructor Create (AOwner: TComponent); override;
  protected
    //SinkInterface//
    function Doonhelp(const pEvtObj: IHTMLEventObj): WordBool; safecall;
    function Doonclick(const pEvtObj: IHTMLEventObj): WordBool; safecall;
    function Doondblclick(const pEvtObj: IHTMLEventObj): WordBool; safecall;
    function Doonkeypress(const pEvtObj: IHTMLEventObj): WordBool; safecall;
    procedure Doonkeydown(const pEvtObj: IHTMLEventObj); safecall;
    procedure Doonkeyup(const pEvtObj: IHTMLEventObj); safecall;
    procedure Doonmouseout(const pEvtObj: IHTMLEventObj); safecall;
    procedure Doonmouseover(const pEvtObj: IHTMLEventObj); safecall;
    procedure Doonmousemove(const pEvtObj: IHTMLEventObj); safecall;
    procedure Doonmousedown(const pEvtObj: IHTMLEventObj); safecall;
    procedure Doonmouseup(const pEvtObj: IHTMLEventObj); safecall;
    function Doonselectstart(const pEvtObj: IHTMLEventObj): WordBool; safecall;
    procedure Doonfilterchange(const pEvtObj: IHTMLEventObj); safecall;
    function Doondragstart(const pEvtObj: IHTMLEventObj): WordBool; safecall;
    function Doonbeforeupdate(const pEvtObj: IHTMLEventObj): WordBool; safecall;
    procedure Doonafterupdate(const pEvtObj: IHTMLEventObj); safecall;
    function Doonerrorupdate(const pEvtObj: IHTMLEventObj): WordBool; safecall;
    function Doonrowexit(const pEvtObj: IHTMLEventObj): WordBool; safecall;
    procedure Doonrowenter(const pEvtObj: IHTMLEventObj); safecall;
    procedure Doondatasetchanged(const pEvtObj: IHTMLEventObj); safecall;
    procedure Doondataavailable(const pEvtObj: IHTMLEventObj); safecall;
    procedure Doondatasetcomplete(const pEvtObj: IHTMLEventObj); safecall;
    procedure Doonlosecapture(const pEvtObj: IHTMLEventObj); safecall;
    procedure Doonpropertychange(const pEvtObj: IHTMLEventObj); safecall;
    procedure Doonscroll(const pEvtObj: IHTMLEventObj); safecall;
    procedure Doonfocus(const pEvtObj: IHTMLEventObj); safecall;
    procedure Doonblur(const pEvtObj: IHTMLEventObj); safecall;
    procedure Doonresize(const pEvtObj: IHTMLEventObj); safecall;
    function Doondrag(const pEvtObj: IHTMLEventObj): WordBool; safecall;
    procedure Doondragend(const pEvtObj: IHTMLEventObj); safecall;
    function Doondragenter(const pEvtObj: IHTMLEventObj): WordBool; safecall;
    function Doondragover(const pEvtObj: IHTMLEventObj): WordBool; safecall;
    procedure Doondragleave(const pEvtObj: IHTMLEventObj); safecall;
    function Doondrop(const pEvtObj: IHTMLEventObj): WordBool; safecall;
    function Doonbeforecut(const pEvtObj: IHTMLEventObj): WordBool; safecall;
    function Dooncut(const pEvtObj: IHTMLEventObj): WordBool; safecall;
    function Doonbeforecopy(const pEvtObj: IHTMLEventObj): WordBool; safecall;
    function Dooncopy(const pEvtObj: IHTMLEventObj): WordBool; safecall;
    function Doonbeforepaste(const pEvtObj: IHTMLEventObj): WordBool; safecall;
    function Doonpaste(const pEvtObj: IHTMLEventObj): WordBool; safecall;
    function Dooncontextmenu(const pEvtObj: IHTMLEventObj): WordBool; safecall;
    procedure Doonrowsdelete(const pEvtObj: IHTMLEventObj); safecall;
    procedure Doonrowsinserted(const pEvtObj: IHTMLEventObj); safecall;
    procedure Dooncellchange(const pEvtObj: IHTMLEventObj); safecall;
    procedure Doonreadystatechange(const pEvtObj: IHTMLEventObj); safecall;
    procedure Doonlayoutcomplete(const pEvtObj: IHTMLEventObj); safecall;
    procedure Doonpage(const pEvtObj: IHTMLEventObj); safecall;
    procedure Doonmouseenter(const pEvtObj: IHTMLEventObj); safecall;
    procedure Doonmouseleave(const pEvtObj: IHTMLEventObj); safecall;
    procedure Doonactivate(const pEvtObj: IHTMLEventObj); safecall;
    procedure Doondeactivate(const pEvtObj: IHTMLEventObj); safecall;
    function Doonbeforedeactivate(const pEvtObj: IHTMLEventObj): WordBool; safecall;
    function Doonbeforeactivate(const pEvtObj: IHTMLEventObj): WordBool; safecall;
    procedure Doonfocusin(const pEvtObj: IHTMLEventObj); safecall;
    procedure Doonfocusout(const pEvtObj: IHTMLEventObj); safecall;
    procedure Doonmove(const pEvtObj: IHTMLEventObj); safecall;
    function Dooncontrolselect(const pEvtObj: IHTMLEventObj): WordBool; safecall;
    function Doonmovestart(const pEvtObj: IHTMLEventObj): WordBool; safecall;
    procedure Doonmoveend(const pEvtObj: IHTMLEventObj); safecall;
    function Doonresizestart(const pEvtObj: IHTMLEventObj): WordBool; safecall;
    procedure Doonresizeend(const pEvtObj: IHTMLEventObj); safecall;
    function Doonmousewheel(const pEvtObj: IHTMLEventObj): WordBool; safecall;
  protected
    //SinkEventsProtected//
    Fonhelp: THTMLButtonElementEvents2onhelpEvent;
    Fonclick: THTMLButtonElementEvents2onclickEvent;
    Fondblclick: THTMLButtonElementEvents2ondblclickEvent;
    Fonkeypress: THTMLButtonElementEvents2onkeypressEvent;
    Fonkeydown: THTMLButtonElementEvents2onkeydownEvent;
    Fonkeyup: THTMLButtonElementEvents2onkeyupEvent;
    Fonmouseout: THTMLButtonElementEvents2onmouseoutEvent;
    Fonmouseover: THTMLButtonElementEvents2onmouseoverEvent;
    Fonmousemove: THTMLButtonElementEvents2onmousemoveEvent;
    Fonmousedown: THTMLButtonElementEvents2onmousedownEvent;
    Fonmouseup: THTMLButtonElementEvents2onmouseupEvent;
    Fonselectstart: THTMLButtonElementEvents2onselectstartEvent;
    Fonfilterchange: THTMLButtonElementEvents2onfilterchangeEvent;
    Fondragstart: THTMLButtonElementEvents2ondragstartEvent;
    Fonbeforeupdate: THTMLButtonElementEvents2onbeforeupdateEvent;
    Fonafterupdate: THTMLButtonElementEvents2onafterupdateEvent;
    Fonerrorupdate: THTMLButtonElementEvents2onerrorupdateEvent;
    Fonrowexit: THTMLButtonElementEvents2onrowexitEvent;
    Fonrowenter: THTMLButtonElementEvents2onrowenterEvent;
    Fondatasetchanged: THTMLButtonElementEvents2ondatasetchangedEvent;
    Fondataavailable: THTMLButtonElementEvents2ondataavailableEvent;
    Fondatasetcomplete: THTMLButtonElementEvents2ondatasetcompleteEvent;
    Fonlosecapture: THTMLButtonElementEvents2onlosecaptureEvent;
    Fonpropertychange: THTMLButtonElementEvents2onpropertychangeEvent;
    Fonscroll: THTMLButtonElementEvents2onscrollEvent;
    Fonfocus: THTMLButtonElementEvents2onfocusEvent;
    Fonblur: THTMLButtonElementEvents2onblurEvent;
    Fonresize: THTMLButtonElementEvents2onresizeEvent;
    Fondrag: THTMLButtonElementEvents2ondragEvent;
    Fondragend: THTMLButtonElementEvents2ondragendEvent;
    Fondragenter: THTMLButtonElementEvents2ondragenterEvent;
    Fondragover: THTMLButtonElementEvents2ondragoverEvent;
    Fondragleave: THTMLButtonElementEvents2ondragleaveEvent;
    Fondrop: THTMLButtonElementEvents2ondropEvent;
    Fonbeforecut: THTMLButtonElementEvents2onbeforecutEvent;
    Foncut: THTMLButtonElementEvents2oncutEvent;
    Fonbeforecopy: THTMLButtonElementEvents2onbeforecopyEvent;
    Foncopy: THTMLButtonElementEvents2oncopyEvent;
    Fonbeforepaste: THTMLButtonElementEvents2onbeforepasteEvent;
    Fonpaste: THTMLButtonElementEvents2onpasteEvent;
    Foncontextmenu: THTMLButtonElementEvents2oncontextmenuEvent;
    Fonrowsdelete: THTMLButtonElementEvents2onrowsdeleteEvent;
    Fonrowsinserted: THTMLButtonElementEvents2onrowsinsertedEvent;
    Foncellchange: THTMLButtonElementEvents2oncellchangeEvent;
    Fonreadystatechange: THTMLButtonElementEvents2onreadystatechangeEvent;
    Fonlayoutcomplete: THTMLButtonElementEvents2onlayoutcompleteEvent;
    Fonpage: THTMLButtonElementEvents2onpageEvent;
    Fonmouseenter: THTMLButtonElementEvents2onmouseenterEvent;
    Fonmouseleave: THTMLButtonElementEvents2onmouseleaveEvent;
    Fonactivate: THTMLButtonElementEvents2onactivateEvent;
    Fondeactivate: THTMLButtonElementEvents2ondeactivateEvent;
    Fonbeforedeactivate: THTMLButtonElementEvents2onbeforedeactivateEvent;
    Fonbeforeactivate: THTMLButtonElementEvents2onbeforeactivateEvent;
    Fonfocusin: THTMLButtonElementEvents2onfocusinEvent;
    Fonfocusout: THTMLButtonElementEvents2onfocusoutEvent;
    Fonmove: THTMLButtonElementEvents2onmoveEvent;
    Foncontrolselect: THTMLButtonElementEvents2oncontrolselectEvent;
    Fonmovestart: THTMLButtonElementEvents2onmovestartEvent;
    Fonmoveend: THTMLButtonElementEvents2onmoveendEvent;
    Fonresizestart: THTMLButtonElementEvents2onresizestartEvent;
    Fonresizeend: THTMLButtonElementEvents2onresizeendEvent;
    Fonmousewheel: THTMLButtonElementEvents2onmousewheelEvent;
  published
    //SinkEventsPublished//
    property onhelp: THTMLButtonElementEvents2onhelpEvent read Fonhelp write Fonhelp;
    property onclick: THTMLButtonElementEvents2onclickEvent read Fonclick write Fonclick;
    property ondblclick: THTMLButtonElementEvents2ondblclickEvent read Fondblclick write Fondblclick;
    property onkeypress: THTMLButtonElementEvents2onkeypressEvent read Fonkeypress write Fonkeypress;
    property onkeydown: THTMLButtonElementEvents2onkeydownEvent read Fonkeydown write Fonkeydown;
    property onkeyup: THTMLButtonElementEvents2onkeyupEvent read Fonkeyup write Fonkeyup;
    property onmouseout: THTMLButtonElementEvents2onmouseoutEvent read Fonmouseout write Fonmouseout;
    property onmouseover: THTMLButtonElementEvents2onmouseoverEvent read Fonmouseover write Fonmouseover;
    property onmousemove: THTMLButtonElementEvents2onmousemoveEvent read Fonmousemove write Fonmousemove;
    property onmousedown: THTMLButtonElementEvents2onmousedownEvent read Fonmousedown write Fonmousedown;
    property onmouseup: THTMLButtonElementEvents2onmouseupEvent read Fonmouseup write Fonmouseup;
    property onselectstart: THTMLButtonElementEvents2onselectstartEvent read Fonselectstart write Fonselectstart;
    property onfilterchange: THTMLButtonElementEvents2onfilterchangeEvent read Fonfilterchange write Fonfilterchange;
    property ondragstart: THTMLButtonElementEvents2ondragstartEvent read Fondragstart write Fondragstart;
    property onbeforeupdate: THTMLButtonElementEvents2onbeforeupdateEvent read Fonbeforeupdate write Fonbeforeupdate;
    property onafterupdate: THTMLButtonElementEvents2onafterupdateEvent read Fonafterupdate write Fonafterupdate;
    property onerrorupdate: THTMLButtonElementEvents2onerrorupdateEvent read Fonerrorupdate write Fonerrorupdate;
    property onrowexit: THTMLButtonElementEvents2onrowexitEvent read Fonrowexit write Fonrowexit;
    property onrowenter: THTMLButtonElementEvents2onrowenterEvent read Fonrowenter write Fonrowenter;
    property ondatasetchanged: THTMLButtonElementEvents2ondatasetchangedEvent read Fondatasetchanged write Fondatasetchanged;
    property ondataavailable: THTMLButtonElementEvents2ondataavailableEvent read Fondataavailable write Fondataavailable;
    property ondatasetcomplete: THTMLButtonElementEvents2ondatasetcompleteEvent read Fondatasetcomplete write Fondatasetcomplete;
    property onlosecapture: THTMLButtonElementEvents2onlosecaptureEvent read Fonlosecapture write Fonlosecapture;
    property onpropertychange: THTMLButtonElementEvents2onpropertychangeEvent read Fonpropertychange write Fonpropertychange;
    property onscroll: THTMLButtonElementEvents2onscrollEvent read Fonscroll write Fonscroll;
    property onfocus: THTMLButtonElementEvents2onfocusEvent read Fonfocus write Fonfocus;
    property onblur: THTMLButtonElementEvents2onblurEvent read Fonblur write Fonblur;
    property onresize: THTMLButtonElementEvents2onresizeEvent read Fonresize write Fonresize;
    property ondrag: THTMLButtonElementEvents2ondragEvent read Fondrag write Fondrag;
    property ondragend: THTMLButtonElementEvents2ondragendEvent read Fondragend write Fondragend;
    property ondragenter: THTMLButtonElementEvents2ondragenterEvent read Fondragenter write Fondragenter;
    property ondragover: THTMLButtonElementEvents2ondragoverEvent read Fondragover write Fondragover;
    property ondragleave: THTMLButtonElementEvents2ondragleaveEvent read Fondragleave write Fondragleave;
    property ondrop: THTMLButtonElementEvents2ondropEvent read Fondrop write Fondrop;
    property onbeforecut: THTMLButtonElementEvents2onbeforecutEvent read Fonbeforecut write Fonbeforecut;
    property oncut: THTMLButtonElementEvents2oncutEvent read Foncut write Foncut;
    property onbeforecopy: THTMLButtonElementEvents2onbeforecopyEvent read Fonbeforecopy write Fonbeforecopy;
    property oncopy: THTMLButtonElementEvents2oncopyEvent read Foncopy write Foncopy;
    property onbeforepaste: THTMLButtonElementEvents2onbeforepasteEvent read Fonbeforepaste write Fonbeforepaste;
    property onpaste: THTMLButtonElementEvents2onpasteEvent read Fonpaste write Fonpaste;
    property oncontextmenu: THTMLButtonElementEvents2oncontextmenuEvent read Foncontextmenu write Foncontextmenu;
    property onrowsdelete: THTMLButtonElementEvents2onrowsdeleteEvent read Fonrowsdelete write Fonrowsdelete;
    property onrowsinserted: THTMLButtonElementEvents2onrowsinsertedEvent read Fonrowsinserted write Fonrowsinserted;
    property oncellchange: THTMLButtonElementEvents2oncellchangeEvent read Foncellchange write Foncellchange;
    property onreadystatechange: THTMLButtonElementEvents2onreadystatechangeEvent read Fonreadystatechange write Fonreadystatechange;
    property onlayoutcomplete: THTMLButtonElementEvents2onlayoutcompleteEvent read Fonlayoutcomplete write Fonlayoutcomplete;
    property onpage: THTMLButtonElementEvents2onpageEvent read Fonpage write Fonpage;
    property onmouseenter: THTMLButtonElementEvents2onmouseenterEvent read Fonmouseenter write Fonmouseenter;
    property onmouseleave: THTMLButtonElementEvents2onmouseleaveEvent read Fonmouseleave write Fonmouseleave;
    property onactivate: THTMLButtonElementEvents2onactivateEvent read Fonactivate write Fonactivate;
    property ondeactivate: THTMLButtonElementEvents2ondeactivateEvent read Fondeactivate write Fondeactivate;
    property onbeforedeactivate: THTMLButtonElementEvents2onbeforedeactivateEvent read Fonbeforedeactivate write Fonbeforedeactivate;
    property onbeforeactivate: THTMLButtonElementEvents2onbeforeactivateEvent read Fonbeforeactivate write Fonbeforeactivate;
    property onfocusin: THTMLButtonElementEvents2onfocusinEvent read Fonfocusin write Fonfocusin;
    property onfocusout: THTMLButtonElementEvents2onfocusoutEvent read Fonfocusout write Fonfocusout;
    property onmove: THTMLButtonElementEvents2onmoveEvent read Fonmove write Fonmove;
    property oncontrolselect: THTMLButtonElementEvents2oncontrolselectEvent read Foncontrolselect write Foncontrolselect;
    property onmovestart: THTMLButtonElementEvents2onmovestartEvent read Fonmovestart write Fonmovestart;
    property onmoveend: THTMLButtonElementEvents2onmoveendEvent read Fonmoveend write Fonmoveend;
    property onresizestart: THTMLButtonElementEvents2onresizestartEvent read Fonresizestart write Fonresizestart;
    property onresizeend: THTMLButtonElementEvents2onresizeendEvent read Fonresizeend write Fonresizeend;
    property onmousewheel: THTMLButtonElementEvents2onmousewheelEvent read Fonmousewheel write Fonmousewheel;
  end;


  //SinkEventsForwards//
  THTMLWindowEventsonloadEvent = procedure (Sender: TObject) of object;
  THTMLWindowEventsonunloadEvent = procedure (Sender: TObject) of object;
  THTMLWindowEventsonhelpEvent = function (Sender: TObject): WordBool of object;
  THTMLWindowEventsonfocusEvent = procedure (Sender: TObject) of object;
  THTMLWindowEventsonblurEvent = procedure (Sender: TObject) of object;
  THTMLWindowEventsonerrorEvent = procedure (Sender: TObject; const description: WideString; const url: WideString; line: Integer) of object;
  THTMLWindowEventsonresizeEvent = procedure (Sender: TObject) of object;
  THTMLWindowEventsonscrollEvent = procedure (Sender: TObject) of object;
  THTMLWindowEventsonbeforeunloadEvent = procedure (Sender: TObject) of object;
  THTMLWindowEventsonbeforeprintEvent = procedure (Sender: TObject) of object;
  THTMLWindowEventsonafterprintEvent = procedure (Sender: TObject) of object;

  //SinkComponent//
  TMSHTMLHTMLWindowEvents = class (TMSHTMLEventsBaseSink
    //ISinkInterface//
  )
  protected
    function DoInvoke (DispID: Integer; const IID: TGUID; LocaleID: Integer;
      Flags: Word; var dps: TDispParams; pDispIds: PDispIdList;
      VarResult, ExcepInfo, ArgErr: Pointer): HResult; override;

    //ISinkInterfaceMethods//
  public
    { system methods }
    constructor Create (AOwner: TComponent); override;
  protected
    //SinkInterface//
    procedure Doonload; safecall;
    procedure Doonunload; safecall;
    function Doonhelp: WordBool; safecall;
    procedure Doonfocus; safecall;
    procedure Doonblur; safecall;
    procedure Doonerror(const description: WideString; const url: WideString; line: Integer); safecall;
    procedure Doonresize; safecall;
    procedure Doonscroll; safecall;
    procedure Doonbeforeunload; safecall;
    procedure Doonbeforeprint; safecall;
    procedure Doonafterprint; safecall;
  protected
    //SinkEventsProtected//
    Fonload: THTMLWindowEventsonloadEvent;
    Fonunload: THTMLWindowEventsonunloadEvent;
    Fonhelp: THTMLWindowEventsonhelpEvent;
    Fonfocus: THTMLWindowEventsonfocusEvent;
    Fonblur: THTMLWindowEventsonblurEvent;
    Fonerror: THTMLWindowEventsonerrorEvent;
    Fonresize: THTMLWindowEventsonresizeEvent;
    Fonscroll: THTMLWindowEventsonscrollEvent;
    Fonbeforeunload: THTMLWindowEventsonbeforeunloadEvent;
    Fonbeforeprint: THTMLWindowEventsonbeforeprintEvent;
    Fonafterprint: THTMLWindowEventsonafterprintEvent;
  published
    //SinkEventsPublished//
    property onload: THTMLWindowEventsonloadEvent read Fonload write Fonload;
    property onunload: THTMLWindowEventsonunloadEvent read Fonunload write Fonunload;
    property onhelp: THTMLWindowEventsonhelpEvent read Fonhelp write Fonhelp;
    property onfocus: THTMLWindowEventsonfocusEvent read Fonfocus write Fonfocus;
    property onblur: THTMLWindowEventsonblurEvent read Fonblur write Fonblur;
    property onerror: THTMLWindowEventsonerrorEvent read Fonerror write Fonerror;
    property onresize: THTMLWindowEventsonresizeEvent read Fonresize write Fonresize;
    property onscroll: THTMLWindowEventsonscrollEvent read Fonscroll write Fonscroll;
    property onbeforeunload: THTMLWindowEventsonbeforeunloadEvent read Fonbeforeunload write Fonbeforeunload;
    property onbeforeprint: THTMLWindowEventsonbeforeprintEvent read Fonbeforeprint write Fonbeforeprint;
    property onafterprint: THTMLWindowEventsonafterprintEvent read Fonafterprint write Fonafterprint;
  end;


  //SinkEventsForwards//
  THTMLWindowEvents2onloadEvent = procedure (Sender: TObject; const pEvtObj: IHTMLEventObj) of object;
  THTMLWindowEvents2onunloadEvent = procedure (Sender: TObject; const pEvtObj: IHTMLEventObj) of object;
  THTMLWindowEvents2onhelpEvent = function (Sender: TObject; const pEvtObj: IHTMLEventObj): WordBool of object;
  THTMLWindowEvents2onfocusEvent = procedure (Sender: TObject; const pEvtObj: IHTMLEventObj) of object;
  THTMLWindowEvents2onblurEvent = procedure (Sender: TObject; const pEvtObj: IHTMLEventObj) of object;
  THTMLWindowEvents2onerrorEvent = procedure (Sender: TObject; const description: WideString; const url: WideString; line: Integer) of object;
  THTMLWindowEvents2onresizeEvent = procedure (Sender: TObject; const pEvtObj: IHTMLEventObj) of object;
  THTMLWindowEvents2onscrollEvent = procedure (Sender: TObject; const pEvtObj: IHTMLEventObj) of object;
  THTMLWindowEvents2onbeforeunloadEvent = procedure (Sender: TObject; const pEvtObj: IHTMLEventObj) of object;
  THTMLWindowEvents2onbeforeprintEvent = procedure (Sender: TObject; const pEvtObj: IHTMLEventObj) of object;
  THTMLWindowEvents2onafterprintEvent = procedure (Sender: TObject; const pEvtObj: IHTMLEventObj) of object;

  //SinkComponent//
  TMSHTMLHTMLWindowEvents2 = class (TMSHTMLEventsBaseSink
    //ISinkInterface//
  )
  protected
    function DoInvoke (DispID: Integer; const IID: TGUID; LocaleID: Integer;
      Flags: Word; var dps: TDispParams; pDispIds: PDispIdList;
      VarResult, ExcepInfo, ArgErr: Pointer): HResult; override;

    //ISinkInterfaceMethods//
  public
    { system methods }
    constructor Create (AOwner: TComponent); override;
  protected
    //SinkInterface//
    procedure Doonload(const pEvtObj: IHTMLEventObj); safecall;
    procedure Doonunload(const pEvtObj: IHTMLEventObj); safecall;
    function Doonhelp(const pEvtObj: IHTMLEventObj): WordBool; safecall;
    procedure Doonfocus(const pEvtObj: IHTMLEventObj); safecall;
    procedure Doonblur(const pEvtObj: IHTMLEventObj); safecall;
    procedure Doonerror(const description: WideString; const url: WideString; line: Integer); safecall;
    procedure Doonresize(const pEvtObj: IHTMLEventObj); safecall;
    procedure Doonscroll(const pEvtObj: IHTMLEventObj); safecall;
    procedure Doonbeforeunload(const pEvtObj: IHTMLEventObj); safecall;
    procedure Doonbeforeprint(const pEvtObj: IHTMLEventObj); safecall;
    procedure Doonafterprint(const pEvtObj: IHTMLEventObj); safecall;
  protected
    //SinkEventsProtected//
    Fonload: THTMLWindowEvents2onloadEvent;
    Fonunload: THTMLWindowEvents2onunloadEvent;
    Fonhelp: THTMLWindowEvents2onhelpEvent;
    Fonfocus: THTMLWindowEvents2onfocusEvent;
    Fonblur: THTMLWindowEvents2onblurEvent;
    Fonerror: THTMLWindowEvents2onerrorEvent;
    Fonresize: THTMLWindowEvents2onresizeEvent;
    Fonscroll: THTMLWindowEvents2onscrollEvent;
    Fonbeforeunload: THTMLWindowEvents2onbeforeunloadEvent;
    Fonbeforeprint: THTMLWindowEvents2onbeforeprintEvent;
    Fonafterprint: THTMLWindowEvents2onafterprintEvent;
  published
    //SinkEventsPublished//
    property onload: THTMLWindowEvents2onloadEvent read Fonload write Fonload;
    property onunload: THTMLWindowEvents2onunloadEvent read Fonunload write Fonunload;
    property onhelp: THTMLWindowEvents2onhelpEvent read Fonhelp write Fonhelp;
    property onfocus: THTMLWindowEvents2onfocusEvent read Fonfocus write Fonfocus;
    property onblur: THTMLWindowEvents2onblurEvent read Fonblur write Fonblur;
    property onerror: THTMLWindowEvents2onerrorEvent read Fonerror write Fonerror;
    property onresize: THTMLWindowEvents2onresizeEvent read Fonresize write Fonresize;
    property onscroll: THTMLWindowEvents2onscrollEvent read Fonscroll write Fonscroll;
    property onbeforeunload: THTMLWindowEvents2onbeforeunloadEvent read Fonbeforeunload write Fonbeforeunload;
    property onbeforeprint: THTMLWindowEvents2onbeforeprintEvent read Fonbeforeprint write Fonbeforeprint;
    property onafterprint: THTMLWindowEvents2onafterprintEvent read Fonafterprint write Fonafterprint;
  end;


  //SinkEventsForwards//
  THTMLDocumentEventsonhelpEvent = function (Sender: TObject): WordBool of object;
  THTMLDocumentEventsonclickEvent = function (Sender: TObject): WordBool of object;
  THTMLDocumentEventsondblclickEvent = function (Sender: TObject): WordBool of object;
  THTMLDocumentEventsonkeydownEvent = procedure (Sender: TObject) of object;
  THTMLDocumentEventsonkeyupEvent = procedure (Sender: TObject) of object;
  THTMLDocumentEventsonkeypressEvent = function (Sender: TObject): WordBool of object;
  THTMLDocumentEventsonmousedownEvent = procedure (Sender: TObject) of object;
  THTMLDocumentEventsonmousemoveEvent = procedure (Sender: TObject) of object;
  THTMLDocumentEventsonmouseupEvent = procedure (Sender: TObject) of object;
  THTMLDocumentEventsonmouseoutEvent = procedure (Sender: TObject) of object;
  THTMLDocumentEventsonmouseoverEvent = procedure (Sender: TObject) of object;
  THTMLDocumentEventsonreadystatechangeEvent = procedure (Sender: TObject) of object;
  THTMLDocumentEventsonbeforeupdateEvent = function (Sender: TObject): WordBool of object;
  THTMLDocumentEventsonafterupdateEvent = procedure (Sender: TObject) of object;
  THTMLDocumentEventsonrowexitEvent = function (Sender: TObject): WordBool of object;
  THTMLDocumentEventsonrowenterEvent = procedure (Sender: TObject) of object;
  THTMLDocumentEventsondragstartEvent = function (Sender: TObject): WordBool of object;
  THTMLDocumentEventsonselectstartEvent = function (Sender: TObject): WordBool of object;
  THTMLDocumentEventsonerrorupdateEvent = function (Sender: TObject): WordBool of object;
  THTMLDocumentEventsoncontextmenuEvent = function (Sender: TObject): WordBool of object;
  THTMLDocumentEventsonstopEvent = function (Sender: TObject): WordBool of object;
  THTMLDocumentEventsonrowsdeleteEvent = procedure (Sender: TObject) of object;
  THTMLDocumentEventsonrowsinsertedEvent = procedure (Sender: TObject) of object;
  THTMLDocumentEventsoncellchangeEvent = procedure (Sender: TObject) of object;
  THTMLDocumentEventsonpropertychangeEvent = procedure (Sender: TObject) of object;
  THTMLDocumentEventsondatasetchangedEvent = procedure (Sender: TObject) of object;
  THTMLDocumentEventsondataavailableEvent = procedure (Sender: TObject) of object;
  THTMLDocumentEventsondatasetcompleteEvent = procedure (Sender: TObject) of object;
  THTMLDocumentEventsonbeforeeditfocusEvent = procedure (Sender: TObject) of object;
  THTMLDocumentEventsonselectionchangeEvent = procedure (Sender: TObject) of object;
  THTMLDocumentEventsoncontrolselectEvent = function (Sender: TObject): WordBool of object;
  THTMLDocumentEventsonmousewheelEvent = function (Sender: TObject): WordBool of object;
  THTMLDocumentEventsonfocusinEvent = procedure (Sender: TObject) of object;
  THTMLDocumentEventsonfocusoutEvent = procedure (Sender: TObject) of object;
  THTMLDocumentEventsonactivateEvent = procedure (Sender: TObject) of object;
  THTMLDocumentEventsondeactivateEvent = procedure (Sender: TObject) of object;
  THTMLDocumentEventsonbeforeactivateEvent = function (Sender: TObject): WordBool of object;
  THTMLDocumentEventsonbeforedeactivateEvent = function (Sender: TObject): WordBool of object;

  //SinkComponent//
  TMSHTMLHTMLDocumentEvents = class (TMSHTMLEventsBaseSink
    //ISinkInterface//
  )
  protected
    function DoInvoke (DispID: Integer; const IID: TGUID; LocaleID: Integer;
      Flags: Word; var dps: TDispParams; pDispIds: PDispIdList;
      VarResult, ExcepInfo, ArgErr: Pointer): HResult; override;

    //ISinkInterfaceMethods//
  public
    { system methods }
    constructor Create (AOwner: TComponent); override;
  protected
    //SinkInterface//
    function Doonhelp: WordBool; safecall;
    function Doonclick: WordBool; safecall;
    function Doondblclick: WordBool; safecall;
    procedure Doonkeydown; safecall;
    procedure Doonkeyup; safecall;
    function Doonkeypress: WordBool; safecall;
    procedure Doonmousedown; safecall;
    procedure Doonmousemove; safecall;
    procedure Doonmouseup; safecall;
    procedure Doonmouseout; safecall;
    procedure Doonmouseover; safecall;
    procedure Doonreadystatechange; safecall;
    function Doonbeforeupdate: WordBool; safecall;
    procedure Doonafterupdate; safecall;
    function Doonrowexit: WordBool; safecall;
    procedure Doonrowenter; safecall;
    function Doondragstart: WordBool; safecall;
    function Doonselectstart: WordBool; safecall;
    function Doonerrorupdate: WordBool; safecall;
    function Dooncontextmenu: WordBool; safecall;
    function Doonstop: WordBool; safecall;
    procedure Doonrowsdelete; safecall;
    procedure Doonrowsinserted; safecall;
    procedure Dooncellchange; safecall;
    procedure Doonpropertychange; safecall;
    procedure Doondatasetchanged; safecall;
    procedure Doondataavailable; safecall;
    procedure Doondatasetcomplete; safecall;
    procedure Doonbeforeeditfocus; safecall;
    procedure Doonselectionchange; safecall;
    function Dooncontrolselect: WordBool; safecall;
    function Doonmousewheel: WordBool; safecall;
    procedure Doonfocusin; safecall;
    procedure Doonfocusout; safecall;
    procedure Doonactivate; safecall;
    procedure Doondeactivate; safecall;
    function Doonbeforeactivate: WordBool; safecall;
    function Doonbeforedeactivate: WordBool; safecall;
  protected
    //SinkEventsProtected//
    Fonhelp: THTMLDocumentEventsonhelpEvent;
    Fonclick: THTMLDocumentEventsonclickEvent;
    Fondblclick: THTMLDocumentEventsondblclickEvent;
    Fonkeydown: THTMLDocumentEventsonkeydownEvent;
    Fonkeyup: THTMLDocumentEventsonkeyupEvent;
    Fonkeypress: THTMLDocumentEventsonkeypressEvent;
    Fonmousedown: THTMLDocumentEventsonmousedownEvent;
    Fonmousemove: THTMLDocumentEventsonmousemoveEvent;
    Fonmouseup: THTMLDocumentEventsonmouseupEvent;
    Fonmouseout: THTMLDocumentEventsonmouseoutEvent;
    Fonmouseover: THTMLDocumentEventsonmouseoverEvent;
    Fonreadystatechange: THTMLDocumentEventsonreadystatechangeEvent;
    Fonbeforeupdate: THTMLDocumentEventsonbeforeupdateEvent;
    Fonafterupdate: THTMLDocumentEventsonafterupdateEvent;
    Fonrowexit: THTMLDocumentEventsonrowexitEvent;
    Fonrowenter: THTMLDocumentEventsonrowenterEvent;
    Fondragstart: THTMLDocumentEventsondragstartEvent;
    Fonselectstart: THTMLDocumentEventsonselectstartEvent;
    Fonerrorupdate: THTMLDocumentEventsonerrorupdateEvent;
    Foncontextmenu: THTMLDocumentEventsoncontextmenuEvent;
    Fonstop: THTMLDocumentEventsonstopEvent;
    Fonrowsdelete: THTMLDocumentEventsonrowsdeleteEvent;
    Fonrowsinserted: THTMLDocumentEventsonrowsinsertedEvent;
    Foncellchange: THTMLDocumentEventsoncellchangeEvent;
    Fonpropertychange: THTMLDocumentEventsonpropertychangeEvent;
    Fondatasetchanged: THTMLDocumentEventsondatasetchangedEvent;
    Fondataavailable: THTMLDocumentEventsondataavailableEvent;
    Fondatasetcomplete: THTMLDocumentEventsondatasetcompleteEvent;
    Fonbeforeeditfocus: THTMLDocumentEventsonbeforeeditfocusEvent;
    Fonselectionchange: THTMLDocumentEventsonselectionchangeEvent;
    Foncontrolselect: THTMLDocumentEventsoncontrolselectEvent;
    Fonmousewheel: THTMLDocumentEventsonmousewheelEvent;
    Fonfocusin: THTMLDocumentEventsonfocusinEvent;
    Fonfocusout: THTMLDocumentEventsonfocusoutEvent;
    Fonactivate: THTMLDocumentEventsonactivateEvent;
    Fondeactivate: THTMLDocumentEventsondeactivateEvent;
    Fonbeforeactivate: THTMLDocumentEventsonbeforeactivateEvent;
    Fonbeforedeactivate: THTMLDocumentEventsonbeforedeactivateEvent;
  published
    //SinkEventsPublished//
    property onhelp: THTMLDocumentEventsonhelpEvent read Fonhelp write Fonhelp;
    property onclick: THTMLDocumentEventsonclickEvent read Fonclick write Fonclick;
    property ondblclick: THTMLDocumentEventsondblclickEvent read Fondblclick write Fondblclick;
    property onkeydown: THTMLDocumentEventsonkeydownEvent read Fonkeydown write Fonkeydown;
    property onkeyup: THTMLDocumentEventsonkeyupEvent read Fonkeyup write Fonkeyup;
    property onkeypress: THTMLDocumentEventsonkeypressEvent read Fonkeypress write Fonkeypress;
    property onmousedown: THTMLDocumentEventsonmousedownEvent read Fonmousedown write Fonmousedown;
    property onmousemove: THTMLDocumentEventsonmousemoveEvent read Fonmousemove write Fonmousemove;
    property onmouseup: THTMLDocumentEventsonmouseupEvent read Fonmouseup write Fonmouseup;
    property onmouseout: THTMLDocumentEventsonmouseoutEvent read Fonmouseout write Fonmouseout;
    property onmouseover: THTMLDocumentEventsonmouseoverEvent read Fonmouseover write Fonmouseover;
    property onreadystatechange: THTMLDocumentEventsonreadystatechangeEvent read Fonreadystatechange write Fonreadystatechange;
    property onbeforeupdate: THTMLDocumentEventsonbeforeupdateEvent read Fonbeforeupdate write Fonbeforeupdate;
    property onafterupdate: THTMLDocumentEventsonafterupdateEvent read Fonafterupdate write Fonafterupdate;
    property onrowexit: THTMLDocumentEventsonrowexitEvent read Fonrowexit write Fonrowexit;
    property onrowenter: THTMLDocumentEventsonrowenterEvent read Fonrowenter write Fonrowenter;
    property ondragstart: THTMLDocumentEventsondragstartEvent read Fondragstart write Fondragstart;
    property onselectstart: THTMLDocumentEventsonselectstartEvent read Fonselectstart write Fonselectstart;
    property onerrorupdate: THTMLDocumentEventsonerrorupdateEvent read Fonerrorupdate write Fonerrorupdate;
    property oncontextmenu: THTMLDocumentEventsoncontextmenuEvent read Foncontextmenu write Foncontextmenu;
    property onstop: THTMLDocumentEventsonstopEvent read Fonstop write Fonstop;
    property onrowsdelete: THTMLDocumentEventsonrowsdeleteEvent read Fonrowsdelete write Fonrowsdelete;
    property onrowsinserted: THTMLDocumentEventsonrowsinsertedEvent read Fonrowsinserted write Fonrowsinserted;
    property oncellchange: THTMLDocumentEventsoncellchangeEvent read Foncellchange write Foncellchange;
    property onpropertychange: THTMLDocumentEventsonpropertychangeEvent read Fonpropertychange write Fonpropertychange;
    property ondatasetchanged: THTMLDocumentEventsondatasetchangedEvent read Fondatasetchanged write Fondatasetchanged;
    property ondataavailable: THTMLDocumentEventsondataavailableEvent read Fondataavailable write Fondataavailable;
    property ondatasetcomplete: THTMLDocumentEventsondatasetcompleteEvent read Fondatasetcomplete write Fondatasetcomplete;
    property onbeforeeditfocus: THTMLDocumentEventsonbeforeeditfocusEvent read Fonbeforeeditfocus write Fonbeforeeditfocus;
    property onselectionchange: THTMLDocumentEventsonselectionchangeEvent read Fonselectionchange write Fonselectionchange;
    property oncontrolselect: THTMLDocumentEventsoncontrolselectEvent read Foncontrolselect write Foncontrolselect;
    property onmousewheel: THTMLDocumentEventsonmousewheelEvent read Fonmousewheel write Fonmousewheel;
    property onfocusin: THTMLDocumentEventsonfocusinEvent read Fonfocusin write Fonfocusin;
    property onfocusout: THTMLDocumentEventsonfocusoutEvent read Fonfocusout write Fonfocusout;
    property onactivate: THTMLDocumentEventsonactivateEvent read Fonactivate write Fonactivate;
    property ondeactivate: THTMLDocumentEventsondeactivateEvent read Fondeactivate write Fondeactivate;
    property onbeforeactivate: THTMLDocumentEventsonbeforeactivateEvent read Fonbeforeactivate write Fonbeforeactivate;
    property onbeforedeactivate: THTMLDocumentEventsonbeforedeactivateEvent read Fonbeforedeactivate write Fonbeforedeactivate;
  end;


  //SinkEventsForwards//
  THTMLDocumentEvents2onhelpEvent = function (Sender: TObject; const pEvtObj: IHTMLEventObj): WordBool of object;
  THTMLDocumentEvents2onclickEvent = function (Sender: TObject; const pEvtObj: IHTMLEventObj): WordBool of object;
  THTMLDocumentEvents2ondblclickEvent = function (Sender: TObject; const pEvtObj: IHTMLEventObj): WordBool of object;
  THTMLDocumentEvents2onkeydownEvent = procedure (Sender: TObject; const pEvtObj: IHTMLEventObj) of object;
  THTMLDocumentEvents2onkeyupEvent = procedure (Sender: TObject; const pEvtObj: IHTMLEventObj) of object;
  THTMLDocumentEvents2onkeypressEvent = function (Sender: TObject; const pEvtObj: IHTMLEventObj): WordBool of object;
  THTMLDocumentEvents2onmousedownEvent = procedure (Sender: TObject; const pEvtObj: IHTMLEventObj) of object;
  THTMLDocumentEvents2onmousemoveEvent = procedure (Sender: TObject; const pEvtObj: IHTMLEventObj) of object;
  THTMLDocumentEvents2onmouseupEvent = procedure (Sender: TObject; const pEvtObj: IHTMLEventObj) of object;
  THTMLDocumentEvents2onmouseoutEvent = procedure (Sender: TObject; const pEvtObj: IHTMLEventObj) of object;
  THTMLDocumentEvents2onmouseoverEvent = procedure (Sender: TObject; const pEvtObj: IHTMLEventObj) of object;
  THTMLDocumentEvents2onreadystatechangeEvent = procedure (Sender: TObject; const pEvtObj: IHTMLEventObj) of object;
  THTMLDocumentEvents2onbeforeupdateEvent = function (Sender: TObject; const pEvtObj: IHTMLEventObj): WordBool of object;
  THTMLDocumentEvents2onafterupdateEvent = procedure (Sender: TObject; const pEvtObj: IHTMLEventObj) of object;
  THTMLDocumentEvents2onrowexitEvent = function (Sender: TObject; const pEvtObj: IHTMLEventObj): WordBool of object;
  THTMLDocumentEvents2onrowenterEvent = procedure (Sender: TObject; const pEvtObj: IHTMLEventObj) of object;
  THTMLDocumentEvents2ondragstartEvent = function (Sender: TObject; const pEvtObj: IHTMLEventObj): WordBool of object;
  THTMLDocumentEvents2onselectstartEvent = function (Sender: TObject; const pEvtObj: IHTMLEventObj): WordBool of object;
  THTMLDocumentEvents2onerrorupdateEvent = function (Sender: TObject; const pEvtObj: IHTMLEventObj): WordBool of object;
  THTMLDocumentEvents2oncontextmenuEvent = function (Sender: TObject; const pEvtObj: IHTMLEventObj): WordBool of object;
  THTMLDocumentEvents2onstopEvent = function (Sender: TObject; const pEvtObj: IHTMLEventObj): WordBool of object;
  THTMLDocumentEvents2onrowsdeleteEvent = procedure (Sender: TObject; const pEvtObj: IHTMLEventObj) of object;
  THTMLDocumentEvents2onrowsinsertedEvent = procedure (Sender: TObject; const pEvtObj: IHTMLEventObj) of object;
  THTMLDocumentEvents2oncellchangeEvent = procedure (Sender: TObject; const pEvtObj: IHTMLEventObj) of object;
  THTMLDocumentEvents2onpropertychangeEvent = procedure (Sender: TObject; const pEvtObj: IHTMLEventObj) of object;
  THTMLDocumentEvents2ondatasetchangedEvent = procedure (Sender: TObject; const pEvtObj: IHTMLEventObj) of object;
  THTMLDocumentEvents2ondataavailableEvent = procedure (Sender: TObject; const pEvtObj: IHTMLEventObj) of object;
  THTMLDocumentEvents2ondatasetcompleteEvent = procedure (Sender: TObject; const pEvtObj: IHTMLEventObj) of object;
  THTMLDocumentEvents2onbeforeeditfocusEvent = procedure (Sender: TObject; const pEvtObj: IHTMLEventObj) of object;
  THTMLDocumentEvents2onselectionchangeEvent = procedure (Sender: TObject; const pEvtObj: IHTMLEventObj) of object;
  THTMLDocumentEvents2oncontrolselectEvent = function (Sender: TObject; const pEvtObj: IHTMLEventObj): WordBool of object;
  THTMLDocumentEvents2onmousewheelEvent = function (Sender: TObject; const pEvtObj: IHTMLEventObj): WordBool of object;
  THTMLDocumentEvents2onfocusinEvent = procedure (Sender: TObject; const pEvtObj: IHTMLEventObj) of object;
  THTMLDocumentEvents2onfocusoutEvent = procedure (Sender: TObject; const pEvtObj: IHTMLEventObj) of object;
  THTMLDocumentEvents2onactivateEvent = procedure (Sender: TObject; const pEvtObj: IHTMLEventObj) of object;
  THTMLDocumentEvents2ondeactivateEvent = procedure (Sender: TObject; const pEvtObj: IHTMLEventObj) of object;
  THTMLDocumentEvents2onbeforeactivateEvent = function (Sender: TObject; const pEvtObj: IHTMLEventObj): WordBool of object;
  THTMLDocumentEvents2onbeforedeactivateEvent = function (Sender: TObject; const pEvtObj: IHTMLEventObj): WordBool of object;

  //SinkComponent//
  TMSHTMLHTMLDocumentEvents2 = class (TMSHTMLEventsBaseSink
    //ISinkInterface//
  )
  protected
    function DoInvoke (DispID: Integer; const IID: TGUID; LocaleID: Integer;
      Flags: Word; var dps: TDispParams; pDispIds: PDispIdList;
      VarResult, ExcepInfo, ArgErr: Pointer): HResult; override;

    //ISinkInterfaceMethods//
  public
    { system methods }
    constructor Create (AOwner: TComponent); override;
  protected
    //SinkInterface//
    function Doonhelp(const pEvtObj: IHTMLEventObj): WordBool; safecall;
    function Doonclick(const pEvtObj: IHTMLEventObj): WordBool; safecall;
    function Doondblclick(const pEvtObj: IHTMLEventObj): WordBool; safecall;
    procedure Doonkeydown(const pEvtObj: IHTMLEventObj); safecall;
    procedure Doonkeyup(const pEvtObj: IHTMLEventObj); safecall;
    function Doonkeypress(const pEvtObj: IHTMLEventObj): WordBool; safecall;
    procedure Doonmousedown(const pEvtObj: IHTMLEventObj); safecall;
    procedure Doonmousemove(const pEvtObj: IHTMLEventObj); safecall;
    procedure Doonmouseup(const pEvtObj: IHTMLEventObj); safecall;
    procedure Doonmouseout(const pEvtObj: IHTMLEventObj); safecall;
    procedure Doonmouseover(const pEvtObj: IHTMLEventObj); safecall;
    procedure Doonreadystatechange(const pEvtObj: IHTMLEventObj); safecall;
    function Doonbeforeupdate(const pEvtObj: IHTMLEventObj): WordBool; safecall;
    procedure Doonafterupdate(const pEvtObj: IHTMLEventObj); safecall;
    function Doonrowexit(const pEvtObj: IHTMLEventObj): WordBool; safecall;
    procedure Doonrowenter(const pEvtObj: IHTMLEventObj); safecall;
    function Doondragstart(const pEvtObj: IHTMLEventObj): WordBool; safecall;
    function Doonselectstart(const pEvtObj: IHTMLEventObj): WordBool; safecall;
    function Doonerrorupdate(const pEvtObj: IHTMLEventObj): WordBool; safecall;
    function Dooncontextmenu(const pEvtObj: IHTMLEventObj): WordBool; safecall;
    function Doonstop(const pEvtObj: IHTMLEventObj): WordBool; safecall;
    procedure Doonrowsdelete(const pEvtObj: IHTMLEventObj); safecall;
    procedure Doonrowsinserted(const pEvtObj: IHTMLEventObj); safecall;
    procedure Dooncellchange(const pEvtObj: IHTMLEventObj); safecall;
    procedure Doonpropertychange(const pEvtObj: IHTMLEventObj); safecall;
    procedure Doondatasetchanged(const pEvtObj: IHTMLEventObj); safecall;
    procedure Doondataavailable(const pEvtObj: IHTMLEventObj); safecall;
    procedure Doondatasetcomplete(const pEvtObj: IHTMLEventObj); safecall;
    procedure Doonbeforeeditfocus(const pEvtObj: IHTMLEventObj); safecall;
    procedure Doonselectionchange(const pEvtObj: IHTMLEventObj); safecall;
    function Dooncontrolselect(const pEvtObj: IHTMLEventObj): WordBool; safecall;
    function Doonmousewheel(const pEvtObj: IHTMLEventObj): WordBool; safecall;
    procedure Doonfocusin(const pEvtObj: IHTMLEventObj); safecall;
    procedure Doonfocusout(const pEvtObj: IHTMLEventObj); safecall;
    procedure Doonactivate(const pEvtObj: IHTMLEventObj); safecall;
    procedure Doondeactivate(const pEvtObj: IHTMLEventObj); safecall;
    function Doonbeforeactivate(const pEvtObj: IHTMLEventObj): WordBool; safecall;
    function Doonbeforedeactivate(const pEvtObj: IHTMLEventObj): WordBool; safecall;
  protected
    //SinkEventsProtected//
    Fonhelp: THTMLDocumentEvents2onhelpEvent;
    Fonclick: THTMLDocumentEvents2onclickEvent;
    Fondblclick: THTMLDocumentEvents2ondblclickEvent;
    Fonkeydown: THTMLDocumentEvents2onkeydownEvent;
    Fonkeyup: THTMLDocumentEvents2onkeyupEvent;
    Fonkeypress: THTMLDocumentEvents2onkeypressEvent;
    Fonmousedown: THTMLDocumentEvents2onmousedownEvent;
    Fonmousemove: THTMLDocumentEvents2onmousemoveEvent;
    Fonmouseup: THTMLDocumentEvents2onmouseupEvent;
    Fonmouseout: THTMLDocumentEvents2onmouseoutEvent;
    Fonmouseover: THTMLDocumentEvents2onmouseoverEvent;
    Fonreadystatechange: THTMLDocumentEvents2onreadystatechangeEvent;
    Fonbeforeupdate: THTMLDocumentEvents2onbeforeupdateEvent;
    Fonafterupdate: THTMLDocumentEvents2onafterupdateEvent;
    Fonrowexit: THTMLDocumentEvents2onrowexitEvent;
    Fonrowenter: THTMLDocumentEvents2onrowenterEvent;
    Fondragstart: THTMLDocumentEvents2ondragstartEvent;
    Fonselectstart: THTMLDocumentEvents2onselectstartEvent;
    Fonerrorupdate: THTMLDocumentEvents2onerrorupdateEvent;
    Foncontextmenu: THTMLDocumentEvents2oncontextmenuEvent;
    Fonstop: THTMLDocumentEvents2onstopEvent;
    Fonrowsdelete: THTMLDocumentEvents2onrowsdeleteEvent;
    Fonrowsinserted: THTMLDocumentEvents2onrowsinsertedEvent;
    Foncellchange: THTMLDocumentEvents2oncellchangeEvent;
    Fonpropertychange: THTMLDocumentEvents2onpropertychangeEvent;
    Fondatasetchanged: THTMLDocumentEvents2ondatasetchangedEvent;
    Fondataavailable: THTMLDocumentEvents2ondataavailableEvent;
    Fondatasetcomplete: THTMLDocumentEvents2ondatasetcompleteEvent;
    Fonbeforeeditfocus: THTMLDocumentEvents2onbeforeeditfocusEvent;
    Fonselectionchange: THTMLDocumentEvents2onselectionchangeEvent;
    Foncontrolselect: THTMLDocumentEvents2oncontrolselectEvent;
    Fonmousewheel: THTMLDocumentEvents2onmousewheelEvent;
    Fonfocusin: THTMLDocumentEvents2onfocusinEvent;
    Fonfocusout: THTMLDocumentEvents2onfocusoutEvent;
    Fonactivate: THTMLDocumentEvents2onactivateEvent;
    Fondeactivate: THTMLDocumentEvents2ondeactivateEvent;
    Fonbeforeactivate: THTMLDocumentEvents2onbeforeactivateEvent;
    Fonbeforedeactivate: THTMLDocumentEvents2onbeforedeactivateEvent;
  published
    //SinkEventsPublished//
    property onhelp: THTMLDocumentEvents2onhelpEvent read Fonhelp write Fonhelp;
    property onclick: THTMLDocumentEvents2onclickEvent read Fonclick write Fonclick;
    property ondblclick: THTMLDocumentEvents2ondblclickEvent read Fondblclick write Fondblclick;
    property onkeydown: THTMLDocumentEvents2onkeydownEvent read Fonkeydown write Fonkeydown;
    property onkeyup: THTMLDocumentEvents2onkeyupEvent read Fonkeyup write Fonkeyup;
    property onkeypress: THTMLDocumentEvents2onkeypressEvent read Fonkeypress write Fonkeypress;
    property onmousedown: THTMLDocumentEvents2onmousedownEvent read Fonmousedown write Fonmousedown;
    property onmousemove: THTMLDocumentEvents2onmousemoveEvent read Fonmousemove write Fonmousemove;
    property onmouseup: THTMLDocumentEvents2onmouseupEvent read Fonmouseup write Fonmouseup;
    property onmouseout: THTMLDocumentEvents2onmouseoutEvent read Fonmouseout write Fonmouseout;
    property onmouseover: THTMLDocumentEvents2onmouseoverEvent read Fonmouseover write Fonmouseover;
    property onreadystatechange: THTMLDocumentEvents2onreadystatechangeEvent read Fonreadystatechange write Fonreadystatechange;
    property onbeforeupdate: THTMLDocumentEvents2onbeforeupdateEvent read Fonbeforeupdate write Fonbeforeupdate;
    property onafterupdate: THTMLDocumentEvents2onafterupdateEvent read Fonafterupdate write Fonafterupdate;
    property onrowexit: THTMLDocumentEvents2onrowexitEvent read Fonrowexit write Fonrowexit;
    property onrowenter: THTMLDocumentEvents2onrowenterEvent read Fonrowenter write Fonrowenter;
    property ondragstart: THTMLDocumentEvents2ondragstartEvent read Fondragstart write Fondragstart;
    property onselectstart: THTMLDocumentEvents2onselectstartEvent read Fonselectstart write Fonselectstart;
    property onerrorupdate: THTMLDocumentEvents2onerrorupdateEvent read Fonerrorupdate write Fonerrorupdate;
    property oncontextmenu: THTMLDocumentEvents2oncontextmenuEvent read Foncontextmenu write Foncontextmenu;
    property onstop: THTMLDocumentEvents2onstopEvent read Fonstop write Fonstop;
    property onrowsdelete: THTMLDocumentEvents2onrowsdeleteEvent read Fonrowsdelete write Fonrowsdelete;
    property onrowsinserted: THTMLDocumentEvents2onrowsinsertedEvent read Fonrowsinserted write Fonrowsinserted;
    property oncellchange: THTMLDocumentEvents2oncellchangeEvent read Foncellchange write Foncellchange;
    property onpropertychange: THTMLDocumentEvents2onpropertychangeEvent read Fonpropertychange write Fonpropertychange;
    property ondatasetchanged: THTMLDocumentEvents2ondatasetchangedEvent read Fondatasetchanged write Fondatasetchanged;
    property ondataavailable: THTMLDocumentEvents2ondataavailableEvent read Fondataavailable write Fondataavailable;
    property ondatasetcomplete: THTMLDocumentEvents2ondatasetcompleteEvent read Fondatasetcomplete write Fondatasetcomplete;
    property onbeforeeditfocus: THTMLDocumentEvents2onbeforeeditfocusEvent read Fonbeforeeditfocus write Fonbeforeeditfocus;
    property onselectionchange: THTMLDocumentEvents2onselectionchangeEvent read Fonselectionchange write Fonselectionchange;
    property oncontrolselect: THTMLDocumentEvents2oncontrolselectEvent read Foncontrolselect write Foncontrolselect;
    property onmousewheel: THTMLDocumentEvents2onmousewheelEvent read Fonmousewheel write Fonmousewheel;
    property onfocusin: THTMLDocumentEvents2onfocusinEvent read Fonfocusin write Fonfocusin;
    property onfocusout: THTMLDocumentEvents2onfocusoutEvent read Fonfocusout write Fonfocusout;
    property onactivate: THTMLDocumentEvents2onactivateEvent read Fonactivate write Fonactivate;
    property ondeactivate: THTMLDocumentEvents2ondeactivateEvent read Fondeactivate write Fondeactivate;
    property onbeforeactivate: THTMLDocumentEvents2onbeforeactivateEvent read Fonbeforeactivate write Fonbeforeactivate;
    property onbeforedeactivate: THTMLDocumentEvents2onbeforedeactivateEvent read Fonbeforedeactivate write Fonbeforedeactivate;
  end;


  //SinkEventsForwards//
  THTMLStyleElementEventsonhelpEvent = function (Sender: TObject): WordBool of object;
  THTMLStyleElementEventsonclickEvent = function (Sender: TObject): WordBool of object;
  THTMLStyleElementEventsondblclickEvent = function (Sender: TObject): WordBool of object;
  THTMLStyleElementEventsonkeypressEvent = function (Sender: TObject): WordBool of object;
  THTMLStyleElementEventsonkeydownEvent = procedure (Sender: TObject) of object;
  THTMLStyleElementEventsonkeyupEvent = procedure (Sender: TObject) of object;
  THTMLStyleElementEventsonmouseoutEvent = procedure (Sender: TObject) of object;
  THTMLStyleElementEventsonmouseoverEvent = procedure (Sender: TObject) of object;
  THTMLStyleElementEventsonmousemoveEvent = procedure (Sender: TObject) of object;
  THTMLStyleElementEventsonmousedownEvent = procedure (Sender: TObject) of object;
  THTMLStyleElementEventsonmouseupEvent = procedure (Sender: TObject) of object;
  THTMLStyleElementEventsonselectstartEvent = function (Sender: TObject): WordBool of object;
  THTMLStyleElementEventsonfilterchangeEvent = procedure (Sender: TObject) of object;
  THTMLStyleElementEventsondragstartEvent = function (Sender: TObject): WordBool of object;
  THTMLStyleElementEventsonbeforeupdateEvent = function (Sender: TObject): WordBool of object;
  THTMLStyleElementEventsonafterupdateEvent = procedure (Sender: TObject) of object;
  THTMLStyleElementEventsonerrorupdateEvent = function (Sender: TObject): WordBool of object;
  THTMLStyleElementEventsonrowexitEvent = function (Sender: TObject): WordBool of object;
  THTMLStyleElementEventsonrowenterEvent = procedure (Sender: TObject) of object;
  THTMLStyleElementEventsondatasetchangedEvent = procedure (Sender: TObject) of object;
  THTMLStyleElementEventsondataavailableEvent = procedure (Sender: TObject) of object;
  THTMLStyleElementEventsondatasetcompleteEvent = procedure (Sender: TObject) of object;
  THTMLStyleElementEventsonlosecaptureEvent = procedure (Sender: TObject) of object;
  THTMLStyleElementEventsonpropertychangeEvent = procedure (Sender: TObject) of object;
  THTMLStyleElementEventsonscrollEvent = procedure (Sender: TObject) of object;
  THTMLStyleElementEventsonfocusEvent = procedure (Sender: TObject) of object;
  THTMLStyleElementEventsonblurEvent = procedure (Sender: TObject) of object;
  THTMLStyleElementEventsonresizeEvent = procedure (Sender: TObject) of object;
  THTMLStyleElementEventsondragEvent = function (Sender: TObject): WordBool of object;
  THTMLStyleElementEventsondragendEvent = procedure (Sender: TObject) of object;
  THTMLStyleElementEventsondragenterEvent = function (Sender: TObject): WordBool of object;
  THTMLStyleElementEventsondragoverEvent = function (Sender: TObject): WordBool of object;
  THTMLStyleElementEventsondragleaveEvent = procedure (Sender: TObject) of object;
  THTMLStyleElementEventsondropEvent = function (Sender: TObject): WordBool of object;
  THTMLStyleElementEventsonbeforecutEvent = function (Sender: TObject): WordBool of object;
  THTMLStyleElementEventsoncutEvent = function (Sender: TObject): WordBool of object;
  THTMLStyleElementEventsonbeforecopyEvent = function (Sender: TObject): WordBool of object;
  THTMLStyleElementEventsoncopyEvent = function (Sender: TObject): WordBool of object;
  THTMLStyleElementEventsonbeforepasteEvent = function (Sender: TObject): WordBool of object;
  THTMLStyleElementEventsonpasteEvent = function (Sender: TObject): WordBool of object;
  THTMLStyleElementEventsoncontextmenuEvent = function (Sender: TObject): WordBool of object;
  THTMLStyleElementEventsonrowsdeleteEvent = procedure (Sender: TObject) of object;
  THTMLStyleElementEventsonrowsinsertedEvent = procedure (Sender: TObject) of object;
  THTMLStyleElementEventsoncellchangeEvent = procedure (Sender: TObject) of object;
  THTMLStyleElementEventsonreadystatechangeEvent = procedure (Sender: TObject) of object;
  THTMLStyleElementEventsonbeforeeditfocusEvent = procedure (Sender: TObject) of object;
  THTMLStyleElementEventsonlayoutcompleteEvent = procedure (Sender: TObject) of object;
  THTMLStyleElementEventsonpageEvent = procedure (Sender: TObject) of object;
  THTMLStyleElementEventsonbeforedeactivateEvent = function (Sender: TObject): WordBool of object;
  THTMLStyleElementEventsonbeforeactivateEvent = function (Sender: TObject): WordBool of object;
  THTMLStyleElementEventsonmoveEvent = procedure (Sender: TObject) of object;
  THTMLStyleElementEventsoncontrolselectEvent = function (Sender: TObject): WordBool of object;
  THTMLStyleElementEventsonmovestartEvent = function (Sender: TObject): WordBool of object;
  THTMLStyleElementEventsonmoveendEvent = procedure (Sender: TObject) of object;
  THTMLStyleElementEventsonresizestartEvent = function (Sender: TObject): WordBool of object;
  THTMLStyleElementEventsonresizeendEvent = procedure (Sender: TObject) of object;
  THTMLStyleElementEventsonmouseenterEvent = procedure (Sender: TObject) of object;
  THTMLStyleElementEventsonmouseleaveEvent = procedure (Sender: TObject) of object;
  THTMLStyleElementEventsonmousewheelEvent = function (Sender: TObject): WordBool of object;
  THTMLStyleElementEventsonactivateEvent = procedure (Sender: TObject) of object;
  THTMLStyleElementEventsondeactivateEvent = procedure (Sender: TObject) of object;
  THTMLStyleElementEventsonfocusinEvent = procedure (Sender: TObject) of object;
  THTMLStyleElementEventsonfocusoutEvent = procedure (Sender: TObject) of object;
  THTMLStyleElementEventsonloadEvent = procedure (Sender: TObject) of object;
  THTMLStyleElementEventsonerrorEvent = procedure (Sender: TObject) of object;

  //SinkComponent//
  TMSHTMLHTMLStyleElementEvents = class (TMSHTMLEventsBaseSink
    //ISinkInterface//
  )
  protected
    function DoInvoke (DispID: Integer; const IID: TGUID; LocaleID: Integer;
      Flags: Word; var dps: TDispParams; pDispIds: PDispIdList;
      VarResult, ExcepInfo, ArgErr: Pointer): HResult; override;

    //ISinkInterfaceMethods//
  public
    { system methods }
    constructor Create (AOwner: TComponent); override;
  protected
    //SinkInterface//
    function Doonhelp: WordBool; safecall;
    function Doonclick: WordBool; safecall;
    function Doondblclick: WordBool; safecall;
    function Doonkeypress: WordBool; safecall;
    procedure Doonkeydown; safecall;
    procedure Doonkeyup; safecall;
    procedure Doonmouseout; safecall;
    procedure Doonmouseover; safecall;
    procedure Doonmousemove; safecall;
    procedure Doonmousedown; safecall;
    procedure Doonmouseup; safecall;
    function Doonselectstart: WordBool; safecall;
    procedure Doonfilterchange; safecall;
    function Doondragstart: WordBool; safecall;
    function Doonbeforeupdate: WordBool; safecall;
    procedure Doonafterupdate; safecall;
    function Doonerrorupdate: WordBool; safecall;
    function Doonrowexit: WordBool; safecall;
    procedure Doonrowenter; safecall;
    procedure Doondatasetchanged; safecall;
    procedure Doondataavailable; safecall;
    procedure Doondatasetcomplete; safecall;
    procedure Doonlosecapture; safecall;
    procedure Doonpropertychange; safecall;
    procedure Doonscroll; safecall;
    procedure Doonfocus; safecall;
    procedure Doonblur; safecall;
    procedure Doonresize; safecall;
    function Doondrag: WordBool; safecall;
    procedure Doondragend; safecall;
    function Doondragenter: WordBool; safecall;
    function Doondragover: WordBool; safecall;
    procedure Doondragleave; safecall;
    function Doondrop: WordBool; safecall;
    function Doonbeforecut: WordBool; safecall;
    function Dooncut: WordBool; safecall;
    function Doonbeforecopy: WordBool; safecall;
    function Dooncopy: WordBool; safecall;
    function Doonbeforepaste: WordBool; safecall;
    function Doonpaste: WordBool; safecall;
    function Dooncontextmenu: WordBool; safecall;
    procedure Doonrowsdelete; safecall;
    procedure Doonrowsinserted; safecall;
    procedure Dooncellchange; safecall;
    procedure Doonreadystatechange; safecall;
    procedure Doonbeforeeditfocus; safecall;
    procedure Doonlayoutcomplete; safecall;
    procedure Doonpage; safecall;
    function Doonbeforedeactivate: WordBool; safecall;
    function Doonbeforeactivate: WordBool; safecall;
    procedure Doonmove; safecall;
    function Dooncontrolselect: WordBool; safecall;
    function Doonmovestart: WordBool; safecall;
    procedure Doonmoveend; safecall;
    function Doonresizestart: WordBool; safecall;
    procedure Doonresizeend; safecall;
    procedure Doonmouseenter; safecall;
    procedure Doonmouseleave; safecall;
    function Doonmousewheel: WordBool; safecall;
    procedure Doonactivate; safecall;
    procedure Doondeactivate; safecall;
    procedure Doonfocusin; safecall;
    procedure Doonfocusout; safecall;
    procedure Doonload; safecall;
    procedure Doonerror; safecall;
  protected
    //SinkEventsProtected//
    Fonhelp: THTMLStyleElementEventsonhelpEvent;
    Fonclick: THTMLStyleElementEventsonclickEvent;
    Fondblclick: THTMLStyleElementEventsondblclickEvent;
    Fonkeypress: THTMLStyleElementEventsonkeypressEvent;
    Fonkeydown: THTMLStyleElementEventsonkeydownEvent;
    Fonkeyup: THTMLStyleElementEventsonkeyupEvent;
    Fonmouseout: THTMLStyleElementEventsonmouseoutEvent;
    Fonmouseover: THTMLStyleElementEventsonmouseoverEvent;
    Fonmousemove: THTMLStyleElementEventsonmousemoveEvent;
    Fonmousedown: THTMLStyleElementEventsonmousedownEvent;
    Fonmouseup: THTMLStyleElementEventsonmouseupEvent;
    Fonselectstart: THTMLStyleElementEventsonselectstartEvent;
    Fonfilterchange: THTMLStyleElementEventsonfilterchangeEvent;
    Fondragstart: THTMLStyleElementEventsondragstartEvent;
    Fonbeforeupdate: THTMLStyleElementEventsonbeforeupdateEvent;
    Fonafterupdate: THTMLStyleElementEventsonafterupdateEvent;
    Fonerrorupdate: THTMLStyleElementEventsonerrorupdateEvent;
    Fonrowexit: THTMLStyleElementEventsonrowexitEvent;
    Fonrowenter: THTMLStyleElementEventsonrowenterEvent;
    Fondatasetchanged: THTMLStyleElementEventsondatasetchangedEvent;
    Fondataavailable: THTMLStyleElementEventsondataavailableEvent;
    Fondatasetcomplete: THTMLStyleElementEventsondatasetcompleteEvent;
    Fonlosecapture: THTMLStyleElementEventsonlosecaptureEvent;
    Fonpropertychange: THTMLStyleElementEventsonpropertychangeEvent;
    Fonscroll: THTMLStyleElementEventsonscrollEvent;
    Fonfocus: THTMLStyleElementEventsonfocusEvent;
    Fonblur: THTMLStyleElementEventsonblurEvent;
    Fonresize: THTMLStyleElementEventsonresizeEvent;
    Fondrag: THTMLStyleElementEventsondragEvent;
    Fondragend: THTMLStyleElementEventsondragendEvent;
    Fondragenter: THTMLStyleElementEventsondragenterEvent;
    Fondragover: THTMLStyleElementEventsondragoverEvent;
    Fondragleave: THTMLStyleElementEventsondragleaveEvent;
    Fondrop: THTMLStyleElementEventsondropEvent;
    Fonbeforecut: THTMLStyleElementEventsonbeforecutEvent;
    Foncut: THTMLStyleElementEventsoncutEvent;
    Fonbeforecopy: THTMLStyleElementEventsonbeforecopyEvent;
    Foncopy: THTMLStyleElementEventsoncopyEvent;
    Fonbeforepaste: THTMLStyleElementEventsonbeforepasteEvent;
    Fonpaste: THTMLStyleElementEventsonpasteEvent;
    Foncontextmenu: THTMLStyleElementEventsoncontextmenuEvent;
    Fonrowsdelete: THTMLStyleElementEventsonrowsdeleteEvent;
    Fonrowsinserted: THTMLStyleElementEventsonrowsinsertedEvent;
    Foncellchange: THTMLStyleElementEventsoncellchangeEvent;
    Fonreadystatechange: THTMLStyleElementEventsonreadystatechangeEvent;
    Fonbeforeeditfocus: THTMLStyleElementEventsonbeforeeditfocusEvent;
    Fonlayoutcomplete: THTMLStyleElementEventsonlayoutcompleteEvent;
    Fonpage: THTMLStyleElementEventsonpageEvent;
    Fonbeforedeactivate: THTMLStyleElementEventsonbeforedeactivateEvent;
    Fonbeforeactivate: THTMLStyleElementEventsonbeforeactivateEvent;
    Fonmove: THTMLStyleElementEventsonmoveEvent;
    Foncontrolselect: THTMLStyleElementEventsoncontrolselectEvent;
    Fonmovestart: THTMLStyleElementEventsonmovestartEvent;
    Fonmoveend: THTMLStyleElementEventsonmoveendEvent;
    Fonresizestart: THTMLStyleElementEventsonresizestartEvent;
    Fonresizeend: THTMLStyleElementEventsonresizeendEvent;
    Fonmouseenter: THTMLStyleElementEventsonmouseenterEvent;
    Fonmouseleave: THTMLStyleElementEventsonmouseleaveEvent;
    Fonmousewheel: THTMLStyleElementEventsonmousewheelEvent;
    Fonactivate: THTMLStyleElementEventsonactivateEvent;
    Fondeactivate: THTMLStyleElementEventsondeactivateEvent;
    Fonfocusin: THTMLStyleElementEventsonfocusinEvent;
    Fonfocusout: THTMLStyleElementEventsonfocusoutEvent;
    Fonload: THTMLStyleElementEventsonloadEvent;
    Fonerror: THTMLStyleElementEventsonerrorEvent;
  published
    //SinkEventsPublished//
    property onhelp: THTMLStyleElementEventsonhelpEvent read Fonhelp write Fonhelp;
    property onclick: THTMLStyleElementEventsonclickEvent read Fonclick write Fonclick;
    property ondblclick: THTMLStyleElementEventsondblclickEvent read Fondblclick write Fondblclick;
    property onkeypress: THTMLStyleElementEventsonkeypressEvent read Fonkeypress write Fonkeypress;
    property onkeydown: THTMLStyleElementEventsonkeydownEvent read Fonkeydown write Fonkeydown;
    property onkeyup: THTMLStyleElementEventsonkeyupEvent read Fonkeyup write Fonkeyup;
    property onmouseout: THTMLStyleElementEventsonmouseoutEvent read Fonmouseout write Fonmouseout;
    property onmouseover: THTMLStyleElementEventsonmouseoverEvent read Fonmouseover write Fonmouseover;
    property onmousemove: THTMLStyleElementEventsonmousemoveEvent read Fonmousemove write Fonmousemove;
    property onmousedown: THTMLStyleElementEventsonmousedownEvent read Fonmousedown write Fonmousedown;
    property onmouseup: THTMLStyleElementEventsonmouseupEvent read Fonmouseup write Fonmouseup;
    property onselectstart: THTMLStyleElementEventsonselectstartEvent read Fonselectstart write Fonselectstart;
    property onfilterchange: THTMLStyleElementEventsonfilterchangeEvent read Fonfilterchange write Fonfilterchange;
    property ondragstart: THTMLStyleElementEventsondragstartEvent read Fondragstart write Fondragstart;
    property onbeforeupdate: THTMLStyleElementEventsonbeforeupdateEvent read Fonbeforeupdate write Fonbeforeupdate;
    property onafterupdate: THTMLStyleElementEventsonafterupdateEvent read Fonafterupdate write Fonafterupdate;
    property onerrorupdate: THTMLStyleElementEventsonerrorupdateEvent read Fonerrorupdate write Fonerrorupdate;
    property onrowexit: THTMLStyleElementEventsonrowexitEvent read Fonrowexit write Fonrowexit;
    property onrowenter: THTMLStyleElementEventsonrowenterEvent read Fonrowenter write Fonrowenter;
    property ondatasetchanged: THTMLStyleElementEventsondatasetchangedEvent read Fondatasetchanged write Fondatasetchanged;
    property ondataavailable: THTMLStyleElementEventsondataavailableEvent read Fondataavailable write Fondataavailable;
    property ondatasetcomplete: THTMLStyleElementEventsondatasetcompleteEvent read Fondatasetcomplete write Fondatasetcomplete;
    property onlosecapture: THTMLStyleElementEventsonlosecaptureEvent read Fonlosecapture write Fonlosecapture;
    property onpropertychange: THTMLStyleElementEventsonpropertychangeEvent read Fonpropertychange write Fonpropertychange;
    property onscroll: THTMLStyleElementEventsonscrollEvent read Fonscroll write Fonscroll;
    property onfocus: THTMLStyleElementEventsonfocusEvent read Fonfocus write Fonfocus;
    property onblur: THTMLStyleElementEventsonblurEvent read Fonblur write Fonblur;
    property onresize: THTMLStyleElementEventsonresizeEvent read Fonresize write Fonresize;
    property ondrag: THTMLStyleElementEventsondragEvent read Fondrag write Fondrag;
    property ondragend: THTMLStyleElementEventsondragendEvent read Fondragend write Fondragend;
    property ondragenter: THTMLStyleElementEventsondragenterEvent read Fondragenter write Fondragenter;
    property ondragover: THTMLStyleElementEventsondragoverEvent read Fondragover write Fondragover;
    property ondragleave: THTMLStyleElementEventsondragleaveEvent read Fondragleave write Fondragleave;
    property ondrop: THTMLStyleElementEventsondropEvent read Fondrop write Fondrop;
    property onbeforecut: THTMLStyleElementEventsonbeforecutEvent read Fonbeforecut write Fonbeforecut;
    property oncut: THTMLStyleElementEventsoncutEvent read Foncut write Foncut;
    property onbeforecopy: THTMLStyleElementEventsonbeforecopyEvent read Fonbeforecopy write Fonbeforecopy;
    property oncopy: THTMLStyleElementEventsoncopyEvent read Foncopy write Foncopy;
    property onbeforepaste: THTMLStyleElementEventsonbeforepasteEvent read Fonbeforepaste write Fonbeforepaste;
    property onpaste: THTMLStyleElementEventsonpasteEvent read Fonpaste write Fonpaste;
    property oncontextmenu: THTMLStyleElementEventsoncontextmenuEvent read Foncontextmenu write Foncontextmenu;
    property onrowsdelete: THTMLStyleElementEventsonrowsdeleteEvent read Fonrowsdelete write Fonrowsdelete;
    property onrowsinserted: THTMLStyleElementEventsonrowsinsertedEvent read Fonrowsinserted write Fonrowsinserted;
    property oncellchange: THTMLStyleElementEventsoncellchangeEvent read Foncellchange write Foncellchange;
    property onreadystatechange: THTMLStyleElementEventsonreadystatechangeEvent read Fonreadystatechange write Fonreadystatechange;
    property onbeforeeditfocus: THTMLStyleElementEventsonbeforeeditfocusEvent read Fonbeforeeditfocus write Fonbeforeeditfocus;
    property onlayoutcomplete: THTMLStyleElementEventsonlayoutcompleteEvent read Fonlayoutcomplete write Fonlayoutcomplete;
    property onpage: THTMLStyleElementEventsonpageEvent read Fonpage write Fonpage;
    property onbeforedeactivate: THTMLStyleElementEventsonbeforedeactivateEvent read Fonbeforedeactivate write Fonbeforedeactivate;
    property onbeforeactivate: THTMLStyleElementEventsonbeforeactivateEvent read Fonbeforeactivate write Fonbeforeactivate;
    property onmove: THTMLStyleElementEventsonmoveEvent read Fonmove write Fonmove;
    property oncontrolselect: THTMLStyleElementEventsoncontrolselectEvent read Foncontrolselect write Foncontrolselect;
    property onmovestart: THTMLStyleElementEventsonmovestartEvent read Fonmovestart write Fonmovestart;
    property onmoveend: THTMLStyleElementEventsonmoveendEvent read Fonmoveend write Fonmoveend;
    property onresizestart: THTMLStyleElementEventsonresizestartEvent read Fonresizestart write Fonresizestart;
    property onresizeend: THTMLStyleElementEventsonresizeendEvent read Fonresizeend write Fonresizeend;
    property onmouseenter: THTMLStyleElementEventsonmouseenterEvent read Fonmouseenter write Fonmouseenter;
    property onmouseleave: THTMLStyleElementEventsonmouseleaveEvent read Fonmouseleave write Fonmouseleave;
    property onmousewheel: THTMLStyleElementEventsonmousewheelEvent read Fonmousewheel write Fonmousewheel;
    property onactivate: THTMLStyleElementEventsonactivateEvent read Fonactivate write Fonactivate;
    property ondeactivate: THTMLStyleElementEventsondeactivateEvent read Fondeactivate write Fondeactivate;
    property onfocusin: THTMLStyleElementEventsonfocusinEvent read Fonfocusin write Fonfocusin;
    property onfocusout: THTMLStyleElementEventsonfocusoutEvent read Fonfocusout write Fonfocusout;
    property onload: THTMLStyleElementEventsonloadEvent read Fonload write Fonload;
    property onerror: THTMLStyleElementEventsonerrorEvent read Fonerror write Fonerror;
  end;


  //SinkEventsForwards//
  THTMLStyleElementEvents2onhelpEvent = function (Sender: TObject; const pEvtObj: IHTMLEventObj): WordBool of object;
  THTMLStyleElementEvents2onclickEvent = function (Sender: TObject; const pEvtObj: IHTMLEventObj): WordBool of object;
  THTMLStyleElementEvents2ondblclickEvent = function (Sender: TObject; const pEvtObj: IHTMLEventObj): WordBool of object;
  THTMLStyleElementEvents2onkeypressEvent = function (Sender: TObject; const pEvtObj: IHTMLEventObj): WordBool of object;
  THTMLStyleElementEvents2onkeydownEvent = procedure (Sender: TObject; const pEvtObj: IHTMLEventObj) of object;
  THTMLStyleElementEvents2onkeyupEvent = procedure (Sender: TObject; const pEvtObj: IHTMLEventObj) of object;
  THTMLStyleElementEvents2onmouseoutEvent = procedure (Sender: TObject; const pEvtObj: IHTMLEventObj) of object;
  THTMLStyleElementEvents2onmouseoverEvent = procedure (Sender: TObject; const pEvtObj: IHTMLEventObj) of object;
  THTMLStyleElementEvents2onmousemoveEvent = procedure (Sender: TObject; const pEvtObj: IHTMLEventObj) of object;
  THTMLStyleElementEvents2onmousedownEvent = procedure (Sender: TObject; const pEvtObj: IHTMLEventObj) of object;
  THTMLStyleElementEvents2onmouseupEvent = procedure (Sender: TObject; const pEvtObj: IHTMLEventObj) of object;
  THTMLStyleElementEvents2onselectstartEvent = function (Sender: TObject; const pEvtObj: IHTMLEventObj): WordBool of object;
  THTMLStyleElementEvents2onfilterchangeEvent = procedure (Sender: TObject; const pEvtObj: IHTMLEventObj) of object;
  THTMLStyleElementEvents2ondragstartEvent = function (Sender: TObject; const pEvtObj: IHTMLEventObj): WordBool of object;
  THTMLStyleElementEvents2onbeforeupdateEvent = function (Sender: TObject; const pEvtObj: IHTMLEventObj): WordBool of object;
  THTMLStyleElementEvents2onafterupdateEvent = procedure (Sender: TObject; const pEvtObj: IHTMLEventObj) of object;
  THTMLStyleElementEvents2onerrorupdateEvent = function (Sender: TObject; const pEvtObj: IHTMLEventObj): WordBool of object;
  THTMLStyleElementEvents2onrowexitEvent = function (Sender: TObject; const pEvtObj: IHTMLEventObj): WordBool of object;
  THTMLStyleElementEvents2onrowenterEvent = procedure (Sender: TObject; const pEvtObj: IHTMLEventObj) of object;
  THTMLStyleElementEvents2ondatasetchangedEvent = procedure (Sender: TObject; const pEvtObj: IHTMLEventObj) of object;
  THTMLStyleElementEvents2ondataavailableEvent = procedure (Sender: TObject; const pEvtObj: IHTMLEventObj) of object;
  THTMLStyleElementEvents2ondatasetcompleteEvent = procedure (Sender: TObject; const pEvtObj: IHTMLEventObj) of object;
  THTMLStyleElementEvents2onlosecaptureEvent = procedure (Sender: TObject; const pEvtObj: IHTMLEventObj) of object;
  THTMLStyleElementEvents2onpropertychangeEvent = procedure (Sender: TObject; const pEvtObj: IHTMLEventObj) of object;
  THTMLStyleElementEvents2onscrollEvent = procedure (Sender: TObject; const pEvtObj: IHTMLEventObj) of object;
  THTMLStyleElementEvents2onfocusEvent = procedure (Sender: TObject; const pEvtObj: IHTMLEventObj) of object;
  THTMLStyleElementEvents2onblurEvent = procedure (Sender: TObject; const pEvtObj: IHTMLEventObj) of object;
  THTMLStyleElementEvents2onresizeEvent = procedure (Sender: TObject; const pEvtObj: IHTMLEventObj) of object;
  THTMLStyleElementEvents2ondragEvent = function (Sender: TObject; const pEvtObj: IHTMLEventObj): WordBool of object;
  THTMLStyleElementEvents2ondragendEvent = procedure (Sender: TObject; const pEvtObj: IHTMLEventObj) of object;
  THTMLStyleElementEvents2ondragenterEvent = function (Sender: TObject; const pEvtObj: IHTMLEventObj): WordBool of object;
  THTMLStyleElementEvents2ondragoverEvent = function (Sender: TObject; const pEvtObj: IHTMLEventObj): WordBool of object;
  THTMLStyleElementEvents2ondragleaveEvent = procedure (Sender: TObject; const pEvtObj: IHTMLEventObj) of object;
  THTMLStyleElementEvents2ondropEvent = function (Sender: TObject; const pEvtObj: IHTMLEventObj): WordBool of object;
  THTMLStyleElementEvents2onbeforecutEvent = function (Sender: TObject; const pEvtObj: IHTMLEventObj): WordBool of object;
  THTMLStyleElementEvents2oncutEvent = function (Sender: TObject; const pEvtObj: IHTMLEventObj): WordBool of object;
  THTMLStyleElementEvents2onbeforecopyEvent = function (Sender: TObject; const pEvtObj: IHTMLEventObj): WordBool of object;
  THTMLStyleElementEvents2oncopyEvent = function (Sender: TObject; const pEvtObj: IHTMLEventObj): WordBool of object;
  THTMLStyleElementEvents2onbeforepasteEvent = function (Sender: TObject; const pEvtObj: IHTMLEventObj): WordBool of object;
  THTMLStyleElementEvents2onpasteEvent = function (Sender: TObject; const pEvtObj: IHTMLEventObj): WordBool of object;
  THTMLStyleElementEvents2oncontextmenuEvent = function (Sender: TObject; const pEvtObj: IHTMLEventObj): WordBool of object;
  THTMLStyleElementEvents2onrowsdeleteEvent = procedure (Sender: TObject; const pEvtObj: IHTMLEventObj) of object;
  THTMLStyleElementEvents2onrowsinsertedEvent = procedure (Sender: TObject; const pEvtObj: IHTMLEventObj) of object;
  THTMLStyleElementEvents2oncellchangeEvent = procedure (Sender: TObject; const pEvtObj: IHTMLEventObj) of object;
  THTMLStyleElementEvents2onreadystatechangeEvent = procedure (Sender: TObject; const pEvtObj: IHTMLEventObj) of object;
  THTMLStyleElementEvents2onlayoutcompleteEvent = procedure (Sender: TObject; const pEvtObj: IHTMLEventObj) of object;
  THTMLStyleElementEvents2onpageEvent = procedure (Sender: TObject; const pEvtObj: IHTMLEventObj) of object;
  THTMLStyleElementEvents2onmouseenterEvent = procedure (Sender: TObject; const pEvtObj: IHTMLEventObj) of object;
  THTMLStyleElementEvents2onmouseleaveEvent = procedure (Sender: TObject; const pEvtObj: IHTMLEventObj) of object;
  THTMLStyleElementEvents2onactivateEvent = procedure (Sender: TObject; const pEvtObj: IHTMLEventObj) of object;
  THTMLStyleElementEvents2ondeactivateEvent = procedure (Sender: TObject; const pEvtObj: IHTMLEventObj) of object;
  THTMLStyleElementEvents2onbeforedeactivateEvent = function (Sender: TObject; const pEvtObj: IHTMLEventObj): WordBool of object;
  THTMLStyleElementEvents2onbeforeactivateEvent = function (Sender: TObject; const pEvtObj: IHTMLEventObj): WordBool of object;
  THTMLStyleElementEvents2onfocusinEvent = procedure (Sender: TObject; const pEvtObj: IHTMLEventObj) of object;
  THTMLStyleElementEvents2onfocusoutEvent = procedure (Sender: TObject; const pEvtObj: IHTMLEventObj) of object;
  THTMLStyleElementEvents2onmoveEvent = procedure (Sender: TObject; const pEvtObj: IHTMLEventObj) of object;
  THTMLStyleElementEvents2oncontrolselectEvent = function (Sender: TObject; const pEvtObj: IHTMLEventObj): WordBool of object;
  THTMLStyleElementEvents2onmovestartEvent = function (Sender: TObject; const pEvtObj: IHTMLEventObj): WordBool of object;
  THTMLStyleElementEvents2onmoveendEvent = procedure (Sender: TObject; const pEvtObj: IHTMLEventObj) of object;
  THTMLStyleElementEvents2onresizestartEvent = function (Sender: TObject; const pEvtObj: IHTMLEventObj): WordBool of object;
  THTMLStyleElementEvents2onresizeendEvent = procedure (Sender: TObject; const pEvtObj: IHTMLEventObj) of object;
  THTMLStyleElementEvents2onmousewheelEvent = function (Sender: TObject; const pEvtObj: IHTMLEventObj): WordBool of object;
  THTMLStyleElementEvents2onloadEvent = procedure (Sender: TObject; const pEvtObj: IHTMLEventObj) of object;
  THTMLStyleElementEvents2onerrorEvent = procedure (Sender: TObject; const pEvtObj: IHTMLEventObj) of object;

  //SinkComponent//
  TMSHTMLHTMLStyleElementEvents2 = class (TMSHTMLEventsBaseSink
    //ISinkInterface//
  )
  protected
    function DoInvoke (DispID: Integer; const IID: TGUID; LocaleID: Integer;
      Flags: Word; var dps: TDispParams; pDispIds: PDispIdList;
      VarResult, ExcepInfo, ArgErr: Pointer): HResult; override;

    //ISinkInterfaceMethods//
  public
    { system methods }
    constructor Create (AOwner: TComponent); override;
  protected
    //SinkInterface//
    function Doonhelp(const pEvtObj: IHTMLEventObj): WordBool; safecall;
    function Doonclick(const pEvtObj: IHTMLEventObj): WordBool; safecall;
    function Doondblclick(const pEvtObj: IHTMLEventObj): WordBool; safecall;
    function Doonkeypress(const pEvtObj: IHTMLEventObj): WordBool; safecall;
    procedure Doonkeydown(const pEvtObj: IHTMLEventObj); safecall;
    procedure Doonkeyup(const pEvtObj: IHTMLEventObj); safecall;
    procedure Doonmouseout(const pEvtObj: IHTMLEventObj); safecall;
    procedure Doonmouseover(const pEvtObj: IHTMLEventObj); safecall;
    procedure Doonmousemove(const pEvtObj: IHTMLEventObj); safecall;
    procedure Doonmousedown(const pEvtObj: IHTMLEventObj); safecall;
    procedure Doonmouseup(const pEvtObj: IHTMLEventObj); safecall;
    function Doonselectstart(const pEvtObj: IHTMLEventObj): WordBool; safecall;
    procedure Doonfilterchange(const pEvtObj: IHTMLEventObj); safecall;
    function Doondragstart(const pEvtObj: IHTMLEventObj): WordBool; safecall;
    function Doonbeforeupdate(const pEvtObj: IHTMLEventObj): WordBool; safecall;
    procedure Doonafterupdate(const pEvtObj: IHTMLEventObj); safecall;
    function Doonerrorupdate(const pEvtObj: IHTMLEventObj): WordBool; safecall;
    function Doonrowexit(const pEvtObj: IHTMLEventObj): WordBool; safecall;
    procedure Doonrowenter(const pEvtObj: IHTMLEventObj); safecall;
    procedure Doondatasetchanged(const pEvtObj: IHTMLEventObj); safecall;
    procedure Doondataavailable(const pEvtObj: IHTMLEventObj); safecall;
    procedure Doondatasetcomplete(const pEvtObj: IHTMLEventObj); safecall;
    procedure Doonlosecapture(const pEvtObj: IHTMLEventObj); safecall;
    procedure Doonpropertychange(const pEvtObj: IHTMLEventObj); safecall;
    procedure Doonscroll(const pEvtObj: IHTMLEventObj); safecall;
    procedure Doonfocus(const pEvtObj: IHTMLEventObj); safecall;
    procedure Doonblur(const pEvtObj: IHTMLEventObj); safecall;
    procedure Doonresize(const pEvtObj: IHTMLEventObj); safecall;
    function Doondrag(const pEvtObj: IHTMLEventObj): WordBool; safecall;
    procedure Doondragend(const pEvtObj: IHTMLEventObj); safecall;
    function Doondragenter(const pEvtObj: IHTMLEventObj): WordBool; safecall;
    function Doondragover(const pEvtObj: IHTMLEventObj): WordBool; safecall;
    procedure Doondragleave(const pEvtObj: IHTMLEventObj); safecall;
    function Doondrop(const pEvtObj: IHTMLEventObj): WordBool; safecall;
    function Doonbeforecut(const pEvtObj: IHTMLEventObj): WordBool; safecall;
    function Dooncut(const pEvtObj: IHTMLEventObj): WordBool; safecall;
    function Doonbeforecopy(const pEvtObj: IHTMLEventObj): WordBool; safecall;
    function Dooncopy(const pEvtObj: IHTMLEventObj): WordBool; safecall;
    function Doonbeforepaste(const pEvtObj: IHTMLEventObj): WordBool; safecall;
    function Doonpaste(const pEvtObj: IHTMLEventObj): WordBool; safecall;
    function Dooncontextmenu(const pEvtObj: IHTMLEventObj): WordBool; safecall;
    procedure Doonrowsdelete(const pEvtObj: IHTMLEventObj); safecall;
    procedure Doonrowsinserted(const pEvtObj: IHTMLEventObj); safecall;
    procedure Dooncellchange(const pEvtObj: IHTMLEventObj); safecall;
    procedure Doonreadystatechange(const pEvtObj: IHTMLEventObj); safecall;
    procedure Doonlayoutcomplete(const pEvtObj: IHTMLEventObj); safecall;
    procedure Doonpage(const pEvtObj: IHTMLEventObj); safecall;
    procedure Doonmouseenter(const pEvtObj: IHTMLEventObj); safecall;
    procedure Doonmouseleave(const pEvtObj: IHTMLEventObj); safecall;
    procedure Doonactivate(const pEvtObj: IHTMLEventObj); safecall;
    procedure Doondeactivate(const pEvtObj: IHTMLEventObj); safecall;
    function Doonbeforedeactivate(const pEvtObj: IHTMLEventObj): WordBool; safecall;
    function Doonbeforeactivate(const pEvtObj: IHTMLEventObj): WordBool; safecall;
    procedure Doonfocusin(const pEvtObj: IHTMLEventObj); safecall;
    procedure Doonfocusout(const pEvtObj: IHTMLEventObj); safecall;
    procedure Doonmove(const pEvtObj: IHTMLEventObj); safecall;
    function Dooncontrolselect(const pEvtObj: IHTMLEventObj): WordBool; safecall;
    function Doonmovestart(const pEvtObj: IHTMLEventObj): WordBool; safecall;
    procedure Doonmoveend(const pEvtObj: IHTMLEventObj); safecall;
    function Doonresizestart(const pEvtObj: IHTMLEventObj): WordBool; safecall;
    procedure Doonresizeend(const pEvtObj: IHTMLEventObj); safecall;
    function Doonmousewheel(const pEvtObj: IHTMLEventObj): WordBool; safecall;
    procedure Doonload(const pEvtObj: IHTMLEventObj); safecall;
    procedure Doonerror(const pEvtObj: IHTMLEventObj); safecall;
  protected
    //SinkEventsProtected//
    Fonhelp: THTMLStyleElementEvents2onhelpEvent;
    Fonclick: THTMLStyleElementEvents2onclickEvent;
    Fondblclick: THTMLStyleElementEvents2ondblclickEvent;
    Fonkeypress: THTMLStyleElementEvents2onkeypressEvent;
    Fonkeydown: THTMLStyleElementEvents2onkeydownEvent;
    Fonkeyup: THTMLStyleElementEvents2onkeyupEvent;
    Fonmouseout: THTMLStyleElementEvents2onmouseoutEvent;
    Fonmouseover: THTMLStyleElementEvents2onmouseoverEvent;
    Fonmousemove: THTMLStyleElementEvents2onmousemoveEvent;
    Fonmousedown: THTMLStyleElementEvents2onmousedownEvent;
    Fonmouseup: THTMLStyleElementEvents2onmouseupEvent;
    Fonselectstart: THTMLStyleElementEvents2onselectstartEvent;
    Fonfilterchange: THTMLStyleElementEvents2onfilterchangeEvent;
    Fondragstart: THTMLStyleElementEvents2ondragstartEvent;
    Fonbeforeupdate: THTMLStyleElementEvents2onbeforeupdateEvent;
    Fonafterupdate: THTMLStyleElementEvents2onafterupdateEvent;
    Fonerrorupdate: THTMLStyleElementEvents2onerrorupdateEvent;
    Fonrowexit: THTMLStyleElementEvents2onrowexitEvent;
    Fonrowenter: THTMLStyleElementEvents2onrowenterEvent;
    Fondatasetchanged: THTMLStyleElementEvents2ondatasetchangedEvent;
    Fondataavailable: THTMLStyleElementEvents2ondataavailableEvent;
    Fondatasetcomplete: THTMLStyleElementEvents2ondatasetcompleteEvent;
    Fonlosecapture: THTMLStyleElementEvents2onlosecaptureEvent;
    Fonpropertychange: THTMLStyleElementEvents2onpropertychangeEvent;
    Fonscroll: THTMLStyleElementEvents2onscrollEvent;
    Fonfocus: THTMLStyleElementEvents2onfocusEvent;
    Fonblur: THTMLStyleElementEvents2onblurEvent;
    Fonresize: THTMLStyleElementEvents2onresizeEvent;
    Fondrag: THTMLStyleElementEvents2ondragEvent;
    Fondragend: THTMLStyleElementEvents2ondragendEvent;
    Fondragenter: THTMLStyleElementEvents2ondragenterEvent;
    Fondragover: THTMLStyleElementEvents2ondragoverEvent;
    Fondragleave: THTMLStyleElementEvents2ondragleaveEvent;
    Fondrop: THTMLStyleElementEvents2ondropEvent;
    Fonbeforecut: THTMLStyleElementEvents2onbeforecutEvent;
    Foncut: THTMLStyleElementEvents2oncutEvent;
    Fonbeforecopy: THTMLStyleElementEvents2onbeforecopyEvent;
    Foncopy: THTMLStyleElementEvents2oncopyEvent;
    Fonbeforepaste: THTMLStyleElementEvents2onbeforepasteEvent;
    Fonpaste: THTMLStyleElementEvents2onpasteEvent;
    Foncontextmenu: THTMLStyleElementEvents2oncontextmenuEvent;
    Fonrowsdelete: THTMLStyleElementEvents2onrowsdeleteEvent;
    Fonrowsinserted: THTMLStyleElementEvents2onrowsinsertedEvent;
    Foncellchange: THTMLStyleElementEvents2oncellchangeEvent;
    Fonreadystatechange: THTMLStyleElementEvents2onreadystatechangeEvent;
    Fonlayoutcomplete: THTMLStyleElementEvents2onlayoutcompleteEvent;
    Fonpage: THTMLStyleElementEvents2onpageEvent;
    Fonmouseenter: THTMLStyleElementEvents2onmouseenterEvent;
    Fonmouseleave: THTMLStyleElementEvents2onmouseleaveEvent;
    Fonactivate: THTMLStyleElementEvents2onactivateEvent;
    Fondeactivate: THTMLStyleElementEvents2ondeactivateEvent;
    Fonbeforedeactivate: THTMLStyleElementEvents2onbeforedeactivateEvent;
    Fonbeforeactivate: THTMLStyleElementEvents2onbeforeactivateEvent;
    Fonfocusin: THTMLStyleElementEvents2onfocusinEvent;
    Fonfocusout: THTMLStyleElementEvents2onfocusoutEvent;
    Fonmove: THTMLStyleElementEvents2onmoveEvent;
    Foncontrolselect: THTMLStyleElementEvents2oncontrolselectEvent;
    Fonmovestart: THTMLStyleElementEvents2onmovestartEvent;
    Fonmoveend: THTMLStyleElementEvents2onmoveendEvent;
    Fonresizestart: THTMLStyleElementEvents2onresizestartEvent;
    Fonresizeend: THTMLStyleElementEvents2onresizeendEvent;
    Fonmousewheel: THTMLStyleElementEvents2onmousewheelEvent;
    Fonload: THTMLStyleElementEvents2onloadEvent;
    Fonerror: THTMLStyleElementEvents2onerrorEvent;
  published
    //SinkEventsPublished//
    property onhelp: THTMLStyleElementEvents2onhelpEvent read Fonhelp write Fonhelp;
    property onclick: THTMLStyleElementEvents2onclickEvent read Fonclick write Fonclick;
    property ondblclick: THTMLStyleElementEvents2ondblclickEvent read Fondblclick write Fondblclick;
    property onkeypress: THTMLStyleElementEvents2onkeypressEvent read Fonkeypress write Fonkeypress;
    property onkeydown: THTMLStyleElementEvents2onkeydownEvent read Fonkeydown write Fonkeydown;
    property onkeyup: THTMLStyleElementEvents2onkeyupEvent read Fonkeyup write Fonkeyup;
    property onmouseout: THTMLStyleElementEvents2onmouseoutEvent read Fonmouseout write Fonmouseout;
    property onmouseover: THTMLStyleElementEvents2onmouseoverEvent read Fonmouseover write Fonmouseover;
    property onmousemove: THTMLStyleElementEvents2onmousemoveEvent read Fonmousemove write Fonmousemove;
    property onmousedown: THTMLStyleElementEvents2onmousedownEvent read Fonmousedown write Fonmousedown;
    property onmouseup: THTMLStyleElementEvents2onmouseupEvent read Fonmouseup write Fonmouseup;
    property onselectstart: THTMLStyleElementEvents2onselectstartEvent read Fonselectstart write Fonselectstart;
    property onfilterchange: THTMLStyleElementEvents2onfilterchangeEvent read Fonfilterchange write Fonfilterchange;
    property ondragstart: THTMLStyleElementEvents2ondragstartEvent read Fondragstart write Fondragstart;
    property onbeforeupdate: THTMLStyleElementEvents2onbeforeupdateEvent read Fonbeforeupdate write Fonbeforeupdate;
    property onafterupdate: THTMLStyleElementEvents2onafterupdateEvent read Fonafterupdate write Fonafterupdate;
    property onerrorupdate: THTMLStyleElementEvents2onerrorupdateEvent read Fonerrorupdate write Fonerrorupdate;
    property onrowexit: THTMLStyleElementEvents2onrowexitEvent read Fonrowexit write Fonrowexit;
    property onrowenter: THTMLStyleElementEvents2onrowenterEvent read Fonrowenter write Fonrowenter;
    property ondatasetchanged: THTMLStyleElementEvents2ondatasetchangedEvent read Fondatasetchanged write Fondatasetchanged;
    property ondataavailable: THTMLStyleElementEvents2ondataavailableEvent read Fondataavailable write Fondataavailable;
    property ondatasetcomplete: THTMLStyleElementEvents2ondatasetcompleteEvent read Fondatasetcomplete write Fondatasetcomplete;
    property onlosecapture: THTMLStyleElementEvents2onlosecaptureEvent read Fonlosecapture write Fonlosecapture;
    property onpropertychange: THTMLStyleElementEvents2onpropertychangeEvent read Fonpropertychange write Fonpropertychange;
    property onscroll: THTMLStyleElementEvents2onscrollEvent read Fonscroll write Fonscroll;
    property onfocus: THTMLStyleElementEvents2onfocusEvent read Fonfocus write Fonfocus;
    property onblur: THTMLStyleElementEvents2onblurEvent read Fonblur write Fonblur;
    property onresize: THTMLStyleElementEvents2onresizeEvent read Fonresize write Fonresize;
    property ondrag: THTMLStyleElementEvents2ondragEvent read Fondrag write Fondrag;
    property ondragend: THTMLStyleElementEvents2ondragendEvent read Fondragend write Fondragend;
    property ondragenter: THTMLStyleElementEvents2ondragenterEvent read Fondragenter write Fondragenter;
    property ondragover: THTMLStyleElementEvents2ondragoverEvent read Fondragover write Fondragover;
    property ondragleave: THTMLStyleElementEvents2ondragleaveEvent read Fondragleave write Fondragleave;
    property ondrop: THTMLStyleElementEvents2ondropEvent read Fondrop write Fondrop;
    property onbeforecut: THTMLStyleElementEvents2onbeforecutEvent read Fonbeforecut write Fonbeforecut;
    property oncut: THTMLStyleElementEvents2oncutEvent read Foncut write Foncut;
    property onbeforecopy: THTMLStyleElementEvents2onbeforecopyEvent read Fonbeforecopy write Fonbeforecopy;
    property oncopy: THTMLStyleElementEvents2oncopyEvent read Foncopy write Foncopy;
    property onbeforepaste: THTMLStyleElementEvents2onbeforepasteEvent read Fonbeforepaste write Fonbeforepaste;
    property onpaste: THTMLStyleElementEvents2onpasteEvent read Fonpaste write Fonpaste;
    property oncontextmenu: THTMLStyleElementEvents2oncontextmenuEvent read Foncontextmenu write Foncontextmenu;
    property onrowsdelete: THTMLStyleElementEvents2onrowsdeleteEvent read Fonrowsdelete write Fonrowsdelete;
    property onrowsinserted: THTMLStyleElementEvents2onrowsinsertedEvent read Fonrowsinserted write Fonrowsinserted;
    property oncellchange: THTMLStyleElementEvents2oncellchangeEvent read Foncellchange write Foncellchange;
    property onreadystatechange: THTMLStyleElementEvents2onreadystatechangeEvent read Fonreadystatechange write Fonreadystatechange;
    property onlayoutcomplete: THTMLStyleElementEvents2onlayoutcompleteEvent read Fonlayoutcomplete write Fonlayoutcomplete;
    property onpage: THTMLStyleElementEvents2onpageEvent read Fonpage write Fonpage;
    property onmouseenter: THTMLStyleElementEvents2onmouseenterEvent read Fonmouseenter write Fonmouseenter;
    property onmouseleave: THTMLStyleElementEvents2onmouseleaveEvent read Fonmouseleave write Fonmouseleave;
    property onactivate: THTMLStyleElementEvents2onactivateEvent read Fonactivate write Fonactivate;
    property ondeactivate: THTMLStyleElementEvents2ondeactivateEvent read Fondeactivate write Fondeactivate;
    property onbeforedeactivate: THTMLStyleElementEvents2onbeforedeactivateEvent read Fonbeforedeactivate write Fonbeforedeactivate;
    property onbeforeactivate: THTMLStyleElementEvents2onbeforeactivateEvent read Fonbeforeactivate write Fonbeforeactivate;
    property onfocusin: THTMLStyleElementEvents2onfocusinEvent read Fonfocusin write Fonfocusin;
    property onfocusout: THTMLStyleElementEvents2onfocusoutEvent read Fonfocusout write Fonfocusout;
    property onmove: THTMLStyleElementEvents2onmoveEvent read Fonmove write Fonmove;
    property oncontrolselect: THTMLStyleElementEvents2oncontrolselectEvent read Foncontrolselect write Foncontrolselect;
    property onmovestart: THTMLStyleElementEvents2onmovestartEvent read Fonmovestart write Fonmovestart;
    property onmoveend: THTMLStyleElementEvents2onmoveendEvent read Fonmoveend write Fonmoveend;
    property onresizestart: THTMLStyleElementEvents2onresizestartEvent read Fonresizestart write Fonresizestart;
    property onresizeend: THTMLStyleElementEvents2onresizeendEvent read Fonresizeend write Fonresizeend;
    property onmousewheel: THTMLStyleElementEvents2onmousewheelEvent read Fonmousewheel write Fonmousewheel;
    property onload: THTMLStyleElementEvents2onloadEvent read Fonload write Fonload;
    property onerror: THTMLStyleElementEvents2onerrorEvent read Fonerror write Fonerror;
  end;

  //SinkIntfEnd//

procedure Register;


implementation


uses
  SysUtils;

{ globals }

procedure BuildPositionalDispIds (pDispIds: PDispIdList; const dps: TDispParams);
var
  i: integer;
begin
  Assert (pDispIds <> nil);
  
  { by default, directly arrange in reverse order }
  for i := 0 to dps.cArgs - 1 do
    pDispIds^ [i] := dps.cArgs - 1 - i;

  { check for named args }
  if (dps.cNamedArgs <= 0) then Exit;

  { parse named args }
  for i := 0 to dps.cNamedArgs - 1 do
    pDispIds^ [dps.rgdispidNamedArgs^ [i]] := i;
end;


{ TMSHTMLEventsBaseSink }

function TMSHTMLEventsBaseSink.GetIDsOfNames(const IID: TGUID; Names: Pointer;
  NameCount, LocaleID: Integer; DispIDs: Pointer): HResult;
begin
  Result := E_NOTIMPL;
end;

function TMSHTMLEventsBaseSink.GetTypeInfo(Index, LocaleID: Integer; out TypeInfo): HResult;
begin
  Result := E_NOTIMPL;
  pointer (TypeInfo) := nil;
end;

function TMSHTMLEventsBaseSink.GetTypeInfoCount(out Count: Integer): HResult;
begin
  Result := E_NOTIMPL;
  Count := 0;
end;

function TMSHTMLEventsBaseSink.Invoke(DispID: Integer; const IID: TGUID; LocaleID: Integer;
  Flags: Word; var Params; VarResult, ExcepInfo, ArgErr: Pointer): HResult;
var
  dps: TDispParams absolute Params;
  bHasParams: boolean;
  pDispIds: PDispIdList;
  iDispIdsSize: integer;
begin
  { validity checks }
  if (Flags AND DISPATCH_METHOD = 0) then
    raise Exception.Create (
      Format ('%s only supports sinking of method calls!', [ClassName]
    ));

  { build pDispIds array. this maybe a bit of overhead but it allows us to
    sink named-argument calls such as Excel's AppEvents, etc!
  }
  pDispIds := nil;
  iDispIdsSize := 0;
  bHasParams := (dps.cArgs > 0);
  if (bHasParams) then
  begin
    iDispIdsSize := dps.cArgs * SizeOf (TDispId);
    GetMem (pDispIds, iDispIdsSize);
  end;  { if }

  try
    { rearrange dispids properly }
    if (bHasParams) then BuildPositionalDispIds (pDispIds, dps);
    Result := DoInvoke (DispId, IID, LocaleID, Flags, dps, pDispIds, VarResult, ExcepInfo, ArgErr);
  finally
    { free pDispIds array }
    if (bHasParams) then FreeMem (pDispIds, iDispIdsSize);
  end;  { finally }
end;

function TMSHTMLEventsBaseSink.QueryInterface(const IID: TGUID; out Obj): HResult;
begin
  if (GetInterface (IID, Obj)) then
  begin
    Result := S_OK;
    Exit;
  end
  else
    if (IsEqualIID (IID, FSinkIID)) then
      if (GetInterface (IDispatch, Obj)) then
      begin
        Result := S_OK;
        Exit;
      end;
  Result := E_NOINTERFACE;
  pointer (Obj) := nil;
end;

function TMSHTMLEventsBaseSink._AddRef: Integer;
begin
  Result := 2;
end;

function TMSHTMLEventsBaseSink._Release: Integer;
begin
  Result := 1;
end;

destructor TMSHTMLEventsBaseSink.Destroy;
begin
  Disconnect;
  inherited;
end;

procedure TMSHTMLEventsBaseSink.Connect (const ASource: IUnknown);
var
  pcpc: IConnectionPointContainer;
begin
  Assert (ASource <> nil);
  Disconnect;
  try
    OleCheck (ASource.QueryInterface (IConnectionPointContainer, pcpc));
    OleCheck (pcpc.FindConnectionPoint (FSinkIID, FCP));
    OleCheck (FCP.Advise (Self, FCookie));
    FSource := ASource;
  except
    raise Exception.Create (Format ('Unable to connect %s.'#13'%s',
      [Name, Exception (ExceptObject).Message]
    ));
  end;  { finally }
end;

procedure TMSHTMLEventsBaseSink.Disconnect;
begin
  if (FSource = nil) then Exit;
  try
    OleCheck (FCP.Unadvise (FCookie));
    FCP := nil;
    FSource := nil;
  except
    pointer (FCP) := nil;
    pointer (FSource) := nil;
  end;  { except }
end;


//SinkImplStart//

function TMSHTMLHTMLElementEvents.DoInvoke (DispID: Integer; const IID: TGUID; LocaleID: Integer;
  Flags: Word; var dps: TDispParams; pDispIds: PDispIdList;
  VarResult, ExcepInfo, ArgErr: Pointer): HResult;
type
  POleVariant = ^OleVariant;
begin
  Result := DISP_E_MEMBERNOTFOUND;

  //SinkInvoke//
    case DispId of
      -2147418102 :
      begin
        OleVariant (VarResult^) := Doonhelp ();
        Result := S_OK;
      end;
      -600 :
      begin
        OleVariant (VarResult^) := Doonclick ();
        Result := S_OK;
      end;
      -601 :
      begin
        OleVariant (VarResult^) := Doondblclick ();
        Result := S_OK;
      end;
      -603 :
      begin
        OleVariant (VarResult^) := Doonkeypress ();
        Result := S_OK;
      end;
      -602 :
      begin
        Doonkeydown ();
        Result := S_OK;
      end;
      -604 :
      begin
        Doonkeyup ();
        Result := S_OK;
      end;
      -2147418103 :
      begin
        Doonmouseout ();
        Result := S_OK;
      end;
      -2147418104 :
      begin
        Doonmouseover ();
        Result := S_OK;
      end;
      -606 :
      begin
        Doonmousemove ();
        Result := S_OK;
      end;
      -605 :
      begin
        Doonmousedown ();
        Result := S_OK;
      end;
      -607 :
      begin
        Doonmouseup ();
        Result := S_OK;
      end;
      -2147418100 :
      begin
        OleVariant (VarResult^) := Doonselectstart ();
        Result := S_OK;
      end;
      -2147418095 :
      begin
        Doonfilterchange ();
        Result := S_OK;
      end;
      -2147418101 :
      begin
        OleVariant (VarResult^) := Doondragstart ();
        Result := S_OK;
      end;
      -2147418108 :
      begin
        OleVariant (VarResult^) := Doonbeforeupdate ();
        Result := S_OK;
      end;
      -2147418107 :
      begin
        Doonafterupdate ();
        Result := S_OK;
      end;
      -2147418099 :
      begin
        OleVariant (VarResult^) := Doonerrorupdate ();
        Result := S_OK;
      end;
      -2147418106 :
      begin
        OleVariant (VarResult^) := Doonrowexit ();
        Result := S_OK;
      end;
      -2147418105 :
      begin
        Doonrowenter ();
        Result := S_OK;
      end;
      -2147418098 :
      begin
        Doondatasetchanged ();
        Result := S_OK;
      end;
      -2147418097 :
      begin
        Doondataavailable ();
        Result := S_OK;
      end;
      -2147418096 :
      begin
        Doondatasetcomplete ();
        Result := S_OK;
      end;
      -2147418094 :
      begin
        Doonlosecapture ();
        Result := S_OK;
      end;
      -2147418093 :
      begin
        Doonpropertychange ();
        Result := S_OK;
      end;
      1014 :
      begin
        Doonscroll ();
        Result := S_OK;
      end;
      -2147418111 :
      begin
        Doonfocus ();
        Result := S_OK;
      end;
      -2147418112 :
      begin
        Doonblur ();
        Result := S_OK;
      end;
      1016 :
      begin
        Doonresize ();
        Result := S_OK;
      end;
      -2147418092 :
      begin
        OleVariant (VarResult^) := Doondrag ();
        Result := S_OK;
      end;
      -2147418091 :
      begin
        Doondragend ();
        Result := S_OK;
      end;
      -2147418090 :
      begin
        OleVariant (VarResult^) := Doondragenter ();
        Result := S_OK;
      end;
      -2147418089 :
      begin
        OleVariant (VarResult^) := Doondragover ();
        Result := S_OK;
      end;
      -2147418088 :
      begin
        Doondragleave ();
        Result := S_OK;
      end;
      -2147418087 :
      begin
        OleVariant (VarResult^) := Doondrop ();
        Result := S_OK;
      end;
      -2147418083 :
      begin
        OleVariant (VarResult^) := Doonbeforecut ();
        Result := S_OK;
      end;
      -2147418086 :
      begin
        OleVariant (VarResult^) := Dooncut ();
        Result := S_OK;
      end;
      -2147418082 :
      begin
        OleVariant (VarResult^) := Doonbeforecopy ();
        Result := S_OK;
      end;
      -2147418085 :
      begin
        OleVariant (VarResult^) := Dooncopy ();
        Result := S_OK;
      end;
      -2147418081 :
      begin
        OleVariant (VarResult^) := Doonbeforepaste ();
        Result := S_OK;
      end;
      -2147418084 :
      begin
        OleVariant (VarResult^) := Doonpaste ();
        Result := S_OK;
      end;
      1023 :
      begin
        OleVariant (VarResult^) := Dooncontextmenu ();
        Result := S_OK;
      end;
      -2147418080 :
      begin
        Doonrowsdelete ();
        Result := S_OK;
      end;
      -2147418079 :
      begin
        Doonrowsinserted ();
        Result := S_OK;
      end;
      -2147418078 :
      begin
        Dooncellchange ();
        Result := S_OK;
      end;
      -609 :
      begin
        Doonreadystatechange ();
        Result := S_OK;
      end;
      1027 :
      begin
        Doonbeforeeditfocus ();
        Result := S_OK;
      end;
      1030 :
      begin
        Doonlayoutcomplete ();
        Result := S_OK;
      end;
      1031 :
      begin
        Doonpage ();
        Result := S_OK;
      end;
      1034 :
      begin
        OleVariant (VarResult^) := Doonbeforedeactivate ();
        Result := S_OK;
      end;
      1047 :
      begin
        OleVariant (VarResult^) := Doonbeforeactivate ();
        Result := S_OK;
      end;
      1035 :
      begin
        Doonmove ();
        Result := S_OK;
      end;
      1036 :
      begin
        OleVariant (VarResult^) := Dooncontrolselect ();
        Result := S_OK;
      end;
      1038 :
      begin
        OleVariant (VarResult^) := Doonmovestart ();
        Result := S_OK;
      end;
      1039 :
      begin
        Doonmoveend ();
        Result := S_OK;
      end;
      1040 :
      begin
        OleVariant (VarResult^) := Doonresizestart ();
        Result := S_OK;
      end;
      1041 :
      begin
        Doonresizeend ();
        Result := S_OK;
      end;
      1042 :
      begin
        Doonmouseenter ();
        Result := S_OK;
      end;
      1043 :
      begin
        Doonmouseleave ();
        Result := S_OK;
      end;
      1033 :
      begin
        OleVariant (VarResult^) := Doonmousewheel ();
        Result := S_OK;
      end;
      1044 :
      begin
        Doonactivate ();
        Result := S_OK;
      end;
      1045 :
      begin
        Doondeactivate ();
        Result := S_OK;
      end;
      1048 :
      begin
        Doonfocusin ();
        Result := S_OK;
      end;
      1049 :
      begin
        Doonfocusout ();
        Result := S_OK;
      end;
    end;  { case }
  //SinkInvokeEnd//
end;

constructor TMSHTMLHTMLElementEvents.Create (AOwner: TComponent);
begin
  inherited Create (AOwner);
  //SinkInit//
  FSinkIID := HTMLElementEvents;
end;

//SinkImplementation//
function TMSHTMLHTMLElementEvents.Doonhelp: WordBool;
begin
  if not Assigned (onhelp) then System.Exit;
  Result := onhelp (Self);
end;

function TMSHTMLHTMLElementEvents.Doonclick: WordBool;
begin
  if not Assigned (onclick) then System.Exit;
  Result := onclick (Self);
end;

function TMSHTMLHTMLElementEvents.Doondblclick: WordBool;
begin
  if not Assigned (ondblclick) then System.Exit;
  Result := ondblclick (Self);
end;

function TMSHTMLHTMLElementEvents.Doonkeypress: WordBool;
begin
  if not Assigned (onkeypress) then System.Exit;
  Result := onkeypress (Self);
end;

procedure TMSHTMLHTMLElementEvents.Doonkeydown;
begin
  if not Assigned (onkeydown) then System.Exit;
  onkeydown (Self);
end;

procedure TMSHTMLHTMLElementEvents.Doonkeyup;
begin
  if not Assigned (onkeyup) then System.Exit;
  onkeyup (Self);
end;

procedure TMSHTMLHTMLElementEvents.Doonmouseout;
begin
  if not Assigned (onmouseout) then System.Exit;
  onmouseout (Self);
end;

procedure TMSHTMLHTMLElementEvents.Doonmouseover;
begin
  if not Assigned (onmouseover) then System.Exit;
  onmouseover (Self);
end;

procedure TMSHTMLHTMLElementEvents.Doonmousemove;
begin
  if not Assigned (onmousemove) then System.Exit;
  onmousemove (Self);
end;

procedure TMSHTMLHTMLElementEvents.Doonmousedown;
begin
  if not Assigned (onmousedown) then System.Exit;
  onmousedown (Self);
end;

procedure TMSHTMLHTMLElementEvents.Doonmouseup;
begin
  if not Assigned (onmouseup) then System.Exit;
  onmouseup (Self);
end;

function TMSHTMLHTMLElementEvents.Doonselectstart: WordBool;
begin
  if not Assigned (onselectstart) then System.Exit;
  Result := onselectstart (Self);
end;

procedure TMSHTMLHTMLElementEvents.Doonfilterchange;
begin
  if not Assigned (onfilterchange) then System.Exit;
  onfilterchange (Self);
end;

function TMSHTMLHTMLElementEvents.Doondragstart: WordBool;
begin
  if not Assigned (ondragstart) then System.Exit;
  Result := ondragstart (Self);
end;

function TMSHTMLHTMLElementEvents.Doonbeforeupdate: WordBool;
begin
  if not Assigned (onbeforeupdate) then System.Exit;
  Result := onbeforeupdate (Self);
end;

procedure TMSHTMLHTMLElementEvents.Doonafterupdate;
begin
  if not Assigned (onafterupdate) then System.Exit;
  onafterupdate (Self);
end;

function TMSHTMLHTMLElementEvents.Doonerrorupdate: WordBool;
begin
  if not Assigned (onerrorupdate) then System.Exit;
  Result := onerrorupdate (Self);
end;

function TMSHTMLHTMLElementEvents.Doonrowexit: WordBool;
begin
  if not Assigned (onrowexit) then System.Exit;
  Result := onrowexit (Self);
end;

procedure TMSHTMLHTMLElementEvents.Doonrowenter;
begin
  if not Assigned (onrowenter) then System.Exit;
  onrowenter (Self);
end;

procedure TMSHTMLHTMLElementEvents.Doondatasetchanged;
begin
  if not Assigned (ondatasetchanged) then System.Exit;
  ondatasetchanged (Self);
end;

procedure TMSHTMLHTMLElementEvents.Doondataavailable;
begin
  if not Assigned (ondataavailable) then System.Exit;
  ondataavailable (Self);
end;

procedure TMSHTMLHTMLElementEvents.Doondatasetcomplete;
begin
  if not Assigned (ondatasetcomplete) then System.Exit;
  ondatasetcomplete (Self);
end;

procedure TMSHTMLHTMLElementEvents.Doonlosecapture;
begin
  if not Assigned (onlosecapture) then System.Exit;
  onlosecapture (Self);
end;

procedure TMSHTMLHTMLElementEvents.Doonpropertychange;
begin
  if not Assigned (onpropertychange) then System.Exit;
  onpropertychange (Self);
end;

procedure TMSHTMLHTMLElementEvents.Doonscroll;
begin
  if not Assigned (onscroll) then System.Exit;
  onscroll (Self);
end;

procedure TMSHTMLHTMLElementEvents.Doonfocus;
begin
  if not Assigned (onfocus) then System.Exit;
  onfocus (Self);
end;

procedure TMSHTMLHTMLElementEvents.Doonblur;
begin
  if not Assigned (onblur) then System.Exit;
  onblur (Self);
end;

procedure TMSHTMLHTMLElementEvents.Doonresize;
begin
  if not Assigned (onresize) then System.Exit;
  onresize (Self);
end;

function TMSHTMLHTMLElementEvents.Doondrag: WordBool;
begin
  if not Assigned (ondrag) then System.Exit;
  Result := ondrag (Self);
end;

procedure TMSHTMLHTMLElementEvents.Doondragend;
begin
  if not Assigned (ondragend) then System.Exit;
  ondragend (Self);
end;

function TMSHTMLHTMLElementEvents.Doondragenter: WordBool;
begin
  if not Assigned (ondragenter) then System.Exit;
  Result := ondragenter (Self);
end;

function TMSHTMLHTMLElementEvents.Doondragover: WordBool;
begin
  if not Assigned (ondragover) then System.Exit;
  Result := ondragover (Self);
end;

procedure TMSHTMLHTMLElementEvents.Doondragleave;
begin
  if not Assigned (ondragleave) then System.Exit;
  ondragleave (Self);
end;

function TMSHTMLHTMLElementEvents.Doondrop: WordBool;
begin
  if not Assigned (ondrop) then System.Exit;
  Result := ondrop (Self);
end;

function TMSHTMLHTMLElementEvents.Doonbeforecut: WordBool;
begin
  if not Assigned (onbeforecut) then System.Exit;
  Result := onbeforecut (Self);
end;

function TMSHTMLHTMLElementEvents.Dooncut: WordBool;
begin
  if not Assigned (oncut) then System.Exit;
  Result := oncut (Self);
end;

function TMSHTMLHTMLElementEvents.Doonbeforecopy: WordBool;
begin
  if not Assigned (onbeforecopy) then System.Exit;
  Result := onbeforecopy (Self);
end;

function TMSHTMLHTMLElementEvents.Dooncopy: WordBool;
begin
  if not Assigned (oncopy) then System.Exit;
  Result := oncopy (Self);
end;

function TMSHTMLHTMLElementEvents.Doonbeforepaste: WordBool;
begin
  if not Assigned (onbeforepaste) then System.Exit;
  Result := onbeforepaste (Self);
end;

function TMSHTMLHTMLElementEvents.Doonpaste: WordBool;
begin
  if not Assigned (onpaste) then System.Exit;
  Result := onpaste (Self);
end;

function TMSHTMLHTMLElementEvents.Dooncontextmenu: WordBool;
begin
  if not Assigned (oncontextmenu) then System.Exit;
  Result := oncontextmenu (Self);
end;

procedure TMSHTMLHTMLElementEvents.Doonrowsdelete;
begin
  if not Assigned (onrowsdelete) then System.Exit;
  onrowsdelete (Self);
end;

procedure TMSHTMLHTMLElementEvents.Doonrowsinserted;
begin
  if not Assigned (onrowsinserted) then System.Exit;
  onrowsinserted (Self);
end;

procedure TMSHTMLHTMLElementEvents.Dooncellchange;
begin
  if not Assigned (oncellchange) then System.Exit;
  oncellchange (Self);
end;

procedure TMSHTMLHTMLElementEvents.Doonreadystatechange;
begin
  if not Assigned (onreadystatechange) then System.Exit;
  onreadystatechange (Self);
end;

procedure TMSHTMLHTMLElementEvents.Doonbeforeeditfocus;
begin
  if not Assigned (onbeforeeditfocus) then System.Exit;
  onbeforeeditfocus (Self);
end;

procedure TMSHTMLHTMLElementEvents.Doonlayoutcomplete;
begin
  if not Assigned (onlayoutcomplete) then System.Exit;
  onlayoutcomplete (Self);
end;

procedure TMSHTMLHTMLElementEvents.Doonpage;
begin
  if not Assigned (onpage) then System.Exit;
  onpage (Self);
end;

function TMSHTMLHTMLElementEvents.Doonbeforedeactivate: WordBool;
begin
  if not Assigned (onbeforedeactivate) then System.Exit;
  Result := onbeforedeactivate (Self);
end;

function TMSHTMLHTMLElementEvents.Doonbeforeactivate: WordBool;
begin
  if not Assigned (onbeforeactivate) then System.Exit;
  Result := onbeforeactivate (Self);
end;

procedure TMSHTMLHTMLElementEvents.Doonmove;
begin
  if not Assigned (onmove) then System.Exit;
  onmove (Self);
end;

function TMSHTMLHTMLElementEvents.Dooncontrolselect: WordBool;
begin
  if not Assigned (oncontrolselect) then System.Exit;
  Result := oncontrolselect (Self);
end;

function TMSHTMLHTMLElementEvents.Doonmovestart: WordBool;
begin
  if not Assigned (onmovestart) then System.Exit;
  Result := onmovestart (Self);
end;

procedure TMSHTMLHTMLElementEvents.Doonmoveend;
begin
  if not Assigned (onmoveend) then System.Exit;
  onmoveend (Self);
end;

function TMSHTMLHTMLElementEvents.Doonresizestart: WordBool;
begin
  if not Assigned (onresizestart) then System.Exit;
  Result := onresizestart (Self);
end;

procedure TMSHTMLHTMLElementEvents.Doonresizeend;
begin
  if not Assigned (onresizeend) then System.Exit;
  onresizeend (Self);
end;

procedure TMSHTMLHTMLElementEvents.Doonmouseenter;
begin
  if not Assigned (onmouseenter) then System.Exit;
  onmouseenter (Self);
end;

procedure TMSHTMLHTMLElementEvents.Doonmouseleave;
begin
  if not Assigned (onmouseleave) then System.Exit;
  onmouseleave (Self);
end;

function TMSHTMLHTMLElementEvents.Doonmousewheel: WordBool;
begin
  if not Assigned (onmousewheel) then System.Exit;
  Result := onmousewheel (Self);
end;

procedure TMSHTMLHTMLElementEvents.Doonactivate;
begin
  if not Assigned (onactivate) then System.Exit;
  onactivate (Self);
end;

procedure TMSHTMLHTMLElementEvents.Doondeactivate;
begin
  if not Assigned (ondeactivate) then System.Exit;
  ondeactivate (Self);
end;

procedure TMSHTMLHTMLElementEvents.Doonfocusin;
begin
  if not Assigned (onfocusin) then System.Exit;
  onfocusin (Self);
end;

procedure TMSHTMLHTMLElementEvents.Doonfocusout;
begin
  if not Assigned (onfocusout) then System.Exit;
  onfocusout (Self);
end;



function TMSHTMLHTMLElementEvents2.DoInvoke (DispID: Integer; const IID: TGUID; LocaleID: Integer;
  Flags: Word; var dps: TDispParams; pDispIds: PDispIdList;
  VarResult, ExcepInfo, ArgErr: Pointer): HResult;
type
  POleVariant = ^OleVariant;
begin
  Result := DISP_E_MEMBERNOTFOUND;

  //SinkInvoke//
    case DispId of
      -2147418102 :
      begin
        OleVariant (VarResult^) := Doonhelp (IUnknown (dps.rgvarg^ [pDispIds^ [0]].unkval) as IHTMLEventObj);
        Result := S_OK;
      end;
      -600 :
      begin
        OleVariant (VarResult^) := Doonclick (IUnknown (dps.rgvarg^ [pDispIds^ [0]].unkval) as IHTMLEventObj);
        Result := S_OK;
      end;
      -601 :
      begin
        OleVariant (VarResult^) := Doondblclick (IUnknown (dps.rgvarg^ [pDispIds^ [0]].unkval) as IHTMLEventObj);
        Result := S_OK;
      end;
      -603 :
      begin
        OleVariant (VarResult^) := Doonkeypress (IUnknown (dps.rgvarg^ [pDispIds^ [0]].unkval) as IHTMLEventObj);
        Result := S_OK;
      end;
      -602 :
      begin
        Doonkeydown (IUnknown (dps.rgvarg^ [pDispIds^ [0]].unkval) as IHTMLEventObj);
        Result := S_OK;
      end;
      -604 :
      begin
        Doonkeyup (IUnknown (dps.rgvarg^ [pDispIds^ [0]].unkval) as IHTMLEventObj);
        Result := S_OK;
      end;
      -2147418103 :
      begin
        Doonmouseout (IUnknown (dps.rgvarg^ [pDispIds^ [0]].unkval) as IHTMLEventObj);
        Result := S_OK;
      end;
      -2147418104 :
      begin
        Doonmouseover (IUnknown (dps.rgvarg^ [pDispIds^ [0]].unkval) as IHTMLEventObj);
        Result := S_OK;
      end;
      -606 :
      begin
        Doonmousemove (IUnknown (dps.rgvarg^ [pDispIds^ [0]].unkval) as IHTMLEventObj);
        Result := S_OK;
      end;
      -605 :
      begin
        Doonmousedown (IUnknown (dps.rgvarg^ [pDispIds^ [0]].unkval) as IHTMLEventObj);
        Result := S_OK;
      end;
      -607 :
      begin
        Doonmouseup (IUnknown (dps.rgvarg^ [pDispIds^ [0]].unkval) as IHTMLEventObj);
        Result := S_OK;
      end;
      -2147418100 :
      begin
        OleVariant (VarResult^) := Doonselectstart (IUnknown (dps.rgvarg^ [pDispIds^ [0]].unkval) as IHTMLEventObj);
        Result := S_OK;
      end;
      -2147418095 :
      begin
        Doonfilterchange (IUnknown (dps.rgvarg^ [pDispIds^ [0]].unkval) as IHTMLEventObj);
        Result := S_OK;
      end;
      -2147418101 :
      begin
        OleVariant (VarResult^) := Doondragstart (IUnknown (dps.rgvarg^ [pDispIds^ [0]].unkval) as IHTMLEventObj);
        Result := S_OK;
      end;
      -2147418108 :
      begin
        OleVariant (VarResult^) := Doonbeforeupdate (IUnknown (dps.rgvarg^ [pDispIds^ [0]].unkval) as IHTMLEventObj);
        Result := S_OK;
      end;
      -2147418107 :
      begin
        Doonafterupdate (IUnknown (dps.rgvarg^ [pDispIds^ [0]].unkval) as IHTMLEventObj);
        Result := S_OK;
      end;
      -2147418099 :
      begin
        OleVariant (VarResult^) := Doonerrorupdate (IUnknown (dps.rgvarg^ [pDispIds^ [0]].unkval) as IHTMLEventObj);
        Result := S_OK;
      end;
      -2147418106 :
      begin
        OleVariant (VarResult^) := Doonrowexit (IUnknown (dps.rgvarg^ [pDispIds^ [0]].unkval) as IHTMLEventObj);
        Result := S_OK;
      end;
      -2147418105 :
      begin
        Doonrowenter (IUnknown (dps.rgvarg^ [pDispIds^ [0]].unkval) as IHTMLEventObj);
        Result := S_OK;
      end;
      -2147418098 :
      begin
        Doondatasetchanged (IUnknown (dps.rgvarg^ [pDispIds^ [0]].unkval) as IHTMLEventObj);
        Result := S_OK;
      end;
      -2147418097 :
      begin
        Doondataavailable (IUnknown (dps.rgvarg^ [pDispIds^ [0]].unkval) as IHTMLEventObj);
        Result := S_OK;
      end;
      -2147418096 :
      begin
        Doondatasetcomplete (IUnknown (dps.rgvarg^ [pDispIds^ [0]].unkval) as IHTMLEventObj);
        Result := S_OK;
      end;
      -2147418094 :
      begin
        Doonlosecapture (IUnknown (dps.rgvarg^ [pDispIds^ [0]].unkval) as IHTMLEventObj);
        Result := S_OK;
      end;
      -2147418093 :
      begin
        Doonpropertychange (IUnknown (dps.rgvarg^ [pDispIds^ [0]].unkval) as IHTMLEventObj);
        Result := S_OK;
      end;
      1014 :
      begin
        Doonscroll (IUnknown (dps.rgvarg^ [pDispIds^ [0]].unkval) as IHTMLEventObj);
        Result := S_OK;
      end;
      -2147418111 :
      begin
        Doonfocus (IUnknown (dps.rgvarg^ [pDispIds^ [0]].unkval) as IHTMLEventObj);
        Result := S_OK;
      end;
      -2147418112 :
      begin
        Doonblur (IUnknown (dps.rgvarg^ [pDispIds^ [0]].unkval) as IHTMLEventObj);
        Result := S_OK;
      end;
      1016 :
      begin
        Doonresize (IUnknown (dps.rgvarg^ [pDispIds^ [0]].unkval) as IHTMLEventObj);
        Result := S_OK;
      end;
      -2147418092 :
      begin
        OleVariant (VarResult^) := Doondrag (IUnknown (dps.rgvarg^ [pDispIds^ [0]].unkval) as IHTMLEventObj);
        Result := S_OK;
      end;
      -2147418091 :
      begin
        Doondragend (IUnknown (dps.rgvarg^ [pDispIds^ [0]].unkval) as IHTMLEventObj);
        Result := S_OK;
      end;
      -2147418090 :
      begin
        OleVariant (VarResult^) := Doondragenter (IUnknown (dps.rgvarg^ [pDispIds^ [0]].unkval) as IHTMLEventObj);
        Result := S_OK;
      end;
      -2147418089 :
      begin
        OleVariant (VarResult^) := Doondragover (IUnknown (dps.rgvarg^ [pDispIds^ [0]].unkval) as IHTMLEventObj);
        Result := S_OK;
      end;
      -2147418088 :
      begin
        Doondragleave (IUnknown (dps.rgvarg^ [pDispIds^ [0]].unkval) as IHTMLEventObj);
        Result := S_OK;
      end;
      -2147418087 :
      begin
        OleVariant (VarResult^) := Doondrop (IUnknown (dps.rgvarg^ [pDispIds^ [0]].unkval) as IHTMLEventObj);
        Result := S_OK;
      end;
      -2147418083 :
      begin
        OleVariant (VarResult^) := Doonbeforecut (IUnknown (dps.rgvarg^ [pDispIds^ [0]].unkval) as IHTMLEventObj);
        Result := S_OK;
      end;
      -2147418086 :
      begin
        OleVariant (VarResult^) := Dooncut (IUnknown (dps.rgvarg^ [pDispIds^ [0]].unkval) as IHTMLEventObj);
        Result := S_OK;
      end;
      -2147418082 :
      begin
        OleVariant (VarResult^) := Doonbeforecopy (IUnknown (dps.rgvarg^ [pDispIds^ [0]].unkval) as IHTMLEventObj);
        Result := S_OK;
      end;
      -2147418085 :
      begin
        OleVariant (VarResult^) := Dooncopy (IUnknown (dps.rgvarg^ [pDispIds^ [0]].unkval) as IHTMLEventObj);
        Result := S_OK;
      end;
      -2147418081 :
      begin
        OleVariant (VarResult^) := Doonbeforepaste (IUnknown (dps.rgvarg^ [pDispIds^ [0]].unkval) as IHTMLEventObj);
        Result := S_OK;
      end;
      -2147418084 :
      begin
        OleVariant (VarResult^) := Doonpaste (IUnknown (dps.rgvarg^ [pDispIds^ [0]].unkval) as IHTMLEventObj);
        Result := S_OK;
      end;
      1023 :
      begin
        OleVariant (VarResult^) := Dooncontextmenu (IUnknown (dps.rgvarg^ [pDispIds^ [0]].unkval) as IHTMLEventObj);
        Result := S_OK;
      end;
      -2147418080 :
      begin
        Doonrowsdelete (IUnknown (dps.rgvarg^ [pDispIds^ [0]].unkval) as IHTMLEventObj);
        Result := S_OK;
      end;
      -2147418079 :
      begin
        Doonrowsinserted (IUnknown (dps.rgvarg^ [pDispIds^ [0]].unkval) as IHTMLEventObj);
        Result := S_OK;
      end;
      -2147418078 :
      begin
        Dooncellchange (IUnknown (dps.rgvarg^ [pDispIds^ [0]].unkval) as IHTMLEventObj);
        Result := S_OK;
      end;
      -609 :
      begin
        Doonreadystatechange (IUnknown (dps.rgvarg^ [pDispIds^ [0]].unkval) as IHTMLEventObj);
        Result := S_OK;
      end;
      1030 :
      begin
        Doonlayoutcomplete (IUnknown (dps.rgvarg^ [pDispIds^ [0]].unkval) as IHTMLEventObj);
        Result := S_OK;
      end;
      1031 :
      begin
        Doonpage (IUnknown (dps.rgvarg^ [pDispIds^ [0]].unkval) as IHTMLEventObj);
        Result := S_OK;
      end;
      1042 :
      begin
        Doonmouseenter (IUnknown (dps.rgvarg^ [pDispIds^ [0]].unkval) as IHTMLEventObj);
        Result := S_OK;
      end;
      1043 :
      begin
        Doonmouseleave (IUnknown (dps.rgvarg^ [pDispIds^ [0]].unkval) as IHTMLEventObj);
        Result := S_OK;
      end;
      1044 :
      begin
        Doonactivate (IUnknown (dps.rgvarg^ [pDispIds^ [0]].unkval) as IHTMLEventObj);
        Result := S_OK;
      end;
      1045 :
      begin
        Doondeactivate (IUnknown (dps.rgvarg^ [pDispIds^ [0]].unkval) as IHTMLEventObj);
        Result := S_OK;
      end;
      1034 :
      begin
        OleVariant (VarResult^) := Doonbeforedeactivate (IUnknown (dps.rgvarg^ [pDispIds^ [0]].unkval) as IHTMLEventObj);
        Result := S_OK;
      end;
      1047 :
      begin
        OleVariant (VarResult^) := Doonbeforeactivate (IUnknown (dps.rgvarg^ [pDispIds^ [0]].unkval) as IHTMLEventObj);
        Result := S_OK;
      end;
      1048 :
      begin
        Doonfocusin (IUnknown (dps.rgvarg^ [pDispIds^ [0]].unkval) as IHTMLEventObj);
        Result := S_OK;
      end;
      1049 :
      begin
        Doonfocusout (IUnknown (dps.rgvarg^ [pDispIds^ [0]].unkval) as IHTMLEventObj);
        Result := S_OK;
      end;
      1035 :
      begin
        Doonmove (IUnknown (dps.rgvarg^ [pDispIds^ [0]].unkval) as IHTMLEventObj);
        Result := S_OK;
      end;
      1036 :
      begin
        OleVariant (VarResult^) := Dooncontrolselect (IUnknown (dps.rgvarg^ [pDispIds^ [0]].unkval) as IHTMLEventObj);
        Result := S_OK;
      end;
      1038 :
      begin
        OleVariant (VarResult^) := Doonmovestart (IUnknown (dps.rgvarg^ [pDispIds^ [0]].unkval) as IHTMLEventObj);
        Result := S_OK;
      end;
      1039 :
      begin
        Doonmoveend (IUnknown (dps.rgvarg^ [pDispIds^ [0]].unkval) as IHTMLEventObj);
        Result := S_OK;
      end;
      1040 :
      begin
        OleVariant (VarResult^) := Doonresizestart (IUnknown (dps.rgvarg^ [pDispIds^ [0]].unkval) as IHTMLEventObj);
        Result := S_OK;
      end;
      1041 :
      begin
        Doonresizeend (IUnknown (dps.rgvarg^ [pDispIds^ [0]].unkval) as IHTMLEventObj);
        Result := S_OK;
      end;
      1033 :
      begin
        OleVariant (VarResult^) := Doonmousewheel (IUnknown (dps.rgvarg^ [pDispIds^ [0]].unkval) as IHTMLEventObj);
        Result := S_OK;
      end;
    end;  { case }
  //SinkInvokeEnd//
end;

constructor TMSHTMLHTMLElementEvents2.Create (AOwner: TComponent);
begin
  inherited Create (AOwner);
  //SinkInit//
  FSinkIID := HTMLElementEvents2;
end;

//SinkImplementation//
function TMSHTMLHTMLElementEvents2.Doonhelp(const pEvtObj: IHTMLEventObj): WordBool;
begin
  if not Assigned (onhelp) then System.Exit;
  Result := onhelp (Self, pEvtObj);
end;

function TMSHTMLHTMLElementEvents2.Doonclick(const pEvtObj: IHTMLEventObj): WordBool;
begin
  if not Assigned (onclick) then System.Exit;
  Result := onclick (Self, pEvtObj);
end;

function TMSHTMLHTMLElementEvents2.Doondblclick(const pEvtObj: IHTMLEventObj): WordBool;
begin
  if not Assigned (ondblclick) then System.Exit;
  Result := ondblclick (Self, pEvtObj);
end;

function TMSHTMLHTMLElementEvents2.Doonkeypress(const pEvtObj: IHTMLEventObj): WordBool;
begin
  if not Assigned (onkeypress) then System.Exit;
  Result := onkeypress (Self, pEvtObj);
end;

procedure TMSHTMLHTMLElementEvents2.Doonkeydown(const pEvtObj: IHTMLEventObj);
begin
  if not Assigned (onkeydown) then System.Exit;
  onkeydown (Self, pEvtObj);
end;

procedure TMSHTMLHTMLElementEvents2.Doonkeyup(const pEvtObj: IHTMLEventObj);
begin
  if not Assigned (onkeyup) then System.Exit;
  onkeyup (Self, pEvtObj);
end;

procedure TMSHTMLHTMLElementEvents2.Doonmouseout(const pEvtObj: IHTMLEventObj);
begin
  if not Assigned (onmouseout) then System.Exit;
  onmouseout (Self, pEvtObj);
end;

procedure TMSHTMLHTMLElementEvents2.Doonmouseover(const pEvtObj: IHTMLEventObj);
begin
  if not Assigned (onmouseover) then System.Exit;
  onmouseover (Self, pEvtObj);
end;

procedure TMSHTMLHTMLElementEvents2.Doonmousemove(const pEvtObj: IHTMLEventObj);
begin
  if not Assigned (onmousemove) then System.Exit;
  onmousemove (Self, pEvtObj);
end;

procedure TMSHTMLHTMLElementEvents2.Doonmousedown(const pEvtObj: IHTMLEventObj);
begin
  if not Assigned (onmousedown) then System.Exit;
  onmousedown (Self, pEvtObj);
end;

procedure TMSHTMLHTMLElementEvents2.Doonmouseup(const pEvtObj: IHTMLEventObj);
begin
  if not Assigned (onmouseup) then System.Exit;
  onmouseup (Self, pEvtObj);
end;

function TMSHTMLHTMLElementEvents2.Doonselectstart(const pEvtObj: IHTMLEventObj): WordBool;
begin
  if not Assigned (onselectstart) then System.Exit;
  Result := onselectstart (Self, pEvtObj);
end;

procedure TMSHTMLHTMLElementEvents2.Doonfilterchange(const pEvtObj: IHTMLEventObj);
begin
  if not Assigned (onfilterchange) then System.Exit;
  onfilterchange (Self, pEvtObj);
end;

function TMSHTMLHTMLElementEvents2.Doondragstart(const pEvtObj: IHTMLEventObj): WordBool;
begin
  if not Assigned (ondragstart) then System.Exit;
  Result := ondragstart (Self, pEvtObj);
end;

function TMSHTMLHTMLElementEvents2.Doonbeforeupdate(const pEvtObj: IHTMLEventObj): WordBool;
begin
  if not Assigned (onbeforeupdate) then System.Exit;
  Result := onbeforeupdate (Self, pEvtObj);
end;

procedure TMSHTMLHTMLElementEvents2.Doonafterupdate(const pEvtObj: IHTMLEventObj);
begin
  if not Assigned (onafterupdate) then System.Exit;
  onafterupdate (Self, pEvtObj);
end;

function TMSHTMLHTMLElementEvents2.Doonerrorupdate(const pEvtObj: IHTMLEventObj): WordBool;
begin
  if not Assigned (onerrorupdate) then System.Exit;
  Result := onerrorupdate (Self, pEvtObj);
end;

function TMSHTMLHTMLElementEvents2.Doonrowexit(const pEvtObj: IHTMLEventObj): WordBool;
begin
  if not Assigned (onrowexit) then System.Exit;
  Result := onrowexit (Self, pEvtObj);
end;

procedure TMSHTMLHTMLElementEvents2.Doonrowenter(const pEvtObj: IHTMLEventObj);
begin
  if not Assigned (onrowenter) then System.Exit;
  onrowenter (Self, pEvtObj);
end;

procedure TMSHTMLHTMLElementEvents2.Doondatasetchanged(const pEvtObj: IHTMLEventObj);
begin
  if not Assigned (ondatasetchanged) then System.Exit;
  ondatasetchanged (Self, pEvtObj);
end;

procedure TMSHTMLHTMLElementEvents2.Doondataavailable(const pEvtObj: IHTMLEventObj);
begin
  if not Assigned (ondataavailable) then System.Exit;
  ondataavailable (Self, pEvtObj);
end;

procedure TMSHTMLHTMLElementEvents2.Doondatasetcomplete(const pEvtObj: IHTMLEventObj);
begin
  if not Assigned (ondatasetcomplete) then System.Exit;
  ondatasetcomplete (Self, pEvtObj);
end;

procedure TMSHTMLHTMLElementEvents2.Doonlosecapture(const pEvtObj: IHTMLEventObj);
begin
  if not Assigned (onlosecapture) then System.Exit;
  onlosecapture (Self, pEvtObj);
end;

procedure TMSHTMLHTMLElementEvents2.Doonpropertychange(const pEvtObj: IHTMLEventObj);
begin
  if not Assigned (onpropertychange) then System.Exit;
  onpropertychange (Self, pEvtObj);
end;

procedure TMSHTMLHTMLElementEvents2.Doonscroll(const pEvtObj: IHTMLEventObj);
begin
  if not Assigned (onscroll) then System.Exit;
  onscroll (Self, pEvtObj);
end;

procedure TMSHTMLHTMLElementEvents2.Doonfocus(const pEvtObj: IHTMLEventObj);
begin
  if not Assigned (onfocus) then System.Exit;
  onfocus (Self, pEvtObj);
end;

procedure TMSHTMLHTMLElementEvents2.Doonblur(const pEvtObj: IHTMLEventObj);
begin
  if not Assigned (onblur) then System.Exit;
  onblur (Self, pEvtObj);
end;

procedure TMSHTMLHTMLElementEvents2.Doonresize(const pEvtObj: IHTMLEventObj);
begin
  if not Assigned (onresize) then System.Exit;
  onresize (Self, pEvtObj);
end;

function TMSHTMLHTMLElementEvents2.Doondrag(const pEvtObj: IHTMLEventObj): WordBool;
begin
  if not Assigned (ondrag) then System.Exit;
  Result := ondrag (Self, pEvtObj);
end;

procedure TMSHTMLHTMLElementEvents2.Doondragend(const pEvtObj: IHTMLEventObj);
begin
  if not Assigned (ondragend) then System.Exit;
  ondragend (Self, pEvtObj);
end;

function TMSHTMLHTMLElementEvents2.Doondragenter(const pEvtObj: IHTMLEventObj): WordBool;
begin
  if not Assigned (ondragenter) then System.Exit;
  Result := ondragenter (Self, pEvtObj);
end;

function TMSHTMLHTMLElementEvents2.Doondragover(const pEvtObj: IHTMLEventObj): WordBool;
begin
  if not Assigned (ondragover) then System.Exit;
  Result := ondragover (Self, pEvtObj);
end;

procedure TMSHTMLHTMLElementEvents2.Doondragleave(const pEvtObj: IHTMLEventObj);
begin
  if not Assigned (ondragleave) then System.Exit;
  ondragleave (Self, pEvtObj);
end;

function TMSHTMLHTMLElementEvents2.Doondrop(const pEvtObj: IHTMLEventObj): WordBool;
begin
  if not Assigned (ondrop) then System.Exit;
  Result := ondrop (Self, pEvtObj);
end;

function TMSHTMLHTMLElementEvents2.Doonbeforecut(const pEvtObj: IHTMLEventObj): WordBool;
begin
  if not Assigned (onbeforecut) then System.Exit;
  Result := onbeforecut (Self, pEvtObj);
end;

function TMSHTMLHTMLElementEvents2.Dooncut(const pEvtObj: IHTMLEventObj): WordBool;
begin
  if not Assigned (oncut) then System.Exit;
  Result := oncut (Self, pEvtObj);
end;

function TMSHTMLHTMLElementEvents2.Doonbeforecopy(const pEvtObj: IHTMLEventObj): WordBool;
begin
  if not Assigned (onbeforecopy) then System.Exit;
  Result := onbeforecopy (Self, pEvtObj);
end;

function TMSHTMLHTMLElementEvents2.Dooncopy(const pEvtObj: IHTMLEventObj): WordBool;
begin
  if not Assigned (oncopy) then System.Exit;
  Result := oncopy (Self, pEvtObj);
end;

function TMSHTMLHTMLElementEvents2.Doonbeforepaste(const pEvtObj: IHTMLEventObj): WordBool;
begin
  if not Assigned (onbeforepaste) then System.Exit;
  Result := onbeforepaste (Self, pEvtObj);
end;

function TMSHTMLHTMLElementEvents2.Doonpaste(const pEvtObj: IHTMLEventObj): WordBool;
begin
  if not Assigned (onpaste) then System.Exit;
  Result := onpaste (Self, pEvtObj);
end;

function TMSHTMLHTMLElementEvents2.Dooncontextmenu(const pEvtObj: IHTMLEventObj): WordBool;
begin
  if not Assigned (oncontextmenu) then System.Exit;
  Result := oncontextmenu (Self, pEvtObj);
end;

procedure TMSHTMLHTMLElementEvents2.Doonrowsdelete(const pEvtObj: IHTMLEventObj);
begin
  if not Assigned (onrowsdelete) then System.Exit;
  onrowsdelete (Self, pEvtObj);
end;

procedure TMSHTMLHTMLElementEvents2.Doonrowsinserted(const pEvtObj: IHTMLEventObj);
begin
  if not Assigned (onrowsinserted) then System.Exit;
  onrowsinserted (Self, pEvtObj);
end;

procedure TMSHTMLHTMLElementEvents2.Dooncellchange(const pEvtObj: IHTMLEventObj);
begin
  if not Assigned (oncellchange) then System.Exit;
  oncellchange (Self, pEvtObj);
end;

procedure TMSHTMLHTMLElementEvents2.Doonreadystatechange(const pEvtObj: IHTMLEventObj);
begin
  if not Assigned (onreadystatechange) then System.Exit;
  onreadystatechange (Self, pEvtObj);
end;

procedure TMSHTMLHTMLElementEvents2.Doonlayoutcomplete(const pEvtObj: IHTMLEventObj);
begin
  if not Assigned (onlayoutcomplete) then System.Exit;
  onlayoutcomplete (Self, pEvtObj);
end;

procedure TMSHTMLHTMLElementEvents2.Doonpage(const pEvtObj: IHTMLEventObj);
begin
  if not Assigned (onpage) then System.Exit;
  onpage (Self, pEvtObj);
end;

procedure TMSHTMLHTMLElementEvents2.Doonmouseenter(const pEvtObj: IHTMLEventObj);
begin
  if not Assigned (onmouseenter) then System.Exit;
  onmouseenter (Self, pEvtObj);
end;

procedure TMSHTMLHTMLElementEvents2.Doonmouseleave(const pEvtObj: IHTMLEventObj);
begin
  if not Assigned (onmouseleave) then System.Exit;
  onmouseleave (Self, pEvtObj);
end;

procedure TMSHTMLHTMLElementEvents2.Doonactivate(const pEvtObj: IHTMLEventObj);
begin
  if not Assigned (onactivate) then System.Exit;
  onactivate (Self, pEvtObj);
end;

procedure TMSHTMLHTMLElementEvents2.Doondeactivate(const pEvtObj: IHTMLEventObj);
begin
  if not Assigned (ondeactivate) then System.Exit;
  ondeactivate (Self, pEvtObj);
end;

function TMSHTMLHTMLElementEvents2.Doonbeforedeactivate(const pEvtObj: IHTMLEventObj): WordBool;
begin
  if not Assigned (onbeforedeactivate) then System.Exit;
  Result := onbeforedeactivate (Self, pEvtObj);
end;

function TMSHTMLHTMLElementEvents2.Doonbeforeactivate(const pEvtObj: IHTMLEventObj): WordBool;
begin
  if not Assigned (onbeforeactivate) then System.Exit;
  Result := onbeforeactivate (Self, pEvtObj);
end;

procedure TMSHTMLHTMLElementEvents2.Doonfocusin(const pEvtObj: IHTMLEventObj);
begin
  if not Assigned (onfocusin) then System.Exit;
  onfocusin (Self, pEvtObj);
end;

procedure TMSHTMLHTMLElementEvents2.Doonfocusout(const pEvtObj: IHTMLEventObj);
begin
  if not Assigned (onfocusout) then System.Exit;
  onfocusout (Self, pEvtObj);
end;

procedure TMSHTMLHTMLElementEvents2.Doonmove(const pEvtObj: IHTMLEventObj);
begin
  if not Assigned (onmove) then System.Exit;
  onmove (Self, pEvtObj);
end;

function TMSHTMLHTMLElementEvents2.Dooncontrolselect(const pEvtObj: IHTMLEventObj): WordBool;
begin
  if not Assigned (oncontrolselect) then System.Exit;
  Result := oncontrolselect (Self, pEvtObj);
end;

function TMSHTMLHTMLElementEvents2.Doonmovestart(const pEvtObj: IHTMLEventObj): WordBool;
begin
  if not Assigned (onmovestart) then System.Exit;
  Result := onmovestart (Self, pEvtObj);
end;

procedure TMSHTMLHTMLElementEvents2.Doonmoveend(const pEvtObj: IHTMLEventObj);
begin
  if not Assigned (onmoveend) then System.Exit;
  onmoveend (Self, pEvtObj);
end;

function TMSHTMLHTMLElementEvents2.Doonresizestart(const pEvtObj: IHTMLEventObj): WordBool;
begin
  if not Assigned (onresizestart) then System.Exit;
  Result := onresizestart (Self, pEvtObj);
end;

procedure TMSHTMLHTMLElementEvents2.Doonresizeend(const pEvtObj: IHTMLEventObj);
begin
  if not Assigned (onresizeend) then System.Exit;
  onresizeend (Self, pEvtObj);
end;

function TMSHTMLHTMLElementEvents2.Doonmousewheel(const pEvtObj: IHTMLEventObj): WordBool;
begin
  if not Assigned (onmousewheel) then System.Exit;
  Result := onmousewheel (Self, pEvtObj);
end;



function TMSHTMLHTMLButtonElementEvents2.DoInvoke (DispID: Integer; const IID: TGUID; LocaleID: Integer;
  Flags: Word; var dps: TDispParams; pDispIds: PDispIdList;
  VarResult, ExcepInfo, ArgErr: Pointer): HResult;
type
  POleVariant = ^OleVariant;
begin
  Result := DISP_E_MEMBERNOTFOUND;

  //SinkInvoke//
    case DispId of
      -2147418102 :
      begin
        OleVariant (VarResult^) := Doonhelp (IUnknown (dps.rgvarg^ [pDispIds^ [0]].unkval) as IHTMLEventObj);
        Result := S_OK;
      end;
      -600 :
      begin
        OleVariant (VarResult^) := Doonclick (IUnknown (dps.rgvarg^ [pDispIds^ [0]].unkval) as IHTMLEventObj);
        Result := S_OK;
      end;
      -601 :
      begin
        OleVariant (VarResult^) := Doondblclick (IUnknown (dps.rgvarg^ [pDispIds^ [0]].unkval) as IHTMLEventObj);
        Result := S_OK;
      end;
      -603 :
      begin
        OleVariant (VarResult^) := Doonkeypress (IUnknown (dps.rgvarg^ [pDispIds^ [0]].unkval) as IHTMLEventObj);
        Result := S_OK;
      end;
      -602 :
      begin
        Doonkeydown (IUnknown (dps.rgvarg^ [pDispIds^ [0]].unkval) as IHTMLEventObj);
        Result := S_OK;
      end;
      -604 :
      begin
        Doonkeyup (IUnknown (dps.rgvarg^ [pDispIds^ [0]].unkval) as IHTMLEventObj);
        Result := S_OK;
      end;
      -2147418103 :
      begin
        Doonmouseout (IUnknown (dps.rgvarg^ [pDispIds^ [0]].unkval) as IHTMLEventObj);
        Result := S_OK;
      end;
      -2147418104 :
      begin
        Doonmouseover (IUnknown (dps.rgvarg^ [pDispIds^ [0]].unkval) as IHTMLEventObj);
        Result := S_OK;
      end;
      -606 :
      begin
        Doonmousemove (IUnknown (dps.rgvarg^ [pDispIds^ [0]].unkval) as IHTMLEventObj);
        Result := S_OK;
      end;
      -605 :
      begin
        Doonmousedown (IUnknown (dps.rgvarg^ [pDispIds^ [0]].unkval) as IHTMLEventObj);
        Result := S_OK;
      end;
      -607 :
      begin
        Doonmouseup (IUnknown (dps.rgvarg^ [pDispIds^ [0]].unkval) as IHTMLEventObj);
        Result := S_OK;
      end;
      -2147418100 :
      begin
        OleVariant (VarResult^) := Doonselectstart (IUnknown (dps.rgvarg^ [pDispIds^ [0]].unkval) as IHTMLEventObj);
        Result := S_OK;
      end;
      -2147418095 :
      begin
        Doonfilterchange (IUnknown (dps.rgvarg^ [pDispIds^ [0]].unkval) as IHTMLEventObj);
        Result := S_OK;
      end;
      -2147418101 :
      begin
        OleVariant (VarResult^) := Doondragstart (IUnknown (dps.rgvarg^ [pDispIds^ [0]].unkval) as IHTMLEventObj);
        Result := S_OK;
      end;
      -2147418108 :
      begin
        OleVariant (VarResult^) := Doonbeforeupdate (IUnknown (dps.rgvarg^ [pDispIds^ [0]].unkval) as IHTMLEventObj);
        Result := S_OK;
      end;
      -2147418107 :
      begin
        Doonafterupdate (IUnknown (dps.rgvarg^ [pDispIds^ [0]].unkval) as IHTMLEventObj);
        Result := S_OK;
      end;
      -2147418099 :
      begin
        OleVariant (VarResult^) := Doonerrorupdate (IUnknown (dps.rgvarg^ [pDispIds^ [0]].unkval) as IHTMLEventObj);
        Result := S_OK;
      end;
      -2147418106 :
      begin
        OleVariant (VarResult^) := Doonrowexit (IUnknown (dps.rgvarg^ [pDispIds^ [0]].unkval) as IHTMLEventObj);
        Result := S_OK;
      end;
      -2147418105 :
      begin
        Doonrowenter (IUnknown (dps.rgvarg^ [pDispIds^ [0]].unkval) as IHTMLEventObj);
        Result := S_OK;
      end;
      -2147418098 :
      begin
        Doondatasetchanged (IUnknown (dps.rgvarg^ [pDispIds^ [0]].unkval) as IHTMLEventObj);
        Result := S_OK;
      end;
      -2147418097 :
      begin
        Doondataavailable (IUnknown (dps.rgvarg^ [pDispIds^ [0]].unkval) as IHTMLEventObj);
        Result := S_OK;
      end;
      -2147418096 :
      begin
        Doondatasetcomplete (IUnknown (dps.rgvarg^ [pDispIds^ [0]].unkval) as IHTMLEventObj);
        Result := S_OK;
      end;
      -2147418094 :
      begin
        Doonlosecapture (IUnknown (dps.rgvarg^ [pDispIds^ [0]].unkval) as IHTMLEventObj);
        Result := S_OK;
      end;
      -2147418093 :
      begin
        Doonpropertychange (IUnknown (dps.rgvarg^ [pDispIds^ [0]].unkval) as IHTMLEventObj);
        Result := S_OK;
      end;
      1014 :
      begin
        Doonscroll (IUnknown (dps.rgvarg^ [pDispIds^ [0]].unkval) as IHTMLEventObj);
        Result := S_OK;
      end;
      -2147418111 :
      begin
        Doonfocus (IUnknown (dps.rgvarg^ [pDispIds^ [0]].unkval) as IHTMLEventObj);
        Result := S_OK;
      end;
      -2147418112 :
      begin
        Doonblur (IUnknown (dps.rgvarg^ [pDispIds^ [0]].unkval) as IHTMLEventObj);
        Result := S_OK;
      end;
      1016 :
      begin
        Doonresize (IUnknown (dps.rgvarg^ [pDispIds^ [0]].unkval) as IHTMLEventObj);
        Result := S_OK;
      end;
      -2147418092 :
      begin
        OleVariant (VarResult^) := Doondrag (IUnknown (dps.rgvarg^ [pDispIds^ [0]].unkval) as IHTMLEventObj);
        Result := S_OK;
      end;
      -2147418091 :
      begin
        Doondragend (IUnknown (dps.rgvarg^ [pDispIds^ [0]].unkval) as IHTMLEventObj);
        Result := S_OK;
      end;
      -2147418090 :
      begin
        OleVariant (VarResult^) := Doondragenter (IUnknown (dps.rgvarg^ [pDispIds^ [0]].unkval) as IHTMLEventObj);
        Result := S_OK;
      end;
      -2147418089 :
      begin
        OleVariant (VarResult^) := Doondragover (IUnknown (dps.rgvarg^ [pDispIds^ [0]].unkval) as IHTMLEventObj);
        Result := S_OK;
      end;
      -2147418088 :
      begin
        Doondragleave (IUnknown (dps.rgvarg^ [pDispIds^ [0]].unkval) as IHTMLEventObj);
        Result := S_OK;
      end;
      -2147418087 :
      begin
        OleVariant (VarResult^) := Doondrop (IUnknown (dps.rgvarg^ [pDispIds^ [0]].unkval) as IHTMLEventObj);
        Result := S_OK;
      end;
      -2147418083 :
      begin
        OleVariant (VarResult^) := Doonbeforecut (IUnknown (dps.rgvarg^ [pDispIds^ [0]].unkval) as IHTMLEventObj);
        Result := S_OK;
      end;
      -2147418086 :
      begin
        OleVariant (VarResult^) := Dooncut (IUnknown (dps.rgvarg^ [pDispIds^ [0]].unkval) as IHTMLEventObj);
        Result := S_OK;
      end;
      -2147418082 :
      begin
        OleVariant (VarResult^) := Doonbeforecopy (IUnknown (dps.rgvarg^ [pDispIds^ [0]].unkval) as IHTMLEventObj);
        Result := S_OK;
      end;
      -2147418085 :
      begin
        OleVariant (VarResult^) := Dooncopy (IUnknown (dps.rgvarg^ [pDispIds^ [0]].unkval) as IHTMLEventObj);
        Result := S_OK;
      end;
      -2147418081 :
      begin
        OleVariant (VarResult^) := Doonbeforepaste (IUnknown (dps.rgvarg^ [pDispIds^ [0]].unkval) as IHTMLEventObj);
        Result := S_OK;
      end;
      -2147418084 :
      begin
        OleVariant (VarResult^) := Doonpaste (IUnknown (dps.rgvarg^ [pDispIds^ [0]].unkval) as IHTMLEventObj);
        Result := S_OK;
      end;
      1023 :
      begin
        OleVariant (VarResult^) := Dooncontextmenu (IUnknown (dps.rgvarg^ [pDispIds^ [0]].unkval) as IHTMLEventObj);
        Result := S_OK;
      end;
      -2147418080 :
      begin
        Doonrowsdelete (IUnknown (dps.rgvarg^ [pDispIds^ [0]].unkval) as IHTMLEventObj);
        Result := S_OK;
      end;
      -2147418079 :
      begin
        Doonrowsinserted (IUnknown (dps.rgvarg^ [pDispIds^ [0]].unkval) as IHTMLEventObj);
        Result := S_OK;
      end;
      -2147418078 :
      begin
        Dooncellchange (IUnknown (dps.rgvarg^ [pDispIds^ [0]].unkval) as IHTMLEventObj);
        Result := S_OK;
      end;
      -609 :
      begin
        Doonreadystatechange (IUnknown (dps.rgvarg^ [pDispIds^ [0]].unkval) as IHTMLEventObj);
        Result := S_OK;
      end;
      1030 :
      begin
        Doonlayoutcomplete (IUnknown (dps.rgvarg^ [pDispIds^ [0]].unkval) as IHTMLEventObj);
        Result := S_OK;
      end;
      1031 :
      begin
        Doonpage (IUnknown (dps.rgvarg^ [pDispIds^ [0]].unkval) as IHTMLEventObj);
        Result := S_OK;
      end;
      1042 :
      begin
        Doonmouseenter (IUnknown (dps.rgvarg^ [pDispIds^ [0]].unkval) as IHTMLEventObj);
        Result := S_OK;
      end;
      1043 :
      begin
        Doonmouseleave (IUnknown (dps.rgvarg^ [pDispIds^ [0]].unkval) as IHTMLEventObj);
        Result := S_OK;
      end;
      1044 :
      begin
        Doonactivate (IUnknown (dps.rgvarg^ [pDispIds^ [0]].unkval) as IHTMLEventObj);
        Result := S_OK;
      end;
      1045 :
      begin
        Doondeactivate (IUnknown (dps.rgvarg^ [pDispIds^ [0]].unkval) as IHTMLEventObj);
        Result := S_OK;
      end;
      1034 :
      begin
        OleVariant (VarResult^) := Doonbeforedeactivate (IUnknown (dps.rgvarg^ [pDispIds^ [0]].unkval) as IHTMLEventObj);
        Result := S_OK;
      end;
      1047 :
      begin
        OleVariant (VarResult^) := Doonbeforeactivate (IUnknown (dps.rgvarg^ [pDispIds^ [0]].unkval) as IHTMLEventObj);
        Result := S_OK;
      end;
      1048 :
      begin
        Doonfocusin (IUnknown (dps.rgvarg^ [pDispIds^ [0]].unkval) as IHTMLEventObj);
        Result := S_OK;
      end;
      1049 :
      begin
        Doonfocusout (IUnknown (dps.rgvarg^ [pDispIds^ [0]].unkval) as IHTMLEventObj);
        Result := S_OK;
      end;
      1035 :
      begin
        Doonmove (IUnknown (dps.rgvarg^ [pDispIds^ [0]].unkval) as IHTMLEventObj);
        Result := S_OK;
      end;
      1036 :
      begin
        OleVariant (VarResult^) := Dooncontrolselect (IUnknown (dps.rgvarg^ [pDispIds^ [0]].unkval) as IHTMLEventObj);
        Result := S_OK;
      end;
      1038 :
      begin
        OleVariant (VarResult^) := Doonmovestart (IUnknown (dps.rgvarg^ [pDispIds^ [0]].unkval) as IHTMLEventObj);
        Result := S_OK;
      end;
      1039 :
      begin
        Doonmoveend (IUnknown (dps.rgvarg^ [pDispIds^ [0]].unkval) as IHTMLEventObj);
        Result := S_OK;
      end;
      1040 :
      begin
        OleVariant (VarResult^) := Doonresizestart (IUnknown (dps.rgvarg^ [pDispIds^ [0]].unkval) as IHTMLEventObj);
        Result := S_OK;
      end;
      1041 :
      begin
        Doonresizeend (IUnknown (dps.rgvarg^ [pDispIds^ [0]].unkval) as IHTMLEventObj);
        Result := S_OK;
      end;
      1033 :
      begin
        OleVariant (VarResult^) := Doonmousewheel (IUnknown (dps.rgvarg^ [pDispIds^ [0]].unkval) as IHTMLEventObj);
        Result := S_OK;
      end;
    end;  { case }
  //SinkInvokeEnd//
end;

constructor TMSHTMLHTMLButtonElementEvents2.Create (AOwner: TComponent);
begin
  inherited Create (AOwner);
  //SinkInit//
  FSinkIID := HTMLButtonElementEvents2;
end;

//SinkImplementation//
function TMSHTMLHTMLButtonElementEvents2.Doonhelp(const pEvtObj: IHTMLEventObj): WordBool;
begin
  if not Assigned (onhelp) then System.Exit;
  Result := onhelp (Self, pEvtObj);
end;

function TMSHTMLHTMLButtonElementEvents2.Doonclick(const pEvtObj: IHTMLEventObj): WordBool;
begin
  if not Assigned (onclick) then System.Exit;
  Result := onclick (Self, pEvtObj);
end;

function TMSHTMLHTMLButtonElementEvents2.Doondblclick(const pEvtObj: IHTMLEventObj): WordBool;
begin
  if not Assigned (ondblclick) then System.Exit;
  Result := ondblclick (Self, pEvtObj);
end;

function TMSHTMLHTMLButtonElementEvents2.Doonkeypress(const pEvtObj: IHTMLEventObj): WordBool;
begin
  if not Assigned (onkeypress) then System.Exit;
  Result := onkeypress (Self, pEvtObj);
end;

procedure TMSHTMLHTMLButtonElementEvents2.Doonkeydown(const pEvtObj: IHTMLEventObj);
begin
  if not Assigned (onkeydown) then System.Exit;
  onkeydown (Self, pEvtObj);
end;

procedure TMSHTMLHTMLButtonElementEvents2.Doonkeyup(const pEvtObj: IHTMLEventObj);
begin
  if not Assigned (onkeyup) then System.Exit;
  onkeyup (Self, pEvtObj);
end;

procedure TMSHTMLHTMLButtonElementEvents2.Doonmouseout(const pEvtObj: IHTMLEventObj);
begin
  if not Assigned (onmouseout) then System.Exit;
  onmouseout (Self, pEvtObj);
end;

procedure TMSHTMLHTMLButtonElementEvents2.Doonmouseover(const pEvtObj: IHTMLEventObj);
begin
  if not Assigned (onmouseover) then System.Exit;
  onmouseover (Self, pEvtObj);
end;

procedure TMSHTMLHTMLButtonElementEvents2.Doonmousemove(const pEvtObj: IHTMLEventObj);
begin
  if not Assigned (onmousemove) then System.Exit;
  onmousemove (Self, pEvtObj);
end;

procedure TMSHTMLHTMLButtonElementEvents2.Doonmousedown(const pEvtObj: IHTMLEventObj);
begin
  if not Assigned (onmousedown) then System.Exit;
  onmousedown (Self, pEvtObj);
end;

procedure TMSHTMLHTMLButtonElementEvents2.Doonmouseup(const pEvtObj: IHTMLEventObj);
begin
  if not Assigned (onmouseup) then System.Exit;
  onmouseup (Self, pEvtObj);
end;

function TMSHTMLHTMLButtonElementEvents2.Doonselectstart(const pEvtObj: IHTMLEventObj): WordBool;
begin
  if not Assigned (onselectstart) then System.Exit;
  Result := onselectstart (Self, pEvtObj);
end;

procedure TMSHTMLHTMLButtonElementEvents2.Doonfilterchange(const pEvtObj: IHTMLEventObj);
begin
  if not Assigned (onfilterchange) then System.Exit;
  onfilterchange (Self, pEvtObj);
end;

function TMSHTMLHTMLButtonElementEvents2.Doondragstart(const pEvtObj: IHTMLEventObj): WordBool;
begin
  if not Assigned (ondragstart) then System.Exit;
  Result := ondragstart (Self, pEvtObj);
end;

function TMSHTMLHTMLButtonElementEvents2.Doonbeforeupdate(const pEvtObj: IHTMLEventObj): WordBool;
begin
  if not Assigned (onbeforeupdate) then System.Exit;
  Result := onbeforeupdate (Self, pEvtObj);
end;

procedure TMSHTMLHTMLButtonElementEvents2.Doonafterupdate(const pEvtObj: IHTMLEventObj);
begin
  if not Assigned (onafterupdate) then System.Exit;
  onafterupdate (Self, pEvtObj);
end;

function TMSHTMLHTMLButtonElementEvents2.Doonerrorupdate(const pEvtObj: IHTMLEventObj): WordBool;
begin
  if not Assigned (onerrorupdate) then System.Exit;
  Result := onerrorupdate (Self, pEvtObj);
end;

function TMSHTMLHTMLButtonElementEvents2.Doonrowexit(const pEvtObj: IHTMLEventObj): WordBool;
begin
  if not Assigned (onrowexit) then System.Exit;
  Result := onrowexit (Self, pEvtObj);
end;

procedure TMSHTMLHTMLButtonElementEvents2.Doonrowenter(const pEvtObj: IHTMLEventObj);
begin
  if not Assigned (onrowenter) then System.Exit;
  onrowenter (Self, pEvtObj);
end;

procedure TMSHTMLHTMLButtonElementEvents2.Doondatasetchanged(const pEvtObj: IHTMLEventObj);
begin
  if not Assigned (ondatasetchanged) then System.Exit;
  ondatasetchanged (Self, pEvtObj);
end;

procedure TMSHTMLHTMLButtonElementEvents2.Doondataavailable(const pEvtObj: IHTMLEventObj);
begin
  if not Assigned (ondataavailable) then System.Exit;
  ondataavailable (Self, pEvtObj);
end;

procedure TMSHTMLHTMLButtonElementEvents2.Doondatasetcomplete(const pEvtObj: IHTMLEventObj);
begin
  if not Assigned (ondatasetcomplete) then System.Exit;
  ondatasetcomplete (Self, pEvtObj);
end;

procedure TMSHTMLHTMLButtonElementEvents2.Doonlosecapture(const pEvtObj: IHTMLEventObj);
begin
  if not Assigned (onlosecapture) then System.Exit;
  onlosecapture (Self, pEvtObj);
end;

procedure TMSHTMLHTMLButtonElementEvents2.Doonpropertychange(const pEvtObj: IHTMLEventObj);
begin
  if not Assigned (onpropertychange) then System.Exit;
  onpropertychange (Self, pEvtObj);
end;

procedure TMSHTMLHTMLButtonElementEvents2.Doonscroll(const pEvtObj: IHTMLEventObj);
begin
  if not Assigned (onscroll) then System.Exit;
  onscroll (Self, pEvtObj);
end;

procedure TMSHTMLHTMLButtonElementEvents2.Doonfocus(const pEvtObj: IHTMLEventObj);
begin
  if not Assigned (onfocus) then System.Exit;
  onfocus (Self, pEvtObj);
end;

procedure TMSHTMLHTMLButtonElementEvents2.Doonblur(const pEvtObj: IHTMLEventObj);
begin
  if not Assigned (onblur) then System.Exit;
  onblur (Self, pEvtObj);
end;

procedure TMSHTMLHTMLButtonElementEvents2.Doonresize(const pEvtObj: IHTMLEventObj);
begin
  if not Assigned (onresize) then System.Exit;
  onresize (Self, pEvtObj);
end;

function TMSHTMLHTMLButtonElementEvents2.Doondrag(const pEvtObj: IHTMLEventObj): WordBool;
begin
  if not Assigned (ondrag) then System.Exit;
  Result := ondrag (Self, pEvtObj);
end;

procedure TMSHTMLHTMLButtonElementEvents2.Doondragend(const pEvtObj: IHTMLEventObj);
begin
  if not Assigned (ondragend) then System.Exit;
  ondragend (Self, pEvtObj);
end;

function TMSHTMLHTMLButtonElementEvents2.Doondragenter(const pEvtObj: IHTMLEventObj): WordBool;
begin
  if not Assigned (ondragenter) then System.Exit;
  Result := ondragenter (Self, pEvtObj);
end;

function TMSHTMLHTMLButtonElementEvents2.Doondragover(const pEvtObj: IHTMLEventObj): WordBool;
begin
  if not Assigned (ondragover) then System.Exit;
  Result := ondragover (Self, pEvtObj);
end;

procedure TMSHTMLHTMLButtonElementEvents2.Doondragleave(const pEvtObj: IHTMLEventObj);
begin
  if not Assigned (ondragleave) then System.Exit;
  ondragleave (Self, pEvtObj);
end;

function TMSHTMLHTMLButtonElementEvents2.Doondrop(const pEvtObj: IHTMLEventObj): WordBool;
begin
  if not Assigned (ondrop) then System.Exit;
  Result := ondrop (Self, pEvtObj);
end;

function TMSHTMLHTMLButtonElementEvents2.Doonbeforecut(const pEvtObj: IHTMLEventObj): WordBool;
begin
  if not Assigned (onbeforecut) then System.Exit;
  Result := onbeforecut (Self, pEvtObj);
end;

function TMSHTMLHTMLButtonElementEvents2.Dooncut(const pEvtObj: IHTMLEventObj): WordBool;
begin
  if not Assigned (oncut) then System.Exit;
  Result := oncut (Self, pEvtObj);
end;

function TMSHTMLHTMLButtonElementEvents2.Doonbeforecopy(const pEvtObj: IHTMLEventObj): WordBool;
begin
  if not Assigned (onbeforecopy) then System.Exit;
  Result := onbeforecopy (Self, pEvtObj);
end;

function TMSHTMLHTMLButtonElementEvents2.Dooncopy(const pEvtObj: IHTMLEventObj): WordBool;
begin
  if not Assigned (oncopy) then System.Exit;
  Result := oncopy (Self, pEvtObj);
end;

function TMSHTMLHTMLButtonElementEvents2.Doonbeforepaste(const pEvtObj: IHTMLEventObj): WordBool;
begin
  if not Assigned (onbeforepaste) then System.Exit;
  Result := onbeforepaste (Self, pEvtObj);
end;

function TMSHTMLHTMLButtonElementEvents2.Doonpaste(const pEvtObj: IHTMLEventObj): WordBool;
begin
  if not Assigned (onpaste) then System.Exit;
  Result := onpaste (Self, pEvtObj);
end;

function TMSHTMLHTMLButtonElementEvents2.Dooncontextmenu(const pEvtObj: IHTMLEventObj): WordBool;
begin
  if not Assigned (oncontextmenu) then System.Exit;
  Result := oncontextmenu (Self, pEvtObj);
end;

procedure TMSHTMLHTMLButtonElementEvents2.Doonrowsdelete(const pEvtObj: IHTMLEventObj);
begin
  if not Assigned (onrowsdelete) then System.Exit;
  onrowsdelete (Self, pEvtObj);
end;

procedure TMSHTMLHTMLButtonElementEvents2.Doonrowsinserted(const pEvtObj: IHTMLEventObj);
begin
  if not Assigned (onrowsinserted) then System.Exit;
  onrowsinserted (Self, pEvtObj);
end;

procedure TMSHTMLHTMLButtonElementEvents2.Dooncellchange(const pEvtObj: IHTMLEventObj);
begin
  if not Assigned (oncellchange) then System.Exit;
  oncellchange (Self, pEvtObj);
end;

procedure TMSHTMLHTMLButtonElementEvents2.Doonreadystatechange(const pEvtObj: IHTMLEventObj);
begin
  if not Assigned (onreadystatechange) then System.Exit;
  onreadystatechange (Self, pEvtObj);
end;

procedure TMSHTMLHTMLButtonElementEvents2.Doonlayoutcomplete(const pEvtObj: IHTMLEventObj);
begin
  if not Assigned (onlayoutcomplete) then System.Exit;
  onlayoutcomplete (Self, pEvtObj);
end;

procedure TMSHTMLHTMLButtonElementEvents2.Doonpage(const pEvtObj: IHTMLEventObj);
begin
  if not Assigned (onpage) then System.Exit;
  onpage (Self, pEvtObj);
end;

procedure TMSHTMLHTMLButtonElementEvents2.Doonmouseenter(const pEvtObj: IHTMLEventObj);
begin
  if not Assigned (onmouseenter) then System.Exit;
  onmouseenter (Self, pEvtObj);
end;

procedure TMSHTMLHTMLButtonElementEvents2.Doonmouseleave(const pEvtObj: IHTMLEventObj);
begin
  if not Assigned (onmouseleave) then System.Exit;
  onmouseleave (Self, pEvtObj);
end;

procedure TMSHTMLHTMLButtonElementEvents2.Doonactivate(const pEvtObj: IHTMLEventObj);
begin
  if not Assigned (onactivate) then System.Exit;
  onactivate (Self, pEvtObj);
end;

procedure TMSHTMLHTMLButtonElementEvents2.Doondeactivate(const pEvtObj: IHTMLEventObj);
begin
  if not Assigned (ondeactivate) then System.Exit;
  ondeactivate (Self, pEvtObj);
end;

function TMSHTMLHTMLButtonElementEvents2.Doonbeforedeactivate(const pEvtObj: IHTMLEventObj): WordBool;
begin
  if not Assigned (onbeforedeactivate) then System.Exit;
  Result := onbeforedeactivate (Self, pEvtObj);
end;

function TMSHTMLHTMLButtonElementEvents2.Doonbeforeactivate(const pEvtObj: IHTMLEventObj): WordBool;
begin
  if not Assigned (onbeforeactivate) then System.Exit;
  Result := onbeforeactivate (Self, pEvtObj);
end;

procedure TMSHTMLHTMLButtonElementEvents2.Doonfocusin(const pEvtObj: IHTMLEventObj);
begin
  if not Assigned (onfocusin) then System.Exit;
  onfocusin (Self, pEvtObj);
end;

procedure TMSHTMLHTMLButtonElementEvents2.Doonfocusout(const pEvtObj: IHTMLEventObj);
begin
  if not Assigned (onfocusout) then System.Exit;
  onfocusout (Self, pEvtObj);
end;

procedure TMSHTMLHTMLButtonElementEvents2.Doonmove(const pEvtObj: IHTMLEventObj);
begin
  if not Assigned (onmove) then System.Exit;
  onmove (Self, pEvtObj);
end;

function TMSHTMLHTMLButtonElementEvents2.Dooncontrolselect(const pEvtObj: IHTMLEventObj): WordBool;
begin
  if not Assigned (oncontrolselect) then System.Exit;
  Result := oncontrolselect (Self, pEvtObj);
end;

function TMSHTMLHTMLButtonElementEvents2.Doonmovestart(const pEvtObj: IHTMLEventObj): WordBool;
begin
  if not Assigned (onmovestart) then System.Exit;
  Result := onmovestart (Self, pEvtObj);
end;

procedure TMSHTMLHTMLButtonElementEvents2.Doonmoveend(const pEvtObj: IHTMLEventObj);
begin
  if not Assigned (onmoveend) then System.Exit;
  onmoveend (Self, pEvtObj);
end;

function TMSHTMLHTMLButtonElementEvents2.Doonresizestart(const pEvtObj: IHTMLEventObj): WordBool;
begin
  if not Assigned (onresizestart) then System.Exit;
  Result := onresizestart (Self, pEvtObj);
end;

procedure TMSHTMLHTMLButtonElementEvents2.Doonresizeend(const pEvtObj: IHTMLEventObj);
begin
  if not Assigned (onresizeend) then System.Exit;
  onresizeend (Self, pEvtObj);
end;

function TMSHTMLHTMLButtonElementEvents2.Doonmousewheel(const pEvtObj: IHTMLEventObj): WordBool;
begin
  if not Assigned (onmousewheel) then System.Exit;
  Result := onmousewheel (Self, pEvtObj);
end;



function TMSHTMLHTMLWindowEvents.DoInvoke (DispID: Integer; const IID: TGUID; LocaleID: Integer;
  Flags: Word; var dps: TDispParams; pDispIds: PDispIdList;
  VarResult, ExcepInfo, ArgErr: Pointer): HResult;
type
  POleVariant = ^OleVariant;
begin
  Result := DISP_E_MEMBERNOTFOUND;

  //SinkInvoke//
    case DispId of
      1003 :
      begin
        Doonload ();
        Result := S_OK;
      end;
      1008 :
      begin
        Doonunload ();
        Result := S_OK;
      end;
      -2147418102 :
      begin
        OleVariant (VarResult^) := Doonhelp ();
        Result := S_OK;
      end;
      -2147418111 :
      begin
        Doonfocus ();
        Result := S_OK;
      end;
      -2147418112 :
      begin
        Doonblur ();
        Result := S_OK;
      end;
      1002 :
      begin
        Doonerror (dps.rgvarg^ [pDispIds^ [0]].bstrval, dps.rgvarg^ [pDispIds^ [1]].bstrval, dps.rgvarg^ [pDispIds^ [2]].lval);
        Result := S_OK;
      end;
      1016 :
      begin
        Doonresize ();
        Result := S_OK;
      end;
      1014 :
      begin
        Doonscroll ();
        Result := S_OK;
      end;
      1017 :
      begin
        Doonbeforeunload ();
        Result := S_OK;
      end;
      1024 :
      begin
        Doonbeforeprint ();
        Result := S_OK;
      end;
      1025 :
      begin
        Doonafterprint ();
        Result := S_OK;
      end;
    end;  { case }
  //SinkInvokeEnd//
end;

constructor TMSHTMLHTMLWindowEvents.Create (AOwner: TComponent);
begin
  inherited Create (AOwner);
  //SinkInit//
  FSinkIID := HTMLWindowEvents;
end;

//SinkImplementation//
procedure TMSHTMLHTMLWindowEvents.Doonload;
begin
  if not Assigned (onload) then System.Exit;
  onload (Self);
end;

procedure TMSHTMLHTMLWindowEvents.Doonunload;
begin
  if not Assigned (onunload) then System.Exit;
  onunload (Self);
end;

function TMSHTMLHTMLWindowEvents.Doonhelp: WordBool;
begin
  if not Assigned (onhelp) then System.Exit;
  Result := onhelp (Self);
end;

procedure TMSHTMLHTMLWindowEvents.Doonfocus;
begin
  if not Assigned (onfocus) then System.Exit;
  onfocus (Self);
end;

procedure TMSHTMLHTMLWindowEvents.Doonblur;
begin
  if not Assigned (onblur) then System.Exit;
  onblur (Self);
end;

procedure TMSHTMLHTMLWindowEvents.Doonerror(const description: WideString; const url: WideString; line: Integer);
begin
  if not Assigned (onerror) then System.Exit;
  onerror (Self, description, url, line);
end;

procedure TMSHTMLHTMLWindowEvents.Doonresize;
begin
  if not Assigned (onresize) then System.Exit;
  onresize (Self);
end;

procedure TMSHTMLHTMLWindowEvents.Doonscroll;
begin
  if not Assigned (onscroll) then System.Exit;
  onscroll (Self);
end;

procedure TMSHTMLHTMLWindowEvents.Doonbeforeunload;
begin
  if not Assigned (onbeforeunload) then System.Exit;
  onbeforeunload (Self);
end;

procedure TMSHTMLHTMLWindowEvents.Doonbeforeprint;
begin
  if not Assigned (onbeforeprint) then System.Exit;
  onbeforeprint (Self);
end;

procedure TMSHTMLHTMLWindowEvents.Doonafterprint;
begin
  if not Assigned (onafterprint) then System.Exit;
  onafterprint (Self);
end;



function TMSHTMLHTMLWindowEvents2.DoInvoke (DispID: Integer; const IID: TGUID; LocaleID: Integer;
  Flags: Word; var dps: TDispParams; pDispIds: PDispIdList;
  VarResult, ExcepInfo, ArgErr: Pointer): HResult;
type
  POleVariant = ^OleVariant;
begin
  Result := DISP_E_MEMBERNOTFOUND;

  //SinkInvoke//
    case DispId of
      1003 :
      begin
        Doonload (IUnknown (dps.rgvarg^ [pDispIds^ [0]].unkval) as IHTMLEventObj);
        Result := S_OK;
      end;
      1008 :
      begin
        Doonunload (IUnknown (dps.rgvarg^ [pDispIds^ [0]].unkval) as IHTMLEventObj);
        Result := S_OK;
      end;
      -2147418102 :
      begin
        OleVariant (VarResult^) := Doonhelp (IUnknown (dps.rgvarg^ [pDispIds^ [0]].unkval) as IHTMLEventObj);
        Result := S_OK;
      end;
      -2147418111 :
      begin
        Doonfocus (IUnknown (dps.rgvarg^ [pDispIds^ [0]].unkval) as IHTMLEventObj);
        Result := S_OK;
      end;
      -2147418112 :
      begin
        Doonblur (IUnknown (dps.rgvarg^ [pDispIds^ [0]].unkval) as IHTMLEventObj);
        Result := S_OK;
      end;
      1002 :
      begin
        Doonerror (dps.rgvarg^ [pDispIds^ [0]].bstrval, dps.rgvarg^ [pDispIds^ [1]].bstrval, dps.rgvarg^ [pDispIds^ [2]].lval);
        Result := S_OK;
      end;
      1016 :
      begin
        Doonresize (IUnknown (dps.rgvarg^ [pDispIds^ [0]].unkval) as IHTMLEventObj);
        Result := S_OK;
      end;
      1014 :
      begin
        Doonscroll (IUnknown (dps.rgvarg^ [pDispIds^ [0]].unkval) as IHTMLEventObj);
        Result := S_OK;
      end;
      1017 :
      begin
        Doonbeforeunload (IUnknown (dps.rgvarg^ [pDispIds^ [0]].unkval) as IHTMLEventObj);
        Result := S_OK;
      end;
      1024 :
      begin
        Doonbeforeprint (IUnknown (dps.rgvarg^ [pDispIds^ [0]].unkval) as IHTMLEventObj);
        Result := S_OK;
      end;
      1025 :
      begin
        Doonafterprint (IUnknown (dps.rgvarg^ [pDispIds^ [0]].unkval) as IHTMLEventObj);
        Result := S_OK;
      end;
    end;  { case }
  //SinkInvokeEnd//
end;

constructor TMSHTMLHTMLWindowEvents2.Create (AOwner: TComponent);
begin
  inherited Create (AOwner);
  //SinkInit//
  FSinkIID := HTMLWindowEvents2;
end;

//SinkImplementation//
procedure TMSHTMLHTMLWindowEvents2.Doonload(const pEvtObj: IHTMLEventObj);
begin
  if not Assigned (onload) then System.Exit;
  onload (Self, pEvtObj);
end;

procedure TMSHTMLHTMLWindowEvents2.Doonunload(const pEvtObj: IHTMLEventObj);
begin
  if not Assigned (onunload) then System.Exit;
  onunload (Self, pEvtObj);
end;

function TMSHTMLHTMLWindowEvents2.Doonhelp(const pEvtObj: IHTMLEventObj): WordBool;
begin
  if not Assigned (onhelp) then System.Exit;
  Result := onhelp (Self, pEvtObj);
end;

procedure TMSHTMLHTMLWindowEvents2.Doonfocus(const pEvtObj: IHTMLEventObj);
begin
  if not Assigned (onfocus) then System.Exit;
  onfocus (Self, pEvtObj);
end;

procedure TMSHTMLHTMLWindowEvents2.Doonblur(const pEvtObj: IHTMLEventObj);
begin
  if not Assigned (onblur) then System.Exit;
  onblur (Self, pEvtObj);
end;

procedure TMSHTMLHTMLWindowEvents2.Doonerror(const description: WideString; const url: WideString; line: Integer);
begin
  if not Assigned (onerror) then System.Exit;
  onerror (Self, description, url, line);
end;

procedure TMSHTMLHTMLWindowEvents2.Doonresize(const pEvtObj: IHTMLEventObj);
begin
  if not Assigned (onresize) then System.Exit;
  onresize (Self, pEvtObj);
end;

procedure TMSHTMLHTMLWindowEvents2.Doonscroll(const pEvtObj: IHTMLEventObj);
begin
  if not Assigned (onscroll) then System.Exit;
  onscroll (Self, pEvtObj);
end;

procedure TMSHTMLHTMLWindowEvents2.Doonbeforeunload(const pEvtObj: IHTMLEventObj);
begin
  if not Assigned (onbeforeunload) then System.Exit;
  onbeforeunload (Self, pEvtObj);
end;

procedure TMSHTMLHTMLWindowEvents2.Doonbeforeprint(const pEvtObj: IHTMLEventObj);
begin
  if not Assigned (onbeforeprint) then System.Exit;
  onbeforeprint (Self, pEvtObj);
end;

procedure TMSHTMLHTMLWindowEvents2.Doonafterprint(const pEvtObj: IHTMLEventObj);
begin
  if not Assigned (onafterprint) then System.Exit;
  onafterprint (Self, pEvtObj);
end;



function TMSHTMLHTMLDocumentEvents.DoInvoke (DispID: Integer; const IID: TGUID; LocaleID: Integer;
  Flags: Word; var dps: TDispParams; pDispIds: PDispIdList;
  VarResult, ExcepInfo, ArgErr: Pointer): HResult;
type
  POleVariant = ^OleVariant;
begin
  Result := DISP_E_MEMBERNOTFOUND;

  //SinkInvoke//
    case DispId of
      -2147418102 :
      begin
        OleVariant (VarResult^) := Doonhelp ();
        Result := S_OK;
      end;
      -600 :
      begin
        OleVariant (VarResult^) := Doonclick ();
        Result := S_OK;
      end;
      -601 :
      begin
        OleVariant (VarResult^) := Doondblclick ();
        Result := S_OK;
      end;
      -602 :
      begin
        Doonkeydown ();
        Result := S_OK;
      end;
      -604 :
      begin
        Doonkeyup ();
        Result := S_OK;
      end;
      -603 :
      begin
        OleVariant (VarResult^) := Doonkeypress ();
        Result := S_OK;
      end;
      -605 :
      begin
        Doonmousedown ();
        Result := S_OK;
      end;
      -606 :
      begin
        Doonmousemove ();
        Result := S_OK;
      end;
      -607 :
      begin
        Doonmouseup ();
        Result := S_OK;
      end;
      -2147418103 :
      begin
        Doonmouseout ();
        Result := S_OK;
      end;
      -2147418104 :
      begin
        Doonmouseover ();
        Result := S_OK;
      end;
      -609 :
      begin
        Doonreadystatechange ();
        Result := S_OK;
      end;
      -2147418108 :
      begin
        OleVariant (VarResult^) := Doonbeforeupdate ();
        Result := S_OK;
      end;
      -2147418107 :
      begin
        Doonafterupdate ();
        Result := S_OK;
      end;
      -2147418106 :
      begin
        OleVariant (VarResult^) := Doonrowexit ();
        Result := S_OK;
      end;
      -2147418105 :
      begin
        Doonrowenter ();
        Result := S_OK;
      end;
      -2147418101 :
      begin
        OleVariant (VarResult^) := Doondragstart ();
        Result := S_OK;
      end;
      -2147418100 :
      begin
        OleVariant (VarResult^) := Doonselectstart ();
        Result := S_OK;
      end;
      -2147418099 :
      begin
        OleVariant (VarResult^) := Doonerrorupdate ();
        Result := S_OK;
      end;
      1023 :
      begin
        OleVariant (VarResult^) := Dooncontextmenu ();
        Result := S_OK;
      end;
      1026 :
      begin
        OleVariant (VarResult^) := Doonstop ();
        Result := S_OK;
      end;
      -2147418080 :
      begin
        Doonrowsdelete ();
        Result := S_OK;
      end;
      -2147418079 :
      begin
        Doonrowsinserted ();
        Result := S_OK;
      end;
      -2147418078 :
      begin
        Dooncellchange ();
        Result := S_OK;
      end;
      -2147418093 :
      begin
        Doonpropertychange ();
        Result := S_OK;
      end;
      -2147418098 :
      begin
        Doondatasetchanged ();
        Result := S_OK;
      end;
      -2147418097 :
      begin
        Doondataavailable ();
        Result := S_OK;
      end;
      -2147418096 :
      begin
        Doondatasetcomplete ();
        Result := S_OK;
      end;
      1027 :
      begin
        Doonbeforeeditfocus ();
        Result := S_OK;
      end;
      1037 :
      begin
        Doonselectionchange ();
        Result := S_OK;
      end;
      1036 :
      begin
        OleVariant (VarResult^) := Dooncontrolselect ();
        Result := S_OK;
      end;
      1033 :
      begin
        OleVariant (VarResult^) := Doonmousewheel ();
        Result := S_OK;
      end;
      1048 :
      begin
        Doonfocusin ();
        Result := S_OK;
      end;
      1049 :
      begin
        Doonfocusout ();
        Result := S_OK;
      end;
      1044 :
      begin
        Doonactivate ();
        Result := S_OK;
      end;
      1045 :
      begin
        Doondeactivate ();
        Result := S_OK;
      end;
      1047 :
      begin
        OleVariant (VarResult^) := Doonbeforeactivate ();
        Result := S_OK;
      end;
      1034 :
      begin
        OleVariant (VarResult^) := Doonbeforedeactivate ();
        Result := S_OK;
      end;
    end;  { case }
  //SinkInvokeEnd//
end;

constructor TMSHTMLHTMLDocumentEvents.Create (AOwner: TComponent);
begin
  inherited Create (AOwner);
  //SinkInit//
  FSinkIID := HTMLDocumentEvents;
end;

//SinkImplementation//
function TMSHTMLHTMLDocumentEvents.Doonhelp: WordBool;
begin
  if not Assigned (onhelp) then System.Exit;
  Result := onhelp (Self);
end;

function TMSHTMLHTMLDocumentEvents.Doonclick: WordBool;
begin
  if not Assigned (onclick) then System.Exit;
  Result := onclick (Self);
end;

function TMSHTMLHTMLDocumentEvents.Doondblclick: WordBool;
begin
  if not Assigned (ondblclick) then System.Exit;
  Result := ondblclick (Self);
end;

procedure TMSHTMLHTMLDocumentEvents.Doonkeydown;
begin
  if not Assigned (onkeydown) then System.Exit;
  onkeydown (Self);
end;

procedure TMSHTMLHTMLDocumentEvents.Doonkeyup;
begin
  if not Assigned (onkeyup) then System.Exit;
  onkeyup (Self);
end;

function TMSHTMLHTMLDocumentEvents.Doonkeypress: WordBool;
begin
  if not Assigned (onkeypress) then System.Exit;
  Result := onkeypress (Self);
end;

procedure TMSHTMLHTMLDocumentEvents.Doonmousedown;
begin
  if not Assigned (onmousedown) then System.Exit;
  onmousedown (Self);
end;

procedure TMSHTMLHTMLDocumentEvents.Doonmousemove;
begin
  if not Assigned (onmousemove) then System.Exit;
  onmousemove (Self);
end;

procedure TMSHTMLHTMLDocumentEvents.Doonmouseup;
begin
  if not Assigned (onmouseup) then System.Exit;
  onmouseup (Self);
end;

procedure TMSHTMLHTMLDocumentEvents.Doonmouseout;
begin
  if not Assigned (onmouseout) then System.Exit;
  onmouseout (Self);
end;

procedure TMSHTMLHTMLDocumentEvents.Doonmouseover;
begin
  if not Assigned (onmouseover) then System.Exit;
  onmouseover (Self);
end;

procedure TMSHTMLHTMLDocumentEvents.Doonreadystatechange;
begin
  if not Assigned (onreadystatechange) then System.Exit;
  onreadystatechange (Self);
end;

function TMSHTMLHTMLDocumentEvents.Doonbeforeupdate: WordBool;
begin
  if not Assigned (onbeforeupdate) then System.Exit;
  Result := onbeforeupdate (Self);
end;

procedure TMSHTMLHTMLDocumentEvents.Doonafterupdate;
begin
  if not Assigned (onafterupdate) then System.Exit;
  onafterupdate (Self);
end;

function TMSHTMLHTMLDocumentEvents.Doonrowexit: WordBool;
begin
  if not Assigned (onrowexit) then System.Exit;
  Result := onrowexit (Self);
end;

procedure TMSHTMLHTMLDocumentEvents.Doonrowenter;
begin
  if not Assigned (onrowenter) then System.Exit;
  onrowenter (Self);
end;

function TMSHTMLHTMLDocumentEvents.Doondragstart: WordBool;
begin
  if not Assigned (ondragstart) then System.Exit;
  Result := ondragstart (Self);
end;

function TMSHTMLHTMLDocumentEvents.Doonselectstart: WordBool;
begin
  if not Assigned (onselectstart) then System.Exit;
  Result := onselectstart (Self);
end;

function TMSHTMLHTMLDocumentEvents.Doonerrorupdate: WordBool;
begin
  if not Assigned (onerrorupdate) then System.Exit;
  Result := onerrorupdate (Self);
end;

function TMSHTMLHTMLDocumentEvents.Dooncontextmenu: WordBool;
begin
  if not Assigned (oncontextmenu) then System.Exit;
  Result := oncontextmenu (Self);
end;

function TMSHTMLHTMLDocumentEvents.Doonstop: WordBool;
begin
  if not Assigned (onstop) then System.Exit;
  Result := onstop (Self);
end;

procedure TMSHTMLHTMLDocumentEvents.Doonrowsdelete;
begin
  if not Assigned (onrowsdelete) then System.Exit;
  onrowsdelete (Self);
end;

procedure TMSHTMLHTMLDocumentEvents.Doonrowsinserted;
begin
  if not Assigned (onrowsinserted) then System.Exit;
  onrowsinserted (Self);
end;

procedure TMSHTMLHTMLDocumentEvents.Dooncellchange;
begin
  if not Assigned (oncellchange) then System.Exit;
  oncellchange (Self);
end;

procedure TMSHTMLHTMLDocumentEvents.Doonpropertychange;
begin
  if not Assigned (onpropertychange) then System.Exit;
  onpropertychange (Self);
end;

procedure TMSHTMLHTMLDocumentEvents.Doondatasetchanged;
begin
  if not Assigned (ondatasetchanged) then System.Exit;
  ondatasetchanged (Self);
end;

procedure TMSHTMLHTMLDocumentEvents.Doondataavailable;
begin
  if not Assigned (ondataavailable) then System.Exit;
  ondataavailable (Self);
end;

procedure TMSHTMLHTMLDocumentEvents.Doondatasetcomplete;
begin
  if not Assigned (ondatasetcomplete) then System.Exit;
  ondatasetcomplete (Self);
end;

procedure TMSHTMLHTMLDocumentEvents.Doonbeforeeditfocus;
begin
  if not Assigned (onbeforeeditfocus) then System.Exit;
  onbeforeeditfocus (Self);
end;

procedure TMSHTMLHTMLDocumentEvents.Doonselectionchange;
begin
  if not Assigned (onselectionchange) then System.Exit;
  onselectionchange (Self);
end;

function TMSHTMLHTMLDocumentEvents.Dooncontrolselect: WordBool;
begin
  if not Assigned (oncontrolselect) then System.Exit;
  Result := oncontrolselect (Self);
end;

function TMSHTMLHTMLDocumentEvents.Doonmousewheel: WordBool;
begin
  if not Assigned (onmousewheel) then System.Exit;
  Result := onmousewheel (Self);
end;

procedure TMSHTMLHTMLDocumentEvents.Doonfocusin;
begin
  if not Assigned (onfocusin) then System.Exit;
  onfocusin (Self);
end;

procedure TMSHTMLHTMLDocumentEvents.Doonfocusout;
begin
  if not Assigned (onfocusout) then System.Exit;
  onfocusout (Self);
end;

procedure TMSHTMLHTMLDocumentEvents.Doonactivate;
begin
  if not Assigned (onactivate) then System.Exit;
  onactivate (Self);
end;

procedure TMSHTMLHTMLDocumentEvents.Doondeactivate;
begin
  if not Assigned (ondeactivate) then System.Exit;
  ondeactivate (Self);
end;

function TMSHTMLHTMLDocumentEvents.Doonbeforeactivate: WordBool;
begin
  if not Assigned (onbeforeactivate) then System.Exit;
  Result := onbeforeactivate (Self);
end;

function TMSHTMLHTMLDocumentEvents.Doonbeforedeactivate: WordBool;
begin
  if not Assigned (onbeforedeactivate) then System.Exit;
  Result := onbeforedeactivate (Self);
end;



function TMSHTMLHTMLDocumentEvents2.DoInvoke (DispID: Integer; const IID: TGUID; LocaleID: Integer;
  Flags: Word; var dps: TDispParams; pDispIds: PDispIdList;
  VarResult, ExcepInfo, ArgErr: Pointer): HResult;
type
  POleVariant = ^OleVariant;
begin
  Result := DISP_E_MEMBERNOTFOUND;

  //SinkInvoke//
    case DispId of
      -2147418102 :
      begin
        OleVariant (VarResult^) := Doonhelp (IUnknown (dps.rgvarg^ [pDispIds^ [0]].unkval) as IHTMLEventObj);
        Result := S_OK;
      end;
      -600 :
      begin
        OleVariant (VarResult^) := Doonclick (IUnknown (dps.rgvarg^ [pDispIds^ [0]].unkval) as IHTMLEventObj);
        Result := S_OK;
      end;
      -601 :
      begin
        OleVariant (VarResult^) := Doondblclick (IUnknown (dps.rgvarg^ [pDispIds^ [0]].unkval) as IHTMLEventObj);
        Result := S_OK;
      end;
      -602 :
      begin
        Doonkeydown (IUnknown (dps.rgvarg^ [pDispIds^ [0]].unkval) as IHTMLEventObj);
        Result := S_OK;
      end;
      -604 :
      begin
        Doonkeyup (IUnknown (dps.rgvarg^ [pDispIds^ [0]].unkval) as IHTMLEventObj);
        Result := S_OK;
      end;
      -603 :
      begin
        OleVariant (VarResult^) := Doonkeypress (IUnknown (dps.rgvarg^ [pDispIds^ [0]].unkval) as IHTMLEventObj);
        Result := S_OK;
      end;
      -605 :
      begin
        Doonmousedown (IUnknown (dps.rgvarg^ [pDispIds^ [0]].unkval) as IHTMLEventObj);
        Result := S_OK;
      end;
      -606 :
      begin
        Doonmousemove (IUnknown (dps.rgvarg^ [pDispIds^ [0]].unkval) as IHTMLEventObj);
        Result := S_OK;
      end;
      -607 :
      begin
        Doonmouseup (IUnknown (dps.rgvarg^ [pDispIds^ [0]].unkval) as IHTMLEventObj);
        Result := S_OK;
      end;
      -2147418103 :
      begin
        Doonmouseout (IUnknown (dps.rgvarg^ [pDispIds^ [0]].unkval) as IHTMLEventObj);
        Result := S_OK;
      end;
      -2147418104 :
      begin
        Doonmouseover (IUnknown (dps.rgvarg^ [pDispIds^ [0]].unkval) as IHTMLEventObj);
        Result := S_OK;
      end;
      -609 :
      begin
        Doonreadystatechange (IUnknown (dps.rgvarg^ [pDispIds^ [0]].unkval) as IHTMLEventObj);
        Result := S_OK;
      end;
      -2147418108 :
      begin
        OleVariant (VarResult^) := Doonbeforeupdate (IUnknown (dps.rgvarg^ [pDispIds^ [0]].unkval) as IHTMLEventObj);
        Result := S_OK;
      end;
      -2147418107 :
      begin
        Doonafterupdate (IUnknown (dps.rgvarg^ [pDispIds^ [0]].unkval) as IHTMLEventObj);
        Result := S_OK;
      end;
      -2147418106 :
      begin
        OleVariant (VarResult^) := Doonrowexit (IUnknown (dps.rgvarg^ [pDispIds^ [0]].unkval) as IHTMLEventObj);
        Result := S_OK;
      end;
      -2147418105 :
      begin
        Doonrowenter (IUnknown (dps.rgvarg^ [pDispIds^ [0]].unkval) as IHTMLEventObj);
        Result := S_OK;
      end;
      -2147418101 :
      begin
        OleVariant (VarResult^) := Doondragstart (IUnknown (dps.rgvarg^ [pDispIds^ [0]].unkval) as IHTMLEventObj);
        Result := S_OK;
      end;
      -2147418100 :
      begin
        OleVariant (VarResult^) := Doonselectstart (IUnknown (dps.rgvarg^ [pDispIds^ [0]].unkval) as IHTMLEventObj);
        Result := S_OK;
      end;
      -2147418099 :
      begin
        OleVariant (VarResult^) := Doonerrorupdate (IUnknown (dps.rgvarg^ [pDispIds^ [0]].unkval) as IHTMLEventObj);
        Result := S_OK;
      end;
      1023 :
      begin
        OleVariant (VarResult^) := Dooncontextmenu (IUnknown (dps.rgvarg^ [pDispIds^ [0]].unkval) as IHTMLEventObj);
        Result := S_OK;
      end;
      1026 :
      begin
        OleVariant (VarResult^) := Doonstop (IUnknown (dps.rgvarg^ [pDispIds^ [0]].unkval) as IHTMLEventObj);
        Result := S_OK;
      end;
      -2147418080 :
      begin
        Doonrowsdelete (IUnknown (dps.rgvarg^ [pDispIds^ [0]].unkval) as IHTMLEventObj);
        Result := S_OK;
      end;
      -2147418079 :
      begin
        Doonrowsinserted (IUnknown (dps.rgvarg^ [pDispIds^ [0]].unkval) as IHTMLEventObj);
        Result := S_OK;
      end;
      -2147418078 :
      begin
        Dooncellchange (IUnknown (dps.rgvarg^ [pDispIds^ [0]].unkval) as IHTMLEventObj);
        Result := S_OK;
      end;
      -2147418093 :
      begin
        Doonpropertychange (IUnknown (dps.rgvarg^ [pDispIds^ [0]].unkval) as IHTMLEventObj);
        Result := S_OK;
      end;
      -2147418098 :
      begin
        Doondatasetchanged (IUnknown (dps.rgvarg^ [pDispIds^ [0]].unkval) as IHTMLEventObj);
        Result := S_OK;
      end;
      -2147418097 :
      begin
        Doondataavailable (IUnknown (dps.rgvarg^ [pDispIds^ [0]].unkval) as IHTMLEventObj);
        Result := S_OK;
      end;
      -2147418096 :
      begin
        Doondatasetcomplete (IUnknown (dps.rgvarg^ [pDispIds^ [0]].unkval) as IHTMLEventObj);
        Result := S_OK;
      end;
      1027 :
      begin
        Doonbeforeeditfocus (IUnknown (dps.rgvarg^ [pDispIds^ [0]].unkval) as IHTMLEventObj);
        Result := S_OK;
      end;
      1037 :
      begin
        Doonselectionchange (IUnknown (dps.rgvarg^ [pDispIds^ [0]].unkval) as IHTMLEventObj);
        Result := S_OK;
      end;
      1036 :
      begin
        OleVariant (VarResult^) := Dooncontrolselect (IUnknown (dps.rgvarg^ [pDispIds^ [0]].unkval) as IHTMLEventObj);
        Result := S_OK;
      end;
      1033 :
      begin
        OleVariant (VarResult^) := Doonmousewheel (IUnknown (dps.rgvarg^ [pDispIds^ [0]].unkval) as IHTMLEventObj);
        Result := S_OK;
      end;
      1048 :
      begin
        Doonfocusin (IUnknown (dps.rgvarg^ [pDispIds^ [0]].unkval) as IHTMLEventObj);
        Result := S_OK;
      end;
      1049 :
      begin
        Doonfocusout (IUnknown (dps.rgvarg^ [pDispIds^ [0]].unkval) as IHTMLEventObj);
        Result := S_OK;
      end;
      1044 :
      begin
        Doonactivate (IUnknown (dps.rgvarg^ [pDispIds^ [0]].unkval) as IHTMLEventObj);
        Result := S_OK;
      end;
      1045 :
      begin
        Doondeactivate (IUnknown (dps.rgvarg^ [pDispIds^ [0]].unkval) as IHTMLEventObj);
        Result := S_OK;
      end;
      1047 :
      begin
        OleVariant (VarResult^) := Doonbeforeactivate (IUnknown (dps.rgvarg^ [pDispIds^ [0]].unkval) as IHTMLEventObj);
        Result := S_OK;
      end;
      1034 :
      begin
        OleVariant (VarResult^) := Doonbeforedeactivate (IUnknown (dps.rgvarg^ [pDispIds^ [0]].unkval) as IHTMLEventObj);
        Result := S_OK;
      end;
    end;  { case }
  //SinkInvokeEnd//
end;

constructor TMSHTMLHTMLDocumentEvents2.Create (AOwner: TComponent);
begin
  inherited Create (AOwner);
  //SinkInit//
  FSinkIID := HTMLDocumentEvents2;
end;

//SinkImplementation//
function TMSHTMLHTMLDocumentEvents2.Doonhelp(const pEvtObj: IHTMLEventObj): WordBool;
begin
  if not Assigned (onhelp) then System.Exit;
  Result := onhelp (Self, pEvtObj);
end;

function TMSHTMLHTMLDocumentEvents2.Doonclick(const pEvtObj: IHTMLEventObj): WordBool;
begin
  if not Assigned (onclick) then System.Exit;
  Result := onclick (Self, pEvtObj);
end;

function TMSHTMLHTMLDocumentEvents2.Doondblclick(const pEvtObj: IHTMLEventObj): WordBool;
begin
  if not Assigned (ondblclick) then System.Exit;
  Result := ondblclick (Self, pEvtObj);
end;

procedure TMSHTMLHTMLDocumentEvents2.Doonkeydown(const pEvtObj: IHTMLEventObj);
begin
  if not Assigned (onkeydown) then System.Exit;
  onkeydown (Self, pEvtObj);
end;

procedure TMSHTMLHTMLDocumentEvents2.Doonkeyup(const pEvtObj: IHTMLEventObj);
begin
  if not Assigned (onkeyup) then System.Exit;
  onkeyup (Self, pEvtObj);
end;

function TMSHTMLHTMLDocumentEvents2.Doonkeypress(const pEvtObj: IHTMLEventObj): WordBool;
begin
  if not Assigned (onkeypress) then System.Exit;
  Result := onkeypress (Self, pEvtObj);
end;

procedure TMSHTMLHTMLDocumentEvents2.Doonmousedown(const pEvtObj: IHTMLEventObj);
begin
  if not Assigned (onmousedown) then System.Exit;
  onmousedown (Self, pEvtObj);
end;

procedure TMSHTMLHTMLDocumentEvents2.Doonmousemove(const pEvtObj: IHTMLEventObj);
begin
  if not Assigned (onmousemove) then System.Exit;
  onmousemove (Self, pEvtObj);
end;

procedure TMSHTMLHTMLDocumentEvents2.Doonmouseup(const pEvtObj: IHTMLEventObj);
begin
  if not Assigned (onmouseup) then System.Exit;
  onmouseup (Self, pEvtObj);
end;

procedure TMSHTMLHTMLDocumentEvents2.Doonmouseout(const pEvtObj: IHTMLEventObj);
begin
  if not Assigned (onmouseout) then System.Exit;
  onmouseout (Self, pEvtObj);
end;

procedure TMSHTMLHTMLDocumentEvents2.Doonmouseover(const pEvtObj: IHTMLEventObj);
begin
  if not Assigned (onmouseover) then System.Exit;
  onmouseover (Self, pEvtObj);
end;

procedure TMSHTMLHTMLDocumentEvents2.Doonreadystatechange(const pEvtObj: IHTMLEventObj);
begin
  if not Assigned (onreadystatechange) then System.Exit;
  onreadystatechange (Self, pEvtObj);
end;

function TMSHTMLHTMLDocumentEvents2.Doonbeforeupdate(const pEvtObj: IHTMLEventObj): WordBool;
begin
  if not Assigned (onbeforeupdate) then System.Exit;
  Result := onbeforeupdate (Self, pEvtObj);
end;

procedure TMSHTMLHTMLDocumentEvents2.Doonafterupdate(const pEvtObj: IHTMLEventObj);
begin
  if not Assigned (onafterupdate) then System.Exit;
  onafterupdate (Self, pEvtObj);
end;

function TMSHTMLHTMLDocumentEvents2.Doonrowexit(const pEvtObj: IHTMLEventObj): WordBool;
begin
  if not Assigned (onrowexit) then System.Exit;
  Result := onrowexit (Self, pEvtObj);
end;

procedure TMSHTMLHTMLDocumentEvents2.Doonrowenter(const pEvtObj: IHTMLEventObj);
begin
  if not Assigned (onrowenter) then System.Exit;
  onrowenter (Self, pEvtObj);
end;

function TMSHTMLHTMLDocumentEvents2.Doondragstart(const pEvtObj: IHTMLEventObj): WordBool;
begin
  if not Assigned (ondragstart) then System.Exit;
  Result := ondragstart (Self, pEvtObj);
end;

function TMSHTMLHTMLDocumentEvents2.Doonselectstart(const pEvtObj: IHTMLEventObj): WordBool;
begin
  if not Assigned (onselectstart) then System.Exit;
  Result := onselectstart (Self, pEvtObj);
end;

function TMSHTMLHTMLDocumentEvents2.Doonerrorupdate(const pEvtObj: IHTMLEventObj): WordBool;
begin
  if not Assigned (onerrorupdate) then System.Exit;
  Result := onerrorupdate (Self, pEvtObj);
end;

function TMSHTMLHTMLDocumentEvents2.Dooncontextmenu(const pEvtObj: IHTMLEventObj): WordBool;
begin
  if not Assigned (oncontextmenu) then System.Exit;
  Result := oncontextmenu (Self, pEvtObj);
end;

function TMSHTMLHTMLDocumentEvents2.Doonstop(const pEvtObj: IHTMLEventObj): WordBool;
begin
  if not Assigned (onstop) then System.Exit;
  Result := onstop (Self, pEvtObj);
end;

procedure TMSHTMLHTMLDocumentEvents2.Doonrowsdelete(const pEvtObj: IHTMLEventObj);
begin
  if not Assigned (onrowsdelete) then System.Exit;
  onrowsdelete (Self, pEvtObj);
end;

procedure TMSHTMLHTMLDocumentEvents2.Doonrowsinserted(const pEvtObj: IHTMLEventObj);
begin
  if not Assigned (onrowsinserted) then System.Exit;
  onrowsinserted (Self, pEvtObj);
end;

procedure TMSHTMLHTMLDocumentEvents2.Dooncellchange(const pEvtObj: IHTMLEventObj);
begin
  if not Assigned (oncellchange) then System.Exit;
  oncellchange (Self, pEvtObj);
end;

procedure TMSHTMLHTMLDocumentEvents2.Doonpropertychange(const pEvtObj: IHTMLEventObj);
begin
  if not Assigned (onpropertychange) then System.Exit;
  onpropertychange (Self, pEvtObj);
end;

procedure TMSHTMLHTMLDocumentEvents2.Doondatasetchanged(const pEvtObj: IHTMLEventObj);
begin
  if not Assigned (ondatasetchanged) then System.Exit;
  ondatasetchanged (Self, pEvtObj);
end;

procedure TMSHTMLHTMLDocumentEvents2.Doondataavailable(const pEvtObj: IHTMLEventObj);
begin
  if not Assigned (ondataavailable) then System.Exit;
  ondataavailable (Self, pEvtObj);
end;

procedure TMSHTMLHTMLDocumentEvents2.Doondatasetcomplete(const pEvtObj: IHTMLEventObj);
begin
  if not Assigned (ondatasetcomplete) then System.Exit;
  ondatasetcomplete (Self, pEvtObj);
end;

procedure TMSHTMLHTMLDocumentEvents2.Doonbeforeeditfocus(const pEvtObj: IHTMLEventObj);
begin
  if not Assigned (onbeforeeditfocus) then System.Exit;
  onbeforeeditfocus (Self, pEvtObj);
end;

procedure TMSHTMLHTMLDocumentEvents2.Doonselectionchange(const pEvtObj: IHTMLEventObj);
begin
  if not Assigned (onselectionchange) then System.Exit;
  onselectionchange (Self, pEvtObj);
end;

function TMSHTMLHTMLDocumentEvents2.Dooncontrolselect(const pEvtObj: IHTMLEventObj): WordBool;
begin
  if not Assigned (oncontrolselect) then System.Exit;
  Result := oncontrolselect (Self, pEvtObj);
end;

function TMSHTMLHTMLDocumentEvents2.Doonmousewheel(const pEvtObj: IHTMLEventObj): WordBool;
begin
  if not Assigned (onmousewheel) then System.Exit;
  Result := onmousewheel (Self, pEvtObj);
end;

procedure TMSHTMLHTMLDocumentEvents2.Doonfocusin(const pEvtObj: IHTMLEventObj);
begin
  if not Assigned (onfocusin) then System.Exit;
  onfocusin (Self, pEvtObj);
end;

procedure TMSHTMLHTMLDocumentEvents2.Doonfocusout(const pEvtObj: IHTMLEventObj);
begin
  if not Assigned (onfocusout) then System.Exit;
  onfocusout (Self, pEvtObj);
end;

procedure TMSHTMLHTMLDocumentEvents2.Doonactivate(const pEvtObj: IHTMLEventObj);
begin
  if not Assigned (onactivate) then System.Exit;
  onactivate (Self, pEvtObj);
end;

procedure TMSHTMLHTMLDocumentEvents2.Doondeactivate(const pEvtObj: IHTMLEventObj);
begin
  if not Assigned (ondeactivate) then System.Exit;
  ondeactivate (Self, pEvtObj);
end;

function TMSHTMLHTMLDocumentEvents2.Doonbeforeactivate(const pEvtObj: IHTMLEventObj): WordBool;
begin
  if not Assigned (onbeforeactivate) then System.Exit;
  Result := onbeforeactivate (Self, pEvtObj);
end;

function TMSHTMLHTMLDocumentEvents2.Doonbeforedeactivate(const pEvtObj: IHTMLEventObj): WordBool;
begin
  if not Assigned (onbeforedeactivate) then System.Exit;
  Result := onbeforedeactivate (Self, pEvtObj);
end;



function TMSHTMLHTMLStyleElementEvents.DoInvoke (DispID: Integer; const IID: TGUID; LocaleID: Integer;
  Flags: Word; var dps: TDispParams; pDispIds: PDispIdList;
  VarResult, ExcepInfo, ArgErr: Pointer): HResult;
type
  POleVariant = ^OleVariant;
begin
  Result := DISP_E_MEMBERNOTFOUND;

  //SinkInvoke//
    case DispId of
      -2147418102 :
      begin
        OleVariant (VarResult^) := Doonhelp ();
        Result := S_OK;
      end;
      -600 :
      begin
        OleVariant (VarResult^) := Doonclick ();
        Result := S_OK;
      end;
      -601 :
      begin
        OleVariant (VarResult^) := Doondblclick ();
        Result := S_OK;
      end;
      -603 :
      begin
        OleVariant (VarResult^) := Doonkeypress ();
        Result := S_OK;
      end;
      -602 :
      begin
        Doonkeydown ();
        Result := S_OK;
      end;
      -604 :
      begin
        Doonkeyup ();
        Result := S_OK;
      end;
      -2147418103 :
      begin
        Doonmouseout ();
        Result := S_OK;
      end;
      -2147418104 :
      begin
        Doonmouseover ();
        Result := S_OK;
      end;
      -606 :
      begin
        Doonmousemove ();
        Result := S_OK;
      end;
      -605 :
      begin
        Doonmousedown ();
        Result := S_OK;
      end;
      -607 :
      begin
        Doonmouseup ();
        Result := S_OK;
      end;
      -2147418100 :
      begin
        OleVariant (VarResult^) := Doonselectstart ();
        Result := S_OK;
      end;
      -2147418095 :
      begin
        Doonfilterchange ();
        Result := S_OK;
      end;
      -2147418101 :
      begin
        OleVariant (VarResult^) := Doondragstart ();
        Result := S_OK;
      end;
      -2147418108 :
      begin
        OleVariant (VarResult^) := Doonbeforeupdate ();
        Result := S_OK;
      end;
      -2147418107 :
      begin
        Doonafterupdate ();
        Result := S_OK;
      end;
      -2147418099 :
      begin
        OleVariant (VarResult^) := Doonerrorupdate ();
        Result := S_OK;
      end;
      -2147418106 :
      begin
        OleVariant (VarResult^) := Doonrowexit ();
        Result := S_OK;
      end;
      -2147418105 :
      begin
        Doonrowenter ();
        Result := S_OK;
      end;
      -2147418098 :
      begin
        Doondatasetchanged ();
        Result := S_OK;
      end;
      -2147418097 :
      begin
        Doondataavailable ();
        Result := S_OK;
      end;
      -2147418096 :
      begin
        Doondatasetcomplete ();
        Result := S_OK;
      end;
      -2147418094 :
      begin
        Doonlosecapture ();
        Result := S_OK;
      end;
      -2147418093 :
      begin
        Doonpropertychange ();
        Result := S_OK;
      end;
      1014 :
      begin
        Doonscroll ();
        Result := S_OK;
      end;
      -2147418111 :
      begin
        Doonfocus ();
        Result := S_OK;
      end;
      -2147418112 :
      begin
        Doonblur ();
        Result := S_OK;
      end;
      1016 :
      begin
        Doonresize ();
        Result := S_OK;
      end;
      -2147418092 :
      begin
        OleVariant (VarResult^) := Doondrag ();
        Result := S_OK;
      end;
      -2147418091 :
      begin
        Doondragend ();
        Result := S_OK;
      end;
      -2147418090 :
      begin
        OleVariant (VarResult^) := Doondragenter ();
        Result := S_OK;
      end;
      -2147418089 :
      begin
        OleVariant (VarResult^) := Doondragover ();
        Result := S_OK;
      end;
      -2147418088 :
      begin
        Doondragleave ();
        Result := S_OK;
      end;
      -2147418087 :
      begin
        OleVariant (VarResult^) := Doondrop ();
        Result := S_OK;
      end;
      -2147418083 :
      begin
        OleVariant (VarResult^) := Doonbeforecut ();
        Result := S_OK;
      end;
      -2147418086 :
      begin
        OleVariant (VarResult^) := Dooncut ();
        Result := S_OK;
      end;
      -2147418082 :
      begin
        OleVariant (VarResult^) := Doonbeforecopy ();
        Result := S_OK;
      end;
      -2147418085 :
      begin
        OleVariant (VarResult^) := Dooncopy ();
        Result := S_OK;
      end;
      -2147418081 :
      begin
        OleVariant (VarResult^) := Doonbeforepaste ();
        Result := S_OK;
      end;
      -2147418084 :
      begin
        OleVariant (VarResult^) := Doonpaste ();
        Result := S_OK;
      end;
      1023 :
      begin
        OleVariant (VarResult^) := Dooncontextmenu ();
        Result := S_OK;
      end;
      -2147418080 :
      begin
        Doonrowsdelete ();
        Result := S_OK;
      end;
      -2147418079 :
      begin
        Doonrowsinserted ();
        Result := S_OK;
      end;
      -2147418078 :
      begin
        Dooncellchange ();
        Result := S_OK;
      end;
      -609 :
      begin
        Doonreadystatechange ();
        Result := S_OK;
      end;
      1027 :
      begin
        Doonbeforeeditfocus ();
        Result := S_OK;
      end;
      1030 :
      begin
        Doonlayoutcomplete ();
        Result := S_OK;
      end;
      1031 :
      begin
        Doonpage ();
        Result := S_OK;
      end;
      1034 :
      begin
        OleVariant (VarResult^) := Doonbeforedeactivate ();
        Result := S_OK;
      end;
      1047 :
      begin
        OleVariant (VarResult^) := Doonbeforeactivate ();
        Result := S_OK;
      end;
      1035 :
      begin
        Doonmove ();
        Result := S_OK;
      end;
      1036 :
      begin
        OleVariant (VarResult^) := Dooncontrolselect ();
        Result := S_OK;
      end;
      1038 :
      begin
        OleVariant (VarResult^) := Doonmovestart ();
        Result := S_OK;
      end;
      1039 :
      begin
        Doonmoveend ();
        Result := S_OK;
      end;
      1040 :
      begin
        OleVariant (VarResult^) := Doonresizestart ();
        Result := S_OK;
      end;
      1041 :
      begin
        Doonresizeend ();
        Result := S_OK;
      end;
      1042 :
      begin
        Doonmouseenter ();
        Result := S_OK;
      end;
      1043 :
      begin
        Doonmouseleave ();
        Result := S_OK;
      end;
      1033 :
      begin
        OleVariant (VarResult^) := Doonmousewheel ();
        Result := S_OK;
      end;
      1044 :
      begin
        Doonactivate ();
        Result := S_OK;
      end;
      1045 :
      begin
        Doondeactivate ();
        Result := S_OK;
      end;
      1048 :
      begin
        Doonfocusin ();
        Result := S_OK;
      end;
      1049 :
      begin
        Doonfocusout ();
        Result := S_OK;
      end;
      1003 :
      begin
        Doonload ();
        Result := S_OK;
      end;
      1002 :
      begin
        Doonerror ();
        Result := S_OK;
      end;
    end;  { case }
  //SinkInvokeEnd//
end;

constructor TMSHTMLHTMLStyleElementEvents.Create (AOwner: TComponent);
begin
  inherited Create (AOwner);
  //SinkInit//
  FSinkIID := HTMLStyleElementEvents;
end;

//SinkImplementation//
function TMSHTMLHTMLStyleElementEvents.Doonhelp: WordBool;
begin
  if not Assigned (onhelp) then System.Exit;
  Result := onhelp (Self);
end;

function TMSHTMLHTMLStyleElementEvents.Doonclick: WordBool;
begin
  if not Assigned (onclick) then System.Exit;
  Result := onclick (Self);
end;

function TMSHTMLHTMLStyleElementEvents.Doondblclick: WordBool;
begin
  if not Assigned (ondblclick) then System.Exit;
  Result := ondblclick (Self);
end;

function TMSHTMLHTMLStyleElementEvents.Doonkeypress: WordBool;
begin
  if not Assigned (onkeypress) then System.Exit;
  Result := onkeypress (Self);
end;

procedure TMSHTMLHTMLStyleElementEvents.Doonkeydown;
begin
  if not Assigned (onkeydown) then System.Exit;
  onkeydown (Self);
end;

procedure TMSHTMLHTMLStyleElementEvents.Doonkeyup;
begin
  if not Assigned (onkeyup) then System.Exit;
  onkeyup (Self);
end;

procedure TMSHTMLHTMLStyleElementEvents.Doonmouseout;
begin
  if not Assigned (onmouseout) then System.Exit;
  onmouseout (Self);
end;

procedure TMSHTMLHTMLStyleElementEvents.Doonmouseover;
begin
  if not Assigned (onmouseover) then System.Exit;
  onmouseover (Self);
end;

procedure TMSHTMLHTMLStyleElementEvents.Doonmousemove;
begin
  if not Assigned (onmousemove) then System.Exit;
  onmousemove (Self);
end;

procedure TMSHTMLHTMLStyleElementEvents.Doonmousedown;
begin
  if not Assigned (onmousedown) then System.Exit;
  onmousedown (Self);
end;

procedure TMSHTMLHTMLStyleElementEvents.Doonmouseup;
begin
  if not Assigned (onmouseup) then System.Exit;
  onmouseup (Self);
end;

function TMSHTMLHTMLStyleElementEvents.Doonselectstart: WordBool;
begin
  if not Assigned (onselectstart) then System.Exit;
  Result := onselectstart (Self);
end;

procedure TMSHTMLHTMLStyleElementEvents.Doonfilterchange;
begin
  if not Assigned (onfilterchange) then System.Exit;
  onfilterchange (Self);
end;

function TMSHTMLHTMLStyleElementEvents.Doondragstart: WordBool;
begin
  if not Assigned (ondragstart) then System.Exit;
  Result := ondragstart (Self);
end;

function TMSHTMLHTMLStyleElementEvents.Doonbeforeupdate: WordBool;
begin
  if not Assigned (onbeforeupdate) then System.Exit;
  Result := onbeforeupdate (Self);
end;

procedure TMSHTMLHTMLStyleElementEvents.Doonafterupdate;
begin
  if not Assigned (onafterupdate) then System.Exit;
  onafterupdate (Self);
end;

function TMSHTMLHTMLStyleElementEvents.Doonerrorupdate: WordBool;
begin
  if not Assigned (onerrorupdate) then System.Exit;
  Result := onerrorupdate (Self);
end;

function TMSHTMLHTMLStyleElementEvents.Doonrowexit: WordBool;
begin
  if not Assigned (onrowexit) then System.Exit;
  Result := onrowexit (Self);
end;

procedure TMSHTMLHTMLStyleElementEvents.Doonrowenter;
begin
  if not Assigned (onrowenter) then System.Exit;
  onrowenter (Self);
end;

procedure TMSHTMLHTMLStyleElementEvents.Doondatasetchanged;
begin
  if not Assigned (ondatasetchanged) then System.Exit;
  ondatasetchanged (Self);
end;

procedure TMSHTMLHTMLStyleElementEvents.Doondataavailable;
begin
  if not Assigned (ondataavailable) then System.Exit;
  ondataavailable (Self);
end;

procedure TMSHTMLHTMLStyleElementEvents.Doondatasetcomplete;
begin
  if not Assigned (ondatasetcomplete) then System.Exit;
  ondatasetcomplete (Self);
end;

procedure TMSHTMLHTMLStyleElementEvents.Doonlosecapture;
begin
  if not Assigned (onlosecapture) then System.Exit;
  onlosecapture (Self);
end;

procedure TMSHTMLHTMLStyleElementEvents.Doonpropertychange;
begin
  if not Assigned (onpropertychange) then System.Exit;
  onpropertychange (Self);
end;

procedure TMSHTMLHTMLStyleElementEvents.Doonscroll;
begin
  if not Assigned (onscroll) then System.Exit;
  onscroll (Self);
end;

procedure TMSHTMLHTMLStyleElementEvents.Doonfocus;
begin
  if not Assigned (onfocus) then System.Exit;
  onfocus (Self);
end;

procedure TMSHTMLHTMLStyleElementEvents.Doonblur;
begin
  if not Assigned (onblur) then System.Exit;
  onblur (Self);
end;

procedure TMSHTMLHTMLStyleElementEvents.Doonresize;
begin
  if not Assigned (onresize) then System.Exit;
  onresize (Self);
end;

function TMSHTMLHTMLStyleElementEvents.Doondrag: WordBool;
begin
  if not Assigned (ondrag) then System.Exit;
  Result := ondrag (Self);
end;

procedure TMSHTMLHTMLStyleElementEvents.Doondragend;
begin
  if not Assigned (ondragend) then System.Exit;
  ondragend (Self);
end;

function TMSHTMLHTMLStyleElementEvents.Doondragenter: WordBool;
begin
  if not Assigned (ondragenter) then System.Exit;
  Result := ondragenter (Self);
end;

function TMSHTMLHTMLStyleElementEvents.Doondragover: WordBool;
begin
  if not Assigned (ondragover) then System.Exit;
  Result := ondragover (Self);
end;

procedure TMSHTMLHTMLStyleElementEvents.Doondragleave;
begin
  if not Assigned (ondragleave) then System.Exit;
  ondragleave (Self);
end;

function TMSHTMLHTMLStyleElementEvents.Doondrop: WordBool;
begin
  if not Assigned (ondrop) then System.Exit;
  Result := ondrop (Self);
end;

function TMSHTMLHTMLStyleElementEvents.Doonbeforecut: WordBool;
begin
  if not Assigned (onbeforecut) then System.Exit;
  Result := onbeforecut (Self);
end;

function TMSHTMLHTMLStyleElementEvents.Dooncut: WordBool;
begin
  if not Assigned (oncut) then System.Exit;
  Result := oncut (Self);
end;

function TMSHTMLHTMLStyleElementEvents.Doonbeforecopy: WordBool;
begin
  if not Assigned (onbeforecopy) then System.Exit;
  Result := onbeforecopy (Self);
end;

function TMSHTMLHTMLStyleElementEvents.Dooncopy: WordBool;
begin
  if not Assigned (oncopy) then System.Exit;
  Result := oncopy (Self);
end;

function TMSHTMLHTMLStyleElementEvents.Doonbeforepaste: WordBool;
begin
  if not Assigned (onbeforepaste) then System.Exit;
  Result := onbeforepaste (Self);
end;

function TMSHTMLHTMLStyleElementEvents.Doonpaste: WordBool;
begin
  if not Assigned (onpaste) then System.Exit;
  Result := onpaste (Self);
end;

function TMSHTMLHTMLStyleElementEvents.Dooncontextmenu: WordBool;
begin
  if not Assigned (oncontextmenu) then System.Exit;
  Result := oncontextmenu (Self);
end;

procedure TMSHTMLHTMLStyleElementEvents.Doonrowsdelete;
begin
  if not Assigned (onrowsdelete) then System.Exit;
  onrowsdelete (Self);
end;

procedure TMSHTMLHTMLStyleElementEvents.Doonrowsinserted;
begin
  if not Assigned (onrowsinserted) then System.Exit;
  onrowsinserted (Self);
end;

procedure TMSHTMLHTMLStyleElementEvents.Dooncellchange;
begin
  if not Assigned (oncellchange) then System.Exit;
  oncellchange (Self);
end;

procedure TMSHTMLHTMLStyleElementEvents.Doonreadystatechange;
begin
  if not Assigned (onreadystatechange) then System.Exit;
  onreadystatechange (Self);
end;

procedure TMSHTMLHTMLStyleElementEvents.Doonbeforeeditfocus;
begin
  if not Assigned (onbeforeeditfocus) then System.Exit;
  onbeforeeditfocus (Self);
end;

procedure TMSHTMLHTMLStyleElementEvents.Doonlayoutcomplete;
begin
  if not Assigned (onlayoutcomplete) then System.Exit;
  onlayoutcomplete (Self);
end;

procedure TMSHTMLHTMLStyleElementEvents.Doonpage;
begin
  if not Assigned (onpage) then System.Exit;
  onpage (Self);
end;

function TMSHTMLHTMLStyleElementEvents.Doonbeforedeactivate: WordBool;
begin
  if not Assigned (onbeforedeactivate) then System.Exit;
  Result := onbeforedeactivate (Self);
end;

function TMSHTMLHTMLStyleElementEvents.Doonbeforeactivate: WordBool;
begin
  if not Assigned (onbeforeactivate) then System.Exit;
  Result := onbeforeactivate (Self);
end;

procedure TMSHTMLHTMLStyleElementEvents.Doonmove;
begin
  if not Assigned (onmove) then System.Exit;
  onmove (Self);
end;

function TMSHTMLHTMLStyleElementEvents.Dooncontrolselect: WordBool;
begin
  if not Assigned (oncontrolselect) then System.Exit;
  Result := oncontrolselect (Self);
end;

function TMSHTMLHTMLStyleElementEvents.Doonmovestart: WordBool;
begin
  if not Assigned (onmovestart) then System.Exit;
  Result := onmovestart (Self);
end;

procedure TMSHTMLHTMLStyleElementEvents.Doonmoveend;
begin
  if not Assigned (onmoveend) then System.Exit;
  onmoveend (Self);
end;

function TMSHTMLHTMLStyleElementEvents.Doonresizestart: WordBool;
begin
  if not Assigned (onresizestart) then System.Exit;
  Result := onresizestart (Self);
end;

procedure TMSHTMLHTMLStyleElementEvents.Doonresizeend;
begin
  if not Assigned (onresizeend) then System.Exit;
  onresizeend (Self);
end;

procedure TMSHTMLHTMLStyleElementEvents.Doonmouseenter;
begin
  if not Assigned (onmouseenter) then System.Exit;
  onmouseenter (Self);
end;

procedure TMSHTMLHTMLStyleElementEvents.Doonmouseleave;
begin
  if not Assigned (onmouseleave) then System.Exit;
  onmouseleave (Self);
end;

function TMSHTMLHTMLStyleElementEvents.Doonmousewheel: WordBool;
begin
  if not Assigned (onmousewheel) then System.Exit;
  Result := onmousewheel (Self);
end;

procedure TMSHTMLHTMLStyleElementEvents.Doonactivate;
begin
  if not Assigned (onactivate) then System.Exit;
  onactivate (Self);
end;

procedure TMSHTMLHTMLStyleElementEvents.Doondeactivate;
begin
  if not Assigned (ondeactivate) then System.Exit;
  ondeactivate (Self);
end;

procedure TMSHTMLHTMLStyleElementEvents.Doonfocusin;
begin
  if not Assigned (onfocusin) then System.Exit;
  onfocusin (Self);
end;

procedure TMSHTMLHTMLStyleElementEvents.Doonfocusout;
begin
  if not Assigned (onfocusout) then System.Exit;
  onfocusout (Self);
end;

procedure TMSHTMLHTMLStyleElementEvents.Doonload;
begin
  if not Assigned (onload) then System.Exit;
  onload (Self);
end;

procedure TMSHTMLHTMLStyleElementEvents.Doonerror;
begin
  if not Assigned (onerror) then System.Exit;
  onerror (Self);
end;



function TMSHTMLHTMLStyleElementEvents2.DoInvoke (DispID: Integer; const IID: TGUID; LocaleID: Integer;
  Flags: Word; var dps: TDispParams; pDispIds: PDispIdList;
  VarResult, ExcepInfo, ArgErr: Pointer): HResult;
type
  POleVariant = ^OleVariant;
begin
  Result := DISP_E_MEMBERNOTFOUND;

  //SinkInvoke//
    case DispId of
      -2147418102 :
      begin
        OleVariant (VarResult^) := Doonhelp (IUnknown (dps.rgvarg^ [pDispIds^ [0]].unkval) as IHTMLEventObj);
        Result := S_OK;
      end;
      -600 :
      begin
        OleVariant (VarResult^) := Doonclick (IUnknown (dps.rgvarg^ [pDispIds^ [0]].unkval) as IHTMLEventObj);
        Result := S_OK;
      end;
      -601 :
      begin
        OleVariant (VarResult^) := Doondblclick (IUnknown (dps.rgvarg^ [pDispIds^ [0]].unkval) as IHTMLEventObj);
        Result := S_OK;
      end;
      -603 :
      begin
        OleVariant (VarResult^) := Doonkeypress (IUnknown (dps.rgvarg^ [pDispIds^ [0]].unkval) as IHTMLEventObj);
        Result := S_OK;
      end;
      -602 :
      begin
        Doonkeydown (IUnknown (dps.rgvarg^ [pDispIds^ [0]].unkval) as IHTMLEventObj);
        Result := S_OK;
      end;
      -604 :
      begin
        Doonkeyup (IUnknown (dps.rgvarg^ [pDispIds^ [0]].unkval) as IHTMLEventObj);
        Result := S_OK;
      end;
      -2147418103 :
      begin
        Doonmouseout (IUnknown (dps.rgvarg^ [pDispIds^ [0]].unkval) as IHTMLEventObj);
        Result := S_OK;
      end;
      -2147418104 :
      begin
        Doonmouseover (IUnknown (dps.rgvarg^ [pDispIds^ [0]].unkval) as IHTMLEventObj);
        Result := S_OK;
      end;
      -606 :
      begin
        Doonmousemove (IUnknown (dps.rgvarg^ [pDispIds^ [0]].unkval) as IHTMLEventObj);
        Result := S_OK;
      end;
      -605 :
      begin
        Doonmousedown (IUnknown (dps.rgvarg^ [pDispIds^ [0]].unkval) as IHTMLEventObj);
        Result := S_OK;
      end;
      -607 :
      begin
        Doonmouseup (IUnknown (dps.rgvarg^ [pDispIds^ [0]].unkval) as IHTMLEventObj);
        Result := S_OK;
      end;
      -2147418100 :
      begin
        OleVariant (VarResult^) := Doonselectstart (IUnknown (dps.rgvarg^ [pDispIds^ [0]].unkval) as IHTMLEventObj);
        Result := S_OK;
      end;
      -2147418095 :
      begin
        Doonfilterchange (IUnknown (dps.rgvarg^ [pDispIds^ [0]].unkval) as IHTMLEventObj);
        Result := S_OK;
      end;
      -2147418101 :
      begin
        OleVariant (VarResult^) := Doondragstart (IUnknown (dps.rgvarg^ [pDispIds^ [0]].unkval) as IHTMLEventObj);
        Result := S_OK;
      end;
      -2147418108 :
      begin
        OleVariant (VarResult^) := Doonbeforeupdate (IUnknown (dps.rgvarg^ [pDispIds^ [0]].unkval) as IHTMLEventObj);
        Result := S_OK;
      end;
      -2147418107 :
      begin
        Doonafterupdate (IUnknown (dps.rgvarg^ [pDispIds^ [0]].unkval) as IHTMLEventObj);
        Result := S_OK;
      end;
      -2147418099 :
      begin
        OleVariant (VarResult^) := Doonerrorupdate (IUnknown (dps.rgvarg^ [pDispIds^ [0]].unkval) as IHTMLEventObj);
        Result := S_OK;
      end;
      -2147418106 :
      begin
        OleVariant (VarResult^) := Doonrowexit (IUnknown (dps.rgvarg^ [pDispIds^ [0]].unkval) as IHTMLEventObj);
        Result := S_OK;
      end;
      -2147418105 :
      begin
        Doonrowenter (IUnknown (dps.rgvarg^ [pDispIds^ [0]].unkval) as IHTMLEventObj);
        Result := S_OK;
      end;
      -2147418098 :
      begin
        Doondatasetchanged (IUnknown (dps.rgvarg^ [pDispIds^ [0]].unkval) as IHTMLEventObj);
        Result := S_OK;
      end;
      -2147418097 :
      begin
        Doondataavailable (IUnknown (dps.rgvarg^ [pDispIds^ [0]].unkval) as IHTMLEventObj);
        Result := S_OK;
      end;
      -2147418096 :
      begin
        Doondatasetcomplete (IUnknown (dps.rgvarg^ [pDispIds^ [0]].unkval) as IHTMLEventObj);
        Result := S_OK;
      end;
      -2147418094 :
      begin
        Doonlosecapture (IUnknown (dps.rgvarg^ [pDispIds^ [0]].unkval) as IHTMLEventObj);
        Result := S_OK;
      end;
      -2147418093 :
      begin
        Doonpropertychange (IUnknown (dps.rgvarg^ [pDispIds^ [0]].unkval) as IHTMLEventObj);
        Result := S_OK;
      end;
      1014 :
      begin
        Doonscroll (IUnknown (dps.rgvarg^ [pDispIds^ [0]].unkval) as IHTMLEventObj);
        Result := S_OK;
      end;
      -2147418111 :
      begin
        Doonfocus (IUnknown (dps.rgvarg^ [pDispIds^ [0]].unkval) as IHTMLEventObj);
        Result := S_OK;
      end;
      -2147418112 :
      begin
        Doonblur (IUnknown (dps.rgvarg^ [pDispIds^ [0]].unkval) as IHTMLEventObj);
        Result := S_OK;
      end;
      1016 :
      begin
        Doonresize (IUnknown (dps.rgvarg^ [pDispIds^ [0]].unkval) as IHTMLEventObj);
        Result := S_OK;
      end;
      -2147418092 :
      begin
        OleVariant (VarResult^) := Doondrag (IUnknown (dps.rgvarg^ [pDispIds^ [0]].unkval) as IHTMLEventObj);
        Result := S_OK;
      end;
      -2147418091 :
      begin
        Doondragend (IUnknown (dps.rgvarg^ [pDispIds^ [0]].unkval) as IHTMLEventObj);
        Result := S_OK;
      end;
      -2147418090 :
      begin
        OleVariant (VarResult^) := Doondragenter (IUnknown (dps.rgvarg^ [pDispIds^ [0]].unkval) as IHTMLEventObj);
        Result := S_OK;
      end;
      -2147418089 :
      begin
        OleVariant (VarResult^) := Doondragover (IUnknown (dps.rgvarg^ [pDispIds^ [0]].unkval) as IHTMLEventObj);
        Result := S_OK;
      end;
      -2147418088 :
      begin
        Doondragleave (IUnknown (dps.rgvarg^ [pDispIds^ [0]].unkval) as IHTMLEventObj);
        Result := S_OK;
      end;
      -2147418087 :
      begin
        OleVariant (VarResult^) := Doondrop (IUnknown (dps.rgvarg^ [pDispIds^ [0]].unkval) as IHTMLEventObj);
        Result := S_OK;
      end;
      -2147418083 :
      begin
        OleVariant (VarResult^) := Doonbeforecut (IUnknown (dps.rgvarg^ [pDispIds^ [0]].unkval) as IHTMLEventObj);
        Result := S_OK;
      end;
      -2147418086 :
      begin
        OleVariant (VarResult^) := Dooncut (IUnknown (dps.rgvarg^ [pDispIds^ [0]].unkval) as IHTMLEventObj);
        Result := S_OK;
      end;
      -2147418082 :
      begin
        OleVariant (VarResult^) := Doonbeforecopy (IUnknown (dps.rgvarg^ [pDispIds^ [0]].unkval) as IHTMLEventObj);
        Result := S_OK;
      end;
      -2147418085 :
      begin
        OleVariant (VarResult^) := Dooncopy (IUnknown (dps.rgvarg^ [pDispIds^ [0]].unkval) as IHTMLEventObj);
        Result := S_OK;
      end;
      -2147418081 :
      begin
        OleVariant (VarResult^) := Doonbeforepaste (IUnknown (dps.rgvarg^ [pDispIds^ [0]].unkval) as IHTMLEventObj);
        Result := S_OK;
      end;
      -2147418084 :
      begin
        OleVariant (VarResult^) := Doonpaste (IUnknown (dps.rgvarg^ [pDispIds^ [0]].unkval) as IHTMLEventObj);
        Result := S_OK;
      end;
      1023 :
      begin
        OleVariant (VarResult^) := Dooncontextmenu (IUnknown (dps.rgvarg^ [pDispIds^ [0]].unkval) as IHTMLEventObj);
        Result := S_OK;
      end;
      -2147418080 :
      begin
        Doonrowsdelete (IUnknown (dps.rgvarg^ [pDispIds^ [0]].unkval) as IHTMLEventObj);
        Result := S_OK;
      end;
      -2147418079 :
      begin
        Doonrowsinserted (IUnknown (dps.rgvarg^ [pDispIds^ [0]].unkval) as IHTMLEventObj);
        Result := S_OK;
      end;
      -2147418078 :
      begin
        Dooncellchange (IUnknown (dps.rgvarg^ [pDispIds^ [0]].unkval) as IHTMLEventObj);
        Result := S_OK;
      end;
      -609 :
      begin
        Doonreadystatechange (IUnknown (dps.rgvarg^ [pDispIds^ [0]].unkval) as IHTMLEventObj);
        Result := S_OK;
      end;
      1030 :
      begin
        Doonlayoutcomplete (IUnknown (dps.rgvarg^ [pDispIds^ [0]].unkval) as IHTMLEventObj);
        Result := S_OK;
      end;
      1031 :
      begin
        Doonpage (IUnknown (dps.rgvarg^ [pDispIds^ [0]].unkval) as IHTMLEventObj);
        Result := S_OK;
      end;
      1042 :
      begin
        Doonmouseenter (IUnknown (dps.rgvarg^ [pDispIds^ [0]].unkval) as IHTMLEventObj);
        Result := S_OK;
      end;
      1043 :
      begin
        Doonmouseleave (IUnknown (dps.rgvarg^ [pDispIds^ [0]].unkval) as IHTMLEventObj);
        Result := S_OK;
      end;
      1044 :
      begin
        Doonactivate (IUnknown (dps.rgvarg^ [pDispIds^ [0]].unkval) as IHTMLEventObj);
        Result := S_OK;
      end;
      1045 :
      begin
        Doondeactivate (IUnknown (dps.rgvarg^ [pDispIds^ [0]].unkval) as IHTMLEventObj);
        Result := S_OK;
      end;
      1034 :
      begin
        OleVariant (VarResult^) := Doonbeforedeactivate (IUnknown (dps.rgvarg^ [pDispIds^ [0]].unkval) as IHTMLEventObj);
        Result := S_OK;
      end;
      1047 :
      begin
        OleVariant (VarResult^) := Doonbeforeactivate (IUnknown (dps.rgvarg^ [pDispIds^ [0]].unkval) as IHTMLEventObj);
        Result := S_OK;
      end;
      1048 :
      begin
        Doonfocusin (IUnknown (dps.rgvarg^ [pDispIds^ [0]].unkval) as IHTMLEventObj);
        Result := S_OK;
      end;
      1049 :
      begin
        Doonfocusout (IUnknown (dps.rgvarg^ [pDispIds^ [0]].unkval) as IHTMLEventObj);
        Result := S_OK;
      end;
      1035 :
      begin
        Doonmove (IUnknown (dps.rgvarg^ [pDispIds^ [0]].unkval) as IHTMLEventObj);
        Result := S_OK;
      end;
      1036 :
      begin
        OleVariant (VarResult^) := Dooncontrolselect (IUnknown (dps.rgvarg^ [pDispIds^ [0]].unkval) as IHTMLEventObj);
        Result := S_OK;
      end;
      1038 :
      begin
        OleVariant (VarResult^) := Doonmovestart (IUnknown (dps.rgvarg^ [pDispIds^ [0]].unkval) as IHTMLEventObj);
        Result := S_OK;
      end;
      1039 :
      begin
        Doonmoveend (IUnknown (dps.rgvarg^ [pDispIds^ [0]].unkval) as IHTMLEventObj);
        Result := S_OK;
      end;
      1040 :
      begin
        OleVariant (VarResult^) := Doonresizestart (IUnknown (dps.rgvarg^ [pDispIds^ [0]].unkval) as IHTMLEventObj);
        Result := S_OK;
      end;
      1041 :
      begin
        Doonresizeend (IUnknown (dps.rgvarg^ [pDispIds^ [0]].unkval) as IHTMLEventObj);
        Result := S_OK;
      end;
      1033 :
      begin
        OleVariant (VarResult^) := Doonmousewheel (IUnknown (dps.rgvarg^ [pDispIds^ [0]].unkval) as IHTMLEventObj);
        Result := S_OK;
      end;
      1003 :
      begin
        Doonload (IUnknown (dps.rgvarg^ [pDispIds^ [0]].unkval) as IHTMLEventObj);
        Result := S_OK;
      end;
      1002 :
      begin
        Doonerror (IUnknown (dps.rgvarg^ [pDispIds^ [0]].unkval) as IHTMLEventObj);
        Result := S_OK;
      end;
    end;  { case }
  //SinkInvokeEnd//
end;

constructor TMSHTMLHTMLStyleElementEvents2.Create (AOwner: TComponent);
begin
  inherited Create (AOwner);
  //SinkInit//
  FSinkIID := HTMLStyleElementEvents2;
end;

//SinkImplementation//
function TMSHTMLHTMLStyleElementEvents2.Doonhelp(const pEvtObj: IHTMLEventObj): WordBool;
begin
  if not Assigned (onhelp) then System.Exit;
  Result := onhelp (Self, pEvtObj);
end;

function TMSHTMLHTMLStyleElementEvents2.Doonclick(const pEvtObj: IHTMLEventObj): WordBool;
begin
  if not Assigned (onclick) then System.Exit;
  Result := onclick (Self, pEvtObj);
end;

function TMSHTMLHTMLStyleElementEvents2.Doondblclick(const pEvtObj: IHTMLEventObj): WordBool;
begin
  if not Assigned (ondblclick) then System.Exit;
  Result := ondblclick (Self, pEvtObj);
end;

function TMSHTMLHTMLStyleElementEvents2.Doonkeypress(const pEvtObj: IHTMLEventObj): WordBool;
begin
  if not Assigned (onkeypress) then System.Exit;
  Result := onkeypress (Self, pEvtObj);
end;

procedure TMSHTMLHTMLStyleElementEvents2.Doonkeydown(const pEvtObj: IHTMLEventObj);
begin
  if not Assigned (onkeydown) then System.Exit;
  onkeydown (Self, pEvtObj);
end;

procedure TMSHTMLHTMLStyleElementEvents2.Doonkeyup(const pEvtObj: IHTMLEventObj);
begin
  if not Assigned (onkeyup) then System.Exit;
  onkeyup (Self, pEvtObj);
end;

procedure TMSHTMLHTMLStyleElementEvents2.Doonmouseout(const pEvtObj: IHTMLEventObj);
begin
  if not Assigned (onmouseout) then System.Exit;
  onmouseout (Self, pEvtObj);
end;

procedure TMSHTMLHTMLStyleElementEvents2.Doonmouseover(const pEvtObj: IHTMLEventObj);
begin
  if not Assigned (onmouseover) then System.Exit;
  onmouseover (Self, pEvtObj);
end;

procedure TMSHTMLHTMLStyleElementEvents2.Doonmousemove(const pEvtObj: IHTMLEventObj);
begin
  if not Assigned (onmousemove) then System.Exit;
  onmousemove (Self, pEvtObj);
end;

procedure TMSHTMLHTMLStyleElementEvents2.Doonmousedown(const pEvtObj: IHTMLEventObj);
begin
  if not Assigned (onmousedown) then System.Exit;
  onmousedown (Self, pEvtObj);
end;

procedure TMSHTMLHTMLStyleElementEvents2.Doonmouseup(const pEvtObj: IHTMLEventObj);
begin
  if not Assigned (onmouseup) then System.Exit;
  onmouseup (Self, pEvtObj);
end;

function TMSHTMLHTMLStyleElementEvents2.Doonselectstart(const pEvtObj: IHTMLEventObj): WordBool;
begin
  if not Assigned (onselectstart) then System.Exit;
  Result := onselectstart (Self, pEvtObj);
end;

procedure TMSHTMLHTMLStyleElementEvents2.Doonfilterchange(const pEvtObj: IHTMLEventObj);
begin
  if not Assigned (onfilterchange) then System.Exit;
  onfilterchange (Self, pEvtObj);
end;

function TMSHTMLHTMLStyleElementEvents2.Doondragstart(const pEvtObj: IHTMLEventObj): WordBool;
begin
  if not Assigned (ondragstart) then System.Exit;
  Result := ondragstart (Self, pEvtObj);
end;

function TMSHTMLHTMLStyleElementEvents2.Doonbeforeupdate(const pEvtObj: IHTMLEventObj): WordBool;
begin
  if not Assigned (onbeforeupdate) then System.Exit;
  Result := onbeforeupdate (Self, pEvtObj);
end;

procedure TMSHTMLHTMLStyleElementEvents2.Doonafterupdate(const pEvtObj: IHTMLEventObj);
begin
  if not Assigned (onafterupdate) then System.Exit;
  onafterupdate (Self, pEvtObj);
end;

function TMSHTMLHTMLStyleElementEvents2.Doonerrorupdate(const pEvtObj: IHTMLEventObj): WordBool;
begin
  if not Assigned (onerrorupdate) then System.Exit;
  Result := onerrorupdate (Self, pEvtObj);
end;

function TMSHTMLHTMLStyleElementEvents2.Doonrowexit(const pEvtObj: IHTMLEventObj): WordBool;
begin
  if not Assigned (onrowexit) then System.Exit;
  Result := onrowexit (Self, pEvtObj);
end;

procedure TMSHTMLHTMLStyleElementEvents2.Doonrowenter(const pEvtObj: IHTMLEventObj);
begin
  if not Assigned (onrowenter) then System.Exit;
  onrowenter (Self, pEvtObj);
end;

procedure TMSHTMLHTMLStyleElementEvents2.Doondatasetchanged(const pEvtObj: IHTMLEventObj);
begin
  if not Assigned (ondatasetchanged) then System.Exit;
  ondatasetchanged (Self, pEvtObj);
end;

procedure TMSHTMLHTMLStyleElementEvents2.Doondataavailable(const pEvtObj: IHTMLEventObj);
begin
  if not Assigned (ondataavailable) then System.Exit;
  ondataavailable (Self, pEvtObj);
end;

procedure TMSHTMLHTMLStyleElementEvents2.Doondatasetcomplete(const pEvtObj: IHTMLEventObj);
begin
  if not Assigned (ondatasetcomplete) then System.Exit;
  ondatasetcomplete (Self, pEvtObj);
end;

procedure TMSHTMLHTMLStyleElementEvents2.Doonlosecapture(const pEvtObj: IHTMLEventObj);
begin
  if not Assigned (onlosecapture) then System.Exit;
  onlosecapture (Self, pEvtObj);
end;

procedure TMSHTMLHTMLStyleElementEvents2.Doonpropertychange(const pEvtObj: IHTMLEventObj);
begin
  if not Assigned (onpropertychange) then System.Exit;
  onpropertychange (Self, pEvtObj);
end;

procedure TMSHTMLHTMLStyleElementEvents2.Doonscroll(const pEvtObj: IHTMLEventObj);
begin
  if not Assigned (onscroll) then System.Exit;
  onscroll (Self, pEvtObj);
end;

procedure TMSHTMLHTMLStyleElementEvents2.Doonfocus(const pEvtObj: IHTMLEventObj);
begin
  if not Assigned (onfocus) then System.Exit;
  onfocus (Self, pEvtObj);
end;

procedure TMSHTMLHTMLStyleElementEvents2.Doonblur(const pEvtObj: IHTMLEventObj);
begin
  if not Assigned (onblur) then System.Exit;
  onblur (Self, pEvtObj);
end;

procedure TMSHTMLHTMLStyleElementEvents2.Doonresize(const pEvtObj: IHTMLEventObj);
begin
  if not Assigned (onresize) then System.Exit;
  onresize (Self, pEvtObj);
end;

function TMSHTMLHTMLStyleElementEvents2.Doondrag(const pEvtObj: IHTMLEventObj): WordBool;
begin
  if not Assigned (ondrag) then System.Exit;
  Result := ondrag (Self, pEvtObj);
end;

procedure TMSHTMLHTMLStyleElementEvents2.Doondragend(const pEvtObj: IHTMLEventObj);
begin
  if not Assigned (ondragend) then System.Exit;
  ondragend (Self, pEvtObj);
end;

function TMSHTMLHTMLStyleElementEvents2.Doondragenter(const pEvtObj: IHTMLEventObj): WordBool;
begin
  if not Assigned (ondragenter) then System.Exit;
  Result := ondragenter (Self, pEvtObj);
end;

function TMSHTMLHTMLStyleElementEvents2.Doondragover(const pEvtObj: IHTMLEventObj): WordBool;
begin
  if not Assigned (ondragover) then System.Exit;
  Result := ondragover (Self, pEvtObj);
end;

procedure TMSHTMLHTMLStyleElementEvents2.Doondragleave(const pEvtObj: IHTMLEventObj);
begin
  if not Assigned (ondragleave) then System.Exit;
  ondragleave (Self, pEvtObj);
end;

function TMSHTMLHTMLStyleElementEvents2.Doondrop(const pEvtObj: IHTMLEventObj): WordBool;
begin
  if not Assigned (ondrop) then System.Exit;
  Result := ondrop (Self, pEvtObj);
end;

function TMSHTMLHTMLStyleElementEvents2.Doonbeforecut(const pEvtObj: IHTMLEventObj): WordBool;
begin
  if not Assigned (onbeforecut) then System.Exit;
  Result := onbeforecut (Self, pEvtObj);
end;

function TMSHTMLHTMLStyleElementEvents2.Dooncut(const pEvtObj: IHTMLEventObj): WordBool;
begin
  if not Assigned (oncut) then System.Exit;
  Result := oncut (Self, pEvtObj);
end;

function TMSHTMLHTMLStyleElementEvents2.Doonbeforecopy(const pEvtObj: IHTMLEventObj): WordBool;
begin
  if not Assigned (onbeforecopy) then System.Exit;
  Result := onbeforecopy (Self, pEvtObj);
end;

function TMSHTMLHTMLStyleElementEvents2.Dooncopy(const pEvtObj: IHTMLEventObj): WordBool;
begin
  if not Assigned (oncopy) then System.Exit;
  Result := oncopy (Self, pEvtObj);
end;

function TMSHTMLHTMLStyleElementEvents2.Doonbeforepaste(const pEvtObj: IHTMLEventObj): WordBool;
begin
  if not Assigned (onbeforepaste) then System.Exit;
  Result := onbeforepaste (Self, pEvtObj);
end;

function TMSHTMLHTMLStyleElementEvents2.Doonpaste(const pEvtObj: IHTMLEventObj): WordBool;
begin
  if not Assigned (onpaste) then System.Exit;
  Result := onpaste (Self, pEvtObj);
end;

function TMSHTMLHTMLStyleElementEvents2.Dooncontextmenu(const pEvtObj: IHTMLEventObj): WordBool;
begin
  if not Assigned (oncontextmenu) then System.Exit;
  Result := oncontextmenu (Self, pEvtObj);
end;

procedure TMSHTMLHTMLStyleElementEvents2.Doonrowsdelete(const pEvtObj: IHTMLEventObj);
begin
  if not Assigned (onrowsdelete) then System.Exit;
  onrowsdelete (Self, pEvtObj);
end;

procedure TMSHTMLHTMLStyleElementEvents2.Doonrowsinserted(const pEvtObj: IHTMLEventObj);
begin
  if not Assigned (onrowsinserted) then System.Exit;
  onrowsinserted (Self, pEvtObj);
end;

procedure TMSHTMLHTMLStyleElementEvents2.Dooncellchange(const pEvtObj: IHTMLEventObj);
begin
  if not Assigned (oncellchange) then System.Exit;
  oncellchange (Self, pEvtObj);
end;

procedure TMSHTMLHTMLStyleElementEvents2.Doonreadystatechange(const pEvtObj: IHTMLEventObj);
begin
  if not Assigned (onreadystatechange) then System.Exit;
  onreadystatechange (Self, pEvtObj);
end;

procedure TMSHTMLHTMLStyleElementEvents2.Doonlayoutcomplete(const pEvtObj: IHTMLEventObj);
begin
  if not Assigned (onlayoutcomplete) then System.Exit;
  onlayoutcomplete (Self, pEvtObj);
end;

procedure TMSHTMLHTMLStyleElementEvents2.Doonpage(const pEvtObj: IHTMLEventObj);
begin
  if not Assigned (onpage) then System.Exit;
  onpage (Self, pEvtObj);
end;

procedure TMSHTMLHTMLStyleElementEvents2.Doonmouseenter(const pEvtObj: IHTMLEventObj);
begin
  if not Assigned (onmouseenter) then System.Exit;
  onmouseenter (Self, pEvtObj);
end;

procedure TMSHTMLHTMLStyleElementEvents2.Doonmouseleave(const pEvtObj: IHTMLEventObj);
begin
  if not Assigned (onmouseleave) then System.Exit;
  onmouseleave (Self, pEvtObj);
end;

procedure TMSHTMLHTMLStyleElementEvents2.Doonactivate(const pEvtObj: IHTMLEventObj);
begin
  if not Assigned (onactivate) then System.Exit;
  onactivate (Self, pEvtObj);
end;

procedure TMSHTMLHTMLStyleElementEvents2.Doondeactivate(const pEvtObj: IHTMLEventObj);
begin
  if not Assigned (ondeactivate) then System.Exit;
  ondeactivate (Self, pEvtObj);
end;

function TMSHTMLHTMLStyleElementEvents2.Doonbeforedeactivate(const pEvtObj: IHTMLEventObj): WordBool;
begin
  if not Assigned (onbeforedeactivate) then System.Exit;
  Result := onbeforedeactivate (Self, pEvtObj);
end;

function TMSHTMLHTMLStyleElementEvents2.Doonbeforeactivate(const pEvtObj: IHTMLEventObj): WordBool;
begin
  if not Assigned (onbeforeactivate) then System.Exit;
  Result := onbeforeactivate (Self, pEvtObj);
end;

procedure TMSHTMLHTMLStyleElementEvents2.Doonfocusin(const pEvtObj: IHTMLEventObj);
begin
  if not Assigned (onfocusin) then System.Exit;
  onfocusin (Self, pEvtObj);
end;

procedure TMSHTMLHTMLStyleElementEvents2.Doonfocusout(const pEvtObj: IHTMLEventObj);
begin
  if not Assigned (onfocusout) then System.Exit;
  onfocusout (Self, pEvtObj);
end;

procedure TMSHTMLHTMLStyleElementEvents2.Doonmove(const pEvtObj: IHTMLEventObj);
begin
  if not Assigned (onmove) then System.Exit;
  onmove (Self, pEvtObj);
end;

function TMSHTMLHTMLStyleElementEvents2.Dooncontrolselect(const pEvtObj: IHTMLEventObj): WordBool;
begin
  if not Assigned (oncontrolselect) then System.Exit;
  Result := oncontrolselect (Self, pEvtObj);
end;

function TMSHTMLHTMLStyleElementEvents2.Doonmovestart(const pEvtObj: IHTMLEventObj): WordBool;
begin
  if not Assigned (onmovestart) then System.Exit;
  Result := onmovestart (Self, pEvtObj);
end;

procedure TMSHTMLHTMLStyleElementEvents2.Doonmoveend(const pEvtObj: IHTMLEventObj);
begin
  if not Assigned (onmoveend) then System.Exit;
  onmoveend (Self, pEvtObj);
end;

function TMSHTMLHTMLStyleElementEvents2.Doonresizestart(const pEvtObj: IHTMLEventObj): WordBool;
begin
  if not Assigned (onresizestart) then System.Exit;
  Result := onresizestart (Self, pEvtObj);
end;

procedure TMSHTMLHTMLStyleElementEvents2.Doonresizeend(const pEvtObj: IHTMLEventObj);
begin
  if not Assigned (onresizeend) then System.Exit;
  onresizeend (Self, pEvtObj);
end;

function TMSHTMLHTMLStyleElementEvents2.Doonmousewheel(const pEvtObj: IHTMLEventObj): WordBool;
begin
  if not Assigned (onmousewheel) then System.Exit;
  Result := onmousewheel (Self, pEvtObj);
end;

procedure TMSHTMLHTMLStyleElementEvents2.Doonload(const pEvtObj: IHTMLEventObj);
begin
  if not Assigned (onload) then System.Exit;
  onload (Self, pEvtObj);
end;

procedure TMSHTMLHTMLStyleElementEvents2.Doonerror(const pEvtObj: IHTMLEventObj);
begin
  if not Assigned (onerror) then System.Exit;
  onerror (Self, pEvtObj);
end;


//SinkImplEnd//

procedure Register;
begin
  //SinkRegisterStart//
  RegisterComponents ('ActiveX', [TMSHTMLHTMLElementEvents]);
  RegisterComponents ('ActiveX', [TMSHTMLHTMLElementEvents2]);
  RegisterComponents ('ActiveX', [TMSHTMLHTMLButtonElementEvents2]);
  RegisterComponents ('ActiveX', [TMSHTMLHTMLWindowEvents]);
  RegisterComponents ('ActiveX', [TMSHTMLHTMLWindowEvents2]);
  RegisterComponents ('ActiveX', [TMSHTMLHTMLDocumentEvents]);
  RegisterComponents ('ActiveX', [TMSHTMLHTMLDocumentEvents2]);
  RegisterComponents ('ActiveX', [TMSHTMLHTMLStyleElementEvents]);
  RegisterComponents ('ActiveX', [TMSHTMLHTMLStyleElementEvents2]);
  //SinkRegisterEnd//
end;


end.



