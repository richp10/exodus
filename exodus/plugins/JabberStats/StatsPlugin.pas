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
unit StatsPlugin;



{$WARN SYMBOL_PLATFORM OFF}

interface

uses
    XMLParser, XMLTag, 
    Exodus_TLB, Classes, ComObj, ActiveX, ExJabberStats_TLB, StdVcl;

type
  TStatsPlugin = class(TAutoObject, IExodusPlugin)
  protected
    procedure Configure; safecall;
    procedure NewChat(const jid: WideString; const Chat: IExodusChat);
      safecall;
    procedure NewRoom(const jid: WideString; const Room: IExodusChat);
      safecall;
    procedure Process(const xpath, event, xml: WideString); safecall;
    procedure Shutdown; safecall;
    procedure Startup(const ExodusController: IExodusController); safecall;
    function NewIM(const jid: WideString; var Body, Subject: WideString;
      const XTags: WideString): WideString; safecall;
    procedure NewOutgoingIM(const jid: WideString;
      const InstantMsg: IExodusChat); safecall;
    //IExodusMenuListener
    procedure OnMenuItemClick(const menuID : WideString; const xml : WideString); safecall;
  private
    _parser: TXMLTagParser;
    _exodus: ExodusController;
    // _stat_file: TextFile;
    _stream: TFileStream;
    _filename: string;
    _cb: integer;

    procedure _setupFile();
  end;

resourcestring
    sStreamError = 'The JabberStats plugin could not initialize the stats file. You shoud configure it and provide a path which exists and you have write permissions.';

implementation

uses
    ComServ, Config, Controls, Dialogs, SysUtils;

procedure TStatsPlugin.Configure;
var
    fConfig: TfrmConfig;
begin
    fConfig := TfrmConfig.Create(nil);
    fConfig.txtFilename.Text := _filename;

    if (fConfig.ShowModal() = mrOK) then begin
        _filename := fConfig.txtFilename.Text;
        _exodus.setPrefAsString('stats_filename', _filename);
    end;

    fConfig.Free();
end;

procedure TStatsPlugin.NewChat(const jid: WideString;
  const Chat: IExodusChat);
begin

end;

procedure TStatsPlugin.NewRoom(const jid: WideString;
  const Room: IExodusChat);
begin

end;

procedure TStatsPlugin.Process(const xpath, event, xml: WideString);
var
    from, t, ns, dt, size, op: Widestring;
    buff: string;
    tag: TXMLTag;
begin
    // we are getting a packet
    _parser.ParseString(xml, '');
    if (_parser.Count = 0) then exit;

    tag := _parser.popTag();

    // from, packet-type, date/time, size
    from := tag.getAttribute('from');
    if (from = '') then from := '-server-';
    t := tag.Name;
    ns := tag.Namespace(true);
    if (ns = '') then ns := 'jabber:client';
    size := IntToStr(Length(xml));
    dt := FormatDateTime(LongDateFormat, Now());
    op := Format('%s '#9' %s '#9' %s '#9' %s '#9' %s '#13#10, [from, t, ns, dt, size]);
    buff := UTF8Encode(op);
    _stream.Write(Pointer(buff)^, Length(buff));
end;

procedure TStatsPlugin.Shutdown;
begin
    // CloseFile(_stat_file);
    _stream.Free();
    if (_cb >= 0) then
        _exodus.UnRegisterCallback(_cb);
    _parser.Free();
end;

procedure TStatsPlugin.Startup(const ExodusController: IExodusController);
begin
    _parser := TXMLTagParser.Create();
    _exodus := ExodusController;
    _filename := _exodus.getPrefAsString('stats_filename');

    if (_filename = '') then begin
        _filename := _exodus.getPrefAsString('spool_path');
        _filename := ExtractFilePath(_filename) + 'stats.txt';
    end;

    _setupFile();
end;

procedure TStatsPlugin._setupFile();
begin
    // close the old stream
    if (_stream <> nil) then
        _stream.Free();

    // Try to open a new one
    try
        if (FileExists(_filename)) then
            _stream := TFileStream.Create(_filename, fmOpenReadWrite,
                fmShareDenyNone)
        else
            _stream := TFileStream.Create(_filename, fmCreate, fmShareDenyNone);

        _exodus.setPrefAsString('stats_filename', _filename);
        _cb := _exodus.RegisterCallback('/log', Self);
    except
        MessageDlg(sStreamError, mtError, [mbOK], 0);
        _stream := nil;
        if (_cb >= 0) then
            _exodus.UnRegisterCallback(_cb);
    end;
end;


function TStatsPlugin.NewIM(const jid: WideString; var Body,
  Subject: WideString; const XTags: WideString): WideString;
begin

end;

procedure TStatsPlugin.NewOutgoingIM(const jid: WideString;
  const InstantMsg: IExodusChat);
begin

end;

//IExodusMenuListener
procedure TStatsPlugin.OnMenuItemClick(const menuID : WideString; const xml : WideString);
begin

end;

initialization
  TAutoObjectFactory.Create(ComServer, TStatsPlugin, Class_StatsPlugin,
    ciMultiInstance, tmApartment);
end.
