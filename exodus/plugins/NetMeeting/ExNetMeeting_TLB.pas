unit ExNetMeeting_TLB;

// ************************************************************************ //
// WARNING                                                                    
// -------                                                                    
// The types declared in this file were generated from data read from a       
// Type Library. If this type library is explicitly or indirectly (via        
// another type library referring to this type library) re-imported, or the   
// 'Refresh' command of the Type Library Editor activated while editing the   
// Type Library, the contents of this file will be regenerated and all        
// manual modifications will be lost.                                         
// ************************************************************************ //

// PASTLWTR : 1.2
// File generated on 8/24/2006 1:42:09 PM from Type Library described below.

// ************************************************************************  //
// Type Lib: ExNetMeeting.tlb (1)
// LIBID: {E6B4D6BB-6346-4D99-92BD-BAA6213E4FDB}
// LCID: 0
// Helpfile: 
// HelpString: ExNetMeeting Library
// DepndLst: 
//   (1) v1.0 Exodus, (C:\Projects\Devel\Clients\Hermes\bin\Exodus.exe)
//   (2) v2.0 stdole, (C:\WINDOWS\system32\stdole2.tlb)
// Errors:
//   Error creating palette bitmap of (TExNetmeetingPlugin) : No Server registered for this CoClass
// ************************************************************************ //
// *************************************************************************//
// NOTE:                                                                      
// Items guarded by $IFDEF_LIVE_SERVER_AT_DESIGN_TIME are used by properties  
// which return objects that may need to be explicitly created via a function 
// call prior to any access via the property. These items have been disabled  
// in order to prevent accidental use from within the object inspector. You   
// may enable them by defining LIVE_SERVER_AT_DESIGN_TIME or by selectively   
// removing them from the $IFDEF blocks. However, such items must still be    
// programmatically created via a method of the appropriate CoClass before    
// they can be used.                                                          
{$TYPEDADDRESS OFF} // Unit must be compiled without type-checked pointers. 
{$WARN SYMBOL_PLATFORM OFF}
{$WRITEABLECONST ON}
{$VARPROPSETTER ON}
interface

uses Windows, ActiveX, Classes, Exodus_TLB, Graphics, OleServer, StdVCL, Variants;
  


// *********************************************************************//
// GUIDS declared in the TypeLibrary. Following prefixes are used:        
//   Type Libraries     : LIBID_xxxx                                      
//   CoClasses          : CLASS_xxxx                                      
//   DISPInterfaces     : DIID_xxxx                                       
//   Non-DISP interfaces: IID_xxxx                                        
// *********************************************************************//
const
  // TypeLibrary Major and minor versions
  ExNetMeetingMajorVersion = 1;
  ExNetMeetingMinorVersion = 0;

  LIBID_ExNetMeeting: TGUID = '{E6B4D6BB-6346-4D99-92BD-BAA6213E4FDB}';

  CLASS_ExNetmeetingPlugin: TGUID = '{D44676BB-8F88-4A46-8981-4FFCE436AF76}';
type

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  ExNetmeetingPlugin = IExodusPlugin;


// *********************************************************************//
// The Class CoExNetmeetingPlugin provides a Create and CreateRemote method to          
// create instances of the default interface IExodusPlugin exposed by              
// the CoClass ExNetmeetingPlugin. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoExNetmeetingPlugin = class
    class function Create: IExodusPlugin;
    class function CreateRemote(const MachineName: string): IExodusPlugin;
  end;


// *********************************************************************//
// OLE Server Proxy class declaration
// Server Object    : TExNetmeetingPlugin
// Help String      : 
// Default Interface: IExodusPlugin
// Def. Intf. DISP? : No
// Event   Interface: 
// TypeFlags        : (2) CanCreate
// *********************************************************************//
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  TExNetmeetingPluginProperties= class;
{$ENDIF}
  TExNetmeetingPlugin = class(TOleServer)
  private
    FIntf: IExodusPlugin;
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    FProps: TExNetmeetingPluginProperties;
    function GetServerProperties: TExNetmeetingPluginProperties;
{$ENDIF}
    function GetDefaultInterface: IExodusPlugin;
  protected
    procedure InitServerData; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: IExodusPlugin);
    procedure Disconnect; override;
    procedure Startup(const exodusController: IExodusController);
    procedure Shutdown;
    procedure Process(const xpath: WideString; const event: WideString; const XML: WideString);
    procedure NewChat(const JID: WideString; const chat: IExodusChat);
    procedure NewRoom(const JID: WideString; const room: IExodusChat);
    function NewIM(const JID: WideString; var Body: WideString; var Subject: WideString; 
                   const xTags: WideString): WideString;
    procedure Configure;
    procedure NewOutgoingIM(const JID: WideString; const instantMsg: IExodusChat);
    property DefaultInterface: IExodusPlugin read GetDefaultInterface;
  published
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    property Server: TExNetmeetingPluginProperties read GetServerProperties;
{$ENDIF}
  end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
// *********************************************************************//
// OLE Server Properties Proxy Class
// Server Object    : TExNetmeetingPlugin
// (This object is used by the IDE's Property Inspector to allow editing
//  of the properties of this server)
// *********************************************************************//
 TExNetmeetingPluginProperties = class(TPersistent)
  private
    FServer:    TExNetmeetingPlugin;
    function    GetDefaultInterface: IExodusPlugin;
    constructor Create(AServer: TExNetmeetingPlugin);
  protected
  public
    property DefaultInterface: IExodusPlugin read GetDefaultInterface;
  published
  end;
{$ENDIF}


procedure Register;

resourcestring
  dtlServerPage = 'Servers';

  dtlOcxPage = 'ActiveX';

implementation

uses ComObj;

class function CoExNetmeetingPlugin.Create: IExodusPlugin;
begin
  Result := CreateComObject(CLASS_ExNetmeetingPlugin) as IExodusPlugin;
end;

class function CoExNetmeetingPlugin.CreateRemote(const MachineName: string): IExodusPlugin;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_ExNetmeetingPlugin) as IExodusPlugin;
end;

procedure TExNetmeetingPlugin.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{D44676BB-8F88-4A46-8981-4FFCE436AF76}';
    IntfIID:   '{6D6CCD11-2FAA-4CCB-92CA-CAB14A3BE234}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TExNetmeetingPlugin.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as IExodusPlugin;
  end;
end;

procedure TExNetmeetingPlugin.ConnectTo(svrIntf: IExodusPlugin);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TExNetmeetingPlugin.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TExNetmeetingPlugin.GetDefaultInterface: IExodusPlugin;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface is NULL. Component is not connected to Server. You must call ''Connect'' or ''ConnectTo'' before this operation');
  Result := FIntf;
end;

constructor TExNetmeetingPlugin.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps := TExNetmeetingPluginProperties.Create(Self);
{$ENDIF}
end;

destructor TExNetmeetingPlugin.Destroy;
begin
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps.Free;
{$ENDIF}
  inherited Destroy;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
function TExNetmeetingPlugin.GetServerProperties: TExNetmeetingPluginProperties;
begin
  Result := FProps;
end;
{$ENDIF}

procedure TExNetmeetingPlugin.Startup(const exodusController: IExodusController);
begin
  DefaultInterface.Startup(exodusController);
end;

procedure TExNetmeetingPlugin.Shutdown;
begin
  DefaultInterface.Shutdown;
end;

procedure TExNetmeetingPlugin.Process(const xpath: WideString; const event: WideString; 
                                      const XML: WideString);
begin
  DefaultInterface.Process(xpath, event, XML);
end;

procedure TExNetmeetingPlugin.NewChat(const JID: WideString; const chat: IExodusChat);
begin
  DefaultInterface.NewChat(JID, chat);
end;

procedure TExNetmeetingPlugin.NewRoom(const JID: WideString; const room: IExodusChat);
begin
  DefaultInterface.NewRoom(JID, room);
end;

function TExNetmeetingPlugin.NewIM(const JID: WideString; var Body: WideString; 
                                   var Subject: WideString; const xTags: WideString): WideString;
begin
  Result := DefaultInterface.NewIM(JID, Body, Subject, xTags);
end;

procedure TExNetmeetingPlugin.Configure;
begin
  DefaultInterface.Configure;
end;

procedure TExNetmeetingPlugin.NewOutgoingIM(const JID: WideString; const instantMsg: IExodusChat);
begin
  DefaultInterface.NewOutgoingIM(JID, instantMsg);
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
constructor TExNetmeetingPluginProperties.Create(AServer: TExNetmeetingPlugin);
begin
  inherited Create;
  FServer := AServer;
end;

function TExNetmeetingPluginProperties.GetDefaultInterface: IExodusPlugin;
begin
  Result := FServer.DefaultInterface;
end;

{$ENDIF}

procedure Register;
begin
  RegisterComponents(dtlServerPage, [TExNetmeetingPlugin]);
end;

end.
