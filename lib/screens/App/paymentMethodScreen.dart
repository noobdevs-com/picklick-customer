import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:picklick_customer/constants/constants.dart';
import 'package:picklick_customer/controllers/cart.dart';
import 'package:picklick_customer/models/dish.dart';

class PaymentMethodScreen extends StatefulWidget {
  const PaymentMethodScreen({Key? key}) : super(key: key);

  @override
  _PaymentMethodScreenState createState() => _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends State<PaymentMethodScreen> {
  final CartController _cartController = Get.find();
  PaymentMethod? _method = PaymentMethod.CASH_ON_DELIVERY;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Text('Payment Method'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          RadioListTile(
            title: Text('COD (Cash On Delivery)'),
            value: PaymentMethod.CASH_ON_DELIVERY,
            groupValue: _method,
            onChanged: (PaymentMethod? value) {
              setState(() {
                _method = value;
              });
            },
          ),
          RadioListTile(
            title: Text('Google Pay'),
            value: PaymentMethod.GOOGLE_PAY,
            groupValue: _method,
            onChanged: (PaymentMethod? value) {
              setState(() {
                _method = value;
              });
            },
          ),
          RadioListTile(
            title: Text('Pay TM'),
            value: PaymentMethod.PAY_TM,
            groupValue: _method,
            onChanged: (PaymentMethod? value) {
              setState(() {
                _method = value;
              });
            },
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Expanded(
          flex: 1,
          child: ElevatedButton(
            onPressed: () async {
              print(_cartController.getCartItems());
              await FirebaseFirestore.instance
                  .collection('orders')
                  .add({'dishes': _cartController.cart});
            },
            child: Text('Checkout'),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
            ),
          ),
        ),
      ),
    ));
  }
}
