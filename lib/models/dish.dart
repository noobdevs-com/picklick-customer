import 'package:flutter/cupertino.dart';

class Dish {
  Dish({
    required this.title,
    required this.price,
    required this.img,
  });

  String title;
  String price;
  ImageProvider img;
}
