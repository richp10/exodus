unit RegNG;

{****************************************************************************}
{*                                                                          *}
{*  for copyright and version information see header in NGImages.pas        *}
{*                                                                          *}
{****************************************************************************}
{*                                                                          *}
{*  Changelog:                            * reverse chronological order *   *}
{*                                                                          *}
{*  * 0.9.3 *                                                               *}
{*  Revision, Based on 0.9.2 Third beta                                     *}
{*  2001/05/08 - Restructured for Maintainability                           *}
{*             - Seperated into multiple units                              *}
{*                                                                          *}
{****************************************************************************}
{*                                                                          *}
{*  TODO:                                                                   *}
{*                                                                          *}
{****************************************************************************}

interface


{$INCLUDE NGDefs.inc}



uses NGConst, NGTypes, NGImages {$IFDEF INCLUDE_JPEG}, NGJPEG {$ENDIF};


procedure Register;



implementation



uses Graphics;


procedure Register;
begin
  { Register the Types in the IDE }
{$IFDEF INCLUDE_JPEG}
  InitDefaults;
{$IFDEF REGISTER_JPEG}
  TPicture.RegisterFileFormat (SCJPEGExt1, SCJPEGImageFile, TJPEGImage);
  TPicture.RegisterFileFormat (SCJPEGExt2, SCJPEGImageFile, TJPEGImage);
  TPicture.RegisterFileFormat (SCJPEGExt3, SCJPEGImageFile, TJPEGImage);
  TPicture.RegisterFileFormat (SCJPEGExt4, SCJPEGImageFile, TJPEGImage);
{$ENDIF}
{$ENDIF}
{$IFDEF REGISTER_MNG}
  TPicture.RegisterFileFormat (SCMNGExt, SCMNGImageFile, TMNGImage);
{$ENDIF}
{$IFDEF REGISTER_JNG}
  TPicture.RegisterFileFormat (SCJNGExt, SCJNGImageFile, TJNGImage);
{$ENDIF}
{$IFDEF REGISTER_PNG}
  TPicture.RegisterFileFormat (SCPNGExt, SCPNGImageFile, TPNGImage);
{$ENDIF}
end;

end.

