import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tcc/pages/login_page.dart';

import '../pages/home_page.dart';


class CommonButtons {

  FirebaseAuth _auth = FirebaseAuth.instance;

  void navigateToMainMenuScreen(BuildContext context) {
    if(_auth.currentUser == null){
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    }
  }

  Widget displayHomeButton(BuildContext context) {
    return Positioned(
      top: 16.0,
      left: 16.0,
      child: ElevatedButton(
        onPressed: () => navigateToMainMenuScreen(context),
        style: ElevatedButton.styleFrom(
          shape: const CircleBorder(),
          backgroundColor: Colors.blue,
          padding: const EdgeInsets.all(16),
        ),
        child: const Icon(Icons.arrow_back),
      ),
    );
  }

}