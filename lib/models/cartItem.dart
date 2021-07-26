class CartItem {
  String name;
  double price;
  int quantity;
  String img;

  CartItem(
      {required this.img,
      required this.name,
      required this.price,
      required this.quantity});

  factory CartItem.toJson(json) {
    return CartItem(
        name: json['name'],
        price: double.parse(json['price']),
        img: json['img'],
        quantity: json['quantity']);
  }
}
