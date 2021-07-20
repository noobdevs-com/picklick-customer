import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:get/get.dart';
import 'package:picklick_customer/models/dish.dart';

class HotelController extends GetxController {
  final dishes = <Dish>[].obs;
  // Firebase Request
  Future<void> getDishes(String id) async {
    QuerySnapshot data = await FirebaseFirestore.instance
        .collection("hotel_dishes")
        .where('ownerId', isEqualTo: id)
        .get();

    dishes.value = data.docs.map((e) => Dish.toJson(e)).toList();
  }
}
