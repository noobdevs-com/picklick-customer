import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:picklick_customer/screens/App/home.dart';
import 'package:pin_input_text_field/pin_input_text_field.dart';

class OTPScreen extends StatefulWidget {
  final String number;

  OTPScreen({required this.number});

  @override
  _OTPScreenState createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final otpController = TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;
  late String verificationId;

  // Firebase Auth Function
  Future<void> sendOtp() async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: '+91${widget.number}',
      verificationCompleted: (PhoneAuthCredential credential) async {
        // ANDROID ONLY!

        // Sign the user in (or link) with the auto-generated credential
        await auth.signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        print("Exception" + e.message!.toString());
        if (e.code == 'invalid-phone-number') {
          print('The provided phone number is not valid.');
        }

        // Handle other errors
      },
      codeSent: (String vId, int? resendToken) async {
        verificationId = vId;
        print('Code has been sent');
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        print('Timed out...');
      },
    );
  }

  Future<void> verifyOtp(String verificationId, String smsCode) async {
    try {
      // Update the UI - wait for the user to enter the SMS code

      // Create a PhoneAuthCredential with the code
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: smsCode);

      // Sign the user in (or link) with the credential

      UserCredential userCredential =
          await auth.signInWithCredential(credential);
      print("verifyCode: " + userCredential.toString());
      Get.to(() => Home());
    } on FirebaseAuthException catch (e) {
      print(e);
      Get.snackbar('Try Again', 'The Entered Code is invalid');
    }
  }

  @override
  void initState() {
    super.initState();
    sendOtp();
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
                style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(18)))),
                onPressed: () {
                  verifyOtp(verificationId, otpController.text);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
