import 'package:get/get.dart';

class OfferDish {
  OfferDish({
    required this.name,
    required this.originalPrice,
    required this.discountedPrice,
    required this.img,
  });

  String name;
  double discountedPrice;
  double originalPrice;
  String img;
  final _quantity = 1.obs;
  int get quantity => _quantity.value;
  setQuantity(int value) {
    _quantity.value += value;
  }

  factory OfferDish.fromJson(json) {
    return OfferDish(
      discountedPrice: double.parse(json['discountedPrice'].toString()),
      name: json['name'],
      originalPrice: double.parse(json['originalPrice'].toString()),
      img: json['img'],
    );
  }
}
