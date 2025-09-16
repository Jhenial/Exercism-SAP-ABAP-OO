CLASS zcl_itab_basics DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.
  
  PUBLIC SECTION.
    TYPES group TYPE c LENGTH 1.
    TYPES: BEGIN OF initial_type,
             group       TYPE group,
             number      TYPE i,
             description TYPE string,
           END OF initial_type,
           itab_data_type TYPE STANDARD TABLE OF initial_type WITH EMPTY KEY.

    METHODS fill_itab
      RETURNING
        VALUE(initial_data) TYPE itab_data_type.
           
    METHODS add_to_itab
      IMPORTING initial_data TYPE itab_data_type
      RETURNING
        VALUE(updated_data) TYPE itab_data_type.

    METHODS sort_itab
      IMPORTING initial_data TYPE itab_data_type
      RETURNING
        VALUE(updated_data) TYPE itab_data_type.

    METHODS search_itab
      IMPORTING initial_data TYPE itab_data_type
      RETURNING
        VALUE(result_index) TYPE i.

ENDCLASS.

CLASS zcl_itab_basics IMPLEMENTATION.

  METHOD fill_itab.
        FIELD-SYMBOLS: <lf_initial_data> TYPE initial_type.
                       
        DO 6 TIMES.
          APPEND INITIAL LINE TO initial_data.
        ENDDO.

        LOOP AT initial_data ASSIGNING <lf_initial_data>.     
             CASE sy-tabix.
               WHEN 1.
               <lf_initial_data>-group       = 'A'.
               <lf_initial_data>-number      = 10.
               <lf_initial_data>-description = 'Group A-2'.
               WHEN 2.
               <lf_initial_data>-group       = 'B'.
               <lf_initial_data>-number      =  5.
               <lf_initial_data>-description = 'Group B'.
               WHEN 3.
                <lf_initial_data>-group    = 'A'.
                <lf_initial_data>-number   =  6.
                <lf_initial_data>-description = 'Group A-1'.
               WHEN 4.
                 <lf_initial_data>-group   = 'C'.
                 <lf_initial_data>-number  = 22.
                 <lf_initial_data>-description = 'Group C-1'.
               WHEN 5.
                 <lf_initial_data>-group   = 'A'.
                 <lf_initial_data>-number  = 13.
                 <lf_initial_data>-description = 'Group A-3'.
               WHEN 6.
                <lf_initial_data>-group    = 'C'.
                <lf_initial_data>-number   = 500.
                <lf_initial_data>-description = 'Group C-2'.
              ENDCASE.
             ENDLOOP.
  ENDMETHOD.

  METHOD add_to_itab.
        FIELD-SYMBOLS: <lf_initial_data> TYPE initial_type.
        DATA: ls_new_line TYPE initial_type.
            
            updated_data = initial_data.
          
              ls_new_line-group       = 'A' .
              ls_new_line-number      = 19.
              ls_new_line-description = 'Group A-4'.
              APPEND ls_new_line TO updated_data.
          
  ENDMETHOD.

  METHOD sort_itab.
        updated_data = initial_data.
        SORT updated_data BY group ASCENDING number DESCENDING.
  ENDMETHOD.

  METHOD search_itab.
         DATA: lv_index TYPE sy-tabix.

         READ TABLE initial_data WITH KEY number = 6 
                                 TRANSPORTING NO FIELDS.

        IF sy-subrc = 0.
           lv_index = sy-tabix.
        ELSE.
        lv_index = 0.
        ENDIF.
        result_index = lv_index.
  ENDMETHOD.

ENDCLASS.
