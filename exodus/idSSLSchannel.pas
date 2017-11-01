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
unit idSSLSchannel;
{$DEFINE SSPI_UNICODE}

interface

uses
  Classes,
  IdGlobal,
  IdSSPI,
  IdAuthenticationSSPI,
  JwaWinCrypt,
  JwaWinType,
  Windows,
  SysUtils,
  IdCoderMIME,
  IdIOHandlerSocket;

const
  UNISP_NAME_A    = 'Microsoft Unified Security Protocol Provider';

  TRUST_E_CERT_SIGNATURE_STR = 'The signature of the certificate cannot be verified.';
  CERT_E_UNTRUSTEDROOT_STR = 'A certification chain processed correctly but terminated in a root certificate not trusted by the trust provider.';
  CERT_E_UNTRUSTEDTESTROOT_STR = 'The root certificate is a testing certificate and policy settings disallow test certificates.';
  CERT_E_CHAINING_STR = 'A chain of certificates was not correctly created.';
  CERT_E_WRONG_USAGE_STR = 'The certificate is not valid for the requested usage.';
  CERT_E_EXPIRED_STR = 'A required certificate is not within its validity period.';
  CERT_E_VALIDITYPERIODNESTING_STR = 'The validity periods of the certification chain do not nest correctly.';
  CERT_E_PURPOSE_STR = 'A certificate is being used for a purpose that is not supported.';
  TRUST_E_BASIC_CONSTRAINTS_STR = 'The basic constraints of the certificate are invalid or missing.';
  CERT_E_ROLE_STR = 'A certificate that can only be used as an end entity is being used as a CA or visa versa.';
  CERT_E_CN_NO_MATCH_STR = 'Certificate does not match host: ';
  CRYPT_E_REVOKED_STR = 'The certificate or signature has been revoked.';
  CRYPT_E_REVOCATION_OFFLINE_STR = 'Because the revocation server was offline, the called function was not able to complete the revocation check.';
  CERT_E_REVOKED_STR = 'A certificate in the chain has been explicitly revoked by its issuer.';
  CERT_E_REVOCATION_FAILURE_STR = 'The revocation process could not continue. The certificates could not be checked.';

  TRUST_E_CERT_SIGNATURE = HRESULT($80096004);
  CERT_E_UNTRUSTEDTESTROOT = HRESULT($800B010D);
  CERT_E_WRONG_USAGE = HRESULT($800B0110);
  CERT_E_VALIDITYPERIODNESTING = HRESULT($800B0102);
  TRUST_E_BASIC_CONSTRAINTS = HRESULT($80096019);
  CERT_E_CN_NO_MATCH = HRESULT($800B010F);
  CRYPT_E_REVOKED = HRESULT($80092010);
  CRYPT_E_REVOCATION_OFFLINE = HRESULT($80092013);
  CERT_E_REVOKED = HRESULT($800B010C);
  CERT_E_REVOCATION_FAILURE = HRESULT($800B010E);

  SEC_I_CONTEXT_EXPIRED                = HRESULT($00090317);
  SCHANNEL_CRED_VERSION                = $00000004;

  SCH_CRED_NO_SYSTEM_MAPPER                  = $00000002;
  SCH_CRED_NO_SERVERNAME_CHECK               = $00000004;
  SCH_CRED_MANUAL_CRED_VALIDATION            = $00000008;
  SCH_CRED_NO_DEFAULT_CREDS                  = $00000010;
  SCH_CRED_AUTO_CRED_VALIDATION              = $00000020;
  SCH_CRED_USE_DEFAULT_CREDS                 = $00000040;
  SCH_CRED_DISABLE_RECONNECTS                = $00000080;

  SCH_CRED_REVOCATION_CHECK_END_CERT           = $00000100;
  SCH_CRED_REVOCATION_CHECK_CHAIN              = $00000200;
  SCH_CRED_REVOCATION_CHECK_CHAIN_EXCLUDE_ROOT = $00000400;
  SCH_CRED_IGNORE_NO_REVOCATION_CHECK          = $00000800;
  SCH_CRED_IGNORE_REVOCATION_OFFLINE           = $00001000;

  SP_PROT_TLS1_CLIENT                          = $00000080;

  SECPKG_ATTR_REMOTE_CERT_CONTEXT = $53;

  CERT_CHAIN_POLICY_IGNORE_NOT_TIME_VALID_FLAG = $00000001;
  CERT_CHAIN_POLICY_IGNORE_CTL_NOT_TIME_VALID_FLAG = $00000002;

type
  PPHMAPPER = ^PHMAPPER;
  PHMAPPER = ^HMAPPER;
  HMAPPER = record
  end;

  PSCHANNEL_CRED = ^SCHANNEL_CRED;
  SCHANNEL_CRED = record
    dwVersion: DWORD; // always SCHANNEL_CRED_VERSION
    cCreds: DWORD;
    paCred: PPCCERT_CONTEXT;
    hRootStore: HCERTSTORE;
    cMappers: DWORD;
    aphMappers: PPHMAPPER;
    cSupportedAlgs: DWORD;
    palgSupportedAlgs: ^ALG_ID;
    grbitEnabledProtocols: DWORD;
    dwMinimumCipherStrength: DWORD;
    dwMaximumCipherStrength: DWORD;
    dwSessionLifespan: DWORD;
    dwFlags: DWORD;
    reserved: DWORD;
  end;

  TEVP_MD = record
    Length: Cardinal;
    MD: PChar;
  end;

  SChannelX509 = class(TObject)
  private

  protected
    mX509:PCCERT_CONTEXT;
    mServerName:WideString;

    {
    function RSubject:TIdX509Name;
    function RIssuer:TIdX509Name;
    function RnotBefore:TDateTime;
    function RnotAfter:TDateTime;
    }
    function RFingerprint:TEVP_MD;
    function RFingerprintAsString:String;
  public
    Constructor Create(aX509: PPCCERT_CONTEXT; serverName: WideString); virtual;
    Destructor Destroy; override;
    //
    property Fingerprint: TEVP_MD read RFingerprint;
    property FingerprintAsString: String read RFingerprintAsString;
    {
    property Subject: TIdX509Name read RSubject;
    property Issuer: TIdX509Name read RIssuer;
    property notBefore: TDateTime read RnotBefore;
    property notAfter: TDateTime read RnotAfter;
    }
    function verifyCertificate(var error:WideString):Boolean;
    function getServerCertName():string;
    procedure setErrorMessage(errorType:DWORD; var error:WideString);
  end;

  TIdDataBuffer = class
  private
    m_Data: Pointer;
    m_Length: Cardinal;

  public
    constructor Create();
    destructor Destroy(); override;

    function Deque(len: Cardinal; limit: Cardinal; var dst): Cardinal;
    procedure Enque(len: Cardinal; var src);
    procedure Clear();
  end;
  TIdSchannelIOHandlerSocket = class(TIdIOHandlerSocket)
  private
    fPassThrough: Boolean;
    mSspiCalls: TSSPIInterface;
    m_phContext: PCtxtHandle;
    m_hContext: CtxtHandle;

    m_Connected: Boolean;

    m_CurrBodyLen: Integer;
    m_BodyLen: Integer;

    m_SecExtraBuffer: SecBuffer;

    m_phClientCreds: PCredHandle;
    m_ClientCreds: CredHandle;
    m_pSChannelCred: SCHANNEL_CRED;
    mServerName: WideString;
    mClientCert: PCCERT_CONTEXT;
    mClientCertId: string;

    mServerCert: SChannelX509;

    m_Buffer: TIdDataBuffer;
    skipRecv: Boolean;

    //
    procedure SetPassThrough(const Value: Boolean);
    procedure Init;
    procedure getServerCertificate;
  protected
    procedure OpenEncodedConnection; virtual;

    function EncryptSend(var ABuf; ALen: Integer): integer;
    function RecvDecrypt(var ABuf; ALen: integer): integer;
    function getMaxDataChunkSize(): Cardinal;
    function getMaxInitialChunkSize(): Cardinal;
    function ClientHandshakeLoop(var IoBuffer; var length: Cardinal;
      var extraData: SecBuffer): Boolean;

    procedure performHandShake;
    function initiateHandShake(dwSSPIFlags: Integer): SECURITY_STATUS;
    function finishHandShake(dwSSPIFlags: Integer): SECURITY_STATUS;

    procedure setupCredentials;
    procedure getCertificate;
    procedure decodeCertKey(var key: Pointer; var decodedLength: Cardinal; encodedString: string);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure initializeSchannel;

    procedure AfterAccept; override;
    procedure ConnectClient(const AHost: string; const APort: Integer; const ABoundIP: string;
     const ABoundPort: Integer; const ABoundPortMin: Integer; const ABoundPortMax: Integer;
     const ATimeout: Integer = IdTimeoutDefault); override;
    procedure Close; override;
    procedure Open; override;

    function Readable(AMSec: Integer = IdTimeoutDefault): Boolean; override;
    function Recv(var ABuf; ALen: integer): integer; override;
    function Send(var ABuf; ALen: integer): integer; override;

    //property SSLSocket: TIdSSLSocket read fSSLSocket write fSSLSocket;
    property PassThrough: Boolean read fPassThrough write SetPassThrough;
    property ServerName: WideString read mServerName write mServerName;
    property CertificateId: string write mClientCertId;
    property PeerCert: SChannelX509 read mServerCert;

    //property OnBeforeConnect: TIOHandlerNotify read fOnBeforeConnect write fOnBeforeConnect;
    property MaxDataChunkSize: Cardinal read getMaxDataChunkSize;
    property MaxIntialChunkSize: Cardinal read getMaxInitialChunkSize;
  published
    //property SSLOptions: TIdSSLOptions read fxSSLOptions write fxSSLOptions;
  end;

implementation

uses IdException, IdIOHandler;

procedure TIdSchannelIOHandlerSocket.Open;
begin
  inherited Open;
end;

procedure TIdSchannelIOHandlerSocket.Close;
begin
  inherited Close;
end;

procedure TIdSchannelIOHandlerSocket.ConnectClient(const AHost: string; const APort: Integer; const ABoundIP: string;
     const ABoundPort: Integer; const ABoundPortMin: Integer; const ABoundPortMax: Integer;
     const ATimeout: Integer = IdTimeoutDefault);
begin
  inherited ConnectClient(AHost, APort, ABoundIP, ABoundPort, ABoundPortMin, ABoundPortMax, ATimeout);
end;

procedure TIdSchannelIOHandlerSocket.AfterAccept;
begin
  //initializeSchannel;
end;

procedure TIdSchannelIOHandlerSocket.initializeSchannel;
begin
  setupCredentials;
  performHandShake;
end;

procedure TIdSchannelIOHandlerSocket.getCertificate;
var
  m_hCertStore: HCERTSTORE;
  sMy: LPCWSTR;
  testCert: PCCERT_CONTEXT;
  keyBlob: CRYPT_HASH_BLOB;
  key: Pointer;
  keyLength: DWORD;
begin
  if (mClientCertId = '') then
  begin
    mClientCert := nil;
    Exit;
  end;

  sMy := 'MY';
  m_hCertStore := CertOpenStore(CERT_STORE_PROV_SYSTEM_W, 0, 0,
    CERT_SYSTEM_STORE_CURRENT_USER, sMy);
  if (m_hCertStore <> nil) then
  begin
    // Decode the certificate id and get the certificate.
    decodeCertKey(key, keyLength, mClientCertId);
    try
      keyBlob.cbData := keyLength;
      keyBlob.pbData := key;
      testCert := CertFindCertificateInStore(m_hCertStore, X509_ASN_ENCODING, 0,
        CERT_FIND_KEY_IDENTIFIER, @keyBlob, nil);
    finally
      FreeMem(key, keyLength);
    end;

    mClientCert := testCert;

    CertCloseStore(m_hCertStore, 0);
  end;
end;

procedure TIdSchannelIOHandlerSocket.decodeCertKey(var key: Pointer; var decodedLength: Cardinal; encodedString: string);
var
  decodedString: string;
  decoder: TIdDecoderMIME;
begin
  decoder := TIdDecoderMIME.Create(nil);
  try
    decodedString := decoder.DecodeToString(encodedString);
    decodedLength := Length(decodedString);
    key := AllocMem(decodedLength);
    Move(Pointer(decodedString)^, key^, decodedLength);
  finally
    decoder.Free;
  end;
end;

procedure TIdSchannelIOHandlerSocket.setupCredentials;
var
  expirationDate: TimeStamp;
  ss: SECURITY_STATUS;
  exceptionStr: WideString;
begin
  m_pSChannelCred.dwVersion := SCHANNEL_CRED_VERSION;
  getCertificate;
  if (mClientCert <> nil) then
  begin
    m_pSChannelCred.cCreds := 1;
    m_pSChannelCred.paCred := @mClientCert;
  end else begin
    m_pSChannelCred.cCreds := 0;
    m_pSChannelCred.paCred := nil;
  end;
  m_pSChannelCred.grbitEnabledProtocols := 0;
  m_pSChannelCred.dwFlags := SCH_CRED_NO_DEFAULT_CREDS or SCH_CRED_MANUAL_CRED_VALIDATION;

  ss := mSspiCalls.FunctionTable.AcquireCredentialsHandleA(nil, UNISP_NAME_A,
    SECPKG_CRED_OUTBOUND, nil, @m_pSChannelCred, nil, nil, m_phClientCreds,
    @expirationDate);

  if (ss = SEC_E_NO_CREDENTIALS) then
  begin
    exceptionStr := 'Bad Certificate';
    raise EIdException.Create(exceptionStr);
  end;

  if (ss <> SEC_E_OK) then
  begin
    exceptionStr := 'Something bad happened when starting SChannel.';
    raise EIdException.Create(exceptionStr);
  end;

  if (mClientCert <> nil) then
  begin
    CertFreeCertificateContext(mClientCert);
    mClientCert := nil;
  end;
end;

function TIdSchannelIOHandlerSocket.initiateHandShake(dwSSPIFlags: Integer): SECURITY_STATUS;
var
  buffer: SecBuffer;
  bufferDesc: SecBufferDesc;
  dwSSPIOutFlags: ULONG;
  expirationDate: TimeStamp;
begin
  with bufferDesc do
  begin
    ulVersion := 0;
    cBuffers := 1;
    pBuffers := @buffer
  end;
  with buffer do
  begin
    cbBuffer := 0;
    BufferType := SECBUFFER_TOKEN;
    pvBuffer := nil;
  end;

  Result := mSspiCalls.FunctionTable.InitializeSecurityContextA(m_phClientCreds,
        nil, PAnsiChar(AnsiString(mServerName)), dwSSPIFlags, 0,
        0, nil, 0, m_phContext, @bufferDesc, @dwSSPIOutFlags, @expirationDate);

  inherited Send(buffer.pvBuffer^, buffer.cbBuffer);

  mSspiCalls.FunctionTable.FreeContextBuffer(buffer.pvBuffer);
end;

procedure TIdSchannelIOHandlerSocket.performHandShake;
var
  dwSSPIFlags: Integer;
  ss: SECURITY_STATUS;
  firstTime: Boolean;
  done: Boolean;
begin
  firstTime := True;
  done := False;

  dwSSPIFlags := ISC_REQ_ALLOCATE_MEMORY or ISC_REQ_USE_SUPPLIED_CREDS;

  while (not done) do
  begin
    if firstTime then
    begin
      ss := initiateHandShake(dwSSPIFlags);
      firstTime := False;
    end else begin
      ss := finishHandShake(dwSSPIFlags);
    end;

    done := ((SEC_I_CONTINUE_NEEDED <> ss) and (SEC_I_COMPLETE_AND_CONTINUE <> ss)
      and (SEC_E_INCOMPLETE_MESSAGE <> ss));
    if (ss = SEC_E_OK) then begin
      getServerCertificate;
    end;
  end;

  if (ss <> SEC_E_OK) then begin
      raise EIdException.Create('Could not complete SSL handshaking.');
  end;

end;

function TIdSchannelIOHandlerSocket.getMaxDataChunkSize;
var
  noUsed: SecPkgContext_StreamSizes;
  ss: SECURITY_STATUS;
begin
  ss := mSspiCalls.FunctionTable.QueryContextAttributesA(m_phContext,
    SECPKG_ATTR_STREAM_SIZES, @noUsed);
  if (ss = SEC_E_OK) then begin
    Result := noUsed.cbMaximumMessage;
  end
  else begin
    //TODO: loggit
    //raise Exception.Create('Could not get the Chunk Size for SChannel.');
    result := 65536;    //max possible chunk size
  end;
end;

function TIdSchannelIOHandlerSocket.getMaxInitialChunkSize;
var
  psecInfo: PSecPkgInfo;
  ss: SECURITY_STATUS;
begin
  ss := mSspiCalls.FunctionTable.QuerySecurityPackageInfoA(UNISP_NAME_A, @psecInfo);
  if (ss = SEC_E_OK) then begin
    Result := psecInfo.cbMaxToken;
  end
  else begin
    Result := 65536;
  end;
end;

procedure TIdSchannelIOHandlerSocket.OpenEncodedConnection;
begin
  initializeSchannel;
end;

function TIdSchannelIOHandlerSocket.Readable(AMSec: Integer): Boolean;
begin
    Result := skipRecv;
    if not Result then
        Result := inherited Readable(AMSec)
end;

function TIdSchannelIOHandlerSocket.Recv(var ABuf; ALen: integer): integer;
begin
  if fPassThrough then begin
    result := inherited Recv(ABuf, ALen);
  end
  else begin
    result := RecvDecrypt(ABuf, ALen);
  end;
end;

function TIdSchannelIOHandlerSocket.Send(var ABuf; ALen: integer): integer;
begin
  if fPassThrough then begin
    result := inherited Send(ABuf, ALen);
  end
  else begin
    result := EncryptSend(ABuf, ALen);
  end;
end;

function TIdSchannelIOHandlerSocket.finishHandShake(dwSSPIFlags: Integer): SECURITY_STATUS;
var
  inbuffer: array[0..1] of SecBuffer;
  recvBuffer: PByte;
  pRecvBuffer: PByte;
  recvBufferSize: Cardinal;
  dwSSPIOutFlags: Cardinal;
  expirationDate: TimeStamp;
  bufferDesc: SecBufferDesc;
  buffer: SecBuffer;
  recvLength: Cardinal;
  inbufferDesc: SecBufferDesc;
  pExtraBuffer: PSecBuffer;
  //I: Integer;
begin
  Result := SEC_E_OK;

  bufferDesc.ulVersion := 0;
  bufferDesc.cBuffers := 1;
  bufferDesc.pBuffers := @buffer;

  buffer.cbBuffer := 0;
  buffer.BufferType := SECBUFFER_TOKEN;
  buffer.pvBuffer := nil;

  //SetLength(recvBuffer, MaxIntialChunkSize);
  //recvLength := inherited Recv(recvBuffer, MaxIntialChunkSize);
  recvBufferSize := MaxIntialChunkSize;
  recvBuffer := AllocMem(recvBufferSize);
  try
    recvLength := inherited Recv(recvBuffer^, recvBufferSize);
    if ((recvLength > recvBufferSize) or (recvLength = 0)) then
    begin
      raise EIdException.Create('The socket must have closed. SSL init failed.');
    end;

    recvLength := m_Buffer.Deque(recvLength, recvBufferSize, recvBuffer^);
    inbufferDesc.ulVersion := 0;
    inbufferDesc.cBuffers := 2;
    inbufferDesc.pBuffers := @inbuffer;

    inbuffer[0].cbBuffer := recvLength;
    inbuffer[0].BufferType := SECBUFFER_TOKEN;
    inbuffer[0].pvBuffer := recvBuffer;

    inbuffer[1].cbBuffer := 0;
    inbuffer[1].BufferType := SECBUFFER_EMPTY;
    inbuffer[1].pvBuffer := nil;

    dwSSPIOutFlags := 0;
    Result := mSspiCalls.FunctionTable.InitializeSecurityContextA(m_phClientCreds,
      m_phContext, nil, dwSSPIFlags, 0, 0, @inbufferDesc, 0,
      nil, @bufferDesc, @dwSSPIOutFlags, @expirationDate);

    if (Result = SEC_E_INCOMPLETE_MESSAGE) then
    begin
      m_Buffer.Enque(recvLength, recvBuffer^);
    end else if (Result < 0) then begin
      raise EIdException.Create('SSL Initialization did not work.');
    end;

    if (inbuffer[1].BufferType = SECBUFFER_EXTRA) then
    begin
      pExtraBuffer := @inbuffer[1];
      pRecvBuffer := recvBuffer;
      Inc(pRecvBuffer, recvLength);
      Dec(pRecvBuffer, pExtraBuffer.cbBuffer);
      m_Buffer.Enque(pExtraBuffer.cbBuffer, pRecvBuffer^);
    end;

    if ((Result = SEC_E_OK) or (Result = SEC_I_CONTINUE_NEEDED)) then
    begin
      inherited Send(buffer.pvBuffer^, buffer.cbBuffer);
      mSspiCalls.FunctionTable.FreeContextBuffer(buffer.pvBuffer);
    end;
  finally
    FreeMem(recvBuffer, recvBufferSize);
  end;
end;

procedure TIdSchannelIOHandlerSocket.getServerCertificate;
var
  ss: SECURITY_STATUS;
  serverCert: PCCERT_CONTEXT;
begin

  ss := mSspiCalls.FunctionTable.QueryContextAttributesA(m_phContext,
    SECPKG_ATTR_REMOTE_CERT_CONTEXT, @serverCert);
  if (ss <> SEC_E_OK) then
  begin
    raise EIdException.Create('Could not get the Server Certificate.');
  end;

  // SChannelX509 takes over ownership of the certificate. No need to release it.
  mServerCert := SChannelX509.Create(@serverCert, mServerName);
end;

procedure TIdSchannelIOHandlerSocket.SetPassThrough(const Value: Boolean);
begin
  if not Value then begin
    if Connected then begin
      OpenEncodedConnection;
    end;
  end;
  fPassThrough := Value;
end;

function TIdSchannelIOHandlerSocket.RecvDecrypt(var ABuf; ALen: Integer): integer;
var
  dataLength: Cardinal;
  dataStore: Pointer;
  Buffers: array[0..3] of SecBuffer;
  pDataBuffer, pExtraBuffer: PSecBuffer;
  BuffersDesc: SecBufferDesc;
  ss: SECURITY_STATUS;
  I, newSize: Integer;
  done: Boolean;
begin
  Result := 0;
  dataStore := nil;
  done := False;
  while (not done) do
  begin
    if (not skipRecv) then
    begin
      dataLength := inherited Recv(ABuf, ALen);
      if (dataLength > Cardinal(ALen)) then begin
        //Something went wrong. Can't trust the ABuf data
        Exit;
      end;
    end else begin
      dataLength := 0;
    end;

    with BuffersDesc do begin
      ulVersion := 0;
      cBuffers := 4;
      pBuffers := @Buffers;
    end;

    with Buffers[0] do begin
      if (dataStore <> nil) then FreeMem(dataStore);
      dataStore := AllocMem(m_Buffer.m_Length + dataLength);
      Move(ABuf, dataStore^, dataLength);

      dataLength := m_Buffer.Deque(dataLength, dataLength + m_Buffer.m_Length, dataStore^);
      cbBuffer := dataLength;
      BufferType := SECBUFFER_DATA;
      pvBuffer := dataStore;
    end;
    for I := 1 to 3 do begin
      with Buffers[I] do begin
        cbBuffer := 0;
        BufferType := SECBUFFER_EMPTY;
        pvBuffer := nil;
      end;
    end;

    ss := mSspiCalls.FunctionTable.DecryptMessage(m_phContext, @BuffersDesc, 0, nil);

    if (ss = SEC_E_INCOMPLETE_MESSAGE) then begin
      m_Buffer.Enque(dataLength, dataStore^);
      skipRecv := false;
      Continue;
    end;

    if (ss = SEC_E_MESSAGE_ALTERED) then
    begin
      if (dataStore <> nil) then FreeMem(dataStore);
      raise EIdException.Create('Our SSL message has been altered.');
    end;

    if (ss < 0) then
    begin
      if (dataStore <> nil) then FreeMem(dataStore);
      raise EIdException.Create('Decryption of the SSL message failed.');
    end;

    if ((ss <> SEC_E_OK) and (ss <> SEC_I_RENEGOTIATE) and
        (ss <> SEC_I_CONTEXT_EXPIRED)) then
    begin
      if (dataStore <> nil) then FreeMem(dataStore);
      raise EIdException.Create('SSL Decryption Failed.');
    end;

    if (ss = SEC_I_CONTEXT_EXPIRED) then
    begin
      if (dataStore <> nil) then FreeMem(dataStore);
      EncryptSend(Pointer(nil)^, 0);
      Exit;
    end;

    pDataBuffer := nil;
    pExtraBuffer := nil;
    for I := 0 to 3 do
    begin
      if ((pDataBuffer = nil) and (Buffers[I].BufferType = SECBUFFER_DATA)) then
      begin
        pDataBuffer := @Buffers[I];
      end;
      if ((pExtraBuffer = nil) and (Buffers[I].BufferType = SECBUFFER_EXTRA)) then
      begin
        pExtraBuffer := @Buffers[I];
      end;
    end;

    if ((pDataBuffer <> nil) and ((pDataBuffer^).cbBuffer > 0)) then
    begin
      if (Cardinal(ALen) < pDataBuffer.cbBuffer) then
      begin
        newSize := ALen;
      end else begin
        newSize := pDataBuffer.cbBuffer;
      end;

      Move(pDataBuffer.pvBuffer^, ABuf, newSize);
      Result := newSize;
      mSspiCalls.FunctionTable.FreeContextBuffer(pDataBuffer.pvBuffer);
    end;

    if ((pExtraBuffer <> nil) and (pExtraBuffer.cbBuffer > 0)) then
    begin
      m_Buffer.Enque(pExtraBuffer.cbBuffer, pExtraBuffer.pvBuffer^);
      mSspiCalls.FunctionTable.FreeContextBuffer(pExtraBuffer.pvBuffer);

      skipRecv := True;
    end else begin
      skipRecv := False;
    end;

    done := True;
  end;
  if (dataStore <> nil) then FreeMem(dataStore);
end;

function TIdSchannelIOHandlerSocket.ClientHandshakeLoop(var IoBuffer;
  var length: Cardinal; var extraData: SecBuffer): Boolean;
begin
  result := True;
end;

function TIdSchannelIOHandlerSocket.EncryptSend(var ABuf; ALen: Integer): integer;
var
  sizes: SecPkgContext_StreamSizes;
  ss: SECURITY_STATUS;
  buffersDesc: SecBufferDesc;
  buffers: array[0..3] of SecBuffer;
  b0, b1, b2, returnString: string;
begin
  ss := mSspiCalls.FunctionTable.QueryContextAttributesA(m_phContext,
    SECPKG_ATTR_STREAM_SIZES, @sizes);
  if (ss <> SEC_E_OK) then
  begin
    raise EIdException.Create('SSL message size call failed.');
  end;

  buffersDesc.ulVersion := 0;
  buffersDesc.cBuffers := 4;
  buffersDesc.pBuffers := @buffers;

  with buffers[0] do begin
    cbBuffer := sizes.cbHeader;
    BufferType := SECBUFFER_STREAM_HEADER;
    pvBuffer := AllocMem(cbBuffer);
  end;
  with buffers[1] do begin
    cbBuffer := ALen;
    BufferType := SECBUFFER_DATA;
    pvBuffer := @ABuf;
  end;
  with buffers[2] do begin
    cbBuffer := sizes.cbTrailer;
    BufferType := SECBUFFER_STREAM_TRAILER;
    pvBuffer := AllocMem(cbBuffer);
  end;
  with buffers[3] do begin
    cbBuffer := 0;
    BufferType := SECBUFFER_EMPTY;
    pvBuffer := nil;
  end;

  ss := mSspiCalls.FunctionTable.EncryptMessage(m_phContext, 0, @buffersDesc, 0);
  if (ss = SEC_E_OK) then begin
    SetString(b0, PChar(buffers[0].pvBuffer), buffers[0].cbBuffer);
    SetString(b1, PChar(buffers[1].pvBuffer), buffers[1].cbBuffer);
    SetString(b2, PChar(buffers[2].pvBuffer), buffers[2].cbBuffer);
    returnString := '';
    returnString := ConCat(b0, b1);
    returnString := ConCat(returnString, b2);

    Result := inherited Send(Pointer(returnString)^, Length(returnString));

    FreeMem(buffers[0].pvBuffer);
    FreeMem(buffers[2].pvBuffer);
  end else begin
    raise EIdException.Create('SSL encryption failed.');
  end;
end;

procedure TIdSchannelIOHandlerSocket.Init;
begin

end;

constructor TIdSchannelIOHandlerSocket.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  fPassThrough := true;

  mSspiCalls := TSSPIInterface.Create;
  mSspiCalls.IsAvailable;

  m_phContext := @m_hContext;
  SecInvalidateHandle(m_phContext);

  m_phClientCreds := @m_ClientCreds;
  SecInvalidateHandle(m_phClientCreds);

  m_Connected := False;

  m_CurrBodyLen := 0;
  m_BodyLen := -1;

  m_SecExtraBuffer.cbBuffer := 0;
  m_SecExtraBuffer.BufferType := 0;
  m_SecExtraBuffer.pvBuffer := nil;

  m_Buffer := TIdDataBuffer.Create();
  skipRecv := False;

  mClientCert := nil;
  mServerCert := nil;

  Init;
end;

destructor TIdSchannelIOHandlerSocket.Destroy;
begin
  FreeAndNil(m_Buffer);

  if (mClientCert <> nil) then
  begin
    CertFreeCertificateContext(mClientCert);
  end;
  if (mServerCert <> nil) then
  begin
    mServerCert.Destroy;
  end;

  mSspiCalls.FunctionTable.DeleteSecurityContext(m_phContext);
  mSspiCalls.Free;
  inherited Destroy;
end;

Constructor SChannelX509.Create(aX509: PPCCERT_CONTEXT; serverName: WideString);
begin
  inherited Create;

  mX509 := aX509^;
  aX509^ := nil;

  mServerName := serverName;
end;

Destructor SChannelX509.Destroy;
begin
  CertFreeCertificateContext(mX509);
end;

{
function SChannelX509.RSubject:TIdX509Name;
begin
  //TODO: Fill this out
end;
function SChannelX509.RIssuer:TIdX509Name;
begin
  //TODO: Fill this out
end;
function SChannelX509.RnotBefore:TDateTime;
begin
  //TODO: Fill this out
end;
function SChannelX509.RnotAfter:TDateTime;
begin
  //TODO: Fill this out
end;
}

function SChannelX509.RFingerprint:TEVP_MD;
begin
  CertGetCertificateContextProperty(mX509,
    CERT_HASH_PROP_ID, nil, Result.Length);
  Result.MD := AllocMem(Result.Length);
  CertGetCertificateContextProperty(mX509,
    CERT_HASH_PROP_ID, Result.MD, Result.Length);
end;

function SChannelX509.RFingerprintAsString:String;
var
  I: Cardinal;
  EVP_MD: TEVP_MD;
  tmp: PChar;
begin
  Result := '';
  EVP_MD := Fingerprint;
  tmp := EVP_MD.MD;
  for I := 0 to EVP_MD.Length - 1 do begin
    if I <> 0 then Result := Result + ':';    {Do not Localize}
    Result := Result + Format('%.2x', [Byte(tmp^)]);  {do not localize}
    Inc(tmp);
  end;
  FreeMem(EVP_MD.MD, EVP_MD.Length);
end;

function SChannelX509.getServerCertName:string;
var
  namePtr: PAnsiChar;
  nameLength: Integer;
  name: array[0..256] of Char;
begin
  name := '';
  nameLength := 128;
  namePtr := Addr(name);

  CertGetNameString(mX509,
    CERT_NAME_SIMPLE_DISPLAY_TYPE,
    0, nil, namePtr, nameLength);

  Result := string(namePtr);
end;

function SChannelX509.verifyCertificate(var error:WideString):Boolean;
var
  ppChainContext:PPCCERT_CHAIN_CONTEXT;
  pChainContext:PCCERT_CHAIN_CONTEXT;
  polHttps:SSL_EXTRA_CERT_CHAIN_POLICY_PARA;
  policyPara:CERT_CHAIN_POLICY_PARA;
  policyStatus:CERT_CHAIN_POLICY_STATUS;
  sysTime: SYSTEMTIME;
  chainPara: CERT_CHAIN_PARA;
  pChainPara: PCERT_CHAIN_PARA;
begin
  Result := True;

  pChainPara := @chainPara;
  pChainPara.cbSize := SizeOf(chainPara);
  pChainPara.RequestedUsage.dwType := 0;
  pChainPara.RequestedUsage.Usage.cUsageIdentifier := 0;
  pChainPara.RequestedUsage.Usage.rgpszUsageIdentifier := '';

  ppChainContext := PPCCERT_CHAIN_CONTEXT(@pChainContext);
  if (not CertGetCertificateChain(0, mX509, LPFILETIME(nil), mX509.hCertStore, pChainPara, 0, nil, ppChainContext)) then
  begin
    Result := False;
    Exit;
  end;

  polHttps.cbSize := SizeOf(polHttps);
  polHttps.dwAuthType := AUTHTYPE_SERVER;
  polHttps.fdwChecks := 0;
  polHttps.pwszServerName := PWideChar(mServerName);

  policyPara.cbSize := SizeOf(policyPara);
  policyPara.dwFlags := 0;
  policyPara.pvExtraPolicyPara := @polHttps;

  policyStatus.cbSize := SizeOf(policyStatus);
  policyStatus.dwError := 0;
  policyStatus.lChainIndex := -1;
  policyStatus.lElementIndex := -1;
  policyStatus.pvExtraPolicyStatus := nil;

  if (not CertVerifyCertificateChainPolicy(CERT_CHAIN_POLICY_SSL, pChainContext,
    @policyPara, @policyStatus)) then
  begin
    Result := False;
    CertFreeCertificateChain(pChainContext);
    Exit;
  end;

  if (Boolean(policyStatus.dwError)) then
  begin
    FileTimeToSystemTime(Windows._FILETIME(mX509.pCertInfo.NotBefore), sysTime);
    FileTimeToSystemTime(Windows._FILETIME(mX509.pCertInfo.NotAfter), sysTime);

    setErrorMessage(policyStatus.dwError, error);

    Result := False;
    CertFreeCertificateChain(pChainContext);
    Exit;
  end;
end;

procedure SChannelX509.setErrorMessage(errorType:DWORD; var error:WideString);
begin
  Case errorType of
    DWORD(TRUST_E_CERT_SIGNATURE): error := TRUST_E_CERT_SIGNATURE_STR;
    DWORD(CERT_E_UNTRUSTEDROOT): error := CERT_E_UNTRUSTEDROOT_STR;
    DWORD(CERT_E_UNTRUSTEDTESTROOT): error := CERT_E_UNTRUSTEDTESTROOT_STR;
    DWORD(CERT_E_CHAINING): error := CERT_E_CHAINING_STR;
    DWORD(CERT_E_WRONG_USAGE): error := CERT_E_WRONG_USAGE_STR;
    DWORD(CERT_E_EXPIRED): error := CERT_E_EXPIRED_STR;
    DWORD(CERT_E_VALIDITYPERIODNESTING): error := CERT_E_VALIDITYPERIODNESTING_STR;
    DWORD(CERT_E_PURPOSE): error := CERT_E_PURPOSE_STR;
    DWORD(TRUST_E_BASIC_CONSTRAINTS): error := TRUST_E_BASIC_CONSTRAINTS_STR;
    DWORD(CERT_E_ROLE): error := CERT_E_ROLE_STR;
    DWORD(CERT_E_CN_NO_MATCH): error := CERT_E_CN_NO_MATCH_STR + mServerName;
    DWORD(CRYPT_E_REVOKED): error := CRYPT_E_REVOKED_STR;
    DWORD(CRYPT_E_REVOCATION_OFFLINE): error := CRYPT_E_REVOCATION_OFFLINE_STR;
    DWORD(CERT_E_REVOKED): error := CERT_E_REVOKED_STR;
    DWORD(CERT_E_REVOCATION_FAILURE): error := CERT_E_REVOCATION_FAILURE_STR;
    else error := 'Some unknown error has occurred.';
  End;
end;


constructor TIdDataBuffer.Create;
begin
    m_Data := nil;
    m_Length := 0;
end;
destructor TIdDataBuffer.Destroy;
begin
    Clear();

    inherited;
end;

procedure TIdDataBuffer.Clear();
begin
    if (m_Data = nil) then exit;

    FreeMem(m_Data, m_Length);
    m_Data := nil;
    m_Length := 0;
end;

function TidDataBuffer.Deque(len: Cardinal; limit: Cardinal; var dst): Cardinal;
var
    tmp: Pointer;
    ptr: PByte;
    amt, overflow: Cardinal;
begin
    Assert (len >= 0);
    Assert (len <= limit);

    amt := m_Length + len;
    overflow := Max(amt - limit, 0);
    tmp := AllocMem(amt);
    ptr := tmp;

    try
        //Copy saved (if any)
        if (m_Data <> nil) then begin
            Move(m_Data^, ptr^, m_Length);
            Inc(ptr, m_Length);
            Clear();
        end;

        Move(dst, ptr^, len);

        Result := amt - overflow;
        if (overflow > 0) then begin
            //copy extra data to saved
            m_Data := AllocMem(overflow);
            ptr := tmp;
            Inc(ptr, Result);
            Move(ptr^, m_Data^, overflow);
        end;

        Move(tmp^, dst, Result);
    finally
        FreeMem(tmp);
    end;
end;
procedure TIdDataBuffer.Enque(len: Cardinal; var src);
var
    tmp: Pointer;
    ptr: PByte;
    amt: Cardinal;
begin
    Assert (len >= 0);
    amt := m_Length + len;
    tmp := AllocMem(amt);
    ptr := tmp;

    if (m_Data <> nil) then begin
        //grow buffer by <len>, and add old data to the head
        Move(m_Data^, ptr^, m_Length);
        Inc(ptr, m_Length);
    end;

    Move(src, ptr^, len);
    m_Data := tmp;
    m_Length := amt;
end;

end.
