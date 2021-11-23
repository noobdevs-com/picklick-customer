import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'package:picklick_customer/screens/App/home.dart';

import 'package:picklick_customer/services/fcm_notification.dart';

import 'package:pin_input_text_field/pin_input_text_field.dart';

import 'fillUserDetails.dart';

class OTPScreen extends StatefulWidget {
  final String number;
  final String verificationId;
  final int? resendToken;

  OTPScreen(
      {required this.number,
      required this.verificationId,
      required this.resendToken});

  @override
  _OTPScreenState createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final otpController = TextEditingController();
  FCMNotification fcmNotification = FCMNotification();
  GetStorage getStorage = GetStorage();
  FirebaseAuth auth = FirebaseAuth.instance;
  bool loading = false;
  int? resendToken;
  late String _verificationId;
  int startTime = 30;

  @override
  void initState() {
    super.initState();
    _verificationId = widget.verificationId;
    resendToken = widget.resendToken;
    startTimer();
  }

  Future<void> reSendOtp() async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: '+91${widget.number}',
      verificationCompleted: (PhoneAuthCredential credential) async {
        final user = await auth.signInWithCredential(credential);

        final userList = await FirebaseFirestore.instance
            .collection('userAddressBook')
            .where('uid', isEqualTo: user.user!.uid)
            .get();

        userList.docs.length > 0
            ? Get.offAll(() => Home())
            : Get.offAll(() => UserDetails());

        getStorage.hasData('deviceToken')
            ? await FirebaseFirestore.instance
                .collection('userAddressBook')
                .doc(FirebaseAuth.instance.currentUser!.uid)
                .set({'notificationToken': getStorage.read('deviceToken')},
                    SetOptions(merge: true))
            : fcmNotification.updateDeviceToken();
        print('Notification Token : ${getStorage.hasData('deviceToken')}');

        Get.snackbar('OTP Verified Succesfully',
            'Your OTP Has Been Verified Automatically !');
      },
      verificationFailed: (FirebaseAuthException e) {
        if (e.code == 'invalid-phone-number') {
          print('The provided phone number is not valid.');
          Get.snackbar(
              'Invalid Number', 'Please Check the number you have entered');
        }
      },
      codeSent: (String vId, int? rtoken) async {
        resendToken = rtoken;
        print('Code has been sent');
        Get.snackbar('OTP Sent', 'OTP has been sent to you mobile number');
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
      forceResendingToken: resendToken,
    );
  }

  Future<void> verifyOtp() async {
    try {
      // Update the UI - wait for the user to enter the SMS code

      // Create a PhoneAuthCredential with the code
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: _verificationId, smsCode: otpController.text);

      // Sign the user in (or link) with the credential

      UserCredential user = await auth.signInWithCredential(credential);
      print("verifyCode: " + user.toString());

      //  Check if user exist
      final userList = await FirebaseFirestore.instance
          .collection('userAddressBook')
          .where('uid', isEqualTo: user.user!.uid)
          .get();

      getStorage.hasData('deviceToken')
          ? await FirebaseFirestore.instance
              .collection('userAddressBook')
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .set({'notificationToken': getStorage.read('deviceToken')},
                  SetOptions(merge: true))
          : fcmNotification.updateDeviceToken();

      userList.docs.length > 0
          ? Get.offAll(() => Home())
          : Get.offAll(() => UserDetails());

      setState(() {
        loading = false;
      });
    } on FirebaseAuthException catch (e) {
      print(e);
      setState(() {
        loading = false;
      });
      Get.snackbar('Try Again', 'The Entered Code is invalid');
    }
  }

  late Timer _timer;

  void startTimer() {
    const onesec = Duration(seconds: 1);
    _timer = Timer.periodic(onesec, (timer) {
      if (startTime == 0) {
        setState(() {
          timer.cancel();
        });
      } else {
        setState(() {
          startTime--;
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(),
        body: SingleChildScrollView(
          child: Column(
            children: [
              loading == true
                  ? Container(
                      height: 5,
                      child: LinearProgressIndicator(
                        backgroundColor: Colors.white,
                        color: Color(0xFFCFB840),
                      ),
                    )
                  : Container(
                      height: 5,
                    ),
              SizedBox(
                height: 500,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text('OTP Has Been Sent To',
                            style: TextStyle(fontSize: 25)),
                        SizedBox(
                          height: 20,
                        ),
                        Text('+91  ${widget.number}',
                            style: TextStyle(fontSize: 20))
                      ],
                    ),
                    Text('Please Enter The 6 - Digit Code Sent To Your Number',
                        style: TextStyle(fontSize: 16),
                        textAlign: TextAlign.center),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 50),
                      child: PinInputTextField(
                        cursor: Cursor(color: Colors.black),
                        decoration: BoxLooseDecoration(
                            bgColorBuilder: FixedColorBuilder(Colors.white24),
                            strokeColorBuilder:
                                FixedColorBuilder(Color(0xFFCFB840))),
                        pinLength: 6,
                        controller: otpController,
                        textInputAction: TextInputAction.go,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    ElevatedButton(
                      child: Text(
                        'Verify Otp',
                        style: TextStyle(fontSize: 18),
                      ),
                      style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                              horizontal: 50, vertical: 15),
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(18)))),
                      onPressed: () async {
                        verifyOtp();
                        setState(() {
                          loading = true;
                        });
                      },
                    ),
                    RichText(
                        text: TextSpan(children: [
                      TextSpan(
                          text: ' Resend OTP ',
                          style: TextStyle(color: Colors.black, fontSize: 16)),
                      TextSpan(
                          text: ' 00:$startTime ',
                          style: TextStyle(color: Colors.red, fontSize: 16)),
                      TextSpan(
                          text: ' seconds ',
                          style: TextStyle(color: Colors.black, fontSize: 16)),
                    ])),
                    startTime == 0
                        ? TextButton.icon(
                            onPressed: () {
                              reSendOtp();
                              if (mounted)
                                setState(() {
                                  startTime = 30;
                                });
                              startTimer();
                              print(widget.verificationId);
                            },
                            icon: Icon(
                              Icons.restore,
                              color: Colors.red,
                            ),
                            label: Text(
                              'Resend OTP',
                              style: TextStyle(color: Colors.red),
                            ),
                          )
                        : Container(
                            height: 5,
                          )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
