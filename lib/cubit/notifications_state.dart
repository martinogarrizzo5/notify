part of 'notifications_cubit.dart';

abstract class NotificationsState extends Equatable {}

class NotificationsListState extends NotificationsState {
  final List<Notification> notifications;

  NotificationsListState({required this.notifications});

  @override
  List<Object?> get props => [notifications];
}

class NotificationLoadingListState extends NotificationsState {
  NotificationLoadingListState();

  @override
  List<Object?> get props => [];
}
