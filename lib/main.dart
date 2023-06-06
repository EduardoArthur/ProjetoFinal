import 'package:flutter/material.dart';
import 'package:tcc/services/map_service.dart';

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

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Map Demo'),
      ),
      body: MapService(), // Use the MapService widget as the body of the home page
    );
  }
}