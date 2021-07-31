import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:picklick_customer/constants/valueConstants.dart';
import 'package:picklick_customer/screens/App/home.dart';

class UserDetails extends StatelessWidget {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final addressController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Center(
        child: SizedBox(
          width: 350,
          height: 500,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                children: [
                  Text('Fill Your Details For Delivery'),
                  SizedBox(width: 15),
                  Icon(Icons.delivery_dining)
                ],
              ),
              Divider(),
              TextFormField(
                keyboardType: TextInputType.name,
                controller: nameController,
                decoration: InputDecoration(
                    labelStyle: TextStyle(color: Colors.black),
                    focusedBorder: KTFFocusedBorderStyle,
                    labelText: 'Name :',
                    border: KTFBorderStyle),
              ),
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                controller: emailController,
                decoration: InputDecoration(
                    labelStyle: TextStyle(color: Colors.black),
                    focusedBorder: KTFFocusedBorderStyle,
                    labelText: 'E-mail :',
                    border: KTFBorderStyle),
              ),
              TextFormField(
                maxLines: null,
                keyboardType: TextInputType.text,
                controller: addressController,
                decoration: InputDecoration(
                    labelStyle: TextStyle(color: Colors.black),
                    focusedBorder: KTFFocusedBorderStyle,
                    labelText: 'Address :',
                    border: KTFBorderStyle),
              ),
              ElevatedButton(
                onPressed: () async {
                  final user = FirebaseAuth.instance.currentUser!;

                  await FirebaseFirestore.instance
                      .collection('userAddressBook')
                      .doc()
                      .set({
                    'name': nameController.text,
                    'email': emailController.text,
                    'address': addressController.text,
                    'uid': user.uid,
                  }).whenComplete(() {
                    user.updateDisplayName('${nameController.text}');
                    Get.offAll(() => Home());
                  });
                },
                child: Text('Add Details'),
                style: kElevatedButtonStyle,
              )
            ],
          ),
        ),
      ),
    ));
  }
}
