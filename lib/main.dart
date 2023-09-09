import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../pages/login_page.dart';
import '../services/auth_service.dart';

import 'config/app_config.dart';

void main() async {
  await SystemConfig.initialize();
  // await SystemConfig.runTests();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthService()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pet Resgate',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(),
    );
  }
}