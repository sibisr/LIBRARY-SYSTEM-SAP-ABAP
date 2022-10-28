*----------------------------------------------------------------------*
***INCLUDE ZA16_REGISTRATION_PAGE.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  STATUS_1002  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE status_1002 OUTPUT.
*  SET PF-STATUS 'xxxxxxxx'.
*  SET TITLEBAR 'xxx'.

  DATA: match_data TYPE za16_l_login.
  IF sy-ucomm = 'BACK'.
    LEAVE TO SCREEN 1000.
  ELSEIF sy-ucomm = 'EXIT'.
    LEAVE TO SCREEN 0.
  ELSEIF sy-ucomm = 'CANCEL'.
    LEAVE TO SCREEN 0.
    ELSEIF SY-UCOMM = 'LOGOUT'.
      LEAVE TO SCREEN 1000.
  ENDIF.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_1002  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_1002 INPUT.
  CLEAR: stu_id.
  IF sy-ucomm = 'SUBMIT'.
    SELECT SINGLE * FROM za16_l_login INTO match_data WHERE user_id = phone.
    IF sy-subrc IS NOT INITIAL.
      IF phone IS NOT INITIAL AND pass IS NOT INITIAL AND pass2 IS NOT INITIAL.
        IF pass EQ pass2.
          SELECT MAX( stu_id ) INTO stu_id FROM za16_l_login.
          stu_id = stu_id + 1.
          SELECT SINGLE * FROM za16_l_login INTO CORRESPONDING FIELDS OF wa_login2
            WHERE user_id = phone AND password = pass.
          IF sy-subrc IS NOT INITIAL.
            wa_login-mandt = sy-uname.
            wa_login-stu_id = stu_id.
            wa_login-user_id = phone.
            wa_login-password = pass.
            INSERT za16_l_login FROM wa_login.
            CALL SCREEN 1003.
          ENDIF.
        ELSE.
          MESSAGE  'PLEASE ENTER THE CORRECT PASSWORD' TYPE 'I' .
        ENDIF.
      ENDIF.
    ELSE.
      MESSAGE 'THE USER ALREADY EXISTS' TYPE 'I'.
    ENDIF.
  ELSE.
    MESSAGE 'PLEASE ENTER THE CURRECT RECORD' TYPE 'I'.
  ENDIF.

IF sy-ucomm = 'BACK'.
    LEAVE TO SCREEN 1000.
  ELSEIF sy-ucomm = 'EXIT'.
    LEAVE TO SCREEN 0.
  ELSEIF sy-ucomm = 'BACK'.
    LEAVE TO SCREEN 1000.
    ELSEIF SY-UCOMM = 'LOGOUT'.
      LEAVE TO SCREEN 1000.
  ENDIF.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  STATUS_1003  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE status_1003 OUTPUT.
*  SET PF-STATUS 'xxxxxxxx'.
*  SET TITLEBAR 'xxx'.
  CLEAR: phone,
        nam,
        gen,
        deg,
        fld,
        rol,
        add,
        dt2.
  phone = wa_login-user_id.
  dat2 = sy-datum.
  year = dat2+0(4).
  month = dat2+2(2).
  day = dat2+6(2).
CONCATENATE day month year into dat SEPARATED BY '/'.
clear : year, month, day.

IF sy-ucomm = 'BACK'.
    LEAVE TO SCREEN 1000.
  ELSEIF sy-ucomm = 'EXIT'.
    LEAVE TO SCREEN 0.
  ELSEIF sy-ucomm = 'BACK'.
    LEAVE TO SCREEN 0.
    ELSEIF SY-UCOMM = 'LOGOUT'.
      LEAVE TO SCREEN 1000.
  ENDIF.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_1003  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_1003 INPUT.
  CLEAR: stu_id,wa_info.
  SELECT MAX( stu_id ) INTO stu_id FROM za16_l_login.
  IF sy-ucomm = 'OK'.
    IF male = 'X'.
      gen = 'MALE'.
    ELSEIF female = 'X'.
      gen = 'FEMALE'.
    ELSE .
      gen = 'OTHERS'.
    ENDIF.
    wa_info-mandt = sy-uname.
    wa_info-stu_id = stu_id.
    wa_info-user_id = phone.
    wa_info-roll = rol.
    wa_info-name = nam.
    wa_info-gender = gen.
    wa_info-degree = deg.
    wa_info-field = fld.
    wa_info-address = add.
    wa_info-date_and_time = dat.
    INSERT za16_l_info FROM wa_info.
    CLEAR: wa_info,
    sy-uname,
    stu_id,
    phone,
    rol,
    nam,
    gen,
    deg,
    fld,
    add,
   dat.
    MESSAGE 'User registred sucessfully' type 'I'.
    call SCREEN 1000.
    IF sy-subrc IS INITIAL.
      CALL SCREEN 1000.
    ENDIF.
  ENDIF.
  IF sy-ucomm = 'BACK'.
    LEAVE TO SCREEN 1000.
  ELSEIF sy-ucomm = 'EXIT'.
    LEAVE TO SCREEN 0.
  ELSEIF sy-ucomm = 'BACK'.
    LEAVE TO SCREEN 0.
    ELSEIF SY-UCOMM = 'LOGOUT'.
      LEAVE TO SCREEN 1000.
  ENDIF.
ENDMODULE.