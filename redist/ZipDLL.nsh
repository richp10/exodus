;ZipDLL include file for NSIS
;Written by Tim Kosse (mailto:tim.kosse@gmx.de)
;Compatible with Modern UI 1.62

;German translation by Tim Kosse
;Spanish translation by "dark_boy"
;French translation by "veekee"
;Brazilian Portuguese translation by "deguix"
;Traditional Chinese traslation by "matini"


!ifndef MUI_MACROS_USED
  !error "Please include modern UI first!!"
!endif

!ifndef MUI_ZIPDLL_USED

!define MUI_ZIPDLL_USED

!macro MUI_ZIPDLL_EXTRACTFILE SOURCE DESTINATION FILE

  Push "${FILE}"
  Push "${DESTINATION}"
  Push "${SOURCE}"

  ;The strings that will be translated are:

  ;"  Error: %s"
  ;"Could not get file attributes."
  ;"Error: Could not get file attributes."
  ;"Could not extract %s"
  ;"  Error: Could not extract %s"
  ;"Specified file does not exist in archive."
  ;"Error: Specified file does not exist in archive."
  ;"Extracting the file %s from %s to %s"

  !ifdef "MUI_LANGUAGEFILE_FRENCH_USED"
    strcmp $LANGUAGE ${LANG_FRENCH} 0 +10
    Push "  Erreur : %s"
    Push "Impossible de récupérer les informations sur le fichier."
    Push "Erreur : Impossible de récupérer les informations sur le fichier."
    Push "Impossible de décompresser %s."
    Push "  Erreur : Impossible de décompresser %s."
    Push "Le fichier spécifié n'existe pas dans l'archive"
    Push "Erreur : Le fichier spécifié n'existe pas dans l'archive"
    Push "Décompression du fichier %s depuis %s vers %s"
    Push "/TRANSLATE"
  !endif
  !ifdef "MUI_LANGUAGEFILE_GERMAN_USED"
    strcmp $LANGUAGE ${LANG_GERMAN} 0 +10
    Push "  Fehler: %s"
    Push "Dateiattribute konnten nicht ermittelt werden."
    Push "Fehler: Dateiattribute konnten nicht ermittelt werden."
    Push "%s konnte nicht dekomprimiert werden."
    Push "  Fehler: %s konnte nicht dekomprimiert werden."
    Push "Die angegebene Datei existiert nicht im Archiv"
    Push "Fehler: Die angegebene Datei existiert nicht im Archiv"
    Push "Dekomprimiere Datei %s von %s nach %s"
    Push "/TRANSLATE"
  !endif
  !ifdef "MUI_LANGUAGEFILE_SPANISH_USED"
    strcmp $LANGUAGE ${LANG_SPANISH} 0 +10
    Push "Error: %s"
    Push "No se obtuvieron atributos del archivo"
    Push "Error: No se obtuvieron atributos del archivo"
    Push "No se pudo extraer %s"
    Push "  Error: No se pudo extraer %s"
    Push "Archivo especificado no existe en el ZIP"
    Push "Error: El archivo especificado no existe en el ZIP"
    Push "Extrayendo el archivo %s de %s a %s"
    Push "/TRANSLATE"
  !endif
  !ifdef "MUI_LANGUAGEFILE_PORTUGUESEBR_USED"
    strcmp $LANGUAGE ${LANG_PORTUGUESEBR} 0 +10
    Push "Erro: %s"
    Push "Não se pode ler os atributos do arquivo"
    Push "Error: Não se pode ler os atributos do arquivo"
    Push "Não se pode extrair %s"
    Push "  Erro: Não se pode extrair %s"
    Push "O arquivo especificado não existe no ZIP"
    Push "Erro: O arquivo especificado não existe no ZIP"
    Push "Extraindo o arquivo %s de %s a %s"
    Push "/TRANSLATE"
  !endif
  !ifdef "MUI_LANGUAGEFILE_TRADCHINESE_USED"
    StrCmp $LANGUAGE ${LANG_TRADCHINESE} 0 +10
	Push "  ¿ù»~¡G%s"
	Push "µLªk¨ú±oÀÉ®×ÄÝ©Ê¡C"
	Push "¿ù»~¡GµLªk¨ú±oÀÉ®×ÄÝ©Ê¡C"
	Push "µLªk¸ÑÀ£ÁY %s"
	Push "  ¿ù»~¡GµLªk¸ÑÀ£ÁY %s"
	Push "«ü©wªºÀÉ®×¤£¦s¦b©óÀ£ÁYÀÉ¤¤¡C"
	Push "¿ù»~¡G«ü©wªºÀÉ®×¤£¦s¦b©óÀ£ÁYÀÉ¤¤¡C"
	Push "¥¿¦b¸ÑÀ£ÁYÀÉ®× %s¡A±q %s ¨ì %s"
	Push "/TRANSLATE"
  !endif

  ZipDLL::extractfile

!macroend

!macro MUI_ZIPDLL_EXTRACTALL SOURCE DESTINATION

  Push "${DESTINATION}"
  Push "${SOURCE}"

  ;The strings that will be translated are:

  ;"  Error: %s"
  ;"Could not get file attributes."
  ;"Error: Could not get file attributes."
  ;"Could not extract %s"
  ;"  Error: Could not extract %s"
  ;"  Extract : %s"
  ;"  Extracting %d files and directories"
  ;"Extracting contents of %s to %s"

  !ifdef "MUI_LANGUAGEFILE_FRENCH_USED"
    strcmp $LANGUAGE ${LANG_FRENCH} 0 +10
    Push "  Erreur : %s"
    Push "Impossible de récupérer les informations sur le fichier."
    Push "Erreur : Impossible de récupérer les informations sur le fichier."
    Push "Impossible de décompresser %s."
    Push "  Erreur : Impossible de décompresser %s."
    Push "  Décompression : %s"
    Push "  Décompression de %d fichiers et répertoires"
    Push "Décompression des données de %s vers %s"
    Push "/TRANSLATE"
  !endif
  !ifdef "MUI_LANGUAGEFILE_GERMAN_USED"
    strcmp $LANGUAGE ${LANG_GERMAN} 0 +10
    Push "  Fehler: %s"
    Push "Dateiattribute konnten nicht ermittelt werden."
    Push "Fehler: Dateiattribute konnten nicht ermittelt werden."
    Push "%s konnte nicht dekomprimiert werden."
    Push "  Fehler: %s konnte nicht dekomprimiert werden."
    Push "  Dekomprimiere: %s"
    Push "  Dekomprimiere %d Dateien und Verzeichnisse"
    Push "Dekomprimiere Inhalt von %s nach %s"
    Push "/TRANSLATE"
  !endif
  !ifdef "MUI_LANGUAGEFILE_SPANISH_USED"
    strcmp $LANGUAGE ${LANG_SPANISH} 0 +10
    Push "Error: %s"
    Push "No se obtuvieron atributos del archivo"
    Push "Error: No se obtuvieron atributos del archivo"
    Push "No se pudo extraer %s"
    Push "  Error: No se pudo extraer %s"
    Push "  Extraer: %s"
    Push "  Extrayendo %d archivos y directorios"
    Push "Extraer archivos de %s a %s"
    Push "/TRANSLATE"
  !endif
  !ifdef "MUI_LANGUAGEFILE_PORTUGUESEBR_USED"
    strcmp $LANGUAGE ${LANG_PORTUGUESEBR} 0 +10
    Push "Erro: %s"
    Push "Não se pode ler os atributos do arquivo"
    Push "Error: Não se pode ler os atributos do arquivo"
    Push "Não se pode extrair %s"
    Push "  Erro: Não se pode extrair %s"
    Push "  Extraindo: %s"
    Push "  Extraindo %d arquivos e diretórios"
    Push "Extraindo arquivos de %s a %s"
    Push "/TRANSLATE"
  !endif
  !ifdef "MUI_LANGUAGEFILE_TRADCHINESE_USED"
    StrCmp $LANGUAGE ${LANG_TRADCHINESE} 0 +10
	Push "  ¿ù»~¡G%s"
	Push "µLªk¨ú±oÀÉ®×ÄÝ©Ê¡C"
	Push "¿ù»~¡GµLªk¨ú±oÀÉ®×ÄÝ©Ê¡C"
	Push "µLªk¸ÑÀ£ÁY %s"
	Push "  ¿ù»~¡GµLªk¸ÑÀ£ÁY %s"
	Push "  ¸ÑÀ£ÁY¡G%s"
	Push "  ¥¿¦b¸ÑÀ£ÁY %d ÀÉ®×©M¸ê®Æ§¨"
	Push "¥¿¦b¸ÑÀ£ÁY %s ªº¤º®e¨ì %s"
	Push "/TRANSLATE"
  !endif

  ZipDLL::extractall

!macroend

!endif