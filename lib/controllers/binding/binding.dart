import 'package:get/get.dart';
import 'package:picklick_customer/controllers/cart.dart';

import 'package:picklick_customer/controllers/hotel.dart';

class InitBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<HotelController>(HotelController());
    Get.put<CartController>(CartController());
  }
}
