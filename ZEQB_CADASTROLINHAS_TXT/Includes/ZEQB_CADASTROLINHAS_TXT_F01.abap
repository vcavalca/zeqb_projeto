*&---------------------------------------------------------------------*
*&  Include           ZEQB_CADASTROLINHAS_TXT_F01
*&---------------------------------------------------------------------*

FORM F_SELECT_FILE  USING    P_IN_FILE
                    CHANGING P_OUT_FILE.

  CALL FUNCTION 'WS_FILENAME_GET'
    EXPORTING
      DEF_FILENAME     = P_IN_FILE
      DEF_PATH         = 'C:\'
   "  MASK             = ',*.*,*.*'
      MODE             = 'O'
      TITLE            = 'SELEC��O DE ARQUIVOS'
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
* IMPLEMENT SUITABLE ERROR HANDLING HERE
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
  IF SY-SUBRC <> 0.
* Implement suitable error handling here

  ELSEIF SY-SUBRC EQ 0.
    PERFORM F_INSERT_TABLE.
  ENDIF.

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

  DATA lo_savelinhas TYPE REF TO ZCEQB_CADASTROLINHAS.
  DATA LV_MSG TYPE I.

  IF GT_UPLOAD[] IS NOT INITIAL.

    REFRESH GT_FILE_FMT.

    LOOP AT GT_UPLOAD INTO DATA(GWA_UPLOAD).

        SPLIT GWA_UPLOAD-LINE AT ';' INTO GWA_FILE_FMT-COD_LINHA
                                          GWA_FILE_FMT-NOME_LINHA
                                          GWA_FILE_FMT-VAL_UNIT
                                          GWA_FILE_FMT-WAERS.

        APPEND GWA_FILE_FMT TO GT_FILE_FMT.


      CREATE OBJECT lo_savelinhas.

      CALL METHOD lo_savelinhas->SAVE_LINHAS
        EXPORTING
          IN_COD_LINHA  = GWA_FILE_FMT-COD_LINHA
          IN_NOME_LINHA = GWA_FILE_FMT-NOME_LINHA
          IN_VAL_UNIT   = GWA_FILE_FMT-VAL_UNIT
          WAERS         = GWA_FILE_FMT-WAERS
        IMPORTING
          OUT_MSG       = LV_MSG.

   ENDLOOP.
  ENDIF.

  IF LV_MSG EQ 1.

    MESSAGE S003(ZEQB_ALL_MSG).

  ELSE.

    MESSAGE S004(ZEQB_ALL_MSG).

  ENDIF.
ENDFORM.
