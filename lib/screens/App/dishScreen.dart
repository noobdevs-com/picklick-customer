import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:picklick_customer/controllers/cart.dart';
import 'package:picklick_customer/screens/App/cartScreen.dart';
import 'package:picklick_customer/screens/App/dishTile.dart';

enum MenuScreen { MENU_SCREEN, OFFER_MENU_SCREEN }

class DishScreen extends StatefulWidget {
  DishScreen({required this.id, required this.name});
  final String id;
  final String name;

  @override
  _DishScreenState createState() => _DishScreenState();
}

class _DishScreenState extends State<DishScreen> {
  final CartController _cartController = Get.find();

  MenuScreen tile = MenuScreen.MENU_SCREEN;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
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
                  onPressed: () => Get.to(() => CartScreen()),
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
          child: SizedBox(
            height: 80,
            child: Row(
              children: [
                Expanded(
                    child: ElevatedButton(
                  child: Text('Menu'),
                  onPressed: () {
                    setState(() {
                      tile = MenuScreen.MENU_SCREEN;
                    });
                  },
                )),
                Expanded(
                    child: ElevatedButton(
                  child: Text('Offer Menu'),
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
      ),
    );
  }
}
