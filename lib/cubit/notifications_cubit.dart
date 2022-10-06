import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:notify/models/notification.dart';
import 'package:notify/utils/db_heper.dart';

part 'notifications_state.dart';

class NotificationsCubit extends Cubit<NotificationsState> {
  NotificationsCubit() : super(NotificationLoadingListState()) {
    loadNotifications();
  }

  Future<void> loadNotifications() async {
    final loadedData = await DBHelper.getData("notifications");
    List<Notification> notifications =
        loadedData.map((item) => Notification.fromMap(item)).toList();

    emit(NotificationsListState(notifications: notifications));
  }

  void addNotification(String id, String title, String body) async {
    if (state is NotificationsListState) {
      final listState = state as NotificationsListState;
      final newNotification = Notification(id: id, body: body, title: title);
      await DBHelper.insert(
          "notifications", {"id": id, "body": body, "title": title});

      emit(
        NotificationsListState(
          notifications: [newNotification, ...listState.notifications],
        ),
      );
    }
  }

  Notification? getNotificationById(String id) {
    if (state is NotificationsListState) {
      final listState = state as NotificationsListState;

      int index =
          listState.notifications.indexWhere((element) => element.id == id);
      if (index != -1) {
        return listState.notifications[index];
      }
    }

    return null;
  }

  Future<void> deleteNotificationById(String id) async {
    if (state is NotificationsListState) {
      final listState = state as NotificationsListState;

      int deletedRows = await DBHelper.deleteById("notifications", id);
      if (deletedRows != 1) {
        throw Exception("Error deleting notification");
      }
      emit(
        NotificationsListState(
          notifications: listState.notifications
              .where((element) => element.id != id)
              .toList(),
        ),
      );
    }
  }
}
