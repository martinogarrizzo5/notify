import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:notify/screens/home_screen.dart';
import 'package:notify/screens/notification_details_screen.dart';

import "../models/notification.dart" as notif_model;

class RouteConfig {
  final String route;
  final notif_model.Notification? selectedNotification;

  RouteConfig.home()
      : route = "/",
        selectedNotification = null;

  RouteConfig.notificationDetailsScreen(notif_model.Notification notification)
      : route = "/notification-details",
        selectedNotification = notification;

  RouteConfig.unknow()
      : route = "/",
        selectedNotification = null;
}

class AppRouterDelegate extends RouterDelegate<RouteConfig>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<RouteConfig> {
  GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  GlobalKey<NavigatorState> get navigatorKey => _navigatorKey;

  String? _route;
  set route(String value) {
    if (_route == value) return;
    _route = value;
    notifyListeners();
  }

  notif_model.Notification? _selectedNotification;
  void setSelectedNotification(notif_model.Notification? notification) {
    _selectedNotification = notification;
    notifyListeners();
  }

  @override
  Future<void> setNewRoutePath(RouteConfig configuration) async {
    _route = configuration.route;
    _selectedNotification = configuration.selectedNotification;
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: _navigatorKey,
      pages: [
        // MaterialPage(
        //   key: ValueKey("home"),
        //   child: HomeScreen([
        //     notif_model.Notification(
        //       id: "1234",
        //       title: "Titolo",
        //       body: "Corppo",
        //     )
        //   ]),
        // ),
        if (_route == "notification-details" && _selectedNotification != null)
          MaterialPage(
            key: ValueKey("notificationDetailsScreen"),
            child: NotificationDetailsScreen(
              notification: _selectedNotification!,
            ),
          ),
      ],
      onPopPage: (route, result) {
        if (!route.didPop(result)) {
          return false;
        }
        if (_selectedNotification != null) {
          setSelectedNotification(null);
        }

        return true;
      },
    );
  }
}

class AppRouteInformationParser extends RouteInformationParser<RouteConfig> {
  @override
  Future<RouteConfig> parseRouteInformation(
      RouteInformation routeInformation) async {
    final String? routeName = routeInformation.location;
    print(routeName);

    if (routeName == '/') {
      return RouteConfig.home();
    }
    if (routeName == '/notification-details') {
      return RouteConfig.notificationDetailsScreen(
          routeInformation.state as notif_model.Notification);
    }

    return RouteConfig.unknow();
  }

  @override
  RouteInformation? restoreRouteInformation(RouteConfig configuration) {
    RouteInformation error = RouteInformation(location: '/404');
    if (configuration.route == null) {
      return error;
    }

    switch (configuration.route) {
      case "/":
        return RouteInformation(location: '/');
      case "/notification-details":
        return RouteInformation(
          location: '/notification-details',
          state: configuration.selectedNotification,
        );
      default:
        return error;
    }
  }
}
