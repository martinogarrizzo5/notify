part of 'notifications_cubit.dart';

abstract class NotificationsState extends Equatable {}

class NotificationsListState implements NotificationsState {
  List<Notification>? notifications;

  NotificationsListState({required this.notifications});

  @override
  List<Object?> get props => [notifications];

  @override
  bool? get stringify => false;
}

class NotificationLoadingListState implements NotificationsState {
  NotificationLoadingListState();

  @override
  List<Object?> get props => [];

  @override
  bool? get stringify => false;
}
