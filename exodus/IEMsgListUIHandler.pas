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
unit IEMsgListUIHandler;


interface

uses
{$IFNDEF EXODUS}
    Exodus_TLB,
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
    BaseMsgList,
    StdCtrls,
    ComCtrls,
    Unicode,
    OleCtrls,
    SHDocVw,
    ExtCtrls,
    mshtml,
    ActiveX;

type
    // WebBrowser Events that need IDocHostUIHandler
    TDocHostUIInfo = record
        cbSize: ULONG;
        dwFlags: DWORD;
        dwDoubleClick: DWORD;
        pchHostCss: PWChar;
        pchHostNS: PWChar;
    end;
    PDocHostUIInfo = ^TDocHostUIInfo;

    IDocHostUIHandler = interface(IUnknown)
        ['{bd3f23c0-d43e-11cf-893b-00aa00bdce1a}']
        function ShowContextMenu(const dwID: DWORD; const ppt: PPOINT; const CommandTarget: IUnknown; const Context: IDispatch): HRESULT; stdcall;
        function GetHostInfo(var pInfo: TDOCHOSTUIINFO): HRESULT; stdcall;
        function ShowUI(const dwID: DWORD; const pActiveObject: IOleInPlaceActiveObject; const pCommandTarget: IOleCommandTarget; const pFrame: IOleInPlaceFrame; const pDoc: IOleInPlaceUIWindow): HRESULT; stdcall;
        function HideUI: HRESULT; stdcall;
        function UpdateUI: HRESULT; stdcall;
        function EnableModeless(const fEnable: BOOL): HRESULT; stdcall;
        function OnDocWindowActivate(const fActivate: BOOL): HRESULT; stdcall;
        function OnFrameWindowActivate(const fActivate: BOOL): HRESULT; stdcall;
        function ResizeBorder(const prcBorder: PRECT; const pUIWindow: IOleInPlaceUIWindow; const fRameWindow: BOOL): HRESULT; stdcall;
        function TranslateAccelerator(const lpMsg: PMSG; const pguidCmdGroup: PGUID; const nCmdID: DWORD): HRESULT; stdcall;
        function GetOptionKeyPath(out pchKey: POLESTR; const dw: DWORD): HRESULT; stdcall;
        function GetDropTarget(const pDropTarget: IDropTarget; out ppDropTarget: IDropTarget): HRESULT; stdcall;
        function GetExternal(out ppDispatch: IDispatch): HRESULT; stdcall;
        function TranslateUrl(const dwTranslate: DWORD; const pchURLIn: POLESTR; out ppchURLOut: POLESTR): HRESULT; stdcall;
        function FilterDataObject(const pDO: IDataObject; out ppDORet: IDataObject): HRESULT; stdcall;
    end;

    TWebBrowserUIObject = class(TObject, IUnknown, IOleClientSite, IDocHostUIHandler)
    private
{$IFNDEF EXODUS}
        _controller: IExodusController;
{$ENDIF}
    protected
        // IUnknown Interface
        function QueryInterface(const IID: TGUID; out Obj): HResult; stdcall;
        function _AddRef: Integer; stdcall;
        function _Release: Integer; stdcall;

        // IOleClientSite Interface
        function SaveObject: HResult; stdcall;
        function GetMoniker(dwAssign: Longint; dwWhichMoniker: Longint; out mk: IMoniker): HResult; stdcall;
        function GetContainer(out container: IOleContainer): HResult; stdcall;
        function ShowObject: HResult; stdcall;
        function OnShowWindow(fShow: BOOL): HResult; stdcall;
        function RequestNewObjectLayout: HResult; stdcall;

        // IDocHostUIHandler Interface
        function ShowContextMenu(const dwID: DWORD; const ppt: PPOINT; const CommandTarget: IUnknown; const Context: IDispatch): HRESULT; stdcall;
        function GetHostInfo(var pInfo: TDOCHOSTUIINFO): HRESULT; stdcall;
        function ShowUI(const dwID: DWORD; const pActiveObject: IOleInPlaceActiveObject; const pCommandTarget: IOleCommandTarget; const pFrame: IOleInPlaceFrame; const pDoc: IOleInPlaceUIWindow): HRESULT; stdcall;
        function HideUI: HRESULT; stdcall;
        function UpdateUI: HRESULT; stdcall;
        function EnableModeless(const fEnable: BOOL): HRESULT; stdcall;
        function OnDocWindowActivate(const fActivate: BOOL): HRESULT; stdcall;
        function OnFrameWindowActivate(const fActivate: BOOL): HRESULT; stdcall;
        function ResizeBorder(const prcBorder: PRECT; const pUIWindow: IOleInPlaceUIWindow; const fRameWindow: BOOL): HRESULT; stdcall;
        function TranslateAccelerator(const lpMsg: PMSG; const pguidCmdGroup: PGUID; const nCmdID: DWORD): HRESULT; stdcall;
        function GetOptionKeyPath(out pchKey: POLESTR; const dw: DWORD): HRESULT; stdcall;
        function GetDropTarget(const pDropTarget: IDropTarget; out ppDropTarget: IDropTarget): HRESULT; stdcall;
        function GetExternal(out ppDispatch: IDispatch): HRESULT; stdcall;
        function TranslateUrl(const dwTranslate: DWORD; const pchURLIn: POLESTR; out ppchURLOut: POLESTR): HRESULT; stdcall;
        function FilterDataObject(const pDO: IDataObject; out ppDORet: IDataObject): HRESULT; stdcall;

    public
{$IFDEF EXODUS}
        constructor Create();
{$ELSE}
        constructor Create(controller: IExodusController);
{$ENDIF}

    end;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
implementation

uses
{$IFDEF EXODUS}
    ExUtils,
    Session,
    PrefController,
    BaseChat,
    Jabber1,
{$ENDIF}
    Emote,
    XMLTag,
    JabberUtils,
    ShellAPI,
    DateUtils,
    StrUtils;

{---------------------------------------}
{---------------------------------------}
{$IFDEF EXODUS}
constructor TWebBrowserUIObject.Create();
{$ELSE}
constructor TWebBrowserUIObject.Create(controller: IExodusController);
{$ENDIF}
begin
    inherited Create;
{$IFNDEF EXODUS}
    assert(controller <> nil);
    _controller := controller;
{$ENDIF}
end;

{---------------------------------------}
function TWebBrowserUIObject.QueryInterface(const IID: TGUID; out Obj): HResult; stdcall;
begin
    if GetInterface(IID, Obj) then
        Result := S_OK
    else
        Result := E_NOINTERFACE;
end;

{---------------------------------------}
function TWebBrowserUIObject._AddRef: Integer; stdcall;
begin
    Result := -1;
end;

{---------------------------------------}
function TWebBrowserUIObject._Release: Integer; stdcall;
begin
    Result := -1;
end;

{---------------------------------------}
function TWebBrowserUIObject.SaveObject: HResult; stdcall;
begin
    Result := S_OK;
end;

{---------------------------------------}
function TWebBrowserUIObject.GetMoniker(dwAssign: Longint; dwWhichMoniker: Longint; out mk: IMoniker): HResult; stdcall;
begin
    mk := nil;
    Result := E_NOTIMPL;
end;

{---------------------------------------}
function TWebBrowserUIObject.GetContainer(out container: IOleContainer): HResult; stdcall;
begin
    container := nil;
    Result := E_NOINTERFACE;
end;

{---------------------------------------}
function TWebBrowserUIObject.ShowObject: HResult; stdcall;
begin
    Result := S_OK;
end;

{---------------------------------------}
function TWebBrowserUIObject.OnShowWindow(fShow: BOOL): HResult; stdcall;
begin
    Result := S_OK;
end;

{---------------------------------------}
function TWebBrowserUIObject.RequestNewObjectLayout: HResult; stdcall;
begin
    Result := E_NOTIMPL;
end;

{---------------------------------------}
function TWebBrowserUIObject.ShowContextMenu(const dwID: DWORD; const ppt: PPOINT; const CommandTarget: IUnknown; const Context: IDispatch): HRESULT; stdcall;
begin
    Result := S_FALSE;
end;

{---------------------------------------}
function TWebBrowserUIObject.GetHostInfo(var pInfo: TDOCHOSTUIINFO): HRESULT; stdcall;
begin
    Result := S_OK;
end;

{---------------------------------------}
function TWebBrowserUIObject.ShowUI(const dwID: DWORD; const pActiveObject: IOleInPlaceActiveObject; const pCommandTarget: IOleCommandTarget; const pFrame: IOleInPlaceFrame; const pDoc: IOleInPlaceUIWindow): HRESULT; stdcall;
begin
    Result := S_OK;
end;

{---------------------------------------}
function TWebBrowserUIObject.HideUI: HRESULT; stdcall;
begin
    Result := S_OK;
end;

{---------------------------------------}
function TWebBrowserUIObject.UpdateUI: HRESULT; stdcall;
begin
    Result := S_OK;
end;

{---------------------------------------}
function TWebBrowserUIObject.EnableModeless(const fEnable: BOOL): HRESULT; stdcall;
begin
    Result := S_OK;
end;

{---------------------------------------}
function TWebBrowserUIObject.OnDocWindowActivate(const fActivate: BOOL): HRESULT; stdcall;
begin
    Result := S_OK;
end;

{---------------------------------------}
function TWebBrowserUIObject.OnFrameWindowActivate(const fActivate: BOOL): HRESULT; stdcall;
begin
    Result := S_OK;
end;

{---------------------------------------}
function TWebBrowserUIObject.ResizeBorder(const prcBorder: PRECT; const pUIWindow: IOleInPlaceUIWindow; const fRameWindow: BOOL): HRESULT; stdcall;
begin
    Result := S_FALSE;
end;

{---------------------------------------}
function TWebBrowserUIObject.TranslateAccelerator(const lpMsg: PMSG; const pguidCmdGroup: PGUID; const nCmdID: DWORD): HRESULT; stdcall;
begin
    Result := S_FALSE;
end;

{---------------------------------------}
function TWebBrowserUIObject.GetOptionKeyPath(out pchKey: POLESTR; const dw: DWORD): HRESULT; stdcall;
var
    reg: widestring;
    len: integer;
begin
{$IFNDEF EXODUS}
    assert(_controller <> nil);
{$ENDIF}
{$IFDEF EXODUS}
    reg := '\Software\Jabber\' + PrefController.GetAppInfo().ID + '\IEMsgList';
{$ELSE}
    reg := '\Software\Jabber\' + _controller.getPrefAsString('appID') + '\IEMsgList';
{$ENDIF}
    len := (length(reg) + 1) * 2; // widestring is 2 byte per char, +1 for null term
    pchKey := CoTaskMemAlloc(len);
    if (pchKey <> nil) then begin
        CopyMemory(pchKey, PWideChar(reg), len);
        Result := S_OK;
    end
    else begin
        Result := E_FAIL;
    end;
end;

{---------------------------------------}
function TWebBrowserUIObject.GetDropTarget(const pDropTarget: IDropTarget; out ppDropTarget: IDropTarget): HRESULT; stdcall;
begin
    Result := E_FAIL;
end;

{---------------------------------------}
function TWebBrowserUIObject.GetExternal(out ppDispatch: IDispatch): HRESULT; stdcall;
begin
    ppDispatch := nil;
    Result := E_FAIL;
end;

{---------------------------------------}
function TWebBrowserUIObject.TranslateUrl(const dwTranslate: DWORD; const pchURLIn: POLESTR; out ppchURLOut: POLESTR): HRESULT; stdcall;
begin
    Result := E_FAIL;
end;

{---------------------------------------}
function TWebBrowserUIObject.FilterDataObject(const pDO: IDataObject; out ppDORet: IDataObject): HRESULT; stdcall;
begin
    ppDORet := nil;
    Result := S_FALSE;
end;


end.


