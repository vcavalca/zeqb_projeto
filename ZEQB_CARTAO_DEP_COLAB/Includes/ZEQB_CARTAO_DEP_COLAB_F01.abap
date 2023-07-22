*&---------------------------------------------------------------------*
*&  Include           ZEQB_CARTAO_DEP_COLAB_F01
*&---------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*&      Form  F_GET_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM F_GET_DATA .

  DATA: LV_PERNR TYPE PA0002-PERNR.
  DATA: LV_NAME TYPE PA0002-CNAME.

  SELECT * INTO TABLE @DATA(LT_UPLOAD)
    FROM ZEQB_CARTOES.

  IF SY-SUBRC EQ 0.

    LOOP AT LT_UPLOAD INTO DATA(LWA_UPLOAD).
      SELECT * INTO TABLE @DATA(LT_CPF) FROM PA0465.

      IF SY-SUBRC EQ 0.
        LOOP AT LT_CPF INTO DATA(LWA_CPF).

          IF LWA_CPF-CPF_NR = LWA_UPLOAD-CPF.
            LV_PERNR = LWA_CPF-PERNR.
          ENDIF.
        ENDLOOP.
      ENDIF.
      SELECT * INTO TABLE @DATA(LT_NAME) FROM PA0002.
      IF SY-SUBRC EQ 0.
        LOOP AT LT_NAME INTO DATA(LWA_NAME).
          IF LWA_NAME-PERNR = LV_PERNR.
            LV_NAME = LWA_NAME-CNAME.
          ENDIF.
        ENDLOOP.
      ENDIF.

      CLEAR GWA_REPORT.
      GWA_REPORT-CPF = LWA_UPLOAD-CPF.
      GWA_REPORT-NAME = LV_NAME.
      GWA_REPORT-COD_CARTAO = LWA_UPLOAD-COD_CARTAO.
      GWA_REPORT-DATA_EMISSAO = LWA_UPLOAD-DATA_EMISSAO.
      GWA_REPORT-DATA_VALIDADE = LWA_UPLOAD-DATA_VALIDADE.

      APPEND GWA_REPORT TO GT_REPORT.

    ENDLOOP.
  ENDIF.
ENDFORM.

*&---------------------------------------------------------------------*
*&      FORM  F_PRINT_ALV
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM F_PRINT_ALV .

  PERFORM F_HEADER.
  PERFORM F_SET_LAYOUT.
  PERFORM SET_FIELD.

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      IS_LAYOUT              = TY_LAYOUT           "Estrutura com detalhes do layout.
      I_CALLBACK_TOP_OF_PAGE = 'F_TOP_PAGE'          "Estrutura para montar o cabeçalho
      I_CALLBACK_PROGRAM     = SY-REPID            "variável do sistema (nome do programa). 'Sy-repid' = 'zcurso_alv1'
*     I_CALLBACK_USER_COMMAND = 'F_USER_COMMAND'    "Chama a função "HOTSPOT"
      I_SAVE                 = 'A'                 "layouts podem ser salvos (aparece os botões para alteração do layout).
*     it_sort                = t_sort[]             "Efetua a quebra com o parametro determinado.
      IT_FIELDCAT            = TY_FIELDCAT_COL     "tabela com as colunas a serem impressas.
    TABLES
      T_OUTTAB               = GT_REPORT.          "Tabela com os dados a serem impressos.

ENDFORM.

*&---------------------------------------------------------------------*
*&      FORM  F_HEADER
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM F_HEADER .

  DATA: VL_DATA(10),
        VL_HORA(10).

  CLEAR TY_WATOP.
  TY_WATOP-TYP  = 'H'.    "H = Grande, destaque | S = Pequena | A = Média com itálico
  TY_WATOP-INFO = TEXT-M01.

  APPEND TY_WATOP TO TY_TOP.

  CLEAR TY_WATOP.

  TY_WATOP-TYP  = 'S'.
  CONCATENATE TEXT-M02 SY-UNAME
    INTO TY_WATOP-INFO
      SEPARATED BY SPACE.

  APPEND TY_WATOP TO TY_TOP.

  CLEAR TY_WATOP.

  TY_WATOP-TYP  = 'S'.

  WRITE SY-DATUM TO VL_DATA USING EDIT MASK '__/__/____'.
  WRITE SY-UZEIT TO VL_HORA USING EDIT MASK '__:__'.

  CONCATENATE TEXT-M03 VL_DATA  VL_HORA
    INTO TY_WATOP-INFO
      SEPARATED BY SPACE.

  APPEND TY_WATOP TO TY_TOP.

ENDFORM.                    " f_header

*&**********************************************************************
*&      FORM  F_TOP_PAGE                                               *
*&**********************************************************************
*       Defines the header of the ALV
*----------------------------------------------------------------------*
FORM F_TOP_PAGE.
  CALL FUNCTION 'REUSE_ALV_COMMENTARY_WRITE'
    EXPORTING
      IT_LIST_COMMENTARY = TY_TOP.
*      I_LOGO             = ''.

ENDFORM.                    "f_top_page

*&---------------------------------------------------------------------*
*&      FORM  F_SET_LAYOUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM F_SET_LAYOUT .
  TY_LAYOUT-ZEBRA             = 'X'.                            "Zebrado
  TY_LAYOUT-COLWIDTH_OPTIMIZE = 'X'.                            "Otimizar larguras de colunas automaticamente
ENDFORM.                    " F_SET_LAYOUT

*&---------------------------------------------------------------------*
*&      FORM  F_SET_FIELD
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM SET_FIELD .
  "CLEAR IT_HRP1000.

  PERFORM F_SET_COLUMN USING  'CPF'           'GT_REPORT' TEXT-T01      ' '  ' '  '12'  ' '  'L'  ' ' ' '.
  PERFORM F_SET_COLUMN USING  'NAME'          'GT_REPORT' TEXT-T02      ' '  ' '  '80'  ' '  'L'  ' ' ' '.
  PERFORM F_SET_COLUMN USING  'COD_CARTAO'    'GT_REPORT' TEXT-T03      ' '  ' '  '20'  ' '  'L'  ' ' ' '.
  PERFORM F_SET_COLUMN USING  'DATA_EMISSAO'  'GT_REPORT' TEXT-T04      ' '  ' '  '80'  ' '  'L'  ' ' ' '.
  PERFORM F_SET_COLUMN USING  'DATA_VALIDADE' 'GT_REPORT' TEXT-T05      ' '  ' '  '80'  ' '  'L'  ' ' ' '.

ENDFORM.                    "F_SET_FIELD

*&---------------------------------------------------------------------*
*&       FORM f_set_column                                             *
*----------------------------------------------------------------------*
*        Clears all tables and variables.
*----------------------------------------------------------------------*
FORM F_SET_COLUMN USING P_FIELDNAME
                        P_TABNAME
                        P_TEXTO
                        P_REF_FIELDNAME
                        P_REF_TABNAME
                        P_OUTPUTLEN
                        P_EMPHASIZE
                        P_JUST
                        P_DO_SUM
                        P_ICON.

  ADD 1 TO VG_NRCOL.
  TY_FIELDCAT-COL_POS       = VG_NRCOL.            "POSIÇÃO DO CAMPO (COLUNA).
  TY_FIELDCAT-FIELDNAME     = P_FIELDNAME.         "CAMPO DA TABELA INTERNA.
  TY_FIELDCAT-TABNAME       = P_TABNAME.           "TABELA INTERNA.
  TY_FIELDCAT-SELTEXT_L     = P_TEXTO.             "NOME/TEXTO DA COLUNA.
  TY_FIELDCAT-REF_FIELDNAME = P_REF_FIELDNAME.     "CAMPO DE REFERÊNCIA.
  TY_FIELDCAT-REF_TABNAME   = P_REF_TABNAME.       "TABELA DE REFERÊNCIA.
  TY_FIELDCAT-OUTPUTLEN     = P_OUTPUTLEN.         "LARGURA DA COLUNA.
  TY_FIELDCAT-EMPHASIZE     = P_EMPHASIZE.         "COLORE UMA COLUNA INTEIRA.
  TY_FIELDCAT-JUST          = P_JUST.              "
  TY_FIELDCAT-DO_SUM        = P_DO_SUM.            "TOTALIZA.
  TY_FIELDCAT-ICON          = P_ICON.

  APPEND TY_FIELDCAT TO TY_FIELDCAT_COL.           "Insere linha na tabela interna TY_FIELDCAT_COL.

ENDFORM.                    "f_set_column
