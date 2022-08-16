import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:picklick_customer/constants/constants.dart';
import 'package:picklick_customer/constants/valueConstants.dart';
import 'package:picklick_customer/controllers/location.dart';
import 'package:picklick_customer/models/user.dart';
import 'package:picklick_customer/screens/App/loading.dart';
import 'package:geocoding/geocoding.dart';

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

  bool loading = false;

  final locationController = Get.put(LocationController());

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
                              Row(
                                children: [
                                  IconButton(
                                      onPressed: () {
                                        setState(() {
                                          Navigator.of(context).pop();
                                        });
                                      },
                                      icon: Icon(Icons.arrow_back))
                                ],
                              ),
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
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        height: 30,
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.email,
                            color: Colors.black54,
                          ),
                          SizedBox(
                            width: 18,
                          ),
                          Flexible(
                            child: Text(data.email,
                                textAlign: TextAlign.justify,
                                overflow: TextOverflow.fade,
                                style: TextStyle(
                                  fontSize: 17,
                                  color: Colors.black54,
                                )),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.phone,
                            color: Colors.black54,
                          ),
                          SizedBox(
                            width: 18,
                          ),
                          Expanded(
                            child: Text(
                                FirebaseAuth.instance.currentUser!.phoneNumber
                                    .toString(),
                                textAlign: TextAlign.justify,
                                style: TextStyle(
                                  fontSize: 17,
                                  color: Colors.black54,
                                )),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.location_city,
                            color: Colors.black54,
                          ),
                          SizedBox(
                            width: 18,
                          ),
                          Flexible(
                            child: Text(data.address,
                                textAlign: TextAlign.justify,
                                maxLines: null,
                                style: TextStyle(
                                  fontSize: 17,
                                  color: Colors.black54,
                                )),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Get.defaultDialog(
                              cancelTextColor: Colors.black45,
                              confirmTextColor: Colors.white,
                              buttonColor: Color(0xFFCFB840),
                              title: 'Edit Profile ?',
                              middleText:
                                  'Do you want to edit your information ?',
                              textCancel: 'No',
                              textConfirm: 'Yes',
                              onConfirm: () {
                                Navigator.pop(context);
                                Future.delayed(Duration(milliseconds: 500), () {
                                  setState(() {
                                    currentPage = ProfileVeiw.PROFILE_EDIT;
                                  });
                                });
                              });
                        },
                        child: Text('Edit Details'),
                        style: kElevatedButtonStyle,
                      )
                    ],
                  ),
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

  bool btnLooading = false;

  Widget profileEdit() {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              IconButton(
                  onPressed: () {
                    setState(() {
                      currentPage = ProfileVeiw.PROFILE_VEIW;
                    });
                  },
                  icon: Icon(Icons.arrow_back))
            ],
          ),
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
                  SizedBox(
                    width: MediaQuery.of(context).size.width - 15,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 4,
                          child: Container(
                            height: 100,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              child: TextFormField(
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Enter Address';
                                  }
                                  return null;
                                },
                                maxLines: null,
                                minLines: 3,
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
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(
                            alignment: Alignment.center,
                            height: 70,
                            child: loading
                                ? Center(
                                    child: CircularProgressIndicator(
                                      color: Color(0xFFCFB840),
                                    ),
                                  )
                                : ElevatedButton(
                                    onPressed: () async {
                                      final status =
                                          await Geolocator.checkPermission();
                                      if (status ==
                                              LocationPermission.whileInUse ||
                                          status == LocationPermission.always) {
                                        setState(() {
                                          loading = true;
                                        });

                                        await Geolocator.getCurrentPosition()
                                            .then((value) async {
                                          final placemark =
                                              await placemarkFromCoordinates(
                                                  value.latitude,
                                                  value.longitude);
                                          print(placemark[0]
                                              .subAdministrativeArea);

                                          setState(() {
                                            addressController.text =
                                                '${placemark[0].name}, ${placemark[0].street}, ${placemark[0].locality}, ${placemark[0].subAdministrativeArea}, ${placemark[0].postalCode}';
                                            loading = false;
                                          });
                                          print(locationController
                                              .position!.latitude);
                                        });
                                      }
                                    },
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Icon(Icons.edit_location),
                                        Text(
                                          'PICK',
                                          style: TextStyle(
                                              fontSize: 11,
                                              overflow: TextOverflow.ellipsis),
                                          textAlign: TextAlign.center,
                                        )
                                      ],
                                    ),
                                  ),
                          ),
                        )
                      ],
                    ),
                  ),
                  btnLooading
                      ? CircularProgressIndicator(color: Color(0xFFCFB840))
                      : ElevatedButton(
                          onPressed: () async {
                            if (!_formKey.currentState!.validate()) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content:
                                        Text('Fill in all Mandotary Fields')),
                              );
                            } else {
                              setState(() {
                                btnLooading = true;
                              });
                              final uid =
                                  FirebaseAuth.instance.currentUser!.uid;
                              await FirebaseFirestore.instance
                                  .collection('userAddressBook')
                                  .doc(uid)
                                  .update({
                                'name': nameController.text,
                                'email': emailController.text,
                                'address': addressController.text,
                                'location': GeoPoint(
                                    locationController.position!.latitude,
                                    locationController.position!.longitude)
                              }).whenComplete(() {
                                user.updateDisplayName(nameController.text);
                                setState(() {
                                  btnLooading = false;
                                  nameController.clear();
                                  emailController.clear();
                                  addressController.clear();
                                  currentPage = ProfileVeiw.PROFILE_VEIW;
                                });
                              }).catchError(
                                      (e) => Get.snackbar('Try Again', e));
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
  void initState() {
    super.initState();
    locationController.setCurrentlocation();
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
