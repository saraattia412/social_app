import 'package:flutter/material.dart';

Widget myDivider( ) => Padding(
  padding: const EdgeInsetsDirectional.only(
    start: 10,
    end: 10
  ),
  child: Container(
    width: double.infinity,
    height: 1,
    color: Colors.grey[200],
  ),
);