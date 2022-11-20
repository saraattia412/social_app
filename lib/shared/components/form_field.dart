// ignore_for_file: avoid_print

import 'package:flutter/material.dart';

Widget defaultFormField({
  required TextEditingController? controller,
  required TextInputType type,
  Function(String)? onSubmit,
  required FormFieldValidator<String>? validator,
  required String label,
  required IconData prefix,

  //part password
  bool isPassword =false,
  IconData? suffix,
  Function? suffixPressed,

  //on tap
  Function? onTap,
  bool isClickable=true,

  Color? colorIcon,
  Color? textColor,


}) =>
    TextFormField(
      onFieldSubmitted: onSubmit,
      controller: controller,
      keyboardType: type,
      validator: validator,

      style: TextStyle(
        color: textColor
      ),

      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          color: Colors.black
        ),
        prefixIcon: Icon(
          prefix,
          color: colorIcon,
        ),

        border:   OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(width: 2.0)
        ),

        //password
        suffixIcon :suffix != null ?  IconButton(
          onPressed: (){
            suffixPressed!();
          },
          icon: Icon(
            suffix,
            color: colorIcon,
          ),
        ) : null,

      ),

      //password
      obscureText:isPassword,

      //on tap
      onTap: (){
        print('done');
      },
      enabled: isClickable,
//END ON TAP

    );
