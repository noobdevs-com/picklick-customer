import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:picklick_customer/constants/constants.dart';
import 'package:picklick_customer/constants/valueConstants.dart';
import 'package:picklick_customer/screens/App/loading.dart';

class BucketBriyani extends StatefulWidget {
  const BucketBriyani({Key? key}) : super(key: key);

  @override
  _BucketBriyaniState createState() => _BucketBriyaniState();
}

class _BucketBriyaniState extends State<BucketBriyani> {
  String bucket = 'PickLick Mini Bucket  (2 Adults)';
  int price = 199;
  TextEditingController descriptionController = TextEditingController();
  String customerName = '';
  String customerAddress = '';
  int miniBucket = 0;
  int familyBucket = 0;
  int mediumBucket = 0;
  int largeBucket = 0;

  @override
  void initState() {
    super.initState();
    getFirebaseUserData();
    getFirebaseBucketData();
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
      });
    });
  }

  int getPrice(int price) {
    bucket == 'PickLick Mini Bucket  (2 Adults)'
        ? price = miniBucket
        : bucket == 'PickLick Family Bucket  (2 Adults & 2 Kids)'
            ? price = familyBucket
            : bucket == 'PickLick Medium Bucket (6 Adults)'
                ? price = mediumBucket
                : bucket == 'PickLick Large Bucket (8 Adults)'
                    ? price = largeBucket
                    : price = 0;
    price = price;
    return price;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('bucketOrder')
              .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
              .snapshots(),
          builder: (_, AsyncSnapshot<QuerySnapshot> sp) {
            if (!sp.hasData) return Loading();
            final data = sp.data!.docs;
            if (data.isNotEmpty) {
              return Center(
                child: Text(
                  'Only One Order Allowed Per User, Order Again Next Week.',
                  textAlign: TextAlign.justify,
                ),
              );
            }

            return SingleChildScrollView(
              child: Center(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height - 200,
                  width: MediaQuery.of(context).size.width - 30,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        'Book Your Favourite PickLick Special Bucket Briyani',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                        textAlign: TextAlign.justify,
                      ),
                      DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                              border: KTFFocusedBorderStyle,
                              fillColor: Colors.white60,
                              filled: true),
                          value: bucket,
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
                      Card(
                        color: Colors.white70,
                        elevation: 0,
                        child: ListTile(
                          title: Text('Price :'),
                          subtitle: Text(bucket ==
                                  'PickLick Mini Bucket  (2 Adults)'
                              ? ' ₹ ${miniBucket.toString()}'
                              : bucket ==
                                      'PickLick Family Bucket  (2 Adults & 2 Kids)'
                                  ? ' ₹ ${familyBucket.toString()}'
                                  : bucket ==
                                          'PickLick Medium Bucket (6 Adults)'
                                      ? ' ₹ ${mediumBucket.toString()}'
                                      : bucket ==
                                              'PickLick Large Bucket (8 Adults)'
                                          ? ' ₹ ${largeBucket.toString()}'
                                          : ''),
                        ),
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
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 4, 8, 0),
                        child: Text(
                          'Note : The Ordered Bucket Will be Delivered The Upcoming Sunday During 11 AM - 2 PM . For Further Queries Contact Us.',
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Get.defaultDialog(
                            title: bucket,
                            middleText: descriptionController.text,
                            onConfirm: () async {
                              final user = FirebaseAuth.instance.currentUser!;
                              await FirebaseFirestore.instance
                                  .collection('bucketOrder')
                                  .doc(user.uid)
                                  .set({
                                'uid': user.uid,
                                'bucket': bucket,
                                'price': price,
                                'discription': descriptionController.text,
                                'orderedAt': Timestamp.fromDate(DateTime.now()),
                                'orderStatus': OrderStatus.pending.toString(),
                                'customerName': customerName,
                                'customerAddress': customerAddress,
                                'customerPhoneNumber': user.phoneNumber,
                              }, SetOptions(merge: true)).whenComplete(() {
                                Navigator.pop(context);
                                Get.snackbar('Bucket Order Has Been Booked',
                                    'You will Be Delivered on Sunday Afternoon');
                                descriptionController.clear();
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
