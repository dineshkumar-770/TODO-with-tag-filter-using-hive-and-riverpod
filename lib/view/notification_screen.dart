import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_demo_todo/notification/notification.dart';

class NotificationUI extends StatefulWidget {
  const NotificationUI({super.key});

  @override
  State<NotificationUI> createState() => _NotificationUIState();
}

class _NotificationUIState extends State<NotificationUI> {
  listenActionStream() {
    AwesomeNotifications();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    listenActionStream();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification'),
      ),
      body: Center(
        child: CupertinoButton(
          onPressed: () {
            Notify.instantNotify();
          },
          child: const Text('Notification'),
        ),
      ),
    );
  }
}
