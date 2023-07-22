*&---------------------------------------------------------------------*
*&  Include           ZEQB_EXTRACT_DATA_SCR
*&---------------------------------------------------------------------*

SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
SELECT-OPTIONS: s_pernr FOR pa0002-pernr NO INTERVALS.
PARAMETERS: p_file TYPE rlgrap-filename OBLIGATORY.
SELECTION-SCREEN END OF BLOCK b1.
