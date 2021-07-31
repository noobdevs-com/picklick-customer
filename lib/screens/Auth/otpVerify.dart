import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:picklick_customer/constants/valueConstants.dart';
import 'package:picklick_customer/screens/App/home.dart';
import 'package:picklick_customer/screens/Auth/fillUserDetails.dart';

import 'package:pin_input_text_field/pin_input_text_field.dart';

class OTPScreen extends StatefulWidget {
  final String number;
  final String verificationId;

  OTPScreen({required this.number, required this.verificationId});

  @override
  _OTPScreenState createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final otpController = TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;

  // Firebase Auth Function

  Future<void> verifyOtp(String verificationId, String smsCode) async {
    try {
      // Update the UI - wait for the user to enter the SMS code

      // Create a PhoneAuthCredential with the code
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: widget.verificationId, smsCode: smsCode);

      // Sign the user in (or link) with the credential

      final user = await auth.signInWithCredential(credential);

      final addressList = await FirebaseFirestore.instance
          .collection('userAddressBook')
          .where('uid', isEqualTo: user.user!.uid)
          .get();

      addressList.docs.length > 0
          ? Get.offAll(() => Home())
          : Get.offAll(() => UserDetails());
    } on FirebaseAuthException catch (e) {
      print(e);
      Get.snackbar('Try Again', 'The Entered Code is invalid');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SizedBox(
          height: 500,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text('OTP Has Been Sent To', style: TextStyle(fontSize: 25)),
                  SizedBox(
                    height: 20,
                  ),
                  Text('+91  ${widget.number}', style: TextStyle(fontSize: 20))
                ],
              ),
              Text('Please Enter The 6 - Digit Code Sent To Your Number',
                  style: TextStyle(fontSize: 16)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: PinInputTextField(
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
                style: kElevatedButtonStyle,
                onPressed: () {
                  verifyOtp(widget.verificationId, otpController.text);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
