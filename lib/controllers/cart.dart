import 'package:get/get.dart';
import 'package:picklick_customer/models/cartItem.dart';
import 'package:picklick_customer/models/dish.dart';
import 'package:picklick_customer/models/offerDish.dart';

class CartController extends GetxController {
  final cart = <Dish>[].obs;
  // final cartItemName = <String>[].obs;
  final price = 0.0.obs;

  void addDishtoCart(Dish dish) {
    final list = cart.where((e) => e.name == dish.name).toList();
    final index = cart.indexWhere((e) => e.name == dish.name);
    if (list.isEmpty) {
      cart.add(dish);
      price.value = price.value + (dish.price * dish.dishQuantity);
    } else {
      price.value = price.value + (dish.price * dish.dishQuantity);
      cart[index].dishQuantity++;
    }
    print(index);
  }

  void removeDishfromCart(Dish dish) {
    final list = cart.where((e) => e.name == dish.name).toList();
    final index = cart.indexWhere((e) => e.name == dish.name);

    if (cart[index].dishQuantity > 1) {
      price.value = price.value - (dish.price * dish.dishQuantity);
      cart[index].dishQuantity--;
    } else if (cart[index].dishQuantity == 1) {
      cart.remove(dish);
      price.value = price.value - (dish.price * dish.dishQuantity);
    }
    ;
    print(index);
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
