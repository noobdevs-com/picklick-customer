import 'package:get/get.dart';
import 'package:picklick_customer/models/cartItem.dart';
import 'package:picklick_customer/models/dish.dart';

class CartController extends GetxController {
  final cart = <Dish>[].obs;
  final price = 0.0.obs;
  int getCartItemCount() => cart.length;

  List<CartItem> getCartItems() {
    return cart.map((e) => CartItem.toJson(e)).toList();
  }

  void addDishtoCart(Dish dish) {
    if (cart.contains(dish)) {
      dish.quantity.value++;
      price.value += dish.price;
    } else {
      cart.add(dish);
      price.value += dish.price;
    }
  }

  void removeDishfromCart(Dish dish) {
    if (dish.quantity.value == 1) {
      return;
    } else {
      dish.quantity.value--;
      price.value -= dish.price;
    }
  }

  void removeDish(Dish dish, int quantity) {
    cart.remove(dish);
    price.value -= dish.price * quantity;
    dish.quantity.value = 1;
  }

  void arrangeDishToCartIndex(int index, Dish dish, List<Dish> dishList) {
    int cartIndex = cart.indexWhere((e) => e.name == dish.name);
    if (cart.contains(dish)) {
      dishList[cartIndex] = dishList[index];
    }
  }
}
