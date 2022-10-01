import 'package:beamer/beamer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notify/components/notifications_handler.dart';
import 'package:notify/cubit/notifications_cubit.dart';
import 'package:notify/screens/home_screen.dart';
import 'package:notify/screens/notification_details_screen.dart';
import "dart:math";
import 'package:notify/utils/notification_helpers.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import "./models/notification.dart" as notif_model;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseMessaging messaging = FirebaseMessaging.instance;
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );
  print('User granted permission: ${settings.authorizationStatus}');

  FirebaseMessaging.onBackgroundMessage(backgroundNotificationsHandler);

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NotificationsCubit(),
      child: MaterialApp(
        home: NotificationsHandler(
          child: HomeScreen(),
        ),
        debugShowCheckedModeBanner: false,
        title: 'Notify',
      ),
    );
  }
}
