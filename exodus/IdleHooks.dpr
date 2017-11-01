library IdleHooks;

{
    Copyright 2001, Peter Millard

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

uses
    Windows, Messages, SysUtils;

{$R *.res}


type
    {
    This is a struct to be used in our memory mapped file
    }
    TSharedArea = record
        InstanceCount: integer; // How many instances do we have
        KeyHook: HHOOK;	        // Our keyboard hook
        MouseHook: HHOOK;		// Our mouse hook
        LastTick: dword;		// The last idle tick count
        end;
    PSharedArea = ^TSharedArea;

var
    // Local stuff
    fShare : PSharedArea = nil;
    mapHandle: THandle = 0;
    newMap: boolean = false;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
procedure CreateMemMap();
begin
    // create a process wide memory mnapped variable
    mapHandle := CreateFileMapping($FFFFFFFF, nil, PAGE_READWRITE,
        0, SizeOf(TSharedArea), 'ExodusHookMem');

    // GetLastError returns 0 for a new mem-mapped file
    newMap := (GetLastError() = 0);

    // get a pointer to our record in the mem map
    fShare := MapViewOfFile(mapHandle, FILE_MAP_WRITE, 0, 0, 0);
    fShare^.LastTick := GetTickCount();

    if (newMap) then
        fShare^.InstanceCount := 1
    else
        fShare^.InstanceCount := fShare^.InstanceCount + 1;
end;

{---------------------------------------}
procedure RemoveMemMap();
begin
    // remove the memory mapped variable
    if (fShare <> nil) then begin
        fShare^.InstanceCount := fShare^.InstanceCount - 1;
        UnMapViewOfFile(fShare);
        CloseHandle(mapHandle);
        mapHandle := 0;
        fShare := nil;
        end;
end;

{---------------------------------------}
function GetLastTick: dword; stdcall;
begin
    // return the last Tick count from our shared mem segment
    Result := fShare^.LastTick;
end;

{---------------------------------------}
function KeyHook(code: integer; wParam: word; lParam: longword): longword; stdcall;
begin
    // This is the callback which is called whenever a keyboard event happens
    if (code = HC_ACTION) then begin
        if ((HiWord(lParam) AND KF_UP) <> 0) then
            fShare^.LastTick := GetTickCount();
        end;
    Result := CallNextHookEx(fShare^.KeyHook, code, wParam, lParam);
end;

{---------------------------------------}
function MouseHook(code: integer; wParam: word; lParam: longword): longword; stdcall;
begin
    // This is the callback which is called whenever a mouse event happens
    if (code = HC_ACTION) then
        fShare^.LastTick := GetTickCount();

    Result := CallNextHookEx(fShare^.MouseHook, code, wParam, lParam);
end;

{---------------------------------------}
procedure InitHooks; stdcall;
begin
    // Setup the hooks if they aren't already there.
    if (fShare^.KeyHook = 0) then begin
        // setup the hook and store it
        fShare^.KeyHook := SetWindowsHookEx(WH_KEYBOARD, @KeyHook, hInstance, 0);
        fShare^.MouseHook := SetWindowsHookEx(WH_MOUSE, @MouseHook, hInstance, 0);
        end;
end;

{---------------------------------------}
procedure StopHooks; stdcall;
begin
    // Unregister our custom hooks
    if (fShare^.KeyHook <> 0) then
        UnHookWindowsHookEx(fShare^.KeyHook);
    fShare^.KeyHook := 0;

    if (fShare^.MouseHook <> 0) then
        UnHookWindowsHookEx(fShare^.MouseHook);
    fShare^.MouseHook := 0;
end;

{---------------------------------------}
{---------------------------------------}
procedure DllEntryPoint(dwReason: DWORD);
begin
    // This gets called when the DLL attaches itself to a process,
    // or when it detaches itself from a process.
    case dwReason of
    Dll_Process_Attach: begin
        mapHandle := 0;
        fShare := nil;
        CreateMemMap();
        end;
    Dll_Process_Detach: begin
        RemoveMemMap();
        end;
    end;
end;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
exports
    KeyHook name 'KeyHook',
    GetLastTick name 'GetLastTick',
    InitHooks name 'InitHooks',
    StopHooks name 'StopHooks';

begin
    DLLProc := @DllEntryPoint;
    DllEntryPoint(Dll_Process_Attach);
end.


