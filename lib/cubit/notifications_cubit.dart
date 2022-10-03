import 'package:bloc/bloc.dart';
import 'package:notify/models/notification.dart';
import 'package:notify/utils/db_heper.dart';

part 'notifications_state.dart';

class NotificationsCubit extends Cubit<NotificationsState> {
  NotificationsCubit() : super(NotificationLoadingListState()) {
    loadNotifications();
  }

  Future<void> loadNotifications() async {
    final loadedData = await DBHelper.getData("notifications");
    List<Notification> notifications = loadedData
        .map(
          (item) => Notification(
            id: item["id"] as String,
            title: item["title"] as String,
            body: item["body"] as String,
          ),
        )
        .toList();

    emit(NotificationsListState(notifications: notifications));
  }

  void addNotification(String id, String title, String body) async {
    if (state.notifications != null) {
      final newNotification = Notification(id: id, body: body, title: title);
      await DBHelper.insert(
          "notifications", {"id": id, "body": body, "title": title});

      emit(
        NotificationsListState(
          notifications: [newNotification, ...state.notifications!],
        ),
      );
    }
  }

  Notification? getNotificationById(String id) {
    if (state.notifications != null) {
      return state.notifications!.firstWhere((element) => element.id == id);
    }

    return null;
  }
}
