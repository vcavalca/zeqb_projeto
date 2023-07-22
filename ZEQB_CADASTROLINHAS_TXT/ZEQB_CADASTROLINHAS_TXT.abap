*======================================================================*
*                             HRST                                     *
*======================================================================*
* Author      : Fábrica ABAP                                           *
* Analist     : Letícia Martins                                        *
* Date        : 03/07/2023                                             *
*----------------------------------------------------------------------*
* Project     : Projeto Final HRST                                     *
* Report      : ZEQB_CADASTROLINHAS_TXT                                *
* Finality    :                                                        *
*----------------------------------------------------------------------*
* Changes History                                                      *
*----------------------------------------------------------------------*
* Date       | Author       | Finality                                 *
* 03/07/2023 | LGOMES       |                                          *
*======================================================================*

REPORT ZEQB_CADASTROLINHAS_TXT.

INCLUDE ZEQB_CADASTROLINHAS_TXT_TOP.
INCLUDE ZEQB_CADASTROLINHAS_TXT_SCR.
INCLUDE ZEQB_CADASTROLINHAS_TXT_F01.


AT SELECTION-SCREEN ON VALUE-REQUEST FOR P_FILE.
  PERFORM F_SELECT_FILE USING P_FILE
                         CHANGING P_FILE.


START-OF-SELECTION.
  PERFORM F_UPLOAD_FILE.

END-OF-SELECTION.
