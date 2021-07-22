import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:picklick_customer/constants/valueConstants.dart';
import 'package:picklick_customer/screens/Auth/otpVerify.dart' as OTP;

class AuthenticationWrapper extends StatelessWidget {
  final phonenumberController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
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
                  height: 130,
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
                  padding: const EdgeInsets.symmetric(horizontal: 60),
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
                    Get.to(() =>
                        OTP.OTPScreen(number: phonenumberController.text));
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
