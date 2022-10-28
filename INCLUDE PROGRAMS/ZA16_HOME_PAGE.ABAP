*----------------------------------------------------------------------*
***INCLUDE ZA16_HOME_PAGE.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  STATUS_1001  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE status_1001 OUTPUT.
*  SET PF-STATUS 'xxxxxxxx'.
*  SET TITLEBAR 'xxx'.
SELECT SINGLE name FROM za16_l_info INTO NAME WHERE stu_id = stu_id.
  CASE sy-ucomm .
    WHEN 'BACK'.
      CALL SCREEN 1000.
    WHEN 'EXIT'.
      CALL SCREEN 1000.
    WHEN 'LOGOUT'.
      CALL SCREEN 1000.
  ENDCASE.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_1001  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_1001 INPUT.
  CASE sy-ucomm .
    WHEN 'BACK'.
      CALL SCREEN 0.
    WHEN 'EXIT'.
      CALL SCREEN 1000.
    WHEN 'LOGOUT'.
      CALL SCREEN 1000.
    WHEN 'LOGOUT'.
      CALL SCREEN 1000.
    WHEN 'SEARCH'.
      CALL SCREEN 1004.
    WHEN 'GET'.
      CALL SCREEN 1005.
    WHEN 'RETURN'.
      CALL SCREEN 1006.
    WHEN 'SHOW'.
      LEAVE TO SCREEN 1007.
    WHEN 'UPDATE'.
      CALL SCREEN 1008.
  ENDCASE.

ENDMODULE.