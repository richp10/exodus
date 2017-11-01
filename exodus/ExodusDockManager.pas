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
unit ExodusDockManager;



interface

uses
    // Exodus stuff
    {BaseChat, ExResponders, ExEvents, RosterWindow, Presence, XMLTag,
    ShellAPI, Registry, SelectItem, Emote, NodeItem,
    Dockable,
    // Delphi stuff
    Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
    ScktComp, StdCtrls, ComCtrls, Menus, ImgList, ExtCtrls,
    Buttons, OleCtrls, AppEvnts, ToolWin,
    IdHttp, TntComCtrls, DdeMan, IdBaseComponent, IdComponent, IdUDPBase,
    IdUDPClient, IdDNSResolver, TntMenus, IdAntiFreezeBase, IdAntiFreeze,
    TntForms, ExTracer, VistaAltFixUnit, ExForm;
    }
    Forms,
    Controls,
    Dockable,
    TntComCtrls;

type
    {
      Dock states
    }
    TDockStates = (dsUnDocked, dsDocked, dsUninitialized);

    IExodusDockManager = interface
    {
        Close the tab for the given form.

        Adjust layout as needed
    }
    procedure CloseDocked(frm: TfrmDockable);

    {
        Open a tab and dock the given form

        Adjust the layout as needed (none docked, embedded roster etc)
    }
    function OpenDocked(frm : TfrmDockable) : TTntTabSheet;

    {
        Float the given form.

        Adjust layout as needed
    }
    procedure FloatDocked(frm : TfrmDockable);

    {
        Get the current docksite for the main window.

        Pretty much the window itself but this absctraction
        should allow us to have a free floting dock manager
    }
    function GetDockSite() : TWinControl;

    {
        Bring the given docked form to the front of the tab list

        If form is currently docked, make it the active tab.
        Sets focus to the new tab
    }
    procedure BringDockedToTop(form: TfrmDockable);

    {
        Get the currently top docked form.

        May return nil if topmost docked form is not TfrmDockable(????) or
        nothing is docked.
    }
    function getTopDocked() : TfrmDockable;

    procedure SelectNext(goforward: boolean; visibleOnly:boolean=false);

    procedure OnNotify(frm: TfrmDockable; notifyEvents: integer);


    {
        frm has had some kind of state change and its presentation needs to
        be updated.

        form may have changed tab icon, notification state.
    }
    procedure UpdateDocked(frm: TfrmDockable);

    {
        Bring the dock manager to front.

        Restore if minimized and bring to top of z-order. Don't take focus
    }
    procedure BringToFront();

    {
        Show or hide the dockmanager.

        Result is if the window was shown or hidden as desired.
        It is possible for the window to have reason to refuse request to show/hide.
    }
    function ShowDockManagerWindow(Show: boolean = true; BringWindowToFront: boolean = true): boolean;

    function isActive(): boolean;

    function getHWND(): THandle;
  end;

implementation

end.

