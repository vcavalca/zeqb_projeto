*&---------------------------------------------------------------------*
*&  Include           ZEQB_ALV_TRANSPORTES_TOP
*&---------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*** Declaration of Tables
*&---------------------------------------------------------------------*

tables: zeqb_cadlinhas.

*&---------------------------------------------------------------------*
*** Declaration of types
*&---------------------------------------------------------------------*
types: begin of ty_report,
         cod_linha             type zeqb_cadlinhas-cod_linha,
         nome_linha            type zeqb_cadlinhas-nome_linha,
         val_unit              type zeqb_cadlinhas-val_unit,
         waers                 type zeqb_cadlinhas-waers,
       end of ty_report.
*&---------------------------------------------------------------------*
*** Declaration of global Internal Tables
*&---------------------------------------------------------------------*
data: gt_report                type table of ty_report,
      gt_upload                type table of ty_report.
*&---------------------------------------------------------------------*
*** Declaration of global work areas
*&---------------------------------------------------------------------*
data: gwa_report               type ty_report,
      gwa_upload               type ty_report.

*&---------------------------------------------------------------------*
*&  Alv Structures                                                  *
*&---------------------------------------------------------------------*
data:  vg_nrcol(4) type c.

data: ty_layout               type slis_layout_alv,
      ty_top                  type slis_t_listheader,
      ty_watop                type slis_listheader,
      ty_fieldcat_col         type slis_t_fieldcat_alv,
      ty_fieldcat             type slis_fieldcat_alv,
      ty_events               type slis_t_event.

data : sch_repid              type sy-repid,
       sch_dynnr              type sy-dynnr,
       sch_field              type dynpread-fieldname,
       sch_objec              type objec,
       sch_subrc              type sy-subrc,
       per_beg                type sy-datum,
       per_end                type sy-datum.

tables hrvpv6a.
