import 'package:flutter/material.dart';

final kElevatedButtonStyle = ElevatedButton.styleFrom(
    shadowColor: Color(0xFFCFB840),
    elevation: 4,
    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8))));

const KTFBorderStyle = OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(8)),
    borderSide: BorderSide(color: Color(0xFFCFB840)));

const KTFFocusedBorderStyle = OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(8)),
    borderSide: BorderSide(color: Colors.black));

const kCardShape = RoundedRectangleBorder(
    borderRadius: BorderRadius.only(
        bottomRight: Radius.circular(20), topRight: Radius.circular(20)));

const KbbcardShape =
    RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(50)));
