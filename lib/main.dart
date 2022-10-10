import 'package:beamer/beamer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notify/database/database.dart';
import './components/notifications_handler.dart';
import './cubit/notifications_cubit.dart';
import './routes/beam_locations.dart';
import './utils/notification_helpers.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';

AppDb db = AppDb();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  db = AppDb();
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
  static final NotificationsCubit notificationsCubit = NotificationsCubit();
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final routerDelegate = BeamerDelegate(
    locationBuilder: BeamerLocationBuilder(
      beamLocations: [
        HomeLocation(),
        NotificationDetailsLocation(),
      ],
    ),
  );

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MyApp.notificationsCubit,
      child: NotificationsHandler(
        child: MaterialApp.router(
          routerDelegate: routerDelegate,
          routeInformationParser: BeamerParser(),
          debugShowCheckedModeBanner: false,
          theme: ThemeData(primarySwatch: Colors.pink),
          title: 'Notify',
        ),
      ),
    );
  }
}
