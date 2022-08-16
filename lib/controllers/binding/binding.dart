import 'package:get/get.dart';
import 'package:picklick_customer/controllers/cart.dart';
import 'package:picklick_customer/controllers/hotel.dart';
import 'package:picklick_customer/controllers/location.dart';

class InitBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LocationController>(() => LocationController(), fenix: true);
    Get.lazyPut<HotelController>(() => HotelController(), fenix: true);
    Get.lazyPut<CartController>(() => CartController(), fenix: true);
  }
}
