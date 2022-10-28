*----------------------------------------------------------------------*
***INCLUDE ZA16_LOGIN_PAGE.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  STATUS_1000  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE status_1000 OUTPUT.
*  SET PF-STATUS 'MENU'.
*  SET TITLEBAR 'xxx'.
  CLEAR: wa_login, wa_login .
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_1000  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_1000 INPUT.

  CASE sy-ucomm .
    WHEN 'LOGIN'.
      SELECT SINGLE * FROM za16_l_login INTO  wa_login
        WHERE user_id = user_id
          AND password = password.
        IF sy-subrc = 0.
          CALL SCREEN 1001.
        ELSE.
          MESSAGE 'ENTER THE CORRECT VALUE' TYPE 'I'.
        ENDIF.
      WHEN  'NEW'.
        LEAVE TO SCREEN 1002.
      WHEN  'EXIT'.
        call SCREEN 0.
        CLEAR: wa_login.
    ENDCASE.

ENDMODULE.