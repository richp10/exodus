unit RichEdit2;

{
  RichEdit98 and DBRichEdit98 components for Delphi 3.0-4.0. version 1.40
  Author Alexander Obukhov, Minsk, Belarus <alex@niiomr.belpak.minsk.by>

  OLE support code written by
    Greg Chapman <glc@well.com>
    Mike Lindre <MikeL@chemware.co.uk>
    Tomasz Kustra <tom_kust@friko5.onet.pl>
    Sigi <medcom@tm.net.my>

  Thanks to:
    Oliver Matla <wolfpack@eulink.net>
    Glenn Benes <gjbenes@infocompii.com>
    Sven Opitz <S.Opitz@Cardy.de>
    Jolios Lin <jolios3@mail.photin.com.tw>
    Tom Wang <wangtao@netchina.com.cn>
    Doron Tal <dorontal@netvision.net.il>
    Alexander Halser <halser@easycash.co.at>
    Arentjan Banck <ajbanck@davilex.nl>
    Andre Van Der Merwe <dart@iafrica.com>
    Iain Magee <iain@swiftsoft.net>
    Sigi <medcom@tm.net.my>
    Rob Schoenaker <rschoenaker@kraan.com>
    Laszlo Kovacs <kovacsl@westel900.net>
}

interface

uses
    Langs, WStrList,
    Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
    StdCtrls, ComCtrls, ComStrs, RichEdit,
    {$ifdef BDE_SUPPORT}
    DB, DBCtrls,
    {$endif}
    ActiveX,OleCtnrs,olectrls,ComObj,OleDlg,RichOle,Menus, Printers;

const
  FT_DOWNWARD = 1;
  DataFormatCount = 2;

var
  CF_RTF: Cardinal = 0;
  CF_RTFNOOBJS: Cardinal = 0;
  CF_RETEXTOBJ: Cardinal = 0;

type
{ The declarations of TTextRangeA and TTextRangeW in Richedit.pas are incorrect}
  TTextRangeA = record
    chrg: TCharRange;
    lpstrText: PAnsiChar; {not AnsiChar!}
  end;

  TTextRangeW = record
    chrg: TCharRange;
    lpstrText: PWideChar; {not WideChar!}
  end;

  TTextRange = TTextRangeA;

  TInputFormat=(ifText, ifRTF, ifUnicode);
  TOutputFormat=(ofText, ofRTF, ofRTFNoObjs, ofTextized, ofUnicode);

  TSearchType98 = (stBackward, stWholeWord, stMatchCase);
  TSearchTypes98 = set of TSearchType98;

  TCustomRichEdit98 = class;

  TConsistentAttribute98 = (caBold, caColor, caFace, caItalic,
    caSize, caStrikeOut, caUnderline, caProtected, caWeight,
    caBackColor, caLanguage, caIndexKind, caOffset, caSpacing,
    caKerning, caULType, caAnimation, caSmallCaps, caAllCaps,
    caHidden, caOutline, caShadow, caEmboss, caImprint, caURL);
  TConsistentAttributes98 = set of TConsistentAttribute98;

  TIndexKind = (ikNone, ikSubscript, ikSuperscript);

  TUnderlineType = (ultNone, ultSingle, ultWord, ultDouble, ultDotted, ultWave,
                    ultThick, ultHair, ultDashDD, ultDashD, ultDash);

  TAnimationType = (aniNone, aniLasVegas, aniBlink, aniSparkle, aniBlackAnts,
                    aniRedAnts, aniShimmer);

  TRichEditOleCallback = class(TInterfacedObject, IRichEditOleCallback)
  private
    FOwner: TCustomRichEdit98;
  protected
    function GetNewStorage(out stg: IStorage): HRESULT; stdcall;
    function GetInPlaceContext(out Frame: IOleInPlaceFrame;
         out Doc: IOleInPlaceUIWindow; var FrameInfo: TOleInPlaceFrameInfo): HRESULT; stdcall;
    function ShowContainerUI(fShow: BOOL): HRESULT; stdcall;
    function QueryInsertObject(const clsid: TCLSID; stg: IStorage; cp: longint): HRESULT; stdcall;
    function DeleteObject(oleobj: IOLEObject): HRESULT; stdcall;
    function QueryAcceptData(dataobj: IDataObject; var cfFormat: TClipFormat;
         reco: DWORD; fReally: BOOL; hMetaPict: HGLOBAL): HRESULT; stdcall;
    function ContextSensitiveHelp(fEnterMode: BOOL): HRESULT; stdcall;
    function GetClipboardData(const chrg: TCharRange; reco: DWORD;
         out dataobj: IDataObject): HRESULT; stdcall;
    function GetDragDropEffect(fDrag: BOOL; grfKeyState: DWORD;
         var dwEffect: DWORD): HRESULT; stdcall;
    function GetContextMenu(seltype: Word; oleobj: IOleObject;
         const chrg: TCharRange; var menu: HMENU): HRESULT; stdcall;
  public
    constructor Create(AOwner: TCustomRichEdit98);
  end;


  TTextAttributes98 = class(TPersistent)
  private
    RichEdit: TCustomRichEdit98;
    FType: TAttributeType;
    FOldAttr: TTextattributes;
    procedure GetAttributes(var Format: TCharFormat2W);
    function GetConsistentAttributes: TConsistentAttributes98;
    procedure SetAttributes(var Format: TCharFormat2W);
  protected
    procedure InitFormat(var Format: TCharFormat2W);
    procedure AssignTo(Dest: TPersistent); override;
    function GetColor: TColor;
    procedure SetColor(Value: TColor);
    function GetName: TFontName;
    procedure SetName(Value: TFontName);
    function GetPitch: TFontPitch;
    procedure SetPitch(Value: TFontPitch);
    function GetProtected: Boolean;
    procedure SetProtected(Value: Boolean);
    function GetSize: Integer;
    procedure SetSize(Value: Integer);
    function GetHeight: Integer;
    procedure SetHeight(Value: Integer);
    function GetWeight: Word;
    procedure SetWeight(Value: Word);
    function GetBackColor: TColor;
    procedure SetBackColor(Value: TColor);
    function GetLanguage: TLanguage;
    procedure SetLanguage(Value: TLanguage);
    function GetIndexKind: TIndexKind;
    procedure SetIndexKind(Value: TIndexKind);
    function GetOffset: Double;
    procedure SetOffset(Value: Double);
    function GetSpacing: Double;
    procedure SetSpacing(Value: Double);
    function GetKerning: Double;
    procedure SetKerning(Value: Double);
    function GetUnderlineType: TUnderlineType;
    procedure SetUnderlineType(Value: TUnderlineType);
    function GetAnimation: TAnimationType;
    procedure SetAnimation(Value: TAnimationType);
    function GetBold: Boolean;
    procedure SetBold(Value: Boolean);
    function GetItalic: Boolean;
    procedure SetItalic(Value: Boolean);
    function GetStrikeOut: Boolean;
    procedure SetStrikeOut(Value: Boolean);
    function GetSmallCaps: Boolean;
    procedure SetSmallCaps(Value: Boolean);
    function GetAllCaps: Boolean;
    procedure SetAllCaps(Value: Boolean);
    function GetHidden: Boolean;
    procedure SetHidden(Value: Boolean);
    function GetOutline: Boolean;
    procedure SetOutline(Value: Boolean);
    function GetShadow: Boolean;
    procedure SetShadow(Value: Boolean);
    function GetEmboss: Boolean;
    procedure SetEmboss(Value: Boolean);
    function GetImprint: Boolean;
    procedure SetImprint(Value: Boolean);
    function GetStyle: TFontStyles;
    procedure SetStyle(Value: TFontStyles);
    function GetIsURL: Boolean;
    procedure SetIsURL(Value: Boolean);
  public
    constructor Create(AOwner: TCustomRichEdit98; AttributeType: TAttributeType);
    procedure Assign(Source: TPersistent); override;
    property ConsistentAttributes: TConsistentAttributes98 read GetConsistentAttributes;
    property Color: TColor read GetColor write SetColor;
    property Name: TFontName read GetName write SetName;
    property Pitch: TFontPitch read GetPitch write SetPitch;
    property Protected: Boolean read GetProtected write SetProtected;
    property Size: Integer read GetSize write SetSize;
    property Height: Integer read GetHeight write SetHeight;
    property Weight: Word read GetWeight write SetWeight;
    property BackColor: TColor read GetBackColor write SetBackColor;
    property Language: TLanguage read GetLanguage write SetLanguage;
    property IndexKind: TIndexKind read GetIndexKind write SetIndexKind;
    property Offset: Double read GetOffset write SetOffset;
    property Spacing: Double read GetSpacing write SetSpacing;
    property Kerning: Double read GetKerning write SetKerning;
    property UnderlineType: TUnderlineType read GetUnderlineType write SetUnderlineType;
    property Animation: TAnimationType read GetAnimation write SetAnimation;
    property Bold: Boolean read GetBold write SetBold;
    property Italic: Boolean read GetItalic write SetItalic;
    property StrikeOut: Boolean read GetStrikeOut write SetStrikeOut;
    property SmallCaps: Boolean read GetSmallCaps write SetSmallCaps;
    property AllCaps: Boolean read GetAllCaps write SetAllCaps;
    property Hidden: Boolean read GetHidden write SetHidden;
    property Outline: Boolean read GetOutline write SetOutline;
    property Shadow: Boolean read GetShadow write SetShadow;
    property Emboss: Boolean read GetEmboss write SetEmboss;
    property Imprint: Boolean read GetImprint write SetImprint;
    property Style: TFontStyles read GetStyle write SetStyle;
    property IsURL: Boolean read GetIsURL write SetIsURL;
  end;

  TLineSpacingRule = (lsrOrdinary, lsr15, lsrDouble, lsrAtLeast, lsrExactly,
                      lsrMultiple);

  TAlignment98 = (taLeft, taRight, taCenter, taJustify);

  TNumberingStyle98 = (nsNone, nsBullet, nsNumber, nsLowerCase, nsUpperCase,
                       nsLowerRoman, nsUpperRoman, nsSequence);

  TNumberingFollow = (nfParenthesis, nfPeriod, nfEncloseParenthesis);

  TBorderLocation = (blLeft, blRight, blTop, blBottom, blInside, blOutside);
  TBorderLocations = set of TBorderLocation;

  TBorderStyle = (bsNone, bs15, bs30, bs45, bs60, bs90, bs120, bs15Dbl,
                  bs30Dbl, bs45Dbl, bs15Gray, bs15GrayDashed);

  TShadingWeight = 0..100;

  TShadingStyle = (shsNone, shsDarkHorizontal, shsDarkVertical, shsDarkDownDiagonal,
                   shsDarkUpDiagonal, shsDarkGrid, shsDarkTrellis, shsLightHorizontal,
                   shsLightVertical, shsLightDownDiagonal, shsLightUpDiagonal,
                   shsLightGrid, shsLightTrellis);

  TTabAlignment = (tbaLeft, tbaCenter, tbaRight, tbaDecimal, tbaWordBar);

  TTabLeader = (tblNone, tblDotted, tblDashed, tblUnderlined, tblThick, tblDouble);

  TParaAttributes98 = class(TParaAttributes)
  private
    RichEdit: TCustomRichEdit98;
    procedure GetAttributes(var Paragraph: TParaFormat2);
    procedure InitPara(var Paragraph: TParaFormat2);
    procedure SetAttributes(var Paragraph: TParaFormat2);
    function GetFirstIndent: Double;
    procedure SetFirstIndent(Value: Double);
    function GetLeftIndent: Double;
    procedure SetLeftIndent(Value: Double);
    function GetRightIndent: Double;
    procedure SetRightIndent(Value: Double);
    function GetSpaceBefore: Double;
    procedure SetSpaceBefore(Value: Double);
    function GetSpaceAfter: Double;
    procedure SetSpaceAfter(Value: Double);
    function GetLineSpacing: Double;
    function GetLineSpacingRule: TLineSpacingRule;
    function GetKeepTogether: Boolean;
    procedure SetKeepTogether(Value: Boolean);
    function GetKeepWithNext: Boolean;
    procedure SetKeepWithNext(Value: Boolean);
    function GetPageBreakBefore: Boolean;
    procedure SetPageBreakBefore(Value: Boolean);
    function GetNoLineNumber: Boolean;
    procedure SetNoLineNumber(Value: Boolean);
    function GetNoWidowControl: Boolean;
    procedure SetNoWidowControl(Value: Boolean);
    function GetDoNotHyphen: Boolean;
    procedure SetDoNotHyphen(Value: Boolean);
    function GetSideBySide: Boolean;
    procedure SetSideBySide(Value: Boolean);
    function GetAlignment: TAlignment98;
    procedure SetAlignment(Value: TAlignment98);
    function GetNumbering: TNumberingStyle98;
    procedure SetNumbering(Value: TNumberingStyle98);
    function GetNumberingStart: Word;
    procedure SetNumberingStart(Value: Word);
    function GetNumberingFollow: TNumberingFollow;
    procedure SetNumberingFollow(Value: TNumberingFollow);
    function GetNumberingTab: Double;
    procedure SetNumberingTab(Value: Double);
    function GetBorderSpace: Double;
    function GetBorderWidth: Double;
    function GetBorderLocations: TBorderLocations;
    function GetBorderStyle: TBorderStyle;
    function GetBorderColor: TColor;
    function GetShadingWeight: TShadingWeight;
    function GetShadingStyle: TShadingStyle;
    function GetShadingColor: TColor;
    function GetShadingBackColor: TColor;
    function GetTabCount: Integer;
    function GetTab(Index: Integer): Double;
    function GetTabAlignment(Index: Integer): TTabAlignment;
    function GetTabLeader(Index: Integer): TTabLeader;
  public
    constructor Create(AOwner: TCustomRichEdit98);
    property Alignment: TAlignment98 read GetAlignment write SetAlignment;
    property FirstIndent: Double read GetFirstIndent write SetFirstIndent;
    property LeftIndent: Double read GetLeftIndent write SetLeftIndent;
    property RightIndent: Double read GetRightIndent write SetRightIndent;
    property SpaceBefore: Double read GetSpaceBefore write SetSpaceBefore;
    property SpaceAfter: Double read GetSpaceAfter write SetSpaceAfter;
    procedure SetLineSpacing(Rule: TLineSpacingRule; Value: Double);
    property LineSpacing: Double read GetLineSpacing;
    property LineSpacingRule: TLineSpacingRule read GetLineSpacingRule;
    property KeepTogether: Boolean read GetKeepTogether write SetKeepTogether;
    property KeepWithNext: Boolean read GetKeepWithNext write SetKeepWithNext;
    property PageBreakBefore: Boolean read GetPageBreakBefore write SetPageBreakBefore;
    property NoLineNumber: Boolean read GetNoLineNumber write SetNoLineNumber;
    property NoWidowControl: Boolean read GetNoWidowControl write SetNoWidowControl;
    property DoNotHyphen: Boolean read GetDoNotHyphen write SetDoNotHyphen;
    property SideBySide: Boolean read GetSideBySide write SetSideBySide;
    property Numbering: TNumberingStyle98 read GetNumbering write SetNumbering;
    property NumberingStart: Word read GetNumberingStart write SetNumberingStart;
    property NumberingFollow: TNumberingFollow read GetNumberingFollow write SetNumberingFollow;
    property NumberingTab: Double read GetNumberingTab write SetNumberingTab;
    property BorderSpace: Double read GetBorderSpace;
    property BorderWidth: Double read GetBorderWidth;
    property BorderLocations: TBorderLocations read GetBorderLocations;
    property BorderStyle: TBorderStyle read GetBorderStyle;
    property BorderColor: TColor read GetBorderColor;
    procedure SetBorder(Space, Width: Double; Locations: TBorderLocations;
                        Style: TBorderStyle; Color: TColor);
    property ShadingWeight: TShadingWeight read GetShadingWeight;
    property ShadingStyle: TShadingStyle read GetShadingStyle;
    property ShadingColor: TColor read GetShadingColor;
    property ShadingBackColor: TColor read GetShadingBackColor;
    procedure SetShading(Weight: TShadingWeight; Style: TShadingStyle;
                         Color, BackColor: TColor);
    property TabCount: Integer read GetTabCount;
    property Tab[Index: Integer]: Double read GetTab;
    property TabAlignment[Index: Integer]: TTabAlignment read GetTabAlignment;
    property TabLeader[Index: Integer]: TTabLeader read GetTabLeader;
    procedure SetTab(Index: Integer; Value: Double; Alignment: TTabAlignment;
                     Leader: TTabLeader);
  end;

  TURLClickEvent = procedure(Sender: TObject; URL: String) of object;
  TURLMoveEvent = procedure(Sender: TObject; URL: String) of object;
  TRichEditProgressEvent = procedure(Sender: TObject; Pos, Size: Integer) of object;

  TUndoName = (unUnknown, unTyping, unDelete, unDragDrop, unCut, unPaste);

  TLangOption = (loAutoKeyboard, loAutoFont, loIMECancelComplete, loIMEAlwaysSendNotify);
  TLangOptions = set of TLangOption;

  TSelType = (stText, stObject, stMultiChar, stMultiObject);
  TSelectionType = set of TSelType;

  TAutoURLDetect = (adNone, adDefault, adExtended);

  TURLType = class(TCollectionItem)
  private
    FName: String;
    FColor: TColor;
    FCursor: Tcursor;
    FUnderline: Boolean;
  protected
    function GetDisplayName: string; override;
  public
    procedure Assign(Source: TPersistent); override;
  published
    property Name: String read FName write FName;
    property Color: TColor read FColor write FColor;
    property Cursor: TCursor read FCursor write FCursor;
    property Underline: Boolean read FUnderline write FUnderline;
  end;

  {$WARNINGS OFF}
  TURLCollection = class(TCollection)
  private
    FOwner: TCustomRichEdit98;
  protected
    function GetOwner: TPersistent; override;
    procedure SetItems(Index: Integer; Value: TURLType);
    function GetItems(Index: Integer): TURLType;
  public
    procedure AddURLType(const Name: String; Color: TColor;
                         Cursor: TCursor; Underline: Boolean);
    property Owner: TCustomRichEdit98 read FOwner;
    property Items[Index: Integer]: TURLType read GetItems write SetItems; default;
  end;
  {$WARNINGS ON}

  TCustomRichEdit98 = class(TCustomRichEdit)
  private
    { Private declarations }
    FUpdateCount: Integer;
    FLibHandle: THandle;
    FSelAttributes: TTextAttributes98;
    FDefAttributes: TTextAttributes98;
    FParagraph: TParaAttributes98;
    FRichEditStrings: TStrings;
    FWideStrings: TWideStrings;
    FScreenLogPixels: Integer;
    FAutoURLDetect: TAutoURLDetect;
    FShowSelBar: Boolean;
    FOnURLClick: TURLClickEvent;
    FOnURLMove: TURLMoveEvent;
    FOnSaveProgress: TRichEditProgressEvent;
    FOnLoadProgress: TRichEditProgressEvent;
    FURLColor: TColor;
    FURLCursor: TCursor;
    FLanguage: TLanguage;
    FCP: Word;
    FWide: Boolean;
    FStreamSel: Boolean;
    FStoreSS,
    FStoreSL,
    FStoreFVL: Integer;
    FCROld: TCharRange;
    FVer10: Boolean;
//    FPlainText: Boolean;
    FLangOptions: TLangOptions;
    FDefWndProcW: TFNWndProc;
    FDefWndProcA: TFNWndProc;
    FURLs: TURLCollection;
    FWordFormatting: Boolean;
    FUndoLimit: Integer;

    FPlainTextIn: TInputFormat;
    FPlainTextOut: TOutputFormat;
    FSelectedInOut: Boolean;
    FPlainRTF: Boolean;

    FPopupVerbMenu: TPopupMenu;
    FAutoVerbMenu: Boolean;
    FObjectVerbs: TStringList;
    FSelObject: IOleObject;
    FDrawAspect: Longint;
    FViewSize: TPoint;
    FIncludeOLE:Boolean;
    FAllowInPlace: Boolean;
    procedure DestroyVerbs;
    procedure UpdateVerbs;
    procedure PopupVerbMenuClick(Sender: TObject);
    procedure DoVerb(Verb: Integer);
    function GetCanPaste: Boolean;

    procedure UpdateObject;
    procedure UpdateView;
    procedure SetIncludeOLE(Value:Boolean);
    function GetIconMetaPict: HGlobal;
    procedure CheckObject;
    procedure SetDrawAspect(Iconic: Boolean; IconMetaPict: HGlobal);
    property AllowInPlace: Boolean read FAllowInPlace write FAllowInPlace default True;

    procedure SetDefAttributes(Value: TTextAttributes98);
    procedure SetSelAttributes(Value: TTextAttributes98);
    procedure SetShowSelBar(Value: Boolean);
    procedure SetRichEditStrings(Value: TStrings);
    procedure CNNotify(var Message: TWMNotify); message CN_NOTIFY;
    procedure CNCommand(var Message: TWMCommand); message CN_COMMAND;
    procedure WMDestroy(var Msg: TMessage); message WM_DESTROY;
    function PrivatePerform(Msg: Cardinal; WParam, LParam: Longint): Longint;

    procedure FindNonSpace(var CR: TCharRange);
    procedure DetectURLs(CR: TCharRange);
  protected
    { Protected declarations }
    procedure CreateWnd; override;
    procedure CreateParams(var Params: TCreateParams); override;
    procedure DefineProperties(Filer: TFiler); override;
    procedure WMNCDestroy(var Message: TWMNCDestroy); message WM_NCDESTROY;
    procedure WMSetText(var Message: TWMSetText); message WM_SETTEXT;
    procedure WMGetText(var Message: TWMGetText); message WM_GETTEXT;
    procedure WMGetTextLength(var Message: TWMGetTextLength); message WM_GETTEXTLENGTH;
    procedure WMSetFont(var Message: TWMSetFont); message WM_SETFONT;
    procedure CMFontChanged(var Message: TMessage); message CM_FONTCHANGED;
    procedure EMReplaceSel(var Message: TMessage); message EM_REPLACESEL;
    procedure EMGetSelText(var Message: TMessage); message EM_GETSELTEXT;
    procedure EMGetTextRange(var Message: TMessage); message EM_GETTEXTRANGE;
    procedure EMGetLine(var Message: TMessage); message EM_GETLINE;
    procedure EMStreamIn(var Message: TMessage); message EM_STREAMIN;
    procedure EMStreamOut(var Message: TMessage); message EM_STREAMOUT;
    procedure WMPaint(var Message: TWMPaint); message WM_PAINT;
    procedure DoSetMaxLength(Value: Integer); override;
    function GetLine: Integer;
    procedure SetLine(Value: Integer);
    function GetColumn: Integer;
    procedure SetColumn(Value: Integer);
    procedure SetAutoURLDetect(Value: TAutoURLDetect);
    function GetFirstVisibleLine: Integer;
    property Lines: TStrings read FRichEditStrings write SetRichEditStrings;
    procedure ReadData(Reader: TReader);
    procedure WriteData(Writer: TWriter);
    function GetWideText: WideString;
    procedure SetWideText(Value: WideString);
    procedure SetLanguage(Value: TLanguage);
    function GetWideSelText: WideString;
    procedure SetWideSelText(Value: WideString);
    property OnURLClick: TURLClickEvent read FOnURLClick write FOnURLClick;
    property OnURLMove: TURLMoveEvent read FOnURLMove write FOnURLMove;
    property OnSaveProgress: TRichEditProgressEvent read FOnSaveProgress write FOnSaveProgress;
    property OnLoadProgress: TRichEditProgressEvent read FOnLoadProgress write FOnLoadProgress;
    procedure CreateWindowHandle(const Params: TCreateParams); override;
    procedure SetLangOptions(Value: TLangOptions);
    procedure SetCustomURLs(Value: TURLCollection);
    procedure CloseOLEObjects;
    procedure CreateOLEObjectInterface;
    function GetPopupMenu: TPopupMenu; override;
    procedure SetRTFSelText(Value: String);
    function GetRTFSelText: String;
    function GetSelType: TSelectionType;
    procedure SetUndoLimit(Value: Integer);
  public
    { Public declarations }
    RichEditOle: IRichEditOle;
    RichEditOleCallback: IRichEditOleCallback;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    function ObjectSelected:Boolean;
    procedure Clear; override;
    procedure CreateLinkToFile(const FileName: string; Iconic: Boolean);
    procedure CreateObject(const OleClassName: string; Iconic: Boolean);
    procedure CreateObjectFromFile(const FileName: string; Iconic: Boolean);
    procedure CreateObjectFromInfo(const CreateInfo: TCreateInfo);
    procedure InsertObjectDialog;
    function PasteSpecialDialog: Boolean;
    function ChangeIconDialog: Boolean;
    property AutoVerbMenu: boolean read FAutoVerbMenu write FAutoVerbMenu default true;
    property InputFormat: TInputFormat read FPlainTextIn write FPlainTextIn;
    property OutputFormat: TOutputFormat read FPlainTextOut write FPlainTextOut;
    property SelectedInOut: Boolean read FSelectedInOut write FSelectedInOut;
    property PlainRTF: Boolean read FPlainRTF write FPlainRTF;

    // pgm 8/29/04 - Move these to public API
    procedure BeginUpdate;
    procedure EndUpdate;

    procedure InsertFromFile(const FileName: String);
    property Line: Integer read GetLine write SetLine;
    property Col: Integer read GetColumn write SetColumn;
    procedure SetCaret(Line, Column: Integer);
    property DefAttributes: TTextAttributes98 read FDefAttributes write SetDefAttributes;
    property SelAttributes: TTextAttributes98 read FSelAttributes write SetSelAttributes;
    property Paragraph: TParaAttributes98 read FParagraph;
    property ShowSelectionBar: Boolean read FShowSelBar write SetShowSelBar;
    property WordFormatting: Boolean read FWordFormatting write FWordFormatting default True;
    function FindText(const SearchStr: string;
      StartPos, Length: Integer; Options: TSearchTypes98): Integer;
    function FindWideText(const SearchStr: WideString;
      StartPos, Length: Integer; Options: TSearchTypes98): Integer;
    function CanUndo: Boolean;
    procedure Undo;
    function UndoName: TUndoName;
    function CanRedo: Boolean;
    procedure Redo;
    function RedoName: TUndoName;
    procedure StopGroupTyping;
    property AutoURLDetect: TAutoURLDetect read FAutoURLDetect write SetAutoURLDetect;
    property FirstVisibleLine: Integer read GetFirstVisibleLine;
    function GetWordAtPos(Pos: Integer; var Start, Len: Integer): String;
    property RTFSelText: String read GetRTFSelText write SetRTFSelText;
    property WideText: WideString read GetWideText write SetWideText;
    property Language: TLanguage read FLanguage write SetLanguage;
    property LangOptions: TLangOptions read FLangOptions write SetLangOptions;
    property WideLines: TWideStrings read FWideStrings stored False;
    property WideSelText: WideString read GetWideSelText write SetWideSelText;
    property CustomURLs: TURLCollection read FURLs write SetCustomURLs;
    function CharAtPos(Pos: TPoint): Integer;
    property IncludeOLE: Boolean read FIncludeOLE write SetIncludeOLE default False;
    property CanPaste: Boolean read GetCanPaste;
    property URLColor : TColor read FURLColor write FURLColor;
    property URLCursor : TCursor read FURLCursor write FURLCursor;
    property SelType: TSelectionType read GetSelType;
    property UndoLimit: Integer read FUndoLimit write SetUndoLimit;
  end;

  TRichEdit98 = class(TCustomRichEdit98)
  published
    { Published declarations }
    property Align;
    property Alignment;
    property AutoURLDetect;
    property BorderStyle;
    property Color;
    property Ctl3D;
    property CustomURLs;
    property DragCursor;
    property DragMode;
    property Enabled;
    property Font;
    property HideSelection;
    property HideScrollBars;
    property ImeMode;
    property ImeName;
    property LangOptions;
    property Language;
    property Lines stored False;
    property MaxLength;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
//    property PlainText;
    property PopupMenu;
    property ReadOnly;
    property ScrollBars;
    property ShowHint;
    property ShowSelectionBar;
    property TabOrder;
    property TabStop default True;
    property URLColor;
    property URLCursor;
    property Visible;
    property WantTabs;
    property WantReturns;
    property WordFormatting;
    property WordWrap;
    property OnChange;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnLoadProgress;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnResizeRequest;
    property OnSelectionChange;
    property OnSaveProgress;
    property OnStartDrag;
    property OnProtectChange;
    property OnSaveClipboard;
    property OnURLClick;
    property OnURLMove;
    property AutoVerbMenu;
    property InputFormat;
    property OutputFormat;
    property SelectedInOut;
    property PlainRTF;
    property UndoLimit;

    property IncludeOLE;
    property AllowInPlace;

{$IFDEF VER120}
    property Anchors;
    property BiDiMode;
    property BorderWidth;
    property Constraints;
    property DragKind;
    property ParentBiDiMode;
{$ENDIF}
  end;

{$ifdef BDE_SUPPORT}
  TDBRichEdit98 = class(TCustomRichEdit98)
  private
    FDataLink: TFieldDataLink;
    FAutoDisplay: Boolean;
    FFocused: Boolean;
    FMemoLoaded: Boolean;
    FDataSave: string;
    procedure BeginEditing;
    procedure DataChange(Sender: TObject);
    procedure EditingChange(Sender: TObject);
    function GetDataField: string;
    function GetDataSource: TDataSource;
    function GetField: TField;
    function GetReadOnly: Boolean;
    procedure SetDataField(const Value: string);
    procedure SetDataSource(Value: TDataSource);
    procedure SetReadOnly(Value: Boolean);
    procedure SetAutoDisplay(Value: Boolean);
    procedure SetFocused(Value: Boolean);
    procedure UpdateData(Sender: TObject);
    procedure WMCut(var Message: TMessage); message WM_CUT;
    procedure WMPaste(var Message: TMessage); message WM_PASTE;
    procedure CMEnter(var Message: TCMEnter); message CM_ENTER;
    procedure CMExit(var Message: TCMExit); message CM_EXIT;
    procedure WMLButtonDblClk(var Message: TWMLButtonDblClk); message WM_LBUTTONDBLCLK;
    procedure CMGetDataLink(var Message: TMessage); message CM_GETDATALINK;
  protected
    procedure DefineProperties(Filer: TFiler); override;
    procedure Change; override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure KeyPress(var Key: Char); override;
    procedure Loaded; override;
    procedure Notification(AComponent: TComponent;
      Operation: TOperation); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure LoadMemo;
    property Field: TField read GetField;
  published
    property Align;
    property Alignment;
    property AutoDisplay: Boolean read FAutoDisplay write SetAutoDisplay default True;
    property AutoURLDetect;
    property BorderStyle;
    property Color;
    property Ctl3D;
    property CustomURLs;
    property DataField: string read GetDataField write SetDataField;
    property DataSource: TDataSource read GetDataSource write SetDataSource;
    property DragCursor;
    property DragMode;
    property Enabled;
    property Font;
    property HideSelection;
    property HideScrollBars;
    property ImeMode;
    property ImeName;
    property Language;
    property LangOptions;
    property MaxLength;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
//    property PlainText;
    property PopupMenu;
    property ReadOnly: Boolean read GetReadOnly write SetReadOnly default False;
    property ScrollBars;
    property ShowHint;
    property ShowSelectionBar;
    property TabOrder;
    property TabStop;
    property Visible;
    property WantReturns;
    property WantTabs;
    property WordFormatting;
    property WordWrap;
    property OnChange;
    property OnClick;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnLoadProgress;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnResizeRequest;
    property OnSaveProgress;
    property OnSelectionChange;
    property OnProtectChange;
    property OnSaveClipboard;
    property OnStartDrag;
    property OnURLClick;
    property AutoVerbMenu;
    property InputFormat;
    property OutputFormat;
    property SelectedInOut;
    property PlainRTF;
    property UndoLimit;

    property IncludeOLE;
    property AllowInPlace;

{$IFDEF VER120}
    property Anchors;
    property BiDiMode;
    property BorderWidth;
    property Constraints;
    property DragKind;
    property ParentBiDiMode;
{$ENDIF}
  end;

{$endif}

const
  RTFConversionFormat: TConversionFormat = (
    ConversionClass: TConversion;
    Extension: 'rtf';
    Next: nil);
  TextConversionFormat: TConversionFormat = (
    ConversionClass: TConversion;
    Extension: 'txt';
    Next: @RTFConversionFormat);

var
  ConversionFormatList: PConversionFormat = @TextConversionFormat;

procedure Register;

implementation

uses
  TypInfo;

var
  PixPerInch: TPoint;
  CFEmbeddedObject: Integer;
  CFLinkSource: Integer;

function PixelsToHimetric(const P: TPoint): TPoint;
begin
  Result.X := MulDiv(P.X, 2540, PixPerInch.X);
  Result.Y := MulDiv(P.Y, 2540, PixPerInch.Y);
end;

procedure CenterWindow(Wnd: HWnd);
var
  Rect: TRect;
begin
  GetWindowRect(Wnd, Rect);
  SetWindowPos(Wnd, 0,
    (GetSystemMetrics(SM_CXSCREEN) - Rect.Right + Rect.Left) div 2,
    (GetSystemMetrics(SM_CYSCREEN) - Rect.Bottom + Rect.Top) div 3,
    0, 0, SWP_NOACTIVATE or SWP_NOSIZE or SWP_NOZORDER);
end;

function OleDialogHook(Wnd: HWnd; Msg, WParam, LParam: Longint): Longint; stdcall;
begin
  Result := 0;
  if Msg = WM_INITDIALOG then
  begin
    if GetWindowLong(Wnd, GWL_STYLE) and WS_CHILD <> 0 then
      Wnd := GetWindowLong(Wnd, GWL_HWNDPARENT);
    CenterWindow(Wnd);
    Result := 1;
  end;
end;

function GetVCLFrameForm(Form: TCustomForm): IVCLFrameForm;
begin
  if Form.OleFormObject = nil then TOleForm.Create(Form);
  Result := Form.OleFormObject as IVCLFrameForm;
end;



procedure Register;
begin
  RegisterComponents('Win32', [TRichEdit98]);
{$ifdef BDE_SUPPORT}
  RegisterComponents('Data Controls', [TDBRichEdit98]);
{$endif}
end;

var
  IsWinNT: Boolean;


{ TTextAttributes98}

constructor TTextAttributes98.Create(AOwner: TCustomRichEdit98;
  AttributeType: TAttributeType);
begin
  inherited Create;
  RichEdit := AOwner;
  FType := AttributeType;
  if RichEdit.FVer10 then
    case FType of
    atSelected:
      FOldAttr:= TRichEdit(Richedit).SelAttributes;
    atDefaultText:
      FOldAttr:= TRichEdit(Richedit).DefAttributes;
    end;
end;

procedure TTextAttributes98.InitFormat(var Format: TCharFormat2W);
begin
  FillChar(Format, SizeOf(TCharFormat2W), 0);
  Format.cbSize := SizeOf(TCharFormat2W);
end;

function TTextAttributes98.GetConsistentAttributes: TConsistentAttributes98;
var
  Format: TCharFormat2W;
begin
  Result := [];
  if RichEdit.HandleAllocated and (FType = atSelected) then
  begin
    InitFormat(Format);
    RichEdit.Perform(EM_GETCHARFORMAT,
      WPARAM(FType = atSelected), LPARAM(@Format));
    with Format do
    begin
      if (dwMask and CFM_BOLD) <> 0 then Include(Result, caBold);
      if (dwMask and CFM_COLOR) <> 0 then Include(Result, caColor);
      if (dwMask and CFM_FACE) <> 0 then Include(Result, caFace);
      if (dwMask and CFM_ITALIC) <> 0 then Include(Result, caItalic);
      if (dwMask and CFM_SIZE) <> 0 then Include(Result, caSize);
      if (dwMask and CFM_STRIKEOUT) <> 0 then Include(Result, caStrikeOut);
      if (dwMask and CFM_UNDERLINE) <> 0 then Include(Result, caUnderline);
      if (dwMask and CFM_PROTECTED) <> 0 then Include(Result, caProtected);
      if (dwMask and CFM_WEIGHT) <> 0 then Include(Result, caWeight);
      if (dwMask and CFM_BACKCOLOR) <> 0 then Include(Result, caBackColor);
      if (dwMask and CFM_LCID) <> 0 then Include(Result, caLanguage);
      if (dwMask and CFM_SUPERSCRIPT) <> 0 then Include(Result, caIndexKind);
      if (dwMask and CFM_OFFSET) <> 0 then Include(Result, caOffset);
      if (dwMask and CFM_SPACING) <> 0 then Include(Result, caSpacing);
      if (dwMask and CFM_KERNING) <> 0 then Include(Result, caKerning);
      if (dwMask and CFM_UNDERLINETYPE) <> 0 then Include(Result, caULType);
      if (dwMask and CFM_ANIMATION) <> 0 then Include(Result, caAnimation);
      if (dwMask and CFM_SMALLCAPS) <> 0 then Include(Result, caSmallCaps);
      if (dwMask and CFM_ALLCAPS) <> 0 then Include(Result, caAllCaps);
      if (dwMask and CFM_HIDDEN) <> 0 then Include(Result, caHidden);
      if (dwMask and CFM_OUTLINE) <> 0 then Include(Result, caOutline);
      if (dwMask and CFM_SHADOW) <> 0 then Include(Result, caShadow);
      if (dwMask and CFM_EMBOSS) <> 0 then Include(Result, caEmboss);
      if (dwMask and CFM_IMPRINT) <> 0 then Include(Result, caImprint);
      if (dwMask and CFM_LINK)<>0 then Include(result, caURL);
    end;
  end;
end;

procedure TTextAttributes98.GetAttributes(var Format: TCharFormat2W);
begin
  InitFormat(Format);
  if RichEdit.HandleAllocated then
    RichEdit.Perform(EM_GETCHARFORMAT,
      WPARAM(FType = atSelected), LPARAM(@Format));
end;

procedure TTextAttributes98.SetAttributes(var Format: TCharFormat2W);
var
  Flag: Longint;
begin
  if FType = atSelected then
    begin
      Flag:= SCF_SELECTION or SCF_USEUIRULES;
      if (RichEdit.SelLength=0) and RichEdit.WordFormatting then
        Flag:= Flag or SCF_WORD;
    end
  else
    Flag:= SCF_DEFAULT;
  if RichEdit.HandleAllocated then
    RichEdit.Perform(EM_SETCHARFORMAT, Flag, LPARAM(@Format))
end;

procedure TTextAttributes98.Assign(Source: TPersistent);
begin
  if Source is TTextAttributes98 then       
    begin
      Color := TTextAttributes98(Source).Color;
      Name := TTextAttributes98(Source).Name;
      Size:= TTextAttributes98(Source).Size;
      Pitch := TTextAttributes98(Source).Pitch;
      Weight := TTextAttributes98(Source).Weight;
      BackColor := TTextAttributes98(Source).BackColor;
      Language := TTextAttributes98(Source).Language;
      IndexKind := TTextAttributes98(Source).IndexKind;
      Offset := TTextAttributes98(Source).Offset;
      Spacing := TTextAttributes98(Source).Spacing;
      Kerning := TTextAttributes98(Source).Kerning;
      UnderlineType := TTextAttributes98(Source).UnderlineType;
      Bold := TTextAttributes98(Source).Bold;
      Italic := TTextAttributes98(Source).Italic;
      StrikeOut:= TTextAttributes98(Source).StrikeOut;
      Animation := TTextAttributes98(Source).Animation;
      SmallCaps := TTextAttributes98(Source).SmallCaps;
      AllCaps := TTextAttributes98(Source).AllCaps;
      Hidden := TTextAttributes98(Source).Hidden;
      Outline := TTextAttributes98(Source).Outline;
      Shadow := TTextAttributes98(Source).Shadow;
      Emboss := TTextAttributes98(Source).Emboss;
      Imprint := TTextAttributes98(Source).Imprint;
      IsURL:= TTextAttributes98(Source).IsURL;
    end
  else if Source is TTextAttributes then
    begin
      Color := TTextAttributes(Source).Color;
      Name := TTextAttributes(Source).Name;
      Size:= TTextAttributes(Source).Size;
      Pitch := TTextAttributes(Source).Pitch;
      Bold:= fsBold in TTextAttributes(Source).Style;
      Italic:= fsItalic in TTextAttributes(Source).Style;
      StrikeOut:= fsStrikeOut in TTextAttributes(Source).Style;
      UnderlineType:= TUnderlineType(fsUnderline in TTextAttributes(Source).Style);
    end
  else if Source is TFont then
    begin
      Color := TFont(Source).Color;
      Name := TFont(Source).Name;
      Size:= TFont(Source).Size;
      Pitch := TFont(Source).Pitch;
      Bold:= fsBold in TFont(Source).Style;
      Italic:= fsItalic in TFont(Source).Style;
      StrikeOut:= fsStrikeOut in TFont(Source).Style;
      UnderlineType:= TUnderlineType(fsUnderline in TFont(Source).Style);
    end
  else
    inherited Assign(Source);
end;

procedure TTextAttributes98.AssignTo(Dest: TPersistent);
begin
  if Dest is TTextAttributes98 then
    begin
      TTextAttributes98(Dest).Color := Color;
      TTextAttributes98(Dest).Name := Name;
      TTextAttributes98(Dest).Size := Size;
      TTextAttributes98(Dest).Pitch := Pitch;
      TTextAttributes98(Dest).Weight := Weight;
      TTextAttributes98(Dest).BackColor := BackColor;
      TTextAttributes98(Dest).Language := Language;
      TTextAttributes98(Dest).IndexKind := IndexKind;
      TTextAttributes98(Dest).Offset := Offset;
      TTextAttributes98(Dest).Spacing := Spacing;
      TTextAttributes98(Dest).Kerning := Kerning;
      TTextAttributes98(Dest).UnderlineType := UnderlineType;
      TTextAttributes98(Dest).Bold := Bold;
      TTextAttributes98(Dest).Italic := Italic;
      TTextAttributes98(Dest).Animation := Animation;
      TTextAttributes98(Dest).SmallCaps := SmallCaps;
      TTextAttributes98(Dest).AllCaps := AllCaps;
      TTextAttributes98(Dest).Hidden := Hidden;
      TTextAttributes98(Dest).Outline := Outline;
      TTextAttributes98(Dest).Shadow := Shadow;
      TTextAttributes98(Dest).Emboss := Emboss;
      TTextAttributes98(Dest).Imprint := Imprint;
      TTextAttributes98(Dest).IsURL := IsURL;
    end
  else if Dest is TTextAttributes then
    begin
      TTextAttributes(Dest).Color := Color;
      TTextAttributes(Dest).Name := Name;
      if Bold then
        TTextAttributes(Dest).Style:= [fsBold]
      else
        TTextAttributes(Dest).Style:= [];
      if Italic then
        TTextAttributes(Dest).Style:= TTextAttributes(Dest).Style+[fsItalic];
      if UnderlineType<>ultNone then
        TTextAttributes(Dest).Style:= TTextAttributes(Dest).Style+[fsUnderline];
      TTextAttributes(Dest).Charset := CharsetFromLocale(Language);
      TTextAttributes(Dest).Size := Size;
      TTextAttributes(Dest).Pitch := Pitch;
    end
  else if Dest is TFont then
    begin
      TFont(Dest).Color := Color;
      TFont(Dest).Name := Name;
      if Bold then
        TFont(Dest).Style:= [fsBold]
      else
        TFont(Dest).Style:= [];
      if Italic then
        TFont(Dest).Style:= TTextAttributes(Dest).Style+[fsItalic];
      if UnderlineType<>ultNone then
        TFont(Dest).Style:= TTextAttributes(Dest).Style+[fsUnderline];
      TFont(Dest).Charset := CharsetFromLocale(Language);
      TFont(Dest).Size := Size;
      TFont(Dest).Pitch := Pitch;
    end
  else
    inherited AssignTo(Dest);
end;

function TTextAttributes98.GetProtected: Boolean;
var
  Format: TCharFormat2W;
begin
  if RichEdit.FVer10 then
    begin
      Result:= FOldAttr.Protected;
      Exit;
    end;
  GetAttributes(Format);
  with Format do
    if (dwEffects and CFE_PROTECTED) <> 0 then
      Result := True else
      Result := False;
end;

procedure TTextAttributes98.SetProtected(Value: Boolean);
var
  Format: TCharFormat2W;
begin
  if RichEdit.FVer10 then
    begin
      FOldAttr.Protected:= Value;
      Exit;
    end;
  InitFormat(Format);
  with Format do
  begin
    dwMask := CFM_PROTECTED;
    if Value then dwEffects := CFE_PROTECTED;
  end;
  SetAttributes(Format);
end;

function TTextAttributes98.GetColor: TColor;
var
  Format: TCharFormat2W;
begin
  if RichEdit.FVer10 then
    begin
      Result:= FOldAttr.Color;
      Exit;
    end;
  GetAttributes(Format);
  with Format do
    if (dwEffects and CFE_AUTOCOLOR) <> 0 then
      Result := clWindowText else
      Result := crTextColor;
end;

procedure TTextAttributes98.SetColor(Value: TColor);
var
  Format: TCharFormat2W;
begin
  if RichEdit.FVer10 then
    begin
      FOldAttr.Color:= Value;
      Exit;
    end;
  InitFormat(Format);
  with Format do
  begin
    dwMask := CFM_COLOR;
    if Value = clWindowText then
      dwEffects := CFE_AUTOCOLOR
    else
      crTextColor := ColorToRGB(Value);
  end;
  SetAttributes(Format);
end;

function TTextAttributes98.GetName: TFontName;
var
  Format: TCharFormat2W;
begin
  if RichEdit.FVer10 then
    begin
      Result:= FOldAttr.Name;
      Exit;
    end;
  GetAttributes(Format);
  Result := Format.szFaceName;
end;

procedure TTextAttributes98.SetName(Value: TFontName);
var
  Format: TCharFormat2W;
  I: Integer;
  W: WideString;
begin
  if RichEdit.FVer10 then
    begin
      FOldAttr.Name:= Value;
      Exit;
    end;
  InitFormat(Format);
  with Format do
  begin
    dwMask := CFM_FACE;
    W:= Value;
    for I:= 0 to Length(Value)-1 do
      szFaceName[I]:= W[I+1];
  end;
  SetAttributes(Format);
end;

function TTextAttributes98.GetPitch: TFontPitch;
var
  Format: TCharFormat2W;
begin
  if RichEdit.FVer10 then
    begin
      Result:= FOldAttr.Pitch;
      Exit;
    end;
  GetAttributes(Format);
  case (Format.bPitchAndFamily and $03) of
    DEFAULT_PITCH: Result := fpDefault;
    VARIABLE_PITCH: Result := fpVariable;
    FIXED_PITCH: Result := fpFixed;
  else
    Result := fpDefault;
  end;
end;

procedure TTextAttributes98.SetPitch(Value: TFontPitch);
var
  Format: TCharFormat2W;
begin
  if RichEdit.FVer10 then
    begin
      FOldAttr.Pitch:= Value;
      Exit;
    end;
  InitFormat(Format);
  with Format do
  begin
    case Value of
      fpVariable: Format.bPitchAndFamily := VARIABLE_PITCH;
      fpFixed: Format.bPitchAndFamily := FIXED_PITCH;
    else
      Format.bPitchAndFamily := DEFAULT_PITCH;
    end;
  end;
  SetAttributes(Format);
end;

function TTextAttributes98.GetSize: Integer;
var
  Format: TCharFormat2W;
begin
  if RichEdit.FVer10 then
    begin
      Result:= FOldAttr.Size;
      Exit;
    end;
  GetAttributes(Format);
  Result := Format.yHeight div 20;
end;

procedure TTextAttributes98.SetSize(Value: Integer);
var
  Format: TCharFormat2W;
begin
  if RichEdit.FVer10 then
    begin
      FOldAttr.Size:= Value;
      Exit;
    end;
  InitFormat(Format);
  with Format do
  begin
    dwMask := CFM_SIZE;
    yHeight := Value * 20;
  end;
  SetAttributes(Format);
end;

function TTextAttributes98.GetWeight: Word;
var
  Format: TCharFormat2W;
begin
  if RichEdit.FVer10 then
    begin
      if Bold then
        Result:= 700
      else
        Result:= 400;
      Exit;
    end;
  GetAttributes(Format);
  Result := Format.wWeight;
end;

procedure TTextAttributes98.SetWeight(Value: Word);
var
  Format: TCharFormat2W;
begin
  if RichEdit.FVer10 then
    Exit;
  InitFormat(Format);
  with Format do
  begin
    dwMask := CFM_Weight;
    wWeight := Value;
  end;
  SetAttributes(Format);
end;

function TTextAttributes98.GetBackColor: TColor;
var
  Format: TCharFormat2W;
begin
  if RichEdit.FVer10 then
    begin
      Result:= clNone;
      Exit;
    end;
  GetAttributes(Format);
  with Format do
    Result := crBackColor;
end;

procedure TTextAttributes98.SetBackColor(Value: TColor);
var
  Format: TCharFormat2W;
begin
  if RichEdit.FVer10 then
    Exit;
  InitFormat(Format);
  with Format do
  begin
    dwMask := CFM_BACKCOLOR;
    crBackColor := ColorToRGB(Value);
  end;
  SetAttributes(Format);
end;

function TTextAttributes98.GetLanguage: TLanguage;
var
  Format: TCharFormat2W;
begin
  if RichEdit.FVer10 then
    begin
      Result:= 2048;
      Exit;
    end;
  GetAttributes(Format);
  Result := Format.lid;
end;

procedure TTextAttributes98.SetLanguage(Value: TLanguage);
var
  Format: TCharFormat2W;
begin
  if RichEdit.FVer10 then
    Exit;
  InitFormat(Format);
  with Format do
  begin
    dwMask := CFM_LCID;
    lid := Value;
  end;
  SetAttributes(Format);
end;

function TTextAttributes98.GetIndexKind: TIndexKind;
var
  Format: TCharFormat2W;
begin
  if RichEdit.FVer10 then
    begin
      Result:= ikNone;
      Exit;
    end;
  GetAttributes(Format);
  case (Format.dwEffects and CFM_SUPERSCRIPT) shr 16 of
  1: Result:= ikSubscript;
  2: Result:= ikSuperscript;
  else Result:= ikNone;
  end;
end;

procedure TTextAttributes98.SetIndexKind(Value: TIndexKind);
var
  Format: TCharFormat2W;
begin
  if RichEdit.FVer10 then
    Exit;
  InitFormat(Format);
  with Format do
  begin
    dwMask := CFM_SUPERSCRIPT;
    dwEffects := Ord(Value) shl 16;
  end;
  SetAttributes(Format);
end;

function TTextAttributes98.GetOffset: Double;
var
  Format: TCharFormat2W;
begin
  if RichEdit.FVer10 then
    begin
      Result:= 0;
      Exit;
    end;
  GetAttributes(Format);
  Result := Format.yOffset/20;
end;

procedure TTextAttributes98.SetOffset(Value: Double);
var
  Format: TCharFormat2W;
begin
  if RichEdit.FVer10 then
    Exit;
  InitFormat(Format);
  with Format do
  begin
    dwMask := CFM_OFFSET;
    yOffset := Round(Value*20);
  end;
  SetAttributes(Format);
end;

function TTextAttributes98.GetSpacing: Double;
var
  Format: TCharFormat2W;
begin
  if RichEdit.FVer10 then
    begin
      Result:= 0;
      Exit;
    end;
  GetAttributes(Format);
  Result := Format.sSpacing/20;
end;

procedure TTextAttributes98.SetSpacing(Value: Double);
var
  Format: TCharFormat2W;
begin
  if RichEdit.FVer10 then
    Exit;
  InitFormat(Format);
  with Format do
  begin
    dwMask := CFM_SPACING;
    sSpacing := Round(Value*20);
  end;
  SetAttributes(Format);
end;

function TTextAttributes98.GetKerning: Double;
var
  Format: TCharFormat2W;
begin
  if RichEdit.FVer10 then
    begin
      Result:= 0;
      Exit;
    end;
  GetAttributes(Format);
  Result := Format.wKerning/20;
end;

procedure TTextAttributes98.SetKerning(Value: Double);
var
  Format: TCharFormat2W;
begin
  if RichEdit.FVer10 then
    Exit;
  InitFormat(Format);
  with Format do
  begin
    dwMask := CFM_KERNING;
    wKerning := Round(Value*20);
  end;
  SetAttributes(Format);
end;

function TTextAttributes98.GetUnderlineType: TUnderlineType;
var
  Format: TCharFormat2W;
begin
  if RichEdit.FVer10 then
    begin
      Result:= TUnderlineType(fsUnderline in FOldAttr.Style);
      Exit;
    end;
  GetAttributes(Format);
  if (Format.dwEffects and Integer(CFE_UNDERLINE)) <>0 then
    Result := TUnderlineType(Format.bUnderlineType)
  else
    Result:= ultNone;
end;

procedure TTextAttributes98.SetUnderlineType(Value: TUnderlineType);
var
  Format: TCharFormat2W;
begin
  if RichEdit.FVer10 then
    begin
      if Value=ultNone then
        FOldAttr.Style:= FOldAttr.Style-[fsUnderline]
      else
        FOldAttr.Style:= FOldAttr.Style+[fsUnderline];
      Exit;
    end;
  InitFormat(Format);
  with Format do
  begin
    dwMask := CFM_UNDERLINETYPE;
    bUnderlineType := Byte(Value);
  end;
  SetAttributes(Format);
end;

function TTextAttributes98.GetAnimation: TAnimationType;
var
  Format: TCharFormat2W;
begin
  if RichEdit.FVer10 then
    begin
      Result:= aniNone;
      Exit;
    end;
  GetAttributes(Format);
  Result := TAnimationType(Format.bAnimation);
end;

procedure TTextAttributes98.SetAnimation(Value: TAnimationType);
var
  Format: TCharFormat2W;
begin
  if RichEdit.FVer10 then
    Exit;
  InitFormat(Format);
  with Format do
  begin
    dwMask := CFM_ANIMATION;
    bAnimation := Byte(Value);
  end;
  SetAttributes(Format);
end;

function TTextAttributes98.GetBold: Boolean;
var
  Format: TCharFormat2W;
begin
  if RichEdit.FVer10 then
    begin
      Result:= fsBold in FOldAttr.Style;
      Exit;
    end;
  GetAttributes(Format);
  Result := Format.dwEffects and CFE_BOLD <>0;
end;

procedure TTextAttributes98.SetBold(Value: Boolean);
var
  Format: TCharFormat2W;
begin
  if RichEdit.FVer10 then
    begin
      if Value then
        FOldAttr.Style:= FOldAttr.Style+[fsBold]
      else
        FOldAttr.Style:= FOldAttr.Style-[fsBold];
      Exit;
    end;
  InitFormat(Format);
  with Format do
  begin
    dwMask := CFM_BOLD;
    if Value then
      dwEffects:= CFE_BOLD;
  end;
  SetAttributes(Format);
end;

function TTextAttributes98.GetItalic: Boolean;
var
  Format: TCharFormat2W;
begin
  if RichEdit.FVer10 then
    begin
      Result:= fsItalic in FOldAttr.Style;
      Exit;
    end;
  GetAttributes(Format);
  Result := Format.dwEffects and CFE_ITALIC <>0;
end;

procedure TTextAttributes98.SetItalic(Value: Boolean);
var
  Format: TCharFormat2W;
begin
  if RichEdit.FVer10 then
    begin
      if Value then
        FOldAttr.Style:= FOldAttr.Style+[fsItalic]
      else
        FOldAttr.Style:= FOldAttr.Style-[fsItalic];
      Exit;
    end;
  InitFormat(Format);
  with Format do
  begin
    dwMask := CFM_ITALIC;
    if Value then
      dwEffects:= CFE_ITALIC;
  end;
  SetAttributes(Format);
end;

function TTextAttributes98.GetStrikeOut: Boolean;
var
  Format: TCharFormat2W;
begin
  if RichEdit.FVer10 then
    begin
      Result:= fsstrikeOut in FOldAttr.Style;
      Exit;
    end;
  GetAttributes(Format);
  Result := Format.dwEffects and CFE_STRIKEOUT <>0;
end;

procedure TTextAttributes98.SetStrikeOut(Value: Boolean);
var
  Format: TCharFormat2W;
begin
  if RichEdit.FVer10 then
    begin
      if Value then
        FOldAttr.Style:= FOldAttr.Style+[fsStrikeout]
      else
        FOldAttr.Style:= FOldAttr.Style-[fsStrikeout];
      Exit;
    end;
  InitFormat(Format);
  with Format do
  begin
    dwMask := CFM_STRIKEOUT;
    if Value then
      dwEffects:= CFE_STRIKEOUT;
  end;
  SetAttributes(Format);
end;

function TTextAttributes98.GetSmallCaps: Boolean;
var
  Format: TCharFormat2W;
begin
  if RichEdit.FVer10 then
    begin
      Result:= False;
      Exit;
    end;
  GetAttributes(Format);
  Result := Format.dwEffects and CFE_SMALLCAPS <>0;
end;

procedure TTextAttributes98.SetSmallCaps(Value: Boolean);
var
  Format: TCharFormat2W;
begin
  if RichEdit.FVer10 then
    Exit;
  InitFormat(Format);
  with Format do
  begin
    dwMask := CFM_SMALLCAPS;
    if Value then
      dwEffects:= CFE_SMALLCAPS;
  end;
  SetAttributes(Format);
end;

function TTextAttributes98.GetAllCaps: Boolean;
var
  Format: TCharFormat2W;
begin
  if RichEdit.FVer10 then
    begin
      Result:= False;
      Exit;
    end;
  GetAttributes(Format);
  Result := Format.dwEffects and CFE_ALLCAPS <>0;
end;

procedure TTextAttributes98.SetAllCaps(Value: Boolean);
var
  Format: TCharFormat2W;
begin
  if RichEdit.FVer10 then
    Exit;
  InitFormat(Format);
  with Format do
  begin
    dwMask := CFM_ALLCAPS;
    if Value then
      dwEffects:= CFE_ALLCAPS;
  end;
  SetAttributes(Format);
end;

function TTextAttributes98.GetHidden: Boolean;
var
  Format: TCharFormat2W;
begin
  if RichEdit.FVer10 then
    begin
      Result:= False;
      Exit;
    end;
  GetAttributes(Format);
  Result := Format.dwEffects and CFE_HIDDEN <>0;
end;

procedure TTextAttributes98.SetHidden(Value: Boolean);
var
  Format: TCharFormat2W;
begin
  if RichEdit.FVer10 then
    Exit;
  InitFormat(Format);
  with Format do
  begin
    dwMask := CFM_HIDDEN;
    if Value then
      dwEffects:= CFE_HIDDEN;
  end;
  SetAttributes(Format);
end;

function TTextAttributes98.GetOutline: Boolean;
var
  Format: TCharFormat2W;
begin
  if RichEdit.FVer10 then
    begin
      Result:= False;
      Exit;
    end;
  GetAttributes(Format);
  Result := Format.dwEffects and CFE_OUTLINE <>0;
end;

procedure TTextAttributes98.SetOutline(Value: Boolean);
var
  Format: TCharFormat2W;
begin
  if RichEdit.FVer10 then
    Exit;
  InitFormat(Format);
  with Format do
  begin
    dwMask := CFM_OUTLINE;
    if Value then
      dwEffects:= CFE_OUTLINE;
  end;
  SetAttributes(Format);
end;

function TTextAttributes98.GetShadow: Boolean;
var
  Format: TCharFormat2W;
begin
  if RichEdit.FVer10 then
    begin
      Result:= False;
      Exit;
    end;
  GetAttributes(Format);
  Result := Format.dwEffects and CFE_SHADOW <>0;
end;

procedure TTextAttributes98.SetShadow(Value: Boolean);
var
  Format: TCharFormat2W;
begin
  if RichEdit.FVer10 then
    Exit;
  InitFormat(Format);
  with Format do
  begin
    dwMask := CFM_SHADOW;
    if Value then
      dwEffects:= CFE_SHADOW;
  end;
  SetAttributes(Format);
end;

function TTextAttributes98.GetEmboss: Boolean;
var
  Format: TCharFormat2W;
begin
  if RichEdit.FVer10 then
    begin
      Result:= False;
      Exit;
    end;
  GetAttributes(Format);
  Result := Format.dwEffects and CFE_EMBOSS <>0;
end;

procedure TTextAttributes98.SetEmboss(Value: Boolean);
var
  Format: TCharFormat2W;
begin
  if RichEdit.FVer10 then
    Exit;
  InitFormat(Format);
  with Format do
  begin
    dwMask := CFM_EMBOSS;
    if Value then
      dwEffects:= CFE_EMBOSS;
  end;
  SetAttributes(Format);
end;

function TTextAttributes98.GetImprint: Boolean;
var
  Format: TCharFormat2W;
begin
  if RichEdit.FVer10 then
    begin
      Result:= False;
      Exit;
    end;
  GetAttributes(Format);
  Result := Format.dwEffects and CFE_IMPRINT <>0;
end;

procedure TTextAttributes98.SetImprint(Value: Boolean);
var
  Format: TCharFormat2W;
begin
  if RichEdit.FVer10 then
    Exit;
  InitFormat(Format);
  with Format do
  begin
    dwMask := CFM_IMPRINT;
    if Value then
      dwEffects:= CFE_IMPRINT;
  end;
  SetAttributes(Format);
end;

function TTextAttributes98.GetIsURL: Boolean;
var
  Format: TCharFormat2W;
begin
  if RichEdit.FVer10 then
    begin
      Result:= False;
      Exit;
    end;
  GetAttributes(Format);
  Result := Format.dwEffects and CFE_LINK <>0;
end;

procedure TTextAttributes98.SetIsURL(Value: Boolean);
var
  Format: TCharFormat2W;
begin
  if RichEdit.FVer10 then
    Exit;
  InitFormat(Format);
  with Format do
  begin
    dwMask := CFM_LINK;
    if Value then
      dwEffects:= CFE_LINK;
  end;
  SetAttributes(Format);
end;

function TTextAttributes98.GetHeight: Integer;
begin
  Result := MulDiv(Size, RichEdit.FScreenLogPixels, 72);
end;

procedure TTextAttributes98.SetHeight(Value: Integer);
begin
  Size := MulDiv(Value, 72, RichEdit.FScreenLogPixels);
end;

function TTextAttributes98.GetStyle: TFontStyles;
var
  Format: TCharFormat2W;
begin
  if RichEdit.FVer10 then
    begin
      Result:= FOldAttr.Style;
      Exit;
    end;
  Result := [];
  GetAttributes(Format);
  with Format do
  begin
    if (dwEffects and Integer(CFE_BOLD)) <> 0 then Include(Result, fsBold);
    if (dwEffects and Integer(CFE_ITALIC)) <> 0 then Include(Result, fsItalic);
    if (dwEffects and Integer(CFE_UNDERLINE)) <> 0 then Include(Result, fsUnderline);
    if (dwEffects and Integer(CFE_STRIKEOUT)) <> 0 then Include(Result, fsStrikeOut);
  end;
end;

procedure TTextAttributes98.SetStyle(Value: TFontStyles);
var
  Format: TCharFormat2W;
begin
  if RichEdit.FVer10 then
    begin
      FOldAttr.Style:= Value;
      Exit;
    end;
  InitFormat(Format);
  with Format do
  begin
    dwMask := CFM_BOLD or CFM_ITALIC or CFM_STRIKEOUT or CFM_UNDERLINETYPE;
    if fsBold in Value then dwEffects := dwEffects or CFE_BOLD;
    if fsItalic in Value then dwEffects := dwEffects or CFE_ITALIC;
    if fsStrikeOut in Value then dwEffects := dwEffects or CFE_STRIKEOUT;
    bUnderlineType:= Ord(fsUnderline in Value);
  end;
  SetAttributes(Format);
end;

{ TParaAttributes98}
constructor TParaAttributes98.Create(AOwner: TCustomRichEdit98);
begin
  inherited Create(AOwner);
  RichEdit := AOwner;
end;

procedure TParaAttributes98.InitPara(var Paragraph: TParaFormat2);
begin
  FillChar(Paragraph, SizeOf(TParaFormat2), 0);
  Paragraph.cbSize := SizeOf(TParaFormat2);
end;

procedure TParaAttributes98.GetAttributes(var Paragraph: TParaFormat2);
begin
  InitPara(Paragraph);
  if RichEdit.HandleAllocated then
    RichEdit.Perform(EM_GETPARAFORMAT, 0, LPARAM(@Paragraph));
end;

procedure TParaAttributes98.SetAttributes(var Paragraph: TParaFormat2);
begin
  if RichEdit.HandleAllocated then
    RichEdit.Perform(EM_SETPARAFORMAT, 0, LPARAM(@Paragraph))
end;

function TParaAttributes98.GetFirstIndent: Double;
var
  Paragraph: TParaFormat2;
begin
  if RichEdit.FVer10 then
    begin
      Result:= TRichEdit(RichEdit).Paragraph.FirstIndent;
      Exit;
    end;
  GetAttributes(Paragraph);
  Result := Paragraph.dxStartIndent/20;
end;

procedure TParaAttributes98.SetFirstIndent(Value: Double);
var
  Paragraph: TParaFormat2;
begin
  if RichEdit.FVer10 then
    begin
      TRichEdit(RichEdit).Paragraph.FirstIndent:= Round(Value);
      Exit;
    end;
  InitPara(Paragraph);
  with Paragraph do
  begin
    dwMask := PFM_STARTINDENT;
    dxStartIndent := Round(Value * 20);
  end;
  SetAttributes(Paragraph);
end;

function TParaAttributes98.GetLeftIndent: Double;
var
  Paragraph: TParaFormat2;
begin
  if RichEdit.FVer10 then
    begin
      Result:= TRichEdit(RichEdit).Paragraph.LeftIndent;
      Exit;
    end;
  GetAttributes(Paragraph);
  Result := Paragraph.dxOffset/20;
end;

procedure TParaAttributes98.SetLeftIndent(Value: Double);
var
  Paragraph: TParaFormat2;
begin
  if RichEdit.FVer10 then
    begin
      TRichEdit(RichEdit).Paragraph.LeftIndent:= Round(Value);
      Exit;
    end;
  InitPara(Paragraph);
  with Paragraph do
  begin
    dwMask := PFM_OFFSET;
    dxOffset := Round(Value * 20);
  end;
  SetAttributes(Paragraph);
end;

function TParaAttributes98.GetRightIndent: Double;
var
  Paragraph: TParaFormat2;
begin
  if RichEdit.FVer10 then
    begin
      Result:= TRichEdit(RichEdit).Paragraph.RightIndent;
      Exit;
    end;
  GetAttributes(Paragraph);
  Result := Paragraph.dxRightIndent/20;
end;

procedure TParaAttributes98.SetRightIndent(Value: Double);
var
  Paragraph: TParaFormat2;
begin
  if RichEdit.FVer10 then
    begin
      TRichEdit(RichEdit).Paragraph.RightIndent:= Round(Value);
      Exit;
    end;
  InitPara(Paragraph);
  with Paragraph do
  begin
    dwMask := PFM_RIGHTINDENT;
    dxRightIndent := Round(Value * 20);
  end;
  SetAttributes(Paragraph);
end;

function TParaAttributes98.GetSpaceBefore: Double;
var
  Paragraph: TParaFormat2;
begin
  if RichEdit.FVer10 then
    begin
      Result:= 0;
      Exit;
    end;
  GetAttributes(Paragraph);
  Result := Paragraph.dySpaceBefore/20;
end;

procedure TParaAttributes98.SetSpaceBefore(Value: Double);
var
  Paragraph: TParaFormat2;
begin
  if RichEdit.FVer10 then
    Exit;
  InitPara(Paragraph);
  with Paragraph do
  begin
    dwMask := PFM_SPACEBEFORE;
    dySpaceBefore := Round(Value*20);
  end;
  SetAttributes(Paragraph);
end;

function TParaAttributes98.GetSpaceAfter: Double;
var
  Paragraph: TParaFormat2;
begin
  if RichEdit.FVer10 then
    begin
      Result:= 0;
      Exit;
    end;
  GetAttributes(Paragraph);
  Result := Paragraph.dySpaceAfter/20;
end;

procedure TParaAttributes98.SetSpaceAfter(Value: Double);
var
  Paragraph: TParaFormat2;
begin
  if RichEdit.FVer10 then
    Exit;
  InitPara(Paragraph);
  with Paragraph do
  begin
    dwMask := PFM_SPACEAFTER;
    dySpaceAfter := Round(Value*20);
  end;
  SetAttributes(Paragraph);
end;

function TParaAttributes98.GetLineSpacing: Double;
var
  Paragraph: TParaFormat2;
begin
  if RichEdit.FVer10 then
    begin
      Result:= 0;
      Exit;
    end;
  GetAttributes(Paragraph);
  Result := Paragraph.dyLineSpacing/20;
end;

function TParaAttributes98.GetLineSpacingRule: TLineSpacingRule;
var
  Paragraph: TParaFormat2;
begin
  Result := lsrOrdinary;
  if RichEdit.FVer10 then Exit;
  GetAttributes(Paragraph);
  Result := TLineSpacingRule(Paragraph.bLineSpacingRule);
end;

procedure TParaAttributes98.SetLineSpacing(Rule: TLineSpacingRule; Value: Double);
var
  Paragraph: TParaFormat2;
begin
  if RichEdit.FVer10 then
    Exit;
  InitPara(Paragraph);
  with Paragraph do
  begin
    dwMask := PFM_LINESPACING;
    bLineSpacingRule:= Ord(Rule);
    dyLineSpacing := Round(Value*20);
  end;
  SetAttributes(Paragraph);
end;

function TParaAttributes98.GetKeepTogether: Boolean;
var
  Paragraph: TParaFormat2;
begin
  if RichEdit.FVer10 then
    begin
      Result:= False;
      Exit;
    end;
  GetAttributes(Paragraph);
  Result := Paragraph.wReserved and PFE_KEEP <>0;
end;

procedure TParaAttributes98.SetKeepTogether(Value: Boolean);
var
  Paragraph: TParaFormat2;
begin
  if RichEdit.FVer10 then
    Exit;
  InitPara(Paragraph);
  with Paragraph do
  begin
    dwMask := PFM_KEEP;
    if Value then
      wReserved:= PFE_KEEP;
  end;
  SetAttributes(Paragraph);
end;

function TParaAttributes98.GetKeepWithNext: Boolean;
var
  Paragraph: TParaFormat2;
begin
  if RichEdit.FVer10 then
    begin
      Result:= False;
      Exit;
    end;
  GetAttributes(Paragraph);
  Result := Paragraph.wReserved and PFE_KEEPNEXT <>0;
end;

procedure TParaAttributes98.SetKeepWithNext(Value: Boolean);
var
  Paragraph: TParaFormat2;
begin
  if RichEdit.FVer10 then
    Exit;
  InitPara(Paragraph);
  with Paragraph do
  begin
    dwMask := PFM_KEEPNEXT;
    if Value then
      wReserved:= PFE_KEEPNEXT;
  end;
  SetAttributes(Paragraph);
end;

function TParaAttributes98.GetPageBreakBefore: Boolean;
var
  Paragraph: TParaFormat2;
begin
  if RichEdit.FVer10 then
    begin
      Result:= False;
      Exit;
    end;
  GetAttributes(Paragraph);
  Result := Paragraph.wReserved and PFE_PAGEBREAKBEFORE <>0;
end;

procedure TParaAttributes98.SetPageBreakBefore(Value: Boolean);
var
  Paragraph: TParaFormat2;
begin
  if RichEdit.FVer10 then
    Exit;
  InitPara(Paragraph);
  with Paragraph do
  begin
    dwMask := PFM_PAGEBREAKBEFORE;
    if Value then
      wReserved:= PFE_PAGEBREAKBEFORE;
  end;
  SetAttributes(Paragraph);
end;

function TParaAttributes98.GetNoLineNumber: Boolean;
var
  Paragraph: TParaFormat2;
begin
  if RichEdit.FVer10 then
    begin
      Result:= False;
      Exit;
    end;
  GetAttributes(Paragraph);
  Result := Paragraph.wReserved and PFE_NOLINENUMBER <>0;
end;

procedure TParaAttributes98.SetNoLineNumber(Value: Boolean);
var
  Paragraph: TParaFormat2;
begin
  if RichEdit.FVer10 then
    Exit;
  InitPara(Paragraph);
  with Paragraph do
  begin
    dwMask := PFM_NOLINENUMBER;
    if Value then
      wReserved:= PFE_NOLINENUMBER;
  end;
  SetAttributes(Paragraph);
end;

function TParaAttributes98.GetNoWidowControl: Boolean;
var
  Paragraph: TParaFormat2;
begin
  if RichEdit.FVer10 then
    begin
      Result:= False;
      Exit;
    end;
  GetAttributes(Paragraph);
  Result := Paragraph.wReserved and PFE_NOWIDOWCONTROL <>0;
end;

procedure TParaAttributes98.SetNoWidowControl(Value: Boolean);
var
  Paragraph: TParaFormat2;
begin
  if RichEdit.FVer10 then
    Exit;
  InitPara(Paragraph);
  with Paragraph do
  begin
    dwMask := PFM_NOWIDOWCONTROL;
    if Value then
      wReserved:= PFE_NOWIDOWCONTROL;
  end;
  SetAttributes(Paragraph);
end;

function TParaAttributes98.GetDoNotHyphen: Boolean;
var
  Paragraph: TParaFormat2;
begin
  if RichEdit.FVer10 then
    begin
      Result:= False;
      Exit;
    end;
  GetAttributes(Paragraph);
  Result := Paragraph.wReserved and PFE_DONOTHYPHEN <>0;
end;

procedure TParaAttributes98.SetDoNotHyphen(Value: Boolean);
var
  Paragraph: TParaFormat2;
begin
  if RichEdit.FVer10 then
    Exit;
  InitPara(Paragraph);
  with Paragraph do
  begin
    dwMask := PFM_DONOTHYPHEN;
    if Value then
      wReserved:= PFE_DONOTHYPHEN;
  end;
  SetAttributes(Paragraph);
end;

function TParaAttributes98.GetSideBySide: Boolean;
var
  Paragraph: TParaFormat2;
begin
  if RichEdit.FVer10 then
    begin
      Result:= False;
      Exit;
    end;
  GetAttributes(Paragraph);
  Result := Paragraph.wReserved and PFE_SIDEBYSIDE <>0;
end;

procedure TParaAttributes98.SetSideBySide(Value: Boolean);
var
  Paragraph: TParaFormat2;
begin
  if RichEdit.FVer10 then
    Exit;
  InitPara(Paragraph);
  with Paragraph do
  begin
    dwMask := PFM_SIDEBYSIDE;
    if Value then
      wReserved:= PFE_SIDEBYSIDE;
  end;
  SetAttributes(Paragraph);
end;

function TParaAttributes98.GetAlignment: TAlignment98;
var
  Paragraph: TParaFormat2;
begin
  if RichEdit.FVer10 then
    begin
      Result:= TAlignment98(TRichEdit(RichEdit).Paragraph.Alignment);
      Exit;
    end;
  GetAttributes(Paragraph);
  Result := TAlignment98(Paragraph.wAlignment - 1);
end;

procedure TParaAttributes98.SetAlignment(Value: TAlignment98);
var
  Paragraph: TParaFormat2;
begin
  if RichEdit.FVer10 then
    begin
      TRichEdit(RichEdit).Paragraph.Alignment:= TAlignment(Value);
      Exit;
    end;
  InitPara(Paragraph);
  with Paragraph do
  begin
    dwMask := PFM_ALIGNMENT;
    wAlignment := Ord(Value) + 1;
  end;
  SetAttributes(Paragraph);
end;

function TParaAttributes98.GetNumbering: TNumberingStyle98;
var
  Paragraph: TParaFormat2;
begin
  if RichEdit.FVer10 then
    begin
      Result:= TNumberingStyle98(TRichEdit(RichEdit).Paragraph.Numbering);
      Exit;
    end;
  GetAttributes(Paragraph);
  Result := TNumberingStyle98(Paragraph.wNumbering);
end;

procedure TParaAttributes98.SetNumbering(Value: TNumberingStyle98);
var
  Paragraph: TParaFormat2;
begin
  if RichEdit.FVer10 then
    begin
      TRichEdit(RichEdit).Paragraph.Numbering:= TNumberingStyle(Value<>nsNone);
      Exit;
    end;
  InitPara(Paragraph);
  with Paragraph do
    begin
      dwMask := PFM_NUMBERING;
      wNumbering := Word(Value);
    end;
  SetAttributes(Paragraph);
end;

function TParaAttributes98.GetNumberingStart: Word;
var
  Paragraph: TParaFormat2;
begin
  if RichEdit.FVer10 then
    begin
      Result:= 0;
      Exit;
    end;
  GetAttributes(Paragraph);
  Result := Paragraph.wNumberingStart;
end;

procedure TParaAttributes98.SetNumberingStart(Value: Word);
var
  Paragraph: TParaFormat2;
begin
  if RichEdit.FVer10 then
    Exit;
  InitPara(Paragraph);
  with Paragraph do
    begin
      dwMask := PFM_NUMBERINGSTART;
      wNumberingStart := Value;
    end;
  SetAttributes(Paragraph);
end;

function TParaAttributes98.GetNumberingFollow: TNumberingFollow;
var
  Paragraph: TParaFormat2;
begin
  if RichEdit.FVer10 then
    begin
      Result:= nfPeriod;
      Exit;
    end;
  GetAttributes(Paragraph);
  Result := TNumberingFollow(Paragraph.wNumberingStyle);
end;

procedure TParaAttributes98.SetNumberingFollow(Value: TNumberingFollow);
var
  Paragraph: TParaFormat2;
begin
  if RichEdit.FVer10 then
    Exit;
  InitPara(Paragraph);
  with Paragraph do
    begin
      dwMask := PFM_NUMBERINGSTYLE;
      wNumberingStyle := Word(Value);
    end;
  SetAttributes(Paragraph);
end;

function TParaAttributes98.GetNumberingTab: Double;
var
  Paragraph: TParaFormat2;
begin
  if RichEdit.FVer10 then
    begin
      Result:= 0;
      Exit;
    end;
  GetAttributes(Paragraph);
  Result := Paragraph.wNumberingTab/20;
end;

procedure TParaAttributes98.SetNumberingTab(Value: Double);
var
  Paragraph: TParaFormat2;
begin
  if RichEdit.FVer10 then
    Exit;
  InitPara(Paragraph);
  with Paragraph do
    begin
      dwMask := PFM_NUMBERINGTAB;
      wNumberingTab := Round(Value*20);
    end;
  SetAttributes(Paragraph);
end;

function TParaAttributes98.GetBorderSpace: Double;
var
  Paragraph: TParaFormat2;
begin
  if RichEdit.FVer10 then
    begin
      Result:= 0;
      Exit;
    end;
  GetAttributes(Paragraph);
  Result := Paragraph.wBorderSpace/20;
end;

function TParaAttributes98.GetBorderWidth: Double;
var
  Paragraph: TParaFormat2;
begin
  if RichEdit.FVer10 then begin
    Result := 0.1;
    Exit;
    end;
  GetAttributes(Paragraph);
  Result := Paragraph.wBorderWidth/20;
end;

function TParaAttributes98.GetBorderLocations: TBorderLocations;
var
  Paragraph: TParaFormat2;
begin
  if RichEdit.FVer10 then
    begin
      Result:= [];
      Exit;
    end;
  GetAttributes(Paragraph);
  Byte(Result) := Lo(Paragraph.wBorders);
end;

function TParaAttributes98.GetBorderStyle: TBorderStyle;
var
  Paragraph: TParaFormat2;
begin
  if RichEdit.FVer10 then begin
    Result := bsNone;
    Exit;
    end;
  GetAttributes(Paragraph);
  Byte(Result) := Hi(Paragraph.wBorders) and 15;
end;

const
  IndexedColors: array[0..15]of TColor=
  (clBlack, clBlue, clAqua, clLime, clFuchsia, clRed, clYellow, clWhite,
   clNavy, clTeal, clGreen, clPurple, clMaroon, clOlive, clDkGray, clLtGray);

function FindClosestColor(Color: TColor): Byte;
var
  I, N, NMin: Byte;
begin
  NMin:= 255;
  Result := 0;
  for I:= 0 to 15 do
    begin
      N:= Abs(TPaletteEntry(Color).peBlue-TPaletteEntry(IndexedColors[I]).peBlue)+
          Abs(TPaletteEntry(Color).peGreen-TPaletteEntry(IndexedColors[I]).peGreen)+
          Abs(TPaletteEntry(Color).peRed-TPaletteEntry(IndexedColors[I]).peRed);
      if N<NMin then begin
          NMin := N;
          Result := I;
          if N = 0 then
            Exit;
        end;
    end;
end;

function TParaAttributes98.GetBorderColor: TColor;
var
  Paragraph: TParaFormat2;
begin
  if RichEdit.FVer10 then
    begin
      Result:= clNone;
      Exit;
    end;
  GetAttributes(Paragraph);
  Result:= IndexedColors[Hi(Paragraph.wBorders) shr 4];
end;

procedure TParaAttributes98.SetBorder(Space, Width: Double; Locations: TBorderLocations;
                    Style: TBorderStyle; Color: TColor);
var
  Paragraph: TParaFormat2;
begin
  if RichEdit.FVer10 then
    Exit;
  InitPara(Paragraph);
  with Paragraph do
    begin
      dwMask := PFM_BORDER;
      wBorderSpace := Round(Space*20);
      wBorderWidth := Round(Width*20);
      wBorders:= FindClosestColor(Color) shl 12 or Byte(Style) shl 8 or Byte(Locations);
    end;
  SetAttributes(Paragraph);
end;

function TParaAttributes98.GetShadingWeight: TShadingWeight;
var
  Paragraph: TParaFormat2;
begin
  if RichEdit.FVer10 then
    begin
      Result:= 0;
      Exit;
    end;
  GetAttributes(Paragraph);
  Result := TShadingWeight(Paragraph.wShadingWeight);
end;

function TParaAttributes98.GetShadingStyle: TShadingStyle;
var
  Paragraph: TParaFormat2;
begin
  if RichEdit.FVer10 then begin
    Result := shsNone;
    Exit;
    end;
  GetAttributes(Paragraph);
  Result := TShadingStyle(Paragraph.wShadingStyle and 15);
end;

function TParaAttributes98.GetShadingColor: TColor;
var
  Paragraph: TParaFormat2;
begin
  if RichEdit.FVer10 then
    begin
      Result:= clNone;
      Exit;
    end;
  GetAttributes(Paragraph);
  Result := IndexedColors[(Paragraph.wShadingStyle shr 4) and 15];
end;

function TParaAttributes98.GetShadingBackColor: TColor;
var
  Paragraph: TParaFormat2;
begin
  if RichEdit.FVer10 then begin
    Result := clWindow;
    Exit;
    end;
  GetAttributes(Paragraph);
  Result := IndexedColors[(Paragraph.wShadingStyle shr 8) and 15];
end;

procedure TParaAttributes98.SetShading(Weight: TShadingWeight; Style: TShadingStyle;
                                       Color, BackColor: TColor);
var
  Paragraph: TParaFormat2;
begin
  if RichEdit.FVer10 then
    Exit;
  InitPara(Paragraph);
  with Paragraph do
    begin
      dwMask := PFM_SHADING;
      wShadingWeight := Weight;
      wShadingStyle:= FindClosestColor(BackColor) shl 8 or
                      FindClosestColor(Color) shl 4 or Byte(Style);
    end;
  SetAttributes(Paragraph);
end;

function TParaAttributes98.GetTabCount: Integer;
var
  Paragraph: TParaFormat2;
begin
  if RichEdit.FVer10 then
    begin
      Result:= TRichEdit(RichEdit).Paragraph.TabCount;
      Exit;
    end;
  GetAttributes(Paragraph);
  Result := Paragraph.cTabCount;
end;

function TParaAttributes98.GetTab(Index: Integer): Double;
var
  Paragraph: TParaFormat2;
begin
  if RichEdit.FVer10 then
    begin
      Result:= TRichEdit(RichEdit).Paragraph.Tab[Index];
      Exit;
    end;
  GetAttributes(Paragraph);
  Result := (Paragraph.rgxTabs[Index] and $FFFFFF)/20;
end;

function TParaAttributes98.GetTabAlignment(Index: Integer): TTabAlignment;
var
  Paragraph: TParaFormat2;
begin
  if RichEdit.FVer10 then
    begin
      Result:= tbaLeft;
      Exit;
    end;
  GetAttributes(Paragraph);
  Result := TTabAlignment(Paragraph.rgxTabs[Index] shr 24 and 15);
end;

function TParaAttributes98.GetTabLeader(Index: Integer): TTabLeader;
var
  Paragraph: TParaFormat2;
begin
  if RichEdit.FVer10 then
    begin
      Result:= tblNone;
      Exit;
    end;
  GetAttributes(Paragraph);
  Result := TTabLeader(Paragraph.rgxTabs[Index] shr 28);
end;

procedure TParaAttributes98.SetTab(Index: Integer; Value: Double;
                                   Alignment: TTabAlignment; Leader: TTabLeader);
var
  Paragraph: TParaFormat2;
begin
  if RichEdit.FVer10 then
    begin
      TRichEdit(RichEdit).Paragraph.Tab[Index]:= Round(Value);
      Exit;
    end;
  GetAttributes(Paragraph);
  with Paragraph do
  begin
    rgxTabs[Index] := Round(Value * 20) or (Byte(Alignment) shl 24) or
                      (Byte(Leader) shl 28);
    dwMask := PFM_TABSTOPS;
    if cTabCount < Index then cTabCount := Index;
    SetAttributes(Paragraph);
  end;
end;



{ TRichEditStrings98 }

const
  ReadError = $0001;
  WriteError = $0002;
  NoError = $0000;
  ReReadError = $0003;

type
  TSelection = record
    StartPos, EndPos: Integer;
  end;

  PRichEditStreamInfo = ^TRichEditStreamInfo;
  TRichEditStreamInfo = record
    Converter: TConversion;
    Stream: TStream;
    RichEdit: TCustomRichEdit98;
  end;

  TRichEditStrings98 = class(TStrings)
  private
    RichEdit: TCustomRichEdit98;
    FConverter: TConversion;
    procedure EnableChange(const Value: Boolean);
  protected
    function Get(Index: Integer): string; override;
    function GetCount: Integer; override;
    procedure Put(Index: Integer; const S: string); override;
    procedure SetUpdateState(Updating: Boolean); override;
    procedure SetTextStr(const Value: string); override;
//    function GetPlainText: Boolean;
//    procedure SetPlainText(Value: Boolean);
    function GetInputFormat: TInputFormat;
    procedure SetInputFormat(Value: TInputFormat);
    function GetOutputFormat: TOutputFormat;
    procedure SetOutputFormat(Value: TOutputFormat);
    function GetSelectedInOut:Boolean;
    procedure SetSelectedInOut(Value: Boolean);
    function GetPlainRTF: Boolean;
    procedure SetPlainRTF(Value: Boolean);
  public
    procedure Clear; override;
    procedure AddStrings(Strings: TStrings); override;
    procedure Delete(Index: Integer); override;
    procedure Insert(Index: Integer; const S: string); override;
    procedure LoadFromFile(const FileName: string); override;
    procedure LoadFromStream(Stream: TStream); override;
    procedure SaveToFile(const FileName: string); override;
    procedure SaveToStream(Stream: TStream); override;
//    property PlainText: Boolean read GetPlainText write SetPlainText;
    property InputFormat: TInputFormat read GetInputFormat write SetInputFormat;
    property OutputFormat: TOutputFormat read GetOutputFormat write SetOutputFormat;
    property SelectedInOut: Boolean read GetSelectedInOut write SetSelectedInOut;
    property PlainRTF:Boolean read GetPlainRTF write SetPlainRTF;
  end;

  TWideRichEditStrings98 = class(TWideStrings)
  private
    RichEdit: TCustomRichEdit98;
    procedure EnableChange(const Value: Boolean);
  protected
    function Get(Index: Integer): WideString; override;
    function GetCount: Integer; override;
    procedure Put(Index: Integer; const S: WideString); override;
    procedure SetUpdateState(Updating: Boolean); override;
    procedure SetTextStr(const Value: WideString); override;
    procedure SetLanguage(Value: TLanguage); override;
    function GetLanguage: TLanguage; override;
//    function GetPlainText: Boolean;
//    procedure SetPlainText(Value: Boolean);
    function GetInputFormat: TInputFormat;
    procedure SetInputFormat(Value: TInputFormat);
    function GetOutputFormat: TOutputFormat;
    procedure SetOutputFormat(Value: TOutputFormat);
    function GetSelectedInOut:Boolean;
    procedure SetSelectedInOut(Value: Boolean);
    function GetPlainRTF: Boolean;
    procedure SetPlainRTF(Value: Boolean);
  public
    procedure Clear; override;
    procedure AddStrings(Strings: TWideStrings); override;
    procedure Delete(Index: Integer); override;
    procedure Insert(Index: Integer; const S: WideString); override;
    procedure LoadFromFile(const FileName: string); override;
    procedure LoadFromStream(Stream: TStream); override;
    procedure SaveToFile(const FileName: string); override;
    procedure SaveToStream(Stream: TStream); override;
//    property PlainText: Boolean read GetPlainText write SetPlainText;
    property InputFormat: TInputFormat read GetInputFormat write SetInputFormat;
    property OutputFormat: TOutputFormat read GetOutputFormat write SetOutputFormat;
    property SelectedInOut: Boolean read GetSelectedInOut write SetSelectedInOut;
    property PlainRTF:Boolean read GetPlainRTF write SetPlainRTF;
  end;

procedure TRichEditStrings98.AddStrings(Strings: TStrings);
var
  SelChange: TNotifyEvent;
begin
  SelChange := RichEdit.OnSelectionChange;
  RichEdit.OnSelectionChange := nil;
  try
    inherited AddStrings(Strings);
  finally
    RichEdit.OnSelectionChange := SelChange;
  end;
end;

function TRichEditStrings98.GetCount: Integer;
begin
  Result := RichEdit.Perform(EM_GETLINECOUNT, 0, 0);
  if RichEdit.Perform(EM_LINELENGTH,
    RichEdit.Perform(EM_LINEINDEX, Result - 1, 0), 0) = 0 then Dec(Result);
end;

function TRichEditStrings98.Get(Index: Integer): string;
begin
  Result:= WideToChar(TWideRichEditStrings98(RichEdit.WideLines).Get(Index), RichEdit.FCP);
end;

procedure TRichEditStrings98.Put(Index: Integer; const S: string);
begin
  TWideRichEditStrings98(RichEdit.WideLines).Put(Index, CharToWide(S, RichEdit.FCP));
end;

procedure TRichEditStrings98.Insert(Index: Integer; const S: string);
begin
  TWideRichEditStrings98(RichEdit.WideLines).Insert(Index, CharToWide(S, RichEdit.FCP));
end;

procedure TRichEditStrings98.Delete(Index: Integer);
begin
  TWideRichEditStrings98(RichEdit.WideLines).Delete(Index);
end;

procedure TRichEditStrings98.Clear;
begin
  RichEdit.Clear;
end;

procedure TRichEditStrings98.SetUpdateState(Updating: Boolean);
begin
  RichEdit.Perform(WM_SETREDRAW, Ord(not Updating), 0);
  if not Updating then begin
    RichEdit.Refresh;
    RichEdit.Perform(CM_TEXTCHANGED, 0, 0);
  end;
end;

procedure TRichEditStrings98.EnableChange(const Value: Boolean);
var
  EventMask: Longint;
begin
  with RichEdit do
  begin
    if Value then
      EventMask := Perform(EM_GETEVENTMASK, 0, 0) or ENM_CHANGE
    else
      EventMask := Perform(EM_GETEVENTMASK, 0, 0) and not ENM_CHANGE;
    Perform(EM_SETEVENTMASK, 0, EventMask);
  end;
end;

procedure TRichEditStrings98.SetTextStr(const Value: string);
begin
  EnableChange(False);
  try
    inherited SetTextStr(Value);
  finally
    EnableChange(True);
  end;
end;

function TRichEditStrings98.GetInputFormat: TInputFormat;
begin
  Result:= RichEdit.InputFormat;
end;

procedure TRichEditStrings98.SetInputFormat(Value: TInputFormat);
begin
  RichEdit.InputFormat:= Value;
end;

function TRichEditStrings98.GetOutputFormat: TOutputFormat;
begin
  Result:= RichEdit.OutputFormat;
end;

procedure TRichEditStrings98.SetOutputFormat(Value: TOutputFormat);
begin
  RichEdit.OutputFormat:= Value;
end;

function TRichEditStrings98.GetSelectedInOut:Boolean;
begin
     Result:=RichEdit.SelectedInOut;
end;

procedure TRichEditStrings98.SetSelectedInOut(Value: Boolean);
begin
  RichEdit.SelectedInOut:=Value;
end;

function TRichEditStrings98.GetPlainRTF: Boolean;
begin
  Result:=RichEdit.PlainRTF;
end;

procedure TRichEditStrings98.SetPlainRTF(Value: Boolean);
begin
  RichEdit.PlainRTF:=Value;
end;

function StreamSave(dwCookie: Longint; pbBuff: PByte;
  cb: Longint; var pcb: Longint): Longint; stdcall;
var
  StreamInfo: PRichEditStreamInfo;
begin
  Result := NoError;
  StreamInfo := PRichEditStreamInfo(Pointer(dwCookie));
  try
    pcb := 0;
    if StreamInfo^.Converter <> nil then
      pcb:= StreamInfo^.Converter.ConvertWriteStream(StreamInfo^.Stream, PChar(pbBuff), cb);
    if Assigned(StreamInfo^.RichEdit.FOnSaveProgress) then
      StreamInfo^.RichEdit.FOnLoadProgress(StreamInfo^.RichEdit,
                                           StreamInfo^.Stream.Position,
                                           StreamInfo^.Stream.Size);
  except
    Result := WriteError;
  end;
end;

function StreamLoad(dwCookie: Longint; pbBuff: PChar;
  cb: Longint; var pcb: Longint): Longint; stdcall;
var
  StreamInfo: PRichEditStreamInfo;
begin
  Result := NoError;
  StreamInfo := PRichEditStreamInfo(Pointer(dwCookie));
  pcb:= 0;
  try
    if Assigned(StreamInfo^.RichEdit.FOnLoadProgress) then
      StreamInfo^.RichEdit.FOnLoadProgress(StreamInfo^.RichEdit,
                                           StreamInfo^.Stream.Position,
                                           StreamInfo^.Stream.Size);
    if StreamInfo^.Converter <> nil then
      pcb:= StreamInfo^.Converter.ConvertReadStream(StreamInfo^.Stream, pbBuff, cb);
  except
    Result := ReadError;
  end;
end;

procedure TRichEditStrings98.LoadFromStream(Stream: TStream);
var
  EditStream: TEditStream;
  Position: Longint;
  TextType: Longint;
  StreamInfo: TRichEditStreamInfo;
  Converter: TConversion;
begin
  StreamInfo.Stream := Stream;
  if FConverter <> nil then
    Converter := FConverter else
    Converter := RichEdit.DefaultConverter.Create;
  StreamInfo.Converter := Converter;
  StreamInfo.RichEdit:= RichEdit;
  try
    with EditStream do
    begin
      dwCookie := LongInt(Pointer(@StreamInfo));
      pfnCallBack := @StreamLoad;
      dwError := 0;
    end;
    Position := Stream.Position;
    case InputFormat of
    ifText:
      TextType:=SF_TEXT;
    ifUnicode:
      TextType:=SF_UNICODE or SF_TEXT;
    else
      TextType:=SF_RTF;
    end;

    if SelectedInOut then
      TextType := (TextType or SFF_SELECTION)
    else
      TextType := (TextType or SFF_PLAINRTF);

    RichEdit.Perform(EM_STREAMIN, TextType, Longint(@EditStream));
    if ((TextType and SF_RTF)=SF_RTF) and (EditStream.dwError <> 0) then
      begin
        Stream.Position:= Position;
        TextType:= SF_TEXT;
        if SelectedInOut then
          TextType:= TextType or SFF_SELECTION;
        if PlainRTF then
          TextType:= TextType or SFF_PLAINRTF;
        RichEdit.Perform(EM_STREAMIN, TextType, Longint(@EditStream));
        if EditStream.dwError <> 0 then
          raise EOutOfResources.Create(sRichEditLoadFail);
      end;
  finally
    if FConverter = nil then Converter.Free;
    if RichEdit.AutoURLDetect=adExtended then
      begin
        RichEdit.FCROld.cpMin:= 0;
        RichEdit.FCROld.cpMax:= GetWindowTextLength(RichEdit.Handle);
        RichEdit.DetectURLs(RichEdit.FCROld);
      end;
  end;
end;

procedure TRichEditStrings98.SaveToStream(Stream: TStream);
var
  EditStream: TEditStream;
  TextType: Longint;
  StreamInfo: TRichEditStreamInfo;
  Converter: TConversion;
begin
  if FConverter <> nil then
    Converter := FConverter else
    Converter := RichEdit.DefaultConverter.Create;
  StreamInfo.Stream := Stream;
  StreamInfo.Converter := Converter;
  StreamInfo.RichEdit:= RichEdit;
  try
    with EditStream do
    begin
      dwCookie := LongInt(Pointer(@StreamInfo));
      pfnCallBack := @StreamSave;
      dwError := 0;
    end;
    case OutputFormat of
    ofText:
      TextType:= SF_TEXT;
    ofRTFNoObjs:
      TextType:= SF_RTFNOOBJS;
    ofTextized:
      TextType:= SF_TEXTIZED;
    ofUnicode:
      TextType:= SF_TEXT or SF_UNICODE;
    else
      TextType:= SF_RTF;
    end;

    if SelectedInOut then TextType := (TextType or SFF_SELECTION)
    else TextType := (TextType or SFF_PLAINRTF);

    RichEdit.Perform(EM_STREAMOUT, TextType, Longint(@EditStream));
    if EditStream.dwError <> 0 then
      raise EOutOfResources.Create(sRichEditSaveFail);
  finally
    if FConverter = nil then Converter.Free;
  end;
end;

procedure TRichEditStrings98.LoadFromFile(const FileName: string);
var
  Ext: string;
  Convert: PConversionFormat;
begin
  Ext := AnsiLowerCaseFileName(ExtractFileExt(Filename));
  System.Delete(Ext, 1, 1);
  Convert := ConversionFormatList;
  while Convert <> nil do
    with Convert^ do
      if Extension <> Ext then Convert := Next
      else Break;
  if Convert = nil then
    Convert := @TextConversionFormat;
  FConverter := Convert^.ConversionClass.Create;
  try
    inherited LoadFromFile(FileName);
  except
    FConverter.Free;
    FConverter := nil;
    raise;
  end;
end;

procedure TRichEditStrings98.SaveToFile(const FileName: string);
var
  Ext: string;
  Convert: PConversionFormat;
begin
  Ext := AnsiLowerCaseFileName(ExtractFileExt(Filename));
  System.Delete(Ext, 1, 1);
  Convert := ConversionFormatList;
  while Convert <> nil do
    with Convert^ do
      if Extension <> Ext then Convert := Next
      else Break;
  if Convert = nil then
    Convert := @TextConversionFormat;
  FConverter := Convert^.ConversionClass.Create;
  try
    inherited SaveToFile(FileName);
  except
    FConverter.Free;
    FConverter := nil;
    raise;
  end;
end;

procedure TWideRichEditStrings98.AddStrings(Strings: TWideStrings);
var
  SelChange: TNotifyEvent;
begin
  SelChange := RichEdit.OnSelectionChange;
  RichEdit.OnSelectionChange := nil;
  try
    inherited AddStrings(Strings);
  finally
    RichEdit.OnSelectionChange := SelChange;
  end;
end;

function TWideRichEditStrings98.GetCount: Integer;
begin
  Result := RichEdit.Perform(EM_GETLINECOUNT, 0, 0);
  if RichEdit.Perform(EM_LINELENGTH,
    RichEdit.Perform(EM_LINEINDEX, Result - 1, 0), 0) = 0 then Dec(Result);
end;

function TWideRichEditStrings98.Get(Index: Integer): WideString;
var
  Text: array[0..4095] of WideChar;
  L: Integer;
begin
  RichEdit.FWide:= True;
  Word((@Text)^) := SizeOf(Text);
  L := RichEdit.PrivatePerform(EM_GETLINE, Index, Longint(@Text));
  if ((Text[L - 1] = #13) or (Text[L - 1] = #11)) then Dec(L, 1);  //CR or Shift-CR
  SetString(Result, Text, L);
  RichEdit.FWide:= False;
end;

procedure TWideRichEditStrings98.Put(Index: Integer; const S: WideString);
var
  Selection: TCharRange;
begin
  if Index >= 0 then
  begin
    RichEdit.FWide:= True;
    Selection.cpMin := RichEdit.Perform(EM_LINEINDEX, Index, 0);
    if Selection.cpMin <> -1 then
    begin
      Selection.cpMax := Selection.cpMin +
        RichEdit.Perform(EM_LINELENGTH, Selection.cpMin, 0);
      RichEdit.Perform(EM_EXSETSEL, 0, Longint(@Selection));
      // RichEdit.PrivatePerform(EM_REPLACESEL, 0, Longint(PChar(String(S)));
      RichEdit.PrivatePerform(EM_REPLACESEL, 0, Longint(Addr(s)));
    end;
    RichEdit.FWide:= False;
  end;
end;

procedure TWideRichEditStrings98.Insert(Index: Integer; const S: WideString);
var
  L: Integer;
  Selection: TCharRange;
  Str: WideString;
begin
  if Index >= 0 then
  begin
    RichEdit.FWide:= True;
    Selection.cpMin := RichEdit.Perform(EM_LINEINDEX, Index, 0);
    if Selection.cpMin >= 0 then
      Str:= S+WideString(#13)
    else begin
      Selection.cpMin :=
        RichEdit.Perform(EM_LINEINDEX, Index - 1, 0);
      if Selection.cpMin < 0 then Exit;
      L := RichEdit.Perform(EM_LINELENGTH, Selection.cpMin, 0);
      if L = 0 then Exit;
      Inc(Selection.cpMin, L);
      Str := WideString(#13)+S;
    end;
    Selection.cpMax := Selection.cpMin;
    RichEdit.Perform(EM_EXSETSEL, 0, Longint(@Selection));
    RichEdit.PrivatePerform(EM_REPLACESEL, 0, LongInt(@Str[1]));
    if RichEdit.SelStart <> (Selection.cpMax + Length(Str)) then
      raise EOutOfResources.Create(sRichEditInsertError);
    RichEdit.FWide:= False;
  end;
end;

procedure TWideRichEditStrings98.Delete(Index: Integer);
const
  Empty: PWideChar = '';
var
  Selection: TCharRange;
begin
  if Index < 0 then Exit;
  Selection.cpMin := RichEdit.Perform(EM_LINEINDEX, Index, 0);
  if Selection.cpMin <> -1 then
  begin
    Selection.cpMax := RichEdit.Perform(EM_LINEINDEX, Index + 1, 0);
    if Selection.cpMax = -1 then
      Selection.cpMax := Selection.cpMin +
        RichEdit.Perform(EM_LINELENGTH, Selection.cpMin, 0);
    RichEdit.Perform(EM_EXSETSEL, 0, Longint(@Selection));
    RichEdit.PrivatePerform(EM_REPLACESEL, 0, Longint(Empty));
  end;
end;

procedure TWideRichEditStrings98.Clear;
begin
  RichEdit.Clear;
end;

procedure TWideRichEditStrings98.SetUpdateState(Updating: Boolean);
begin
  RichEdit.Perform(WM_SETREDRAW, Ord(not Updating), 0);
  if not Updating then begin
    RichEdit.Refresh;
    RichEdit.PrivatePerform(CM_TEXTCHANGED, 0, 0);
  end;
end;

procedure TWideRichEditStrings98.EnableChange(const Value: Boolean);
var
  EventMask: Longint;
begin
  with RichEdit do
  begin
    if Value then
      EventMask := Perform(EM_GETEVENTMASK, 0, 0) or ENM_CHANGE
    else
      EventMask := Perform(EM_GETEVENTMASK, 0, 0) and not ENM_CHANGE;
    Perform(EM_SETEVENTMASK, 0, EventMask);
  end;
end;

procedure TWideRichEditStrings98.SetTextStr(const Value: WideString);
begin
  RichEdit.FWide:= True;
  EnableChange(False);
  try
    inherited SetTextStr(Value);
  finally
    EnableChange(True);
  end;
  RichEdit.FWide:= False;
end;
{
function TWideRichEditStrings98.GetPlainText: Boolean;
begin
  Result:= RichEdit.PlainText;
end;

procedure TWideRichEditStrings98.SetPlainText(Value: Boolean);
begin
  RichEdit.PlainText:= Value;
end;
}
function TWideRichEditStrings98.GetInputFormat: TInputFormat;
begin
  Result:= RichEdit.InputFormat;
end;

procedure TWideRichEditStrings98.SetInputFormat(Value: TInputFormat);
begin
  RichEdit.InputFormat:= Value;
end;

function TWideRichEditStrings98.GetOutputFormat: TOutputFormat;
begin
  Result:= RichEdit.OutputFormat;
end;

procedure TWideRichEditStrings98.SetOutputFormat(Value: TOutputFormat);
begin
  RichEdit.OutputFormat:= Value;
end;

function TWideRichEditStrings98.GetSelectedInOut:Boolean;
begin
     Result:=RichEdit.SelectedInOut;
end;

procedure TWideRichEditStrings98.SetSelectedInOut(Value: Boolean);
begin
     RichEdit.SelectedInOut:=Value;
end;

function TWideRichEditStrings98.GetPlainRTF: Boolean;
begin
     Result:=RichEdit.PlainRTF;
end;

procedure TWideRichEditStrings98.SetPlainRTF(Value: Boolean);
begin
     RichEdit.PlainRTF:=Value;
end;

procedure TWideRichEditStrings98.LoadFromStream(Stream: TStream);
begin
  RichEdit.Lines.LoadFromStream(Stream);
end;

procedure TWideRichEditStrings98.SaveToStream(Stream: TStream);
begin
  RichEdit.Lines.SaveToStream(Stream);
end;

procedure TWideRichEditStrings98.LoadFromFile(const FileName: string);
begin
  RichEdit.Lines.LoadFromFile(FileName);
end;

procedure TWideRichEditStrings98.SaveToFile(const FileName: string);
begin
  RichEdit.Lines.SaveToFile(FileName);
end;

procedure TWideRichEditStrings98.SetLanguage(Value: TLanguage);
begin
  RichEdit.Language:= Value;
end;

function TWideRichEditStrings98.GetLanguage: TLanguage;
begin
  Result:= RichEdit.Language;
end;





{TURLType}
procedure TURLType.Assign(Source: TPersistent);
begin
  if (Source is TURLType) then
    begin
      Name:= TURLType(Source).Name;
      Color:= TURLType(Source).Color;
      Cursor:= TURLType(Source).Cursor;
      Underline:= TURLType(Source).Underline;
    end;
end;

function TURLType.GetDisplayName: string;
begin
  Result:= Name;
end;



{TURLCollection}

procedure TURLCollection.AddURLType(const Name: String; Color: TColor;
                     Cursor: TCursor; Underline: Boolean);
var
  Item: TURLType;
  I: INteger;
begin
  for I:= 0 to Count-1 do
    begin
      Item:= Items[I];
      if Item.Name=Name then
        begin
          Item.Color:= Color;
          Item.Cursor:= Cursor;
          Item.Underline:= Underline;
          Exit;
        end;
    end;
  Item:= TURLType(Add);
  Item.Name:= Name;
  Item.Color:= Color;
  Item.Cursor:= Cursor;
  Item.Underline:= Underline;
end;

function TURLCollection.GetOwner: TPersistent;
begin
  Result:= FOwner;
end;

procedure TURLCollection.SetItems(Index: Integer; Value: TURLType);
begin
  if (Index>-1) and (Index<Count) then
    Items[Index].Assign(Value);
end;

function TURLCollection.GetItems(Index: Integer): TURLType;
begin
  Result:= TURLType(inherited Items[Index]);
end;





{ TCustomRichEdit98 }

constructor TCustomRichEdit98.Create(AOwner: TComponent);
var
  DC: HDC;
begin
  FUpdateCount:= 0;
  FShowSelBar:= False;
  FLangOptions:= [loAutoFont];
  inherited Create(AOwner);
  FSelAttributes := TTextAttributes98.Create(Self, atSelected);
  FDefAttributes := TTextAttributes98.Create(Self, atDefaultText);
  FParagraph := TParaAttributes98.Create(Self);
  FRichEditStrings:= TRichEditStrings98.Create;
  TRichEditStrings98(FRichEditStrings).RichEdit := Self;
  FWideStrings := TWideRichEditStrings98.Create;
  TWideRichEditStrings98(FWideStrings).RichEdit := Self;
  DC := GetDC(0);
  FScreenLogPixels := GetDeviceCaps(DC, LOGPIXELSY);
  ReleaseDC(0, DC);
  FWide:= False;
  FWordFormatting:= True;
  Language:= GetSystemDefaultLCID;
  FURLs:= TURLCollection.Create(TURLType);
  FURLs.FOwner:= Self;
  FURLs.AddURLType('e-mail', clWindowText, crDefault, True);
  FURLs.AddURLType('http', clWindowText, crDefault, True);
  FURLs.AddURLType('file', clWindowText, crDefault, True);
  FURLs.AddURLType('mailto', clWindowText, crDefault, True);
  FURLs.AddURLType('ftp', clWindowText, crDefault, True);
  FURLs.AddURLType('https', clWindowText, crDefault, True);
  FURLs.AddURLType('gopher', clWindowText, crDefault, True);
  FURLs.AddURLType('nntp', clWindowText, crDefault, True);
  FURLs.AddURLType('prospero', clWindowText, crDefault, True);
  FURLs.AddURLType('telnet', clWindowText, crDefault, True);
  FURLs.AddURLType('news', clWindowText, crDefault, True);
  FURLs.AddURLType('wais', clWindowText, crDefault, True);
  FURLColor:= clBlue;
  FURLCursor:= crHandpoint;
  FStreamSel:= False;
  FCROld.cpMin:= 0;
  FCROld.cpMax:= 0;

  FAutoVerbMenu:= true;
  FPlainTextIn:= ifRTF;
  FPlainTextOut:= ofRTF;
  FPlainRTF:= False;
  FSelectedInOut:= False;

  FIncludeOLE:= False;
end;

destructor TCustomRichEdit98.Destroy;
begin
  FSelAttributes.Free;
  FDefAttributes.Free;
  FParagraph.Free;
  FRichEditStrings.Free;
  FWideStrings.Free;
  FURLs.Free;

  DestroyVerbs;

  inherited Destroy;
end;

{$WARNINGS OFF}
function TCustomRichEdit98.ObjectSelected:Boolean;
var ReObject:TReObject;
begin
  ReObject.cbStruct:= sizeof(TReObject);
  result:=(RichEditOle.GetObject(REO_IOB_SELECTION, ReObject, REO_GETOBJ_POLEOBJ) = S_OK) and
          Assigned(ReObject.oleobj);
end;
{$WARNINGS ON}

procedure TCustomRichEdit98.CreateParams(var Params: TCreateParams);
const
  RichEditModuleName = 'RICHED20.DLL';
  ControlClassName = 'RICHEDIT20W';
  CS_OFF = CS_OWNDC or CS_CLASSDC or CS_PARENTDC or CS_GLOBALCLASS;
  CS_ON = CS_VREDRAW or CS_HREDRAW;
var
  OldError: Longint;
  WCW: TWndClassW;
  WCA: TWndClassA;
begin
  OldError := SetErrorMode(SEM_NOOPENFILEERRORBOX);
  FLibHandle := LoadLibrary(RichEditModuleName);
  FVer10:= False;
  if (FLibHandle > 0) and (FLibHandle < HINSTANCE_ERROR) then
    FLibHandle := 0;
  if FLibHandle=0 then
    begin
      FVer10:= True;
      IsWinNT:= False;
      inherited CreateParams(Params);
      Exit;
    end;
  SetErrorMode(OldError);
  if IsWinNT then
    begin
      GetClassInfoW(HInstance, ControlClassName, WCW);
      FDefWndProcW:= WCW.lpfnWndProc;
    end
  else
  GetClassInfoA(HInstance, ControlClassName, WCA);
  FDefWndProcA:= WCA.lpfnWndProc;
  inherited CreateParams(Params);
//  Params.Style:= Params.Style or ES_SAVESEL;
  Params.Style:= Params.Style or WS_CHILD or WS_CLIPCHILDREN or WS_CLIPSIBLINGS or ES_SAVESEL;
  CreateSubClass(Params, ControlClassName);
end;

procedure TCustomRichEdit98.CreateWnd;
var
  Opt: Integer;
begin
  inherited CreateWnd;
  SendMessage(Handle, EM_SETEVENTMASK, 0,
    ENM_CHANGE or ENM_SELCHANGE or ENM_REQUESTRESIZE or
    ENM_PROTECTED or ENM_LINK);
  SendMessage(Handle, EM_AUTOURLDETECT, Ord(AutoURLDetect=adDefault), 0);
  Opt:= Perform(EM_GETOPTIONS, 0, 0);
  if FShowSelBar then
    Opt:= Opt or ECO_SELECTIONBAR
  else
    Opt:= Opt and not ECO_SELECTIONBAR;
  Perform(EM_SETOPTIONS, ECOOP_SET, Opt);
  SetShowSelBar(FShowSelBar);
  Perform(EM_SETLANGOPTIONS, 0, Byte(FLangOptions));

  if FIncludeOLE then
    begin
      if not RichEdit_GetOleInterface(Handle, RichEditOle) then
        raise Exception.Create('Unable to get interface');
      if not RichEdit_SetOleCallback(Handle, RichEditOlecallback) then
        raise Exception.Create('Unable to set callback');
    end;
end;

procedure TCustomRichEdit98.CreateWindowHandle(const Params: TCreateParams);
var
  WCN: WideString;
  P: TCreateParams;
begin
  if IsWinNT then
    with Params do
      begin
        WCN:= WinClassName;
        WindowHandle:= CreateWindowExW(ExStyle, @WCN[1], nil, Style,
        X, Y, Width, Height, WndParent, 0, WindowClass.hInstance, Param);
      end
  else
    begin
      Move(Params, P, SizeOf(Params));
      P.Caption:= nil;
      inherited CreateWindowHandle(P);
    end;
end;

procedure TCustomRichEdit98.CreateOLEObjectInterface;
begin
  RichEditOleCallback := TRichEditOleCallback.Create(Self);
end;

(*{procedure TCustomRichEdit98.CloseOLEObjects;                      {!!0.01 -- added method}
var i: integer;
    REObject: TREObject;
begin
  if not Assigned(RichEditOle) then Exit;
  fillchar(REObject, sizeof(REObject), 0);
  REObject.cbStruct:= sizeof(REObject);
  for i:= 0 to Pred(RichEditOle.GetObjectCount) do begin
    if RichEditOle.GetObject(i, REObject, REO_GETOBJ_POLEOBJ) = S_OK then
      REObject.oleobj.Close(OLECLOSE_NOSAVE);
  end;
end;*)

procedure TCustomRichEdit98.CloseOLEObjects; {!!0.01 -- added method}
var
  I: Integer;
  ReObject: TReObject;
begin
  if not Assigned(RichEditOle) then Exit;
  if FSelObject<>nil then
    begin
      FSelObject.Close(OLECLOSE_NOSAVE);     /// very important
      FSelObject:= nil;
    end;
  FillChar(ReObject, SizeOf(ReObject), 0);
  ReObject.cbStruct := SizeOf(ReObject);
  for I := 1 to RicheditOle.GetObjectCount do
    if RichEditOle.GetObject(I, ReObject, REO_GETOBJ_POLEOBJ) = S_OK then
      ReObject.oleobj.CLOSE(OLECLOSE_NOSAVE);
end;

procedure TCustomRichEdit98.WMNCDestroy(var Message: TWMNCDestroy);
begin
  inherited;
  if FLibHandle <> 0 then FreeLibrary(FLibHandle);
end;

procedure TCustomRichEdit98.WMDestroy(var Msg: TMessage); {!!0.01 -- changed from WM_NCDESTROY}
begin
  CloseOLEObjects;                                {!!0.01}
  RichEditOle:= nil;
  inherited;
end;

procedure TCustomRichEdit98.EMReplaceSel(var Message: TMessage);
var
  W: WideString;
begin
  if not FWide then
    begin
      W:= CharToWide(PChar(Message.LParam), FCP);
      if (Length(W) > 0) then
        Message.LParam := Integer(@W[1])
      else
        Message.LParam := 0;
    end;
  Message.WParam:= 1;
  Message.Result:= PrivatePerform(Message.Msg, Message.WParam, Message.LParam);
end;

procedure TCustomRichEdit98.EMGetSelText(var Message: TMessage);
var
  W: WideString;
  P: PChar;
  L: Integer;
begin
  if SelLength=0 then
    begin
      Message.Result:= 0;
      Exit;
    end;
  if not FWide then begin
      P:= PChar(Message.LParam);
      L:= SelLength;
      SetLength(W, L);
      Message.LParam:= Integer(@W[1]);
      Message.Result:= PrivatePerform(Message.Msg, Message.WParam, Message.LParam);
      WideCharToMultiByte(FCP, 0, @W[1], -1, P, L, nil, nil);
      Message.LParam:= Integer(P);
      end
  else
    Message.Result:= PrivatePerform(Message.Msg, Message.WParam, Message.LParam);
end;

procedure TCustomRichEdit98.EMGetTextRange(var Message: TMessage);
var
  W: WideString;
  P: PChar;
type
  PTextRange = ^TTextRange;
begin
  if not FWide then begin
     with PTextRange(Message.LParam)^ do begin
        P:= lpstrText;
        SetLength(W, Abs(chrg.cpMax - chrg.cpMin));
        lpstrText:= PChar(@W[1]);
        end;
     Message.Result:= PrivatePerform(Message.Msg, Message.WParam, Message.LParam);
     with PTextRange(Message.LParam)^ do begin
        StrPCopy(P, WideToChar(W, FCP));
        lpstrText:= P;
        end;
     end
  else
    Message.Result:= PrivatePerform(Message.Msg, Message.WParam, Message.LParam);
end;

procedure TCustomRichEdit98.Clear; {!!0.01 -- overriden to close objects}
begin
  CloseOLEObjects;
  inherited Clear;
end;

const
  URLChars = ['0'..'9', 'A'..'Z', 'a'..'z', ':', '.', '/', '\', '@'];

procedure TCustomRichEdit98.FindNonSpace(var CR: TCharRange);
var
  TRS: TTextRange;
  C: packed array[0..1]of Char;
  L: Integer;
begin
  L:= GetWindowTextLength(Handle);
  if CR.cpMin>=L then
    CR.cpMin:= L-1;
  TRS.chrg.cpMin:= CR.cpMin;
  TRS.chrg.cpMax:= CR.cpMin+1;
  TRS.lpstrText:= @C[0];
  while (TRS.chrg.cpMin>0) do
    begin
      Perform(EM_GETTEXTRANGE, 0, Integer(@TRS));
      if not (C[0] in URLChars) then
        Break;
      Dec(TRS.chrg.cpMin);
      Dec(TRS.chrg.cpMax);
    end;
  CR.cpMin:= TRS.chrg.cpMin;
  Perform(EM_GETTEXTRANGE, 0, Integer(@TRS));
  if not (C[0] in URLChars) then
    Inc(CR.cpMin);
  if CR.cpMax>=L then
    Exit;
  TRS.chrg.cpMin:= CR.cpMax;
  TRS.chrg.cpMax:= CR.cpMax+1;
  C:= '.';
  while (TRS.chrg.cpMin<=L) and (C[0] in URLChars) do
    begin
      Perform(EM_GETTEXTRANGE, 0, Integer(@TRS));
      Inc(TRS.chrg.cpMin);
      Inc(TRS.chrg.cpMax);
    end;
  CR.cpMax:= TRS.chrg.cpMin-1;
end;

procedure TCustomRichEdit98.DetectURLs(CR: TCharRange);
var
  P1, P2: Integer;
  Word: String;
  I, N: Integer;
  URL, S: String;
  TR: TTextRange;
  OC,
  OSC: TNotifyEvent;
  Start: Integer;
  B: Boolean;
  URLType: TURLType;
  FW: Boolean;
begin
  FW:= FWide;
  FWide:= False;
  TR.chrg:= CR;
  FindNonSpace(TR.chrg);
  if (TR.chrg.cpMin>TR.chrg.cpMax) or (GetWindowTextLength(Handle)<3) then
    Exit;
  BeginUpdate;
  if TR.chrg.cpMin=TR.chrg.cpMax then
    S:= WideText
  else
    begin
      SetLength(S, TR.chrg.cpMax-TR.chrg.cpMin);
      TR.lpstrText:= @S[1];
      Perform(EM_GETTEXTRANGE, 0, Integer(@TR));
    end;
  FWide:= FW;
  S:= AnsiUpperCase(S);
  OC:= OnChange;
  OSC:= OnSelectionChange;
  OnChange:= nil;
  OnSelectionChange:= nil;
  Start:= TR.chrg.cpMin;
  P1:= 1;
  repeat
    P2:= P1;
    repeat
      Inc(P2)
    until not (S[P2] in URLChars);
    Word:= Copy(S, P1, P2-P1);
    I:= 1;
    repeat
      URLType:= FURLs[I];
      URL:= AnsiUpperCase(URLType.Name+':');
      B:= (AnsiPos(URL, Word)=1) and (Length(Word)>Length(URL));
      Inc(I);
    until (I=FURLs.Count) or B;
    if not B then
      begin
        N:= AnsiPos('@', Word);
        B:= (N>1) and (N<Length(Word)) and (AnsiPos('.', Copy(Word, N+1, MaxInt))>1);
        URLType:= FURLs[0];
      end;
    CR.cpMin:= Start+P1-1;
    CR.cpMax:= Start+P2-1;
    Perform(EM_EXSETSEL, 0, Integer(@CR));
    if B then
      begin
        SelAttributes.IsURL:= True;
        if URLType.Color=clWindowText then
          SelAttributes.Color:= URLColor
        else
          SelAttributes.Color:= URLType.Color;
        SelAttributes.UnderlineType:= TUnderlineType(URLType.Underline);
      end
    else
      begin
        SelAttributes.IsURL:= False;
        SelAttributes.Color:= clDefault;
        SelAttributes.UnderlineType:= ultNone;
      end;
    P1:= P2;
    if S[P1]=#0 then
      Break;
    repeat
      Inc(P1);
    until S[P1] in URLChars+[#0];
  until S[P1]  in [#0..' '];

  EndUpdate;
  OnChange:= OC;
  OnSelectionChange:= OSC;
end;

procedure TCustomRichEdit98.EMGetLine(var Message: TMessage);
var
  W: WideString;
  P: PChar;
  L: ^Word;
begin
  if not FWide then begin
      P:= PChar(Message.LParam);
      L:= Pointer(P);
      SetLength(W, L^);
      Message.LParam:= Integer(@W[1]);
      W[1]:= WideChar(L^);
      Message.Result:= PrivatePerform(Message.Msg, Message.WParam, Message.LParam);
      StrPCopy(P, WideToChar(W, FCP));
      Message.LParam:= Integer(P);
    end
  else
    Message.Result:= PrivatePerform(Message.Msg, Message.WParam, Message.LParam);
end;

procedure TCustomRichEdit98.EMStreamIn(var Message: TMessage);
begin
  if FStreamSel then
    Message.WParam:= Message.WParam or SFF_SELECTION;
  inherited;
end;

procedure TCustomRichEdit98.EMStreamOut(var Message: TMessage);
begin
  if FStreamSel then
    Message.WParam:= Message.WParam or SFF_SELECTION;
  inherited;
end;

procedure TCustomRichEdit98.WMSetText(var Message: TWMSetText);
var
  W: WideString;
begin
  if (csDesigning in ComponentState) then
    Message.Text:= nil
  else if not FWide then
    begin
      W:= CharToWide(Message.Text, FCP);
      if W<>'' then
        Message.Text:= @W[1];
    end;
  Message.Result:= PrivatePerform(Message.Msg, Message.Unused, Integer(Message.Text));
end;

procedure TCustomRichEdit98.WMGetTextLength(var Message: TWMGetTextLength);
var
  GTL: TGetTextLengthEx;
begin
  GTL.flags:= GTL_DEFAULT;
  GTL.codepage:= 1200;
  Message.Result:= Perform(EM_GETTEXTLENGTHEX, Integer(@GTL), 0);
end;

procedure TCustomRichEdit98.WMGetText(var Message: TWMGetText);
var
  W: WideString;
  P: PChar;
  L: Integer;
begin
  if FWide then
    begin
      P:= Message.Text;
      L:= Perform(WM_GETTEXTLENGTH, 0, 0);
      SetLength(W, L);
      Message.Text:= @W[1];
      GetWindowTextW(Handle, @W[1], L);
      StrPCopy(P, WideToChar(W, FCP));
      Message.Text:= P;
    end
  else
    inherited;
end;

procedure TCustomRichEdit98.WMSetFont(var Message: TWMSetFont);
begin
  FDefAttributes.Assign(Font);
end;

procedure TCustomRichEdit98.CNCommand(var Message: TWMCommand);
var
  CR, CRMax: TCharRange;
begin
  if not (csLoading in ComponentState) and not (csReading in ComponentState) and
     (AutoURLDetect=adExtended) and (FURLs.Count>0) and (Message.NotifyCode = EN_CHANGE) and
     (FUpdateCount=0) then
    begin
      Perform(EM_EXGETSEL, 0, Integer(@CR));
      CRMax:= CR;
      if FCROld.cpMin<CR.cpMin then
        CRMax.cpMin:= FCROld.cpMin;
      if FCROld.cpMax>CR.cpMax then
        CRMax.cpMax:= FCROld.cpMax;
      DetectURLs(CRMax);
      FCROld:= CR;
    end;
  inherited;
end;

procedure TCustomRichEdit98.CNNotify(var Message: TWMNotify);
type
  PENLink = ^TENLink;
var
  URL: String;
  P: Integer;
  URLType: TURLType;
  I: Integer;
  Cr: TCursor;
begin
  case Message.NMHdr^.code of
  EN_LINK:
    with PENLink(Pointer(Message.NMHdr))^ do
      begin
        URLType := nil;
        FWide:= False;
        URL:= WideText;
        // URL:= Copy(URL, chrg.cpMin + 1, chrg.cpMax - chrg.cpMin {+ 1});
        URL := Copy(WideText, chrg.cpMin + 1, chrg.cpMax - chrg.cpMin { + 1});
        P:= Pos(':', URL);
        if P>1 then
          for I:= 1 to FURLs.Count-1 do
            begin
              URLType:= FURLs[I];
              if URLType.Name=AnsiLowerCase(Copy(URL, 1, P-1)) then
                Break;
            end
        else if Pos('@', URL)>1 then
          URLType:= FURLs[0];
        case msg of
        WM_LBUTTONUP:
          if Assigned(FOnURLClick) and (Length(URL)>1) then
            FOnURLClick(Self, URL);
        WM_MOUSEMOVE:
          begin
            if (URLType <> nil) then begin
                if URLType.Cursor=crDefault then
                  if URLCursor=crDefault then
                    CR:= crHandPoint
                  else
                    CR:= URLCursor
                else
                  Cr:= URLType.Cursor;
                end
            else
                CR := crHandPoint;
                
            Windows.SetCursor(Screen.Cursors[Cr]);
            if Assigned(FOnURLMove) and (Length(URL)>1) then
              FOnURLMove(Self, URL);
          end;
        end;
      end;
  else
    inherited;
  end;
end;

procedure TCustomRichEdit98.SetRichEditStrings(Value: TStrings);
begin
  FRichEditStrings.Assign(Value);
end;

procedure TCustomRichEdit98.SetSelAttributes(Value: TTextAttributes98);
begin
  SelAttributes.Assign(Value);
end;

procedure TCustomRichEdit98.SetDefAttributes(Value: TTextAttributes98);
begin
  DefAttributes.Assign(Value);
end;

function TCustomRichEdit98.GetLine: Integer;
begin
  Result:= Perform(EM_EXLINEFROMCHAR, 0, -1);
end;

procedure TCustomRichEdit98.SetLine(Value: Integer);
begin
  SetCaret(Value, Col);
end;

function TCustomRichEdit98.GetColumn: Integer;
begin
  Result:= SelStart - Perform(EM_LINEINDEX, -1, 0);
end;

procedure TCustomRichEdit98.SetColumn(Value: Integer);
begin
  SetCaret(Line, Value);
end;

procedure TCustomRichEdit98.SetCaret(Line, Column: Integer);
var
  L: Integer;
begin
  L:= Perform(EM_LINEINDEX, Line, 0);
  if L<0 then
    Exit;
  SelStart:= L+Column;
end;

procedure TCustomRichEdit98.SetShowSelBar(Value: Boolean);
var
  Opt: Integer;
begin
  if FShowSelBar<>Value then
    begin
      FShowSelBar:= Value;
      Opt:= Perform(EM_GETOPTIONS, 0, 0);
      if Value then
        Opt:= Opt or ECO_SELECTIONBAR
      else
        Opt:= Opt and not ECO_SELECTIONBAR;
      RecreateWnd;
      Perform(EM_SETOPTIONS, ECOOP_SET, Opt);
    end;
end;

function TCustomRichEdit98.CanUndo: Boolean;
begin
  Result:= Perform(EM_CANUNDO, 0, 0)<>0;
end;

procedure TCustomRichEdit98.Undo;
begin
  Perform(EM_UNDO, 0, 0);
end;

function TCustomRichEdit98.UndoName: TUndoName;
begin
  Result:= TUndoName(Perform(EM_GETUNDONAME, 0, 0));
end;

function TCustomRichEdit98.CanRedo: Boolean;
begin
  Result:= Perform(EM_CANREDO, 0, 0)<>0;
end;

procedure TCustomRichEdit98.Redo;
begin
  Perform(EM_REDO, 0, 0);
end;

function TCustomRichEdit98.RedoName: TUndoName;
begin
  Result:= TUndoName(Perform(EM_GETREDONAME, 0, 0));
end;

procedure TCustomRichEdit98.SetUndoLimit(Value: Integer);
begin
  FUndoLimit:= Value;
  Perform(EM_SETUNDOLIMIT, Value, 0);
end;

procedure TCustomRichEdit98.SetAutoURLDetect(Value: TAutoURLDetect);
begin
  FAutoURLDetect:= Value;
  Perform(EM_AUTOURLDETECT, Ord(Value=adDefault), 0)
end;

function TCustomRichEdit98.GetFirstVisibleLine: Integer;
begin
  Result:= Perform(EM_GETFIRSTVISIBLELINE, 0, 0);
end;

procedure TCustomRichEdit98.SetLanguage(Value: Tlanguage);
begin
  FLanguage:= Value;
  FCP:= CodePageFromLocale(Value);
end;

procedure TCustomRichEdit98.CMFontChanged(var Message: TMessage);
begin
  FDefAttributes.Assign(Font);
end;

function TCustomRichEdit98.GetWordAtPos(Pos: Integer; var Start, Len: Integer): String;
var
  TR: TTextRange;
begin
  Start:= Perform(EM_FINDWORDBREAK, WB_LEFT, Pos);
  Len:= Perform(EM_FINDWORDBREAK, WB_RIGHTBREAK, Pos) - Start;
  TR.chrg.cpMin:= Start;
  TR.chrg.cpMax:= Start+Len;
  TR.lpstrText:= PChar(AllocMem(Len+1));
  Perform(EM_GETTEXTRANGE, 0, LParam(@TR));
  SetString(Result, TR.lpstrText, Len);
  FreeMem(TR.lpstrText);
end;

procedure TCustomRichEdit98.SetCustomURLs(Value: TURLCollection);
var
  I: Integer;
  Item: TURLType;
begin
  FURLS.Clear;
  if Assigned(Value) then
    for I:= 0 to Value.Count-1 do
      begin
        Item:= Value[I];
        with Item do
          FURLs.AddURLType(Name, Color, Cursor, Underline);
      end;
end;

procedure TCustomRichEdit98.DefineProperties(Filer: TFiler);
begin
  Filer.DefineProperty('RTF', ReadData, WriteData, Perform(WM_GETTEXTLENGTH, 0, 0)>0);
end;

procedure TCustomRichEdit98.ReadData(Reader: TReader);
var
  MS: TMemoryStream;
  S: String;
  OSC,
  OC: TNotifyEvent;
begin
  MS := nil;
  OSC := nil;
  OC := nil;
  try
    OSC:= OnSelectionChange;
    OC:= OnChange;
    OnSelectionChange:= nil;
    OnChange:= nil;
    Clear;
    DefAttributes.Assign(Font);
    MS:= TMemoryStream.Create;
    S:= Reader.ReadString;
    MS.Write(S[1], Length(S));
    MS.Position:= 0;
    Lines.LoadFromStream(MS);
  finally
    if (MS <> nil) then
        MS.Free;
    if (Assigned(OSC)) then OnSelectionChange:= OSC;
    if (Assigned(OC)) then OnChange:= OC;
  end;
end;

procedure TCustomRichEdit98.WriteData(Writer: TWriter);
var
  MS: TMemoryStream;
  C: Char;
begin
  if Perform(WM_GETTEXTLENGTH, 0, 0)=0 then
    Exit;
  MS:= TMemoryStream.Create;
  Lines.SaveToStream(MS);
  C:= #0;
  MS.Write(C, 1);
  Writer.WriteString(PChar(MS.Memory));
  MS.Free;
end;

procedure TCustomRichEdit98.SetWideText(Value: WideString);
begin
  FWide:= True;
//  SetWindowTextW(Handle, @Value[1]);
  SendMessage(Handle, WM_SETTEXT, 0, Integer(@Value[1]));
  FWide:= False;
end;

function TCustomRichEdit98.GetWideText: WideString;
var
  GTL: TGetTextLengthEx;
  GT: TGetTextEx;
  L: Integer;
begin
  GTL.flags:= GTL_DEFAULT;
  GTL.codepage:= 1200;
  L:= Perform(EM_GETTEXTLENGTHEX, Integer(@GTL), 0);
  SetLength(Result, L);
  GT.cb:= L*2+2;
  GT.flags:= GT_DEFAULT;
  GT.codepage:= 1200;
  GT.lpDefaultChar:= nil;
  GT.lpUsedDefChar:= nil;
  PrivatePerform(EM_GETTEXTEX, Integer(@GT), Integer(@Result[1]));
end;

procedure TCustomRichEdit98.SetRTFSelText(Value: String);
var
  MS: TMemoryStream;
  OldFormat: TInputFormat;
begin
  MS:= TMemoryStream.Create;
  MS.Write(Value[1], Length(Value)+1);
  MS.Position:= 0;
  FStreamSel:= True;
  OldFormat:= InputFormat;
  InputFormat:= ifRTF;
  Lines.LoadFromStream(MS);
  InputFormat:= OldFormat;
  FStreamSel:= False;
  MS.Free;
end;

function TCustomRichEdit98.GetRTFSelText: String;
var
  MS: TMemoryStream;
  OldFormat: TOutputFormat;
begin
  MS:= TMemoryStream.Create;
  FStreamSel:= True;
  OldFormat:= OutputFormat;
  OutputFormat:= ofRTF;
  Lines.SaveToStream(MS);
  OutputFormat:= OldFormat;
  FStreamSel:= False;
  Result:= PChar(MS.Memory);
  MS.Free;
end;

procedure TCustomRichEdit98.InsertFromFile(const FileName: String);
begin
  FStreamSel:= True;
  Lines.LoadFromFile(FileName);
  FStreamSel:= False;
end;

function TCustomRichEdit98.GetWideSelText: WideString;
var
  Length: Integer;
begin
  FWide:= True;
  SetLength(Result, SelLength + 1);
  Length := Perform(EM_GETSELTEXT, 0, Longint(@Result[1]));
  SetLength(Result, Length);
  FWide:= False;
end;

procedure TCustomRichEdit98.SetWideSelText(Value: WideString);
begin
  FWide:= True;

  // pgm 5/8/02 - Fix range-check error for empty strings.
  if (Length(Value) = 0) then exit;

  Perform(EM_REPLACESEL, 1, Integer(@Value[1]));
  FWide:= False;
end;

function TCustomRichEdit98.FindText(const SearchStr: string;
  StartPos, Length: Integer; Options: TSearchTypes98): Integer;
var
  Find: TFindTextExW;
  Flags: Integer;
  W: WideString;
begin
  with Find.chrg do
  begin
    cpMin := StartPos;
    if Length>0 then
      if stBackward in Options then
        cpMax:= cpMin - Length
      else
        cpMax := cpMin + Length
    else
      cpMax:= -1;
  end;
  Flags := FT_DOWNWARD;
  if stBackward in Options then Flags := Flags and not FT_DOWNWARD;
  if stWholeWord in Options then Flags := Flags or FT_WHOLEWORD;
  if stMatchCase in Options then Flags := Flags or FT_MATCHCASE;
  W:= CharToWide(SearchStr, FCP);
  Find.lpstrText := @W[1];
  Result := SendMessage(Handle, EM_FINDTEXTEX, Flags, LongInt(@Find));
end;

function TCustomRichEdit98.FindWideText(const SearchStr: WideString;
  StartPos, Length: Integer; Options: TSearchTypes98): Integer;
var
  Find: TFindTextExW;
  Flags: Integer;
begin
  with Find.chrg do
  begin
    cpMin := StartPos;
    if Length>0 then
      if stBackward in Options then
        cpMax:= cpMin - Length
      else
        cpMax := cpMin + Length
    else
      cpMax:= -1;
  end;
  Flags := FT_DOWNWARD;
  if stBackward in Options then Flags := Flags and not FT_DOWNWARD;
  if stWholeWord in Options then Flags := Flags or FT_WHOLEWORD;
  if stMatchCase in Options then Flags := Flags or FT_MATCHCASE;
  Find.lpstrText := @SearchStr[1];
  Result := SendMessage(Handle, EM_FINDTEXTEX, Flags, LongInt(@Find));
end;

procedure TCustomRichEdit98.SetLangOptions(Value: TLangOptions);
var
  LO: Byte;
begin
  FLangOptions:= Value;
  Lo:= Byte(Value);
  Perform(EM_SETLANGOPTIONS, 0, LO);
end;

function TCustomRichEdit98.PrivatePerform(Msg: Cardinal; WParam, LParam: Longint): Longint;
begin
  Result := 0;
  if HandleAllocated then
    if IsWinNT {and FWide }then
      Result:= CallWindowProcW(FDefWndProcW, Handle, Msg, Wparam, Lparam)
    else
      Result:= CallWindowProcA(FDefWndProcA, Handle, Msg, Wparam, Lparam)
end;

procedure TCustomRichEdit98.BeginUpdate;
begin
  Inc(FUpdateCount);
  Perform(WM_SETREDRAW, 0, 0);
  FStoreSS:= SelStart;
  FStoreSL:= SelLength;
  FStoreFVL:= FirstVisibleLine;
end;

procedure TCustomRichEdit98.EndUpdate;
begin
  if FUpdateCount>0 then
    Dec(FUpdateCount);
  if FUpdateCount=0 then
    begin
      SelStart:= FStoreSS;
      SelLength:= FStoreSL;
      while FirstVisibleLine<>FStoreFVL do
        if FirstVisibleLine<FStoreFVL then
          Perform(EM_SCROLL, SB_LINEDOWN, 0)
        else
          Perform(EM_SCROLL, SB_LINEUP, 0);
      Perform(WM_SETREDRAW, 1, 0);
      Repaint;
    end;
end;

procedure TCustomRichEdit98.WMPaint(var Message: TWMPaint);
begin
  if FUpdateCount=0 then
    inherited
  else
    Message.Result:= 0;
end;

function TCustomRichEdit98.CharAtPos(Pos: TPoint): Integer;
begin
  Result:= Perform(EM_CHARFROMPOS, 0, Integer(@Pos));
end;

procedure TCustomRichEdit98.SetIncludeOLE(Value:Boolean);
begin
 FIncludeOLE := Value;
 if Value then CreateOLEObjectInterface;
 ReCreateWnd;
end;

{$WARNINGS OFF}
function TCustomRichEdit98.GetPopupMenu: TPopupMenu;
var
  I: Integer;
  Item: TMenuItem;
  ReObject: TReObject;
begin
  Result := inherited GetPopupMenu;
  if FAutoVerbMenu and Assigned(RichEditOle) then begin
    ReObject.cbStruct:= sizeof(TReObject);
    {if an object is selected, get its IOLEObject interface}
    if (RichEditOle.GetObject(REO_IOB_SELECTION, ReObject, REO_GETOBJ_POLEOBJ) <> S_OK) or
          not Assigned(ReObject.oleobj) then begin
      {no object selected -- clean up any previous object info}
      FSelObject:= nil;
      DestroyVerbs;
    end
    else
      if FSelObject = ReObject.oleobj then
        {same object selected -- use already allocated menu}
        Result:= FPopupVerbMenu
//        if Result=nil then begin
      else begin
        {new object selected -- create a menu for it}
        FSelObject:= ReObject.oleobj;
        UpdateVerbs;
        if FObjectVerbs.Count = 0 then
          Result:= nil
        else begin
          FPopupVerbMenu:= TPopupMenu.Create(Self);
          for I := 0 to FObjectVerbs.Count - 1 do begin
            Item := TMenuItem.Create(Self);
            Item.Caption := FObjectVerbs[I];
            Item.Tag := I;
            if TVerbInfo(FObjectVerbs.Objects[i]).Verb = 0 then
              Item.Default:= true;              // Verb = 0 is the primary verb
            Item.OnClick := PopupVerbMenuClick;
            FPopupVerbMenu.Items.Add(Item);
          end;
          Result := FPopupVerbMenu;
        end;
      end;
  end;
end;
{$WARNINGS ON}

procedure TCustomRichEdit98.DestroyVerbs;
begin
  FPopupVerbMenu.Free;
  FPopupVerbMenu := nil;
  FObjectVerbs.Free;
  FObjectVerbs := nil;
end;

procedure TCustomRichEdit98.UpdateVerbs;
var
  EnumOleVerb: IEnumOleVerb;
  OleVerb: TOleVerb;
  VerbInfo: TVerbInfo;
begin
  DestroyVerbs;
  FObjectVerbs := TStringList.Create;
  if FSelObject.EnumVerbs(EnumOleVerb) = 0 then
  begin
    while (EnumOleVerb.Next(1, OleVerb, nil) = 0) and
      (OleVerb.lVerb >= 0) and
      (OleVerb.grfAttribs and OLEVERBATTRIB_ONCONTAINERMENU <> 0) do
    begin
      VerbInfo.Verb := OleVerb.lVerb;
      VerbInfo.Flags := OleVerb.fuFlags;
      FObjectVerbs.AddObject(OleVerb.lpszVerbName, TObject(VerbInfo));
    end;
  end;
end;

procedure TCustomRichEdit98.PopupVerbMenuClick(Sender: TObject);
begin
  DoVerb((Sender as TMenuItem).Tag);
end;

procedure TCustomRichEdit98.DoVerb(Verb: Integer);
var
  H: THandle;
  R: TRect;
  ClientSite: IOleClientSite;
  PT:Integer;
begin
  if not Assigned(RichEditOle) or not Assigned(FSelObject) then Exit;
  pt := 0;
  if Verb > 0 then begin
    if FObjectVerbs = nil then UpdateVerbs;
    if Verb >= FObjectVerbs.Count then
      raise EOleError.Create('Invalid Verb');
    Verb := Smallint(Integer(FObjectVerbs.Objects[Verb]) and $0000FFFF);
  end else
    if Verb = ovPrimary then Verb := 0;
  H := Handle;
//  PT:=Point(AX,AY);
  SendMessage(H,EM_POSFROMCHAR,pt,0)  ;
R:=BoundsRect;
//  R := ClientRect;

  OleCheck(RichEditOle.GetClientSite(ClientSite));
  OleCheck(FSelObject.DoVerb(Verb, nil, ClientSite, 0, H, R));
end;

procedure TCustomRichEdit98.InsertObjectDialog;
var
   Data: TOleUIInsertObject;
   NameBuffer: array[0..255] of Char;
   CreateInfo: TCreateInfo;
begin
     FillChar(Data, SizeOf(Data), 0);
     FillChar(NameBuffer, SizeOf(NameBuffer), 0);
     Data.cbStruct := SizeOf(Data);
     Data.dwFlags := IOF_SELECTCREATENEW;
     Data.hWndOwner := Application.Handle;
     Data.lpfnHook := OleDialogHook;
     Data.lpszFile := NameBuffer;
     Data.cchFile := SizeOf(NameBuffer);
     try
        if OleUIInsertObject(Data) = OLEUI_OK then begin
           if Data.dwFlags and IOF_SELECTCREATENEW <> 0 then begin
              CreateInfo.CreateType := ctNewObject;
              CreateInfo.ClassID := Data.clsid;
           end
           else
           begin
               if Data.dwFlags and IOF_CHECKLINK = 0 then
               CreateInfo.CreateType := ctFromFile
               else
               CreateInfo.CreateType := ctLinkToFile;
               CreateInfo.FileName := NameBuffer;
               end;
           CreateInfo.ShowAsIcon := Data.dwFlags and IOF_CHECKDISPLAYASICON <> 0;
           CreateInfo.IconMetaPict := Data.hMetaPict;
           CreateObjectFromInfo(CreateInfo);
      if CreateInfo.CreateType = ctNewObject then
//      begin
      DoVerb(OvOpen);
//      end
//      else
//      DoVerb(OVOpen);
           end;
  finally
    DestroyMetaPict(Data.hMetaPict);
  end;
end;

procedure TCustomRichEdit98.CreateObjectFromInfo(const CreateInfo:TCreateInfo);
var
   Storage:IStorage;
   OleObject:IOleObject;
   OleSite:IOleClientSite;
   ReObject:TReObject;
   Data: TOleUIChangeIcon;
begin
     try
        RichEditOle.GetClientSite(OleSite);
        RichEditOleCallback.GetNewStorage(Storage);
        with CreateInfo do begin
             case CreateType of
                  ctNewObject:
                              OleCheck(OleCreate(ClassID, IOleObject, OLERENDER_DRAW, nil,
                              OleSite, Storage, OleObject));
                  ctFromFile:
                             OleCheck(OleCreateFromFile(GUID_NULL, PWideChar(FileName), IOleObject,
                             OLERENDER_DRAW, nil, OleSite, Storage, OleObject));
                  ctLinkToFile:
                               OleCheck(OleCreateLinkToFile(PWideChar(FileName), IOleObject,
                               OLERENDER_DRAW, nil, OleSite, Storage, OleObject));
                  ctFromData:
                             OleCheck(OleCreateFromData(DataObject, IOleObject,
                             OLERENDER_DRAW, nil, OleSite, Storage, OleObject));
                  ctLinkFromData:
                                 OleCheck(OleCreateLinkFromData(DataObject, IOleObject,
                                 OLERENDER_DRAW, nil, OleSite, Storage, OleObject));
                  end;
             FillChar(ReObject, SizeOf(TReObject), 0);
             ReObject.cbStruct:=SizeOf(TReObject);
             ReObject.cp:=SelStart;
             ReObject.oleobj:=OleObject;
             ReObject.clsid:=Data.clsid;
             ReObject.stg:=Storage;
             ReObject.olesite:=OleSite;
             ReObject.sizel.cx:=0;
             ReObject.sizel.cy:=0;
             ReObject.dwUser:=0;
             FSelObject:= OleObject;
             ReObject.dwFlags:={REO_BELOWBASELINE or} REO_DYNAMICSIZE or REO_RESIZABLE;
             if CreateInfo.ShowAsIcon then
             Begin
              ReObject.dvaspect:=DVASPECT_ICON;
              FDrawAspect:=DVASPECT_ICON;
              SetDrawaspect(True,ICONMETAPICT);
             end
             else
             begin
             FDrawaspect:=DVASPECT_CONTENT;
             ReObject.dvaspect:=DVASPECT_CONTENT;
             end;
      If CreateInfo.CreateType=ctNewObject then
             ReObject.dwFlags:= ReObject.dwFlags or REO_BLANK;
         RicheditOle.SetHostNames(PWideChar(WideString(Application.Title)),
                          PWideChar(WideString(Caption)));
            Olecheck(RichEditOle.InsertObject(ReObject));
            end;
     except
           raise;
     end;

end;

procedure TCustomRichedit98.SetDrawAspect(Iconic: Boolean;
  IconMetaPict: HGlobal);
var
  OleCache: IOleCache;
  EnumStatData: IEnumStatData;
  OldAspect, AdviseFlags, Connection: Longint;
  TempMetaPict: HGlobal;
  FormatEtc: TFormatEtc;
  Medium: TStgMedium;
  ClassID: TCLSID;
  StatData: TStatData;

begin
  OldAspect := FDrawAspect;
  if Iconic then
  begin
    FDrawAspect := DVASPECT_ICON;
    AdviseFlags := ADVF_NODATA;
  end else
  begin
    FDrawAspect := DVASPECT_CONTENT;
    AdviseFlags := ADVF_PRIMEFIRST;
  end;
  if (FDrawAspect <> OldAspect) or (FDrawAspect = DVASPECT_ICON) then
  begin
    OleCache := FSelObject as IOleCache;
    if FDrawAspect <> OldAspect then
    begin
      OleCheck(OleCache.EnumCache(EnumStatData));
      if EnumStatData <> nil then
        while EnumStatData.Next(1, StatData, nil) = 0 do
          if StatData.formatetc.dwAspect = OldAspect then
            OleCache.Uncache(StatData.dwConnection);
      FillChar(FormatEtc, SizeOf(FormatEtc), 0);
      FormatEtc.dwAspect := FDrawAspect;
      FormatEtc.lIndex := -1;
      OleCheck(OleCache.Cache(FormatEtc, AdviseFlags, Connection));
    end;
    if FDrawAspect = DVASPECT_ICON then
    begin
      TempMetaPict := 0;
      if IconMetaPict = 0 then
      begin
        OleCheck(FSelObject.GetUserClassID(ClassID));
        TempMetaPict := OleGetIconOfClass(ClassID, nil, True);
        IconMetaPict := TempMetaPict;
      end;
      try
        FormatEtc.cfFormat := CF_METAFILEPICT;
        FormatEtc.ptd := nil;
        FormatEtc.dwAspect := DVASPECT_ICON;
        FormatEtc.lIndex := -1;
        FormatEtc.tymed := TYMED_MFPICT;
        Medium.tymed := TYMED_MFPICT;
        Medium.hMetaFilePict := IconMetaPict;
        Medium.unkForRelease := nil;
        OleCheck(OleCache.Cache(FormatEtc, AdviseFlags, Connection));
        OLECheck(OleCache.SetData(FormatEtc, Medium, False));
      finally
        DestroyMetaPict(TempMetaPict);
      end;
    end;
    if FDrawAspect = DVASPECT_CONTENT then UpdateObject;
    UpdateView;
    end;
end;

function TCustomRichEdit98.PasteSpecialDialog: Boolean;
const
  PasteFormatCount = 2;
var
  Data: TOleUIPasteSpecial;
  PasteFormats: array[0..PasteFormatCount - 1] of TOleUIPasteEntry;
  CreateInfo: TCreateInfo;
begin
  Result := False;
  if not CanPaste then Exit;
  FillChar(Data, SizeOf(Data), 0);
  FillChar(PasteFormats, SizeOf(PasteFormats), 0);
  Data.cbStruct := SizeOf(Data);
  Data.hWndOwner := Application.Handle;
  Data.lpfnHook := OleDialogHook;
  Data.arrPasteEntries := @PasteFormats;
  Data.cPasteEntries := PasteFormatCount;
  Data.arrLinkTypes := @CFLinkSource;
  Data.cLinkTypes := 1;
  PasteFormats[0].fmtetc.cfFormat := CFEmbeddedObject;
  PasteFormats[0].fmtetc.dwAspect := DVASPECT_CONTENT;
  PasteFormats[0].fmtetc.lIndex := -1;
  PasteFormats[0].fmtetc.tymed := TYMED_ISTORAGE;
  PasteFormats[0].lpstrFormatName := '%s';
  PasteFormats[0].lpstrResultText := '%s';
  PasteFormats[0].dwFlags := OLEUIPASTE_PASTE or OLEUIPASTE_ENABLEICON;
  PasteFormats[1].fmtetc.cfFormat := CFLinkSource;
  PasteFormats[1].fmtetc.dwAspect := DVASPECT_CONTENT;
  PasteFormats[1].fmtetc.lIndex := -1;
  PasteFormats[1].fmtetc.tymed := TYMED_ISTREAM;
  PasteFormats[1].lpstrFormatName := '%s';
  PasteFormats[1].lpstrResultText := '%s';
  PasteFormats[1].dwFlags := OLEUIPASTE_LINKTYPE1 or OLEUIPASTE_ENABLEICON;
  try
    if OleUIPasteSpecial(Data) = OLEUI_OK then
    begin
      if Data.fLink then
        CreateInfo.CreateType := ctLinkFromData else
        CreateInfo.CreateType := ctFromData;
        CreateInfo.ShowAsIcon := Data.dwFlags and PSF_CHECKDISPLAYASICON <> 0;
        CreateInfo.IconMetaPict := Data.hMetaPict;
        CreateInfo.DataObject := Data.lpSrcDataObj;
        CreateObjectFromInfo(CreateInfo);
      Result := True;
    end;
  finally
    DestroyMetaPict(Data.hMetaPict);
  end;
end;

function TCustomRichedit98.GetCanPaste: Boolean;
var
  DataObject: IDataObject;
begin
  Result := (OleGetClipboard(DataObject) >= 0) and
    ((OleQueryCreateFromData(DataObject) = 0) or
     (OleQueryLinkFromData(DataObject) = 0));
end;

procedure TCustomRichEdit98.UpdateObject;
begin
  if FSelObject <> nil then
  begin
    OleCheck(FSelObject.Update);
    Changed;
  end;
end;

procedure TCustomRichEdit98.UpdateView;
var
  ViewObject2: IViewObject2;
begin
  if FSelObject.QueryInterface(IViewObject2, ViewObject2) >= 0 then
  begin
    ViewObject2.GetExtent(FDrawAspect, - 1, nil, FViewSize);
    //    AdjustBounds;
  end;
  Invalidate;
  Changed;
end;

function TCustomRichedit98.ChangeIconDialog: Boolean;
var
  Data: TOleUIChangeIcon;
begin
  CheckObject;
  Result := False;
  FillChar(Data, SizeOf(Data), 0);
  Data.cbStruct := SizeOf(Data);
  Data.dwFlags := CIF_SELECTCURRENT;
  Data.hWndOwner := Application.Handle;
  Data.lpfnHook := OleDialogHook;
  OleCheck(FSelObject.GetUserClassID(Data.clsid));
  Data.hMetaPict := GetIconMetaPict;
  try
    if OleUIChangeIcon(Data) = OLEUI_OK then
    begin
      SetDrawAspect(True, Data.hMetaPict);
      Result := True;
    end;
  finally
    DestroyMetaPict(Data.hMetaPict);
  end;
end;

function TCustomRichEdit98.GetIconMetaPict: HGlobal;
var
  DataObject: IDataObject;
  FormatEtc: TFormatEtc;
  Medium: TStgMedium;
  ClassID: TCLSID;
begin
  CheckObject;
  Result := 0;
  if FDrawAspect = DVASPECT_ICON then
  begin
    FSelObject.QueryInterface(IDataObject, DataObject);
    if DataObject <> nil then
    begin
      FormatEtc.cfFormat := CF_METAFILEPICT;
      FormatEtc.ptd := nil;
      FormatEtc.dwAspect := DVASPECT_ICON;
      FormatEtc.lIndex := -1;
      FormatEtc.tymed := TYMED_MFPICT;
      if DataObject.GetData(FormatEtc, Medium) >= 0 then
        Result := Medium.hMetaFilePict;
    end;
  end;
  if Result = 0 then
  begin
    OleCheck(FSelObject.GetUserClassID(ClassID));
    Result := OleGetIconOfClass(ClassID, nil, True);
  end;
end;

procedure TCustomRichedit98.CheckObject;
begin
  if FSelObject = nil then
    raise EOleError.Create('EmptyDocument');
end;

procedure TCustomRichEdit98.CreateLinkToFile(const FileName: string;
                                             Iconic: Boolean);
var
  CreateInfo: TCreateInfo;
begin
  CreateInfo.CreateType := ctLinkToFile;
  CreateInfo.ShowAsIcon := Iconic;
  CreateInfo.IconMetaPict := 0;
  CreateInfo.FileName := FileName;
  CreateObjectFromInfo(CreateInfo);
end;

procedure TCustomRichEdit98.CreateObject(const OleClassName: string;
  Iconic: Boolean);
var
  CreateInfo: TCreateInfo;
begin
  CreateInfo.CreateType := ctNewObject;
  CreateInfo.ShowAsIcon := Iconic;
  CreateInfo.IconMetaPict := 0;
  CreateInfo.ClassID := ProgIDToClassID(OleClassName);
  CreateObjectFromInfo(CreateInfo);
end;

procedure TCustomRichEdit98.CreateObjectFromFile(const FileName: string;
  Iconic: Boolean);
var
  CreateInfo: TCreateInfo;
begin
  CreateInfo.CreateType := ctFromFile;
  CreateInfo.ShowAsIcon := Iconic;
  CreateInfo.IconMetaPict := 0;
  CreateInfo.FileName := FileName;
  CreateObjectFromInfo(CreateInfo);
end;

procedure TCustomRichEdit98.StopGroupTyping;
begin
  Perform(EM_STOPGROUPTYPING, 0, 0);
end;

function TCustomRichEdit98.GetSelType: TSelectionType;
var
  B: Byte;
begin
  B:= Perform(EM_SELECTIONTYPE, 0, 0);
  Result:= TSelectionType(B);
end;

procedure TCustomRichEdit98.DoSetMaxLength(Value: Integer);
begin
  if Value=0 then
    Value:= MAXLONG;
  SendMessage(Handle, EM_EXLIMITTEXT, 0, Value);
end;

{ TDBRichEdit98 }
{$ifdef BDE_SUPPORT}
constructor TDBRichEdit98.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  inherited ReadOnly := True;
  FAutoDisplay := True;
  FDataLink := TFieldDataLink.Create;
  FDataLink.Control := Self;
  FDataLink.OnDataChange := DataChange;
  FDataLink.OnEditingChange := EditingChange;
  FDataLink.OnUpdateData := UpdateData;
end;

destructor TDBRichEdit98.Destroy;
begin
  FDataLink.Free;
  FDataLink := nil;
  inherited Destroy;
end;

procedure TDBRichEdit98.Loaded;
begin
  inherited Loaded;
  if (csDesigning in ComponentState) then DataChange(Self);
end;

procedure TDBRichEdit98.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (FDataLink <> nil) and
    (AComponent = DataSource) then DataSource := nil;
end;

procedure TDBRichEdit98.BeginEditing;
begin
  if not FDataLink.Editing then
  try
    if FDataLink.Field.IsBlob then
      FDataSave := FDataLink.Field.AsString;
    FDataLink.Edit;
  finally
    FDataSave := '';
  end;
end;

procedure TDBRichEdit98.KeyDown(var Key: Word; Shift: TShiftState);
begin
  inherited KeyDown(Key, Shift);
  if FMemoLoaded then
  begin
    if (Key = VK_DELETE) or (Key = VK_BACK) or
      ((Key = VK_INSERT) and (ssShift in Shift)) or
      (((Key = Ord('V')) or (Key = Ord('X'))) and (ssCtrl in Shift)) then
      BeginEditing;
  end;
end;

procedure TDBRichEdit98.KeyPress(var Key: Char);
begin
  inherited KeyPress(Key);
  if FMemoLoaded then
  begin
    if (Key in [#32..#255]) and (FDataLink.Field <> nil) and
      not FDataLink.Field.IsValidChar(Key) then
    begin
      MessageBeep(0);
      Key := #0;
    end;
    case Key of
      ^H, ^I, ^J, ^M, ^V, ^X, #32..#255:
        BeginEditing;
      #27:
        FDataLink.Reset;
    end;
  end else
  begin
    if Key = #13 then LoadMemo;
    Key := #0;
  end;
end;

procedure TDBRichEdit98.Change;
begin
  if FMemoLoaded then FDataLink.Modified;
  FMemoLoaded := True;
  inherited Change;
end;

function TDBRichEdit98.GetDataSource: TDataSource;
begin
  Result := FDataLink.DataSource;
end;

procedure TDBRichEdit98.SetDataSource(Value: TDataSource);
begin
  FDataLink.DataSource := Value;
  if Value <> nil then Value.FreeNotification(Self);
end;

function TDBRichEdit98.GetDataField: string;
begin
  Result := FDataLink.FieldName;
end;

procedure TDBRichEdit98.SetDataField(const Value: string);
begin
  FDataLink.FieldName := Value;
end;

function TDBRichEdit98.GetReadOnly: Boolean;
begin
  Result := FDataLink.ReadOnly;
end;

procedure TDBRichEdit98.SetReadOnly(Value: Boolean);
begin
  FDataLink.ReadOnly := Value;
end;

function TDBRichEdit98.GetField: TField;
begin
  Result := FDataLink.Field;
end;

procedure TDBRichEdit98.LoadMemo;
begin
  if not FMemoLoaded and Assigned(FDataLink.Field) and FDataLink.Field.IsBlob then
  begin
    try
      Lines.Assign(FDataLink.Field);
      FMemoLoaded := True;
    except
      { Rich Edit Load failure }
      on E:EOutOfResources do
        Lines.Text := Format('(%s)', [E.Message]);
    end;
    EditingChange(Self);
  end;
end;

procedure TDBRichEdit98.DataChange(Sender: TObject);
begin
  if FDataLink.Field <> nil then
    if FDataLink.Field.IsBlob then
    begin
      if FAutoDisplay or (FDataLink.Editing and FMemoLoaded) then
      begin
        { Check if the data has changed since we read it the first time }
        if (FDataSave <> '') and (FDataSave = FDataLink.Field.AsString) then Exit;
        FMemoLoaded := False;
        LoadMemo;
      end else
      begin
        Text := Format('(%s)', [FDataLink.Field.DisplayLabel]);
        FMemoLoaded := False;
      end;
    end else
    begin
      if FFocused and FDataLink.CanModify then
        Text := FDataLink.Field.Text
      else
        Text := FDataLink.Field.DisplayText;
      FMemoLoaded := True;
    end
  else
  begin
    if csDesigning in ComponentState then Text := Name else Text := '';
    FMemoLoaded := False;
  end;
  if HandleAllocated then
    RedrawWindow(Handle, nil, 0, RDW_INVALIDATE or RDW_ERASE or RDW_FRAME);
end;

procedure TDBRichEdit98.EditingChange(Sender: TObject);
begin
  inherited ReadOnly := not (FDataLink.Editing and FMemoLoaded);
end;

procedure TDBRichEdit98.UpdateData(Sender: TObject);
begin
  if FDataLink.Field.IsBlob then
    FDataLink.Field.Assign(Lines) else
    FDataLink.Field.AsString := Text;
end;

procedure TDBRichEdit98.SetFocused(Value: Boolean);
begin
  if FFocused <> Value then
  begin
    FFocused := Value;
    if not Assigned(FDataLink.Field) or not FDataLink.Field.IsBlob then
      FDataLink.Reset;
  end;
end;

procedure TDBRichEdit98.CMEnter(var Message: TCMEnter);
begin
  SetFocused(True);
  inherited;
  if SysLocale.FarEast and FDataLink.CanModify then
    inherited ReadOnly := False;
end;

procedure TDBRichEdit98.CMExit(var Message: TCMExit);
begin
  try
    FDataLink.UpdateRecord;
  except
    SetFocus;
    raise;
  end;
  SetFocused(False);
  inherited;
end;

procedure TDBRichEdit98.SetAutoDisplay(Value: Boolean);
begin
  if FAutoDisplay <> Value then
  begin
    FAutoDisplay := Value;
    if Value then LoadMemo;
  end;
end;

procedure TDBRichEdit98.WMLButtonDblClk(var Message: TWMLButtonDblClk);
begin
  if not FMemoLoaded then LoadMemo else inherited;
end;

procedure TDBRichEdit98.WMCut(var Message: TMessage);
begin
  BeginEditing;
  inherited;
end;

procedure TDBRichEdit98.WMPaste(var Message: TMessage);
begin
  BeginEditing;
  inherited;
end;

procedure TDBRichEdit98.CMGetDataLink(var Message: TMessage);
begin
  Message.Result := Integer(FDataLink);
end;

procedure TDBRichEdit98.DefineProperties(Filer: TFiler);
begin
end;
{$endif}




constructor TRichEditOleCallback.Create(AOwner: TCustomRichEdit98);
begin
  inherited Create;
  FOwner:= AOwner;
end;

function TRichEditOleCallback.GetNewStorage(out stg: IStorage): HRESULT;
var LockBytes: ILockBytes;
begin
  Result:= S_OK;
  try
    OleCheck(CreateILockBytesOnHGlobal(0, True, LockBytes));
    OleCheck(StgCreateDocfileOnILockBytes(LockBytes, STGM_READWRITE
      or STGM_SHARE_EXCLUSIVE or STGM_CREATE, 0, stg));
  except
    Result:= E_OUTOFMEMORY;
  end;
end;

function TRichEditOleCallback.GetInPlaceContext(out Frame: IOleInPlaceFrame;
       out Doc: IOleInPlaceUIWindow; var FrameInfo: TOleInPlaceFrameInfo): HRESULT;
begin
//  Result:= E_NOTIMPL;
//  exit;
 Doc:=nil;
 Frame := GetVCLFrameForm(ValidParentForm(FOwner));
 Frame._AddRef;
  with frameInfo do
  begin
    fMDIApp := False;
    Frame.GetWindow(hWndFrame);
    hAccel := 0;
    cAccelEntries := 0;
   end;
  Result := S_OK;
end;

function TRichEditOleCallback.ShowContainerUI(fShow: BOOL): HRESULT;
begin
// Result:=S_OK;
  Result:= E_NOTIMPL;
end;

function TRichEditOleCallback.GetClipboardData(const chrg: TCharRange; reco: DWORD;
         out dataobj: IDataObject): HRESULT;
begin
  Result:= E_NOTIMPL;
end;

function TRichEditOleCallback.ContextSensitiveHelp(fEnterMode: BOOL): HRESULT;
begin
  Result:= E_NOTIMPL;
end;

function TRichEditOleCallback.QueryInsertObject(const clsid: TCLSID; stg: IStorage;
       cp: longint): HRESULT;
begin
  Result:= S_OK;
end;

function TRichEditOleCallback.DeleteObject(oleobj: IOLEObject): HRESULT;
begin
  FOwner.FSelObject:= nil;
  oleobj.Close(OLECLOSE_NOSAVE);
  Result:= S_OK;
end;

function TRichEditOleCallback.QueryAcceptData(dataobj: IDataObject; var cfFormat: TClipFormat;
         reco: DWORD; fReally: BOOL; hMetaPict: HGLOBAL): HRESULT;
begin
  Result:= S_OK;
end;

function TRichEditOleCallback.GetDragDropEffect(fDrag: BOOL; grfKeyState: DWORD;
         var dwEffect: DWORD): HRESULT;
const MK_ALT = $20;
var Effect: DWORD;
begin
  Result:= S_OK;
	if not fDrag then begin // allowable dest effects
		// check for force link
		if ((grfKeyState and (MK_CONTROL or MK_SHIFT)) = (MK_CONTROL or MK_SHIFT)) then
			Effect := DROPEFFECT_LINK
		// check for force copy
		else if ((grfKeyState and MK_CONTROL) = MK_CONTROL) then
			Effect := DROPEFFECT_COPY
		// check for force move
		else if ((grfKeyState and MK_ALT) = MK_ALT) then
			Effect := DROPEFFECT_MOVE
		// default -- recommended action is move
		else
			Effect := DROPEFFECT_MOVE;
		if (Effect and dwEffect <> 0) then // make sure allowed type
			dwEffect := Effect;
  end;
end;

function TRichEditOleCallback.GetContextMenu(seltype: Word; oleobj: IOleObject;
         const chrg: TCharRange; var menu: HMENU): HRESULT;
begin
  menu:=0;
  Result:= S_OK;
end;

var
  OSVI: TOSVersionInfo;

initialization
  OSVI.dwOSVersionInfoSize:= SizeOf(OSVI);
  GetVersionEx(OSVI);
  IsWinNT:= OSVI.dwPlatformId=VER_PLATFORM_WIN32_NT;
  CF_RTF:= RegisterClipboardFormat(RichEdit.CF_RTF);
  CF_RTFNOOBJS:= RegisterClipboardFormat(RichEdit.CF_RTFNOOBJS);
  CF_RETEXTOBJ:= RegisterClipboardFormat(RichEdit.CF_RETEXTOBJ);

end.
