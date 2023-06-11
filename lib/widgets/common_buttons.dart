import 'package:flutter/material.dart';

import 'home_page.dart';


class CommonButtons {

  void navigateToMainMenuScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => HomePage()),
    );
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