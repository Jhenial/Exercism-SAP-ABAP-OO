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

DATA: ls_numbers TYPE initial_numbers_type,
      ls_aggr    TYPE aggregated_data_type,
      lv_count   TYPE i,
      lv_sum     TYPE i,
      lv_min     TYPE i,
      lv_max     TYPE i.

SORT initial_numbers BY group.
CLEAR: ls_aggr, lv_count, lv_sum, lv_min, lv_max.

LOOP AT initial_numbers INTO ls_numbers.

AT NEW group.
CLEAR: ls_aggr, lv_count, lv_sum, lv_min, lv_max.
ls_aggr-group = ls_numbers-group.
lv_min = ls_numbers-number.
lv_max = ls_numbers-number.
ENDAT.

  ADD 1                 TO lv_count.
  ADD ls_numbers-number TO lv_sum.
  IF ls_numbers-number < lv_min.
    lv_min = ls_numbers-number.
  ENDIF.

 IF ls_numbers-number > lv_max.
    lv_max = ls_numbers-number.
  ENDIF.

  AT END OF group.
    ls_aggr-count   = lv_count.
    ls_aggr-sum     = lv_sum.
    ls_aggr-min     = lv_min.
    ls_aggr-max     = lv_max.
    ls_aggr-average = lv_sum / lv_count.
    APPEND ls_aggr TO aggregated_data.
  ENDAT.
    ENDLOOP.
  ENDMETHOD.
ENDCLASS.
