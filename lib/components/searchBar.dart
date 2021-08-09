import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:picklick_customer/controllers/hotel.dart';
import 'package:picklick_customer/controllers/search.dart';
import 'package:picklick_customer/models/shop.dart';
import 'package:picklick_customer/screens/App/dishScreen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final SearchController searchController = Get.put(SearchController());
  Future<void> getHotels(String value) async {
    searchController.shops.clear();
    await Future.delayed(Duration(milliseconds: 500));
    FirebaseFirestore.instance
        .collection('hotels')
        .where('name', isGreaterThanOrEqualTo: value)
        .where('name', isLessThan: value + 'z')
        .limit(5)
        .get()
        .then((snapshot) {
      print("Result:");
      snapshot.docs.forEach((element) {
        searchController.shops.add(Shop.toJson(element.data()));
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
              TextField(
                decoration: InputDecoration(
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
                  if (t == "") return;
                  getHotels(t);
                },
                autofocus: true,
                style: TextStyle(
                  fontSize: 16,
                ),
              ),

              // Search Results
              Expanded(
                child: Obx(
                  () => ListView.builder(
                    shrinkWrap: true,
                    itemCount: searchController.shops.length,
                    itemBuilder: (_, i) {
                      return Card(
                        child: ListTile(
                          onTap: () {
                            if (searchController.shops[i].status == 'open') {
                              Get.to(() => DishScreen(
                                    id: searchController.shops[i].ownerId,
                                    name: searchController.shops[i].name,
                                  ));
                              Navigator.pop(context);
                            } else
                              Get.snackbar('Restaurant is Closed',
                                  'The restaurant you are trying to reach is not at service now , try again later');
                          },
                          leading: CircleAvatar(
                            backgroundImage:
                                NetworkImage(searchController.shops[i].img),
                            radius: 29,
                          ),
                          title: Text(searchController.shops[i].name),
                          subtitle: Text(searchController.shops[i].location),
                          trailing: searchController.shops[i].status == 'open'
                              ? Text(
                                  searchController.shops[i].status
                                      .toUpperCase(),
                                  style: TextStyle(
                                      color: Colors.green,
                                      letterSpacing: 2,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13),
                                )
                              : Text(
                                  searchController.shops[i].status
                                      .toUpperCase(),
                                  style: TextStyle(
                                      color: Colors.red,
                                      letterSpacing: 2,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13),
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
