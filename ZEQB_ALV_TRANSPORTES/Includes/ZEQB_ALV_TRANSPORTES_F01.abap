*&---------------------------------------------------------------------*
*&  Include           ZEQB_ALV_TRANSPORTES_F01
*&---------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*&      Form  F_GET_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form f_get_data.

  if p_codli is not initial.
    select cod_linha nome_linha val_unit waers into table gt_upload
      from zeqb_cadlinhas
      where cod_linha eq p_codli.
  else.
    select cod_linha nome_linha val_unit waers into table gt_upload
      from zeqb_cadlinhas.
  endif.

  sort gt_upload by cod_linha.
  refresh gt_report.

  loop at gt_upload into gwa_upload.
    clear gwa_report.
    gwa_report-cod_linha  = gwa_upload-cod_linha.
    gwa_report-nome_linha = gwa_upload-nome_linha.
    gwa_report-val_unit   = gwa_upload-val_unit.
    gwa_report-waers      = gwa_upload-waers.

    append gwa_report to gt_report.
  endloop.


endform.
*&---------------------------------------------------------------------*
*&      Form  F_PRINT_ALV
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form f_print_alv .

  perform f_header.
  perform f_set_layout.
  perform set_field.

  call function 'REUSE_ALV_GRID_DISPLAY'
    exporting
      is_layout              = ty_layout           "Estrutura com detalhes do layout.
      i_callback_top_of_page = 'F_TOP_PAGE'          "Estrutura para montar o cabeçalho
      i_callback_program     = sy-repid            "variável do sistema (nome do programa). 'Sy-repid' = 'zcurso_alv1'
*     I_CALLBACK_USER_COMMAND = 'F_USER_COMMAND'    "Chama a função "HOTSPOT"
      i_save                 = 'A'                 "layouts podem ser salvos (aparece os botões para alteração do layout).
*     it_sort                = t_sort[]             "Efetua a quebra com o parametro determinado.
      it_fieldcat            = ty_fieldcat_col     "tabela com as colunas a serem impressas.
    tables
      t_outtab               = gt_report.          "Tabela com os dados a serem impressos.

endform.

*&---------------------------------------------------------------------*
*&      FORM  F_HEADER
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form f_header .

  data: vl_data(10),
        vl_hora(10).

  clear ty_watop.
  ty_watop-typ  = 'H'.    "H = Grande, destaque | S = Pequena | A = Média com itálico
  ty_watop-info = text-m01.

  append ty_watop to ty_top.

  clear ty_watop.

  ty_watop-typ  = 'S'.
  concatenate text-m02 sy-uname
    into ty_watop-info
      separated by space.

  append ty_watop to ty_top.

  clear ty_watop.

  ty_watop-typ  = 'S'.

  write sy-datum to vl_data using edit mask '__/__/____'.
  write sy-uzeit to vl_hora using edit mask '__:__'.

  concatenate text-m03 vl_data  vl_hora
    into ty_watop-info
      separated by space.

  append ty_watop to ty_top.

endform.                    " f_header

*&**********************************************************************
*&      FORM  F_TOP_PAGE                                               *
*&**********************************************************************
*       Defines the header of the ALV
*----------------------------------------------------------------------*
form f_top_page.
  call function 'REUSE_ALV_COMMENTARY_WRITE'
    exporting
      it_list_commentary = ty_top.
*      I_LOGO             = ''.

endform.                    "f_top_page

*&---------------------------------------------------------------------*
*&      FORM  F_SET_LAYOUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form f_set_layout .
  ty_layout-zebra             = 'X'.                            "Zebrado
  ty_layout-colwidth_optimize = 'X'.                            "Otimizar larguras de colunas automaticamente
endform.                    " F_SET_LAYOUT

*&---------------------------------------------------------------------*
*&      FORM  F_SET_FIELD
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form set_field .
  "CLEAR IT_HRP1000.

  perform f_set_column using  'COD_LINHA'         'GT_REPORT' text-t01      ' '  ' '  '12'  ' '  'L'  ' ' ' '.
  perform f_set_column using  'NOME_LINHA'        'GT_REPORT' text-t02      ' '  ' '  '80'  ' '  'L'  ' ' ' '.
  perform f_set_column using  'VAL_UNIT'          'GT_REPORT' text-t03      ' '  ' '  '20'  ' '  'L'  ' ' ' '.
  perform f_set_column using  'WAERS'             'GT_REPORT' text-t04      ' '  ' '  '20'  ' '  'L'  ' ' ' '.

endform.                    "F_SET_FIELD

*&---------------------------------------------------------------------*
*&       FORM f_set_column                                             *
*----------------------------------------------------------------------*
*        Clears all tables and variables.
*----------------------------------------------------------------------*
form f_set_column using p_fieldname
                        p_tabname
                        p_texto
                        p_ref_fieldname
                        p_ref_tabname
                        p_outputlen
                        p_emphasize
                        p_just
                        p_do_sum
                        p_icon.

  add 1 to vg_nrcol.
  ty_fieldcat-col_pos       = vg_nrcol.            "POSIÇÃO DO CAMPO (COLUNA).
  ty_fieldcat-fieldname     = p_fieldname.         "CAMPO DA TABELA INTERNA.
  ty_fieldcat-tabname       = p_tabname.           "TABELA INTERNA.
  ty_fieldcat-seltext_l     = p_texto.             "NOME/TEXTO DA COLUNA.
  ty_fieldcat-ref_fieldname = p_ref_fieldname.     "CAMPO DE REFERÊNCIA.
  ty_fieldcat-ref_tabname   = p_ref_tabname.       "TABELA DE REFERÊNCIA.
  ty_fieldcat-outputlen     = p_outputlen.         "LARGURA DA COLUNA.
  ty_fieldcat-emphasize     = p_emphasize.         "COLORE UMA COLUNA INTEIRA.
  ty_fieldcat-just          = p_just.              "
  ty_fieldcat-do_sum        = p_do_sum.            "TOTALIZA.
  ty_fieldcat-icon          = p_icon.

  append ty_fieldcat to ty_fieldcat_col.           "Insere linha na tabela interna TY_FIELDCAT_COL.

endform.                    "f_set_column
