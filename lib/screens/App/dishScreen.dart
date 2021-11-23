import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:picklick_customer/components/dishSearchBar.dart';
import 'package:picklick_customer/controllers/cart.dart';
import 'package:picklick_customer/screens/App/cartScreen.dart';
import 'package:picklick_customer/screens/App/dishTile.dart';
import 'package:picklick_customer/screens/App/offerDishTile.dart';

import 'home.dart';

class DishScreen extends StatefulWidget {
  DishScreen({required this.id, required this.name, required this.img});
  final String id;
  final String name;

  final String img;

  @override
  _DishScreenState createState() => _DishScreenState();
}

class _DishScreenState extends State<DishScreen> {
  final CartController _cartController = Get.put(CartController());

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_cartController.cart.length > 0 ||
            _cartController.offerCart.length > 0) {
          Get.defaultDialog(
              title: 'Warning',
              middleText:
                  'If you go back your cart will be cleared, Are you Sure You want to go back?',
              textCancel: 'No',
              textConfirm: 'Yes',
              onConfirm: () {
                _cartController.offerCart.clear();
                _cartController.cart.clear();
                _cartController.price.value = 0;
                Get.off(() => Home());
              });
          return false;
        } else {
          return true;
        }
      },
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            leading: Row(
              children: [
                Expanded(
                    child: IconButton(
                        onPressed: () {
                          if (_cartController.cart.length > 0 ||
                              _cartController.offerCart.length > 0) {
                            Get.defaultDialog(
                                title: 'Warning',
                                middleText:
                                    'If you go back your cart will be cleared, Are you Sure You want to go back?',
                                textCancel: 'No',
                                textConfirm: 'Yes',
                                onConfirm: () {
                                  _cartController.offerCart.clear();
                                  _cartController.cart.clear();
                                  _cartController.price.value = 0;
                                  Get.off(() => Home());
                                });
                          } else {
                            Get.back();
                          }
                        },
                        icon: Icon(Icons.arrow_back))),
                Expanded(
                    child: Hero(
                        tag: widget.img,
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(widget.img),
                        ))),
              ],
            ),
            leadingWidth: MediaQuery.of(context).size.width / 4.2,
            title: Text(
              widget.name,
              style: TextStyle(
                  fontSize: 21,
                  fontStyle: FontStyle.italic,
                  overflow: TextOverflow.ellipsis),
            ),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                      onPressed: () {
                        Get.to(() => DishSearchBar(
                              id: widget.id,
                            ));
                      },
                      icon: Icon(Icons.search)),
                  IconButton(
                    icon: Icon(Icons.shopping_cart),
                    onPressed: () => Get.to(
                      () => CartScreen(
                        id: widget.id,
                        name: widget.name,
                      ),
                    ),
                  ),
                  Obx(() => Text(
                      ('${_cartController.cart.length + _cartController.offerCart.length}')
                          .toString())),
                  SizedBox(
                    width: 25,
                  )
                ],
              )
            ],
            bottom: TabBar(
              indicatorColor: Colors.white,
              tabs: [
                Tab(
                  child: Text('Menu'),
                ),
                Tab(
                  child: Text('Offer Menu'),
                )
              ],
            ),
          ),
          body: TabBarView(
            children: [
              DishTile(
                id: widget.id,
              ),
              OfferDishTile(id: widget.id)
            ],
          ),
        ),
      ),
    );
  }
}
