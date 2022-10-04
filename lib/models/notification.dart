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
}
