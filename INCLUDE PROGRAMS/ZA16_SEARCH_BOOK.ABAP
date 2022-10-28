*----------------------------------------------------------------------*
***INCLUDE ZA16_SEARCH_BOOK.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  STATUS_1004  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE status_1004 OUTPUT.
*  SET PF-STATUS 'xxxxxxxx'.
*  SET TITLEBAR 'xxx'.
ENDMODULE.

*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_1004  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_1004 INPUT.
  IF sy-ucomm = 'SEARCH'.
    IF wa_book IS NOT INITIAL.
      SELECT * FROM za16_l_book_info INTO CORRESPONDING FIELDS OF TABLE it_book
       WHERE book_name = wa_book-book_name OR author = wa_book-author .
    ENDIF.
 " ELSE.
   " MESSAGE 'BOOK NOT FOUND .....!' TYPE 'I'.
  ENDIF.
  IF sy-ucomm = 'EXIT'.
    CALL SCREEN  0.
  ENDIF.
  IF sy-ucomm = 'CANCEL'.
    LEAVE TO SCREEN 0.
  ENDIF.
  IF sy-ucomm = 'LOGOUT'.
    LEAVE TO SCREEN 1000.
  ENDIF.
  IF sy-ucomm = 'BACK'.
    LEAVE TO SCREEN 1003.
  ENDIF.

ENDMODULE.