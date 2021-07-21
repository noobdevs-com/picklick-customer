import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:picklick_customer/controllers/cart.dart';
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
        body: Obx(() => ListView.builder(
            itemCount: _cartController.cart.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.fromLTRB(
                  4,
                  4,
                  4,
                  0,
                ),
                child: Card(
                  child: ListTile(
                    title: Text(_cartController.cart[index].name),
                    subtitle: Text('₹ ${_cartController.cart[index].price}'),
                    trailing: SizedBox(
                      width: 160,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                              onPressed: () {
                                if (_cartController.cart[index].quantity > 1)
                                  _cartController.cart[index].setQuantity(-1);
                                _cartController.price.value -=
                                    _cartController.cart[index].price;

                                setState(() {});
                              },
                              icon: Icon(Icons.remove)),
                          Text(_cartController.cart[index].quantity.toString()),
                          IconButton(
                              onPressed: () {
                                _cartController.cart[index].setQuantity(1);
                                _cartController.price.value +=
                                    _cartController.cart[index].price;

                                setState(() {});
                              },
                              icon: Icon(Icons.add)),
                          IconButton(
                              onPressed: () {
                                _cartController.removeDishtoCart(
                                    _cartController.cart[index]);
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
                    '      Total :  ₹ ${_cartController.price.value}',
                    style: TextStyle(fontSize: 20),
                  ))),
              Expanded(
                flex: 1,
                child: ElevatedButton(
                  onPressed: () {
                    Get.to(() => PaymentMethodScreen());
                  },
                  child: Text('Proceed'),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
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
