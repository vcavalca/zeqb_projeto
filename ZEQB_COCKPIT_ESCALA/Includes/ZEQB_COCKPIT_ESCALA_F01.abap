*&---------------------------------------------------------------------*
*&  Include           ZEQB_COCKPIT_ESCALA_F01
*&---------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*&      Form  F_SHOW_CARTOES
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM F_SHOW_CARTOES.

  DATA: LV_ID     TYPE VRM_ID,
        LT_VALUES TYPE VRM_VALUES,
        LS_VALUES LIKE LINE OF LT_VALUES,
        LV_PERNR  TYPE PA0002-PERNR,
        LV_NOME   TYPE PA0002-CNAME.

  SELECT * FROM ZEQB_CARTOES INTO TABLE @DATA(LT_EMP).
  IF SY-SUBRC IS INITIAL.

    LOOP AT LT_EMP INTO DATA(LS_EMP).
      SELECT * INTO TABLE @DATA(LT_CPF) FROM PA0465.
      IF SY-SUBRC EQ 0.
        LOOP AT LT_CPF INTO DATA(LWA_CPF).
          IF LWA_CPF-CPF_NR = LS_EMP-CPF.
            LV_PERNR = LWA_CPF-PERNR.
          ENDIF.
        ENDLOOP.
      ENDIF.

      SELECT * INTO TABLE @DATA(LT_NOME) FROM PA0002.
      IF SY-SUBRC EQ 0.
        LOOP AT LT_NOME INTO DATA(LWA_NOME).
          IF LWA_NOME-PERNR = LV_PERNR.
            LV_NOME = LWA_NOME-CNAME.
          ENDIF.
        ENDLOOP.
      ENDIF.

      LS_VALUES-KEY = LS_EMP-COD_CARTAO.
      LS_VALUES-TEXT = LV_NOME.

      APPEND LS_VALUES TO LT_VALUES.
      CLEAR LS_VALUES.

    ENDLOOP.

  ENDIF.

  LV_ID = 'ZEQB_CARTOES-COD_CARTAO'.

  CALL FUNCTION 'VRM_SET_VALUES'
    EXPORTING
      ID              = LV_ID
      VALUES          = LT_VALUES
    EXCEPTIONS
      ID_ILLEGAL_NAME = 1
      OTHERS          = 2.
  IF SY-SUBRC <> 0.
    CASE SY-SUBRC.
      WHEN 1.
        MESSAGE 'Nome de ID inválido' TYPE 'E'.
      WHEN OTHERS.
        MESSAGE 'Erro desconhecido ao definir os valores' TYPE 'E'.
    ENDCASE.
  ENDIF.

ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  F_SHOW_LINHAS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM F_SHOW_LINHAS.

  DATA: LV_ID_LINHA      TYPE VRM_ID,
        LT_VALUES_LINHA  TYPE VRM_VALUES,
        LWA_VALUES_LINHA LIKE LINE OF LT_VALUES_LINHA.

  SELECT * FROM ZEQB_CADLINHAS INTO TABLE @DATA(LT_TEMP_LINHAS).
  IF SY-SUBRC IS INITIAL.

    LOOP AT LT_TEMP_LINHAS INTO DATA(LWA_TEMP_LINHAS).
      LWA_VALUES_LINHA-KEY = LWA_TEMP_LINHAS-COD_LINHA.
      LWA_VALUES_LINHA-TEXT = LWA_TEMP_LINHAS-NOME_LINHA.

      APPEND LWA_VALUES_LINHA TO LT_VALUES_LINHA.
      CLEAR LWA_VALUES_LINHA.

    ENDLOOP.
  ENDIF.

  LV_ID_LINHA = 'ZEQB_CADLINHAS-COD_LINHA'.

  CALL FUNCTION 'VRM_SET_VALUES'
    EXPORTING
      ID              = LV_ID_LINHA
      VALUES          = LT_VALUES_LINHA
    EXCEPTIONS
      ID_ILLEGAL_NAME = 1
      OTHERS          = 2.
  IF SY-SUBRC <> 0.
    CASE SY-SUBRC.
      WHEN 1.
        MESSAGE 'Nome de ID inválido' TYPE 'E'.
      WHEN OTHERS.
        MESSAGE 'Erro desconhecido ao definir os valores' TYPE 'E'.
    ENDCASE.
  ENDIF.

ENDFORM.
