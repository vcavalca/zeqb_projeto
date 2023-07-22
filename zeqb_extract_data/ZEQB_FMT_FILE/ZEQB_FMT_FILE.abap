FUNCTION zeqb_fmt_file.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     REFERENCE(IN_PERNR) TYPE  PA0002-PERNR
*"  EXPORTING
*"     REFERENCE(OUT_LINE) TYPE  STRING
*"----------------------------------------------------------------------

  DATA: lv_age_low       TYPE i,
        lv_age_high      TYPE i,
        lv_tmp_aux       TYPE string,
        lv_cname         TYPE pa0002-cname,
        lv_gbdat         TYPE pa0002-gbdat,
        lv_ort01         TYPE pa0006-ort01,
        lv_state         TYPE pa0006-state,
        lv_stras         TYPE pa0006-stras,
        lv_cpf_nr        TYPE pa0465-cpf_nr,
        lv_father_name   TYPE pa0021-fcnam,
        lv_mother_name   TYPE pa0021-fcnam,
        lv_email         TYPE pa0105-usrid,
        lv_cnpj_paval    TYPE j_1bwfield-cgc_compan,
        lv_cnpj_bbranch  TYPE j_1bwfield-cgc_branch,
        lv_full_cnpj     TYPE j_1bwfield-cgc_number,
        lv_age_dependent TYPE i.
  DATA: lt_dependents_names TYPE TABLE OF string.

  SELECT SINGLE low, high INTO @DATA(lv_age)
    FROM tvarvc
    WHERE name EQ 'ZEQB_ELEGIBLE_DEPENDENTS'.

  IF sy-subrc EQ 0.
    lv_age_low = lv_age-low.
    lv_age_high = lv_age-high.
  ELSE.
    lv_age_low = 0.
    lv_age_high = 99.
  ENDIF.

  SELECT SINGLE cname, gbdat INTO @DATA(lwa_pa0002)
    FROM pa0002
    WHERE pernr EQ @in_pernr.

  IF sy-subrc EQ 0.

    lv_cname = lwa_pa0002-cname.
    lv_gbdat = lwa_pa0002-gbdat.

  ENDIF.

  SELECT SINGLE stras, ort01, state INTO @DATA(lwa_pa0006)
    FROM pa0006
    WHERE pernr EQ @in_pernr.

  IF sy-subrc EQ 0.

    lv_ort01 = lwa_pa0006-ort01.
    lv_state = lwa_pa0006-state.
    lv_stras = lwa_pa0006-stras.

  ENDIF.

  SELECT SINGLE * INTO @DATA(lwa_pa0465)
    FROM pa0465
    WHERE pernr EQ @in_pernr.

  IF sy-subrc EQ 0.

    lv_cpf_nr = lwa_pa0465-cpf_nr.

  ENDIF.

  SELECT SINGLE * INTO @DATA(lwa_father)
    FROM pa0021
    WHERE pernr EQ @in_pernr
    AND subty EQ '11'.

  IF sy-subrc EQ 0.

    lv_father_name = lwa_father-fcnam.

  ENDIF.

  SELECT SINGLE * INTO @DATA(lwa_mother)
    FROM pa0021
    WHERE pernr EQ @in_pernr
    AND subty EQ '12'.

  IF sy-subrc EQ 0.

    lv_mother_name = lwa_mother-fcnam.

  ENDIF.

  SELECT SINGLE * INTO @DATA(lwa_email)
    FROM pa0105
    WHERE pernr EQ @in_pernr.

  IF sy-subrc EQ 0.

    lv_email = lwa_email-usrid.

  ENDIF.

  SELECT SINGLE * INTO @DATA(cnpj)
    FROM t001z
    WHERE bukrs EQ '0001'
    AND party EQ 'NLRDNB'.

  IF sy-subrc EQ 0.

    lv_cnpj_paval = cnpj-paval.

  ENDIF.

  SELECT SINGLE * INTO @DATA(cnpj_branch)
    FROM j_1bbranch
    WHERE bukrs EQ 'BR01'.

  IF sy-subrc EQ 0.

    lv_cnpj_bbranch = cnpj_branch-cgc_branch.

  ENDIF.

  CALL FUNCTION 'J_1BBUILD_CGC'
    EXPORTING
      cgc_company = lv_cnpj_paval
      cgc_branch  = lv_cnpj_bbranch
    IMPORTING
      cgc_number  = lv_full_cnpj.

  SELECT * INTO TABLE @DATA(lt_dependents)
    FROM pa0021
    WHERE pernr EQ @in_pernr
    AND subty EQ '2'.

  IF sy-subrc EQ 0.

    LOOP AT lt_dependents INTO DATA(lwa_dependents).

      lv_age_dependent = sy-datum - lwa_dependents-fgbdt.
      lv_age_dependent = lv_age_dependent / 365.

      IF lv_age_dependent >= lv_age_low AND lv_age_dependent <= lv_age_high.

        APPEND lwa_dependents-fcnam TO lt_dependents_names.

      ENDIF.

    ENDLOOP.

  ENDIF.

  lv_tmp_aux = lv_full_cnpj && ';'
            && lv_cpf_nr && ';'
            && lv_cname && ';'
            && lv_father_name && ';'
            && lv_mother_name && ';'
            && lv_email && ';'
            && lv_stras && ';'
            && lv_ort01 && ';'
            && lv_state && ';'
            && lv_gbdat.

  LOOP AT lt_dependents INTO DATA(lwa_dependent).
    CONCATENATE lv_tmp_aux lwa_dependent-fcnam INTO lv_tmp_aux SEPARATED BY ';'.
  ENDLOOP.

  out_line = lv_tmp_aux.

ENDFUNCTION.
