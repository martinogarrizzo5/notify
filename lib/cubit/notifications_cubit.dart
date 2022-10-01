import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:notify/models/notification.dart';

part 'notifications_state.dart';

class NotificationsCubit extends Cubit<NotificationsState> {
  NotificationsCubit() : super(NotificationsState(notifications: []));

  void addNotification(String id, String title, String body) {
    final newNotification = Notification(id: id, body: body, title: title);
    emit(
      NotificationsState(
        notifications: [...state.notifications, newNotification],
      ),
    );
  }
}
