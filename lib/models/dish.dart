import 'package:flutter/cupertino.dart';

class Dish {
  Dish(
      {required this.name,
      required this.price,
      required this.img,
      required this.ownerId});

  String name;
  String price;
  String img;
  String ownerId;

  factory Dish.toJson(json) {
    return Dish(
        name: json['name'],
        price: json['price'],
        img: json['img'],
        ownerId: json['ownerId']);
  }
}
