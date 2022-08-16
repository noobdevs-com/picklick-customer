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
        Get.rawSnackbar(message: 'OTP has been sent to you mobile number');
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
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xFFF0EBCC),
        elevation: 2,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            SizedBox(
              height: 40,
            ),
            Text('Verify OTP',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    wordSpacing: 2.5,
                    letterSpacing: 0.5)),
            SizedBox(
              height: 20,
            ),
            Text('Please Enter The 6 - Digit Code',
                style: TextStyle(color: Colors.grey),
                textAlign: TextAlign.center),
            SizedBox(
              height: 28,
            ),
            PinInputTextField(
              // decoration: BoxLooseDecoration(
              //     bgColorBuilder: FixedColorBuilder(Colors.white24),
              //     strokeColorBuilder: FixedColorBuilder(Color(0xFFCFB840))),
              decoration: BoxLooseDecoration(
                  strokeColorBuilder:
                      PinListenColorBuilder(Color(0xFFCFB840), Colors.grey)),
              pinLength: 6,
              controller: otpController,
              textInputAction: TextInputAction.go,
              keyboardType: TextInputType.number,
            ),
            SizedBox(
              height: 12,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  '00:$startTime',
                  style: TextStyle(color: Colors.grey, letterSpacing: 2),
                ),
              ],
            ),
            SizedBox(
              height: 28,
            ),
            SizedBox(
              height: 48,
              width: 292,
              child: ElevatedButton(
                onPressed: loading
                    ? null
                    : () async {
                        verifyOtp();
                        setState(() {
                          loading = true;
                        });
                      },
                child: Text(
                  'Verify Otp',
                ),
                style: ElevatedButton.styleFrom(
                    primary: Colors.redAccent[400],
                    onPrimary: Colors.white,
                    minimumSize: Size(double.infinity, 60),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15))),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Didn’t Recieve the OTP ? ',
                  style: TextStyle(color: Colors.grey),
                ),
                TextButton(
                    onPressed: startTime == 0
                        ? () {
                            reSendOtp();

                            startTime = 45;
                            startTimer();
                          }
                        : null,
                    child: Text(
                      'RESEND OTP',
                    ),
                    style: TextButton.styleFrom(primary: Colors.red)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
