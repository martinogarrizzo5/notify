import 'package:flutter/cupertino.dart';

@immutable
class Notification {
  final String id;
  final String title;
  final String body;

  const Notification({
    required this.id,
    required this.title,
    required this.body,
  });

  factory Notification.fromMap(Map<String, dynamic> map) {
    return Notification(
      id: map['id'] as String,
      title: map['title'] as String,
      body: map['body'] as String,
    );
  }
}
