*&---------------------------------------------------------------------*
*&  Include           ZEQB_COCKPIT_I01
*&---------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_9000  INPUT
*&---------------------------------------------------------------------*
MODULE user_command_9000 INPUT.
  CASE sy-ucomm.
    WHEN 'FFIND_A'.
      CALL TRANSACTION 'ZTR_EQB_EXTRACT_DATA'.
    WHEN 'FFIND_B'.
      CALL TRANSACTION 'ZTR_EQB_SAVE_CARD'.
    WHEN 'FFIND_C'.
      CALL TRANSACTION 'ZTR_EQB_CAD_LINHAS'.
    WHEN 'FFIND_D'.
      CALL TRANSACTION 'ZTR_EQB_TRANSP'.
    WHEN 'FFIND_E'.
      CALL TRANSACTION 'ZTR_EQB_CARTOESCOLAB'.
    WHEN 'FFIND_F'.
      CALL TRANSACTION 'ZTR_EQB_ESCALA'.
    WHEN 'FFIND_G'.
      CALL TRANSACTION 'ZTR_ZEQB_IMPORT_TXT'.
    WHEN 'FFIND_H'.
      CALL TRANSACTION 'ZTR_EQB_HIST_COMP'.
    WHEN 'BACK' OR 'EXIT' OR 'CANCEL'.
      LEAVE TO SCREEN 0.
  ENDCASE.
ENDMODULE.
