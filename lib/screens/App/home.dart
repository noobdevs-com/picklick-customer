import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:picklick_customer/components/MenuDrawer.dart';
import 'package:picklick_customer/components/searchBar.dart';
import 'package:picklick_customer/controllers/cart.dart';
import 'package:picklick_customer/screens/App/cartScreen.dart';
import 'package:picklick_customer/screens/App/offerShopTile.dart';
import 'package:picklick_customer/screens/App/shopTile.dart';

class Home extends StatelessWidget {
  final CartController _cartController = Get.put(CartController());
  final List<Tab> myTabs = <Tab>[
    Tab(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [Text('Shop'), Icon(Icons.shop)],
      ),
    ),
    Tab(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Shop Offers'),
          Icon(
            Icons.circle,
            size: 15,
          )
        ],
      ),
    ),
    Tab(
      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text('Favorites'),
        Icon(
          Icons.favorite,
        )
      ]),
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: myTabs.length,
      child: SafeArea(
        child: Scaffold(
          drawer: MenuDrawer(),
          appBar: AppBar(
            toolbarHeight: 110,
            bottom: TabBar(
              indicatorColor: Colors.white,
              tabs: myTabs,
            ),
            actions: [
              IconButton(
                  onPressed: () {
                    Get.to(() => SearchScreen());
                  },
                  icon: Icon(
                    Icons.search,
                    size: 27,
                  )),
              SizedBox(
                width: 20,
              ),
              Image.asset(
                'assets/logo.png',
              )
            ],
          ),
          body: TabBarView(children: [
            ShopTile(),
            OfferShopTile(),
            Center(child: Text('This is the PickLcik tab')),
          ]),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Get.to(() => CartScreen());
            },
            child: Icon(Icons.shopping_cart),
          ),
        ),
      ),
    );
  }
}
