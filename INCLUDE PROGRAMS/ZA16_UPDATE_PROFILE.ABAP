*----------------------------------------------------------------------*
***INCLUDE ZA16_UPDATE_PROFILE.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  STATUS_1008  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE status_1008 OUTPUT.
*  SET PF-STATUS 'xxxxxxxx'.
*  SET TITLEBAR 'xxx'.
  DATA: it_update TYPE TABLE OF za16_l_info,
        wa_update TYPE za16_l_info.



  DATA: up_roll          TYPE  za16_rollno,
        up_name          TYPE  za16_name,
        up_gender        TYPE  za16_gender,
        up_degree        TYPE  za16_degree,
        up_field         TYPE  za16_field,
        up_address       TYPE za16_address,
        up_date_and_time TYPE  za16_dt.


  SELECT * FROM za16_l_info INTO TABLE it_update WHERE stu_id = stu_id.

  LOOP AT it_update INTO wa_update.
    up_roll   = wa_update-roll.
    up_name   = wa_update-name.
    up_gender = wa_update-gender.
    up_degree = wa_update-degree.
    up_field  = wa_update-field.
    up_address = wa_update-address.
    up_date_and_time = wa_update-date_and_time.
  ENDLOOP.
  CASE sy-ucomm .
    WHEN 'BACK'.
      CALL SCREEN 1004.
    WHEN 'EXIT'.
      CALL SCREEN 0.
    WHEN 'CANCEL'.
      CALL SCREEN 1004.
    WHEN 'LOGOUT'.
      CALL SCREEN 1000.
  ENDCASE.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_1008  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_1008 INPUT.
  IF sy-ucomm = 'UPDATE'.
    wa_update-roll   = up_roll   .
    wa_update-name   = up_name   .
    wa_update-gender = up_gender .
    wa_update-degree = up_degree .
    wa_update-field  = up_field  .
    wa_update-address    = up_address.
    UPDATE za16_l_info FROM wa_update.

    CLEAR: up_roll,
           up_name,
           up_gender,
           up_degree,
           up_field,
           up_address.


    MESSAGE 'SUCCESSFUL UPDATED' TYPE 'S'.

    LEAVE TO SCREEN 1001.
  ENDIF.

ENDMODULE.