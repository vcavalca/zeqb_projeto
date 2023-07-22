*======================================================================*
*                                                                      *
*                                HRST                                  *
*                                                                      *
*======================================================================*
* Author      : Fábrica ABAP                                           *
* Analist     : Gustavo Lima                                           *
* Date        : 03/07/2023                                             *
*----------------------------------------------------------------------*
* Project     : Projeto HRST                                           *
* Report      : ZEQB_CARTAO_DEP_COLAB                                  *
* Finality    :                                                        *
*----------------------------------------------------------------------*
* Changes History                                                      *
*----------------------------------------------------------------------*
* Date       | Author         | Finality                               *
* 04/07/2023 | GLIMA          |                                        *
*======================================================================*
REPORT ZEQB_CARTAO_DEP_COLAB.

INCLUDE: ZEQB_CARTAO_DEP_COLAB_TOP,
         ZEQB_CARTAO_DEP_COLAB_F01.

START-OF-SELECTION.

  PERFORM F_GET_DATA.

END-OF-SELECTION.

  PERFORM F_PRINT_ALV.
