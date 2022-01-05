import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:picklick_customer/constants/constants.dart';
import 'package:picklick_customer/constants/valueConstants.dart';
import 'package:picklick_customer/models/user.dart';
import 'package:picklick_customer/screens/App/loading.dart';

class MyAccount extends StatefulWidget {
  const MyAccount({Key? key}) : super(key: key);

  @override
  _MyAccountState createState() => _MyAccountState();
}

class _MyAccountState extends State<MyAccount> {
  var currentPage = ProfileVeiw.PROFILE_VEIW;
  final user = FirebaseAuth.instance.currentUser!;

  final ref = FirebaseFirestore.instance
      .collection('userAddressBook')
      .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid);

  final _formKey = GlobalKey<FormState>();

  Widget profileView() {
    return StreamBuilder(
        stream: ref.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            final data = CustomerUser.toJson(snapshot.data!.docs[0]);
            return Column(
              children: [
                Stack(children: [
                  Column(
                    children: [
                      Container(
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                radius: 50,
                                backgroundColor: Colors.white,
                                child: Icon(
                                  Icons.person_rounded,
                                  color: Color(0xFFCFB840),
                                  size: 90,
                                ),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Text(
                                data.name,
                                style: TextStyle(
                                    shadows: [
                                      Shadow(color: Colors.grey, blurRadius: 5),
                                    ],
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 24),
                              ),
                            ],
                          ),
                        ),
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                                colors: [
                              Color(0xFFF0EBCC),
                              Color(0xFFCFB840),
                            ])),
                        height: 280,
                        width: MediaQuery.of(context).size.width,
                      ),
                      Container(
                        color: Colors.white,
                        height: 50,
                        width: MediaQuery.of(context).size.width,
                      )
                    ],
                  ),
                  Positioned(
                    left: 70,
                    top: 250,
                    child: Card(
                      elevation: 1,
                      child: Container(
                        child: Center(
                            child: Text(
                          'User Details',
                          style: TextStyle(
                            letterSpacing: 1,
                            fontWeight: FontWeight.bold,
                            fontSize: 19,
                            color: Color(0xFFCFB840),
                          ),
                        )),
                        height: 60,
                        width: MediaQuery.of(context).size.width - 150,
                        color: Color(0xFFF0EBCC),
                      ),
                    ),
                  )
                ]),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      height: 30,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 50),
                      child: Row(
                        children: [
                          Icon(
                            Icons.email,
                            color: Colors.black54,
                          ),
                          SizedBox(
                            width: 18,
                          ),
                          Text(data.email,
                              textAlign: TextAlign.justify,
                              style: TextStyle(
                                fontSize: 17,
                                color: Colors.black54,
                              )),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 50),
                      child: Row(
                        children: [
                          Icon(
                            Icons.phone,
                            color: Colors.black54,
                          ),
                          SizedBox(
                            width: 18,
                          ),
                          Text(
                              FirebaseAuth.instance.currentUser!.phoneNumber
                                  .toString(),
                              textAlign: TextAlign.justify,
                              style: TextStyle(
                                fontSize: 17,
                                color: Colors.black54,
                              )),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 50),
                      child: Row(
                        children: [
                          Icon(
                            Icons.location_city,
                            color: Colors.black54,
                          ),
                          SizedBox(
                            width: 18,
                          ),
                          Text(data.address,
                              textAlign: TextAlign.justify,
                              style: TextStyle(
                                fontSize: 17,
                                color: Colors.black54,
                              )),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          currentPage = ProfileVeiw.PROFILE_EDIT;
                        });
                      },
                      child: Text('Edit Details'),
                      style: kElevatedButtonStyle,
                    )
                  ],
                ),
              ],
            );
          }

          return Loading();
        });
  }

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final addressController = TextEditingController();

  bool loading = false;

  Widget profileEdit() {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
              height: 5,
              child: loading == true
                  ? LinearProgressIndicator(
                      color: Colors.black,
                      backgroundColor: Colors.white,
                    )
                  : null),
          Center(
            child: SizedBox(
              width: 350,
              height: 450,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Edit User Details',
                        style: TextStyle(
                            fontSize: 20,
                            letterSpacing: 2,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(width: 15),
                      Icon(Icons.delivery_dining)
                    ],
                  ),
                  Divider(
                    color: Color(0xFFCFB840),
                    height: 4,
                    thickness: 2,
                    endIndent: 50,
                    indent: 50,
                  ),
                  SizedBox(height: 15),
                  Container(
                    height: 50,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Enter Name';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.name,
                        controller: nameController,
                        decoration: InputDecoration(
                            enabledBorder: KTFBorderStyle,
                            labelStyle: TextStyle(color: Colors.black),
                            focusedBorder: KTFFocusedBorderStyle,
                            hintText: 'Enter Your Name',
                            labelText: 'Name :',
                            border: KTFBorderStyle),
                      ),
                    ),
                  ),
                  Container(
                    height: 50,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Enter Email';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.emailAddress,
                        controller: emailController,
                        decoration: InputDecoration(
                            enabledBorder: KTFBorderStyle,
                            labelStyle: TextStyle(color: Colors.black),
                            focusedBorder: KTFFocusedBorderStyle,
                            hintText: 'Enter Your Email',
                            labelText: 'E-mail :',
                            border: KTFBorderStyle),
                      ),
                    ),
                  ),
                  Container(
                    height: 50,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Enter Address';
                          }
                          return null;
                        },
                        maxLines: null,
                        keyboardType: TextInputType.text,
                        controller: addressController,
                        decoration: InputDecoration(
                            enabledBorder: KTFBorderStyle,
                            labelStyle: TextStyle(color: Colors.black),
                            focusedBorder: KTFFocusedBorderStyle,
                            hintText: 'Enter Your Address',
                            labelText: 'Address :',
                            border: KTFBorderStyle),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      if (!_formKey.currentState!.validate()) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Fill in all Mandotary Fields')),
                        );
                      } else {
                        setState(() {
                          loading = true;
                        });
                        final uid = FirebaseAuth.instance.currentUser!.uid;
                        await FirebaseFirestore.instance
                            .collection('userAddressBook')
                            .doc(uid)
                            .update({
                          'name': nameController.text,
                          'email': emailController.text,
                          'address': addressController.text,
                        }).whenComplete(() {
                          user.updateDisplayName(nameController.text);
                          setState(() {
                            loading = false;
                            nameController.clear();
                            emailController.clear();
                            addressController.clear();
                            currentPage = ProfileVeiw.PROFILE_VEIW;
                          });
                        }).catchError((e) => Get.snackbar('Try Again', e));
                      }
                    },
                    child: Text('Update Details'),
                    style: kElevatedButtonStyle,
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: currentPage == ProfileVeiw.PROFILE_VEIW
            ? profileView()
            : profileEdit());
  }
}
