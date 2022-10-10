import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:notify/main.dart';
import "../database/database.dart";

part 'notifications_state.dart';

class NotificationsCubit extends Cubit<NotificationsState> {
  NotificationsCubit() : super(NotificationLoadingListState()) {
    db.getAllNotifications().listen((notifications) {
      emit(NotificationsListState(notifications: notifications));
    });
  }

  void addNotification(String id, String title, String body) async {
    if (state is NotificationsListState) {
      final listState = state as NotificationsListState;
      final newNotification = Notification(id: id, body: body, title: title);
      int addedRows = await db.insertNotification(newNotification);
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

  // Future<void> deleteNotificationById(String id) async {
  //   if (state is NotificationsListState) {
  //     final listState = state as NotificationsListState;

  //     int deletedRows = await db.deleteNotificationById(id);
  //     if (deletedRows != 1) {
  //       throw Exception("Error deleting notification");
  //     }
  //     emit(
  //       NotificationsListState(
  //         notifications: listState.notifications
  //             .where((element) => element.id != id)
  //             .toList(),
  //       ),
  //     );
  //   }
  // }
}
