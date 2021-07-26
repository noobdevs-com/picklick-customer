import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:picklick_customer/controllers/cart.dart';
import 'package:picklick_customer/screens/App/home.dart';
import 'package:picklick_customer/screens/App/paymentMethodScreen.dart';

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final CartController _cartController = Get.find();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('My Cart'),
        ),
        body: _cartController.cart.length == 0
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
                            'Cart Is Empty, Fill The Cart To Buy Items',
                            style: TextStyle(fontSize: 18),
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Icon(Icons.shopping_cart)
                        ],
                      ),
                      TextButton(
                          onPressed: () {
                            Get.to(() => Home());
                          },
                          child: Text('Add Items To Cart',
                              style:
                                  TextStyle(fontSize: 18, color: Colors.red)))
                    ],
                  ),
                ),
              )
            : Obx(() => ListView.builder(
                itemCount: _cartController.cart.length,
                itemBuilder: (context, index) {
                  final cart = _cartController.cart[index];
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(
                      4,
                      4,
                      4,
                      0,
                    ),
                    child: Card(
                      child: ListTile(
                        title: Text(cart.name),
                        subtitle: Text('₹ ${cart.price * cart.quantity}'),
                        trailing: SizedBox(
                          width: 160,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                  onPressed: () {
                                    if (cart.quantity > 1) {
                                      cart.setQuantity(-1);
                                      setState(() {
                                        _cartController.price.value -=
                                            cart.price;
                                      });
                                    }
                                  },
                                  icon: Icon(Icons.remove)),
                              Text(cart.quantity.toString()),
                              IconButton(
                                  onPressed: () {
                                    cart.setQuantity(1);

                                    setState(() {
                                      _cartController.price.value += cart.price;
                                    });
                                  },
                                  icon: Icon(Icons.add)),
                              IconButton(
                                  onPressed: () {
                                    _cartController.removeDishtoCart(cart);
                                  },
                                  icon: Icon(Icons.delete))
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                })),
        bottomNavigationBar: BottomAppBar(
          child: Row(
            children: [
              Obx(() => Expanded(
                  flex: 1,
                  child: Text(
                    '  TOTAL :  ₹ ${_cartController.price.value}',
                    style: TextStyle(fontSize: 20),
                  ))),
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      Get.to(() => PaymentMethodScreen());
                    },
                    child: Text('Proceed'),
                    style: ElevatedButton.styleFrom(
                      padding:
                          EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
