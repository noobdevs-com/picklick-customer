import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:picklick_customer/controllers/hotel.dart';
import 'package:picklick_customer/screens/App/cartScreen.dart';
import 'package:picklick_customer/screens/Auth/fillUserDetails.dart';
import 'package:picklick_customer/screens/App/home.dart';
import 'package:picklick_customer/screens/Auth/authenticationWrapper.dart';

class Wrapper extends StatelessWidget {
  Future checkStatus() async {
    await Future.delayed(Duration(seconds: 3));
    if (FirebaseAuth.instance.currentUser != null) {
      // signed in
      Get.to(() => Home());
    } else {
      Get.to(() => AuthenticationWrapper());
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
                  CupertinoActivityIndicator(
                    radius: 28,
                    animating: true,
                  ),
                ],
              ),
            ),
          );
        });
  }
}
