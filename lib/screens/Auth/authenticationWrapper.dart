import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:picklick_customer/screens/App/home.dart';
import 'package:picklick_customer/screens/Auth/otpVerify.dart' as OTP;
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:picklick_customer/services/fcm_notification.dart';

import 'fillUserDetails.dart';

class AuthenticationWrapper extends StatefulWidget {
  @override
  _AuthenticationWrapperState createState() => _AuthenticationWrapperState();
}

class _AuthenticationWrapperState extends State<AuthenticationWrapper> {
  FirebaseAuth auth = FirebaseAuth.instance;
  FCMNotification fcmNotification = FCMNotification();
  GetStorage getStorage = GetStorage();
  final phonenumberController = TextEditingController();
  late String verificationId;
  int? resendToken;
  bool loading = false;

  Future<void> sendOtp() async {
    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: '+91${phonenumberController.text}',
        verificationCompleted: (PhoneAuthCredential credential) async {
          print(getStorage.read('deviceToken'));
          // ANDROID ONLY!

          // Sign the user in (or link) with the auto-generated credential
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

          Get.snackbar('OTP Verified Succesfully',
              'Your OTP Has Been Verified Automatically !');
        },
        verificationFailed: (FirebaseAuthException e) {
          Get.snackbar('Error', "Exception" + e.message!.toString());
          if (e.code == 'invalid-phone-number') {
            Get.snackbar(
                'Invalid Number', 'The provided phone number is not valid.');
          }
          setState(() {
            loading = false;
          });

          // Handle other errors
        },
        codeSent: (String vId, int? rToken) async {
          setState(() {
            loading = false;
          });
          verificationId = vId;
          resendToken = rToken;

          Get.snackbar('OTP Sent', 'OTP has been sent to you mobile number.');
          Get.to(() => OTP.OTPScreen(
                number: phonenumberController.text,
                verificationId: verificationId,
                resendToken: resendToken,
              ));
          print(verificationId);
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
        forceResendingToken: resendToken);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  SizedBox(
                    height: 60,
                  ),
                  Text(
                    'Enter Your Phone',
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        wordSpacing: 2.5,
                        letterSpacing: 0.5),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'We will send you a One Time Password to\nthe mobile number',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  IntlPhoneField(
                    dropdownIcon: Icon(
                      Icons.arrow_drop_down,
                      color: Color(0xFFCFB840),
                    ),
                    controller: phonenumberController,
                    decoration: InputDecoration(
                      labelText: 'Phone Number',
                      labelStyle: TextStyle(color: Colors.black),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFFCFB840)),
                      ),
                    ),
                    initialCountryCode: 'IN',
                    onChanged: (phone) {
                      print(phone.completeNumber);
                    },
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  SizedBox(
                    height: 48,
                    width: 292,
                    child: ElevatedButton(
                      onPressed: loading
                          ? null
                          : () {
                              sendOtp();
                              setState(() {
                                loading = true;
                              });
                            },
                      child: Text(
                        'Continue',
                      ),
                      style: ElevatedButton.styleFrom(
                          primary: Colors.redAccent[400],
                          onPrimary: Colors.white,
                          minimumSize: Size(double.infinity, 60),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15))),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
