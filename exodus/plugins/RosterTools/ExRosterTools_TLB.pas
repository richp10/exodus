unit ExRosterTools_TLB;

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
// File generated on 8/24/2006 1:42:10 PM from Type Library described below.

// ************************************************************************  //
// Type Lib: ExRosterTools.tlb (1)
// LIBID: {5EA5A7C9-CA6B-4F61-8FF1-95BFAD75397F}
// LCID: 0
// Helpfile: 
// HelpString: RosterTools Library
// DepndLst: 
//   (1) v1.0 Exodus, (C:\Projects\Devel\Clients\Hermes\bin\Exodus.exe)
//   (2) v2.0 stdole, (C:\WINDOWS\system32\stdole2.tlb)
// Errors:
//   Error creating palette bitmap of (TRosterPlugin) : Server C:\Projects\exodus\exodus\plugins\ExRosterTools.dll contains no icons
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
  ExRosterToolsMajorVersion = 1;
  ExRosterToolsMinorVersion = 0;

  LIBID_ExRosterTools: TGUID = '{5EA5A7C9-CA6B-4F61-8FF1-95BFAD75397F}';

  CLASS_RosterPlugin: TGUID = '{F4DAE94B-7B21-4576-A5D0-573A4E2CBD65}';
type

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  RosterPlugin = IExodusPlugin;


// *********************************************************************//
// The Class CoRosterPlugin provides a Create and CreateRemote method to          
// create instances of the default interface IExodusPlugin exposed by              
// the CoClass RosterPlugin. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoRosterPlugin = class
    class function Create: IExodusPlugin;
    class function CreateRemote(const MachineName: string): IExodusPlugin;
  end;


// *********************************************************************//
// OLE Server Proxy class declaration
// Server Object    : TRosterPlugin
// Help String      : 
// Default Interface: IExodusPlugin
// Def. Intf. DISP? : No
// Event   Interface: 
// TypeFlags        : (2) CanCreate
// *********************************************************************//
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  TRosterPluginProperties= class;
{$ENDIF}
  TRosterPlugin = class(TOleServer)
  private
    FIntf: IExodusPlugin;
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    FProps: TRosterPluginProperties;
    function GetServerProperties: TRosterPluginProperties;
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
    property Server: TRosterPluginProperties read GetServerProperties;
{$ENDIF}
  end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
// *********************************************************************//
// OLE Server Properties Proxy Class
// Server Object    : TRosterPlugin
// (This object is used by the IDE's Property Inspector to allow editing
//  of the properties of this server)
// *********************************************************************//
 TRosterPluginProperties = class(TPersistent)
  private
    FServer:    TRosterPlugin;
    function    GetDefaultInterface: IExodusPlugin;
    constructor Create(AServer: TRosterPlugin);
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

class function CoRosterPlugin.Create: IExodusPlugin;
begin
  Result := CreateComObject(CLASS_RosterPlugin) as IExodusPlugin;
end;

class function CoRosterPlugin.CreateRemote(const MachineName: string): IExodusPlugin;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_RosterPlugin) as IExodusPlugin;
end;

procedure TRosterPlugin.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{F4DAE94B-7B21-4576-A5D0-573A4E2CBD65}';
    IntfIID:   '{6D6CCD11-2FAA-4CCB-92CA-CAB14A3BE234}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TRosterPlugin.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as IExodusPlugin;
  end;
end;

procedure TRosterPlugin.ConnectTo(svrIntf: IExodusPlugin);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TRosterPlugin.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TRosterPlugin.GetDefaultInterface: IExodusPlugin;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface is NULL. Component is not connected to Server. You must call ''Connect'' or ''ConnectTo'' before this operation');
  Result := FIntf;
end;

constructor TRosterPlugin.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps := TRosterPluginProperties.Create(Self);
{$ENDIF}
end;

destructor TRosterPlugin.Destroy;
begin
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps.Free;
{$ENDIF}
  inherited Destroy;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
function TRosterPlugin.GetServerProperties: TRosterPluginProperties;
begin
  Result := FProps;
end;
{$ENDIF}

procedure TRosterPlugin.Startup(const exodusController: IExodusController);
begin
  DefaultInterface.Startup(exodusController);
end;

procedure TRosterPlugin.Shutdown;
begin
  DefaultInterface.Shutdown;
end;

procedure TRosterPlugin.Process(const xpath: WideString; const event: WideString; 
                                const XML: WideString);
begin
  DefaultInterface.Process(xpath, event, XML);
end;

procedure TRosterPlugin.NewChat(const JID: WideString; const chat: IExodusChat);
begin
  DefaultInterface.NewChat(JID, chat);
end;

procedure TRosterPlugin.NewRoom(const JID: WideString; const room: IExodusChat);
begin
  DefaultInterface.NewRoom(JID, room);
end;

function TRosterPlugin.NewIM(const JID: WideString; var Body: WideString; var Subject: WideString; 
                             const xTags: WideString): WideString;
begin
  Result := DefaultInterface.NewIM(JID, Body, Subject, xTags);
end;

procedure TRosterPlugin.Configure;
begin
  DefaultInterface.Configure;
end;

procedure TRosterPlugin.NewOutgoingIM(const JID: WideString; const instantMsg: IExodusChat);
begin
  DefaultInterface.NewOutgoingIM(JID, instantMsg);
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
constructor TRosterPluginProperties.Create(AServer: TRosterPlugin);
begin
  inherited Create;
  FServer := AServer;
end;

function TRosterPluginProperties.GetDefaultInterface: IExodusPlugin;
begin
  Result := FServer.DefaultInterface;
end;

{$ENDIF}

procedure Register;
begin
  RegisterComponents(dtlServerPage, [TRosterPlugin]);
end;

end.
