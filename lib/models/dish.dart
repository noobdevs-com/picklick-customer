import 'package:get/get.dart';

class Dish extends GetxController {
  Dish({
    required this.name,
    required this.price,
    required this.img,
    // required this.ownerId,
  });

  String name;
  double price;
  String img;
  // String ownerId;
  final _quantity = 1.obs;
  int get quantity => _quantity.value;
  setQuantity(int value) {
    _quantity.value += value;
  }

  factory Dish.toJson(json) {
    return Dish(
      name: json['name'],
      price: double.parse(json['price'].toString()),
      img: json['img'],
      // ownerId: json['ownerId']
    );
  }
}
