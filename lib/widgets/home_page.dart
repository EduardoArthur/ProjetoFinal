import 'package:flutter/material.dart';
import 'package:tcc/widgets/report_list_screen.dart';
import 'package:tcc/widgets/find_animals.dart';

import 'report_lost_animal.dart';

class HomePage extends StatelessWidget {

// =============================================================================
//                               Constants
// =============================================================================

  // Fonts
  static const fontSize = 18.0;
  static const fontWeight = FontWeight.bold;
  static const labelColor = Colors.white;

  // Buttons
  static const buttonColor = Colors.blue;
  static const borderRadius = 8.0;
  static const iconSize = 24.0;
  static const verticalPadding = 16.0;
  static const horizontalPadding = 32.0;

  // Space between buttons
  static const sizedBoxHeight = 24.0;

// =============================================================================
//                              Build
// =============================================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Main Menu'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Buttons
            reportarAnimal(context),
            const SizedBox(height: sizedBoxHeight),
            exibirDenuncias(context),
            const SizedBox(height: sizedBoxHeight),
            mostrarLista(context),
          ],
        ),
      ),
    );
  }

  Widget reportarAnimal(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ReportLostAnimal(),
          ),
        );
      },
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: verticalPadding, horizontal: horizontalPadding),
        backgroundColor: buttonColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
      icon: const Icon(
        Icons.map,
        size: iconSize,
        color: labelColor,
      ),
      label: const Text(
        'Reportar animal',
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: labelColor,
        ),
      ),
    );
  }

  Widget exibirDenuncias(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FindAnimals(),
          ),
        );
      },
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: verticalPadding, horizontal: horizontalPadding),
        backgroundColor: buttonColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
      icon: const Icon(
        Icons.search,
        size: iconSize,
        color: labelColor,
      ),
      label: const Text(
        'Exibir Denuncias',
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: labelColor,
        ),
      ),
    );
  }

  Widget mostrarLista(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ReportListScreen(),
          ),
        );
      },
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: verticalPadding, horizontal: horizontalPadding),
        backgroundColor: buttonColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
      icon: const Icon(
        Icons.search,
        size: iconSize,
        color: labelColor,
      ),
      label: const Text(
        'mostrar lista',
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: labelColor,
        ),
      ),
    );
  }
}