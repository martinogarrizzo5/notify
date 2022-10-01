import 'dart:math';
import 'package:firebase_messaging/firebase_messaging.dart';
import "package:flutter/material.dart";
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notify/cubit/notifications_cubit.dart';

class NotificationsHandler extends StatefulWidget {
  final Widget child;
  const NotificationsHandler({Key? key, required this.child}) : super(key: key);

  @override
  State<NotificationsHandler> createState() => _NotificationsHandlerState();
}

class _NotificationsHandlerState extends State<NotificationsHandler> {
  @override
  void initState() {
    super.initState();
    setupNotificationListener();
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
      BlocProvider.of<NotificationsCubit>(context).addNotification(
        "${Random().nextInt(100000)}-${Random().nextInt(100000)}",
        notification.title!,
        notification.body!,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
