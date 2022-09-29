import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  final List<String> notifications;

  const HomeScreen(this.notifications, {Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: ListView(
        children: widget.notifications
            .map(
              (el) => Card(
                child: ListTile(
                  onTap: () {},
                  title: Text(el),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
