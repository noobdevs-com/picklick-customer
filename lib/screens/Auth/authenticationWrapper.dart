import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:picklick_customer/screens/App/home.dart';
import 'package:picklick_customer/screens/Auth/otpVerify.dart' as OTP;

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

  @override
  Widget build(BuildContext context) {
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

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
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
                height: MediaQuery.of(context).size.height - 200,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          "Dream IT",
                          style: TextStyle(
                            letterSpacing: 2,
                            fontSize: 17,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        Text(
                          "Beleive IT",
                          style: TextStyle(
                            letterSpacing: 2,
                            fontSize: 17,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        Text(
                          "Build IT",
                          style: TextStyle(
                            letterSpacing: 2,
                            fontSize: 17,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Get Your Favourite Food',
                              style: TextStyle(fontSize: 28),
                            ),
                            SizedBox(height: 17),
                            Text('At Your Door Step !',
                                style: TextStyle(fontSize: 20)),
                          ]),
                    ),
                    Expanded(
                      child: Image(
                        image: AssetImage(
                          'assets/logo.png',
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text('Enter Your Phone Number Here To Continue :'),
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 60),
                        child: TextField(
                          style: TextStyle(fontSize: 17),
                          textAlign: TextAlign.center,
                          cursorColor: Colors.black,
                          keyboardType: TextInputType.number,
                          controller: phonenumberController,
                          decoration: InputDecoration(
                              hintText: 'Enter Your Phone Number',
                              focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Color(0xFFCFB840)),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(18))),
                              suffix: Text('(IN)'),
                              prefix: SizedBox(width: 50, child: Text('(+91)')),
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(18)))),
                        ),
                      ),
                    ),
                    Flexible(
                      child: ElevatedButton(
                        child: Text(
                          'Verify Number',
                          style: TextStyle(fontSize: 18),
                        ),
                        style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                                horizontal: 50, vertical: 15),
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(18)))),
                        onPressed: () {
                          sendOtp();
                          setState(() {
                            loading = true;
                          });
                        },
                      ),
                    ),
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
