import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:get/get.dart';
import 'package:picklick_customer/models/dish.dart';
import 'package:picklick_customer/models/shop.dart';

class HotelController extends GetxController {
  final shops = <Shop>[].obs;
  final dishes = <Dish>[].obs;
  final loading = false.obs;

  @override
  void onInit() {
    super.onInit();
    getShops();
  }

  // Firebase Request
  Future<void> getShops() async {
    loading.value = true;
    shops.clear();
    QuerySnapshot data =
        await FirebaseFirestore.instance.collection("hotels").get();
    data.docs.forEach((element) {
      shops.add(Shop.toJson(element));
    });
    loading.value = false;
  }

  Future<void> getDishes(String id) async {
    QuerySnapshot data = await FirebaseFirestore.instance
        .collection("hotel_dishes")
        .where('ownerId', isEqualTo: id)
        .get();

    dishes.value = data.docs.map((e) => Dish.toJson(e)).toList();
  }
}
