import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:picklick_customer/constants/valueConstants.dart';
import 'package:picklick_customer/controllers/cart.dart';

import 'package:picklick_customer/controllers/hotel.dart';
import 'package:picklick_customer/controllers/shopSearch.dart';
import 'package:picklick_customer/models/dish.dart';

class DishSearchBar extends StatefulWidget {
  DishSearchBar({Key? key, required this.id}) : super(key: key);
  String id;
  @override
  _DishSearchBarState createState() => _DishSearchBarState();
}

class _DishSearchBarState extends State<DishSearchBar> {
  final SearchController searchController = Get.put(SearchController());
  final CartController _cartController = Get.put(CartController());
  final HotelController _controller = Get.put(HotelController());
  Future<void> getDishes(String value) async {
    searchController.dishes.clear();

    FirebaseFirestore.instance
        .collection('hotel_dishes')
        .where('ownerId', isEqualTo: widget.id)
        .where('name', isGreaterThanOrEqualTo: value)
        .orderBy('name')
        .where('name', isLessThan: value + 'z')
        .get()
        .then((snapshot) {
      print("Result:");
      snapshot.docs.forEach((element) {
        searchController.dishes.add(Dish.toJson(element.data()));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: 16,
          ),
          child: Column(
            children: [
              // Search Bar
              SizedBox(
                height: 8,
              ),
              Container(
                height: 50,
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search For Dishes',
                    border: KTFBorderStyle,
                    focusedBorder: KTFFocusedBorderStyle,
                    prefixIcon: Icon(
                      Icons.search_outlined,
                      color: Colors.black,
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.close, color: Colors.black),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  onChanged: (String t) {
                    searchController.dishes.clear();
                    searchController.update();
                    if (t == "") return;
                    getDishes(t);
                  },
                  autofocus: true,
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),

              // Search Results
              Expanded(
                child: Obx(
                  () => ListView.builder(
                    itemCount: searchController.dishes.length,
                    itemBuilder: (_, i) {
                      return Card(
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundImage:
                                NetworkImage(searchController.dishes[i].img),
                            radius: 29,
                          ),
                          title: Text(searchController.dishes[i].name),
                          subtitle:
                              Text(searchController.dishes[i].price.toString()),
                          trailing: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: Color(0xFFCFB840)),
                            onPressed: () {
                              if (_cartController.cart
                                  .contains(_controller.dishes[i])) {
                                Get.snackbar("Item already in cart",
                                    "The item you have choosen is already in cart.");
                              }
                              _cartController.addDishtoCart(
                                  _controller.dishes[i],
                                  _controller.dishes[i].quantity);
                            },
                            child: Icon(
                              Icons.add_shopping_cart_rounded,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
