part of 'notification_bloc.dart';

abstract class NotificationState extends Equatable {
  const NotificationState();

  @override
  List<Object> get props => [];
}

class NotificationInitial extends NotificationState {}

class LoadedNotification extends NotificationState {
  final Notification notification;

  const LoadedNotification({required this.notification});

  @override
  List<Object> get props => [notification];
}

class LoadedNotificationWithWordsCount extends LoadedNotification {
  final int words;

  const LoadedNotificationWithWordsCount(
      {required super.notification, required this.words});
}
