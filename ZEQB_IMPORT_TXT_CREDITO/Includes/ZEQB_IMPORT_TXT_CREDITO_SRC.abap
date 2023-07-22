*&---------------------------------------------------------------------*
*&  Include           ZEQB_IMPORT_TXT_CREDITO_SRC
*&---------------------------------------------------------------------*

SELECTION-SCREEN BEGIN OF BLOCK B1 WITH FRAME TITLE TEXT-001.

SELECT-OPTIONS: s_codlin FOR ZEQB_TICKET-COD_LINHA NO INTERVALS.

PARAMETERS: p_file TYPE rlgrap-filename OBLIGATORY.

SELECTION-SCREEN END OF BLOCK b1.
