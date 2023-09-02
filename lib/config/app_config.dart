import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/widgets.dart';
// import 'package:tcc/services/DatabaseTestApi.dart';

class SystemConfig {
  static Future<void> initialize() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
  }

  static void notificationConfig(){
    FirebaseMessaging.onBackgroundMessage((RemoteMessage message) async {
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    });

  }

  // static Future<void> runTests() async {
  //   final crudTestApi = DatabaseTestAPI();
  //   crudTestApi.runTests();
  // }
}