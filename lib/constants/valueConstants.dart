import 'package:flutter/material.dart';

final kElevatedButtonStyle = ElevatedButton.styleFrom(
    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(18))));

const KTFBorderStyle = OutlineInputBorder(
  borderRadius: BorderRadius.all(Radius.circular(8)),
);

const KTFFocusedBorderStyle = OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(8)),
    borderSide: BorderSide(color: Color(0xFFCFB840)));
