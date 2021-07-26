import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:picklick_customer/constants/valueConstants.dart';
import 'package:picklick_customer/screens/Auth/otpVerify.dart' as OTP;

class AuthenticationWrapper extends StatelessWidget {
  final phonenumberController = TextEditingController();
  final FirebaseAuth auth = FirebaseAuth.instance;
  late final String verificationId;
  @override
  Widget build(BuildContext context) {
    Future<void> sendOtp() async {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: '+91${phonenumberController.text}',
        verificationCompleted: (PhoneAuthCredential credential) async {
          // ANDROID ONLY!

          // Sign the user in (or link) with the auto-generated credential
          await auth.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          Get.snackbar('Error', "Exception" + e.message!.toString());
          if (e.code == 'invalid-phone-number') {
            print('The provided phone number is not valid.');
            Get.snackbar(
                'Invalid Number', 'Please Check the number you have entered');
          }

          // Handle other errors
        },
        codeSent: (String vId, int? resendToken) async {
          verificationId = vId;
          print('Code has been sent');
          Get.snackbar('OTP Sent', 'OTP has been sent to you mobile number');
          Get.to(() => OTP.OTPScreen(
                number: phonenumberController.text,
                verificationId: verificationId,
              ));
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          print('Timed out...');
        },
      );
    }

    return SafeArea(
      child: Scaffold(
        body: SizedBox(
          height: 700,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                  child: Column(children: [
                Image(
                  image: AssetImage(
                    'assets/logo.png',
                  ),
                  height: 100,
                ),
                Text(
                  "Dream IT, Beleive IT and Build IT",
                  style: TextStyle(
                    letterSpacing: 2,
                    fontSize: 15,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ])),
              Expanded(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Get Your Favourite Food',
                        style: TextStyle(fontSize: 28),
                      ),
                      SizedBox(height: 10),
                      Text('At Your Door Step !',
                          style: TextStyle(fontSize: 20)),
                    ]),
              ),
              Text('Enter Your Phone Number Here To Continue :'),
              Flexible(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 60),
                  child: TextField(
                    keyboardType: TextInputType.number,
                    controller: phonenumberController,
                    decoration: InputDecoration(
                      focusedBorder: KTFFocusedBorderStyle,
                      prefix: SizedBox(width: 50, child: Text('+91')),
                      border: KTFBorderStyle,
                    ),
                  ),
                ),
              ),
              Flexible(
                child: ElevatedButton(
                  child: Text(
                    'Verify Number',
                    style: TextStyle(fontSize: 18),
                  ),
                  style: kElevatedButtonStyle,
                  onPressed: () {
                    sendOtp();
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
