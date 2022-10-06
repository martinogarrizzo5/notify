part of 'notification_bloc.dart';

abstract class NotificationEvent extends Equatable {
  const NotificationEvent();

  @override
  List<Object> get props => [];
}

class NotificationChangeEvent extends NotificationEvent {
  final Notification notification;

  const NotificationChangeEvent({required this.notification});

  @override
  List<Object> get props => [notification];
}

class WordCountEvent extends NotificationEvent {
  @override
  List<Object> get props => [];
}

class NotificationDeleteEvent extends NotificationEvent {
  final String id;

  const NotificationDeleteEvent(this.id);

  @override
  List<Object> get props => [id];
}

class NotificationNotFoundEvent extends NotificationEvent {}
