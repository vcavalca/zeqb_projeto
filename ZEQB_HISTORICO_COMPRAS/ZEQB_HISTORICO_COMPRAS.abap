*======================================================================*
*                                                                      *
*                                HRST                                  *
*                                                                      *
*======================================================================*
* Author      : Fábrica ABAP                                           *
* Analist     : Gustavo Lima                                           *
* Date        : 06/07/2023                                             *
*----------------------------------------------------------------------*
* Project     : Projeto HRST                                           *
* Report      : ZEQB_HISTORICO_COMPRAS                                 *
* Finality    :                                                        *
*----------------------------------------------------------------------*
* Changes History                                                      *
*----------------------------------------------------------------------*
* Date       | Author         | Finality                               *
*            | GLIMA          |                                        *
*======================================================================*
REPORT ZEQB_HISTORICO_COMPRAS.

INCLUDE: ZEQB_HISTORICO_COMPRAS_TOP,
         ZEQB_HISTORICO_COMPRAS_SCR,
         ZEQB_HISTORICO_COMPRAS_F01.

START-OF-SELECTION.

  PERFORM F_GET_DATA.

END-OF-SELECTION.

  PERFORM F_PRINT_ALV.
