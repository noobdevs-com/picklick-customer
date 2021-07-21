import 'package:get/get.dart';
import 'package:picklick_customer/models/dish.dart';

class CartController extends GetxController {
  final cart = <Dish>[].obs;
  final price = 0.0.obs;

  void addDishtoCart(Dish dish) {
    cart.add(dish);
    price.value += dish.price;
  }

  void removeDishtoCart(Dish dish) {
    cart.remove(dish);
    price.value = dish.price;
  }

  int getCartItemCount() {
    return cart.length;
  }
}
