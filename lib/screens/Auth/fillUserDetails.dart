import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:picklick_customer/constants/valueConstants.dart';

class UserDetails extends StatelessWidget {
  final nameController = TextEditingController();
  final altphnNumberController = TextEditingController();
  final addressController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Center(
        child: SizedBox(
          width: 300,
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
                controller: altphnNumberController,
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
                onPressed: () {},
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
