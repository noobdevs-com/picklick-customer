import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:picklick_customer/screens/App/accountScreen.dart';
import 'package:picklick_customer/screens/App/orderScreen.dart';
import 'package:picklick_customer/screens/Auth/authenticationWrapper.dart';

class MenuDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            height: 120,
            child: DrawerHeader(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Color(0xFFF0EBCC),
              ),
              child: Column(
                children: [
                  FirebaseAuth.instance.currentUser!.displayName == null
                      ? Text(
                          'User',
                          style: TextStyle(fontSize: 18),
                        )
                      : Text(
                          FirebaseAuth.instance.currentUser!.displayName
                              .toString(),
                          style: TextStyle(fontSize: 18),
                        ),
                  Text(
                    FirebaseAuth.instance.currentUser!.phoneNumber.toString(),
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
            ),
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
            title: Text('Log Out'),
            trailing: Icon(Icons.logout),
            onTap: () async {
              await FirebaseAuth.instance.signOut();
              Get.to(() => AuthenticationWrapper());
            },
          )
        ],
      ),
    );
  }
}
