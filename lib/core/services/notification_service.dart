import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationService {
  final FirebaseMessaging _messaging =
      FirebaseMessaging.instance;

  Future<void> initialize() async {

    await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    final token =
        await _messaging.getToken();

    print("FCM TOKEN");
    print(token);

    FirebaseMessaging.onMessage.listen((message) {
      print(message.notification?.title);
      print(message.notification?.body);
    });
  }
}