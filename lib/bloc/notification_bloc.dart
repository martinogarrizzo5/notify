import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:notify/models/notification.dart';

part 'notification_event.dart';
part 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  NotificationBloc() : super(NotificationInitial()) {
    on<WordCountEvent>(_onWordCountEvent);
    on<NotificationChangeEvent>(_onNotificationChangeEvent);
  }

  void _onNotificationChangeEvent(
      NotificationChangeEvent event, Emitter<NotificationState> emit) {
    emit(LoadedNotification(notification: event.notification));
  }

  void _onWordCountEvent(
      WordCountEvent event, Emitter<NotificationState> emit) {
    if (state is LoadedNotification) {
      final notification = (state as LoadedNotification).notification;
      final words = notification.body.split(" ");

      emit(
        LoadedNotificationWithWordsCount(
          notification: notification,
          words: words.length,
        ),
      );
    }
  }
}
