*&---------------------------------------------------------------------*
*&  Include           ZEQB_CADASTROLINHAS_TXT_TOP
*&---------------------------------------------------------------------*
TABLES: ZEQB_CADLINHAS.

TYPES: BEGIN OF TY_UPLOAD,
         LINE TYPE STRING,
       END OF TY_UPLOAD.


TYPES: BEGIN OF TY_FILE_FMT,

         COD_LINHA     TYPE ZEQB_CADLINHAS-COD_LINHA,
         NOME_LINHA    TYPE ZEQB_CADLINHAS-NOME_LINHA,
         VAL_UNIT      TYPE STRING,
         WAERS         TYPE ZEQB_CADLINHAS-WAERS,

       END OF TY_FILE_FMT.

*&---------------------------------------------------------------------*
*** Declaration of global Internal Tables
*&---------------------------------------------------------------------*
DATA: GT_UPLOAD   TYPE TABLE OF TY_UPLOAD,
      GT_FILE_FMT TYPE TABLE OF TY_FILE_FMT.

*&---------------------------------------------------------------------*
*** Declaration of global work areas
*&---------------------------------------------------------------------*
DATA: GWA_FILE_FMT TYPE TY_FILE_FMT.
