import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:picklick_customer/services/local_notification.dart';
import 'package:picklick_customer/services/urlLauncher.dart';
import 'package:timezone/data/latest.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:picklick_customer/components/MenuDrawer.dart';
import 'package:picklick_customer/components/shopSearchBar.dart';
import 'package:picklick_customer/screens/App/bucketBriyani.dart';
import 'package:picklick_customer/screens/App/shopTile.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  void initState() {
    super.initState();

    initializeTimeZones();

// Notification

    LocalNotification.initialize(context);
    FirebaseMessaging.instance.getInitialMessage().then((m) {
      if (m != null) {
        final routeMessage = m.data['route'];
        Navigator.of(context).pushNamed(routeMessage);
      }
    });
    FirebaseMessaging.onMessage.listen((m) {
      LocalNotification.displayHeadsUpNotification(m);
    });
    FirebaseMessaging.onMessageOpenedApp.listen((m) {
      final routeMessage = m.data['route'];
      print(routeMessage);
    });

    _controller = TabController(
      initialIndex: index,
      length: myTabs.length,
      vsync: this,
    );
  }

  late TabController _controller;
  late Position _currentPosition;
  int index = 0;
  final urlL = URLLauncher();

  Future<Position?> getlocation() async {
    await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.bestForNavigation,
            forceAndroidLocationManager: true)
        .then((Position position) {
      setState(() {
        position = _currentPosition;
      });

      return position;
    });
  }

  final List<Tab> myTabs = <Tab>[
    Tab(
        child: Text(
      'Restaurants',
    )),
    Tab(
      child: Center(
          child: Text(
        'Bucket Biriyani',
        textAlign: TextAlign.center,
      )),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.defaultDialog(
            cancelTextColor: Colors.black45,
            confirmTextColor: Colors.white,
            buttonColor: Color(0xFFCFB840),
            title: 'Exit Application',
            middleText: 'Do you want to exit the app ?',
            textCancel: 'No',
            textConfirm: 'Yes',
            onConfirm: () {
              SystemNavigator.pop();
            });
        return true;
      },
      child: Scaffold(
        drawer: MenuDrawer(),
        appBar: AppBar(
          bottom: TabBar(
            onTap: (currentIndex) {
              index = currentIndex;
            },
            controller: _controller,
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
              width: 10,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'MISTER',
                  style: TextStyle(fontSize: 12),
                ),
                Text(
                  'PICKLICK',
                  style: TextStyle(fontSize: 16),
                )
              ],
            ),
            SizedBox(
              width: 20,
            ),
          ],
        ),
        body: TabBarView(
            controller: _controller, children: [ShopTile(), BucketBriyani()]),
        floatingActionButton: InkWell(
          child: Container(
            height: 60,
            width: 60,
            child: Image.asset(
              'assets/whatsapplogo.png',
            ),
          ),
          onTap: () {
            urlL.openwhatsapp();
          },
        ),
      ),
    );
  }
}
