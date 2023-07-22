*&---------------------------------------------------------------------*
*& Report ZEQB_COCKPIT_ESCALA
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zeqb_cockpit_escala.

INCLUDE: zeqb_cockpit_escala_top,
         zeqb_cockpit_escala_f01.

START-OF-SELECTION.
  CALL SCREEN 9001.

  INCLUDE zeqb_cockpit_escala_o01.

  INCLUDE zeqb_cockpit_escala_i01.
