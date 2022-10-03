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

  static Future<List<Map<String, Object?>>> getData(String table) async {
    final db = await DBHelper.notificationsDatabase();
    final data = await db.query(table);

    return data;
  }
}
