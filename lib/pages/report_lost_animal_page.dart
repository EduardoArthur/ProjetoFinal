import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:location/location.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

import '../domain/report.dart';

import '../services/report_service.dart';
import '../services/auth_service.dart';

import '../widgets/common_widgets.dart';
import '../widgets/pop_ups.dart';
import '../widgets/report_dialog.dart';

class ReportLostAnimalPage extends StatefulWidget {
  @override
  _ReportLostAnimalPageState createState() => _ReportLostAnimalPageState();
}

class _ReportLostAnimalPageState extends State<ReportLostAnimalPage> {

// =============================================================================
//                          Services and Widgets
// =============================================================================

  final reportService = ReportService();
  final commonButtons = CommonWidgets();
  final popUps = PopUps();


// =============================================================================
//                              Variables
// =============================================================================

  LocationData? currentLocation;
  List<Marker> markers = [];
  bool showForm = false;
  bool showButton = true;
  bool isLoading = false;

// =============================================================================
//                          Init State and Build
// =============================================================================

  @override
  void initState() {
    super.initState();
    getCurrentLocation();
    popUps.showMapInstructions(context);
  }

  @override
  Widget build(BuildContext context) {
    AuthService auth = Provider.of<AuthService>(context);
    return currentLocation != null
        ? buildMap(context, auth.usuario)
        : const Center(
        child:
        CircularProgressIndicator());
  }

  Widget buildMap(BuildContext context, User? user) {
    return Scaffold(
      body: Stack(
        children: [
          displayMap(),
          commonButtons.displayHomeButton(context, user),
          if (showButton) displayReportButton(),
          if (showForm) showReportDialog(context, user),
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
      const circleRadius = 50.0;
      return CircleMarker(
        point: point,
        color: Colors.blue
            .withOpacity(0.3),
        borderStrokeWidth: 1.5,
        borderColor: Colors.blue,
        radius: circleRadius,
      );
    }).toList();
  }

// =============================================================================
//                               Dialogs
// =============================================================================

  Widget showReportDialog(BuildContext context, User? user) {
    return isLoading ?
    const Center(child: CircularProgressIndicator())
    :
    ReportDialog(
      onSubmit: (selectedAnimalKind, description, imgUrl) async {

        setState(() {
          isLoading = true;
        });

        String urlFirebase = await uploadImageToFirebase(imgUrl);

        // Build and save a new report
        Report report = reportService.buildNewReport(
          user, markers.last.point, selectedAnimalKind, description, urlFirebase);
        reportService.createNewReport(report, user);

        setState(() {
          isLoading = false;
        });

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
        content: Text('Caso registrado com sucesso!'),
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
        child: const Text('Reportar'),
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

  // Upload Image to firebase
  Future<String> uploadImageToFirebase(String imageFile) async {
    try {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference reference = FirebaseStorage.instance.ref().child('images/$fileName');
      UploadTask uploadTask = reference.putFile(File(imageFile));

      TaskSnapshot taskSnapshot = await uploadTask;
      String imageUrl = await taskSnapshot.ref.getDownloadURL();

      return imageUrl;
    } catch (e) {
      print('Error uploading image to Firebase: $e');
      return '';
    }
  }

}