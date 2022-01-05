import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:picklick_customer/screens/App/accountScreen.dart';
import 'package:picklick_customer/screens/App/bucketOrder.dart';

import 'package:picklick_customer/screens/App/loading.dart';
import 'package:picklick_customer/screens/App/orderScreen.dart';
import 'package:picklick_customer/screens/App/test.dart';
import 'package:picklick_customer/screens/Auth/authenticationWrapper.dart';
import 'package:url_launcher/url_launcher.dart';

class MenuDrawer extends StatelessWidget {
  openwhatsapp() async {
    var whatsapp = "+918300044575";
    var whatsappURl_android = "whatsapp://send?phone=$whatsapp&text=";
    try {
      launch(whatsappURl_android);
    } catch (e) {
      Get.snackbar('Error', 'e');
    }
  }

  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            curve: Curves.fastLinearToSlowEaseIn,
            duration: Duration(seconds: 1),
            decoration: BoxDecoration(
              color: Color(0xFFF0EBCC),
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
                    return Column(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width,
                          child: Text(
                            '${data[0]['name']} ,',
                            style: TextStyle(fontSize: 22, letterSpacing: 1),
                            textAlign: TextAlign.justify,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: [
                            Text(
                              FirebaseAuth.instance.currentUser!.phoneNumber
                                  .toString(),
                              style: TextStyle(
                                  fontSize: 17,
                                  fontStyle: FontStyle.italic,
                                  letterSpacing: 1),
                            ),
                          ],
                        )
                      ],
                    );
                  }
                  return Loading();
                }),
          ),
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
              openwhatsapp();
            },
          ),
          ListTile(
            title: Text('Log Out'),
            trailing: Icon(Icons.logout),
            onTap: () {
              Get.defaultDialog(
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
        ],
      ),
    );
  }
}
