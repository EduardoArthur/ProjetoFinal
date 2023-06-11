import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:location/location.dart';
import 'package:latlong2/latlong.dart';

import 'package:tcc/domain/report.dart';
import 'package:tcc/domain/user.dart';

import 'package:tcc/services/report_service.dart';

import 'package:tcc/widgets/common_buttons.dart';
import 'package:tcc/widgets/report_dialog.dart';

class ReportLostAnimal extends StatefulWidget {
  @override
  _ReportLostAnimalState createState() => _ReportLostAnimalState();
}

class _ReportLostAnimalState extends State<ReportLostAnimal> {

// =============================================================================
//                          Services and Widgets
// =============================================================================

  final reportService = ReportService();
  final commonButtons = CommonButtons();

// =============================================================================
//                              Variables
// =============================================================================

  LocationData? currentLocation;
  List<Marker> markers = [];
  bool showForm = false;
  bool showButton = true;
  late User userTeste;

// =============================================================================
//                          Init State and Build
// =============================================================================

  @override
  void initState() {
    super.initState();
    getCurrentLocation();
    getUser();
  }

  void getUser() {
    userTeste = User(id: 'docIdTeste', name: 'teste', email: 'teste@teste.com');
  }

  @override
  Widget build(BuildContext context) {
    return currentLocation != null
        ? buildMap(context)
        : const Center(
        child:
        CircularProgressIndicator()); // Show a progress indicator while fetching the location
  }

  Widget buildMap(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          displayMap(),
          commonButtons.displayHomeButton(context),
          if (showButton) displayReportButton(),
          if (showForm) showReportDialog(context),
        ],
      ),
    );
  }

// =============================================================================
//                              Build Map
// =============================================================================

  Widget displayMap() {
    return FlutterMap(
      options: MapOptions(
        onTap: (tapPosition, tappedLatLng) =>
            handleMapTap(tapPosition, tappedLatLng),
        center: LatLng(currentLocation?.latitude ?? 0.0,
            currentLocation?.longitude ?? 0.0),
        zoom: 16.5,
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
          subdomains: const ['a', 'b', 'c'],
        ),
        MarkerLayer(markers: markers),
        CircleLayer(circles: buildCircleMarkers()),
      ],
    );
  }

  List<CircleMarker> buildCircleMarkers() {
    return markers.map((marker) {
      final point = marker.point;
      const circleRadius = 50.0; // Adjust the radius as desired
      return CircleMarker(
        point: point,
        color: Colors.blue
            .withOpacity(0.3), // Adjust the color and opacity as desired
        borderStrokeWidth: 1.5,
        borderColor: Colors.blue,
        radius: circleRadius,
      );
    }).toList();
  }

// =============================================================================
//                               Dialogs
// =============================================================================

  Widget showReportDialog(BuildContext context) {
    return ReportDialog(
      onSubmit: (selectedAnimalKind, description) {

        // Build and save a new report
        Report report = reportService.buildNewReport(
            userTeste, markers.last.point, selectedAnimalKind!, description);
        reportService.createNewReport(report, userTeste);

        // Close the dialog
        closeForm();

        // Show success message
        showSuccessMessage(context);
      },
      onCancel: () {
        closeForm();
      },
    );
  }

  void showSuccessMessage(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Denuncia registrada com sucesso!'),
        backgroundColor: Colors.green,
      ),
    );
  }

// =============================================================================
//                              Buttons
// =============================================================================

  Widget displayReportButton() {
    bool isButtonDisabled = markers.isEmpty;

    return Positioned(
      top: 16.0,
      right: 16.0,
      child: ElevatedButton(
        onPressed: isButtonDisabled ? null : openForm,
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith<Color>(
            (Set<MaterialState> states) {
              if (states.contains(MaterialState.disabled)) {
                return Colors.grey; // Set disabled button color
              }
              return Colors.blue; // Set enabled button color
            },
          ),
        ),
        child: const Text('Denunciar'),
      ),
    );
  }

// =============================================================================
//                             Functions
// =============================================================================

  // Set state controller for popup and button

  // if the form is being displayed, the button must be hidden
  void openForm() {
    setState(() {
      showForm = true;
      showButton = false;
    });
  }

  // if the form is closed, the button must be displayed
  void closeForm() {
    setState(() {
      showForm = false;
      showButton = true;
    });
  }

  // Set marker on taped position
  void handleMapTap(TapPosition? tapPosition, LatLng tappedLatLng) {
    setState(() {
      markers = [
        Marker(
          width: 80.0,
          height: 80.0,
          point: tappedLatLng,
          builder: (ctx) => const Icon(Icons.location_on, color: Colors.red),
        ),
      ];
    });
  }

  // Get user phone current location if given access
  Future<void> getCurrentLocation() async {
    final location = Location();

    try {
      final permissionStatus = await location.requestPermission();

      if (permissionStatus == PermissionStatus.granted) {
        final currentLocationData = await location.getLocation();
        setState(() {
          currentLocation = currentLocationData;
        });
      } else {
        print('Location permission not granted');
      }
    } catch (e) {
      print('Error getting current location: $e');
    }
  }

}