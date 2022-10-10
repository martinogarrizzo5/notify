import 'dart:io';

import 'package:drift/drift.dart';
// These imports are only needed to open the database
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'database.g.dart';

@DriftDatabase(
  // relative import for the drift file. Drift also supports `package:`
  // imports
  include: {'tables.drift'},
)
class AppDb extends _$AppDb {
  AppDb() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  Stream<List<Notification>> getAllNotifications() {
    return select(notifications).watch();
  }

  Stream<Notification?> getNotificationById(String id) {
    return (select(notifications)
          ..where(
            (t) => t.id.equals(id),
          ))
        .watchSingleOrNull();
  }

  Future<int> insertNotification(Notification notification) {
    return into(notifications).insert(notification);
  }

  Future<void> updateNotificationById(
      {required String id, required String title}) {
    return (update(notifications)..where((item) => item.id.equals(id)))
        .write(Notification(id: id, title: title));
  }

  Future<int> deleteNotificationById(String id) {
    return (delete(notifications)
          ..where(
            (item) => item.id.equals(id),
          ))
        .go();
  }
}

LazyDatabase _openConnection() {
  // the LazyDatabase util lets us find the right location for the file async.
  return LazyDatabase(() async {
    // put the database file, called db.sqlite here, into the documents folder
    // for your app.
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'notifications.db'));
    return NativeDatabase(file);
  });
}
