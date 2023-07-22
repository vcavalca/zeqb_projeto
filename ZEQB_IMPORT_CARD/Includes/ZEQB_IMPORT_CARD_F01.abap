*&---------------------------------------------------------------------*
*&  Include           ZEQB_IMPORT_CARD_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  F_SELECT_FILE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_P_FILE  text
*      <--P_P_FILE  text
*----------------------------------------------------------------------*
FORM F_SELECT_FILE  USING    P_IN_FILE
                    CHANGING P_OUT_FILE.

  CALL FUNCTION 'WS_FILENAME_GET'
    EXPORTING
      DEF_FILENAME     = P_IN_FILE
      DEF_PATH         = 'C:\'
   "  MASK             = ',*.*,*.*'
      MODE             = 'O'
      TITLE            = 'SELECÇÃO DE ARQUIVOS'
    IMPORTING
      FILENAME         = P_OUT_FILE
*     RC               =
    EXCEPTIONS
      INV_WINSYS       = 1
      NO_BATCH         = 2
      SELECTION_CANCEL = 3
      SELECTION_ERROR  = 4
      OTHERS           = 5.
  .
  IF SY-SUBRC <> 0.

    CASE SY-SUBRC.
      WHEN 1.
        MESSAGE S015(ZEQB_ALL_MSG).
      WHEN 2.
        MESSAGE S016(ZEQB_ALL_MSG).
      WHEN 3.
        MESSAGE S017(ZEQB_ALL_MSG).
      WHEN 4.
        MESSAGE S018(ZEQB_ALL_MSG).
      WHEN OTHERS.
        MESSAGE S019(ZEQB_ALL_MSG).
    ENDCASE.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_UPLOAD_FILE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM F_UPLOAD_FILE .

  DATA LV_FILENAME TYPE STRING.

  LV_FILENAME = P_FILE.

  CALL FUNCTION 'GUI_UPLOAD'
    EXPORTING
      FILENAME                = LV_FILENAME
*     FILETYPE                = 'ASC'
*     HAS_FIELD_SEPARATOR     = ' '
*     HEADER_LENGTH           = 0
*     READ_BY_LINE            = 'X'
*     DAT_MODE                = ' '
*     CODEPAGE                = ' '
*     IGNORE_CERR             = ABAP_TRUE
*     REPLACEMENT             = '#'
*     CHECK_BOM               = ' '
*     VIRUS_SCAN_PROFILE      =
*     NO_AUTH_CHECK           = ' '
*   IMPORTING
*     FILELENGTH              =
*     HEADER                  =
    TABLES
      DATA_TAB                = GT_UPLOAD
*   CHANGING
*     ISSCANPERFORMED         = ' '
    EXCEPTIONS
      FILE_OPEN_ERROR         = 1
      FILE_READ_ERROR         = 2
      NO_BATCH                = 3
      GUI_REFUSE_FILETRANSFER = 4
      INVALID_TYPE            = 5
      NO_AUTHORITY            = 6
      UNKNOWN_ERROR           = 7
      BAD_DATA_FORMAT         = 8
      HEADER_NOT_ALLOWED      = 9
      SEPARATOR_NOT_ALLOWED   = 10
      HEADER_TOO_LONG         = 11
      UNKNOWN_DP_ERROR        = 12
      ACCESS_DENIED           = 13
      DP_OUT_OF_MEMORY        = 14
      DISK_FULL               = 15
      DP_TIMEOUT              = 16
      OTHERS                  = 17.

  CASE SY-SUBRC.
    WHEN 0.
      PERFORM F_INSERT_TABLE.
    WHEN 2.
      MESSAGE S008(ZEQB_ALL_MSG).
    WHEN 5.
      MESSAGE S009(ZEQB_ALL_MSG).
    WHEN 1.
      MESSAGE S010(ZEQB_ALL_MSG).
    WHEN 10.
      MESSAGE S011(ZEQB_ALL_MSG).
  ENDCASE.



ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_INSERT_TABLE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM F_INSERT_TABLE .

  DATA: LV_MSG  TYPE I,
        LO_SAVE TYPE REF TO ZCLEQB_SAVE_CARD.

  IF GT_UPLOAD[] IS NOT INITIAL.
    REFRESH GT_FILE_FMT.
    LOOP AT GT_UPLOAD INTO DATA(GWA_UPLOAD).
      CLEAR GWA_FILE_FMT.

      SPLIT GWA_UPLOAD-LINE AT ';' INTO GWA_FILE_FMT-CODCARTAO
                                         GWA_FILE_FMT-CPF_NR
                                         GWA_FILE_FMT-DATE_EM
                                         GWA_FILE_FMT-DATE_V.

      APPEND GWA_FILE_FMT TO GT_FILE_FMT.

*      CALL FUNCTION 'ZALEQB_SAVE_CARD'
*        EXPORTING
*          IN_COD_CARTAO          = GWA_FILE_FMT-CODCARTAO
*          IN_CPF                 = GWA_FILE_FMT-CPF_NR
*          IN_NAME                = GWA_FILE_FMT-CNAME
*          IN_DATA_EMISSAO        = GWA_FILE_FMT-DATE_EM
*          IN_DATA_VALIDADE       = GWA_FILE_FMT-DATE_V
*         IMPORTING
*           OUT_MSG                = LV_MSG.
*                .
      CREATE OBJECT LO_SAVE.

      CALL METHOD LO_SAVE->SAVE_CARD
        EXPORTING
          IN_COD_CARTAO    = GWA_FILE_FMT-CODCARTAO
          IN_CPF           = GWA_FILE_FMT-CPF_NR
*          IN_NAME          = GWA_FILE_FMT-CNAME
          IN_DATA_EMISSAO  = GWA_FILE_FMT-DATE_EM
          IN_DATA_VALIDADE = GWA_FILE_FMT-DATE_V
        IMPORTING
          OUT_MSG          = LV_MSG.



    ENDLOOP.
  ENDIF.

  IF LV_MSG EQ 1.

    MESSAGE S001(ZEQB_ALL_MSG).


  ELSE.

    MESSAGE S002(ZEQB_ALL_MSG).

  ENDIF.
ENDFORM.
