import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:notify/screens/home_screen.dart';
import 'package:notify/utils/notification_helpers.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';

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
  Future<void> setupNotificationListener() async {
    // for foreground notifications
    FirebaseMessaging.onMessage.listen(_handleMessage);

    // for terminated app notifications
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }

    // for background notifications
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }

  void _handleMessage(RemoteMessage message) {
    print(message.notification?.body);
  }

  @override
  void initState() {
    super.initState();
    setupNotificationListener();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Notify',
      home: const HomeScreen(),
    );
  }
}
