import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:picklick_customer/screens/App/accountScreen.dart';
import 'package:picklick_customer/screens/App/bucketOrder.dart';
import 'package:picklick_customer/screens/App/loading.dart';
import 'package:picklick_customer/screens/App/orderScreen.dart';
import 'package:picklick_customer/screens/Auth/authenticationWrapper.dart';
import 'package:picklick_customer/services/urlLauncher.dart';

class MenuDrawer extends StatelessWidget {
  final urlL = URLLauncher();

  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            curve: Curves.fastLinearToSlowEaseIn,
            duration: Duration(seconds: 1),
            decoration: BoxDecoration(
              color: Color(0xFFCFB840),
            ),
            child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('userAddressBook')
                    .where('uid',
                        isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasData) {
                    var data = snapshot.data!.docs;
                    return Padding(
                      padding: const EdgeInsets.only(left: 5),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 30,
                                backgroundColor:
                                    Colors.transparent.withOpacity(0.1),
                                backgroundImage:
                                    AssetImage('assets/logoIn.png'),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width,
                                child: Text(
                                  '${data[0]['name']}',
                                  style:
                                      TextStyle(fontSize: 22, letterSpacing: 1),
                                  textAlign: TextAlign.justify,
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  Text(
                                    FirebaseAuth
                                        .instance.currentUser!.phoneNumber
                                        .toString(),
                                    style: TextStyle(
                                        fontSize: 17,
                                        fontStyle: FontStyle.italic,
                                        letterSpacing: 1),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ],
                      ),
                    );
                  }
                  return Loading();
                }),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
                ListTile(
                  title: Text('My Account'),
                  trailing: Icon(Icons.person),
                  onTap: () {
                    Get.to(() => MyAccount());
                  },
                ),
                ListTile(
                  title: Text('My Orders'),
                  trailing: Icon(Icons.book),
                  onTap: () {
                    Get.to(() => OrderScreen());
                  },
                ),
                ListTile(
                  title: Text('Bucket Order'),
                  trailing: Icon(Icons.food_bank_outlined),
                  onTap: () {
                    Get.to(() => BucketOrder());
                  },
                ),
                ListTile(
                  title: Text('Contact & Support'),
                  trailing: Icon(Icons.phone),
                  onTap: () {
                    urlL.openwhatsapp();
                  },
                ),
              ],
            ),
          ),
          Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: ListTile(
              title: Text('Log Out'),
              trailing: Icon(Icons.logout),
              onTap: () {
                Get.defaultDialog(
                    cancelTextColor: Colors.black45,
                    confirmTextColor: Colors.white,
                    buttonColor: Color(0xFFCFB840),
                    title: 'Log Out',
                    middleText: 'Do You Want To Log Out This Account',
                    textCancel: 'No',
                    textConfirm: 'Yes',
                    onConfirm: () async {
                      await FirebaseAuth.instance.signOut();
                      Get.offAll(() => AuthenticationWrapper());
                    });
              },
            ),
          ),
          SizedBox(
            height: 10,
          )
        ],
      ),
    );
  }
}
