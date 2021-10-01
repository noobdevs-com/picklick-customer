import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:picklick_customer/constants/constants.dart';
import 'package:picklick_customer/controllers/cart.dart';
import 'package:picklick_customer/controllers/hotel.dart';

import 'package:picklick_customer/screens/App/home.dart';

class PaymentMethodScreen extends StatefulWidget {
  const PaymentMethodScreen({Key? key, required this.restaurantName})
      : super(key: key);
  final String restaurantName;

  @override
  _PaymentMethodScreenState createState() => _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends State<PaymentMethodScreen> {
  void initState() {
    super.initState();
    // getlocation();
    getFirebaseUserData();
  }

  // late Position _currentPosition;
  String customerName = '';
  String customerAddress = '';

  // Future<Position?> getlocation() async {
  //   Position position = await Geolocator.getCurrentPosition(
  //       desiredAccuracy: LocationAccuracy.high);

  //   _currentPosition = position;

  //   return position;
  // }

  final ref = FirebaseFirestore.instance
      .collection('userAddressBook')
      .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
      .get();

  getFirebaseUserData() {
    FirebaseFirestore.instance
        .collection('userAddressBook')
        .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) {
      var data = value.docs[0].data();
      setState(() {
        customerName = data['name'];
        customerAddress = data['address'];
      });
    });
  }

  final CartController _cartController = Get.find();
  final HotelController _hotelController = Get.find();
  PaymentMethod? _method = PaymentMethod.CASH_ON_DELIVERY;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment Method'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          RadioListTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('COD (Cash On Delivery)'),
                Image.asset('assets/money_3.png')
              ],
            ),
            value: PaymentMethod.CASH_ON_DELIVERY,
            groupValue: _method,
            onChanged: (PaymentMethod? value) {
              setState(() {
                _method = value;
              });
            },
          ),
          RadioListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Google Pay'),
                  Text(
                    'Availble Soon',
                    style: TextStyle(fontStyle: FontStyle.italic),
                  )
                ],
              ),
              value: PaymentMethod.GOOGLE_PAY,
              groupValue: _method,
              onChanged: null

              // (PaymentMethod? value) {
              //   setState(() {
              //     _method = value;
              //   });
              // },
              ),
          RadioListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Pay TM'),
                  Text(
                    'Availble Soon',
                    style: TextStyle(fontStyle: FontStyle.italic),
                  )
                ],
              ),
              value: PaymentMethod.PAY_TM,
              groupValue: _method,
              onChanged: null

              // (PaymentMethod? value) {
              //   setState(() {
              //     _method = value;
              //   });
              // },
              ),
          ListTile(
            title: Text(
                'Total Price :  ₹ ${_cartController.price.value} + Delivery Charge'),
            subtitle: Text('Delivery Charge : ₹ 7 per km'),
          )
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: ElevatedButton(
          onPressed: () async {
            final user = FirebaseAuth.instance.currentUser!;
            List dishes = _cartController.cart
                .map((element) => element.converToJson())
                .toList();
            dishes.addAll(_cartController.offerCart
                .map((element) => element.converToJson())
                .toList());

            Get.defaultDialog(
                title: 'Place Order',
                middleText: 'Do you want to confirm the order ?',
                textCancel: 'No',
                textConfirm: 'Yes',
                onConfirm: () async {
                  try {
                    await FirebaseFirestore.instance.collection('orders').add({
                      'dishes': dishes,
                      'orderStatus': OrderStatus.pending.toString(),
                      'orderedAt': Timestamp.fromDate(DateTime.now()),
                      'paymentMethod': _method.toString(),
                      'price': _cartController.price.value,
                      'quantity': _cartController.cart.length +
                          _cartController.offerCart.length,
                      'uid': user.uid,
                      'restaurantName': widget.restaurantName,
                      'customerName': customerName,
                      'customerAddress': customerAddress,
                      'customerPhoneNumber': user.phoneNumber,
                      'PLpriceTotal': _cartController.price.value -
                          (_cartController.price.value / 100 * 10)
                      // 'coordinates': [
                      //   _currentPosition.longitude,
                      //   _currentPosition.latitude
                      // ]
                    }).whenComplete(() {
                      setState(() {
                        _cartController.cart.clear();
                        _cartController.offerCart.clear();
                        _cartController.price.value = 0;
                        Get.defaultDialog(
                            title: 'Successful',
                            middleText:
                                'Your Order Has Been Placed Successfully!',
                            onConfirm: () {
                              Get.off(() => Home());
                            });
                      });
                    });
                  } catch (e) {
                    print(e);
                  }
                });
          },
          child: Text('Checkout'),
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
          ),
        ),
      ),
    );
  }
}
