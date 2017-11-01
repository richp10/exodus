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
unit BaseMsgList;


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
    ExFrame;

type
  TfBaseMsgList = class(TExFrame)
  protected
    _base: TObject; // this is our base form
{$IFNDEF EXODUS}
    _controller: IExodusController;
{$ENDIF}

    function _getPrefBool(prefName: Widestring): boolean; virtual;
    function _getPrefString(prefName: Widestring): widestring; virtual;
    function _getPrefInt(prefName: Widestring): integer; virtual;

  public
    { Public declarations }
{$IFDEF EXODUS}
    constructor Create(Owner: TComponent); override;
{$ELSE}
    constructor Create(Owner: TComponent; controller: IExodusController);
{$ENDIF}

    procedure Invalidate(); override;
    procedure CopyAll(); virtual;
    procedure Copy(); virtual;
    procedure ScrollToBottom(); virtual;
    procedure Clear(); virtual; // Clear the msg list
    procedure Reset(); virtual; // Clear the msg list and reset last date, last nick, etc. (Currently used in IEMsgList)
    procedure setContextMenu(popup: TTntPopupMenu); virtual;
    procedure setDragOver(event: TDragOverEvent); virtual;
    procedure setDragDrop(event: TDragDropEvent); virtual;
    procedure DisplayMsg(Msg: TJabberMessage; AutoScroll: boolean = true); virtual;
    procedure DisplayPresence(nick, txt: Widestring; timestamp: string; dtTimestamp: TDateTime); virtual;
    function  getHandle(): THandle; virtual;
    function  getObject(): TObject; virtual;
    function  empty(): boolean; virtual;
    function  getHistory(): Widestring; virtual;
    procedure Save(fn: string); virtual;
    procedure populate(history: Widestring); virtual;
    procedure setupPrefs(); virtual;
    procedure setTitle(title: Widestring); virtual;
    procedure refresh(); virtual; // start dock
    procedure ready(); virtual;  // form up, (un)dock done, etc.

    procedure DisplayComposing(msg: Widestring); virtual;
    procedure HideComposing(); virtual;
    function  isComposing(): boolean; virtual;
    procedure DisplayRawText(txt: Widestring); virtual;

    property Handle: THandle read getHandle;
    property winObject: TObject read getObject;
  end;

{$IFDEF EXODUS}
  function MsgListFactory(Owner: TComponent;
                          Parent: TWinControl;
                          ListName: widestring = 'msg_list_frame'): TfBaseMsgList;
{$ENDIF}

implementation

{$R *.dfm}

{$IFDEF EXODUS}
uses
    Session,
    RTFMsgList,
    IEMsgList;
{$ENDIF}

const
    RTF_MSGLIST = 0;
    HTML_MSGLIST = 1;

{$IFDEF EXODUS}
function MsgListFactory(Owner: TComponent; Parent: TWinControl; ListName: widestring): TfBaseMsgList;
 var
    mtype: integer;
begin
    mtype := MainSession.prefs.getInt('msglist_type');
    if (mtype = HTML_MSGLIST) then
        Result := TfIEMsgList.Create(Owner)
    else if (mtype = RTF_MSGLIST) then
        Result := TfRTFMsgList.Create(Owner)
    else Result := TfRTFMsgList.Create(Owner);

    Result.Parent := Parent;
    Result.Name := ListName;
    Result.Align := alClient;
    Result.Visible := true;
end;
{$ENDIF}

{$IFDEF EXODUS}
constructor TfBaseMsgList.Create(Owner: TComponent);
{$ELSE}
constructor TfBaseMsgList.Create(Owner: TComponent; controller: IExodusController);
{$ENDIF}
begin
    inherited Create(Owner);
    _base := Owner;
{$IFNDEF EXODUS}
    _controller := controller;
{$ENDIF}
end;

procedure TfBaseMsgList.Invalidate();
begin
    //
end;

procedure TfBaseMsgList.CopyAll();
begin
    //
end;

procedure TfBaseMsgList.Copy();
begin
    //
end;

procedure TfBaseMsgList.ScrollToBottom();
begin
    //
end;

procedure TfBaseMsgList.Clear();
begin
    //
end;

procedure TfBaseMsgList.Reset();
begin
    //
end;

procedure TfBaseMsgList.setContextMenu(popup: TTntPopupMenu);
begin
    //
end;

function TfBaseMsgList.getHandle(): THandle;
begin
    Result := 0;
end;

function TfBaseMsgList.getObject(): TObject;
begin
    Result := nil;
end;

procedure TfBaseMsgList.DisplayMsg(Msg: TJabberMessage; AutoScroll: boolean = true);
begin
    // NOOP
end;

procedure TfBaseMsgList.DisplayPresence(nick, txt: Widestring; timestamp: string; dtTimestamp: TDateTime);
begin
    // NOOP
end;

procedure TfBaseMsgList.Save(fn: string);
begin
    // NOOP
end;

procedure TfBaseMsgList.populate(history: Widestring);
begin
    // NOOP
end;

procedure TfBaseMsgList.setupPrefs();
begin
    // NOOP
end;

function TfBaseMsgList.empty(): boolean;
begin
    Result := true;
end;

function TfBaseMsgList.getHistory(): Widestring;
begin
    Result := '';
end;

procedure TfBaseMsgList.setDragOver(event: TDragOverEvent);
begin
    // NOOP
end;

procedure TfBaseMsgList.setDragDrop(event: TDragDropEvent);
begin
    // NOOP
end;

procedure TfBaseMsgList.setTitle(title: Widestring);
begin
    // NOOP
end;

procedure TfBaseMsgList.ready();
begin
    // NOOP
end;

procedure TfBaseMsgList.refresh();
begin
    // NOOP
end;

procedure TfBaseMsgList.DisplayComposing(msg: Widestring);
begin
    // NOOP
end;

procedure TfBaseMsgList.DisplayRawText(txt: Widestring); 
begin
    // NOOP
end;

procedure TfBaseMsgList.HideComposing();
begin
    // NOOP
end;

function TfBaseMsgList.IsComposing(): boolean;
begin
    result := false;
end;

{---------------------------------------}
function TfBaseMsgList._getPrefBool(prefName: Widestring): boolean;
begin
{$IFDEF EXODUS}
    Result := MainSession.Prefs.getBool(prefName);
{$ELSE}
    Result := false;
    if (_controller = nil) then exit;

    Result := _controller.GetPrefAsBool(prefName);
{$ENDIF}
end;

{---------------------------------------}
function TfBaseMsgList._getPrefString(prefName: Widestring): widestring;
begin
{$IFDEF EXODUS}
    Result := MainSession.Prefs.getString(prefName);
{$ELSE}
    Result := '';
    if (_controller = nil) then exit;

    Result := _controller.GetPrefAsString(prefName);
{$ENDIF}
end;

{---------------------------------------}
function TfBaseMsgList._getPrefInt(prefName: Widestring): integer;
begin
{$IFDEF EXODUS}
    Result := MainSession.Prefs.getInt(prefName);
{$ELSE}
    Result := 0;
    if (_controller = nil) then exit;

    Result := _controller.GetPrefAsInt(prefName);
{$ENDIF}
end;


end.
