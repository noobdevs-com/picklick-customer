import 'dish.dart';

class Cart {
  Cart(
      {required this.name,
      required this.price,
      required this.quantity,
      required this.img});
  String name;
  double price;
  int quantity;
  String img;

  List<Dish> cart = [];

  void addDishtoCart(Dish dish) {
    cart.add(dish);
  }

  void removeDishtoCart(Dish dish) {
    cart.remove(dish);
  }
}
