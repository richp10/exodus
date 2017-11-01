;; -*- tab-width: 4; -*-
;    Copyright 2003, Joe Hildebrand
;
;    This file is part of Exodus.
;
;    Exodus is free software; you can redistribute it and/or modify
;    it under the terms of the GNU General Public License as published by
;    the Free Software Foundation; either version 2 of the License, or
;    (at your option) any later version.
;
;    Exodus is distributed in the hope that it will be useful,
;    but WITHOUT ANY WARRANTY; without even the implied warranty of
;    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;    GNU General Public License for more details.
;
;    You should have received a copy of the GNU General Public License
;    along with Exodus; if not, write to the Free Software
;    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

/*
    2004-02-11 - Lazarus Long <lazarus (dot) long (at) bigfoot (dot) com>
                (all changes were made implying the usage of a stock 2.0 version
                of NSIS).
               - moved the localization string to a separate file for ease of
                 future translation (it would be nice to get a way to ease the
                 translators work by allowing these strings to go in default.po
                 and then extract them here at compile time, but it will increase
                 the default.mo size with unused strings unless they are stripped
                 just before compilation, but that means a bit of perl or bash
                 magic, I'll leave it in a TODO state for now).
    2004-02-17 - Lazarus Long <lazarus (dot) long (at) bigfoot (dot) com>
               - reluctantly (against my intention to keep the i18n strings all
                 in one file) created the "example-plugin-locale.nsh" in the
                 plugins dir since the plugin stuff is all there.
*/


; Section name (NAME_ExImportAIM)
!define i18n_NAME_ExImportAIM_EN "ImportAIM"
!define i18n_NAME_ExImportAIM_CA "${i18n_NAME_ExImportAIM_EN}"
!define i18n_NAME_ExImportAIM_CZ "${i18n_NAME_ExImportAIM_EN}"
!define i18n_NAME_ExImportAIM_DA "${i18n_NAME_ExImportAIM_EN}"
!define i18n_NAME_ExImportAIM_DE "${i18n_NAME_ExImportAIM_EN}"
!define i18n_NAME_ExImportAIM_ES "${i18n_NAME_ExImportAIM_EN}"
!define i18n_NAME_ExImportAIM_FR "${i18n_NAME_ExImportAIM_EN}"
!define i18n_NAME_ExImportAIM_JA "${i18n_NAME_ExImportAIM_EN}"
!define i18n_NAME_ExImportAIM_KO "${i18n_NAME_ExImportAIM_EN}"
!define i18n_NAME_ExImportAIM_LT "${i18n_NAME_ExImportAIM_EN}"
!define i18n_NAME_ExImportAIM_NL "${i18n_NAME_ExImportAIM_EN}"
!define i18n_NAME_ExImportAIM_NO "${i18n_NAME_ExImportAIM_EN}"
!define i18n_NAME_ExImportAIM_PL "${i18n_NAME_ExImportAIM_EN}"
!define i18n_NAME_ExImportAIM_PT_BR "${i18n_NAME_ExImportAIM_EN}"
!define i18n_NAME_ExImportAIM_PT_PT "Importar AIM"
!define i18n_NAME_ExImportAIM_RU "${i18n_NAME_ExImportAIM_EN}"
!define i18n_NAME_ExImportAIM_SL "${i18n_NAME_ExImportAIM_EN}"
!define i18n_NAME_ExImportAIM_ZH "${i18n_NAME_ExImportAIM_EN}"

; Section description (DESC_ExImportAIM)
!define i18n_DESC_ExImportAIM_EN "Import contacts from AOL Instant Messenger."
!define i18n_DESC_ExImportAIM_CA "${i18n_DESC_ExImportAIM_EN}"
!define i18n_DESC_ExImportAIM_CZ "${i18n_DESC_ExImportAIM_EN}"
!define i18n_DESC_ExImportAIM_DA "${i18n_DESC_ExImportAIM_EN}"
!define i18n_DESC_ExImportAIM_DE "${i18n_DESC_ExImportAIM_EN}"
!define i18n_DESC_ExImportAIM_ES "${i18n_DESC_ExImportAIM_EN}"
!define i18n_DESC_ExImportAIM_FR "${i18n_DESC_ExImportAIM_EN}"
!define i18n_DESC_ExImportAIM_JA "${i18n_DESC_ExImportAIM_EN}"
!define i18n_DESC_ExImportAIM_KO "${i18n_DESC_ExImportAIM_EN}"
!define i18n_DESC_ExImportAIM_LT "${i18n_DESC_ExImportAIM_EN}"
!define i18n_DESC_ExImportAIM_NL "${i18n_DESC_ExImportAIM_EN}"
!define i18n_DESC_ExImportAIM_NO "${i18n_DESC_ExImportAIM_EN}"
!define i18n_DESC_ExImportAIM_PL "${i18n_DESC_ExImportAIM_EN}"
!define i18n_DESC_ExImportAIM_PT_BR "${i18n_DESC_ExImportAIM_EN}"
!define i18n_DESC_ExImportAIM_PT_PT "Importar os contactos do cliente de mensagens instantâneas da AOL (AIM)."
!define i18n_DESC_ExImportAIM_RU "${i18n_DESC_ExImportAIM_EN}"
!define i18n_DESC_ExImportAIM_SL "${i18n_DESC_ExImportAIM_EN}"
!define i18n_DESC_ExImportAIM_ZH "${i18n_DESC_ExImportAIM_EN}"

; Section name (NAME_ExAspell)
!define i18n_NAME_ExAspell_EN "Aspell"
!define i18n_NAME_ExAspell_CA "${i18n_NAME_ExAspell_EN}"
!define i18n_NAME_ExAspell_CZ "${i18n_NAME_ExAspell_EN}"
!define i18n_NAME_ExAspell_DA "${i18n_NAME_ExAspell_EN}"
!define i18n_NAME_ExAspell_DE "${i18n_NAME_ExAspell_EN}"
!define i18n_NAME_ExAspell_ES "${i18n_NAME_ExAspell_EN}"
!define i18n_NAME_ExAspell_FR "${i18n_NAME_ExAspell_EN}"
!define i18n_NAME_ExAspell_JA "${i18n_NAME_ExAspell_EN}"
!define i18n_NAME_ExAspell_KO "${i18n_NAME_ExAspell_EN}"
!define i18n_NAME_ExAspell_LT "${i18n_NAME_ExAspell_EN}"
!define i18n_NAME_ExAspell_NL "${i18n_NAME_ExAspell_EN}"
!define i18n_NAME_ExAspell_NO "${i18n_NAME_ExAspell_EN}"
!define i18n_NAME_ExAspell_PL "${i18n_NAME_ExAspell_EN}"
!define i18n_NAME_ExAspell_PT_BR "${i18n_NAME_ExAspell_EN}"
!define i18n_NAME_ExAspell_PT_PT "Corrector Aspell"
!define i18n_NAME_ExAspell_RU "${i18n_NAME_ExAspell_EN}"
!define i18n_NAME_ExAspell_SL "${i18n_NAME_ExAspell_EN}"
!define i18n_NAME_ExAspell_ZH "${i18n_NAME_ExAspell_EN}"

; Section description (DESC_ExAspell)
!define i18n_DESC_ExAspell_EN "A spell checker that uses aspell (http://aspell.net/win32), which needs to be downloaded seperately."
!define i18n_DESC_ExAspell_CA "${i18n_DESC_ExAspell_EN}"
!define i18n_DESC_ExAspell_CZ "${i18n_DESC_ExAspell_EN}"
!define i18n_DESC_ExAspell_DA "${i18n_DESC_ExAspell_EN}"
!define i18n_DESC_ExAspell_DE "${i18n_DESC_ExAspell_EN}"
!define i18n_DESC_ExAspell_ES "${i18n_DESC_ExAspell_EN}"
!define i18n_DESC_ExAspell_FR "${i18n_DESC_ExAspell_EN}"
!define i18n_DESC_ExAspell_JA "${i18n_DESC_ExAspell_EN}"
!define i18n_DESC_ExAspell_KO "${i18n_DESC_ExAspell_EN}"
!define i18n_DESC_ExAspell_LT "${i18n_DESC_ExAspell_EN}"
!define i18n_DESC_ExAspell_NL "${i18n_DESC_ExAspell_EN}"
!define i18n_DESC_ExAspell_NO "${i18n_DESC_ExAspell_EN}"
!define i18n_DESC_ExAspell_PL "${i18n_DESC_ExAspell_EN}"
!define i18n_DESC_ExAspell_PT_BR "${i18n_DESC_ExAspell_EN}"
!define i18n_DESC_ExAspell_PT_PT "Um corrector ortográfico que utiliza o sistema GNU Aspell (http://aspell.net/win32/) que tem que ser transferido e instalado separadamente."
!define i18n_DESC_ExAspell_RU "${i18n_DESC_ExAspell_EN}"
!define i18n_DESC_ExAspell_SL "${i18n_DESC_ExAspell_EN}"
!define i18n_DESC_ExAspell_ZH "${i18n_DESC_ExAspell_EN}"

; Section name (NAME_ExImportICQ)
!define i18n_NAME_ExImportICQ_EN "ImportICQ"
!define i18n_NAME_ExImportICQ_CA "${i18n_NAME_ExImportICQ_EN}"
!define i18n_NAME_ExImportICQ_CZ "${i18n_NAME_ExImportICQ_EN}"
!define i18n_NAME_ExImportICQ_DA "${i18n_NAME_ExImportICQ_EN}"
!define i18n_NAME_ExImportICQ_DE "${i18n_NAME_ExImportICQ_EN}"
!define i18n_NAME_ExImportICQ_ES "${i18n_NAME_ExImportICQ_EN}"
!define i18n_NAME_ExImportICQ_FR "${i18n_NAME_ExImportICQ_EN}"
!define i18n_NAME_ExImportICQ_JA "${i18n_NAME_ExImportICQ_EN}"
!define i18n_NAME_ExImportICQ_KO "${i18n_NAME_ExImportICQ_EN}"
!define i18n_NAME_ExImportICQ_LT "${i18n_NAME_ExImportICQ_EN}"
!define i18n_NAME_ExImportICQ_NL "${i18n_NAME_ExImportICQ_EN}"
!define i18n_NAME_ExImportICQ_NO "${i18n_NAME_ExImportICQ_EN}"
!define i18n_NAME_ExImportICQ_PL "${i18n_NAME_ExImportICQ_EN}"
!define i18n_NAME_ExImportICQ_PT_BR "${i18n_NAME_ExImportICQ_EN}"
!define i18n_NAME_ExImportICQ_PT_PT "Importar ICQ"
!define i18n_NAME_ExImportICQ_RU "${i18n_NAME_ExImportICQ_EN}"
!define i18n_NAME_ExImportICQ_SL "${i18n_NAME_ExImportICQ_EN}"
!define i18n_NAME_ExImportICQ_ZH "${i18n_NAME_ExImportICQ_EN}"

; Section description (DESC_ExImportICQ)
!define i18n_DESC_ExImportICQ_EN "Import contacts from your local ICQ installation."
!define i18n_DESC_ExImportICQ_CA "${i18n_DESC_ExImportICQ_EN}"
!define i18n_DESC_ExImportICQ_CZ "${i18n_DESC_ExImportICQ_EN}"
!define i18n_DESC_ExImportICQ_DA "${i18n_DESC_ExImportICQ_EN}"
!define i18n_DESC_ExImportICQ_DE "${i18n_DESC_ExImportICQ_EN}"
!define i18n_DESC_ExImportICQ_ES "${i18n_DESC_ExImportICQ_EN}"
!define i18n_DESC_ExImportICQ_FR "${i18n_DESC_ExImportICQ_EN}"
!define i18n_DESC_ExImportICQ_JA "${i18n_DESC_ExImportICQ_EN}"
!define i18n_DESC_ExImportICQ_KO "${i18n_DESC_ExImportICQ_EN}"
!define i18n_DESC_ExImportICQ_LT "${i18n_DESC_ExImportICQ_EN}"
!define i18n_DESC_ExImportICQ_NL "${i18n_DESC_ExImportICQ_EN}"
!define i18n_DESC_ExImportICQ_NO "${i18n_DESC_ExImportICQ_EN}"
!define i18n_DESC_ExImportICQ_PL "${i18n_DESC_ExImportICQ_EN}"
!define i18n_DESC_ExImportICQ_PT_BR "${i18n_DESC_ExImportICQ_EN}"
!define i18n_DESC_ExImportICQ_PT_PT "Importar os contactos da sua instalação local do ICQ."
!define i18n_DESC_ExImportICQ_RU "${i18n_DESC_ExImportICQ_EN}"
!define i18n_DESC_ExImportICQ_SL "${i18n_DESC_ExImportICQ_EN}"
!define i18n_DESC_ExImportICQ_ZH "${i18n_DESC_ExImportICQ_EN}"

; Section name (NAME_ExJabberStats)
!define i18n_NAME_ExJabberStats_EN "JabberStats"
!define i18n_NAME_ExJabberStats_CA "${i18n_NAME_ExJabberStats_EN}"
!define i18n_NAME_ExJabberStats_CZ "${i18n_NAME_ExJabberStats_EN}"
!define i18n_NAME_ExJabberStats_DA "${i18n_NAME_ExJabberStats_EN}"
!define i18n_NAME_ExJabberStats_DE "${i18n_NAME_ExJabberStats_EN}"
!define i18n_NAME_ExJabberStats_ES "${i18n_NAME_ExJabberStats_EN}"
!define i18n_NAME_ExJabberStats_FR "${i18n_NAME_ExJabberStats_EN}"
!define i18n_NAME_ExJabberStats_JA "${i18n_NAME_ExJabberStats_EN}"
!define i18n_NAME_ExJabberStats_KO "${i18n_NAME_ExJabberStats_EN}"
!define i18n_NAME_ExJabberStats_LT "${i18n_NAME_ExJabberStats_EN}"
!define i18n_NAME_ExJabberStats_NL "${i18n_NAME_ExJabberStats_EN}"
!define i18n_NAME_ExJabberStats_NO "${i18n_NAME_ExJabberStats_EN}"
!define i18n_NAME_ExJabberStats_PL "${i18n_NAME_ExJabberStats_EN}"
!define i18n_NAME_ExJabberStats_PT_BR "${i18n_NAME_ExJabberStats_EN}"
!define i18n_NAME_ExJabberStats_PT_PT "Estatísticas Jabber"
!define i18n_NAME_ExJabberStats_RU "${i18n_NAME_ExJabberStats_EN}"
!define i18n_NAME_ExJabberStats_SL "${i18n_NAME_ExJabberStats_EN}"
!define i18n_NAME_ExJabberStats_ZH "${i18n_NAME_ExJabberStats_EN}"

; Section description (DESC_ExJabberStats)
!define i18n_DESC_ExJabberStats_EN "Create a tab delimited file (in a directory like C:\Documents and Settings\username\Application Data\Exodus) with to, from, type, namespace, date/time, and size for each packet."
!define i18n_DESC_ExJabberStats_CA "${i18n_DESC_ExJabberStats_EN}"
!define i18n_DESC_ExJabberStats_CZ "${i18n_DESC_ExJabberStats_EN}"
!define i18n_DESC_ExJabberStats_DA "${i18n_DESC_ExJabberStats_EN}"
!define i18n_DESC_ExJabberStats_DE "${i18n_DESC_ExJabberStats_EN}"
!define i18n_DESC_ExJabberStats_ES "${i18n_DESC_ExJabberStats_EN}"
!define i18n_DESC_ExJabberStats_FR "${i18n_DESC_ExJabberStats_EN}"
!define i18n_DESC_ExJabberStats_JA "${i18n_DESC_ExJabberStats_EN}"
!define i18n_DESC_ExJabberStats_KO "${i18n_DESC_ExJabberStats_EN}"
!define i18n_DESC_ExJabberStats_LT "${i18n_DESC_ExJabberStats_EN}"
!define i18n_DESC_ExJabberStats_NL "${i18n_DESC_ExJabberStats_EN}"
!define i18n_DESC_ExJabberStats_NO "${i18n_DESC_ExJabberStats_EN}"
!define i18n_DESC_ExJabberStats_PL "${i18n_DESC_ExJabberStats_EN}"
!define i18n_DESC_ExJabberStats_PT_BR "${i18n_DESC_ExJabberStats_EN}"
!define i18n_DESC_ExJabberStats_PT_PT "Criar um ficheiro de texto (numa directoria do género C:\Documents and Settings\<o_seu_nome>\Application Data\Exodus) com os campos Dstinatário, Remetente, Tipo, Universo, Data/Hora e Tamanho para cada pacote separados por avanços de linha (tabs)."
!define i18n_DESC_ExJabberStats_RU "${i18n_DESC_ExJabberStats_EN}"
!define i18n_DESC_ExJabberStats_SL "${i18n_DESC_ExJabberStats_EN}"
!define i18n_DESC_ExJabberStats_ZH "${i18n_DESC_ExJabberStats_EN}"

; Section name (NAME_ExWordSpeller)
!define i18n_NAME_ExWordSpeller_EN "WordSpeller"
!define i18n_NAME_ExWordSpeller_CA "${i18n_NAME_ExWordSpeller_EN}"
!define i18n_NAME_ExWordSpeller_CZ "${i18n_NAME_ExWordSpeller_EN}"
!define i18n_NAME_ExWordSpeller_DA "${i18n_NAME_ExWordSpeller_EN}"
!define i18n_NAME_ExWordSpeller_DE "${i18n_NAME_ExWordSpeller_EN}"
!define i18n_NAME_ExWordSpeller_ES "${i18n_NAME_ExWordSpeller_EN}"
!define i18n_NAME_ExWordSpeller_FR "${i18n_NAME_ExWordSpeller_EN}"
!define i18n_NAME_ExWordSpeller_JA "${i18n_NAME_ExWordSpeller_EN}"
!define i18n_NAME_ExWordSpeller_KO "${i18n_NAME_ExWordSpeller_EN}"
!define i18n_NAME_ExWordSpeller_LT "${i18n_NAME_ExWordSpeller_EN}"
!define i18n_NAME_ExWordSpeller_NL "${i18n_NAME_ExWordSpeller_EN}"
!define i18n_NAME_ExWordSpeller_NO "${i18n_NAME_ExWordSpeller_EN}"
!define i18n_NAME_ExWordSpeller_PL "${i18n_NAME_ExWordSpeller_EN}"
!define i18n_NAME_ExWordSpeller_PT_BR "${i18n_NAME_ExWordSpeller_EN}"
!define i18n_NAME_ExWordSpeller_PT_PT "Corrector Word"
!define i18n_NAME_ExWordSpeller_RU "${i18n_NAME_ExWordSpeller_EN}"
!define i18n_NAME_ExWordSpeller_SL "${i18n_NAME_ExWordSpeller_EN}"
!define i18n_NAME_ExWordSpeller_ZH "${i18n_NAME_ExWordSpeller_EN}"

; Section description (DESC_ExWordSpeller)
!define i18n_DESC_ExWordSpeller_EN "An attempt at a spell checker that uses Microsoft Word.  Use at your own peril."
!define i18n_DESC_ExWordSpeller_CA "${i18n_DESC_ExWordSpeller_EN}"
!define i18n_DESC_ExWordSpeller_CZ "${i18n_DESC_ExWordSpeller_EN}"
!define i18n_DESC_ExWordSpeller_DA "${i18n_DESC_ExWordSpeller_EN}"
!define i18n_DESC_ExWordSpeller_DE "${i18n_DESC_ExWordSpeller_EN}"
!define i18n_DESC_ExWordSpeller_ES "${i18n_DESC_ExWordSpeller_EN}"
!define i18n_DESC_ExWordSpeller_FR "${i18n_DESC_ExWordSpeller_EN}"
!define i18n_DESC_ExWordSpeller_JA "${i18n_DESC_ExWordSpeller_EN}"
!define i18n_DESC_ExWordSpeller_KO "${i18n_DESC_ExWordSpeller_EN}"
!define i18n_DESC_ExWordSpeller_LT "${i18n_DESC_ExWordSpeller_EN}"
!define i18n_DESC_ExWordSpeller_NL "${i18n_DESC_ExWordSpeller_EN}"
!define i18n_DESC_ExWordSpeller_NO "${i18n_DESC_ExWordSpeller_EN}"
!define i18n_DESC_ExWordSpeller_PL "${i18n_DESC_ExWordSpeller_EN}"
!define i18n_DESC_ExWordSpeller_PT_BR "${i18n_DESC_ExWordSpeller_EN}"
!define i18n_DESC_ExWordSpeller_PT_PT "Tentativa de um corrector ortográfico que utiliza o Microsoft Word.  Use por sua conta e risco."
!define i18n_DESC_ExWordSpeller_RU "${i18n_DESC_ExWordSpeller_EN}"
!define i18n_DESC_ExWordSpeller_SL "${i18n_DESC_ExWordSpeller_EN}"
!define i18n_DESC_ExWordSpeller_ZH "${i18n_DESC_ExWordSpeller_EN}"

; Section name (NAME_ExNetMeeting)
!define i18n_NAME_ExNetMeeting_EN "NetMeeting"
!define i18n_NAME_ExNetMeeting_CA "${i18n_NAME_ExNetMeeting_EN}"
!define i18n_NAME_ExNetMeeting_CZ "${i18n_NAME_ExNetMeeting_EN}"
!define i18n_NAME_ExNetMeeting_DA "${i18n_NAME_ExNetMeeting_EN}"
!define i18n_NAME_ExNetMeeting_DE "${i18n_NAME_ExNetMeeting_EN}"
!define i18n_NAME_ExNetMeeting_ES "${i18n_NAME_ExNetMeeting_EN}"
!define i18n_NAME_ExNetMeeting_FR "${i18n_NAME_ExNetMeeting_EN}"
!define i18n_NAME_ExNetMeeting_JA "${i18n_NAME_ExNetMeeting_EN}"
!define i18n_NAME_ExNetMeeting_KO "${i18n_NAME_ExNetMeeting_EN}"
!define i18n_NAME_ExNetMeeting_LT "${i18n_NAME_ExNetMeeting_EN}"
!define i18n_NAME_ExNetMeeting_NL "${i18n_NAME_ExNetMeeting_EN}"
!define i18n_NAME_ExNetMeeting_NO "${i18n_NAME_ExNetMeeting_EN}"
!define i18n_NAME_ExNetMeeting_PL "${i18n_NAME_ExNetMeeting_EN}"
!define i18n_NAME_ExNetMeeting_PT_BR "${i18n_NAME_ExNetMeeting_EN}"
!define i18n_NAME_ExNetMeeting_PT_PT "NetMeeting"
!define i18n_NAME_ExNetMeeting_RU "${i18n_NAME_ExNetMeeting_EN}"
!define i18n_NAME_ExNetMeeting_SL "${i18n_NAME_ExNetMeeting_EN}"
!define i18n_NAME_ExNetMeeting_ZH "${i18n_NAME_ExNetMeeting_EN}"

; Section description (DESC_ExNetMeeting)
!define i18n_DESC_ExNetMeeting_EN "Initiate and receive invitations to NetMeeting sessions."
!define i18n_DESC_ExNetMeeting_CA "${i18n_DESC_ExNetMeeting_EN}"
!define i18n_DESC_ExNetMeeting_CZ "${i18n_DESC_ExNetMeeting_EN}"
!define i18n_DESC_ExNetMeeting_DA "${i18n_DESC_ExNetMeeting_EN}"
!define i18n_DESC_ExNetMeeting_DE "${i18n_DESC_ExNetMeeting_EN}"
!define i18n_DESC_ExNetMeeting_ES "${i18n_DESC_ExNetMeeting_EN}"
!define i18n_DESC_ExNetMeeting_FR "${i18n_DESC_ExNetMeeting_EN}"
!define i18n_DESC_ExNetMeeting_JA "${i18n_DESC_ExNetMeeting_EN}"
!define i18n_DESC_ExNetMeeting_KO "${i18n_DESC_ExNetMeeting_EN}"
!define i18n_DESC_ExNetMeeting_LT "${i18n_DESC_ExNetMeeting_EN}"
!define i18n_DESC_ExNetMeeting_NL "${i18n_DESC_ExNetMeeting_EN}"
!define i18n_DESC_ExNetMeeting_NO "${i18n_DESC_ExNetMeeting_EN}"
!define i18n_DESC_ExNetMeeting_PL "${i18n_DESC_ExNetMeeting_EN}"
!define i18n_DESC_ExNetMeeting_PT_BR "${i18n_DESC_ExNetMeeting_EN}"
!define i18n_DESC_ExNetMeeting_PT_PT "Enviar e receber convites para sessões de NetMeeting."
!define i18n_DESC_ExNetMeeting_RU "${i18n_DESC_ExNetMeeting_EN}"
!define i18n_DESC_ExNetMeeting_SL "${i18n_DESC_ExNetMeeting_EN}"
!define i18n_DESC_ExNetMeeting_ZH "${i18n_DESC_ExNetMeeting_EN}"

; Section name (NAME_ExRosterTools)
!define i18n_NAME_ExRosterTools_EN "RosterTools"
!define i18n_NAME_ExRosterTools_CA "${i18n_NAME_ExRosterTools_EN}"
!define i18n_NAME_ExRosterTools_CZ "${i18n_NAME_ExRosterTools_EN}"
!define i18n_NAME_ExRosterTools_DA "${i18n_NAME_ExRosterTools_EN}"
!define i18n_NAME_ExRosterTools_DE "${i18n_NAME_ExRosterTools_EN}"
!define i18n_NAME_ExRosterTools_ES "${i18n_NAME_ExRosterTools_EN}"
!define i18n_NAME_ExRosterTools_FR "${i18n_NAME_ExRosterTools_EN}"
!define i18n_NAME_ExRosterTools_JA "${i18n_NAME_ExRosterTools_EN}"
!define i18n_NAME_ExRosterTools_KO "${i18n_NAME_ExRosterTools_EN}"
!define i18n_NAME_ExRosterTools_LT "${i18n_NAME_ExRosterTools_EN}"
!define i18n_NAME_ExRosterTools_NL "${i18n_NAME_ExRosterTools_EN}"
!define i18n_NAME_ExRosterTools_NO "${i18n_NAME_ExRosterTools_EN}"
!define i18n_NAME_ExRosterTools_PL "${i18n_NAME_ExRosterTools_EN}"
!define i18n_NAME_ExRosterTools_PT_BR "${i18n_NAME_ExRosterTools_EN}"
!define i18n_NAME_ExRosterTools_PT_PT "Ferrametas do rol"
!define i18n_NAME_ExRosterTools_RU "${i18n_NAME_ExRosterTools_EN}"
!define i18n_NAME_ExRosterTools_SL "${i18n_NAME_ExRosterTools_EN}"
!define i18n_NAME_ExRosterTools_ZH "${i18n_NAME_ExRosterTools_EN}"

; Section description (DESC_ExRosterTools)
!define i18n_DESC_ExRosterTools_EN "Export and import your roster to your local filesystem."
!define i18n_DESC_ExRosterTools_CA "${i18n_DESC_ExRosterTools_EN}"
!define i18n_DESC_ExRosterTools_CZ "${i18n_DESC_ExRosterTools_EN}"
!define i18n_DESC_ExRosterTools_DA "${i18n_DESC_ExRosterTools_EN}"
!define i18n_DESC_ExRosterTools_DE "${i18n_DESC_ExRosterTools_EN}"
!define i18n_DESC_ExRosterTools_ES "${i18n_DESC_ExRosterTools_EN}"
!define i18n_DESC_ExRosterTools_FR "${i18n_DESC_ExRosterTools_EN}"
!define i18n_DESC_ExRosterTools_JA "${i18n_DESC_ExRosterTools_EN}"
!define i18n_DESC_ExRosterTools_KO "${i18n_DESC_ExRosterTools_EN}"
!define i18n_DESC_ExRosterTools_LT "${i18n_DESC_ExRosterTools_EN}"
!define i18n_DESC_ExRosterTools_NL "${i18n_DESC_ExRosterTools_EN}"
!define i18n_DESC_ExRosterTools_NO "${i18n_DESC_ExRosterTools_EN}"
!define i18n_DESC_ExRosterTools_PL "${i18n_DESC_ExRosterTools_EN}"
!define i18n_DESC_ExRosterTools_PT_BR "${i18n_DESC_ExRosterTools_EN}"
!define i18n_DESC_ExRosterTools_PT_PT "Importar e exportar o rol de e para um ficheiro no sistema local."
!define i18n_DESC_ExRosterTools_RU "${i18n_DESC_ExRosterTools_EN}"
!define i18n_DESC_ExRosterTools_SL "${i18n_DESC_ExRosterTools_EN}"
!define i18n_DESC_ExRosterTools_ZH "${i18n_DESC_ExRosterTools_EN}"

; Plugin upgrade abort message (MSG_PluginAbort)
!define i18n_MSG_PluginAbort_EN "Error downloading $1 plugin"
!define i18n_MSG_PluginAbort_CA "${i18n_MSG_PluginAbort_EN}"
!define i18n_MSG_PluginAbort_CZ "${i18n_MSG_PluginAbort_EN}"
!define i18n_MSG_PluginAbort_DA "${i18n_MSG_PluginAbort_EN}"
!define i18n_MSG_PluginAbort_DE "${i18n_MSG_PluginAbort_EN}"
!define i18n_MSG_PluginAbort_ES "${i18n_MSG_PluginAbort_EN}"
!define i18n_MSG_PluginAbort_FR "${i18n_MSG_PluginAbort_EN}"
!define i18n_MSG_PluginAbort_JA "${i18n_MSG_PluginAbort_EN}"
!define i18n_MSG_PluginAbort_KO "${i18n_MSG_PluginAbort_EN}"
!define i18n_MSG_PluginAbort_LT "${i18n_MSG_PluginAbort_EN}"
!define i18n_MSG_PluginAbort_NL "${i18n_MSG_PluginAbort_EN}"
!define i18n_MSG_PluginAbort_NO "${i18n_MSG_PluginAbort_EN}"
!define i18n_MSG_PluginAbort_PL "${i18n_MSG_PluginAbort_EN}"
!define i18n_MSG_PluginAbort_PT_BR "${i18n_MSG_PluginAbort_EN}"
!define i18n_MSG_PluginAbort_PT_PT "Erro a transferir a extensão $1"
!define i18n_MSG_PluginAbort_RU "${i18n_MSG_PluginAbort_EN}"
!define i18n_MSG_PluginAbort_SL "${i18n_MSG_PluginAbort_EN}"
!define i18n_MSG_PluginAbort_ZH "${i18n_MSG_PluginAbort_EN}"

/*
; #Subject#
!define i18n_#STRING#_EN ""
!define i18n_#STRING#__CA "${i18n_#STRING#_EN}"
!define i18n_#STRING#__CZ "${i18n_#STRING#_EN}"
!define i18n_#STRING#__DA "${i18n_#STRING#_EN}"
!define i18n_#STRING#__DE "${i18n_#STRING#_EN}"
!define i18n_#STRING#__ES "${i18n_#STRING#_EN}"
!define i18n_#STRING#__FR "${i18n_#STRING#_EN}"
!define i18n_#STRING#__JA "${i18n_#STRING#_EN}"
!define i18n_#STRING#__KO "${i18n_#STRING#_EN}"
!define i18n_#STRING#__LT "${i18n_#STRING#_EN}"
!define i18n_#STRING#__NL "${i18n_#STRING#_EN}"
!define i18n_#STRING#__NO "${i18n_#STRING#_EN}"
!define i18n_#STRING#__PL "${i18n_#STRING#_EN}"
!define i18n_#STRING#__PT_BR "${i18n_#STRING#_EN}"
!define i18n_#STRING#__PT_PT "${i18n_#STRING#_EN}"
!define i18n_#STRING#__RU "${i18n_#STRING#_EN}"
!define i18n_#STRING#__SL "${i18n_#STRING#_EN}"
!define i18n_#STRING#__ZH "${i18n_#STRING#_EN}"
*/

