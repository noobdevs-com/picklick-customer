import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:picklick_customer/models/dish.dart';
import 'package:picklick_customer/models/shop.dart';

class HotelController extends GetxController {
  final shops = <Shop>[].obs;
  final dishes = <Dish>[].obs;
  final filterKey = 'All'.obs;
  final loading = false.obs;
  final filterLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    getShops();
  }

  // Firebase Request
  Future<void> getShops() async {
    loading.value = true;
    shops.clear();
    QuerySnapshot data = await FirebaseFirestore.instance
        .collection("hotels")
        .orderBy('status', descending: true)
        .orderBy('name')
        .get();
    data.docs.forEach((element) {
      shops.add(Shop.toJson(element));
    });
    loading.value = false;
  }

  Future<void> filterShops(String status) async {
    filterLoading.value = true;

    try {
      QuerySnapshot ref = await FirebaseFirestore.instance
          .collection('hotels')
          .where('status', isEqualTo: status)
          .orderBy('name')
          .get();
      shops.clear();

      for (var i = 0; i < ref.docs.length; i++) {
        Shop shop = Shop(
          img: ref.docs[i]['img'],
          ownerId: ref.docs[i]['ownerId'],
          did: ref.docs[i].id,
          name: ref.docs[i]["name"],
          status: ref.docs[i]["status"],
          location: ref.docs[i]["location"],
        );
        shops.add(shop);
      }
      filterLoading.value = false;
    } catch (e) {
      print(e);
      Get.snackbar("oops...", "Unable to get restaurants");

      filterLoading.value = false;
    }
  }

  // Future<void> getOfferDishes() async {
  //   loading.value = true;
  //   offerDishes.clear();
  //   QuerySnapshot data =
  //       await FirebaseFirestore.instance.collection("hotel_offerDishes").get();

  //   offerDishes.value = data.docs.map((e) => OfferDish.fromJson(e)).toList();
  //   loading.value = false;
  // }
}
