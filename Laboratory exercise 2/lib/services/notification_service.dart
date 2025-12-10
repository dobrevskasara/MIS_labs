import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import '../main.dart';

class NotificationService extends StatefulWidget {
  final Widget child;

  const NotificationService({super.key, required this.child});

  @override
  State<NotificationService> createState() => _NotificationServiceState();
}

class _NotificationServiceState extends State<NotificationService> {
  @override
  void initState() {
    super.initState();

    FirebaseMessaging.instance.getInitialMessage().then((msg) {
      if (msg != null) {
        _handleMessage(msg);
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);

    FirebaseMessaging.onMessage.listen((msg) {
      print("Foreground: ${msg.notification?.title}");
    });
  }

  void _handleMessage(RemoteMessage msg) {
    print("Handle message: ${msg.data}");

    if (msg.data['type'] == 'recipe') {
      Navigator.pushNamed(
        navigatorKey.currentContext!,
        '/randomMeal',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}