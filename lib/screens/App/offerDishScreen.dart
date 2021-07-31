import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:picklick_customer/controllers/cart.dart';
import 'package:picklick_customer/screens/App/cartScreen.dart';
import 'package:picklick_customer/screens/App/dishTile.dart';

import 'offerDishTile.dart';

class OfferDishScreen extends StatelessWidget {
  final CartController _cartController = Get.find();

  OfferDishScreen({required this.id, required this.name});
  final String id;
  final String name;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            '$name\'s Menu',
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
          child: OfferDishTile(
            id: id,
          ),
        ),
      ),
    );
  }
}
