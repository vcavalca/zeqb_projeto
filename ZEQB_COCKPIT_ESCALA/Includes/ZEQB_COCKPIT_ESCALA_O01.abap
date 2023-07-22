*&---------------------------------------------------------------------*
*&  Include           ZEQB_COCKPIT_ESCALA_O01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  STATUS_9001  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE status_9001 OUTPUT.
  SET PF-STATUS 'FSTATUS'.
  SET TITLEBAR 'Cockpit Scale'.

  PERFORM f_show_cartoes.

  PERFORM f_show_linhas.

ENDMODULE.

*&---------------------------------------------------------------------*
*&      Module  HABILITA_CAMPOS  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE habilita_campos OUTPUT.
  LOOP AT SCREEN.

    IF screen-name EQ 'BTNGERAR'.
      IF GWA_CADLIN-VAL_UNIT IS INITIAL.
        screen-input = 0.
      ELSE.
        screen-input = 1.
      ENDIF.

      MODIFY SCREEN.

    ENDIF.

  ENDLOOP.
ENDMODULE.
