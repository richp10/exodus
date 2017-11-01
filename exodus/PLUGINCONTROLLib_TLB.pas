unit PLUGINCONTROLLib_TLB;

{$TYPEDADDRESS OFF} // Unit must be compiled without type-checked pointers. 
{$WARN SYMBOL_PLATFORM OFF}
{$WRITEABLECONST ON}
{$VARPROPSETTER ON}
interface

uses Windows, ActiveX, Classes, Graphics, OleCtrls, OleServer, StdVCL, Variants;

// *********************************************************************//
// GUIDS declared in the TypeLibrary. Following prefixes are used:        
//   Type Libraries     : LIBID_xxxx                                      
//   CoClasses          : CLASS_xxxx                                      
//   DISPInterfaces     : DIID_xxxx                                       
//   Non-DISP interfaces: IID_xxxx                                        
// *********************************************************************//
const
  // TypeLibrary Major and minor versions
  PLUGINCONTROLLibMajorVersion = 1;
  PLUGINCONTROLLibMinorVersion = 0;

  LIBID_PLUGINCONTROLLib: TGUID = '{D11520D5-FB89-4274-903C-33C011EA81F3}';

  IID_IAXControl: TGUID = '{F476FEEF-2622-4BB2-BA35-1DDE736F469D}';
  CLASS_AXControl: TGUID = '{524459CD-5F81-4825-96E8-2EA2573B9A14}';
type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  IAXControl = interface;
  IAXControlDisp = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  AXControl = IAXControl;

// *********************************************************************//
// Interface: IAXControl
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {F476FEEF-2622-4BB2-BA35-1DDE736F469D}
// *********************************************************************//
  IAXControl = interface(IDispatch)
    ['{F476FEEF-2622-4BB2-BA35-1DDE736F469D}']
    procedure Connect; safecall;
    procedure Disconnect; safecall;
  end;

// *********************************************************************//
// DispIntf:  IAXControlDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {F476FEEF-2622-4BB2-BA35-1DDE736F469D}
// *********************************************************************//
  IAXControlDisp = dispinterface
    ['{F476FEEF-2622-4BB2-BA35-1DDE736F469D}']
    procedure Connect; dispid 1;
    procedure Disconnect; dispid 2;
  end;


// *********************************************************************//
// OLE Control Proxy class declaration
// Control Name     : TAXControl
// Help String      : AXControl Class
// Default Interface: IAXControl
// Def. Intf. DISP? : No
// Event   Interface: 
// TypeFlags        : (2) CanCreate
// *********************************************************************//
  TAXControl = class(TOleControl)
  private
    ClassId:  TGuid;
    FIntf:    IAXControl;
    function  GetControlInterface: IAXControl;
    function  Get_GUID: WideString; safecall;

  protected
    procedure CreateControl;
    procedure InitControlData; override;
  public
    property  GUID: WideString read Get_GUID;

    constructor Create(AOwner: TComponent; ClassId: TGuid); overload;

    procedure Connect;
    procedure Disconnect;
    property  ControlInterface: IAXControl read GetControlInterface;
    property  DefaultInterface: IAXControl read GetControlInterface;
  published
    property Anchors;
    property  TabStop;
    property  Align;
    property  DragCursor;
    property  DragMode;
    property  ParentShowHint;
    property  PopupMenu;
    property  ShowHint;
    property  TabOrder;
    property  Visible;
    property  OnDragDrop;
    property  OnDragOver;
    property  OnEndDrag;
    property  OnEnter;
    property  OnExit;
    property  OnStartDrag;
  end;

{
procedure Register;

resourcestring
  dtlServerPage = 'ActiveX';

  dtlOcxPage = 'ActiveX';

}
implementation

uses ComObj;

constructor TAXControl.Create(AOwner: TComponent; ClassId: TGuid);
begin
      Self.ClassID := ClassId;
      inherited Create(AOwner);
end;

function TAXControl.Get_GUID: WideString; safecall;
begin
  Result := GuidToString(Self.ClassID);
end;

procedure TAXControl.InitControlData;
const
  CControlData: TControlData2 = (
    ClassID: '{524459CD-5F81-4825-96E8-2EA2573B9A14}';
    EventIID: '';
    EventCount: 0;
    EventDispIDs: nil;
    LicenseKey: nil (*HR:$80004002*);
    Flags: $00000000;
    Version: 401);
begin
  ControlData := @CControlData;
  if (not (ClassId.D1 = 0)) then
       ControlData.ClassID := Self.ClassId;
end;

procedure TAXControl.CreateControl;

  procedure DoCreate;
  begin
    FIntf := IUnknown(OleObject) as IAXControl;
  end;

begin
  if FIntf = nil then DoCreate;
end;

function TAXControl.GetControlInterface: IAXControl;
begin
  CreateControl;
  Result := FIntf;
end;

procedure TAXControl.Connect;
begin
  try
    DefaultInterface.Connect();
  except
  // eat, not mandatory
  end;
end;

procedure TAXControl.Disconnect;
begin
  try
    DefaultInterface.Disconnect;
  except
   // eat, not mandatory
 end;
end;
{
procedure Register;
begin
  RegisterComponents(dtlOcxPage, [TAXControl]);
end;
}
end.
