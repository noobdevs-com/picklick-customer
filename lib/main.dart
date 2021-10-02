import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:picklick_customer/controllers/binding/binding.dart';

import 'package:picklick_customer/screens/wrapper.dart';

// Notification

const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    'This channel is used for important notifications.', // description
    importance: Importance.max,
    playSound: true);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> _firebaseMessagingbackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('BG message arrived : ${message.messageId}');
}

// Root App
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingbackgroundHandler);

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true, // Required to display a heads up notification
    badge: true,
    sound: true,
  );
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          appBarTheme: AppBarTheme(
              color: Color(0xFFCFB840),
              iconTheme: IconThemeData(color: Colors.black),
              foregroundColor: Colors.black),
          cardTheme: CardTheme(
              elevation: 2,
              color: Color(0xFfF0EBCC).withOpacity(0.825),
              shadowColor: Colors.grey),
          primaryColor: Color(0xFFCFB840),
          visualDensity: VisualDensity.adaptivePlatformDensity,
          scaffoldBackgroundColor: Color(0xFFF0EBCC),
          floatingActionButtonTheme: FloatingActionButtonThemeData(
              elevation: 2,
              backgroundColor: Color(0xFFCFB840),
              foregroundColor: Colors.black),
          elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
            primary: Colors.red,
            elevation: 0,
          )),
          textSelectionTheme: TextSelectionThemeData(
            cursorColor: Colors.black,
          )),
      initialRoute: '/',
      routes: {
        '/': (context) => Wrapper(),
      },
      initialBinding: InitBinding(),
    );
  }
}
