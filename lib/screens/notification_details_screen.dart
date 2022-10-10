import 'dart:math';

import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notify/bloc/notification_bloc.dart';
import 'package:notify/main.dart';
import 'package:notify/routes/beam_locations.dart';

class NotificationDetailsScreen extends StatelessWidget {
  final String notificationId;
  final NotificationBloc notificationBloc = NotificationBloc();

  NotificationDetailsScreen({Key? key, required this.notificationId})
      : super(key: key) {
    final notification =
        MyApp.notificationsCubit.getNotificationById(notificationId);
    if (notification != null) {
      notificationBloc.add(NotificationChangeEvent(notification: notification));
      notificationBloc.listenToNotificationChanges(notificationId);
    } else {
      notificationBloc.add(NotificationNotFoundEvent());
    }
  }
  static const path = "/notifications/:id";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              notificationBloc.add(NotificationDeleteEvent(notificationId));
            },
            icon: const Icon(Icons.delete),
          ),
        ],
      ),
      body: BlocBuilder<NotificationBloc, NotificationState>(
          bloc: notificationBloc,
          builder: (context, state) {
            if (state is NotificationNotFound) {
              return const Text("Notification not found");
            }

            if (state is NotificationDeleted) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Notification deleted"),
                    ElevatedButton(
                      onPressed: () =>
                          Beamer.of(context).beamTo(HomeLocation()),
                      child: const Text("Go to home"),
                    ),
                  ],
                ),
              );
            }

            if (state is NotificationError) {
              return Text("Error ${state.exception.toString()}");
            }

            if (state is NotificationInitial) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (state is LoadedNotification) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      state.notification.title!,
                      style: const TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      state.notification.body!,
                      style: const TextStyle(fontSize: 15),
                    ),
                    const SizedBox(height: 16),
                    Builder(
                      builder: (context) {
                        return ElevatedButton(
                          onPressed: () {
                            notificationBloc.add(WordCountEvent());
                          },
                          child: const Text("Count Body Words"),
                        );
                      },
                    ),
                    if (state is LoadedNotificationWithWordsCount)
                      Text("Words: ${state.words}")
                    else
                      const Text("No words counted yet!"),
                    ElevatedButton(
                      onPressed: () {
                        db.updateNotificationById(
                          id: notificationId,
                          title: Random().nextInt(10000).toString(),
                        );
                      },
                      child: Text("Update notification"),
                    )
                  ],
                ),
              );
            }

            return const Text("Unknown state");
          }),
    );
  }
}
