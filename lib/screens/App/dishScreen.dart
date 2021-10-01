import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:picklick_customer/controllers/cart.dart';
import 'package:picklick_customer/screens/App/cartScreen.dart';
import 'package:picklick_customer/screens/App/dishTile.dart';

import 'home.dart';

enum MenuScreen { MENU_SCREEN, OFFER_MENU_SCREEN }

class DishScreen extends StatefulWidget {
  DishScreen({required this.id, required this.name});
  final String id;
  final String name;

  @override
  _DishScreenState createState() => _DishScreenState();
}

class _DishScreenState extends State<DishScreen> {
  final CartController _cartController = Get.put(CartController());

  MenuScreen tile = MenuScreen.MENU_SCREEN;

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
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            '${widget.name}\'s Menu',
            style: TextStyle(
              fontSize: 16,
              fontStyle: FontStyle.italic,
            ),
          ),
          actions: [
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.shopping_cart),
                  onPressed: () => Get.to(
                    () => CartScreen(
                      name: widget.name,
                    ),
                  ),
                ),
                SizedBox(
                  width: 12,
                ),
                Obx(() => Text(
                    ('${_cartController.cart.length + _cartController.offerCart.length}')
                        .toString())),
                SizedBox(
                  width: 40,
                )
              ],
            )
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: DishTile(
            id: widget.id,
            tile: tile,
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          color: Color(0xFFF0EBCC),
          child: Row(
            children: [
              Expanded(
                  child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                ),
                child: Text('Menu'),
                onPressed: () {
                  setState(() {
                    tile = MenuScreen.MENU_SCREEN;
                  });
                },
              )),
              SizedBox(
                width: 5,
              ),
              Expanded(
                  child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                ),
                child: Text(
                  'Offer Menu',
                ),
                onPressed: () {
                  setState(() {
                    tile = MenuScreen.OFFER_MENU_SCREEN;
                  });
                },
              ))
            ],
          ),
        ),
      ),
    );
  }
}
