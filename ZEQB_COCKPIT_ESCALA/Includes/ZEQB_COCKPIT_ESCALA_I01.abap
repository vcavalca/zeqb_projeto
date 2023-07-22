*&---------------------------------------------------------------------*
*&  Include           ZEQB_COCKPIT_ESCALA_I01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_9001  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE USER_COMMAND_9001 INPUT.
  DATA: LV_DATA_DE            TYPE DATS,
        LV_DATA_ATE           TYPE DATS,
        LV_QNT_DIAS           TYPE I,
        LV_QNT_DIAS_UTEIS     TYPE I,
        LV_CARTAO             TYPE ZEQB_CARTOES-COD_CARTAO,
        LV_MSG                TYPE I,
        LO_SAVE               TYPE REF TO ZCLEQB_SAVE_TICKET,
        CONT                  TYPE I,
        LV_TODAY              TYPE SY-DATUM,
        LV_PRIMEIRO_DIA       TYPE SY-DATUM,
        LV_LAST_DAY_OF_MONTHS TYPE SY-DATUM,
        LV_NEXT_MONTH         TYPE SY-DATUM.

  DATA: LT_ETH_DATS TYPE STANDARD TABLE OF RKE_DAT,
        DATA1       TYPE SY-DATUM,
        DATA2       TYPE SY-DATUM.

  DATA: LV_CODLIN   TYPE ZEQB_CADLINHA-COD_LINHA.


  LV_CARTAO = ZEQB_CARTOES-COD_CARTAO.
  LV_CODLIN = ZEQB_CADLINHAS-COD_LINHA.

  CASE SY-UCOMM.
    WHEN 'FSIMULAR'.
      SELECT SINGLE DATA_EMISSAO, DATA_VALIDADE INTO @DATA(LT_CARTAO)
        FROM ZEQB_CARTOES
        WHERE COD_CARTAO EQ @LV_CARTAO.

      IF SY-SUBRC <> 0.
        CLEAR GWA_CARTOES-DATA_EMISSAO.
        CLEAR GWA_CARTOES-DATA_VALIDADE.
      ELSE.
        GWA_CARTOES-DATA_EMISSAO = LT_CARTAO-DATA_EMISSAO.
        GWA_CARTOES-DATA_VALIDADE = LT_CARTAO-DATA_VALIDADE.
      ENDIF.

      SELECT SINGLE VAL_UNIT INTO @DATA(LT_LINHA)
        FROM ZEQB_CADLINHAS
        WHERE COD_LINHA EQ @LV_CODLIN.

      IF SY-SUBRC EQ 0.
        GWA_CADLIN-VAL_UNIT = LT_LINHA.
      ELSE.
        CLEAR GWA_CADLIN-VAL_UNIT.
        CLEAR VAL_TOT.
        CLEAR QTD_DIAS.
      ENDIF.

      LV_TODAY = SY-DATUM.

      CALL FUNCTION 'LAST_DAY_OF_MONTHS'
        EXPORTING
          DAY_IN            = LV_TODAY
        IMPORTING
          LAST_DAY_OF_MONTH = LV_LAST_DAY_OF_MONTHS
        EXCEPTIONS
          DAY_IN_NO_DATE    = 1
          OTHERS            = 2.
      IF SY-SUBRC <> 0.
        CASE SY-SUBRC.
          WHEN 1.
            MESSAGE 'Data inválida' TYPE 'E'.
          WHEN OTHERS.
            MESSAGE 'Erro ao calcular o último dia do mês' TYPE 'E'.
        ENDCASE.
      ELSEIF SY-SUBRC = 0.
        LV_PRIMEIRO_DIA = LV_LAST_DAY_OF_MONTHS + 1.

      ENDIF.

      CALL FUNCTION 'LAST_DAY_OF_MONTHS'
        EXPORTING
          DAY_IN            = LV_PRIMEIRO_DIA
        IMPORTING
          LAST_DAY_OF_MONTH = LV_NEXT_MONTH
        EXCEPTIONS
          DAY_IN_NO_DATE    = 1
          OTHERS            = 2.
      IF SY-SUBRC <> 0.
        CASE SY-SUBRC.
          WHEN 1.
            MESSAGE 'Data inválida' TYPE 'E'.
          WHEN OTHERS.
            MESSAGE 'Erro ao calcular o último dia do mês' TYPE 'E'.
        ENDCASE.

      ENDIF.

      CALL FUNCTION 'RKE_SELECT_FACTDAYS_FOR_PERIOD'
        EXPORTING
          I_DATAB               = LV_PRIMEIRO_DIA
          I_DATBI               = LV_NEXT_MONTH
          I_FACTID              = 'BR'
        TABLES
          ETH_DATS              = LT_ETH_DATS
        EXCEPTIONS
          DATE_CONVERSION_ERROR = 1
          OTHERS                = 2.

      IF SY-SUBRC EQ 0.
      ELSEIF SY-SUBRC <> 0.
        CASE SY-SUBRC.
          WHEN 1.
            MESSAGE 'Erro de conversão de data' TYPE 'E'.
          WHEN OTHERS.
            MESSAGE 'Erro desconhecido durante o cálculo dos dias úteis' TYPE 'E'.
        ENDCASE.
      ENDIF.

      CONT = 0.
      LOOP AT LT_ETH_DATS INTO DATA(LWA_COUNT).
        CONT = CONT + 1.
      ENDLOOP.

      QTD_DIAS = CONT.

      VAL_TOT = ( QTD_TICKET * QTD_DIAS ) * GWA_CADLIN-VAL_UNIT.

      LV_DATA_DE = LV_PRIMEIRO_DIA.
      LV_DATA_ATE = LV_NEXT_MONTH.

    WHEN 'FGRAVA'.
      CREATE OBJECT LO_SAVE.

      CALL METHOD LO_SAVE->SAVE_TICKET
        EXPORTING
          IN_COD_LINHA   = LV_CODLIN
          IN_COD_CARTAO  = LV_CARTAO
          IN_QTD_TICKET  = QTD_TICKET
          IN_QTD_DIAS    = QTD_DIAS
          IN_VALOR_TOTAL = VAL_TOT
        IMPORTING
          OUT_MSG        = LV_MSG.

      IF LV_MSG EQ 1.

        MESSAGE S001(ZEQB_ALL_MSG).
        CLEAR ZEQB_CADLINHAS-COD_LINHA.
        CLEAR GWA_CADLIN-VAL_UNIT.
        CLEAR QTD_TICKET.
        CLEAR VAL_TOT.
      ELSE.

        MESSAGE S002(ZEQB_ALL_MSG).

      ENDIF.

    WHEN 'BACK' OR 'EXIT' OR 'CANCEL'.
      LEAVE TO SCREEN 0.
  ENDCASE.

ENDMODULE.
