import 'dart:math';

import 'package:notify/models/notification.dart';
import "package:sqflite/sqflite.dart";
import "package:path/path.dart" as path;

class DBHelper {
  static Future<Database> notificationsDatabase() async {
    final dbPath = await getDatabasesPath();
    final sqlDb = await openDatabase(
      path.join(dbPath, "notifications.db"),
      onCreate: (db, version) {
        return db.execute(
            "CREATE TABLE notifications(id TEXT PRIMARY KEY, title TEXT, body TEXT)");
      },
      version: 1,
    );

    return sqlDb;
  }

  static Future<void> insert(String table, Map<String, Object> data) async {
    final db = await DBHelper.notificationsDatabase();
    db.insert(table, data);
  }

  static Future<void> updateNotification(String id) async {
    final db = await DBHelper.notificationsDatabase();
    db.update(
      "notifications",
      {"body": Random().nextInt(1000).toString()},
      where: "id = ?",
      whereArgs: [id],
    );
  }

  static Future<List<Map<String, Object?>>> getData(String table) async {
    final db = await DBHelper.notificationsDatabase();
    final data = await db.query(table);

    return data;
  }

  static Future<Map<String, Object?>?> getNotificationData(String id) async {
    final db = await DBHelper.notificationsDatabase();
    final data =
        await db.query("notifications", where: "id = ?", whereArgs: [id]);

    if (data.isEmpty) {
      return null;
    }

    return data.first;
  }

  static Future<int> deleteById(String table, String id) async {
    final db = await DBHelper.notificationsDatabase();
    return db.delete(table, where: "id = ?", whereArgs: [id]);
  }
}
