import 'package:beamer/beamer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
  List<notif_model.Notification> notifications = [];
  notif_model.Notification? selectedNotification;
  void onSelectedNotificationChange(notification) {
    setState(() => selectedNotification = notification);
  }

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
    if (message.notification == null) return;

    final notification = message.notification;
    if (notification != null) {
      final newNotification = notif_model.Notification(
        id: "${Random().nextInt(10000)}-${Random().nextInt(10000)}",
        title: notification.title!,
        body: notification.body!,
      );
      setState(
        () => notifications.insert(0, newNotification),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    setupNotificationListener();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NotificationsCubit(),
      child: MaterialApp(
        home: Navigator(
          pages: [
            MaterialPage(
              key: ValueKey("home"),
              child: HomeScreen(
                notifications: notifications,
                onSelectedNotificationChange: onSelectedNotificationChange,
              ),
            ),
            if (selectedNotification != null)
              MaterialPage(
                key: ValueKey("notification-details"),
                child: NotificationDetailsScreen(
                  notification: selectedNotification!,
                ),
              ),
          ],
          onPopPage: (route, result) {
            if (!route.didPop(result)) return false;
            final page = route.settings as MaterialPage;

            if (selectedNotification != null &&
                page.key == ValueKey("notification-details")) {
              setState(() => selectedNotification = null);
            }

            return true;
          },
        ),
        debugShowCheckedModeBanner: false,
        title: 'Notify',
      ),
    );
  }
}
