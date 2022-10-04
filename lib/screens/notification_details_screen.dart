import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notify/bloc/notification_bloc.dart';
import 'package:notify/routes/beam_locations.dart';
import '../cubit/notifications_cubit.dart';

class NotificationDetailsScreen extends StatelessWidget {
  final String notificationId;

  const NotificationDetailsScreen({Key? key, required this.notificationId})
      : super(key: key);
  static const path = "/notifications/:id";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              BlocProvider.of<NotificationsCubit>(context, listen: false)
                  .deleteNotificationById(notificationId);
            },
            icon: const Icon(Icons.delete),
          ),
        ],
      ),
      body: BlocBuilder<NotificationsCubit, NotificationsState>(
          builder: (context, state) {
        if (state is NotificationLoadingListState) {
          return const Center(child: CircularProgressIndicator());
        }

        final notification = BlocProvider.of<NotificationsCubit>(context)
            .getNotificationById(notificationId);
        if (notification == null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("No notification found"),
                ElevatedButton(
                  onPressed: () => Beamer.of(context).beamTo(HomeLocation()),
                  child: const Text("Go to home"),
                ),
              ],
            ),
          );
        }

        return BlocProvider(
          create: (context) => NotificationBloc()
            ..add(
              NotificationChangeEvent(notification: notification),
            ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  notification.title,
                  style: const TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  notification.body,
                  style: const TextStyle(fontSize: 15),
                ),
                const SizedBox(height: 16),
                Builder(
                  builder: (context) {
                    return ElevatedButton(
                      onPressed: () {
                        BlocProvider.of<NotificationBloc>(context)
                            .add(WordCountEvent());
                      },
                      child: const Text("Count Body Words"),
                    );
                  },
                ),
                BlocBuilder<NotificationBloc, NotificationState>(
                  builder: (context, state) {
                    if (state is LoadedNotificationWithWordsCount) {
                      return Text("Words: ${state.words}");
                    }
                    return const Text("No words counted yet!");
                  },
                )
              ],
            ),
          ),
        );
      }),
    );
  }
}
