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
unit NTDLLFixup;

interface

implementation
uses
    SysUtils,
    Windows;
{$DEFINE NTDLL_FIXUP}
{****************************************************************************
PatchINT3 is based on code from Pete Morris

Wed 4/06/2005 6:25 pm. This is a do-nothing program that fixes
NTDLL.DbgBreakPoint in Delphi 5 running under XP (SP2 although I think it's
all the XPs and NTs and who knows). Seems Microsoft left a breakpoint in a
DLL, so when you run a Delphi 5 program in the Delphi environment, it
starts-off by opening the CPU (assembly-language) window at a "ret". If you
use the arrow to up a bit you'll see you're at this code:

ntdll.DbgBreakPoint:
7C901230 int 3
7C901231 ret <---- you are here.

This is fairly frightening the first time it happens, but it was really quite
harmless although fairly annoying. Note that the program won't do this unless
it's in the IDE. To stop it, you can run PatchINT3 below from initialization
as shown -- written by a kindly german I found at
www.delphipraxis.net/post164845.html (I used google xlation). I fixed the
numerous punctuation errors -- and there are other copies of this thing in
slightly different forms and languages around the web, so who knows who wrote
the original. ...

Sadly this has to be in the program you're debugging; i.e., after you run
this, some *other* Delphi 5 debug IDE session will still break with the
breakpoint -- or who knows....

I still suspect there's some way to do this "normally"; I had high hopes for
EXCEPTION_BREAKPOINT $80000003 -- but I "added" it to the Delphi 5 exceptions
(tools / debugger options / OS exceptions / add button, with every combination
of the check boxes) with absolutely no effect.

Note the $ifDEF NTDLL will suppress the code if you compile a release version
with the debug info off, as the comment indicates. This will run outside the
IDE without annoyances.

RANDOM MUSINGS

Finally note that very simple programs -- like this one for instance -- will
*never* invoke the ntdll.dbgbreakpoint; I assume it has something to do with
particular controls, which are wrappers of / call Microsoft controls, which in
turn call the ntdll.dbgbreakpoint which is, I gather, an entry point
specifically for the purpose of invoking the debugger. Perhaps the usux code
does this under provocation from the Borland code; more likely, it's "just
normal" and the usux tools handle the thing properly, as do later Borland
tools (Delphi 6, 7) after sacrifice of first child presumably....

****************************************************************************}

{$ifDEF NTDLL_FIXUP}
procedure PatchINT3;
var
    NOP: Byte;
    NTDLL: THandle;
    BytesWritten: DWORD;
    ADDRESS: Pointer;
begin
    if DebugHook=0 then
        exit;


    if Win32Platform <> VER_PLATFORM_WIN32_NT then
        exit;

    NTDLL := GetModuleHandle('NTDLL.DLL');

    if NTDLL = 0 then
        exit;

    ADDRESS := GetProcAddress(NTDLL, 'DbgBreakPoint');
    if ADDRESS = nil then
        exit;

    try
        if Char(Address^) <> #$CC
        then exit;

        NOP := $90;

        if WriteProcessMemory(GetCurrentProcess,ADDRESS,@NOP, 1,BytesWritten) and
           (BytesWritten = 1) then
            FlushInstructionCache(GetCurrentProcess, ADDRESS, 1);

    except
        //Do not panic if you see an EAccessViolation here,
        // it is perfectly harmless!
        on EAccessViolation DO;
        else raise;
    end;
end;

{$endif}
initialization

{$ifDEF NTDLL_FIXUP} {only compiled if defined on.}
    PatchInt3;
{$endif}

end.
