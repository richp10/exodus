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
unit ExVcardCache;


interface

uses Classes, Exodus_TLB, Unicode, XMLVCardCache, XMLTag, SyncObjs, Windows;

type
  TExVCardCache = class;

  TExVCardCacheLoader = class(TThread)
  private
    _owner: TExVCardCache;
    _list: TWidestringList;

    constructor Create(cache: TExVCardCache; data: TWidestringList);

  public
    destructor Destroy(); override;

    procedure Execute(); override;
  end;
  TExVCardCache = class(TXMLVCardCache)
  private
    _loader: TExVCardCacheLoader;
    _crit: TCriticalSection;
    _depResolver: TObject; //TSimpleDependancyHandler;

    procedure LoadFinished();
  protected
    procedure OnDependancyReady(tag: TXMLTag);
    procedure Load(cache: TWidestringList); override;
    procedure SaveEntry(vcard: TXMLVCardCacheEntry); override;
    procedure DeleteEntry(vcard: TXMLVCardCacheEntry); override;

  public
    constructor Create(js: TObject); override;
    destructor Destroy(); override;

  end;

implementation

uses AvatarCache, ComObj, SysUtils, Session, XMLParser, XMLUtils, SQLUtils, COMExodusDataTable, ExSession;

const
    VCARD_SQL_SCHEMA_TABLE: Widestring = 'CREATE TABLE vcard_cache (' +
            'jid TEXT, ' +
            'datetime FLOAT, ' +
            'xml TEXT, ' +
            'hash TEXT);';
    VCARD_SQL_SCHEMA_INDEX: Widestring = 'CREATE INDEX vcard_cache_jid_idx ON vcard_cache (jid);';

    VCARD_SQL_LOAD: Widestring = 'SELECT * FROM vcard_cache;';
    VCARD_SQL_INSERT: Widestring = 'INSERT INTO vcard_cache (jid,datetime,xml,hash) VALUES (''%s'',%8.6f,''%s'',''%s'');';
    VCARD_SQL_DELETE: Widestring = 'DELETE FROM vcard_cache where (jid = ''%s'');';

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
constructor TExVCardCacheLoader.Create(cache: TExVCardCache; data: TWidestringList);
begin
    inherited Create(true);

    _owner := cache;
    _list := data;
end;
{---------------------------------------}
destructor TExVCardCacheLoader.Destroy;
begin
    inherited;
end;

{---------------------------------------}
procedure TExVCardCacheLoader.Execute();
var
    cache: TWidestringList;
    tag: TXMLTag;
    pending: TXMLVCardCacheEntry;
    parser: TXMLTagParser;
    dt, currDT: TDateTime;
    jid, xml, hash, sql: Widestring;
    rst: IExodusDataTable;
    idx: Integer;
    colJid, colDT, colXML, colHash: Integer;
    skipped: TWidestringList;

    procedure _initialize();
    begin
        Avatars.Load();
        if DataStore.CheckForTableExistence('vcard_cache') then exit;

        try
            DataStore.ExecSQL(VCARD_SQL_SCHEMA_TABLE);
            DataStore.ExecSQL(VCARD_SQL_SCHEMA_INDEX);
        except
            //TODO:  loggit!!
        end;
    end;
    function _queryTable(): Boolean;
    begin
        Result := false;
        if not DataStore.GetTable(VCARD_SQL_LOAD, rst) then exit;
        if rst.RowCount = 0 then exit;
        Result := rst.FirstRow();
        if Result and (rst.GetFieldIndex('hash') = -1) then begin
            //table needs altering
            DataStore.ExecSQL('alter table vcard_cache add hash TEXT;');
            Result := _queryTable();
        end;
    end;
begin
    _initialize();

    cache := _list;
    currDT := Now() - _owner.TimeToLive;
    skipped := TWidestringList.Create();
    parser := TXMLTagParser.Create();
    try
        //query for cache
        rst := TExodusDataTable.Create() as IExodusDataTable;
        if _queryTable() then begin
            colJid := rst.GetFieldIndex('jid');
            colDT := rst.GetFieldIndex('datetime');
            colXML := rst.GetFieldIndex('xml');
            colHash := rst.GetFieldIndex('hash');
            for idx := 0 to rst.RowCount - 1 do begin
                jid := rst.GetField(colJid);
                dt := rst.GetFieldAsDouble(colDT);
                xml := rst.GetField(colXML);
                hash := rst.GetField(colHash);
                rst.NextRow();
                skipped.Add(jid);

                if (jid = '') then continue;
                if (cache.IndexOf(jid) <> -1) then continue;
                if (currDT > dt) then continue;
                if (xml = '') then continue;

                xml := XML_UnEscapeChars(UTF8Decode(xml));
                parser.ParseString(xml);
                if (parser.Count = 0) then continue;
                tag := parser.popTag();

                pending := TXMLVCardCacheEntry.Create(_owner, jid);
                pending.Load(tag);
                pending.TimeStamp := dt;

                if not pending.IsValid then continue;
                cache.AddObject(jid, pending);
                pending.Picture := Avatars.Find(jid);

                skipped.Delete(skipped.Count - 1);
            end;
        end;

        //remove stale
        while (skipped.Count > 0) do begin
            jid := skipped[0];
            skipped.Delete(0);
            sql := Format(VCARD_SQL_DELETE, [str2sql(UTF8Encode(jid))]);
            DataStore.ExecSQL(sql);
        end;
    except
        //TODO:  loggit!!
    end;

    skipped.Free();
    parser.Free();

    _owner.LoadFinished();
end;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
type
  PVCardOpEntry = ^TVCardOpEntry;
  TVCardOpEntry = record
    SQL: Widestring;
  end;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
constructor TExVCardCache.Create(js: TObject);
begin
    inherited;
    _depResolver := TSimpleAuthResolver.create(Self.OnDependancyReady, DEPMOD_LOGGED_IN);
end;

{---------------------------------------}
destructor TExVCardCache.Destroy();
begin
    _crit.Free();
    _depResolver.Free();
    inherited;
end;

procedure TExVCardCache.OnDependancyReady(tag: TXMLTag);
var
    loader: TExVCardCacheLoader;
begin
    repeat
        _crit.Acquire();
        loader := _loader;
        _crit.Release();

        try
            if (loader <> nil) then loader.WaitFor();
        except
            //catch possible race-to-the-death
        end;
    until (loader = nil);
    TAuthDependancyResolver.SignalReady(DEPMOD_VCARD_CACHE);
end;

{---------------------------------------}
procedure TExVCardCache.LoadFinished();
begin
    _crit.Acquire();
    _loader := nil;
    _crit.Release();
end;
{---------------------------------------}
procedure TExVCardCache.Load(cache: TWidestringList);
begin
    _crit := TCriticalSection.Create();
    _loader := TExVCardCacheLoader.Create(Self, cache);
    _loader.Resume();
end;
{---------------------------------------}
procedure TExVCardCache.SaveEntry(vcard: TXMLVCardCacheEntry);
var
    tag: TXMLTag;
    hash, sql: Widestring;
begin
    if (vcard = nil) then exit;

    if (vcard.Picture <> nil) then
        hash := vcard.Picture.getHash()
    else
        hash := '';

    tag := TXMLTag.Create('iq');
    tag.setAttribute('from', vcard.Jid);
    vcard.fillTag(tag, false);

    try
        if (hash <> '') then
            Avatars.Add(vcard.Jid, vcard.Picture);
        sql := Format(VCARD_SQL_INSERT, [
                str2sql(UTF8Encode(vcard.Jid)),
                vcard.Timestamp,
                str2sql(UTF8Encode(XML_EscapeChars(tag.XML))),
                str2sql(UTF8Encode(hash))
        ]);
        DataStore.ExecSQL(sql);
    except
        //TODO:  loggit
    end;

    tag.Free();

    inherited;
end;
{---------------------------------------}
procedure TExVCardCache.DeleteEntry(vcard: TXMLVCardCacheEntry);
var
    sql: Widestring;
begin
    if (vcard = nil) then exit;

    try
        Avatars.Remove(vcard.Picture);
        sql := Format(VCARD_SQL_DELETE, [str2sql(UTF8Encode(vcard.Jid))]);
        DataStore.ExecSQL(sql);
    except
    end;

    inherited;
end;


end.
