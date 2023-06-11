import 'package:flutter/material.dart';
import 'package:tcc/widgets/home_page.dart';

import 'config/app_config.dart';

void main() async {
  await SystemConfig.initialize();
  // await SystemConfig.runTests();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TCC',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}