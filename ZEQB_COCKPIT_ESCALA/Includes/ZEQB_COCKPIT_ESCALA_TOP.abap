*&---------------------------------------------------------------------*
*&  Include           ZEQB_COCKPIT_ESCALA_TOP
*&---------------------------------------------------------------------*

tables: pa0002,
        zeqb_cartoes,
        zeqb_cadlinhas,
        zeqb_ticket.

types: begin of ty_rep,
         lin type string,
       end of ty_rep.




data: gt_pa0002    type standard table of pa0002,
      gwa_pa0002   type pa0002,
      gv_name_func type pa0002-cname,
      gv_data_de   type dats,
      gv_data_ate  type dats,
      gwa_cartoes  type zeqb_cartoes,
      gv_cartoes   type zeqb_cartoes,
      gwa_cadlin   type zeqb_cadlinhas,
      gv_cadlin    type zeqb_cadlinhas,
      qtd_dias     type zeqb_ticket-qtd_dias,
      qtd_ticket   type zeqb_ticket-qtd_ticket,
      val_tot      type zeqb_ticket-valor_total,
      gwa_ticket   type zeqb_ticket,
      gt_rep       type standard table of rke_dat,
      n_var_i      type betrg.
