unit uExFrm;

{******************************************************************************
Initial Author   :    Scott Price (scottp)
Initially Created:    16-September-2001
Language         :    Object Pascal
Compiler Version :    Delphi 5.01 (UK)
                      (* Possibly 3.02, 4.03 - Form File in D5 Text Format *)
Copyright        :    © Knowledge Solutions (UK) Limited, 1996-2001

Source Code Constraints:
========================
   Distribution, disclosure or modifications of this source code, outside of
   any licenced agreements with Knowledge Solutions (UK) Limited, or removal
   of this notice constitutes a breach of any or all license agreements.

Operating Systems Tested On:
============================
   Microsoft Windows(R) 98, First Edition
   Microsoft Windows(R) NT4, Service Pack 5

Design Notes:
=============

VERSION  AUTHOR                DATE/TIME
===============================================================================
$history$
$nokeywords$
===============================================================================
NOTES:
 - This demonstration requires the presence of LIBMNG.DLL on a
   search path, or in the same directory as this example application.
******************************************************************************}


interface



uses
  { Borland Standard Units }
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, ExtCtrls, ExtDlgs, StdCtrls,

  { LIBMNG Units }
  NGImages;


type
  TfmLIBMNGExample = class(TForm)
    sbxImage: TScrollBox;
    imgDisplay: TImage;
    pnlButtons: TPanel;
    splSep: TSplitter;
    sbInfo: TStatusBar;
    btnLoad: TButton;
    opdImage: TOpenPictureDialog;
    procedure btnLoadClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;


var
  fmLIBMNGExample: TfmLIBMNGExample;



implementation



{$R *.DFM}

procedure TfmLIBMNGExample.btnLoadClick(Sender: TObject);
const
  scLOAD_Failed = 'FAILED:  To Load Image!';
begin
  { Please ensure you have read the NOTES: in the header above before continuing }
  
  { If you have the packages compiled with LATE_BINDING enabled, then at the Execute
    point it might appear to be a little slow to show the dialog.  This is because the
    LIBMNG DLL is delay-loaded, and only on first call, which is at this point.  If you
    have the library compiled with Eary Binding, then this will not see to be present,
    but rather the start of the whole application will be slightly slower, as we obviously
    have an additional DLL or two to cater for. } 

  { Try to load any of the available images.  Report failures to the TStatusBar.SimpleText }
  if opdImage.Execute then begin
     TRY
        imgDisplay.Picture.LoadFromFile(opdImage.FileName);
     EXCEPT
        sbInfo.SimpleText:= scLOAD_Failed + Format(' (%s)', [opdImage.FileName]);
     END;

     sbInfo.SimpleText:= 'Loaded Image:  ' + opdImage.FileName;
  end else
      sbInfo.SimpleText:= scLOAD_Failed;
end;

end.
