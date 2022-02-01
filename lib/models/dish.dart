import 'package:get/get.dart';

class Dish extends GetxController {
  Dish(
      {required this.name,
      required this.price,
      required this.img,
      required this.dishQuantity});

  String name;
  double price;
  String img;
  int dishQuantity;

  final quantity = 1.obs;

  int get dishquantity => quantity.value;

  factory Dish.toJson(json) {
    late int quantity;
    try {
      quantity = json['quantity'];
    } catch (e) {
      quantity = 1;
    }
    return Dish(
      name: json['name'],
      price: double.parse(json['price'].toString()),
      img: json['img'],
      dishQuantity: quantity,
    );
  }

  Map<String, dynamic> converToJson() {
    return {
      "name": this.name,
      "price": this.price,
      "img": this.img,
      "quantity": this.quantity
    };
  }
}
