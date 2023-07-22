*&---------------------------------------------------------------------*
*&  Include           ZEQB_IMPORT_CARD_TOP
*&---------------------------------------------------------------------*


*&---------------------------------------------------------------------*
*** Declaration of Tables
*&---------------------------------------------------------------------*



*&---------------------------------------------------------------------*
*** Declaration of types
*&---------------------------------------------------------------------*
TYPES: BEGIN OF TY_UPLOAD,
         LINE TYPE STRING,
       END OF TY_UPLOAD.


TYPES: BEGIN OF TY_FILE_FMT,

         CODCARTAO TYPE ZEQB_CARTOES-COD_CARTAO,
         CPF_NR    TYPE ZEQB_CARTOES-CPF,
         DATE_EM   TYPE ZEQB_CARTOES-DATA_EMISSAO,
         DATE_V    TYPE ZEQB_CARTOES-DATA_VALIDADE,

       END OF TY_FILE_FMT.


TYPES: BEGIN OF TY_REPORT,
         CODCARTAO TYPE ZEQB_CARTOES-COD_CARTAO,
         CPF_NR    TYPE ZEQB_CARTOES-CPF,
         DATE_EM   TYPE ZEQB_CARTOES-DATA_EMISSAO,
         DATE_V    TYPE ZEQB_CARTOES-DATA_VALIDADE,
       END OF TY_REPORT.

*&---------------------------------------------------------------------*
*** Declaration of global Internal Tables
*&---------------------------------------------------------------------*
DATA: GT_UPLOAD   TYPE TABLE OF TY_UPLOAD,
      GT_FILE_FMT TYPE TABLE OF TY_FILE_FMT,
      GT_REPORT   TYPE TABLE OF TY_REPORT.

*&---------------------------------------------------------------------*
*** Declaration of global work areas
*&---------------------------------------------------------------------*
DATA: GWA_FILE_FMT TYPE TY_FILE_FMT,
      GWA_REPORT   TYPE TY_REPORT.
*&---------------------------------------------------------------------*
*&  Alv Structures                                                  *
*&---------------------------------------------------------------------*
DATA:  vg_nrcol(4) TYPE c.

DATA: ty_layout       TYPE slis_layout_alv,
      ty_top          TYPE slis_t_listheader,
      ty_watop        TYPE slis_listheader,
      ty_fieldcat_col TYPE slis_t_fieldcat_alv,
      ty_fieldcat     TYPE slis_fieldcat_alv,
      ty_events       TYPE slis_t_event.

DATA : sch_repid TYPE sy-repid,
       sch_dynnr TYPE sy-dynnr,
       sch_field TYPE dynpread-fieldname,
       sch_objec TYPE objec,
       sch_subrc TYPE sy-subrc,
       per_beg   TYPE sy-datum,
       per_end   TYPE sy-datum.

TABLES hrvpv6a.
