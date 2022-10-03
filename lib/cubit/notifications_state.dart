part of 'notifications_cubit.dart';

abstract class NotificationsState {
  List<Notification>? notifications;
}

class NotificationsListState implements NotificationsState {
  @override
  List<Notification>? notifications;

  NotificationsListState({required this.notifications});
}

class NotificationLoadingListState implements NotificationsState {
  @override
  List<Notification>? notifications;

  NotificationLoadingListState() {
    notifications = null;
  }
}
