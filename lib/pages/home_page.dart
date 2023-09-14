import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../pages/login_page.dart';

import '../pages/my_reports_page.dart';
import '../pages/report_lost_animal_page.dart';
import '../services/auth_service.dart';
import '../widgets/common_widgets.dart';

class HomePage extends StatelessWidget {
// =============================================================================
//                               Constants
// =============================================================================

  final commonWidgets = CommonWidgets();

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

  // Labels
  static const labelReportLostAnimalPage = 'Reportar Animal Abandonado';
  static const labelSearchReportsPage = 'Buscar Casos';
  static const labelMyReportsPage = 'Meus Casos';
  static const labelExit = 'Sair';
  static const labelLogOut = 'Log out';

// =============================================================================
//                              Build
// =============================================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Menu Principal'),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              commonWidgets.showLogo(200, 200),
              // Buttons
              reportarAnimal(context),
              const SizedBox(height: sizedBoxHeight),
              mostrarLista(context),
              const SizedBox(height: sizedBoxHeight),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  exit(context),
                  logOut(context),
                ],
              ),
            ],
          ),
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
            builder: (context) => ReportLostAnimalPage(),
          ),
        );
      },
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(
            vertical: verticalPadding, horizontal: horizontalPadding),
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
        labelReportLostAnimalPage,
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
            builder: (context) => MyReportsPage(),
          ),
        );
      },
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(
            vertical: verticalPadding, horizontal: horizontalPadding),
        backgroundColor: buttonColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
      icon: const Icon(
        Icons.report,
        size: iconSize,
        color: labelColor,
      ),
      label: const Text(
        labelMyReportsPage,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: labelColor,
        ),
      ),
    );
  }

  Widget exit(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () {
        SystemNavigator.pop();
      },
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(
            vertical: verticalPadding, horizontal: horizontalPadding),
        backgroundColor: Colors.red,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
      icon: const Icon(
        Icons.close,
        size: iconSize,
        color: labelColor,
      ),
      label: const Text(
        labelExit,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: labelColor,
        ),
      ),
    );
  }

  Widget logOut(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () {
        context.read<AuthService>().logout();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LoginPage(),
          ),
        );
      },
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(
            vertical: verticalPadding, horizontal: horizontalPadding),
        backgroundColor: Colors.red,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
      icon: const Icon(
        Icons.logout,
        size: iconSize,
        color: labelColor,
      ),
      label: const Text(
        labelLogOut,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: labelColor,
        ),
      ),
    );
  }
}
