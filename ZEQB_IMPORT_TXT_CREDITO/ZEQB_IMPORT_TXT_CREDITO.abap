*======================================================================*
*                                                                      *
*                            HRST                                      *
*                                                                      *
*======================================================================*
* Author      : Fábrica ABAP                                           *
* Analist     : Francisco Rodrigues                                    *
* Date        : 03/07/2023                                             *
*----------------------------------------------------------------------*
* Project     : Projeto HRST                                           *
* Report      : ZEQB_IMPORT_TXT_CREDITO                                *
* Finality    :                                                        *
*----------------------------------------------------------------------*
* Changes History                                                      *
*----------------------------------------------------------------------*
* Date       | Author         | Finality                               *
* 03/07/2023 | Fneto          |                                        *
*======================================================================*
*&---------------------------------------------------------------------*
*& Report ZEQB_IMPORT_TXT_CREDITO
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zeqb_import_txt_credito.

INCLUDE zeqb_import_txt_credito_top.

INCLUDE zeqb_import_txt_credito_src.

INCLUDE zeqb_import_txt_credito_f01.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_file.
  PERFORM f_select_file USING p_file
                         CHANGING p_file.

START-OF-SELECTION.

  PERFORM f_get_data.

END-OF-SELECTION.
