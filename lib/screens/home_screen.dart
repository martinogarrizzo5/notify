import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notify/cubit/notifications_cubit.dart';
import "../models/notification.dart" as notif_model;

class HomeScreen extends StatefulWidget {
  final path = "/";

  const HomeScreen({
    Key? key,
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
      body: BlocBuilder<NotificationsCubit, NotificationsState>(
        builder: (context, state) {
          return ListView(
            children: state.notifications
                .map(
                  (notification) => Card(
                    child: ListTile(
                      onTap: () {},
                      title: Text(notification.title),
                    ),
                  ),
                )
                .toList(),
          );
        },
      ),
    );
  }
}
