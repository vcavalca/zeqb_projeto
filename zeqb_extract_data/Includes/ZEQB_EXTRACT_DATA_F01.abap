*&---------------------------------------------------------------------*
*&  Include           ZEQB_EXTRACT_DATA_F01
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
      mode             = 'S'
      title            = TEXT-002
    IMPORTING
      filename         = p_out_file
    EXCEPTIONS
      inv_winsys       = 1
      no_batch         = 2
      selection_cancel = 3
      selection_error  = 4
      OTHERS           = 5.
  .
  IF sy-subrc <> 0.
    CASE sy-subrc.
      WHEN 1.
        MESSAGE s015(zeqb_all_msg).
      WHEN 2.
        MESSAGE s016(zeqb_all_msg).
      WHEN 3.
        MESSAGE s017(zeqb_all_msg).
      WHEN 4.
        MESSAGE s018(zeqb_all_msg).
      WHEN OTHERS.
        MESSAGE s019(zeqb_all_msg).
    ENDCASE.
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
FORM f_get_data.
  DATA: lv_string         TYPE string,
        lv_parameter_date TYPE sy-datum.

  SELECT SINGLE low INTO @DATA(lv_low)
    FROM tvarvc
    WHERE name EQ 'ZEQB_ELEGIBLE_EMPLOYEES'.

  IF sy-subrc EQ 0.
    lv_parameter_date = lv_low.
  ELSE.
    lv_parameter_date = '19000101'.
  ENDIF.

  SELECT pernr INTO TABLE @DATA(lt_pernr)
    FROM pa0000
    WHERE pernr IN @s_pernr
    AND begda <= @sy-datum
    AND endda >= @sy-datum
    AND begda >= @lv_parameter_date.

  IF sy-subrc EQ 0.

    LOOP AT lt_pernr INTO DATA(lwa_pernr).

      CALL FUNCTION 'ZEQB_FMT_FILE'
        EXPORTING
          in_pernr = lwa_pernr-pernr
        IMPORTING
          out_line = lv_string.

      CLEAR gwa_file.
      gwa_file-line = lv_string.
      APPEND gwa_file TO gt_file.

    ENDLOOP.

  ELSEIF sy-subrc <> 0.

    MESSAGE s007(zeqb_all_msg).

  ENDIF.

  IF gt_file IS NOT INITIAL.

    PERFORM f_save_file.

  ELSE.

    MESSAGE s006(zeqb_all_msg).

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
    CASE sy-subrc.
      WHEN 1.
        MESSAGE 'Erro na gravação do arquivo' TYPE 'E'.
      WHEN 2.
        MESSAGE 'Operação de lote não permitida' TYPE 'E'.
      WHEN 3.
        MESSAGE s012(zeqb_all_msg).
      WHEN 4.
        MESSAGE s009(zeqb_all_msg).
      WHEN 5.
        MESSAGE s013(zeqb_all_msg).
      WHEN 6.
        MESSAGE 'Erro desconhecido' TYPE 'E'.
      WHEN 7.
        MESSAGE 'Cabeçalho não permitido' TYPE 'E'.
      WHEN 8.
        MESSAGE 'Separador não permitido' TYPE 'E'.
      WHEN 9.
        MESSAGE 'Tamanho do arquivo não permitido' TYPE 'E'.
      WHEN 10.
        MESSAGE 'Cabeçalho muito longo' TYPE 'E'.
      WHEN 11.
        MESSAGE 'Erro de criação no data provider' TYPE 'E'.
      WHEN 12.
        MESSAGE 'Erro de envio no data provider' TYPE 'E'.
      WHEN 13.
        MESSAGE 'Erro de gravação no data provider' TYPE 'E'.
      WHEN 14.
        MESSAGE 'Erro desconhecido no data provider' TYPE 'E'.
      WHEN 15.
        MESSAGE 'Acesso negado' TYPE 'E'.
      WHEN 16.
        MESSAGE 'Memória insuficiente' TYPE 'E'.
      WHEN 17.
        MESSAGE 'Disco cheio' TYPE 'E'.
      WHEN 18.
        MESSAGE 'Tempo limite excedido' TYPE 'E'.
      WHEN 19.
        MESSAGE 'Arquivo não encontrado' TYPE 'E'.
      WHEN 20.
        MESSAGE 'Exceção do provedor de dados' TYPE 'E'.
      WHEN 21.
        MESSAGE 'Erro de fluxo de controle' TYPE 'E'.
      WHEN OTHERS.
        MESSAGE s014(zeqb_all_msg).
    ENDCASE.

  ELSEIF sy-subrc EQ 0.

    MESSAGE s000(zeqb_all_msg).

  ENDIF.

ENDFORM.
