  method save_ticket.

    data: gt_save_in  type table of zeqb_ticket,
          gwa_save_in type zeqb_ticket,
          gwa_cadlin  type zeqb_cadlinhas.



    gwa_save_in-cod_cartao = in_cod_cartao.
    gwa_save_in-cod_linha = in_cod_linha.
    gwa_save_in-qtd_dias = in_qtd_dias.
    gwa_save_in-qtd_ticket = in_qtd_ticket.
    gwa_save_in-valor_total = in_valor_total.
    modify zeqb_ticket from gwa_save_in.
    commit work.

    if sy-subrc eq 0.

      out_msg = 1.

    else.

      out_msg = 0.

    endif.

  endmethod.
