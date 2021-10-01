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

  Widget profileView() {
    return SingleChildScrollView(
      child: Center(
        child: SizedBox(
          height: 550,
          width: 350,
          child: StreamBuilder(
              stream: ref.snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasData) {
                  final data = CustomerUser.toJson(snapshot.data!.docs[0]);
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(
                        children: [
                          Text(
                            'My Account',
                            style: TextStyle(fontSize: 20),
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Icon(Icons.person)
                        ],
                      ),
                      Divider(),
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 15),
                          child: Row(
                            children: [
                              Text(
                                'Name :      ',
                              ),
                              Flexible(
                                child: Text(
                                  '${data.name}',
                                  textAlign: TextAlign.justify,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 15),
                          child: Row(
                            children: [
                              Text('Email :        '),
                              Flexible(
                                child: Text(
                                  data.email,
                                  textAlign: TextAlign.justify,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 15),
                          child: Row(
                            children: [
                              Text('Phone Number :        '),
                              Flexible(
                                child: Text(
                                  FirebaseAuth.instance.currentUser!.phoneNumber
                                      .toString(),
                                  textAlign: TextAlign.justify,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 15),
                          child: Row(
                            children: [
                              Text('Address :    '),
                              Expanded(
                                child: Text(
                                  data.address,
                                  textAlign: TextAlign.justify,
                                ),
                              ),
                            ],
                          ),
                        ),
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
                  );
                }

                return Loading();
              }),
        ),
      ),
    );
  }

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final addressController = TextEditingController();

  bool loading = false;

  Widget profileEdit() {
    return SingleChildScrollView(
      child: Column(
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
        appBar: AppBar(),
        body: currentPage == ProfileVeiw.PROFILE_VEIW
            ? profileView()
            : profileEdit());
  }
}
