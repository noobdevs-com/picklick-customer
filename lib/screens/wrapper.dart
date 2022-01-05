import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'package:picklick_customer/screens/App/home.dart';

import 'package:picklick_customer/screens/Auth/authenticationWrapper.dart';
import 'package:picklick_customer/services/fcm_notification.dart';

class Wrapper extends StatefulWidget {
  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  GetStorage getStorage = GetStorage();

  FCMNotification fcmNotification = FCMNotification();

  updateNotificationToken(String uid) async {
    getStorage.hasData('deviceToken')
        ? await FirebaseFirestore.instance
            .collection('userAddressBook')
            .doc(uid)
            .set({'notificationToken': getStorage.read('deviceToken')},
                SetOptions(merge: true))
        : fcmNotification.updateDeviceToken();
  }

  Future checkStatus() async {
    await Future.delayed(Duration(seconds: 3));
    if (FirebaseAuth.instance.currentUser != null) {
      // signed in
      updateNotificationToken(FirebaseAuth.instance.currentUser!.uid);
      Get.off(() => Home());
    } else {
      Get.off(() => AuthenticationWrapper());
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: checkStatus(),
        builder: (_, s) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/logo.png',
                    height: 180,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  CupertinoActivityIndicator()
                ],
              ),
            ),
          );
        });
  }
}
