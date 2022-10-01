import 'package:flutter/material.dart';
import "../models/notification.dart" as notif_model;

class HomeScreen extends StatefulWidget {
  final path = "/";
  final List<notif_model.Notification> notifications;
  final ValueChanged onSelectedNotificationChange;

  const HomeScreen({
    Key? key,
    required this.notifications,
    required this.onSelectedNotificationChange,
  }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notify'),
      ),
      body: ListView(
        children: widget.notifications
            .map(
              (notification) => Card(
                child: ListTile(
                  onTap: () =>
                      widget.onSelectedNotificationChange(notification),
                  title: Text(notification.title),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
