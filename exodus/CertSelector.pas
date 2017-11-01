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
unit CertSelector;


interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Grids, TntGrids, TntStdCtrls, IdCoderMIME,

  JwaCryptUIApi, JwaWinCrypt;

type
  TForm1 = class(TForm)
    Button1: TTntButton;
    Button2: TTntButton;
    StringGrid1: TStringGrid;
    Label1: TLabel;

    procedure Button3Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    m_hCertStore: HCERTSTORE;
    certificates: TStringList;
    mIndex: Integer;

    procedure AutoSizeGrid(Grid: TStringGrid);
    procedure getCertificates;
    procedure setIssuedInGrid(m_pCertContext: PCERT_CONTEXT; certNum, index: Cardinal);
    procedure setIssuerInGrid(m_pCertContext: PCERT_CONTEXT; certNum, index: Cardinal);
    procedure setNameInGrid(m_pCertContext: PCERT_CONTEXT; certNum, index, dwFlags: Cardinal);
    procedure setFriendlyNameInGrid(m_pCertContext: PCERT_CONTEXT; certNum, index: Cardinal);
    procedure setDisplayInGrid(m_pCertContext: PCERT_CONTEXT; certNum, index, dwFlags, display: Cardinal);
    procedure setExpirationDateInGrid(m_pCertContext: PCERT_CONTEXT; certNum, index: Cardinal);
    procedure setPurposeInGrid(m_pCertContext: PCERT_CONTEXT; certNum, index: Cardinal);

    function encodeCertKey(keyLength: Cardinal; key: Pointer): string;
    procedure decodeCertKey(var key: Pointer; var decodedLength: Cardinal; encodedString: string);
    function getSelectedCert(index: Integer): PCERT_CONTEXT;
  public
    procedure createHeader;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property Index: Integer read mIndex;
  end;

var
  Form1: TForm1;

  function getSelectedCertificate(AOwner: TComponent): PCCERT_CONTEXT;

implementation

{$R *.dfm}

constructor TForm1.Create(AOwner: TComponent);
var
  sMy: LPCWSTR;
begin
  inherited Create(AOwner);

  sMy := 'MY';
  m_hCertStore := CertOpenStore(CERT_STORE_PROV_SYSTEM_W, 0, 0,
    CERT_SYSTEM_STORE_CURRENT_USER, sMy);

  certificates := TStringList.Create;
end;

destructor TForm1.Destroy;
begin
  if (m_hCertStore <> nil) then
  begin
    CertCloseStore(m_hCertStore, 0);
  end;

  inherited Destroy;
end;

function TForm1.getSelectedCert(index: Integer): PCCERT_CONTEXT;
var
  cert: string;
  key: Pointer;
  keyLength: Cardinal;
  keyBlob: _CRYPTOAPI_BLOB;
begin
  cert := certificates[index];
  decodeCertKey(key, keyLength, cert);
  try
    keyBlob.cbData := keyLength;
    keyBlob.pbData := key;
    Result := CertFindCertificateInStore(m_hCertStore, X509_ASN_ENCODING, 0, CERT_FIND_KEY_IDENTIFIER, @keyBlob, nil);
  finally
    FreeMem(key, keyLength);
  end;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  mIndex := StringGrid1.Row-1;
end;

procedure TForm1.Button3Click(Sender: TObject);
var
  testCert: PCCERT_CONTEXT;
begin
  testCert := getSelectedCert(StringGrid1.Row-1);

  CryptUIDlgViewContext(CERT_STORE_CERTIFICATE_CONTEXT, testCert, HWND(nil), nil, 0, nil);

  CertFreeCertificateContext(testCert);
end;

procedure TForm1.getCertificates;
var
    m_pCertContext: PCCERT_CONTEXT;
    certNum: Cardinal;
    serialNumber: string;
    key: Pointer;
    keyLength: Cardinal;
begin
    if (m_hCertStore <> nil) then begin
      certNum := 0;
      m_pCertContext := CertEnumCertificatesInStore(m_hCertStore, nil);
      while (m_pCertContext <> nil) do
      begin
        certNum := certNum + 1;
        StringGrid1.RowCount := certNum + 1;

        // Get Issuer
        setIssuedInGrid(m_pCertContext, certNum, 0);
        setIssuerInGrid(m_pCertContext, certNum, 1);
        setPurposeInGrid(m_pCertContext, certNum, 2);
        setFriendlyNameInGrid(m_pCertContext, certNum, 3);
        setExpirationDateInGrid(m_pCertContext, certNum, 4);

        CertGetCertificateContextProperty(m_pCertContext,
          CERT_KEY_IDENTIFIER_PROP_ID, nil, keyLength);
        key := AllocMem(keyLength);
        try
          CertGetCertificateContextProperty(m_pCertContext,
            CERT_KEY_IDENTIFIER_PROP_ID, key, keyLength);

            serialNumber := encodeCertKey(keyLength, key);
            certificates.Add(serialNumber);
        finally
          FreeMem(key, keyLength);
        end;

        m_pCertContext := CertEnumCertificatesInStore(m_hCertStore, m_pCertContext);
      end;
    end;

    AutoSizeGrid(StringGrid1);
end;

function TForm1.encodeCertKey(keyLength: Cardinal; key: Pointer): string;
var
  encoder: TIdEncoderMime;
  tmp: string;
begin
  encoder := TIdEncoderMIME.Create(nil);
  try
    SetString(tmp, PChar(key), keyLength);
    Result := encoder.EncodeString(tmp);
  finally
    encoder.Free;
  end;
end;

procedure TForm1.decodeCertKey(var key: Pointer; var decodedLength: Cardinal; encodedString: string);
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

function getSelectedCertificate(AOwner: TComponent): PCCERT_CONTEXT;
begin
  Result := nil;

  Form1 := TForm1.Create(AOwner);
  try
    Form1.createHeader;
    Form1.getCertificates;

    if (Form1.ShowModal = mrOk) then
    begin
      Result := Form1.getSelectedCert(Form1.Index);
    end;
  finally
    Form1.Destroy;
  end;
end;

procedure TForm1.createHeader;
begin
  if (StringGrid1.RowCount < 1) then
  begin
    StringGrid1.RowCount := 1;
  end;

  with StringGrid1 do begin
    ColCount := 5;
    Cells[0,0] := 'Issued to';
    Cells[1,0] := 'Issued by';
    Cells[2,0] := 'Intended Purposes';
    Cells[3,0] := 'Friendly name';
    Cells[4,0] := 'Expiration Date';
  end;
end;

procedure TForm1.setPurposeInGrid(m_pCertContext: PCERT_CONTEXT; certNum, index: Cardinal);
var
  usageLength: Cardinal;
  usage: PCTL_USAGE;
  I: Cardinal;
  usageStr: string;
begin
  CertGetEnhancedKeyUsage(m_pCertContext, 0, nil, usageLength);
  usage := PCERT_ENHKEY_USAGE(AllocMem(usageLength));
  try
    if (CertGetEnhancedKeyUsage(m_pCertContext, 0, usage, usageLength)) then
    begin
      if (usage.cUsageIdentifier = 0) then
      begin
        StringGrid1.Cells[index, certNum] := '<All>';
      end else begin
        for I := 0 to usage.cUsageIdentifier - 1 do
        begin
          usageStr := usage.rgpszUsageIdentifier;
        end;
      end;
    end else begin
      //TODO: It might not exist.
    end;
  finally
    FreeMem(usage, usageLength);
  end;
end;

procedure TForm1.setExpirationDateInGrid(m_pCertContext: PCERT_CONTEXT; certNum, index: Cardinal);
var
  sysTime: _SYSTEMTIME;
  expirationDate: WideString;
begin
  FileTimeToSystemTime(Windows.FILETIME(m_pCertContext.pCertInfo.NotAfter), sysTime);
  expirationDate := IntToStr(sysTime.wMonth);
  expirationDate := expirationDate + '/';
  expirationDate := expirationDate + IntToStr(sysTime.wDay);
  expirationDate := expirationDate + '/';
  expirationDate := expirationDate + IntToStr(sysTime.wYear);
  StringGrid1.Cells[index, certNum] := expirationDate;
end;

procedure TForm1.setDisplayInGrid(m_pCertContext: PCERT_CONTEXT; certNum, index, dwFlags, display: Cardinal);
var
  keyLength: Cardinal;
  key: PAnsiChar;
begin
  keyLength := CertGetNameString(m_pCertContext, display, dwFlags, nil, nil, 0);
  key := AllocMem(keyLength);
  try
    CertGetNameString(m_pCertContext, display, dwFlags, nil, key, keyLength);
    StringGrid1.Cells[index, certNum] := key;
  finally
    FreeMem(key, keyLength);
  end;
end;

procedure TForm1.setNameInGrid(m_pCertContext: PCERT_CONTEXT; certNum, index, dwFlags: Cardinal);
begin
  setDisplayInGrid(m_pCertContext, certNum, index, dwFlags, CERT_NAME_SIMPLE_DISPLAY_TYPE);
end;

procedure TForm1.setFriendlyNameInGrid(m_pCertContext: PCERT_CONTEXT; certNum, index: Cardinal);
begin
  setDisplayInGrid(m_pCertContext, certNum, index, 0, CERT_NAME_FRIENDLY_DISPLAY_TYPE);

  if (StringGrid1.Cells[0, certNum] = StringGrid1.Cells[index, certNum]) then
  begin
    StringGrid1.Cells[index, certNum] := 'None';
  end;
end;

procedure TForm1.setIssuedInGrid(m_pCertContext: PCERT_CONTEXT; certNum, index: Cardinal);
begin
  setNameInGrid(m_pCertContext, certNum, index, 0);
end;

procedure TForm1.setIssuerInGrid(m_pCertContext: PCERT_CONTEXT; certNum, index: Cardinal);
begin
  setNameInGrid(m_pCertContext, certNum, index, CERT_NAME_ISSUER_FLAG);
end;

procedure TForm1.AutoSizeGrid(Grid: TStringGrid);
const
  ColWidthMin = 10;
var
  C, R, W, ColWidthMax: integer;
begin
  for C := 0 to Grid.ColCount - 1 do begin
    ColWidthMax := ColWidthMin;
    for R := 0 to (Grid.RowCount - 1) do begin
      W := Grid.Canvas.TextWidth(Grid.Cells[C, R]);
      if W > ColWidthMax then
        ColWidthMax := W;
    end;
    Grid.ColWidths[C] := ColWidthMax + 5;
  end;
end;

end.
