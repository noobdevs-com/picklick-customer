import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'package:picklick_customer/constants/valueConstants.dart';
import 'package:picklick_customer/controllers/location.dart';
import 'package:picklick_customer/screens/App/home.dart';
import 'package:picklick_customer/services/fcm_notification.dart';

class UserDetails extends StatefulWidget {
  @override
  State<UserDetails> createState() => _UserDetailsState();
}

class _UserDetailsState extends State<UserDetails> {
  final nameController = TextEditingController();

  final emailController = TextEditingController();

  final addressController = TextEditingController();

  GetStorage getStorage = GetStorage();

  FCMNotification fcmNotification = FCMNotification();

  bool locloading = false;
  bool btnLoading = false;

  final locationController = Get.put(LocationController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 60,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Let's Get Started",
                        style: TextStyle(
                            color: Color.fromARGB(255, 182, 19, 8),
                            fontSize: 20,
                            fontWeight: FontWeight.w600),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Text(
                        'We Deliver To Your Doorstep',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.transparent.withOpacity(0.1),
                    backgroundImage: AssetImage('assets/logoIn.png'),
                  ),
                ],
              ),
              SizedBox(
                height: 28,
              ),
              textField('Name : ', nameController, TextInputType.name),
              SizedBox(height: 20),
              textField(
                  'E-mail : ', emailController, TextInputType.emailAddress),
              SizedBox(height: 20),
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
                          padding: const EdgeInsets.symmetric(horizontal: 8),
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
                        child: locloading
                            ? Center(
                                child: CircularProgressIndicator(
                                  color: Color(0xFFCFB840),
                                ),
                              )
                            : ElevatedButton(
                                onPressed: () async {
                                  final status =
                                      await Geolocator.checkPermission();
                                  if (status == LocationPermission.whileInUse ||
                                      status == LocationPermission.always) {
                                    setState(() {
                                      locloading = true;
                                    });

                                    await Geolocator.getCurrentPosition()
                                        .then((value) async {
                                      final placemark =
                                          await placemarkFromCoordinates(
                                              value.latitude, value.longitude);
                                      print(placemark[0].subAdministrativeArea);

                                      setState(() {
                                        addressController.text =
                                            '${placemark[0].name}, ${placemark[0].street}, ${placemark[0].locality}, ${placemark[0].subAdministrativeArea}, ${placemark[0].postalCode}';
                                        locloading = false;
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
              SizedBox(
                height: 40,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 48,
                    width: 292,
                    child: ElevatedButton(
                      onPressed: btnLoading
                          ? null
                          : () async {
                              try {
                                setState(() {
                                  btnLoading = true;
                                });
                                final user = FirebaseAuth.instance.currentUser!;

                                await FirebaseFirestore.instance
                                    .collection('userAddressBook')
                                    .doc(user.uid)
                                    .set({
                                  'name': nameController.text,
                                  'email': emailController.text,
                                  'address': addressController.text,
                                  'uid': user.uid,
                                  'notificationToken':
                                      getStorage.read('deviceToken') == null
                                          ? fcmNotification.updateDeviceToken()
                                          : getStorage.read('deviceToken')
                                }, SetOptions(merge: true)).whenComplete(() {
                                  setState(() {
                                    btnLoading = false;
                                  });
                                  user.updateDisplayName(
                                      '${nameController.text}');
                                  Get.offAll(() => Home());
                                });
                              } catch (e) {
                                print(e);
                              }
                            },
                      child: Text(
                        'Add Details',
                      ),
                      style: ElevatedButton.styleFrom(
                          primary: Colors.redAccent[400],
                          onPrimary: Colors.white,
                          minimumSize: Size(double.infinity, 60),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15))),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget textField(String label, TextEditingController? controller,
      TextInputType keyboardtype) {
    return TextFormField(
      keyboardType: keyboardtype,
      controller: controller,
      decoration: InputDecoration(
          labelStyle: TextStyle(color: Colors.black),
          focusedBorder: KTFFocusedBorderStyle,
          labelText: label,
          border: KTFBorderStyle),
    );
  }
}
