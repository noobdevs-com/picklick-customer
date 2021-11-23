import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:picklick_customer/constants/constants.dart';
import 'package:picklick_customer/constants/valueConstants.dart';
import 'package:picklick_customer/screens/App/loading.dart';
import 'package:picklick_customer/services/fcm_notification.dart';
import 'package:lottie/lottie.dart';

class BucketBriyani extends StatefulWidget {
  const BucketBriyani({Key? key}) : super(key: key);

  @override
  _BucketBriyaniState createState() => _BucketBriyaniState();
}

class _BucketBriyaniState extends State<BucketBriyani>
    with TickerProviderStateMixin {
  String bucket = 'PickLick Mini Bucket  (2 Adults)';
  late int price;
  TextEditingController descriptionController = TextEditingController();
  String? customerName;
  String? customerAddress;
  String? discription;
  int miniBucket = 0;
  int familyBucket = 0;
  int mediumBucket = 0;
  int largeBucket = 0;
  int offer = 1;
  String? img;
  bool visible = true;
  final fCMNotification = FCMNotification();
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    getFirebaseUserData();
    getFirebaseBucketData();
    getAdminToken();

    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

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

  getFirebaseBucketData() {
    FirebaseFirestore.instance
        .collection('bucketPrice')
        .doc('1908mzw8UuOX8kvLDR3e')
        .get()
        .then((value) {
      var data = value.data()!;
      setState(() {
        miniBucket = data['miniBucket'];
        familyBucket = data['familyBucket'];
        mediumBucket = data['mediumBucket'];
        largeBucket = data['largeBucket'];
        discription = data['discription'] ?? '';
        offer = data['offer'];
        img = data['posterImg'];
        visible = data['visible'];
      });
    });
  }

  getPrice() {
    setState(() {
      bucket == 'PickLick Mini Bucket  (2 Adults)'
          ? price = miniBucket
          : bucket == 'PickLick Family Bucket  (2 Adults & 2 Kids)'
              ? price = familyBucket
              : bucket == 'PickLick Medium Bucket (6 Adults)'
                  ? price = mediumBucket
                  : bucket == 'PickLick Large Bucket (8 Adults)'
                      ? price = largeBucket
                      : price = 0;
    });
  }

  List<String> adminToken = [];

  Future<void> getAdminToken() async {
    await FirebaseFirestore.instance
        .collection('adminBook')
        .get()
        .then((value) {
      final data = value.docs.map<String>((e) => e['notificationToken']);
      adminToken = data.toList();

      print(adminToken);
    });
  }

  @override
  Widget build(BuildContext context) {
    getPrice();
    return Scaffold(
      body: !visible == true
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width - 100,
                    child: Text(
                      'Sorry For the inconvience, We are currently not accepting orders',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width - 100,
                    child: Text(
                      discription!,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.red),
                    ))
              ],
            )
          : StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('bucketOrder')
                  .where('uid',
                      isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                  .snapshots(),
              builder: (_, AsyncSnapshot<QuerySnapshot> sp) {
                if (!sp.hasData) return Loading();
                final data = sp.data!.docs;
                if (data.isNotEmpty) {
                  return Center(
                    child: Text(
                      'Only One Order Allowed Per User, For More Orders Please Contact us.',
                      textAlign: TextAlign.justify,
                    ),
                  );
                }

                return SingleChildScrollView(
                  child: Center(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width - 25,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          FadeInImage.assetNetwork(
                            placeholder: 'assets/logo.png',
                            image: img!,
                            fit: BoxFit.fill,
                            height: 200,
                            width: MediaQuery.of(context).size.width - 30,
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          DropdownButtonFormField<String>(
                              decoration: InputDecoration(
                                  border: KTFFocusedBorderStyle,
                                  fillColor: Colors.white60,
                                  filled: true),
                              value: bucket,
                              isExpanded: true,
                              onChanged: (value) {
                                setState(() {
                                  bucket = value!;
                                });
                              },
                              elevation: 16,
                              items: <String>[
                                'PickLick Mini Bucket  (2 Adults)',
                                'PickLick Family Bucket  (2 Adults & 2 Kids)',
                                'PickLick Medium Bucket (6 Adults)',
                                'PickLick Large Bucket (8 Adults)'
                              ]
                                  .map<DropdownMenuItem<String>>(
                                      (value) => DropdownMenuItem(
                                            value: value,
                                            child: Text(value),
                                          ))
                                  .toList()),
                          SizedBox(
                            height: 25,
                          ),
                          Card(
                            color: Colors.white70,
                            elevation: 0,
                            child: ListTile(
                              title: Text('Price :'),
                              subtitle: Text('₹ $price'),
                            ),
                          ),
                          discription != ''
                              ? Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(8, 4, 8, 0),
                                  child: Text('* $discription',
                                      style: TextStyle(
                                          color: Colors.green, fontSize: 12),
                                      textAlign: TextAlign.justify),
                                )
                              : SizedBox(
                                  height: 0,
                                ),
                          SizedBox(
                            height: 25,
                          ),
                          TextFormField(
                            maxLines: null,
                            keyboardType: TextInputType.text,
                            controller: descriptionController,
                            decoration: InputDecoration(
                                labelStyle: TextStyle(color: Colors.black),
                                focusedBorder: KTFFocusedBorderStyle,
                                labelText: 'Description :',
                                hintText: 'Add Notes for Delivery',
                                border: KTFBorderStyle,
                                fillColor: Colors.white60,
                                filled: true),
                          ),
                          SizedBox(
                            height: 25,
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(8, 4, 8, 0),
                            child: Text(
                              'Note : The Ordered Bucket Will be Delivered on the anounced dates. For Further Queries Contact Us.',
                            ),
                          ),
                          SizedBox(
                            height: 25,
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Get.defaultDialog(
                                title: bucket,
                                middleText: descriptionController.text,
                                onConfirm: () async {
                                  Navigator.of(context).pop();
                                  final user =
                                      FirebaseAuth.instance.currentUser!;
                                  await FirebaseFirestore.instance
                                      .collection('bucketOrder')
                                      .doc(user.uid)
                                      .set({
                                    'uid': user.uid,
                                    'bucket': bucket,
                                    'price':
                                        (price - (price / 100 * offer)).round(),
                                    'discription': descriptionController.text,
                                    'orderedAt':
                                        Timestamp.fromDate(DateTime.now()),
                                    'orderStatus':
                                        OrderStatus.pending.toString(),
                                    'customerName': customerName,
                                    'customerAddress': customerAddress,
                                    'customerPhoneNumber': user.phoneNumber,
                                  }, SetOptions(merge: true)).whenComplete(() {
                                    Get.bottomSheet(
                                      Lottie.asset(
                                          'assets/confirmAnimation.json',
                                          fit: BoxFit.fill,
                                          controller: _controller,
                                          onLoaded: (comp) {
                                        _controller.duration = comp.duration;
                                        _controller.forward().whenComplete(() {
                                          _controller.reverse();
                                          Navigator.of(context).pop();
                                        });
                                      }),
                                    );
                                    adminToken.forEach((e) =>
                                        fCMNotification.createOrderNotification(
                                            e,
                                            'Incoming Order',
                                            'You have a pending order from a customer !'));
                                  });
                                },
                                textConfirm: 'Confirm Order',
                              );
                            },
                            child: Text('Place Order'),
                            style: kElevatedButtonStyle,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
    );
  }
}
