*======================================================================*
*                                                                      *
*                                HRST                                  *
*                                                                      *
*======================================================================*
* Author      : Fábrica ABAP                                           *
* Analist     : Vinicius Moura                                         *
* Date        : 03/07/2023                                             *
*----------------------------------------------------------------------*
* Project     : Projeto HRST                                           *
* Report      : ZEQB_EXTRACT_DATA                                      *
* Finality    :                                                        *
*----------------------------------------------------------------------*
* Changes History                                                      *
*----------------------------------------------------------------------*
* Date       | Author         | Finality                               *
* 10/07/2023 | VMOURA         |                                        *
*======================================================================*
REPORT zeqb_extract_data.

INCLUDE: zeqb_extract_data_top,
         zeqb_extract_data_scr,
         zeqb_extract_data_f01.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_file.
  PERFORM f_select_file USING p_file
                         CHANGING p_file.

START-OF-SELECTION.

  PERFORM f_get_data.

END-OF-SELECTION.
