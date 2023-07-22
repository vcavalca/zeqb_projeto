*&---------------------------------------------------------------------*
*&  Include           ZEQB_IMPORT_TXT_CREDITO_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  F_SELECT_FILE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_P_FILE  text
*      <--P_P_FILE  text
*----------------------------------------------------------------------*

FORM f_select_file  USING    p_in_file
                    CHANGING p_out_file.

  CALL FUNCTION 'WS_FILENAME_GET'
    EXPORTING
      def_filename     = p_in_file
      def_path         = 'C:\'
   "  MASK             = ',*.*,*.*'
      mode             = 'S'
      title            = 'SELECÇÃO DE ARQUIVOS'
    IMPORTING
      filename         = p_out_file
*     RC               =
    EXCEPTIONS
      inv_winsys       = 1
      no_batch         = 2
      selection_cancel = 3
      selection_error  = 4
      OTHERS           = 5.
  .
  IF sy-subrc <> 0.
* IMPLEMENT SUITABLE ERROR HANDLING HERE
  ENDIF.

ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  F_GET_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_get_data .

  DATA: lo_file   TYPE REF TO zeqb_cartao_file,
        lv_string TYPE string,
        lo_save   TYPE REF TO zcleqb_save_tab,
        lv_msg    TYPE i.

  DATA: lv_today              TYPE sy-datum,
        lv_last_day_of_months TYPE sy-datum,
        lv_primeiro_dia       TYPE sy-datum.

  lv_today = sy-datum.

  CALL FUNCTION 'LAST_DAY_OF_MONTHS'
    EXPORTING
      day_in            = lv_today
    IMPORTING
      last_day_of_month = lv_last_day_of_months
    EXCEPTIONS
      day_in_no_date    = 1
      OTHERS            = 2.
  IF sy-subrc <> 0.
    CASE sy-subrc.
      WHEN 1.
        MESSAGE 'Data inválida' TYPE 'E'.
      WHEN OTHERS.
        MESSAGE 'Erro ao calcular o último dia do mês' TYPE 'E'.
    ENDCASE.
  ELSEIF sy-subrc = 0.
    lv_primeiro_dia = lv_last_day_of_months + 1.

  ENDIF.

  CREATE OBJECT lo_file.

  CREATE OBJECT lo_save.

  "SELECT VAI SER TROCADO POR UM OUTRO COM BASE NA NOVA TABELA
  SELECT * INTO TABLE @DATA(lt_codlinha)
    FROM zeqb_ticket.
*    WHERE cod_linha IN @s_codlin.

  IF sy-subrc EQ 0.

    LOOP AT lt_codlinha INTO DATA(lwa_codlinha).
      "TIRAR O CALL METHOD E CHAMAR A FUNÇÃO QUE VAI TER Q SER FEITA
      CALL METHOD lo_file->set_format
        EXPORTING
          in_codlinha  = lwa_codlinha-cod_linha
          in_codcartao = lwa_codlinha-cod_cartao
        IMPORTING
          out_line     = lv_string.


      CLEAR gwa_file.
      gwa_file-linha = lv_string.

      APPEND gwa_file TO gt_file.
      CLEAR lv_string.
      CALL METHOD lo_save->save_card
        EXPORTING
          in_cod_linha   = lwa_codlinha-cod_linha
          in_cod_cartao  = lwa_codlinha-cod_cartao
          in_valor_total = lwa_codlinha-valor_total
          in_dia_compra  = lv_primeiro_dia.


    ENDLOOP.

  ENDIF.

  IF gt_file IS NOT INITIAL.

    PERFORM f_save_file.

  ELSE.

    MESSAGE s001(zeqb_all_msg).

  ENDIF.

ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  F_SAVE_FILE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_save_file .

  DATA lv_name_file TYPE string.



  lv_name_file = p_file.


  CALL FUNCTION 'GUI_DOWNLOAD'
    EXPORTING
      filename                = lv_name_file
    TABLES
      data_tab                = gt_file
    EXCEPTIONS
      file_write_error        = 1
      no_batch                = 2
      gui_refuse_filetransfer = 3
      invalid_type            = 4
      no_authority            = 5
      unknown_error           = 6
      header_not_allowed      = 7
      separator_not_allowed   = 8
      filesize_not_allowed    = 9
      header_too_long         = 10
      dp_error_create         = 11
      dp_error_send           = 12
      dp_error_write          = 13
      unknown_dp_error        = 14
      access_denied           = 15
      dp_out_of_memory        = 16
      disk_full               = 17
      dp_timeout              = 18
      file_not_found          = 19
      dataprovider_exception  = 20
      control_flush_error     = 21
      OTHERS                  = 22.

  IF sy-subrc <> 0.
* Implement suitable error handling here

  ELSEIF sy-subrc EQ 0.

    MESSAGE s000(zeqb_all_msg).

  ENDIF.

ENDFORM.
