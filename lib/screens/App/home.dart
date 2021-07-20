import 'package:flutter/material.dart';
import 'package:picklick_customer/components/MenuDrawer.dart';
import 'package:picklick_customer/screens/App/cart.dart';
import 'package:picklick_customer/screens/App/shopTile.dart';

class Home extends StatelessWidget {
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
      child: Scaffold(
        drawer: MenuDrawer(),
        appBar: AppBar(
          toolbarHeight: 110,
          bottom: TabBar(
            tabs: myTabs,
          ),
          actions: [
            IconButton(
                onPressed: () {},
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
          Center(child: Text('This is the Shop Status tab')),
          Center(child: Text('This is the Shop Status tab')),
          Center(child: Text('This is the PickLcik tab')),
        ]),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => MyCart()));
          },
          child: Icon(Icons.shopping_cart),
        ),
      ),
    );
  }
}
