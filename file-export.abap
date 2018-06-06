
TYPES : BEGIN OF ty_file,
          file_line TYPE string,
        END OF ty_file.
        
DATA : t_file   TYPE TABLE OF ty_file.
DATA : wa_file  TYPE ty_file.


PARAMETERS p_path LIKE rlgrap-filename.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_path.
  PERFORM get_dir USING '' CHANGING p_path.


FORM f_download USING p_file_name    TYPE string
                      p_table_source TYPE string.

  DATA : l_msg TYPE string.

  DATA: w_path   TYPE string,
        w_tab    TYPE string,
        vl_subrc TYPE sy-subrc,
        vl_aux   TYPE c,
        vl_rede  TYPE c.

  DATA : l_line TYPE string.

  FIELD-SYMBOLS <fs_tab> TYPE STANDARD TABLE.
  FIELD-SYMBOLS <wa_tab> TYPE ty_file.

  CONCATENATE p_path '\' p_file_name INTO w_path .
  w_tab = p_table_source.
  ASSIGN (w_tab) TO <fs_tab>.

  IF <fs_tab> IS ASSIGNED AND <fs_tab>[] IS NOT INITIAL.

    IF w_path(2) = '\\'.

      OPEN DATASET w_path IN LEGACY TEXT MODE FOR OUTPUT.
      vl_subrc = sy-subrc.

      LOOP AT <fs_tab> ASSIGNING <wa_tab>.
        MOVE <wa_tab>-file_line TO l_line.
        TRANSFER l_line TO w_path.
      ENDLOOP.
      CLOSE DATASET w_path.

      vl_subrc = sy-subrc.
    ELSE.

      CALL FUNCTION 'GUI_DOWNLOAD'
        EXPORTING
          filename                  = w_path
          filetype                  = 'ASC'
          write_field_separator     = 'X'
          trunc_trailing_blanks_eol = ' '
        TABLES
          data_tab                  = <fs_tab>
        EXCEPTIONS
          file_write_error          = 1
          no_batch                  = 2
          gui_refuse_filetransfer   = 3
          invalid_type              = 4
          no_authority              = 5
          unknown_error             = 6
          header_not_allowed        = 7
          separator_not_allowed     = 8
          filesize_not_allowed      = 9
          header_too_long           = 10
          dp_error_create           = 11
          dp_error_send             = 12
          dp_error_write            = 13
          unknown_dp_error          = 14
          access_denied             = 15
          dp_out_of_memory          = 16
          disk_full                 = 17
          dp_timeout                = 18
          file_not_found            = 19
          dataprovider_exception    = 20
          control_flush_error       = 21
          OTHERS                    = 22.
      vl_subrc = sy-subrc.
    ENDIF.

    IF vl_subrc IS INITIAL.
      CONCATENATE 'File' w_path 'created' INTO l_msg SEPARATED BY space.
      MESSAGE l_msg TYPE 'S'.
    ELSE.
      CONCATENATE 'Error while creating file:' w_path 'gerado' INTO l_msg SEPARATED BY space.
      MESSAGE l_msg TYPE 'S' DISPLAY LIKE 'E'.
    ENDIF.

  ENDIF.

ENDFORM.

FORM get_dir USING p_filename CHANGING p_path.

  DATA: l_path   TYPE string,
        l_len(3) TYPE n.

  CALL METHOD cl_gui_frontend_services=>directory_browse
    EXPORTING
      window_title    = 'Select the directory'
      initial_folder  = 'C:\'
    CHANGING
      selected_folder = l_path.
  CALL METHOD cl_gui_cfw=>flush.

  l_len = strlen( l_path ) - 1.

  IF NOT l_path IS INITIAL.
    IF l_path+l_len(1) NE '\'.
      CONCATENATE l_path '\' p_filename INTO p_path.
    ELSE.
      CONCATENATE l_path p_filename INTO p_path.
    ENDIF.
  ENDIF.

ENDFORM.