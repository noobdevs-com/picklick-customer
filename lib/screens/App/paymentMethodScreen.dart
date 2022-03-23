import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:picklick_customer/constants/constants.dart';
import 'package:picklick_customer/controllers/cart.dart';
import 'package:picklick_customer/controllers/location.dart';
import 'package:picklick_customer/controllers/paymet.dart';
import 'package:picklick_customer/services/fcm_notification.dart';

class PaymentMethodScreen extends StatefulWidget {
  const PaymentMethodScreen(
      {Key? key, required this.restaurantName, required this.restaurantId})
      : super(key: key);
  final String restaurantName;
  final String restaurantId;

  @override
  _PaymentMethodScreenState createState() => _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends State<PaymentMethodScreen>
    with TickerProviderStateMixin {
  GeoPoint? geoPosition;
  void initState() {
    super.initState();
    // getlocation();
    getFirebaseUserData();
    getRestaurantToken();
    getAdminToken();

    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  // late Position _currentPosition;
  String customerName = '';
  String customerAddress = '';
  String restaurantToken = '';

  String userToken = '';
  List<String> adminToken = [];
  String authToken = '';
  String? networkImage;
  late final AnimationController _controller;
  final fCMNotification = FCMNotification();
  final locationController = Get.put(LocationController());
  final paymentController = Get.put(RazorPaymentGateway());

  Future<void> getRestaurantToken() async {
    await FirebaseFirestore.instance
        .collection('hotels')
        .where('ownerId', isEqualTo: widget.restaurantId)
        .get()
        .then((value) {
      var data = value.docs[0].data();
      setState(() {
        restaurantToken = data['notificationToken'];
        networkImage = data['img'];
        geoPosition = data['geoLocation'];
      });
    });
    locationController.getDistanceBtwUserAndRestaurant(geoPosition!);
  }

  Future<void> getAdminToken() async {
    await FirebaseFirestore.instance
        .collection('adminBook')
        .get()
        .then((value) {
      final data = value.docs.map<String>((e) => e['notificationToken']);
      adminToken = data.toList();
      adminToken.add(restaurantToken);
      print(adminToken);
    });
  }

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
        userToken = data['notificationToken'];
      });
    });
  }

  final CartController _cartController = Get.find();

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
            activeColor: Colors.green,
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
            activeColor: Colors.green,
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
            onChanged: null,
            // onChanged: (PaymentMethod? value) {
            //   setState(() {
            //     _method = value;
            //   });
            // },
          ),
          RadioListTile(
            activeColor: Colors.green,
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
            onChanged: null,
            // onChanged: (PaymentMethod? value) {
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
            if (_method == PaymentMethod.PAY_TM) {
              paymentController.proceedPayment(250.toString(), customerName,
                  FirebaseAuth.instance.currentUser!.phoneNumber.toString());
            }
            //             final user = FirebaseAuth.instance.currentUser!;
            // List dishes = _cartController.cart
            //     .map((element) => element.converToJson())
            //     .toList();
            // dishes.addAll(_cartController.offerCart
            //     .map((element) => element.converToJson())
            //     .toList());

            // Get.defaultDialog(
            //     cancelTextColor: Colors.black45,
            //     confirmTextColor: Colors.white,
            //     buttonColor: Color(0xFFCFB840),
            //     title: 'Place Order',
            //     middleText: 'Do you want to confirm the order ?',
            //     textCancel: 'No',
            //     textConfirm: 'Yes',
            //     onConfirm: () async {
            //       Navigator.of(context).pop();
            //       try {
            //         await FirebaseFirestore.instance.collection('orders').add({
            //           'dishes': dishes,
            //           'orderStatus': OrderStatus.pending.toString(),
            //           'orderedAt': Timestamp.fromDate(DateTime.now()),
            //           'paymentMethod': _method.toString(),
            //           'price': _cartController.price.value,
            //           'quantity': _cartController.cart.length +
            //               _cartController.offerCart.length,
            //           'uid': user.uid,
            //           'restaurantName': widget.restaurantName,
            //           'customerName': customerName,
            //           'customerAddress': customerAddress,
            //           'customerPhoneNumber': user.phoneNumber,
            //           'PLpriceTotal': _cartController.price.value -
            //               (_cartController.price.value / 100 * 10),
            //           'notificationToken': userToken,
            //           'restaurantId': widget.restaurantId,
            //           'restaurantImg': networkImage,
            //           // 'coordinates': [
            //           //   _currentPosition.longitude,
            //           //   _currentPosition.latitude
            //           // ]
            //           'location': GeoPoint(
            //               locationController.position!.latitude,
            //               locationController.position!.longitude),
            //         }).whenComplete(() async {
            //           await FirebaseFirestore.instance
            //               .collection('adminOrders')
            //               .add({
            //             'dishes': dishes,
            //             'orderStatus': OrderStatus.pending.toString(),
            //             'orderedAt': Timestamp.fromDate(DateTime.now()),
            //             'paymentMethod': _method.toString(),
            //             'price': _cartController.price.value,
            //             'quantity': _cartController.cart.length +
            //                 _cartController.offerCart.length,
            //             'uid': user.uid,
            //             'restaurantName': widget.restaurantName,
            //             'customerName': customerName,
            //             'customerAddress': customerAddress,
            //             'customerPhoneNumber': user.phoneNumber,
            //             'PLpriceTotal': _cartController.price.value -
            //                 (_cartController.price.value / 100 * 10),
            //             'notificationToken': userToken,
            //             'restaurantId': widget.restaurantId,
            //             'restaurantImg': networkImage
            //             // 'coordinates': [
            //             //   _currentPosition.longitude,
            //             //   _currentPosition.latitude
            //             // ]
            //           });
            //           adminToken.forEach((e) =>
            //               fCMNotification.createOrderNotification(
            //                   e,
            //                   'Incoming Order',
            //                   'You have a pending order from a customer !'));
            //           setState(() {
            //             _cartController.cart.clear();
            //             _cartController.offerCart.clear();
            //             _cartController.price.value = 0;
            //             Get.bottomSheet(
            //               Lottie.asset('assets/confirmAnimation.json',
            //                   fit: BoxFit.fill,
            //                   controller: _controller, onLoaded: (comp) {
            //                 _controller.duration = comp.duration;
            //                 _controller
            //                     .forward()
            //                     .whenComplete(() => Navigator.of(context).pop())
            //                     .then((value) => Get.offAll(() => Home()));
            //               }),
            //               backgroundColor: Color(0xFFF0EBCC),
            //             );
            //           });
            //         });
            //       } catch (e) {
            //         print(e);
            //       }
            //     });
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
