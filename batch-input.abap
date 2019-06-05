DATA : wa_bdcdata     TYPE bdcdata.
DATA : t_bdcdata      TYPE TABLE OF wa_bdcdata.
DATA : t_messages     TYPE TABLE OF bdcmsgcoll.
DATA : wa_messages    TYPE bdcmsgcoll.

FORM bdc_dynpro USING program TYPE any
                      dynpro  TYPE any.

  CLEAR wa_bdcdata.
  wa_bdcdata-program  = program.
  wa_bdcdata-dynpro   = dynpro.
  wa_bdcdata-dynbegin = 'X'.
  APPEND wa_bdcdata TO t_bdcdata.

ENDFORM.

FORM bdc_field USING fnam TYPE any
                     fval TYPE any.

  CLEAR wa_bdcdata.
  wa_bdcdata-fnam = fnam.
  wa_bdcdata-fval = fval.
  APPEND wa_bdcdata TO t_bdcdata.

ENDFORM.

PERFORM bdc_dynpro USING : 'SAPMF02D'     '0036'.
PERFORM bdc_field  USING : 'BDC_CURSOR'   'USE_ZAV'.
PERFORM bdc_field  USING : 'BDC_OKCODE'   '/00'.
PERFORM bdc_field  USING : 'RF02D-KUNNR'  kunnr.
PERFORM bdc_field  USING : 'USE_ZAV'      'X'.

CALL TRANSACTION '<transactio-code>'
USING t_bdcdata
MODE 'N'
MESSAGES INTO t_messages.