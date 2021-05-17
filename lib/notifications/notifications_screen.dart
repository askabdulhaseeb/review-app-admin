import 'package:admin_review/components/custom_app_bar.dart';
import 'package:flutter/material.dart';

class NotificationsScreen extends StatefulWidget {
  NotificationsScreen({Key key}) : super(key: key);

  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Push Notifications'),
      body: Container(),
    );
  }
}
