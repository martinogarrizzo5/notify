import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:notify/main.dart';
import "../database/database.dart";

part 'notification_event.dart';
part 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  StreamSubscription<Notification?>? dbSubscription;

  NotificationBloc() : super(NotificationInitial()) {
    on<WordCountEvent>(_onWordCountEvent);
    on<NotificationChangeEvent>(_onNotificationChangeEvent);
    on<NotificationDeleteEvent>(_onNotificationDeleteEvent);
  }

  @override
  Future<void> close() {
    dbSubscription?.cancel();
    return super.close();
  }

  void _onNotificationChangeEvent(
      NotificationChangeEvent event, Emitter<NotificationState> emit) {
    if (state is LoadedNotificationWithWordsCount) {
      emit(LoadedNotificationWithWordsCount(
        notification: event.notification,
        words: (state as LoadedNotificationWithWordsCount).words,
      ));
    } else {
      emit(LoadedNotification(notification: event.notification));
    }
  }

  void _onWordCountEvent(
      WordCountEvent event, Emitter<NotificationState> emit) {
    if (state is LoadedNotification) {
      final notification = (state as LoadedNotification).notification;
      final words = notification.body!.split(" ");

      emit(
        LoadedNotificationWithWordsCount(
          notification: notification,
          words: words.length,
        ),
      );
    }
  }

  void _onNotificationDeleteEvent(
      NotificationDeleteEvent event, Emitter<NotificationState> emit) {
    db.deleteNotificationById(event.id).then((_) => {},
        onError: (error, stack) => emit(NotificationError(exception: error)));
  }

  void listenToNotificationChanges(String notificationId) {
    dbSubscription?.cancel();
    dbSubscription = db.getNotificationById(notificationId).listen((event) {
      if (event != null) {
        return add(NotificationChangeEvent(notification: event));
      }

      if (state is LoadedNotification) {
        emit(NotificationDeleted());
      } else {
        emit(NotificationInitial());
      }
      dbSubscription?.cancel();
    });
  }
}
