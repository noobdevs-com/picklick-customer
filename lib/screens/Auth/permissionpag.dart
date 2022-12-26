// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:picklick_customer/screens/App/home.dart';

class PermissionPage extends StatefulWidget {
  const PermissionPage({Key? key}) : super(key: key);

  @override
  _PermissionPageState createState() => _PermissionPageState();
}

class _PermissionPageState extends State<PermissionPage>
    with SingleTickerProviderStateMixin {
  FirebaseAuth auth = FirebaseAuth.instance;
  late AnimationController animationCon;
  late Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Column(children: [
            SizedBox(
              height: 20,
            ),
            Flexible(
              child: Image.asset(
                'assets/logo.png',
              ),
            ),
            Flexible(
              child: Padding(
                padding: EdgeInsets.only(top: 10, left: 30, right: 30),
                child: RichText(
                    text: TextSpan(children: [
                  TextSpan(
                    text: 'OK!',
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFFCFB840)),
                  ),
                  TextSpan(
                    text: ' We Need Some Access',
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                        color: Colors.black),
                  ),
                ])),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Flexible(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 60, vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(Icons.location_pin),
                    SizedBox(
                      width: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Location',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black)),
                        SizedBox(height: 10),
                        Text(
                            'We need your location to give\nyou a better experince',
                            style:
                                TextStyle(fontSize: 14, color: Colors.black)),
                      ],
                    )
                  ],
                ),
              ),
            ),
            Flexible(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 30, horizontal: 60),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(Icons.call),
                    SizedBox(
                      width: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Call',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black)),
                        SizedBox(height: 10),
                        Text(
                            'We need your call information to\nserve you better',
                            style:
                                TextStyle(fontSize: 14, color: Colors.black)),
                      ],
                    )
                  ],
                ),
              ),
            ),
            SizedBox(height: 10),
            Flexible(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 40),
                child: TextButton(
                  onPressed: () async {
                    final permissions = await getPermission();
                    if (permissions) {
                      await Geolocator.getCurrentPosition();

                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => Home()),
                          (route) => false);
                    }
                  },
                  child: Text(
                    'Continue',
                    style: TextStyle(fontSize: 24),
                  ),
                  style: ElevatedButton.styleFrom(
                      primary: Color(0xFFCFB840),
                      onPrimary: Colors.white,
                      minimumSize: Size(double.infinity, 60),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15))),
                ),
              ),
            ),
            Flexible(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 40),
                child: TextButton(
                  onPressed: () {
                    Get.defaultDialog(
                        cancelTextColor: Colors.black45,
                        confirmTextColor: Color.fromRGBO(255, 255, 255, 1),
                        buttonColor: Color(0xFFCFB840),
                        title: 'Exit Application',
                        middleText: 'Do you want to exit the app ?',
                        textCancel: 'No',
                        textConfirm: 'Yes',
                        onConfirm: () {
                          SystemNavigator.pop();
                        });
                  },
                  child: Text(
                    'Dismiss',
                    style: TextStyle(fontSize: 18),
                  ),
                  style: ElevatedButton.styleFrom(
                      onPrimary: Colors.black26,
                      minimumSize: Size(double.infinity, 60),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15))),
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }

  getPermission() async {
    PermissionStatus status = await Permission.location.request();

    print(status.toString());

    if (status.isGranted) {
      return true;
    } else if (status.isDenied || status.isPermanentlyDenied) {
      Fluttertoast.showToast(
        msg: "Unable to load app: Location access denied",
      );
      return false;
    }
  }
}
