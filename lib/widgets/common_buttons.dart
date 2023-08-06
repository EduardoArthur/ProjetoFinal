import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tcc/pages/login_page.dart';
import 'package:tcc/pages/ong_home_page.dart';

import '../pages/home_page.dart';


class CommonButtons {

  void navigateToMainMenuScreen(BuildContext context, User? user) {
    if (user == null){
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    } else if (user.displayName == null){
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } else if (user.displayName != null){
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => OngHomePage()),
      );
    }
  }

  Widget displayHomeButton(BuildContext context, User? user) {
    return Positioned(
      top: 16.0,
      left: 16.0,
      child: ElevatedButton(
        onPressed: () => navigateToMainMenuScreen(context, user),
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