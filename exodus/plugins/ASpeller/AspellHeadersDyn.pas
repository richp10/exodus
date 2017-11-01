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
unit AspellHeadersDyn;
{
  File      : AspellHeaders.pas
  Purpose   : Delphi Headerfiles for GNU-Aspell-0.50 (based on aspell.h)
  Copyright : (c) 12/2002 Thorsten Maerz <info@netztorte.de>
  License   : LGPL
}

interface

const ASPELLDLL = 'aspell-15.dll';

function LoadAspell(dllname:string=ASPELLDLL):boolean;

type
  AspellConfig                = type pointer;
  AspellMutableContainer      = type pointer;
  AspellKeyInfoEnumeration    = type pointer;
  AspellCanHaveError          = type pointer;
  AspellSpeller               = type pointer;
  AspellWordList              = type pointer;
  AspellFilter                = type pointer;
  AspellDocumentChecker       = type pointer;
  AspellModuleInfoList        = type pointer;
  AspellModuleInfoEnumeration = type pointer;
  AspellDictInfoList          = type pointer;
  AspellDictInfoEnumeration   = type pointer;
  AspellStringList            = type pointer;
  AspellStringEnumeration     = type pointer;
  AspellStringPairEnumeration = type pointer;
  AspellStringMap             = type pointer;

type
  AspellTypeId = ^TAspellTypeId;
  TAspellTypeId = record
    case boolean of
      true:  (num:Longword);
      false: (str:array[0..3] of char);
  end;

type
  AspellKeyInfoType = ( AspellKeyInfoString, AspellKeyInfoInt,
                        AspellKeyInfoBool,   AspellKeyInfoList );

  AspellKeyInfo = ^TAspellKeyInfo;
  TAspellKeyInfo = record
  {* the name of the key *}
    name       : PChar;
  {* the key type *}
    type_      : AspellKeyInfoType;
  {* the default value of the key *}
    def        : PChar;
  {* a brief description of the key or null if internal value *}
    desc       : PChar;
  {* other data used by config implementations
   * should be set to 0 if not used *}
    otherdata  : array[0..15] of char;
  end;

type
  AspellErrorInfo = ^TAspellErrorInfo;
  TAspellErrorInfo = record
    isa        : AspellErrorInfo;
    mesg       : PChar;
    num_parms  : Word;
    parms      : array[0..2] of char;
  end;

type
  AspellError = ^TAspellError;
  TAspellError = record
    mesg       : PChar;
    err        : AspellErrorInfo;
  end;

type
  AspellToken = ^TAspellToken;
  TAspellToken = record
    offset     : Word;
    len        : Word;
  end;

type
  AspellModuleInfo = ^TAspellModuleInfo;
  TAspellModuleInfo = record
    name        : PChar;
    order_num   : double;
    lib_dir     : PChar;
    dict_dirs   : AspellStringList;
    dict_exts   : AspellStringList;
  end;

type
  AspellDictInfo = ^TAspellDictInfo;
  TAspellDictInfo = record
  {* name to identify the dictionary by *}
    name        : PChar;
    code        : PChar;
    jargon      : PChar;
    size        : integer;
    size_str    : PChar;
    module      : AspellModuleInfo;
  end;

type
  AspellStringPair = ^TAspellStringPair;
  TAspellStringPair = record
    first       : PChar;
    second      : PChar;
  end;

type
{************************** mutable container **************************}
  Taspell_mutable_container_add=function(ths:AspellMutableContainer; to_add:PChar):integer; cdecl;
  Taspell_mutable_container_remove=function(ths:AspellMutableContainer; to_rem:PChar):integer; cdecl;
  Taspell_mutable_container_clear=procedure(ths:AspellMutableContainer); cdecl;
  Taspell_mutable_container_to_mutable_container=function(ths:AspellMutableContainer):AspellMutableContainer; cdecl;

{******************************* key info *******************************}
  Taspell_key_info_enumeration_at_end=function(ths:AspellKeyInfoEnumeration):integer; cdecl;
  Taspell_key_info_enumeration_next=function(ths:AspellKeyInfoEnumeration):AspellKeyInfo; cdecl;
  Tdelete_aspell_key_info_enumeration=procedure(ths:AspellKeyInfoEnumeration); cdecl;
  Taspell_key_info_enumeration_clone=function(ths:AspellKeyInfoEnumeration):AspellKeyInfoEnumeration; cdecl;
  Taspell_key_info_enumeration_assign=procedure(ths:AspellKeyInfoEnumeration; other:AspellKeyInfoEnumeration); cdecl;

{******************************** config ********************************}
  Tnew_aspell_config=function:AspellConfig; cdecl;
  Tdelete_aspell_config=procedure(ths:AspellConfig); cdecl;
  Taspell_config_clone=function(ths:AspellConfig):AspellConfig; cdecl;
  Taspell_config_assign=procedure(ths:AspellConfig; other:AspellConfig); cdecl;
  Taspell_config_error_number=function(ths:AspellConfig):Word; cdecl;
  Taspell_config_error_message=function(ths:AspellConfig):PChar; cdecl;

  Taspell_config_error=function(ths:AspellConfig):AspellError; cdecl;

{* sets extra keys which this config class should accept
 * begin and end are expected to point to the begging
 * and end of an array of Aspell Key Info *}
  Taspell_config_set_extra=procedure(ths, begin_, end_:AspellKeyInfo); cdecl;

{* returns the KeyInfo object for the
 * corresponding key or returns null and sets
 * error_num to PERROR_UNKNOWN_KEY if the key is
 * not valid. The pointer returned is valid for
 * the lifetime of the object. *}
  Taspell_config_keyinfo=function(ths:AspellConfig; key:PChar):AspellKeyInfo; cdecl;

{* returns a newly allocated enumeration of all the
 * possible objects this config class uses *}
  Taspell_config_possible_elements=function(ths:AspellConfig; include_extra:integer):AspellKeyInfoEnumeration; cdecl;

{* returns the default value for given key which
 * way involve substating variables, thus it is
 * not the same as keyinfo(key)->def returns null
 * and sets error_num to PERROR_UNKNOWN_KEY if
 * the key is not valid. Uses the temporary
 * string. *}
  Taspell_config_get_default=function(ths:AspellConfig; key:PChar):PChar; cdecl;

{* returns a newly alloacted enumeration of all the
 * key/value pairs. This DOES not include ones
 * which are set to their default values *}
  Taspell_config_elements=function(ths:AspellConfig):AspellStringPairEnumeration; cdecl;
  
{* inserts an item, if the item already exists it
 * will be replaced. returns true if it succesed
 * or false on error. If the key in not valid it
 * sets error_num to PERROR_UNKNOWN_KEY, if the
 * value is not valid it will sets error_num to
 * PERROR_BAD_VALUE, if the value can not be
 * changed it sets error_num to
 * PERROR_CANT_CHANGE_VALUE, and if the value is
 * a list and you are trying to set it directory
 * it sets error_num to PERROR_LIST_SET *}
  Taspell_config_replace=function(ths:AspellConfig; key, value:PChar):integer; cdecl;

{* remove a key and returns true if it exists
 * otherise return false. This effictly sets the
 * key to its default value. Calling replace with
 * a value of "<default>" will also call
 * remove. If the key does not exists sets
 * error_num to 0 or PERROR_NOT, if the key in
 * not valid sets error_num to
 * PERROR_UNKNOWN_KEY, if the value can not be
 * changed sets error_num to
 * PERROR_CANT_CHANGE_VALUE *}
  Taspell_config_remove=function(ths:AspellConfig; key:PChar):integer; cdecl;
  Taspell_config_have=function(ths:AspellConfig; key:PChar):integer; cdecl;

{* returns null on error *}
  Taspell_config_retrieve=function(ths:AspellConfig; key:PChar):PChar; cdecl;
  Taspell_config_retrieve_list=function(ths:AspellConfig; key:PChar; lst:AspellMutableContainer):integer; cdecl;

{* return -1 on error, 0 if false, 1 if true *}
  Taspell_config_retrieve_bool=function(ths:AspellConfig; key:PChar):integer; cdecl;

{* return -1 on error *}
  Taspell_config_retrieve_int=function(ths:AspellConfig; key:PChar):integer; cdecl;

{******************************** error ********************************}
{**************************** can have error ****************************}
  Taspell_error_number=function(ths:AspellCanHaveError):Word; cdecl;
  Taspell_error_message=function(ths:AspellCanHaveError):PChar; cdecl;
  Taspell_error=function(ths:AspellCanHaveError):AspellError; cdecl;
  Tdelete_aspell_can_have_error=procedure(ths:AspellCanHaveError); cdecl;

{******************************* speller *******************************}
  Tnew_aspell_speller=function(config:AspellConfig):AspellCanHaveError; cdecl;
  Tto_aspell_speller=function(obj:AspellCanHaveError):AspellSpeller; cdecl;
  Tdelete_aspell_speller=procedure(ths:AspellSpeller); cdecl;
  Taspell_speller_error_number=function(ths:AspellSpeller):Word; cdecl;
  Taspell_speller_error_message=function(ths:AspellSpeller):PChar; cdecl;
  Taspell_speller_error=function(ths:AspellSpeller):AspellError; cdecl;
  Taspell_speller_config=function(ths:AspellSpeller):AspellConfig; cdecl;

{* returns  0 if it is not in the dictionary,
 * 1 if it is, or -1 on error. *}
  Taspell_speller_check=function(ths:AspellSpeller; word_:PChar; word_size:integer):integer; cdecl;
  Taspell_speller_add_to_personal=function(ths:AspellSpeller; word:PChar; word_size:integer):integer; cdecl;
  Taspell_speller_add_to_session=function(ths:AspellSpeller; word:PChar; word_size:integer):integer; cdecl;
  Taspell_speller_personal_word_list=function(ths:AspellSpeller):AspellWordList; cdecl;
  Taspell_speller_session_word_list=function(ths:AspellSpeller):AspellWordList; cdecl;
  Taspell_speller_main_word_list=function(ths:AspellSpeller):AspellWordList; cdecl;
  Taspell_speller_save_all_word_lists=function(ths:AspellSpeller):integer; cdecl;
  Taspell_speller_clear_session=function(ths:AspellSpeller):integer; cdecl;

{* Return null on error.
 * the word list returned by suggest is only valid until the next
 * call to suggest *}
  Taspell_speller_suggest=function(ths:AspellSpeller; word_:PChar; word_size:integer):AspellWordList; cdecl;
  Taspell_speller_store_replacement=function(ths:AspellSpeller; mis:PChar; mis_size:integer; cor:PChar; cor_size:integer):integer; cdecl;

{******************************** filter ********************************}
  Tdelete_aspell_filter=procedure(ths:AspellFilter); cdecl;
  Taspell_filter_error_number=function(ths:AspellFilter):Word; cdecl;
  Taspell_filter_error_message=function(ths:AspellFilter):PChar; cdecl;
  Taspell_filter_error=function(ths:AspellFilter):AspellError; cdecl;
  Tto_aspell_filter=function(obj:AspellCanHaveError):AspellFilter; cdecl;

{*************************** document checker ***************************}
  Tdelete_aspell_document_checker=procedure(ths:AspellDocumentChecker); cdecl;
  Taspell_document_checker_error_number=function(ths:AspellDocumentChecker):Word; cdecl;
  Taspell_document_checker_error_message=function(ths:AspellDocumentChecker):PChar; cdecl;
  Taspell_document_checker_error=function(ths:AspellDocumentChecker):AspellError; cdecl;

{* Creates a new document checker.
 * The speller class is expect to last until this
 * class is destroyed.
 * If config is given it will be used to overwide
 * any relevent options set by this speller class.
 * The config class is not once this function is done.
 * If filter is given then it will take ownership of
 * the filter class and use it to do the filtering.
 * You are expected to free the checker when done. *}
  Tnew_aspell_document_checker=function(speller:AspellSpeller):AspellCanHaveError; cdecl;
  Tto_aspell_document_checker=function(obj:AspellCanHaveError):AspellDocumentChecker; cdecl;

{* reset the internal state of the filter.
 * should be called whenever a new document is being filtered *}
  Taspell_document_checker_reset=procedure(ths:AspellDocumentChecker); cdecl;

{* process a string
 * The string passed in should only be split on white space
 * characters.  Furthermore, between calles to reset, each string
 * should be passed in exactly once and in the order they appeared
 * in the document.  Passing in stings out of order, skipping
 * strings or passing them in more than once may lead to undefined
 * results. *}
  Taspell_document_checker_process=procedure(ths:AspellDocumentChecker; str:PChar; size:integer); cdecl;

{* returns the next misspelled word in the processed string
 * if there are no more misspelled word than token.word
 * will be null and token.size will be 0 *}
  Taspell_document_checker_next_misspelling=function(ths:AspellDocumentChecker):AspellToken; cdecl;

{* returns the underlying filter class *}
  Taspell_document_checker_filter=function(ths:AspellDocumentChecker):AspellFilter; cdecl;

{****************************** word list ******************************}
  Taspell_word_list_empty=function(ths:AspellWordList):integer; cdecl;
  Taspell_word_list_size=function(ths:AspellWordList):Word; cdecl;
  Taspell_word_list_elements=function(ths:AspellWordList):AspellStringEnumeration; cdecl;

{************************** string enumeration **************************}
  Tdelete_aspell_string_enumeration=procedure(ths:AspellStringEnumeration); cdecl;
  Taspell_string_enumeration_clone=function(ths:AspellStringEnumeration):AspellStringEnumeration; cdecl;
  Taspell_string_enumeration_assign=procedure(ths:AspellStringEnumeration; other:AspellStringEnumeration); cdecl;
  Taspell_string_enumeration_at_end=function(ths:AspellStringEnumeration):integer; cdecl;
  Taspell_string_enumeration_next=function(ths:AspellStringEnumeration):PChar; cdecl;

{********************************* info *********************************}
  Tget_aspell_module_info_list=function(config:AspellConfig):AspellModuleInfoList; cdecl;
  Taspell_module_info_list_empty=function(ths:AspellModuleInfoList):integer; cdecl;
  Taspell_module_info_list_size=function(ths:AspellModuleInfoList):Word; cdecl;
  Taspell_module_info_list_elements=function(ths:AspellModuleInfoList):AspellModuleInfoEnumeration; cdecl;

  Tget_aspell_dict_info_list=function(config:AspellConfig):AspellDictInfoList; cdecl;
  Taspell_dict_info_list_empty=function(ths:AspellDictInfoList):integer; cdecl;
  Taspell_dict_info_list_size=function(ths:AspellDictInfoList):Word; cdecl;
  Taspell_dict_info_list_elements=function(ths:AspellDictInfoList):AspellDictInfoEnumeration; cdecl;

  Taspell_module_info_enumeration_at_end=function(ths:AspellModuleInfoEnumeration):integer; cdecl;
  Taspell_module_info_enumeration_next=function(ths:AspellModuleInfoEnumeration):AspellModuleInfo; cdecl;
  Tdelete_aspell_module_info_enumeration=procedure(ths:AspellModuleInfoEnumeration); cdecl; 
  Taspell_module_info_enumeration_clone=function(ths:AspellModuleInfoEnumeration):AspellModuleInfoEnumeration; cdecl;
  Taspell_module_info_enumeration_assign=procedure(ths:AspellModuleInfoEnumeration; other:AspellModuleInfoEnumeration); cdecl;

  Taspell_dict_info_enumeration_at_end=function(ths:AspellDictInfoEnumeration):integer; cdecl;
  Taspell_dict_info_enumeration_next=function(ths:AspellDictInfoEnumeration):AspellDictInfo; cdecl;
  Tdelete_aspell_dict_info_enumeration=procedure(ths:AspellDictInfoEnumeration); cdecl; 
  Taspell_dict_info_enumeration_clone=function(ths:AspellDictInfoEnumeration):AspellDictInfoEnumeration; cdecl;
  Taspell_dict_info_enumeration_assign=procedure(ths:AspellDictInfoEnumeration; other:AspellDictInfoEnumeration); cdecl;

{***************************** string list *****************************}
  Tnew_aspell_string_list=function:AspellStringList; cdecl;
  Taspell_string_list_empty=function(ths:AspellStringList):integer; cdecl;
  Taspell_string_list_size=function(ths:AspellStringList):Word; cdecl;
  Taspell_string_list_elements=function(ths:AspellStringList):AspellStringEnumeration; cdecl;
  Taspell_string_list_add=function(ths:AspellStringList; to_add:PChar):integer; cdecl;
  Taspell_string_list_remove=function(ths:AspellStringList; to_rem:PChar):integer; cdecl;
  Taspell_string_list_clear=procedure(ths:AspellStringList); cdecl;
  Taspell_string_list_to_mutable_container=function(ths:AspellStringList):AspellMutableContainer; cdecl;
  Tdelete_aspell_string_list=procedure(ths:AspellStringList); cdecl;
  Taspell_string_list_clone=function(ths:AspellStringList):AspellStringList; cdecl;
  Taspell_string_list_assign=procedure(ths:AspellStringList; other:AspellStringList); cdecl;

{****************************** string map ******************************}
  Tnew_aspell_string_map=function:AspellStringMap; cdecl;
  Taspell_string_map_add=function(ths:AspellStringMap; to_add:PChar):integer; cdecl; 
  Taspell_string_map_remove=function(ths:AspellStringMap; to_rem:PChar):integer; cdecl; 
  Taspell_string_map_clear=procedure(ths:AspellStringMap); cdecl;
  Taspell_string_map_to_mutable_container=function(ths:AspellStringMap):AspellMutableContainer; cdecl;
  Tdelete_aspell_string_map=procedure(ths:AspellStringMap); cdecl; 
  Taspell_string_map_clone=function(ths:AspellStringMap):AspellStringMap; cdecl;
  Taspell_string_map_assign=procedure(ths:AspellStringMap; other:AspellStringMap); cdecl; 
  Taspell_string_map_empty=function(ths:AspellStringMap):integer; cdecl;

  Taspell_string_map_size=function(ths:AspellStringMap):Word; cdecl;
  Taspell_string_map_elements=function(ths:AspellStringMap):AspellStringPairEnumeration; cdecl;

{* Insert a new element.
 * Will NOT overright an existing entry.
 * Returns false if the element already exists. *}
  Taspell_string_map_insert=function(ths:AspellStringMap; key:PChar; value:PChar):integer; cdecl;

{* Insert a new element.
 * Will overright an existing entry.
 * Always returns true. *}
  Taspell_string_map_replace=function(ths:AspellStringMap; key:Pchar; value:PChar):integer; cdecl;

{* Looks up an element.
 * Returns null if the element did not exist.
 * Returns an empty string if the element exists but has a null value.
 * Otherwises returns the value *}
  Taspell_string_map_lookup=function(ths:AspellStringMap; key:PChar):PChar; cdecl;

{***************************** string pair *****************************}
{*********************** string pair enumeration ***********************}
  Taspell_string_pair_enumeration_at_end=function(ths:AspellStringPairEnumeration):integer; cdecl;
  Taspell_string_pair_enumeration_next=function(ths:AspellStringPairEnumeration):AspellStringPair; cdecl;
  Tdelete_aspell_string_pair_enumeration=procedure(ths:AspellStringPairEnumeration); cdecl;
  Taspell_string_pair_enumeration_clone=function(ths:AspellStringPairEnumeration):AspellStringPairEnumeration; cdecl;
  Taspell_string_pair_enumeration_assign=procedure(ths:AspellStringPairEnumeration; other:AspellStringPairEnumeration); cdecl;

var
  aspell_mutable_container_add                  : Taspell_mutable_container_add;
  aspell_mutable_container_remove               : Taspell_mutable_container_remove;
  aspell_mutable_container_clear                : Taspell_mutable_container_clear;
  aspell_mutable_container_to_mutable_container : Taspell_mutable_container_to_mutable_container;
  aspell_key_info_enumeration_at_end            : Taspell_key_info_enumeration_at_end;
  aspell_key_info_enumeration_next              : Taspell_key_info_enumeration_next;
  delete_aspell_key_info_enumeration            : Tdelete_aspell_key_info_enumeration;
  aspell_key_info_enumeration_clone             : Taspell_key_info_enumeration_clone;
  aspell_key_info_enumeration_assign            : Taspell_key_info_enumeration_assign;
  new_aspell_config                             : Tnew_aspell_config;
  delete_aspell_config                          : Tdelete_aspell_config;
  aspell_config_clone                           : Taspell_config_clone;
  aspell_config_assign                          : Taspell_config_assign;
  aspell_config_error_number                    : Taspell_config_error_number;
  aspell_config_error_message                   : Taspell_config_error_message;
  aspell_config_error                           : Taspell_config_error;
  aspell_config_set_extra                       : Taspell_config_set_extra;
  aspell_config_keyinfo                         : Taspell_config_keyinfo;
  aspell_config_possible_elements               : Taspell_config_possible_elements;
  aspell_config_get_default                     : Taspell_config_get_default;
  aspell_config_elements                        : Taspell_config_elements;
  aspell_config_replace                         : Taspell_config_replace;
  aspell_config_remove                          : Taspell_config_remove;
  aspell_config_have                            : Taspell_config_have;
  aspell_config_retrieve                        : Taspell_config_retrieve;
  aspell_config_retrieve_list                   : Taspell_config_retrieve_list;
  aspell_config_retrieve_bool                   : Taspell_config_retrieve_bool;
  aspell_config_retrieve_int                    : Taspell_config_retrieve_int;
  aspell_error_number                           : Taspell_error_number;
  aspell_error_message                          : Taspell_error_message;
  aspell_error                                  : Taspell_error;
  delete_aspell_can_have_error                  : Tdelete_aspell_can_have_error;
  new_aspell_speller                            : Tnew_aspell_speller;
  to_aspell_speller                             : Tto_aspell_speller;
  delete_aspell_speller                         : Tdelete_aspell_speller;
  aspell_speller_error_number                   : Taspell_speller_error_number;
  aspell_speller_error_message                  : Taspell_speller_error_message;
  aspell_speller_error                          : Taspell_speller_error;
  aspell_speller_config                         : Taspell_speller_config;
  aspell_speller_check                          : Taspell_speller_check;
  aspell_speller_add_to_personal                : Taspell_speller_add_to_personal;
  aspell_speller_add_to_session                 : Taspell_speller_add_to_session;
  aspell_speller_personal_word_list             : Taspell_speller_personal_word_list;
  aspell_speller_session_word_list              : Taspell_speller_session_word_list;
  aspell_speller_main_word_list                 : Taspell_speller_main_word_list;
  aspell_speller_save_all_word_lists            : Taspell_speller_save_all_word_lists;
  aspell_speller_clear_session                  : Taspell_speller_clear_session;
  aspell_speller_suggest                        : Taspell_speller_suggest;
  aspell_speller_store_replacement              : Taspell_speller_store_replacement;
  delete_aspell_filter                          : Tdelete_aspell_filter;
  aspell_filter_error_number                    : Taspell_filter_error_number;
  aspell_filter_error_message                   : Taspell_filter_error_message;
  aspell_filter_error                           : Taspell_filter_error;
  to_aspell_filter                              : Tto_aspell_filter;
  delete_aspell_document_checker                : Tdelete_aspell_document_checker;
  aspell_document_checker_error_number          : Taspell_document_checker_error_number;
  aspell_document_checker_error_message         : Taspell_document_checker_error_message;
  aspell_document_checker_error                 : Taspell_document_checker_error;
  new_aspell_document_checker                   : Tnew_aspell_document_checker;
  to_aspell_document_checker                    : Tto_aspell_document_checker;
  aspell_document_checker_reset                 : Taspell_document_checker_reset;
  aspell_document_checker_process               : Taspell_document_checker_process;
  aspell_document_checker_next_misspelling      : Taspell_document_checker_next_misspelling;
  aspell_document_checker_filter                : Taspell_document_checker_filter;
  aspell_word_list_empty                        : Taspell_word_list_empty;
  aspell_word_list_size                         : Taspell_word_list_size;
  aspell_word_list_elements                     : Taspell_word_list_elements;
  delete_aspell_string_enumeration              : Tdelete_aspell_string_enumeration;
  aspell_string_enumeration_clone               : Taspell_string_enumeration_clone;
  aspell_string_enumeration_assign              : Taspell_string_enumeration_assign;
  aspell_string_enumeration_at_end              : Taspell_string_enumeration_at_end;
  aspell_string_enumeration_next                : Taspell_string_enumeration_next;
  get_aspell_module_info_list                   : Tget_aspell_module_info_list;
  aspell_module_info_list_empty                 : Taspell_module_info_list_empty;
  aspell_module_info_list_size                  : Taspell_module_info_list_size;
  aspell_module_info_list_elements              : Taspell_module_info_list_elements;
  get_aspell_dict_info_list                     : Tget_aspell_dict_info_list;
  aspell_dict_info_list_empty                   : Taspell_dict_info_list_empty;
  aspell_dict_info_list_size                    : Taspell_dict_info_list_size;
  aspell_dict_info_list_elements                : Taspell_dict_info_list_elements;
  aspell_module_info_enumeration_at_end         : Taspell_module_info_enumeration_at_end;
  aspell_module_info_enumeration_next           : Taspell_module_info_enumeration_next;
  delete_aspell_module_info_enumeration         : Tdelete_aspell_module_info_enumeration;
  aspell_module_info_enumeration_clone          : Taspell_module_info_enumeration_clone;
  aspell_module_info_enumeration_assign         : Taspell_module_info_enumeration_assign;
  aspell_dict_info_enumeration_at_end           : Taspell_dict_info_enumeration_at_end;
  aspell_dict_info_enumeration_next             : Taspell_dict_info_enumeration_next;
  delete_aspell_dict_info_enumeration           : Tdelete_aspell_dict_info_enumeration;
  aspell_dict_info_enumeration_clone            : Taspell_dict_info_enumeration_clone;
  aspell_dict_info_enumeration_assign           : Taspell_dict_info_enumeration_assign;
  new_aspell_string_list                        : Tnew_aspell_string_list;
  aspell_string_list_empty                      : Taspell_string_list_empty;
  aspell_string_list_size                       : Taspell_string_list_size;
  aspell_string_list_elements                   : Taspell_string_list_elements;
  aspell_string_list_add                        : Taspell_string_list_add;
  aspell_string_list_remove                     : Taspell_string_list_remove;
  aspell_string_list_clear                      : Taspell_string_list_clear;
  aspell_string_list_to_mutable_container       : Taspell_string_list_to_mutable_container;
  delete_aspell_string_list                     : Tdelete_aspell_string_list;
  aspell_string_list_clone                      : Taspell_string_list_clone;
  aspell_string_list_assign                     : Taspell_string_list_assign;
  new_aspell_string_map                         : Tnew_aspell_string_map;
  aspell_string_map_add                         : Taspell_string_map_add;
  aspell_string_map_remove                      : Taspell_string_map_remove;
  aspell_string_map_clear                       : Taspell_string_map_clear;
  aspell_string_map_to_mutable_container        : Taspell_string_map_to_mutable_container;
  delete_aspell_string_map                      : Tdelete_aspell_string_map;
  aspell_string_map_clone                       : Taspell_string_map_clone;
  aspell_string_map_assign                      : Taspell_string_map_assign;
  aspell_string_map_empty                       : Taspell_string_map_empty;
  aspell_string_map_size                        : Taspell_string_map_size;
  aspell_string_map_elements                    : Taspell_string_map_elements;
  aspell_string_map_insert                      : Taspell_string_map_insert;
  aspell_string_map_replace                     : Taspell_string_map_replace;
  aspell_string_map_lookup                      : Taspell_string_map_lookup;
  aspell_string_pair_enumeration_at_end         : Taspell_string_pair_enumeration_at_end;
  aspell_string_pair_enumeration_next           : Taspell_string_pair_enumeration_next;
  delete_aspell_string_pair_enumeration         : Tdelete_aspell_string_pair_enumeration;
  aspell_string_pair_enumeration_clone          : Taspell_string_pair_enumeration_clone;
  aspell_string_pair_enumeration_assign         : Taspell_string_pair_enumeration_assign;

{******************************** errors ********************************}
var
  aerror_other,
  aerror_operation_not_supported,
    aerror_cant_copy,
  aerror_file,
    aerror_cant_open_file,
      aerror_cant_read_file,
      aerror_cant_write_file,
    aerror_invalid_name,
    aerror_bad_file_format,
  aerror_dir,
    aerror_cant_read_dir,
  aerror_config,
    aerror_unknown_key,
    aerror_cant_change_value,
    aerror_bad_key,
    aerror_bad_value,
    aerror_duplicate,
  aerror_language_related,
    aerror_unknown_language,
    aerror_unknown_soundslike,
    aerror_language_not_supported,
    aerror_no_wordlist_for_lang,
    aerror_mismatched_language,
  aerror_encoding,
    aerror_unknown_encoding,
    aerror_encoding_not_supported,
    aerror_conversion_not_supported,
  aerror_pipe,
    aerror_cant_create_pipe,
    aerror_process_died,
  aerror_bad_input,
    aerror_invalid_word,
    aerror_word_list_flags,
      aerror_invalid_flag,
      aerror_conflicting_flags
    : AspellErrorInfo ;

implementation

uses registry;

type
  THandle = integer;
  DWORD   = LongWord;
  HMODULE = DWORD;
  LPCSTR  = PAnsiChar;
  FARPROC = pointer;

const
  HKEY_CLASSES_ROOT     = DWORD($80000000);
  HKEY_CURRENT_USER     = DWORD($80000001);
  HKEY_LOCAL_MACHINE    = DWORD($80000002);
  HKEY_USERS            = DWORD($80000003);
  HKEY_PERFORMANCE_DATA = DWORD($80000004);
  HKEY_CURRENT_CONFIG   = DWORD($80000005);
  HKEY_DYN_DATA         = DWORD($80000006);

  function GetProcAddress(hModule: HMODULE; lpProcName: LPCSTR): FARPROC;
    stdcall; external 'kernel32.dll' name 'GetProcAddress';
  function LoadLibrary(lpLibFileName: PChar): HMODULE;
    stdcall; external 'kernel32.dll' name 'LoadLibraryA';

function LoadAspell(dllname:string=ASPELLDLL):boolean;
var AspellHandle:THandle;
    reg:TRegistry;
    sver:string;
  function LinkFunctions:boolean;
  begin
    Result := false;
    try
      @aspell_mutable_container_add                  := GetProcAddress(AspellHandle, 'aspell_mutable_container_add');
      @aspell_mutable_container_remove               := GetProcAddress(AspellHandle, 'aspell_mutable_container_remove');
      @aspell_mutable_container_clear                := GetProcAddress(AspellHandle, 'aspell_mutable_container_clear');
      @aspell_mutable_container_to_mutable_container := GetProcAddress(AspellHandle, 'aspell_mutable_container_to_mutable_container');
      @aspell_key_info_enumeration_at_end            := GetProcAddress(AspellHandle, 'aspell_key_info_enumeration_at_end');
      @aspell_key_info_enumeration_next              := GetProcAddress(AspellHandle, 'aspell_key_info_enumeration_next');
      @delete_aspell_key_info_enumeration            := GetProcAddress(AspellHandle, 'delete_aspell_key_info_enumeration');
      @aspell_key_info_enumeration_clone             := GetProcAddress(AspellHandle, 'aspell_key_info_enumeration_clone');
      @aspell_key_info_enumeration_assign            := GetProcAddress(AspellHandle, 'aspell_key_info_enumeration_assign');
      @new_aspell_config                             := GetProcAddress(AspellHandle, 'new_aspell_config');
      @delete_aspell_config                          := GetProcAddress(AspellHandle, 'delete_aspell_config');
      @aspell_config_clone                           := GetProcAddress(AspellHandle, 'aspell_config_clone');
      @aspell_config_assign                          := GetProcAddress(AspellHandle, 'aspell_config_assign');
      @aspell_config_error_number                    := GetProcAddress(AspellHandle, 'aspell_config_error_number');
      @aspell_config_error_message                   := GetProcAddress(AspellHandle, 'aspell_config_error_message');
      @aspell_config_error                           := GetProcAddress(AspellHandle, 'aspell_config_error');
      @aspell_config_set_extra                       := GetProcAddress(AspellHandle, 'aspell_config_set_extra');
      @aspell_config_keyinfo                         := GetProcAddress(AspellHandle, 'aspell_config_keyinfo');
      @aspell_config_possible_elements               := GetProcAddress(AspellHandle, 'aspell_config_possible_elements');
      @aspell_config_get_default                     := GetProcAddress(AspellHandle, 'aspell_config_get_default');
      @aspell_config_elements                        := GetProcAddress(AspellHandle, 'aspell_config_elements');
      @aspell_config_replace                         := GetProcAddress(AspellHandle, 'aspell_config_replace');
      @aspell_config_remove                          := GetProcAddress(AspellHandle, 'aspell_config_remove');
      @aspell_config_have                            := GetProcAddress(AspellHandle, 'aspell_config_have');
      @aspell_config_retrieve                        := GetProcAddress(AspellHandle, 'aspell_config_retrieve');
      @aspell_config_retrieve_list                   := GetProcAddress(AspellHandle, 'aspell_config_retrieve_list');
      @aspell_config_retrieve_bool                   := GetProcAddress(AspellHandle, 'aspell_config_retrieve_bool');
      @aspell_config_retrieve_int                    := GetProcAddress(AspellHandle, 'aspell_config_retrieve_int');
      @aspell_error_number                           := GetProcAddress(AspellHandle, 'aspell_error_number');
      @aspell_error_message                          := GetProcAddress(AspellHandle, 'aspell_error_message');
      @aspell_error                                  := GetProcAddress(AspellHandle, 'aspell_error');
      @delete_aspell_can_have_error                  := GetProcAddress(AspellHandle, 'delete_aspell_can_have_error');
      @new_aspell_speller                            := GetProcAddress(AspellHandle, 'new_aspell_speller');
      @to_aspell_speller                             := GetProcAddress(AspellHandle, 'to_aspell_speller');
      @delete_aspell_speller                         := GetProcAddress(AspellHandle, 'delete_aspell_speller');
      @aspell_speller_error_number                   := GetProcAddress(AspellHandle, 'aspell_speller_error_number');
      @aspell_speller_error_message                  := GetProcAddress(AspellHandle, 'aspell_speller_error_message');
      @aspell_speller_error                          := GetProcAddress(AspellHandle, 'aspell_speller_error');
      @aspell_speller_config                         := GetProcAddress(AspellHandle, 'aspell_speller_config');
      @aspell_speller_check                          := GetProcAddress(AspellHandle, 'aspell_speller_check');
      @aspell_speller_add_to_personal                := GetProcAddress(AspellHandle, 'aspell_speller_add_to_personal');
      @aspell_speller_add_to_session                 := GetProcAddress(AspellHandle, 'aspell_speller_add_to_session');
      @aspell_speller_personal_word_list             := GetProcAddress(AspellHandle, 'aspell_speller_personal_word_list');
      @aspell_speller_session_word_list              := GetProcAddress(AspellHandle, 'aspell_speller_session_word_list');
      @aspell_speller_main_word_list                 := GetProcAddress(AspellHandle, 'aspell_speller_main_word_list');
      @aspell_speller_save_all_word_lists            := GetProcAddress(AspellHandle, 'aspell_speller_save_all_word_lists');
      @aspell_speller_clear_session                  := GetProcAddress(AspellHandle, 'aspell_speller_clear_session');
      @aspell_speller_suggest                        := GetProcAddress(AspellHandle, 'aspell_speller_suggest');
      @aspell_speller_store_replacement              := GetProcAddress(AspellHandle, 'aspell_speller_store_replacement');
      @delete_aspell_filter                          := GetProcAddress(AspellHandle, 'delete_aspell_filter');
      @aspell_filter_error_number                    := GetProcAddress(AspellHandle, 'aspell_filter_error_number');
      @aspell_filter_error_message                   := GetProcAddress(AspellHandle, 'aspell_filter_error_message');
      @aspell_filter_error                           := GetProcAddress(AspellHandle, 'aspell_filter_error');
      @to_aspell_filter                              := GetProcAddress(AspellHandle, 'to_aspell_filter');
      @delete_aspell_document_checker                := GetProcAddress(AspellHandle, 'delete_aspell_document_checker');
      @aspell_document_checker_error_number          := GetProcAddress(AspellHandle, 'aspell_document_checker_error_number');
      @aspell_document_checker_error_message         := GetProcAddress(AspellHandle, 'aspell_document_checker_error_message');
      @aspell_document_checker_error                 := GetProcAddress(AspellHandle, 'aspell_document_checker_error');
      @new_aspell_document_checker                   := GetProcAddress(AspellHandle, 'new_aspell_document_checker');
      @to_aspell_document_checker                    := GetProcAddress(AspellHandle, 'to_aspell_document_checker');
      @aspell_document_checker_reset                 := GetProcAddress(AspellHandle, 'aspell_document_checker_reset');
      @aspell_document_checker_process               := GetProcAddress(AspellHandle, 'aspell_document_checker_process');
      @aspell_document_checker_next_misspelling      := GetProcAddress(AspellHandle, 'aspell_document_checker_next_misspelling');
      @aspell_document_checker_filter                := GetProcAddress(AspellHandle, 'aspell_document_checker_filter');
      @aspell_word_list_empty                        := GetProcAddress(AspellHandle, 'aspell_word_list_empty');
      @aspell_word_list_size                         := GetProcAddress(AspellHandle, 'aspell_word_list_size');
      @aspell_word_list_elements                     := GetProcAddress(AspellHandle, 'aspell_word_list_elements');
      @delete_aspell_string_enumeration              := GetProcAddress(AspellHandle, 'delete_aspell_string_enumeration');
      @aspell_string_enumeration_clone               := GetProcAddress(AspellHandle, 'aspell_string_enumeration_clone');
      @aspell_string_enumeration_assign              := GetProcAddress(AspellHandle, 'aspell_string_enumeration_assign');
      @aspell_string_enumeration_at_end              := GetProcAddress(AspellHandle, 'aspell_string_enumeration_at_end');
      @aspell_string_enumeration_next                := GetProcAddress(AspellHandle, 'aspell_string_enumeration_next');
      @get_aspell_module_info_list                   := GetProcAddress(AspellHandle, 'get_aspell_module_info_list');
      @aspell_module_info_list_empty                 := GetProcAddress(AspellHandle, 'aspell_module_info_list_empty');
      @aspell_module_info_list_size                  := GetProcAddress(AspellHandle, 'aspell_module_info_list_size');
      @aspell_module_info_list_elements              := GetProcAddress(AspellHandle, 'aspell_module_info_list_elements');
      @get_aspell_dict_info_list                     := GetProcAddress(AspellHandle, 'get_aspell_dict_info_list');
      @aspell_dict_info_list_empty                   := GetProcAddress(AspellHandle, 'aspell_dict_info_list_empty');
      @aspell_dict_info_list_size                    := GetProcAddress(AspellHandle, 'aspell_dict_info_list_size');
      @aspell_dict_info_list_elements                := GetProcAddress(AspellHandle, 'aspell_dict_info_list_elements');
      @aspell_module_info_enumeration_at_end         := GetProcAddress(AspellHandle, 'aspell_module_info_enumeration_at_end');
      @aspell_module_info_enumeration_next           := GetProcAddress(AspellHandle, 'aspell_module_info_enumeration_next');
      @delete_aspell_module_info_enumeration         := GetProcAddress(AspellHandle, 'delete_aspell_module_info_enumeration');
      @aspell_module_info_enumeration_clone          := GetProcAddress(AspellHandle, 'aspell_module_info_enumeration_clone');
      @aspell_module_info_enumeration_assign         := GetProcAddress(AspellHandle, 'aspell_module_info_enumeration_assign');
      @aspell_dict_info_enumeration_at_end           := GetProcAddress(AspellHandle, 'aspell_dict_info_enumeration_at_end');
      @aspell_dict_info_enumeration_next             := GetProcAddress(AspellHandle, 'aspell_dict_info_enumeration_next');
      @delete_aspell_dict_info_enumeration           := GetProcAddress(AspellHandle, 'delete_aspell_dict_info_enumeration');
      @aspell_dict_info_enumeration_clone            := GetProcAddress(AspellHandle, 'aspell_dict_info_enumeration_clone');
      @aspell_dict_info_enumeration_assign           := GetProcAddress(AspellHandle, 'aspell_dict_info_enumeration_assign');
      @new_aspell_string_list                        := GetProcAddress(AspellHandle, 'new_aspell_string_list');
      @aspell_string_list_empty                      := GetProcAddress(AspellHandle, 'aspell_string_list_empty');
      @aspell_string_list_size                       := GetProcAddress(AspellHandle, 'aspell_string_list_size');
      @aspell_string_list_elements                   := GetProcAddress(AspellHandle, 'aspell_string_list_elements');
      @aspell_string_list_add                        := GetProcAddress(AspellHandle, 'aspell_string_list_add');
      @aspell_string_list_remove                     := GetProcAddress(AspellHandle, 'aspell_string_list_remove');
      @aspell_string_list_clear                      := GetProcAddress(AspellHandle, 'aspell_string_list_clear');
      @aspell_string_list_to_mutable_container       := GetProcAddress(AspellHandle, 'aspell_string_list_to_mutable_container');
      @delete_aspell_string_list                     := GetProcAddress(AspellHandle, 'delete_aspell_string_list');
      @aspell_string_list_clone                      := GetProcAddress(AspellHandle, 'aspell_string_list_clone');
      @aspell_string_list_assign                     := GetProcAddress(AspellHandle, 'aspell_string_list_assign');
      @new_aspell_string_map                         := GetProcAddress(AspellHandle, 'new_aspell_string_map');
      @aspell_string_map_add                         := GetProcAddress(AspellHandle, 'aspell_string_map_add');
      @aspell_string_map_remove                      := GetProcAddress(AspellHandle, 'aspell_string_map_remove');
      @aspell_string_map_clear                       := GetProcAddress(AspellHandle, 'aspell_string_map_clear');
      @aspell_string_map_to_mutable_container        := GetProcAddress(AspellHandle, 'aspell_string_map_to_mutable_container');
      @delete_aspell_string_map                      := GetProcAddress(AspellHandle, 'delete_aspell_string_map');
      @aspell_string_map_clone                       := GetProcAddress(AspellHandle, 'aspell_string_map_clone');
      @aspell_string_map_assign                      := GetProcAddress(AspellHandle, 'aspell_string_map_assign');
      @aspell_string_map_empty                       := GetProcAddress(AspellHandle, 'aspell_string_map_empty');
      @aspell_string_map_size                        := GetProcAddress(AspellHandle, 'aspell_string_map_size');
      @aspell_string_map_elements                    := GetProcAddress(AspellHandle, 'aspell_string_map_elements');
      @aspell_string_map_insert                      := GetProcAddress(AspellHandle, 'aspell_string_map_insert');
      @aspell_string_map_replace                     := GetProcAddress(AspellHandle, 'aspell_string_map_replace');
      @aspell_string_map_lookup                      := GetProcAddress(AspellHandle, 'aspell_string_map_lookup');
      @aspell_string_pair_enumeration_at_end         := GetProcAddress(AspellHandle, 'aspell_string_pair_enumeration_at_end');
      @aspell_string_pair_enumeration_next           := GetProcAddress(AspellHandle, 'aspell_string_pair_enumeration_next');
      @delete_aspell_string_pair_enumeration         := GetProcAddress(AspellHandle, 'delete_aspell_string_pair_enumeration');
      @aspell_string_pair_enumeration_clone          := GetProcAddress(AspellHandle, 'aspell_string_pair_enumeration_clone');
      @aspell_string_pair_enumeration_assign         := GetProcAddress(AspellHandle, 'aspell_string_pair_enumeration_assign');

      aerror_other                       := GetProcAddress(AspellHandle, 'aerror_other');
      aerror_operation_not_supported     := GetProcAddress(AspellHandle, 'aerror_operation_not_supported');
        aerror_cant_copy                 := GetProcAddress(AspellHandle, 'aerror_cant_copy');
      aerror_file                        := GetProcAddress(AspellHandle, 'aerror_file');
        aerror_cant_open_file            := GetProcAddress(AspellHandle, 'aerror_cant_open_file');
          aerror_cant_read_file          := GetProcAddress(AspellHandle, 'aerror_cant_read_file');
          aerror_cant_write_file         := GetProcAddress(AspellHandle, 'aerror_cant_write_file');
        aerror_invalid_name              := GetProcAddress(AspellHandle, 'aerror_invalid_name');
        aerror_bad_file_format           := GetProcAddress(AspellHandle, 'aerror_bad_file_format');
      aerror_dir                         := GetProcAddress(AspellHandle, 'aerror_dir');
        aerror_cant_read_dir             := GetProcAddress(AspellHandle, 'aerror_cant_read_dir');
      aerror_config                      := GetProcAddress(AspellHandle, 'aerror_config');
        aerror_unknown_key               := GetProcAddress(AspellHandle, 'aerror_unknown_key');
        aerror_cant_change_value         := GetProcAddress(AspellHandle, 'aerror_cant_change_value');
        aerror_bad_key                   := GetProcAddress(AspellHandle, 'aerror_bad_key');
        aerror_bad_value                 := GetProcAddress(AspellHandle, 'aerror_bad_value');
        aerror_duplicate                 := GetProcAddress(AspellHandle, 'aerror_duplicate');
      aerror_language_related            := GetProcAddress(AspellHandle, 'aerror_language_related');
        aerror_unknown_language          := GetProcAddress(AspellHandle, 'aerror_unknown_language');
        aerror_unknown_soundslike        := GetProcAddress(AspellHandle, 'aerror_unknown_soundslike');
        aerror_language_not_supported    := GetProcAddress(AspellHandle, 'aerror_language_not_supported');
        aerror_no_wordlist_for_lang      := GetProcAddress(AspellHandle, 'aerror_no_wordlist_for_lang');
        aerror_mismatched_language       := GetProcAddress(AspellHandle, 'aerror_mismatched_language');
      aerror_encoding                    := GetProcAddress(AspellHandle, 'aerror_encoding');
        aerror_unknown_encoding          := GetProcAddress(AspellHandle, 'aerror_unknown_encoding');
        aerror_encoding_not_supported    := GetProcAddress(AspellHandle, 'aerror_encoding_not_supported');
        aerror_conversion_not_supported  := GetProcAddress(AspellHandle, 'aerror_conversion_not_supported');
      aerror_pipe                        := GetProcAddress(AspellHandle, 'aerror_pipe');
        aerror_cant_create_pipe          := GetProcAddress(AspellHandle, 'aerror_cant_create_pipe');
        aerror_process_died              := GetProcAddress(AspellHandle, 'aerror_process_died');
      aerror_bad_input                   := GetProcAddress(AspellHandle, 'aerror_bad_input');
        aerror_invalid_word              := GetProcAddress(AspellHandle, 'aerror_invalid_word');
        aerror_word_list_flags           := GetProcAddress(AspellHandle, 'aerror_word_list_flags');
          aerror_invalid_flag            := GetProcAddress(AspellHandle, 'aerror_invalid_flag');
          aerror_conflicting_flags       := GetProcAddress(AspellHandle, 'aerror_conflicting_flags');
    except
      exit;
    end;
    Result := true;
  end; // LinkFunctions
  // LoadAspell
begin
  if dllname = ''
  then
  begin
    reg:=TRegistry.Create;
    reg.RootKey := HKEY_LOCAL_MACHINE;
    if reg.OpenKey('\SOFTWARE\Aspell', False)
    then
    begin
      str(reg.ReadInteger('AspellVersion'), sver);
      dllname := reg.ReadString('Path') + '\aspell-' + sver + '.dll';
      reg.CloseKey;
      reg.Free;
    end
    else dllname := ASPELLDLL;
  end;

  AspellHandle := LoadLibrary(PChar(dllname));
  if AspellHandle <> 0
  then Result := LinkFunctions
  else Result := false;
end;

end.



