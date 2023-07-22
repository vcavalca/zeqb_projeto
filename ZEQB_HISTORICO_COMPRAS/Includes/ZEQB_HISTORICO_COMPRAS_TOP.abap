*&---------------------------------------------------------------------*
*&  Include           ZEQB_HISTORICO_COMPRAS_TOP
*&---------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*** Declaração das estruturas transparentes
*&---------------------------------------------------------------------*
TABLES: ZEQB_HISTORICO.

*&---------------------------------------------------------------------*
*** Declaração dos tipos
*&---------------------------------------------------------------------*

TYPES: BEGIN OF TY_REPORT,
         COD_LINHA  TYPE ZEQB_HISTORICO-COD_LINHA,
         COD_CARTAO TYPE ZEQB_HISTORICO-COD_CARTAO,
         TOTAL_VAL  TYPE ZEQB_HISTORICO-TOTAL_VAL,
         DIA_COMPRA TYPE ZEQB_HISTORICO-DIA_COMPRA,
         WAERS      TYPE WAERS,
         NAME       TYPE ZEQB_HISTORICO-NAME,
       END OF TY_REPORT.

*&---------------------------------------------------------------------*
*** Declaração das tabelas internas
*&---------------------------------------------------------------------*
DATA: GT_REPORT TYPE TABLE OF TY_REPORT,
      GT_UPLOAD TYPE TABLE OF TY_REPORT.

*&---------------------------------------------------------------------*
*** Declaração das work areas globais
*&---------------------------------------------------------------------*
DATA: GWA_UPLOAD TYPE TY_REPORT.
      "GWA_REPORT TYPE TY_REPORT,

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
