import 'package:get/get.dart';
import 'package:picklick_customer/models/cartItem.dart';
import 'package:picklick_customer/models/dish.dart';
import 'package:picklick_customer/models/offerDish.dart';

class CartController extends GetxController {
  final cart = <Dish>[].obs;
  final cartItemName = <String>[].obs;
  final price = 0.0.obs;

  void addDishtoCart(Dish dish, int quantity) {
    cart.add(dish);
    price.value = price.value + (dish.price * quantity);
  }

  void removeDishfromCart(Dish dish, int quantity) {
    cart.remove(dish);
    price.value = price.value - (dish.price * quantity);
  }

  int getCartItemCount() {
    return cart.length + offerCart.length;
  }

  List<CartItem> getCartItems() {
    return cart.map((e) => CartItem.toJson(e)).toList();
  }

  final offerCart = <OfferDish>[].obs;

  void addOfferDishtoCart(OfferDish offerdish) {
    offerCart.add(offerdish);
    price.value += offerdish.discountedPrice;
  }

  void removeOfferDishtoCart(OfferDish offerdish) {
    offerCart.remove(offerdish);
    price.value -= offerdish.discountedPrice;
  }
}
