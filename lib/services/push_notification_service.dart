import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotificationService {

  Future<void> sendNotificationToUser(String? userFcmToken, String title, String message) async {

    if (userFcmToken == null) {
      return;
    }

    final FirebaseMessaging messaging = FirebaseMessaging.instance;

    await messaging.sendMessage(
      to: userFcmToken,
      data: {
        'title': title,
        'body': message,
      },
    );
  }

}