DATA : t_fields         TYPE lvc_t_fcat.
DATA : o_alv            TYPE REF TO cl_gui_alv_grid.
DATA : o_container      TYPE REF TO cl_gui_custom_container.
DATA : t_sort           TYPE lvc_t_sort.

DATA : wa_lvc_s_layo    TYPE lvc_s_layo.
DATA : wa_lvc_s_stbl    TYPE lvc_s_stbl.
DATA : ls_exclude       TYPE ui_func.
DATA : pt_exclude       TYPE ui_functions.
DATA : wa_variant       TYPE disvariant.


MODULE alv OUTPUT.
  DATA : oref_handlers TYPE REF TO lcl_event_handlers.

  CLEAR wa_lvc_s_layo.
  PERFORM : f_make_fields.
  PERFORM : f_make_sort.

  wa_lvc_s_layo-no_toolbar  = 'X'.
  wa_lvc_s_layo-zebra       = 'X'.
  wa_lvc_s_layo-smalltitle  = 'X'.
  wa_lvc_s_layo-sel_mode    = 'B'.
  wa_lvc_s_layo-no_f4       = 'X'.

  wa_lvc_s_stbl-row = 'X'.
  wa_lvc_s_stbl-col = 'X'.

  IF o_alv IS INITIAL .
    CREATE OBJECT o_cont
      EXPORTING
        container_name = 'CC_'.

    CREATE OBJECT o_alv
      EXPORTING
        i_parent = o_cont.

    CREATE OBJECT oref_handlers.
    SET HANDLER oref_handlers->handle_double_click FOR o_alv.

    CALL METHOD o_alv->register_edit_event
      EXPORTING
        i_event_id = cl_gui_alv_grid=>mc_evt_modified
      EXCEPTIONS
        error      = 1
        OTHERS     = 2.

    CALL METHOD o_alv->set_table_for_first_display
      EXPORTING
        is_layout       = wa_lvc_s_layo
      CHANGING
        it_outtab       = "<SOME_INTERNAL_TABLE>
        it_fieldcatalog = t_fields
        it_sort         = t_sort.
  ENDIF.

  CALL METHOD o_alv->refresh_table_display
    EXPORTING
      is_stable = wa_lvc_s_stbl.
  CALL METHOD cl_gui_cfw=>dispatch.

ENDMODULE.               

CLASS lcl_event_handlers DEFINITION.
  PUBLIC SECTION.
    METHODS: handle_double_click FOR EVENT double_click OF cl_gui_alv_grid
                        IMPORTING e_row e_column es_row_no.
ENDCLASS.


CLASS lcl_event_handlers IMPLEMENTATION.

  METHOD handle_double_click.
    CASE e_column.
      WHEN 'SOME_COLUMN_NAME'.
        " Make something
    ENDCASE.
  ENDMETHOD.                    

ENDCLASS.                    

FORM f_make_fields .

  REFRESH t_fields.

  PERFORM : f_make_field USING 'T_CARGAS' 'A_CANCCAR' 'Cancelar Carga' '14' '' '' 'X' '' '' '' '' '' '' '' '' '' 'X'.


ENDFORM.

FORM f_make_field USING VALUE(p_tabela)      "1
                        VALUE(p_coluna)      "2
                        VALUE(p_texto)       "3
                        VALUE(p_tam)         "4
                        VALUE(p_sum)         "5
                        VALUE(p_currency)    "6
                        VALUE(p_key)         "7
                        VALUE(p_moeda)       "8
                        VALUE(p_edit)        "9
                        VALUE(p_emp)         "10
                        VALUE(p_icon)        "11
                        VALUE(p_no_zero)     "12
                        VALUE(p_convexit)    "13
                        VALUE(p_decimals_o)  "14
                        VALUE(p_no_sum)      "15
                        VALUE(p_no_convext)
                        VALUE(p_button) .

  DATA : lwa_lvc_t_fcat TYPE LINE OF lvc_t_fcat.

  lwa_lvc_t_fcat-fieldname = p_coluna.
  lwa_lvc_t_fcat-tabname   = p_tabela.
  lwa_lvc_t_fcat-currency  = p_currency.
  lwa_lvc_t_fcat-reptext   = p_texto.
  lwa_lvc_t_fcat-do_sum    = p_sum.
  lwa_lvc_t_fcat-key       = p_key.
  lwa_lvc_t_fcat-outputlen = p_tam.
  lwa_lvc_t_fcat-currency  = p_moeda.
  lwa_lvc_t_fcat-emphasize = p_emp.
  lwa_lvc_t_fcat-edit      = p_edit.
  lwa_lvc_t_fcat-icon      = p_icon.
  lwa_lvc_t_fcat-no_zero     = p_no_zero.
  lwa_lvc_t_fcat-convexit   = p_convexit.
  lwa_lvc_t_fcat-decimals_o  = p_decimals_o.
  lwa_lvc_t_fcat-decimals    = p_decimals_o.
  lwa_lvc_t_fcat-no_sum    = p_no_sum.
  lwa_lvc_t_fcat-no_convext = p_no_convext.


  CASE p_tabela.
    WHEN 'T_CARGAS'.
      APPEND lwa_lvc_t_fcat TO t_fields.
  ENDCASE.

ENDFORM.

FORM f_make_sort .
  DATA: ls_sort    TYPE lvc_s_sort.

  REFRESH: t_sort_cargas.
  CLEAR: ls_sort.
  ls_sort-spos      = '1'.
  ls_sort-fieldname = 'DESTINO'.
  ls_sort-up        = 'X'.
  ls_sort-subtot    = 'X'.
  APPEND ls_sort TO t_sort_cargas.

ENDFORM.