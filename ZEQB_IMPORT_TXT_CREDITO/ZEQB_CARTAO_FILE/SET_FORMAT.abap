  METHOD set_format.
    DATA: lv_today              TYPE sy-datum,
          lv_last_day_of_months TYPE sy-datum,
          lv_cpf                TYPE zeqb_cartoes-cpf,
          lv_pernr              TYPE pa0002-pernr,
          lv_cname              TYPE pa0002-cname,
          lv_primeiro_dia       TYPE sy-datum.

    DATA lo_update TYPE REF TO zcleqb_save_tab.
    DATA lv_msg TYPE i.

    CREATE OBJECT lo_update.

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
* Implement suitable error handling here

    ELSEIF sy-subrc = 0.
      lv_primeiro_dia = lv_last_day_of_months + 1.

    ENDIF.

    SELECT SINGLE cod_linha, cod_cartao, valor_total, qtd_dias  INTO @DATA(lwa_zeqb_ticket)
      FROM zeqb_ticket
     WHERE cod_linha EQ @in_codlinha
      AND cod_cartao EQ @in_codcartao.

    IF sy-subrc EQ 0.

      SELECT * INTO TABLE @DATA(lt_find)
      FROM zeqb_cartoes.

      IF sy-subrc IS INITIAL.

        LOOP AT lt_find INTO DATA(lwa_find).

          IF lwa_find-cod_cartao EQ lwa_zeqb_ticket-cod_cartao.
            lv_cpf = lwa_find-cpf.

          ENDIF.

        ENDLOOP.

        SELECT * INTO TABLE @DATA(lt_find_pernr)
          FROM pa0465.

        IF sy-subrc IS INITIAL.

          LOOP AT lt_find_pernr INTO DATA(lwa_find_pernr).

            IF lwa_find_pernr-cpf_nr EQ lv_cpf.

              lv_pernr = lwa_find_pernr-pernr.

            ENDIF.

          ENDLOOP.

          SELECT * INTO TABLE @DATA(lt_get_name)
            FROM pa0002.

          IF sy-subrc IS INITIAL.

            LOOP AT lt_get_name INTO DATA(lwa_get_name).

              IF lwa_get_name-pernr EQ lv_pernr.

                lv_cname = lwa_get_name-cname.

              ENDIF.

            ENDLOOP.

          ENDIF.

        ENDIF.

      ENDIF.

      out_line = lwa_zeqb_ticket-cod_cartao && ';' && lv_cname && ';' && lwa_zeqb_ticket-cod_linha && ';' && lwa_zeqb_ticket-valor_total && ';' && lv_primeiro_dia.

    ENDIF.

  ENDMETHOD.
