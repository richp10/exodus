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
unit DNSUtils;


interface

uses
  SysUtils, Classes, Windows, Session,  
  IdBaseComponent, IdComponent, IdUDPBase, IdUDPClient,
  IdDNSResolver;

    {
        Stuff for IpHlp.dll, which is 98+ from Iphlpapi.h
        FIXED_INFO contains all the bits we need,
        including a linked list *sigh* of the DNS servers.

        for more docs, see:
        http://msdn.microsoft.com/library/default.asp?url=/library/en-us/iphlp/iphlp/fixed_info.asp
    }
const
    MAX_HOSTNAME_LEN = 128;
    MAX_SCOPE_ID_LEN = 256;
    DNS_TIMEOUT = 3000; // milleseconds.

type
    TIP_ADDRESS_STRING = array[0..15] of char;

    PTIP_ADDRESS_STRING = ^TIP_ADDRESS_STRING;
    PTIP_ADDR_STRING = ^TIP_ADDR_STRING;
    PTFixedInfo = ^TFixedInfo;

    TIP_ADDR_STRING = packed record
        next: PTIP_ADDR_STRING;         // next record in the list
        ipAddress: TIP_ADDRESS_STRING;  // the ip addr
        ipMask: TIP_ADDRESS_STRING;     // the ip mask
        context: DWORD;                 // use this for AddIPAddress or DeleteIPAddress
    end;

    TFixedInfo = packed record
        hostName: array[1..MAX_HOSTNAME_LEN + 4] of char;
        domainName: array[1..MAX_HOSTNAME_LEN + 4] of char;
        currentDNSServer: PTIP_ADDR_STRING;
        dnsServerList: TIP_ADDR_STRING;
        nodeType: word;
        scopeID: array[1..MAX_SCOPE_ID_LEN + 4] of char;
        enableRouting: word;
        enableProxy: word;
        enableDNS: word;
    end;

    // Real stuff for actually doing DNS lookups.
    TDNSResolverThread = class(TThread)
    protected
        _resolver: TIdDNSResolver;
        _srv: Widestring;
        _a: Widestring;
        _ip: string;
        _p: Word;
        _session: TJabberSession;
        _res: boolean;
    public
        procedure Execute(); override;
        procedure SendResult();
    end;

procedure GetSRVAsync(Session: TJabberSession; Resolver: TIdDNSResolver;
    srv_req, a_req: Widestring);
procedure CancelDNS();
function GetSRVRecord(Resolver: TIdDNSResolver; srv_req, a_req: Widestring;
    var ip: string; var port: Word): boolean;
function GetNameServers(): string;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
implementation

uses
    Stringprep, XMLTag, Registry, IdException;

const
    IpHlpDLL = 'IPHLPAPI.DLL'; // DO NOT TRANSLATE

var
    cur_thd: TDNSResolverThread;
    dns_servers: string;
    dns_list: TStringlist;

{---------------------------------------}
procedure GetSRVAsync(Session: TJabberSession; Resolver: TIdDNSResolver;
    srv_req, a_req: Widestring);
begin
    cur_thd := TDNSResolverThread.Create(true);
    cur_thd._session := Session;

    // use stringprep for idn's
    cur_thd._a := xmpp_nameprep(a_req);
    cur_thd._srv := Lowercase(srv_req);
    cur_thd._resolver := Resolver;
    cur_thd.FreeOnTerminate := true;
    cur_thd.Resume();
end;

{---------------------------------------}
procedure CancelDNS();
begin
    if (cur_thd <> nil) then
        cur_thd.Terminate();
end;

{---------------------------------------}
procedure TDNSResolverThread.Execute();
begin
    _res := GetSRVRecord(_resolver, _srv, _a, _ip, _p);
    Synchronize(SendResult);
    cur_thd := nil;
end;

{---------------------------------------}
procedure TDNSResolverThread.SendResult();
var
    t: TXMLTag;
begin
    if (_res) then begin
        // it worked..
        t := TXMLTag.Create('dns');
        if (_p > 0) then
            t.setAttribute('type', 'srv')
        else
            t.setAttribute('type', 'a');
        t.setAttribute('ip', _ip);
        t.setAttribute('port', IntToStr(_p));
    end
    else begin
        // failed.
        t := TXMLTag.Create('dns');
        t.setAttribute('type', 'failed');
    end;
    _session.FireEvent('/session/dns', t);
    t.Free();
end;

{---------------------------------------}
function GetNameServers(): string;
var
    OSVersionInfo32: OSVERSIONINFO;
    iphlp: THandle;
    info: PTFixedInfo;
    info_size: longint;
    next_server: PTIP_ADDR_STRING;
    res: integer;
    GetNetworkParams: function(FixedInfo: PTFixedInfo; pOutPutLen: PULONG): DWORD; stdcall;
begin

    // Look in different places depending on OS.
    Result := '';
    OSVersionInfo32.dwOSVersionInfoSize := SizeOf(OSVersionInfo32);
    GetVersionEx(OSVersionInfo32);
    if ((OSVersionInfo32.dwPlatformID = VER_PLATFORM_WIN32_WINDOWS) and
        (OSVersionInfo32.dwMinorVersion = 0)) then begin
        // WIN 95
        exit;
    end
    else begin
        // Everything else can use GetNetworkParams from iphlpapi.dll
        info_size := 0;
        iphlp := LoadLibrary(IpHlpDLL);
        if (iphlp = 0) then exit;

        try
            GetNetworkParams := GetProcAddress(iphlp, 'GetNetworkParams');
            if (@GetNetworkParams = nil) then exit;

            // find out how much mem we need
            res := GetNetworkParams(nil, @info_size);
            if (res <> ERROR_BUFFER_OVERFLOW) then exit;

            // allocate it.
            GetMem(info, info_size);
            res := GetNetworkParams(info, @info_size);
            if (res <> ERROR_SUCCESS) then begin
                FreeMem(info);
                exit;
            end;

            // walk the list and build up space delimited list.
            Result := info^.dnsServerList.ipAddress;
            next_server := info^.dnsServerList.next;
            while (next_server <> nil) do begin
                if (Result <> '') then Result := Result + ' ';
                Result := Result + next_server^.ipAddress;
                next_server := next_server.next;
            end;
            FreeMem(info);
        finally
            FreeLibrary(iphlp);
        end;
    end;
end;

{---------------------------------------}
function GetSRVRecord(Resolver: TIdDNSResolver; srv_req, a_req: Widestring;
    var ip: string; var port: Word): boolean;
var
    idx, i: integer;
    lo_pri, cur_w, cur: integer;
    srv: TSRVRecord;
    ar: TARecord;
begin
    // Make a SRV request first..
    // if that fails, fall back on A Records

    if (dns_list.Count = 0) then begin
        dns_servers := GetNameServers();
        if (dns_servers = '') then begin
            ip := a_req;
            port := 0;
            Result := false;
            exit;
        end;

        dns_list.Clear();
        dns_list.Delimiter := ' ';
        dns_list.DelimitedText := dns_servers;

        if (dns_list.Count = 0) then begin
            ip := a_req;
            port := 0;
            Result := false;
            exit;
        end;
    end;

    // iterate over all possible DNS servers if something fails
    idx := 0;
    ip := '';
    port := 0;
    while ((ip = '') and (idx < dns_list.count)) do begin
        Resolver.Host := dns_list[idx];
        idx := idx + 1;

        // Use this for testing
        // Resolver.Host := '192.168.2.1';

        Resolver.ReceiveTimeout := DNS_TIMEOUT;
        Resolver.AllowRecursiveQueries := true;

        try
            Resolver.QueryRecords := [qtSRV];
            Resolver.Resolve(srv_req);

            // Worked... Pick the correct SRV Record.. Lowest priority, highest weight.
            lo_pri := 65535;
            cur := -1;
            cur_w := 0;
            for i := 0 to Resolver.QueryResult.Count - 1 do begin
                if (Resolver.QueryResult[i] is TSRVRecord) then begin
                    srv := TSRVRecord(Resolver.QueryResult[i]);
                    if (srv.Priority < lo_pri) then begin
                        cur := i;
                        lo_pri := srv.Priority;
                        cur_w := srv.Weight;
                    end
                    else if ((srv.Priority = lo_pri) and (srv.Weight > cur_w)) then begin
                        cur := i;
                        cur_w := srv.Weight;
                    end;
                end;
            end;

            if (cur = -1) then begin
                // it worked, but we got 0 results back
                raise EIdDNSResolverError.Create('No SRV records');
            end
            else begin
                assert(cur < Resolver.QueryResult.Count);
                srv := TSRVRecord(Resolver.QueryResult[cur]);
                ip := srv.IP;
                port := srv.Port;
                a_req := srv.IP;
            end;
        except
            on EAssertionFailed do begin
                // jump to the next DNS server
                continue;
            end;
            on EIdDnsResolverError do begin
                try
                    Resolver.QueryRecords := [qtA];
                    Resolver.Resolve(a_req);
                except
                    // jump to the next DNS server
                    continue;
                end;
            end
            else begin
                continue;
            end;
        end;

        // Check to see if we have an A Record matching this name
        for i := 0 to Resolver.QueryResult.Count - 1 do begin
            if (Resolver.QueryResult[i] is TARecord) then begin
                ar := TARecord(Resolver.QueryResult[i]);
                if (ar.Name = a_req) then begin
                    ip := ar.IPAddress;
                    break;
                end;
            end;
        end;
    end;
    
    Result := (ip <> '');
end;

initialization
    dns_servers := '';
    dns_list := TStringlist.Create();

finalization
    FreeAndNil(dns_list);

end.
