import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

final defaultColor = HexColor('#668cff');

    Widget background() => Container(
  decoration:  BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.center,
      colors: [
        HexColor('#668cff'),
        Colors.white,

      ],
    ),
  ),
);