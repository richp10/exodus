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
unit AutoUpdate;


interface

uses
  Classes,
  IdHttp,
  XMLTag;

type
  TNewUrlEvent = procedure(url: string);

  TAutoUpdateThread = class(TThread)
  private
    { Private declarations }
    _url  : string;
    _pkey : Widestring;
    _available : boolean;
    _background : boolean;
    _onNew : TNewUrlEvent;
    _debug: Widestring;
    procedure checkDoUpdate();
    procedure debugMsg();

  protected
    procedure Execute; override;
  public
    property PKey : Widestring read _pkey write _pkey;
    property URL  : string read _url write _url;
    property Available : boolean read _available;
    property Background : boolean write _background;
    property OnNewUrl :  TNewUrlEvent write _onNew;
  end;

function InitAutoUpdate(background : boolean = true) : boolean;
procedure InitUpdateBranding();
procedure FireAutoUpdate(URL: string);

{*
const
    EXODUS_REG = '\Software\Jabber\Exodus';
*}    
{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
implementation

uses
    Controls, IQ, Dialogs,
    Forms, Registry, Session, ShellAPI, SysUtils,
    Windows, XMLUtils, PrefController;

{---------------------------------------}
function RoundDateTime(val: TDateTime) : TDateTime;
{
var
    f: TFormatSettings;
}
begin
    //GetLocaleFormatSettings(LANG_NEUTRAL, f);
    //Result := StrToDateTime(DateTimeToStr(val), f);
    //Result := StrToDateTime(DateTimeToStr(val, f), f);
    try
        Result := StrToDateTime(DateTimeToStr(val));
    except
        on EConvertError do
            Result := val;
    end;
end;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
function InitAutoUpdate(background : boolean = true) : boolean;
var
    url  : string;
    t    : TAutoUpdateThread;
begin
    result := false;
    if (background and (not MainSession.Prefs.getBool('auto_updates'))) then exit;

    // NOTE: if you want to do auto-update, the easiest way to turn it on is
    // to create a branding.xml next to your exodus.exe, which contains this:
    // <brand>
    //   <auto_update_url>http://exodus.jabberstudio.org/daily/setup.exe</auto_update_url>
    // </brand>
    url  := MainSession.Prefs.getString('auto_update_url');

    t := TAutoUpdateThread.Create(true);
    t.PKey := 'last_update';
    t.URL := url;
    t.Background := background;
    t.OnNewUrl := @FireAutoUpdate;
    t.FreeOnTerminate := true;
    if (background) then begin
        t.Resume();
    end
    else begin
        //t.Execute();
        //result := t.Available;
        //t.Terminate();
        t.Resume();
    end;
end;

{---------------------------------------}
procedure OnNewBrand(url : string);
var
    bfn : string;
    bfs : TFileStream;
    http : TIdHTTP;
begin
    bfn := ExtractFilePath(Application.EXEName) + 'branding.new';
    bfs := TFileStream.Create(bfn, fmOpenWrite or fmCreate);
    http := nil;
    try
      http := TIdHTTP.Create(nil);
      http.HandleRedirects := true;
      MainSession.Prefs.setProxy(http);

      // just eat exceptions here
      try
        http.Get(url, bfs);
          bfs.Free();
          if (http.ResponseCode = 200) then begin
              DeleteFile(pchar(ExtractFilePath(Application.EXEName) + 'branding.xml'));
              RenameFile(bfn, 'branding.xml');
              MainSession.Prefs.setString('last_branding_update', DateTimeToStr(http.Response.LastModified));
              // Harumph.  There's no good way to reparse the branding file.  Even if
              // there was, there's no way to know where those prefs have been used
              // at this time.  Therefore, just wait patiently until the next time
              // the client starts up.
          end
          else
              DeleteFile(pchar(bfn));
      except
      end;

    finally
        if (http <> nil) then http.Free();
  end;
end;

{---------------------------------------}
procedure InitUpdateBranding();
var
    url  : string;
    t    : TAutoUpdateThread;
begin
    if (not MainSession.Prefs.getBool('auto_updates')) then exit;
    url  := MainSession.Prefs.getString('branding_url');
    if (url = '') then exit;

    t := TAutoUpdateThread.Create(true);
    t.URL := url;
    t.PKey := 'last_branding_update';
    t.Background := true;
    t.OnNewUrl := @OnNewBrand;
    t.FreeOnTerminate := true;
    t.Resume();
end;

{---------------------------------------}
{---------------------------------------}
{ TAutoUpdateThread }
{---------------------------------------}
{---------------------------------------}
procedure TAutoUpdateThread.Execute;
var
    http : TIdHTTP;
    last, rounded : TDateTime;
begin
    _available := false;
    http := nil;
    last := MainSession.Prefs.getSetDateTime(_pkey);

    _debug := 'AUTOUPDATE. Last = ' + DateTimeToStr(last);
    Synchronize(debugMsg);

    try
        http := TIdHTTP.Create(nil);
        http.HandleRedirects := true;
        MainSession.Prefs.setProxy(http);
        try
            http.Head(_url);
            if (http.ResponseCode <> 200) then begin
                exit;
            end;
        except
            exit;
        end;

        rounded := RoundDateTime(http.Response.LastModified);
        _debug := 'AUTOUPDATE: Rounded = ' + DateTimeToStr(rounded);
        Synchronize(debugMsg);

        if (rounded <= last) then begin
            if (rounded <> last) then
                MainSession.Prefs.setDateTime(_pkey, rounded);
            exit;
        end;

        if (Assigned(_onNew)) then begin
            if (_background) then
                synchronize(checkDoUpdate)
            else
                _onNew(_url);
        end;

        _available := true;
    finally
        if (http <> nil) then http.Free();
    end;
end;

{---------------------------------------}
procedure TAutoUpdateThread.debugMsg();
begin
    MainSession.FireEvent('/data/debug', nil, _debug);
end;

{---------------------------------------}
procedure TAutoUpdateThread.checkDoUpdate();
begin
    _onNew(_url);
end;

procedure FireAutoUpdate(URL: string);
var
    t: TXMLTag;
begin
    t := TXMLTag.Create('update');
    t.setAttribute('url', URL);
    MainSession.FireEvent('/session/gui/autoupdate', t);
end;

end.
