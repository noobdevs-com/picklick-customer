import 'package:flutter/cupertino.dart';

class Shop {
  Shop(
      {required this.name,
      required this.location,
      required this.img,
      required this.ownerId});

  String name;
  String location;
  String img;
  String ownerId;

  factory Shop.toJson(json) {
    return Shop(
        img: json['img'],
        name: json['name'],
        location: json['location'],
        ownerId: json['ownerId']);
  }
}
