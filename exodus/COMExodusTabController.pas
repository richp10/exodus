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

unit COMExodusTabController;

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  ComObj, ActiveX, Exodus_TLB, StdVcl, TntComCtrls, Unicode, Contnrs, XMLTag;

type
  TExodusTabController = class(TAutoObject, IExodusTabController)
  protected
    function AddTab(const ActiveX_GUID, Name, Type_: WideString): IExodusTab;
      safecall;
      function Get_Tab(Index: Integer): IExodusTab; safecall;
      function Get_TabCount: Integer; safecall;
      procedure RemoveTab(Index: Integer); safecall;
      procedure Clear; safecall;
      function GetTabByUID(const uid: WideString): IExodusTab; safecall;
      function GetTabIndexByUID(const uid: WideString): Integer; safecall;
      function Get_VisibleTabCount: Integer; safecall;
      function GetTabIndexByName(const Name: WideString): Integer; safecall;
      function Get_VisibleTab(Index: Integer): IExodusTab; safecall;
      function Get_ActiveTab: Integer; safecall;
      procedure Set_ActiveTab(Index: Integer); safecall;
  private
      _Tabs: TObjectList;
      _HiddenTabs: TWideStringList;
      _SessionCB: Integer;
      //Methods
      procedure _SessionCallback(Event: string; Tag: TXMLTag);
  public
      constructor Create();
      destructor Destroy; override;
  end;

implementation

uses ComServ, COMExodusTab, COMExodusTabWrapper, Session, PrefController,
     RosterForm, Windows, SysUtils, Variants;

{---------------------------------------}
constructor TExodusTabController.Create();
begin
    _Tabs := TObjectList.Create();
    _Tabs.OwnsObjects := true;
    _HiddenTabs := TWideStringList.Create();
    MainSession.Prefs.fillStringlist('tabs_hidden', _HiddenTabs);
    _SessionCB := MainSession.RegisterCallback(_SessionCallback, '/session');
end;
{---------------------------------------}
procedure TExodusTabController._SessionCallback(Event: string; Tag: TXMLTag);
begin
    // catch session events
    if Event = '/session/prefs' then
         MainSession.Prefs.fillStringlist('tabs_hidden', _HiddenTabs);

end;

{---------------------------------------}
destructor TExodusTabController.Destroy();
begin
    _Tabs.Free;
    _HiddenTabs.Free;
end;

{---------------------------------------}
function TExodusTabController.AddTab(const ActiveX_GUID, Name,
  Type_: WideString): IExodusTab;
var
    Tab: TExodusTabWrapper;
    Idx: Integer;
begin
   Tab := TExodusTabWrapper.Create(ActiveX_GUID, Type_);
   _Tabs.Add(Tab);
   Tab.ExodusTab.Name := Name;
   //Hide tab if it is in the list of hidden tabs
   Idx := _HiddenTabs.IndexOf(Name);
   if (Idx > -1) then
       Tab.ExodusTab.Hide
   else
       Tab.ExodusTab.Show;    

   Result := Tab.ExodusTab;
end;

{---------------------------------------}
function TExodusTabController.Get_Tab(Index: Integer): IExodusTab;
begin
   Result := TExodusTabWrapper(_Tabs[Index]).ExodusTab;
end;

{---------------------------------------}
function TExodusTabController.Get_TabCount: Integer;
begin
    Result := _Tabs.Count;
end;

{---------------------------------------}
procedure TExodusTabController.RemoveTab(Index: Integer);
begin
   _Tabs.Delete(Index);
end;

{---------------------------------------}
procedure TExodusTabController.Clear;
begin
  _Tabs.Clear();
end;


function TExodusTabController.GetTabByUID(const uid: WideString): IExodusTab;
var
    i: Integer;
begin
    Result := nil;
    for i := 0 to _Tabs.Count - 1 do
    begin
       if (Get_Tab(i).UID = uid) then
       begin
          Result := Get_Tab(i);
          break;
       end;
    end;
end;

{---------------------------------------}
function TExodusTabController.GetTabIndexByUID(const uid: WideString): Integer;
var
    i: Integer;
begin
    Result := -1;
    for i := 0 to _Tabs.Count - 1 do
    begin
       if (Get_Tab(i).UID = uid) then
       begin
          Result := i;
          break;
       end;
    end;
end;

{---------------------------------------}
function TExodusTabController.Get_VisibleTabCount: Integer;
var
    i: Integer;
begin
    Result := 0;
    for i := 0 to _Tabs.Count - 1 do
    begin
       if (Get_Tab(i).Visible) then
           Inc(Result);
    end;
end;

{---------------------------------------}
function TExodusTabController.GetTabIndexByName(
  const Name: WideString): Integer;
var
    i: Integer;
begin
    Result := -1;
    for i := 0 to _Tabs.Count - 1 do
    begin
       if (Get_Tab(i).Name = Name) then
       begin
          Result := i;
          break;
       end;
    end;
end;

{---------------------------------------}
function TExodusTabController.Get_VisibleTab(Index: Integer): IExodusTab;
var
    i: Integer;
begin
    Result := nil;
    if (Index < 0) then exit;
    if (Index > Get_VisibleTabCount - 1) then exit;
    for i := 0 to _Tabs.Count - 1 do
    begin
       if (Get_Tab(i).TabIndex = Index) then
       begin
          Result := Get_Tab(Get_Tab(i).PageIndex);
          break;
       end;
    end;
end;

{---------------------------------------}
function TExodusTabController.Get_ActiveTab: Integer;
begin
    OutputDebugString(PChar(Format('Active tab: %d',[GetRosterWindow().PageControl.ActivePageIndex])));
    Result := GetRosterWindow().PageControl.ActivePageIndex;
end;

{---------------------------------------}
procedure TExodusTabController.Set_ActiveTab(Index: Integer);
begin
    if (Index < 0) then exit;
    if (Index > GetRosterWindow().PageControl.PageCount - 1) then exit;
    
    OutputDebugString(PChar(Format('Setting active tab: %d',[Index])));
    //Get_Tab(Index).Activate;
    GetRosterWindow().PageControl.ActivePage := GetRosterWindow().PageControl.Pages[Index];
    OutputDebugString(PChar(Format('Active tab: %d',[GetRosterWindow().PageControl.ActivePageIndex])));
end;


initialization
  TAutoObjectFactory.Create(ComServer, TExodusTabController, Class_ExodusTabController,
    ciMultiInstance, tmApartment);
end.
