CLASS zcl_itab_aggregation DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    TYPES group TYPE c LENGTH 1.

    TYPES: BEGIN OF initial_numbers_type,
             group  TYPE group,
             number TYPE i,
           END OF initial_numbers_type,
           initial_numbers TYPE STANDARD TABLE OF initial_numbers_type WITH EMPTY KEY.

    TYPES: BEGIN OF aggregated_data_type,
             group   TYPE group,
             count   TYPE i,
             sum     TYPE i,
             min     TYPE i,
             max     TYPE i,
             average TYPE f,
           END OF aggregated_data_type,
           aggregated_data TYPE STANDARD TABLE OF aggregated_data_type WITH EMPTY KEY.

    METHODS perform_aggregation
      IMPORTING
        initial_numbers        TYPE initial_numbers
      RETURNING
        VALUE(aggregated_data) TYPE aggregated_data.

  PROTECTED SECTION.
  PRIVATE SECTION.

ENDCLASS.



CLASS zcl_itab_aggregation IMPLEMENTATION.

  METHOD perform_aggregation.

    " Tabela auxiliar com chave GROUP
    TYPES: BEGIN OF lty_aux,
             group TYPE group,
             count TYPE i,
             sum   TYPE i,
             min   TYPE i,
             max   TYPE i,
           END OF lty_aux.

    DATA: lt_result TYPE aggregated_data,
          lt_aux    TYPE HASHED TABLE OF lty_aux WITH UNIQUE KEY group,
          ls_aux    TYPE lty_aux,
          ls_line   TYPE initial_numbers_type,
          ls_result TYPE aggregated_data_type.

    FIELD-SYMBOLS: <fs_aux> TYPE lty_aux.

    LOOP AT initial_numbers INTO ls_line.

      ASSIGN lt_aux[ group = ls_line-group ] TO <fs_aux>.

      IF sy-subrc <> 0.
        CLEAR ls_aux.
        ls_aux-group = ls_line-group.
        ls_aux-count = 1.
        ls_aux-sum   = ls_line-number.
        ls_aux-min   = ls_line-number.
        ls_aux-max   = ls_line-number.
        INSERT ls_aux INTO TABLE lt_aux ASSIGNING <fs_aux>.
      ELSE.
        <fs_aux>-count += 1.
        <fs_aux>-sum   += ls_line-number.
        <fs_aux>-min    = COND #( WHEN ls_line-number < <fs_aux>-min THEN ls_line-number ELSE <fs_aux>-min ).
        <fs_aux>-max    = COND #( WHEN ls_line-number > <fs_aux>-max THEN ls_line-number ELSE <fs_aux>-max ).
      ENDIF.

    ENDLOOP.

    LOOP AT lt_aux ASSIGNING <fs_aux>.
      CLEAR ls_result.
      ls_result-group   = <fs_aux>-group.
      ls_result-count   = <fs_aux>-count.
      ls_result-sum     = <fs_aux>-sum.
      ls_result-min     = <fs_aux>-min.
      ls_result-max     = <fs_aux>-max.
      ls_result-average = <fs_aux>-sum / <fs_aux>-count.
      APPEND ls_result TO lt_result.
    ENDLOOP.

    aggregated_data = lt_result.

  ENDMETHOD.

ENDCLASS.
