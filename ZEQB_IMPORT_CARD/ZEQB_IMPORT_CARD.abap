*======================================================================*
*                                                                      *
*                                HRST                                  *
*                                                                      *
*======================================================================*
* Author      : Grupo B                                                *
* Analist     : Guilherme Lima                                         *
* Date        : 03/07/2023                                             *
*----------------------------------------------------------------------*
* Project     : Projeto HRST                                           *
* Report      : ZEQB_IMPORT_CARD                                       *
* Finality    :                                                        *
*----------------------------------------------------------------------*
* Changes History                                                      *
*----------------------------------------------------------------------*
* Date       | Author         | Finality                               *
* 10/07/2023 | gferreira      |                                        *
*======================================================================*
REPORT ZEQB_IMPORT_CARD.

INCLUDE: ZEQB_IMPORT_CARD_TOP,
         ZEQB_IMPORT_CARD_SCR,
         ZEQB_IMPORT_CARD_F01.


AT SELECTION-SCREEN ON VALUE-REQUEST FOR P_FILE.
  PERFORM F_SELECT_FILE USING P_FILE
                         CHANGING P_FILE.


START-OF-SELECTION.
  PERFORM F_UPLOAD_FILE.
END-OF-SELECTION.
