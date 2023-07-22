*======================================================================

*                                HRST

*======================================================================
* Author      : Fábrica ABAP
* Analist     : Otavio Henrique
* Date        : 27/06/2023
*----------------------------------------------------------------------
* Project     : Projeto ABAP
* Report      : ZEQB_ALV_TRANSPORTES
* Finality    :
*----------------------------------------------------------------------
* Changes History
*----------------------------------------------------------------------
* Date       | Author         | Finality
*            |                |
*======================================================================
report zeqb_alv_transportes.

*Declaration
include zeqb_alv_transportes_top.
*Screen
include zeqb_alv_transportes_scr.
*Code
include zeqb_alv_transportes_f01.

start-of-selection.

perform f_get_data.

perform f_print_alv.

end-of-selection.
