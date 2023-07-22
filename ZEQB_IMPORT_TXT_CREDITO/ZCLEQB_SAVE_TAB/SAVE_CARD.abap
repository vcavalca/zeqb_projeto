METHOD save_card.

  DATA: gt_save_in  TYPE TABLE OF zeqb_historico,
        lv_cpf      TYPE pa0465-cpf_nr,
        lv_cname    TYPE pa0002-cname,
        lv_pernr    TYPE pa0002-pernr,
        gwa_save_in TYPE zeqb_historico.

  SELECT * INTO TABLE @DATA(lt_find)
        FROM zeqb_cartoes.

  IF sy-subrc IS INITIAL.

    LOOP AT lt_find INTO DATA(lwa_find).

      IF lwa_find-cod_cartao EQ in_cod_cartao.
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

  gwa_save_in-cod_linha = in_cod_linha.
  gwa_save_in-cod_cartao = in_cod_cartao.
  gwa_save_in-name = lv_cname.
  gwa_save_in-total_val = in_valor_total.
  gwa_save_in-dia_compra = in_dia_compra.
  gwa_save_in-waers = 'BRL'.

  APPEND gwa_save_in TO gt_save_in.

  MODIFY zeqb_historico FROM TABLE gt_save_in.
  COMMIT WORK.

ENDMETHOD.
