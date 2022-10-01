import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notify/cubit/notifications_cubit.dart';

class HomeScreen extends StatefulWidget {
  static const path = "/";
  static const beamPage = BeamPage(key: ValueKey('home'), child: HomeScreen());

  const HomeScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Image.asset(
              "assets/notify-logo.png",
              height: 150,
            ),
            BlocBuilder<NotificationsCubit, NotificationsState>(
              builder: (context, state) {
                return Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(8),
                    children: state.notifications!
                        .map(
                          (notification) => Container(
                            margin: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.yellow[50],
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.15),
                                  spreadRadius: 1,
                                  blurRadius: 2,
                                  offset: const Offset(0, 0),
                                ),
                              ],
                            ),
                            child: ListTile(
                              onTap: () => Beamer.of(context).beamToNamed(
                                "/notifications/${notification.id}",
                              ),
                              leading: Icon(
                                Icons.notifications,
                                color: Color(0xFFFF006F),
                              ),
                              title: Text(notification.title),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
