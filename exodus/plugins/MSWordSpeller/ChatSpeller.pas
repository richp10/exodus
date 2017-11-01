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
unit ChatSpeller;

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
    Word2000, Exodus_TLB,
    ComCtrls, RichEdit2, ExRichEdit, SysUtils, Graphics,
    ComObj, ActiveX, ExWordSpeller_TLB, StdVcl;

type
  TChatSpeller = class(TAutoObject, IExodusChatPlugin)
  protected
    function onAfterMessage(var Body: WideString): WideString; safecall;
    procedure onBeforeMessage(var Body: WideString); safecall;
    procedure onContextMenu(const ID: WideString); safecall;
    procedure onKeyPress(const Key: WideString); safecall;
    procedure onRecvMessage(const Body, xml: WideString); safecall;
    procedure onClose; safecall;
    procedure onMenu(const ID: WideString); safecall;
    procedure onNewWindow(HWND: Integer); safecall;
    { Protected declarations }
  private
    _word: TWordApplication;
    _chat: IExodusChat;
    _msgout: TExRichEdit;
  public
    reg_id: integer;
    constructor Create(word_app: TWordApplication; chat_controller: IExodusChat);
  end;

implementation

uses ComServ;

const
    // space, tab, LF, CR, !, ,, .
    WhitespaceChars = [#32, #09, #10, #13, #33, #44, #46];

constructor TChatSpeller.Create(word_app: TWordApplication;
    chat_controller: IExodusChat);
begin
    inherited Create();
    _word := word_app;
    _chat := chat_controller;
    _MsgOut := nil;
end;

function TChatSpeller.onAfterMessage(var Body: WideString): WideString;
begin
    // a msg is about to be sent
end;

procedure TChatSpeller.onBeforeMessage(var Body: WideString);
begin
    // a msg is being checked
end;

procedure TChatSpeller.onContextMenu(const ID: WideString);
begin
    // a menu was clicked
end;

procedure TChatSpeller.onKeyPress(const Key: WideString);
var
    adr: integer;
    tmps: String;
    k: Char;
    ok: boolean;
    last, cur: longint;
    word: WideString;
begin
    if (_MsgOut = nil) then begin
        adr := _chat.getMagicInt(Ptr_MsgInput);
        _MsgOut := TExRichEdit(Pointer(adr)^);
        end;

    tmps := Key;
    k := tmps[1];

    if ((k in WhitespaceChars) and (_MsgOut.SelStart > 0)) then begin
        // check spelling for this word
        cur := _MsgOut.SelStart;
        last := cur;

        // find the last word break..
        while ((last > 0) and ((_MsgOut.Text[last] in WhitespaceChars) = false)) do
            dec(last);

        word := Trim(Copy(_MsgOut.Text, last, (cur - last) + 1));
        ok := _word.CheckSpelling(word);
        with _MsgOut do begin
            SelStart := last;
            SelLength := (cur - last);
            if (ok) then begin
                SelAttributes.Color := clBlack;
                SelAttributes.Style := [];
                end
            else begin
                SelAttributes.Color := clRed;
                SelAttributes.UnderlineType := ultWave;
                SelAttributes.Style := [fsUnderline];
                end;
            SelStart := cur;
            SelLength := 0;
            SelAttributes.Color := clBlack;
            SelAttributes.Style := [];
            end;
        end;
end;

procedure TChatSpeller.onRecvMessage(const Body, xml: WideString);
begin
    // a msg was just received
end;

procedure TChatSpeller.onClose;
begin
    // the chat session is closing.
    _chat.UnRegister(reg_id);
end;

procedure TChatSpeller.onMenu(const ID: WideString);
begin
    // a menu was clicked
end;

procedure TChatSpeller.onNewWindow(HWND: Integer);
begin
    // we have a new window assigned to us
    _MsgOut := nil;
end;


initialization
  TAutoObjectFactory.Create(ComServer, TChatSpeller, Class_ChatSpeller,
    ciMultiInstance, tmApartment);
end.
