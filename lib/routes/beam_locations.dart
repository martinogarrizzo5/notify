import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:notify/screens/home_screen.dart';
import 'package:notify/screens/notification_details_screen.dart';

class HomeLocation extends BeamLocation {
  @override
  List<BeamPage> buildPages(
      BuildContext context, RouteInformationSerializable state) {
    return [
      HomeScreen.beamPage,
    ];
  }

  @override
  List<Pattern> get pathPatterns => [HomeScreen.path];
}

class NotificationDetailsLocation extends BeamLocation {
  @override
  List<BeamPage> buildPages(
      BuildContext context, RouteInformationSerializable state) {
    final pages = [
      HomeScreen.beamPage,
    ];

    final beamState = Beamer.of(context).currentBeamLocation.state as BeamState;
    final String? notificationId = beamState.pathParameters['id'];

    if (notificationId != null) {
      pages.add(
        BeamPage(
          key: ValueKey('notification-$notificationId'),
          child: NotificationDetailsScreen(notificationId: notificationId),
        ),
      );
    }

    return pages;
  }

  @override
  List<Pattern> get pathPatterns => ["/notifications/:id"];
}
