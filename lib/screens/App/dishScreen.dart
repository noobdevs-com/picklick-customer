import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:picklick_customer/components/dishSearchBar.dart';
import 'package:picklick_customer/controllers/cart.dart';
import 'package:picklick_customer/screens/App/cartScreen.dart';
import 'package:picklick_customer/screens/App/dishTile.dart';
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
              cancelTextColor: Color(0xFFCFB840),
              buttonColor: Color(0xFFCFB840),
              confirmTextColor: Color(0xFFF0EBCC),
              backgroundColor: Color(0xFFF0EBCC),
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
          elevation: 0.5,
          automaticallyImplyLeading: false,
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
                    icon: Icon(CupertinoIcons.back)),
              ),
              Expanded(
                child: Hero(
                    tag: widget.img,
                    child: CircleAvatar(
                      radius: 20,
                      child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          child: Image.network(
                            widget.img,
                            height: 40,
                            width: 40,
                            fit: BoxFit.cover,
                          )),
                    )),
              ),
            ],
          ),
          leadingWidth: MediaQuery.of(context).size.width / 3,
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
                GestureDetector(
                  onTap: () =>
                      Get.to(CartScreen(name: widget.name, id: widget.id)),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Color(0xFFF0EBCC),
                        borderRadius: BorderRadius.all(Radius.circular(12))),
                    width: 70,
                    height: 40,
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Icon(Icons.shopping_cart),
                          Obx(() => Text(
                              ('${_cartController.cart.length + _cartController.offerCart.length}')
                                  .toString()))
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 25,
                )
              ],
            )
          ],
        ),
        body: DishTile(
          id: widget.id,
        ),
      ),
    );
  }
}
