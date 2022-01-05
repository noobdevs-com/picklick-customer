import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:picklick_customer/constants/valueConstants.dart';
import 'package:picklick_customer/controllers/hotel.dart';

import 'package:picklick_customer/controllers/shopSearch.dart';
import 'package:picklick_customer/models/shop.dart';
import 'package:picklick_customer/screens/App/dishScreen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final SearchController searchController = Get.put(SearchController());

  List<String> tempSearch = [];
  Future<void> getDishes(String value) async {
    searchController.shops.clear();
    FirebaseFirestore.instance
        .collection('hotels')
        .where('name', isGreaterThanOrEqualTo: value)
        .orderBy('name')
        .where('name', isLessThan: value + 'z')
        .get()
        .then((snapshot) {
      snapshot.docs.forEach((element) {
        searchController.shops.add(Shop.toJson(element.data()));
        tempSearch.add(Shop.toJson(element.data()).name!.toUpperCase());
      });
    });
  }

  final _hotelController = Get.put(HotelController());
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
                    if (t == "") return;
                    getDishes(t.toUpperCase());
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
                    itemCount: searchController.shops.length,
                    itemBuilder: (_, i) {
                      return Card(
                        shadowColor: Colors.black87,
                        elevation: 2,
                        margin: EdgeInsets.all(2),
                        child: ListTile(
                          title: Text(
                            searchController.shops[i].name!,
                            style: TextStyle(
                              fontSize: 19,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: Text(
                            searchController.shops[i].location!,
                            style: TextStyle(
                                fontSize: 15, fontStyle: FontStyle.italic),
                          ),
                          leading: SizedBox(
                            width: 50,
                            child: ClipRRect(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50)),
                              child: Hero(
                                  tag: searchController.shops[i],
                                  child: FadeInImage(
                                      height: 50,
                                      width: 50,
                                      fit: BoxFit.cover,
                                      placeholder:
                                          AssetImage('assets/mainLogo.png'),
                                      image: NetworkImage(
                                        searchController.shops[i].img!,
                                      ))),
                            ),
                          ),
                          trailing: !_hotelController.loading.value
                              ? StreamBuilder(
                                  stream: FirebaseFirestore.instance
                                      .collection('hotels')
                                      .where('ownerId',
                                          isEqualTo:
                                              searchController.shops[i].ownerId)
                                      .snapshots(),
                                  builder: (context,
                                      AsyncSnapshot<QuerySnapshot> sp) {
                                    if (!sp.hasData)
                                      return CupertinoActivityIndicator();
                                    final data = sp.data!.docs[0];

                                    return CircleAvatar(
                                      radius: 8,
                                      backgroundColor: data['status'] == 'open'
                                          ? Colors.green
                                          : Colors.red,
                                    );
                                  },
                                )
                              : CircularProgressIndicator(),
                          onTap: () {
                            if (searchController.shops[i].status == 'open')
                              Get.to(() => DishScreen(
                                    img: searchController.shops[i].img!,
                                    id: searchController.shops[i].ownerId!,
                                    name: searchController.shops[i].name!,
                                  ));
                            else
                              Get.snackbar('Restaurant is Closed',
                                  'The restaurant you are trying to reach is not at service now , try again later');
                          },
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
