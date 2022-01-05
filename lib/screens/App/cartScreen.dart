import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:picklick_customer/controllers/cart.dart';
import 'package:picklick_customer/screens/App/home.dart';
import 'package:picklick_customer/screens/App/paymentMethodScreen.dart';

class CartScreen extends StatefulWidget {
  CartScreen({required this.name, required this.id});
  final String name;
  final String id;
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final CartController _cartController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('My Cart'),
      ),
      body: _cartController.offerCart.length + _cartController.cart.length == 0
          ? Center(
              child: SizedBox(
                height: 200,
                width: 500,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Cart Is Empty',
                          style: TextStyle(fontSize: 20),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Icon(Icons.shopping_cart)
                      ],
                    ),
                    TextButton(
                        onPressed: () {
                          Get.offAll(() => Home());
                        },
                        child: Text('Add Items To Cart',
                            style: TextStyle(fontSize: 18, color: Colors.red)))
                  ],
                ),
              ),
            )
          : WillPopScope(
              onWillPop: () async {
                _cartController.cart.map((element) => element.dishQuantity = 1);
                return true;
              },
              child: SingleChildScrollView(
                child: Obx(() => Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        ListView.builder(
                            scrollDirection: Axis.vertical,
                            physics: ScrollPhysics(
                                parent: NeverScrollableScrollPhysics()),
                            shrinkWrap: true,
                            itemCount: _cartController.cart.length,
                            itemBuilder: (context, index) {
                              final cart = _cartController.cart[index];
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 4),
                                child: Card(
                                  elevation: 0.5,
                                  child: ListTile(
                                    title: Text(cart.name),
                                    subtitle:
                                        Text('₹ ${cart.price * cart.quantity}'),
                                    trailing: SizedBox(
                                      width: 160,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          IconButton(
                                              onPressed: () {
                                                if (cart.quantity > 1) {
                                                  cart.setQuantity(-1);
                                                  setState(() {
                                                    _cartController.price
                                                        .value -= cart.price;
                                                  });
                                                }
                                              },
                                              icon: Icon(Icons.remove)),
                                          Text(cart.quantity.toString()),
                                          IconButton(
                                              onPressed: () {
                                                cart.setQuantity(1);

                                                setState(() {
                                                  _cartController.price.value +=
                                                      cart.price;
                                                });
                                              },
                                              icon: Icon(Icons.add)),
                                          IconButton(
                                              onPressed: () {
                                                _cartController
                                                    .removeDishfromCart(
                                                        cart, cart.quantity);
                                              },
                                              icon: Icon(Icons.delete))
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }),
                        ListView.builder(
                            scrollDirection: Axis.vertical,
                            physics: ScrollPhysics(
                                parent: NeverScrollableScrollPhysics()),
                            shrinkWrap: true,
                            itemCount: _cartController.offerCart.length,
                            itemBuilder: (context, index) {
                              final offercart =
                                  _cartController.offerCart[index];
                              return Padding(
                                padding: const EdgeInsets.fromLTRB(
                                  4,
                                  4,
                                  4,
                                  0,
                                ),
                                child: Card(
                                  child: ListTile(
                                    title: Text(offercart.name),
                                    subtitle: Text(
                                        '₹ ${offercart.discountedPrice * offercart.quantity}'),
                                    trailing: SizedBox(
                                      width: 160,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          IconButton(
                                              onPressed: () {
                                                if (offercart.quantity > 1) {
                                                  offercart.setQuantity(-1);
                                                  setState(() {
                                                    _cartController
                                                            .price.value -=
                                                        offercart
                                                            .discountedPrice;
                                                  });
                                                }
                                              },
                                              icon: Icon(Icons.remove)),
                                          Text(offercart.quantity.toString()),
                                          IconButton(
                                              onPressed: () {
                                                offercart.setQuantity(1);

                                                setState(() {
                                                  _cartController.price.value +=
                                                      offercart.discountedPrice;
                                                });
                                              },
                                              icon: Icon(Icons.add)),
                                          IconButton(
                                              onPressed: () {
                                                _cartController
                                                    .removeOfferDishtoCart(
                                                        offercart);
                                              },
                                              icon: Icon(Icons.delete))
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }),
                      ],
                    )),
              ),
            ),
      bottomNavigationBar: BottomAppBar(
        elevation: 0,
        color: Colors.white,
        child: Row(
          children: [
            SizedBox(
              width: 8,
            ),
            Obx(() => Flexible(
                flex: 1,
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                      color: Colors.red),
                  height: 45,
                  child: Center(
                    child: Text(
                      '  TOTAL :  ₹ ${_cartController.price.value}',
                      style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                          color: Colors.white),
                    ),
                  ),
                ))),
            Flexible(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: _cartController.cart.length != 0
                      ? () {
                          Get.to(
                            () => PaymentMethodScreen(
                              restaurantId: widget.id,
                              restaurantName: widget.name,
                            ),
                          );
                        }
                      : null,
                  child: Text('Proceed'),
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFFCFB840),
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
