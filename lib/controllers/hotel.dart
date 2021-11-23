import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:picklick_customer/models/dish.dart';
import 'package:picklick_customer/models/offerDish.dart';
import 'package:picklick_customer/models/shop.dart';

class HotelController extends GetxController {
  final shops = <Shop>[].obs;
  final dishes = <Dish>[].obs;
  final offerDishes = <OfferDish>[].obs;
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

  Future<void> getDishes(String id) async {
    loading.value = true;
    dishes.clear();
    QuerySnapshot data = await FirebaseFirestore.instance
        .collection("hotel_dishes")
        .where('ownerId', isEqualTo: id)
        .orderBy('name')
        .get();

    dishes.value = data.docs.map((e) => Dish.toJson(e)).toList();
    loading.value = false;
  }

  Future<void> getOfferDishes(String id) async {
    loading.value = true;
    offerDishes.clear();
    QuerySnapshot data = await FirebaseFirestore.instance
        .collection("hotel_offerDishes")
        .where('ownerId', isEqualTo: id)
        .orderBy('name')
        .get();

    offerDishes.value = data.docs.map((e) => OfferDish.fromJson(e)).toList();
    loading.value = false;
  }
}

mixin AnimatedState {}
