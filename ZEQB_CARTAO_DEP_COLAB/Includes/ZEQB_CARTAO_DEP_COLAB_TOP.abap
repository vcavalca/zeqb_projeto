*&---------------------------------------------------------------------*
*&  Include           ZEQB_CARTAO_DEP_COLAB_TOP
*&---------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*** Declaração das estruturas transparentes
*&---------------------------------------------------------------------*
TABLES: ZEQB_CARTOES,
        PA0002.

*&---------------------------------------------------------------------*
*** Declaração dos tipos
*&---------------------------------------------------------------------*

*TYPES: BEGIN OF TY_UPLOAD,
*         COD_CARTAO    TYPE ZEQB_CARTOES-COD_CARTAO,
*         CPF           TYPE ZEQB_CARTOES-CPF,
*         DATA_EMISSAO  TYPE ZEQB_CARTOES-DATA_EMISSAO,
*         DATA_VALIDADE TYPE ZEQB_CARTOES-DATA_VALIDADE,
*       END OF TY_UPLOAD.

TYPES: BEGIN OF TY_REPORT,
         NAME          TYPE PA0002-CNAME,
         COD_CARTAO    TYPE ZEQB_CARTOES-COD_CARTAO,
         CPF           TYPE ZEQB_CARTOES-CPF,
         DATA_EMISSAO  TYPE ZEQB_CARTOES-DATA_EMISSAO,
         DATA_VALIDADE TYPE ZEQB_CARTOES-DATA_VALIDADE,
       END OF TY_REPORT.

*&---------------------------------------------------------------------*
*** Declaração das tabelas internas
*&---------------------------------------------------------------------*
DATA: GT_REPORT TYPE TABLE OF TY_REPORT.
*      GT_UPLOAD TYPE TABLE OF TY_UPLOAD.

*&---------------------------------------------------------------------*
*** Declaração das work areas globais
*&---------------------------------------------------------------------*
DATA: GWA_REPORT TYPE TY_REPORT.
*     GWA_UPLOAD TYPE TY_UPLOAD,


*&---------------------------------------------------------------------*
*&  ESTRUTURAS DO ALV                                                  *
*&---------------------------------------------------------------------*
DATA:  VG_NRCOL(4) TYPE C.

DATA: TY_LAYOUT       TYPE SLIS_LAYOUT_ALV,
      TY_TOP          TYPE SLIS_T_LISTHEADER,
      TY_WATOP        TYPE SLIS_LISTHEADER,
      TY_FIELDCAT_COL TYPE SLIS_T_FIELDCAT_ALV,
      TY_FIELDCAT     TYPE SLIS_FIELDCAT_ALV,
      TY_EVENTS       TYPE SLIS_T_EVENT.

DATA : SCH_REPID TYPE SY-REPID,
       SCH_DYNNR TYPE SY-DYNNR,
       SCH_FIELD TYPE DYNPREAD-FIELDNAME,
       SCH_OBJEC TYPE OBJEC,
       SCH_SUBRC TYPE SY-SUBRC,
       PER_BEG   TYPE SY-DATUM,
       PER_END   TYPE SY-DATUM.

TABLES HRVPV6A.
