import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:picklick_customer/components/MenuDrawer.dart';
import 'package:picklick_customer/components/searchBar.dart';
import 'package:picklick_customer/main.dart';
import 'package:picklick_customer/screens/App/bucketBriyani.dart';
import 'package:new_version/new_version.dart';
import 'package:picklick_customer/screens/App/shopTile.dart';
import 'package:url_launcher/url_launcher.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  void initState() {
    super.initState();

    _checkVersion();
    FirebaseMessaging.onMessage.listen((m) {
      RemoteNotification? notification = m.notification;
      AndroidNotification? androidNotification = m.notification!.android;
      if (notification != null && androidNotification != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
                android: AndroidNotificationDetails(
                    channel.id, channel.name, channel.description,
                    color: Color(0xFFCFB840),
                    playSound: true,
                    icon: '@mipmap/ic_launcher')));
      }
    });
    // getlocation();
  }

  _checkVersion() {
    final version = NewVersion(androidId: 'com.melwin.picklick_customer');

    version.showAlertIfNecessary(context: context);
  }

  late Position _currentPosition;

  Future<Position?> getlocation() async {
    await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high,
            forceAndroidLocationManager: true)
        .then((Position position) {
      setState(() {
        position = _currentPosition;
      });

      return position;
    });
  }

  // Future<Position> _determinePosition() async {
  //   bool serviceEnabled;
  //   LocationPermission permission;

  //   // Test if location services are enabled.
  //   serviceEnabled = await Geolocator.isLocationServiceEnabled();
  //   if (!serviceEnabled) {
  //     // Location services are not enabled don't continue
  //     // accessing the position and request users of the
  //     // App to enable the location services.
  //     Get.snackbar('ERROR', 'Location services are disabled.');
  //     return Future.error('Location services are disabled.');
  //   }

  //   permission = await Geolocator.checkPermission();
  //   if (permission == LocationPermission.denied) {
  //     permission = await Geolocator.requestPermission();
  //     if (permission == LocationPermission.denied) {
  //       // Permissions are denied, next time you could try
  //       // requesting permissions again (this is also where
  //       // Android's shouldShowRequestPermissionRationale
  //       // returned true. According to Android guidelines
  //       // your App should show an explanatory UI now.
  //       Get.snackbar('ERROR', 'Location permissions are denied');
  //       return Future.error('Location permissions are denied');
  //     }
  //   }

  //   if (permission == LocationPermission.deniedForever) {
  //     // Permissions are denied forever, handle appropriately.
  //     Get.snackbar('ERROR',
  //         'Location permissions are permanently denied, we cannot request permissions.');
  //     return Future.error(
  //         'Location permissions are permanently denied, we cannot request permissions.');
  //   }

  //   // When we reach here, permissions are granted and we can
  //   // continue accessing the position of the device.
  //   return await Geolocator.getCurrentPosition() ;
  // }

  final List<Tab> myTabs = <Tab>[
    Tab(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [Text('Shop'), Icon(Icons.shop)],
      ),
    ),
    Tab(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('PickLick Special'),
        ],
      ),
    ),
  ];

  openwhatsapp() async {
    var whatsapp = "+918300044575";
    var whatsappURl_android = "whatsapp://send?phone=$whatsapp&text=";
    try {
      launch(whatsappURl_android);
    } catch (e) {
      Get.snackbar('Error', 'e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.defaultDialog(
            title: 'Exit Application',
            middleText: 'Do you want to exit the app ?',
            textCancel: 'No',
            textConfirm: 'Yes',
            onConfirm: () {
              SystemNavigator.pop();
            });
        return true;
      },
      child: DefaultTabController(
        length: myTabs.length,
        child: Scaffold(
          drawer: MenuDrawer(),
          appBar: AppBar(
            bottom: TabBar(
              indicatorColor: Colors.white,
              tabs: myTabs,
            ),
            actions: [
              IconButton(
                  onPressed: () {
                    Get.to(() => SearchScreen());
                  },
                  icon: Icon(
                    Icons.search,
                    size: 27,
                  )),
              SizedBox(
                width: 20,
              ),
              Image.asset(
                'assets/logo1.png',
              )
            ],
          ),
          body: TabBarView(children: [
            ShopTile(),
            BucketBriyani(),
          ]),
          floatingActionButton: FloatingActionButton(
            child: Image.asset(
              'assets/whatsapplogo.png',
              fit: BoxFit.contain,
            ),
            onPressed: () {
              openwhatsapp();
            },
          ),
        ),
      ),
    );
  }
}
