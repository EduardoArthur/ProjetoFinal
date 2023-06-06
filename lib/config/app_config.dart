import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';
// import 'package:tcc/services/DatabaseTestApi.dart';

class SystemConfig {
  static Future<void> initialize() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
  }

  // static Future<void> runTests() async {
  //   final crudTestApi = DatabaseTestAPI();
  //   crudTestApi.runTests();
  // }
}