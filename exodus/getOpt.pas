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
unit getopt;

{
  TGetOpts : a "GetOpt" component that implements 'Getopt' style commandline parsing
             supports short option (-o) and long option (--option) syntax,
             required and optioanl options, and option arguments with optional
             default values.
             short and long options can be mixed

             June 3, 2001, Danny Heijl danny.heijl@pandora.be


  Use :
    - Create an instance of TGetOpts
    - put the supported lowercase option letters in the Options property string
      note that optionletter matching is *not* case sensitive
    - put a - (dash) for every option that doesn't take an argument in the same
      positon of the OptFlags property string, and a : (colon) for every option that
      requires one
    - Put an 'x' for every option that is required in the corresponding position
      of the ReqFlags property string, and a ' ' (space) for optional ones
    - optionally supply a comma-delimited string with "long option" forms
      in the LongOpts property (in the same sequence as Options). Long options
      are of the form --option, short ones are -o. You can supply an argument
      embedded with a long option (--option=value), or you can supply the
      argument as is usual, following the long option (--option value)
    - optionally supply a comma-delimited string with default values for option
      arguments, use a '-' (dash) when there is no default value
    - then repeatedly call GetOpt until it returns False
      * after a successful call to GetOpt, Optarg contains the argument if any,
        OptInd contains the position of the option in the Options string, and
        OptChar contains the option letter (lowercase)
      * all errors raise an EGetOpt exception
      * arguments not preceded by an option letter get Optind and OptArg = 0
    - Notes: -long option names should not contain spaces, but you can embed
              spaces in values by surrounding a value with double quotes.
             -the following options could be equivalent :
                 -d 1
                 --debuglevel 1
                 --debuglevel=1
             -option arguments can not start with a '-' (dash)

  Example of use :
    with TGetOpts.Create do begin
      try
        Options  := 'dnc';            // -d -n and -c supported
        OptFlags := ':-:';            // -d and -c need an argument, -n doesn't
        ReqFlags := ' xx';            // -d optional, -n and -c required
        Defaults := '0,-,-';          // defaults: -d 0
        LongOpts := 'debuglevel,dryrun,filename'; //long form of the options d, n and f
        while GetOpt do begin
          case Ord(OptChar) of
             0: raise Exception.Create('extra argument');
             Ord('d'): iDebugLevel := StrToInt(OptArg);
             Ord('n'): bDryRun := True;
             Ord('f'): strFileName := OptArg;
      end;
    end;
      finally
        Free
  end;
end;
}

interface

  uses SysUtils, classes;

type
  EGetOpt = class(Exception);

type
  EConfigException = Exception;

  TGetOpts = class(TComponent)
    private
      FIndex:      integer;
      FOptions:    string;
      FLongOpts:   TStringList;
      FDefaults:   TStringList;
      FOptFlags:   string;
      FReqFlags:   string;
      FOptInd:     integer;
      FOptChar:    Char;
      FOptArg:     string;
      OptsNeeded:  string;
    function GetLongOpts: string;
    procedure SetLongOpts(const Value: string);
    procedure SetReqFlags(const Value: string);
    function Getdefaults: string;
    procedure SetDefaults(const Value: string);
    procedure SetOptions(const Value: string);
    protected
    public
      constructor Create(AOwner: TComponent); override;
      Destructor Destroy; override;
      // these are set by GetOpt
      property OptInd:    integer   read FOptind;
      property OptChar:   Char      read FOptChar;
      property OptArg:    string    read FOptArg;
      // call GetOpt repeatedly until it returns False
      function  GetOpt: Boolean;
    published
      // set these before you call Getopt
      property Options:   string    read FOptions     write SetOptions;
      property LongOpts:  string    read GetLongOpts  write SetLongOpts;
      property OptFlags:  string    read FOptFlags    write FOptFlags;
      property ReqFlags:  string    read FReqFlags    write SetReqFlags;
      property Defaults:  string    read Getdefaults  write SetDefaults;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Compon', [TGetOpts]);
end;

resourcestring
  SPropertiesMissing  = '%s: improper use of TGetOpts, one, some or more properties not initialized.';
  SReqOptMissing      = '%s: a required option (-%s) is missing.';
  SOptNeedsArg        = '%s: Option %s requires an argument.';
  SOPtUnknown         = '%s: Unknown option %s.';
  SNoLongOpt          = '%s: long option format not supported.';

{ TGetOpts }


constructor TGetOpts.Create(AOwner: TComponent);
begin
  inherited;
  FLongOpts := TStringList.Create;
  FDefaults := TStringList.Create;
  FIndex := 1;
end;

destructor TGetOpts.Destroy;
begin
  FLongOpts.Clear;
  FreeAndNil(FLongOpts);
  FDefaults.Clear;
  FreeAndNil(FDefaults);
  inherited;
end;



{ options are not case sensitive }
procedure TGetOpts.SetOptions(const Value: string);
begin
  FOptions := LowerCase(Value);
end;

function TGetOpts.GetLongOpts: string;
begin
  Result := FLongOpts.CommaText;
end;

procedure TGetOpts.SetLongOpts(const Value: string);
begin
  FLongOpts.CommaText := Lowercase(Value);
end;

function TGetOpts.Getdefaults: string;
begin
  Result := FDefaults.CommaText;
end;

procedure TGetOpts.SetDefaults(const Value: string);
begin
  FDefaults.CommaText := Value;
end;

procedure TGetOpts.SetReqFlags(const Value: string);
begin
  FReqFlags := LowerCase(Value);
  OptsNeeded := FReqFlags;
end;

{ GetOpt }

function TGetOpts.GetOpt: Boolean;
var
  s1:         string;
  strOpt:     string;
  strOptDef:  string;
  iPosEq:     integer;
  i:          integer;
begin
  // all parameters processed ?
  if FIndex > ParamCount then begin
    // all options processed
    if Trim(OptsNeeded) <> '' then begin  // required option(s) missing
      raise EGetOpt.Create(Format(SReqOptMissing,
                                  [Paramstr(0), FOptions[Pos('x', OptsNeeded)]]));
end;
    Result := False;
    exit;
  end;

  // check for proper usage of the component on the first call to GetOpt
  if FIndex = 1 then begin
    if (Length(FOptions) <> Length(FOptFlags)) or
       (Length(FOptions) <> Length(FReqFlags)) or
       (Length(Foptions) = 0) or
       ((FLongOpts.Count > 0) and (FLongOpts.Count <> Length(Foptions))) or
       ((FDefaults.Count > 0) and (FDefaults.Count <> Length(Foptions))) then
      raise EGetOpt.Create(SPropertiesMissing);
    // initialize  required Options array
    OptsNeeded := FReqFlags;
  end;
  // process next option
  FOptInd := -1;
  strOptDef := '-';
  s1 := LowerCase(Paramstr(FIndex));
  if (s1[1] = '-') or (s1[1] = '/') then begin             // option flag ?
    if s1[2] = '-' then begin           // yes, long option
      if FLongOpts.Count = 0 then       // no long options allowed !
        raise EGetOpt.Create(SNoLongOpt);
      Inc(Findex);                      // long option found and allowed
      strOpt := Copy(s1, 3, Length(s1) - 2);
      iPosEq := Pos('=', stropt);       // embedded value with = ?
      if iPosEq > 0 then begin          // yes, split into option and argument
        FOptArg := Copy(strOpt, iPosEq + 1, Length(strOpt) - iPosEq);
        strOpt  := Copy(strOpt, 1, iPosEq - 1);
  end else begin                    // argument is seperate (if any)
        FOptArg := '';
  end;
                                        // handle long option
      for i := 0 to FLongOpts.Count - 1 do begin
        if strOpt = FLongOpts.Strings[i] then begin
          FOptInd := i + 1;
          if FDefaults.Count > 0 then   // fetch default argument if any
            strOptDef := FDefaults.Strings[FOptInd - 1];
          FOptChar := FOptions[FOptInd];
          break;
    end;
  end;
      if FOptInd < 0 then                // unknown option
        raise EGetOpt.Create(Format(SOptUnknown, [ParamStr(0), s1]));
                                         // found a long option
      if FOptFlags[FOptInd] = ':' then begin  // does the option need an argument?
        if FOptArg = '' then begin            // it does, was it embedded with = ?
          if FIndex > ParamCount then begin   // no, any arguments left ?
            if strOptDef = '-' then begin     // no, and no default either
              raise EGetOpt.Create(Format(SOptNeedsArg, [ParamStr(0), s1]));
        end else begin                    // none left, but have default
              FOptArg := strOptDef;
        end;
      end else begin                      // some left,
            if (ParamStr(Findex)[1] <> '-') and (ParamStr(Findex)[1] <> '/') then begin  // and it's not an option
              FOptArg := ParamStr(FIndex);            // so get the argument
              Inc(Findex);
        end else begin                            // it is an option,
              FOptArg := strOptDef;                   // so use default argument
        end;
      end;
    end;
  end;
end else begin                       // short option
      Inc(Findex);
      strOpt := s1[2];                   // get option letter
      FOptChar := LowerCase(s1)[2];
      FOptInd := Pos(strOpt, FOptions);  // get the ordinal value in OptString
      if FOptInd = 0 then                // unkown option
        raise EGetOpt.Create(Format(SOptUnknown, [ParamStr(0), s1]));
      if FDefaults.Count > 0 then        // fetch default argument if any
        strOptDef := FDefaults.Strings[FOptInd - 1];
      if FOptFlags[FOptInd] = ':' then begin  // does the option need an argument?
        if FIndex > ParamCount then begin   // yes, any arguments left ?
          if strOptDef = '-' then begin     // no, and no default either
            raise EGetOpt.Create(Format(SOptNeedsArg, [ParamStr(0), s1]));
      end else begin                    // none left, but have default
            FOptArg := strOptDef;
      end;
    end else begin                      // some left,
          if (ParamStr(Findex)[1] <> '-') and (ParamStr(Findex)[1] <> '/') then begin  // and not an option
            FOptArg := ParamStr(FIndex);            // so get the argument
            Inc(Findex);
      end else begin
            FOptArg := strOptDef;                   // but an option, so use default
      end;
    end;
  end;
end;
    OptsNeeded[Foptind] := ' ';        // flag option found
  end else begin
  // arguments without option letter get OptInd = 0
    FOptArg := ParamStr(Findex);
    Inc(Findex);
    FOptInd := 0;
    FOptChar := Char(0);
  end;
  Result := True;
end;

end.
