*&---------------------------------------------------------------------*
*& Report ZA16_LIBRARY_MANAGEMENT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZA16_LIBRARY_MANAGEMENT.

TABLES: za16_l_book_info , za16_l_getbook , za16_l_info , za16_l_login .




DATA: user_id   LIKE za16_l_login-user_id,
      password  LIKE za16_l_login-password,
      password2 LIKE za16_l_login-password.



DATA : wa_login  LIKE za16_l_login,
       wa_login2 LIKE za16_l_login.




DATA stu_id LIKE za16_l_login-stu_id.
DATA name TYPE za16_name.

DATA: phone TYPE za16_user_id,
      pass  TYPE za16_password,
      pass2 TYPE za16_password.

DATA: nam TYPE za16_name,
      gen TYPE za16_gender,
      deg TYPE za16_degree,
      fld TYPE za16_field,
      rol TYPE za16_rollno,
      add TYPE za16_address,
      dt2 TYPE za16_dt.

DATA dat2 TYPE date.

DATA: wa_info  TYPE za16_l_info,
      wa_info2 TYPE za16_l_info.

DATA : male   TYPE c, female TYPE c, others TYPE c.


DATA: year(4)  TYPE c,
      month(2) TYPE c,
      day(2)   TYPE c.

DATA: dat TYPE string.

DATA: it_book  TYPE TABLE OF za16_l_book_info,
      wa_book  TYPE za16_l_book_info,
      wa_book2 TYPE za16_l_book_info,
      wa_book3 LIKE LINE OF it_book.

DATA:bk_id  TYPE za16_book_id,
     bk_id2 TYPE za16_get_id.

DATA: s_id     TYPE za16_stu_id,
      b_id     TYPE za16_book_id,
      b_name   TYPE za16_book_name,
      b_author TYPE za16_author.

DATA : cr_dat(25) TYPE c,
       cr_dat2    TYPE date.

" GET BOOK

DATA: wa_get  TYPE za16_l_getbook,
      wa_get2 LIKE wa_get,
      get_id2 TYPE za16_get_id,
      wa_rec  TYPE za16_l_getbook,
      wa_rec2 LIKE wa_rec.

DATA: ret_date(25) TYPE c,
      ret_date2    TYPE date.

INCLUDE za16_login_page.
INCLUDE za16_registration_page.
INCLUDE za16_home_page.
INCLUDE za16_search_book.



***&SPWIZARD: DATA DECLARATION FOR TABLECONTROL 'LIB1'
*&SPWIZARD: DEFINITION OF DDIC-TABLE
"TABLES:   ZA16_L_BOOK_INFO.

*&SPWIZARD: TYPE FOR THE DATA OF TABLECONTROL 'LIB1'
TYPES: BEGIN OF t_lib1,
         book_id   LIKE za16_l_book_info-book_id,
         book_name LIKE za16_l_book_info-book_name,
         author    LIKE za16_l_book_info-author,
         prices    LIKE za16_l_book_info-prices,
       END OF t_lib1.

*&SPWIZARD: INTERNAL TABLE FOR TABLECONTROL 'LIB1'
DATA: g_lib1_itab TYPE t_lib1 OCCURS 0,
      g_lib1_wa   TYPE t_lib1. "work area
DATA:     g_lib1_copied.           "copy flag

*&SPWIZARD: DECLARATION OF TABLECONTROL 'LIB1' ITSELF
CONTROLS: lib1 TYPE TABLEVIEW USING SCREEN 1004.

*&SPWIZARD: LINES OF TABLECONTROL 'LIB1'
DATA:     g_lib1_lines  LIKE sy-loopc.

DATA:     ok_code LIKE sy-ucomm.

*&SPWIZARD: OUTPUT MODULE FOR TC 'LIB1'. DO NOT CHANGE THIS LINE!
*&SPWIZARD: COPY DDIC-TABLE TO ITAB
MODULE lib1_init OUTPUT.
  IF g_lib1_copied IS INITIAL.
*&SPWIZARD: COPY DDIC-TABLE 'ZA16_L_BOOK_INFO'
*&SPWIZARD: INTO INTERNAL TABLE 'g_LIB1_itab'
    SELECT * FROM za16_l_book_info
       INTO CORRESPONDING FIELDS
       OF TABLE g_lib1_itab.
    g_lib1_copied = 'X'.
    REFRESH CONTROL 'LIB1' FROM SCREEN '1004'.
  ENDIF.
ENDMODULE.

*&SPWIZARD: OUTPUT MODULE FOR TC 'LIB1'. DO NOT CHANGE THIS LINE!
*&SPWIZARD: MOVE ITAB TO DYNPRO
MODULE lib1_move OUTPUT.
  MOVE-CORRESPONDING g_lib1_wa TO za16_l_book_info.
ENDMODULE.

*&SPWIZARD: OUTPUT MODULE FOR TC 'LIB1'. DO NOT CHANGE THIS LINE!
*&SPWIZARD: GET LINES OF TABLECONTROL
MODULE lib1_get_lines OUTPUT.
  g_lib1_lines = sy-loopc.
ENDMODULE.

*&SPWIZARD: INPUT MODULE FOR TC 'LIB1'. DO NOT CHANGE THIS LINE!
*&SPWIZARD: PROCESS USER COMMAND
MODULE lib1_user_command INPUT.
  ok_code = sy-ucomm.
  PERFORM user_ok_tc USING    'LIB1'
                              'G_LIB1_ITAB'
                              'FLAG'
                     CHANGING ok_code.
  sy-ucomm = ok_code.
ENDMODULE.

*----------------------------------------------------------------------*
*   INCLUDE TABLECONTROL_FORMS                                         *
*----------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*&      Form  USER_OK_TC                                               *
*&---------------------------------------------------------------------*
FORM user_ok_tc USING    p_tc_name TYPE dynfnam
                         p_table_name
                         p_mark_name
                CHANGING p_ok      LIKE sy-ucomm.

*&SPWIZARD: BEGIN OF LOCAL DATA----------------------------------------*
  DATA: l_ok     TYPE sy-ucomm,
        l_offset TYPE i.
*&SPWIZARD: END OF LOCAL DATA------------------------------------------*

*&SPWIZARD: Table control specific operations                          *
*&SPWIZARD: evaluate TC name and operations                            *
  SEARCH p_ok FOR p_tc_name.
  IF sy-subrc <> 0.
    EXIT.
  ENDIF.
  l_offset = strlen( p_tc_name ) + 1.
  l_ok = p_ok+l_offset.
*&SPWIZARD: execute general and TC specific operations                 *
  CASE l_ok.
    WHEN 'INSR'.                      "insert row
      PERFORM fcode_insert_row USING    p_tc_name
                                        p_table_name.
      CLEAR p_ok.

    WHEN 'DELE'.                      "delete row
      PERFORM fcode_delete_row USING    p_tc_name
                                        p_table_name
                                        p_mark_name.
      CLEAR p_ok.

    WHEN 'P--' OR                     "top of list
         'P-'  OR                     "previous page
         'P+'  OR                     "next page
         'P++'.                       "bottom of list
      PERFORM compute_scrolling_in_tc USING p_tc_name
                                            l_ok.
      CLEAR p_ok.
*     WHEN 'L--'.                       "total left
*       PERFORM FCODE_TOTAL_LEFT USING P_TC_NAME.
*
*     WHEN 'L-'.                        "column left
*       PERFORM FCODE_COLUMN_LEFT USING P_TC_NAME.
*
*     WHEN 'R+'.                        "column right
*       PERFORM FCODE_COLUMN_RIGHT USING P_TC_NAME.
*
*     WHEN 'R++'.                       "total right
*       PERFORM FCODE_TOTAL_RIGHT USING P_TC_NAME.
*
    WHEN 'MARK'.                      "mark all filled lines
      PERFORM fcode_tc_mark_lines USING p_tc_name
                                        p_table_name
                                        p_mark_name   .
      CLEAR p_ok.

    WHEN 'DMRK'.                      "demark all filled lines
      PERFORM fcode_tc_demark_lines USING p_tc_name
                                          p_table_name
                                          p_mark_name .
      CLEAR p_ok.

*     WHEN 'SASCEND'   OR
*          'SDESCEND'.                  "sort column
*       PERFORM FCODE_SORT_TC USING P_TC_NAME
*                                   l_ok.

  ENDCASE.

ENDFORM.                              " USER_OK_TC

*&---------------------------------------------------------------------*
*&      Form  FCODE_INSERT_ROW                                         *
*&---------------------------------------------------------------------*
FORM fcode_insert_row
              USING    p_tc_name           TYPE dynfnam
                       p_table_name             .

*&SPWIZARD: BEGIN OF LOCAL DATA----------------------------------------*
  DATA l_lines_name       LIKE feld-name.
  DATA l_selline          LIKE sy-stepl.
  DATA l_lastline         TYPE i.
  DATA l_line             TYPE i.
  DATA l_table_name       LIKE feld-name.
  FIELD-SYMBOLS <tc>                 TYPE cxtab_control.
  FIELD-SYMBOLS <table>              TYPE STANDARD TABLE.
  FIELD-SYMBOLS <lines>              TYPE i.
*&SPWIZARD: END OF LOCAL DATA------------------------------------------*

  ASSIGN (p_tc_name) TO <tc>.

*&SPWIZARD: get the table, which belongs to the tc                     *
  CONCATENATE p_table_name '[]' INTO l_table_name. "table body
  ASSIGN (l_table_name) TO <table>.                "not headerline

*&SPWIZARD: get looplines of TableControl                              *
  CONCATENATE 'G_' p_tc_name '_LINES' INTO l_lines_name.
  ASSIGN (l_lines_name) TO <lines>.

*&SPWIZARD: get current line                                           *
  GET CURSOR LINE l_selline.
  IF sy-subrc <> 0.                   " append line to table
    l_selline = <tc>-lines + 1.
*&SPWIZARD: set top line                                               *
    IF l_selline > <lines>.
      <tc>-top_line = l_selline - <lines> + 1 .
    ELSE.
      <tc>-top_line = 1.
    ENDIF.
  ELSE.                               " insert line into table
    l_selline = <tc>-top_line + l_selline - 1.
    l_lastline = <tc>-top_line + <lines> - 1.
  ENDIF.
*&SPWIZARD: set new cursor line                                        *
  l_line = l_selline - <tc>-top_line + 1.

*&SPWIZARD: insert initial line                                        *
  INSERT INITIAL LINE INTO <table> INDEX l_selline.
  <tc>-lines = <tc>-lines + 1.
*&SPWIZARD: set cursor                                                 *
  SET CURSOR LINE l_line.

ENDFORM.                              " FCODE_INSERT_ROW


*&---------------------------------------------------------------------*
*&      Form  FCODE_DELETE_ROW                                         *
*&---------------------------------------------------------------------*
FORM fcode_delete_row
              USING    p_tc_name           TYPE dynfnam
                       p_table_name
                       p_mark_name   .

*&SPWIZARD: BEGIN OF LOCAL DATA----------------------------------------*
  DATA l_table_name       LIKE feld-name.

  FIELD-SYMBOLS <tc>         TYPE cxtab_control.
  FIELD-SYMBOLS <table>      TYPE STANDARD TABLE.
  FIELD-SYMBOLS <wa>.
  FIELD-SYMBOLS <mark_field>.
*&SPWIZARD: END OF LOCAL DATA------------------------------------------*

  ASSIGN (p_tc_name) TO <tc>.

*&SPWIZARD: get the table, which belongs to the tc                     *
  CONCATENATE p_table_name '[]' INTO l_table_name. "table body
  ASSIGN (l_table_name) TO <table>.                "not headerline

*&SPWIZARD: delete marked lines                                        *
  DESCRIBE TABLE <table> LINES <tc>-lines.

  LOOP AT <table> ASSIGNING <wa>.

*&SPWIZARD: access to the component 'FLAG' of the table header         *
    ASSIGN COMPONENT p_mark_name OF STRUCTURE <wa> TO <mark_field>.

    IF <mark_field> = 'X'.
      DELETE <table> INDEX syst-tabix.
      IF sy-subrc = 0.
        <tc>-lines = <tc>-lines - 1.
      ENDIF.
    ENDIF.
  ENDLOOP.

ENDFORM.                              " FCODE_DELETE_ROW

*&---------------------------------------------------------------------*
*&      Form  COMPUTE_SCROLLING_IN_TC
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_TC_NAME  name of tablecontrol
*      -->P_OK       ok code
*----------------------------------------------------------------------*
FORM compute_scrolling_in_tc USING    p_tc_name
                                      p_ok.
*&SPWIZARD: BEGIN OF LOCAL DATA----------------------------------------*
  DATA l_tc_new_top_line     TYPE i.
  DATA l_tc_name             LIKE feld-name.
  DATA l_tc_lines_name       LIKE feld-name.
  DATA l_tc_field_name       LIKE feld-name.

  FIELD-SYMBOLS <tc>         TYPE cxtab_control.
  FIELD-SYMBOLS <lines>      TYPE i.
*&SPWIZARD: END OF LOCAL DATA------------------------------------------*

  ASSIGN (p_tc_name) TO <tc>.
*&SPWIZARD: get looplines of TableControl                              *
  CONCATENATE 'G_' p_tc_name '_LINES' INTO l_tc_lines_name.
  ASSIGN (l_tc_lines_name) TO <lines>.


*&SPWIZARD: is no line filled?                                         *
  IF <tc>-lines = 0.
*&SPWIZARD: yes, ...                                                   *
    l_tc_new_top_line = 1.
  ELSE.
*&SPWIZARD: no, ...                                                    *
    CALL FUNCTION 'SCROLLING_IN_TABLE'
      EXPORTING
        entry_act      = <tc>-top_line
        entry_from     = 1
        entry_to       = <tc>-lines
        last_page_full = 'X'
        loops          = <lines>
        ok_code        = p_ok
        overlapping    = 'X'
      IMPORTING
        entry_new      = l_tc_new_top_line
      EXCEPTIONS
*       NO_ENTRY_OR_PAGE_ACT  = 01
*       NO_ENTRY_TO    = 02
*       NO_OK_CODE_OR_PAGE_GO = 03
        OTHERS         = 0.
  ENDIF.

*&SPWIZARD: get actual tc and column                                   *
  GET CURSOR FIELD l_tc_field_name
             AREA  l_tc_name.

  IF syst-subrc = 0.
    IF l_tc_name = p_tc_name.
*&SPWIZARD: et actual column                                           *
      SET CURSOR FIELD l_tc_field_name LINE 1.
    ENDIF.
  ENDIF.

*&SPWIZARD: set the new top line                                       *
  <tc>-top_line = l_tc_new_top_line.


ENDFORM.                              " COMPUTE_SCROLLING_IN_TC

*&---------------------------------------------------------------------*
*&      Form  FCODE_TC_MARK_LINES
*&---------------------------------------------------------------------*
*       marks all TableControl lines
*----------------------------------------------------------------------*
*      -->P_TC_NAME  name of tablecontrol
*----------------------------------------------------------------------*
FORM fcode_tc_mark_lines USING p_tc_name
                               p_table_name
                               p_mark_name.
*&SPWIZARD: EGIN OF LOCAL DATA-----------------------------------------*
  DATA l_table_name       LIKE feld-name.

  FIELD-SYMBOLS <tc>         TYPE cxtab_control.
  FIELD-SYMBOLS <table>      TYPE STANDARD TABLE.
  FIELD-SYMBOLS <wa>.
  FIELD-SYMBOLS <mark_field>.
*&SPWIZARD: END OF LOCAL DATA------------------------------------------*

  ASSIGN (p_tc_name) TO <tc>.

*&SPWIZARD: get the table, which belongs to the tc                     *
  CONCATENATE p_table_name '[]' INTO l_table_name. "table body
  ASSIGN (l_table_name) TO <table>.                "not headerline

*&SPWIZARD: mark all filled lines                                      *
  LOOP AT <table> ASSIGNING <wa>.

*&SPWIZARD: access to the component 'FLAG' of the table header         *
    ASSIGN COMPONENT p_mark_name OF STRUCTURE <wa> TO <mark_field>.

    <mark_field> = 'X'.
  ENDLOOP.

ENDFORM.                                          "fcode_tc_mark_lines

*&---------------------------------------------------------------------*
*&      Form  FCODE_TC_DEMARK_LINES
*&---------------------------------------------------------------------*
*       demarks all TableControl lines
*----------------------------------------------------------------------*
*      -->P_TC_NAME  name of tablecontrol
*----------------------------------------------------------------------*
FORM fcode_tc_demark_lines USING p_tc_name
                                 p_table_name
                                 p_mark_name .
*&SPWIZARD: BEGIN OF LOCAL DATA----------------------------------------*
  DATA l_table_name       LIKE feld-name.

  FIELD-SYMBOLS <tc>         TYPE cxtab_control.
  FIELD-SYMBOLS <table>      TYPE STANDARD TABLE.
  FIELD-SYMBOLS <wa>.
  FIELD-SYMBOLS <mark_field>.
*&SPWIZARD: END OF LOCAL DATA------------------------------------------*

  ASSIGN (p_tc_name) TO <tc>.

*&SPWIZARD: get the table, which belongs to the tc                     *
  CONCATENATE p_table_name '[]' INTO l_table_name. "table body
  ASSIGN (l_table_name) TO <table>.                "not headerline

*&SPWIZARD: demark all filled lines                                    *
  LOOP AT <table> ASSIGNING <wa>.

*&SPWIZARD: access to the component 'FLAG' of the table header         *
    ASSIGN COMPONENT p_mark_name OF STRUCTURE <wa> TO <mark_field>.

    <mark_field> = space.
  ENDLOOP.
ENDFORM.                                          "fcode_tc_mark_lines

"INCLUDE za16_get_book.
*&---------------------------------------------------------------------*
*&      Module  STATUS_1005  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE status_1005 OUTPUT.
*  SET PF-STATUS 'xxxxxxxx'.
*  SET TITLEBAR 'xxx'.
  DATA: gg_book TYPE za16_l_getbook.
  SELECT MAX( get_id ) FROM za16_l_getbook INTO get_id2.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_1005  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_1005 INPUT.
  IF sy-ucomm = 'GETBOOK'.
    SELECT SINGLE * FROM za16_l_getbook INTO gg_book WHERE stu_id = stu_id.
    IF gg_book IS NOT INITIAL.
      IF gg_book-book_id = bk_id.
        MESSAGE 'THE BOOK ALREADY EXISTS TO YOU' TYPE 'I'.
      ELSE.
        PERFORM gt_book.
      ENDIF.
    ELSE.
      PERFORM gt_book.
    ENDIF.
  ENDIF.
  IF sy-ucomm = 'exit'.
    LEAVE TO SCREEN 0.
  ENDIF.
  IF sy-ucomm = 'BACK'.
    LEAVE TO SCREEN 1001.
  ENDIF.
  IF sy-ucomm = 'LOGOUT'.
    LEAVE TO SCREEN 1000.
  ENDIF.
ENDMODULE.



FORM gt_book.
  IF bk_id IS NOT INITIAL.
    SELECT SINGLE * FROM za16_l_book_info INTO CORRESPONDING FIELDS OF wa_book3
      WHERE book_id = bk_id.
    s_id = stu_id.
    b_id = wa_book3-book_id.
    b_name = wa_book3-book_name.
    b_author = wa_book3-author.
    cr_dat2 = sy-datum.

    year = cr_dat2+0(4).
    month = cr_dat2+4(2).
    day = cr_dat2+6(2).

    CONCATENATE day month year INTO cr_dat SEPARATED BY '/'.
    CLEAR: year,month, day.

    wa_get-mandt = sy-uname.
    wa_get-get_id = get_id2 + 1.
    wa_get-stu_id = s_id.
    wa_get-book_id = b_id.
    wa_get-book_name = b_name.
    wa_get-author = b_author.
    wa_get-car_date = cr_dat2.

    INSERT za16_l_getbook FROM wa_get.
  ENDIF.
ENDFORM.
INCLUDE za16_return_book.

*----------------------------------------------------------------------*
***INCLUDE ZA16_SHOW_BOOK.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  STATUS_1007  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE status_1007 OUTPUT.
*  SET PF-STATUS 'xxxxxxxx'.
*  SET TITLEBAR 'xxx'.
  TYPES: BEGIN OF st_join,
           stu_id        TYPE za16_stu_id,
           user_id       TYPE za16_user_id,
           roll          TYPE za16_rollno,
           name          TYPE za16_name,
           field         TYPE za16_field,
           date_and_time TYPE za16_dt,
           get_id        TYPE za16_get_id,
           book_id       TYPE za16_book_id,
           author        TYPE za16_author,
           car_date      TYPE date,
         END OF st_join.
  DATA: it_join TYPE  st_join,
        wa_join TYPE st_join.

  DATA: it_pro TYPE TABLE OF za16_l_info,
        wa_pro TYPE za16_l_info.

  DATA:it_gt_book TYPE TABLE OF za16_l_getbook,
       wa_gt_book TYPE za16_l_getbook.

  CLEAR: wa_join, wa_pro, wa_gt_book.
  REFRESH: it_pro , it_gt_book. ", it_join.
  SELECT za16_l_info~stu_id
    za16_l_info~user_id
    za16_l_info~name
    za16_l_info~roll
    za16_l_info~field
    za16_l_info~date_and_time
    za16_l_getbook~get_id
    za16_l_getbook~book_id
    za16_l_getbook~author
    za16_l_getbook~car_date

    INTO CORRESPONDING FIELDS OF it_join
    FROM za16_l_info INNER JOIN za16_l_getbook
    ON za16_l_info~stu_id = za16_l_getbook~stu_id
    WHERE za16_l_info~stu_id = stu_id.
  ENDSELECT.
  CASE sy-ucomm .
    WHEN 'BACK'.
      CALL SCREEN 1001.
    WHEN 'EXIT'.
      CALL SCREEN 0.
    WHEN 'CANCEL'.
      CALL SCREEN 1001.
    WHEN 'LOGOUT'.
      CALL SCREEN 1000.
  ENDCASE.

ENDMODULE.

*&SPWIZARD: DECLARATION OF TABLECONTROL 'EDWR' ITSELF
CONTROLS: EDWR TYPE TABLEVIEW USING SCREEN 1007.

*&SPWIZARD: OUTPUT MODULE FOR TC 'EDWR'. DO NOT CHANGE THIS LINE!
*&SPWIZARD: UPDATE LINES FOR EQUIVALENT SCROLLBAR
MODULE EDWR_CHANGE_TC_ATTR OUTPUT.
  DESCRIBE TABLE IT_PRO LINES EDWR-lines.
ENDMODULE.

INCLUDE za16_update_profile.