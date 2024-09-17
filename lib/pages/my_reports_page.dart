import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:intl/intl.dart';

import '../domain/report.dart';
import '../domain/enumeration/AnimalKind.dart';

import '../services/report_service.dart';
import '../services/auth_service.dart';

import '../util/conversion_util.dart';
import '../util/location_util.dart';
import '../widgets/report_details.dart';




class MyReportsPage extends StatefulWidget {
  @override
  _MyReportsPageState createState() => _MyReportsPageState();
}

class _MyReportsPageState extends State<MyReportsPage> {
// =============================================================================
//                          Services and Widgets
// =============================================================================

  final ReportService reportService = ReportService();
  final ConversionUtil conversionUtil = ConversionUtil();
  final LocationUtil locationUtil = LocationUtil();
  final GlobalKey<State> _dialogKey = GlobalKey<State>();

// =============================================================================
//                              Variables
// =============================================================================

  AnimalKind? selectedAnimalKind;
  List<Report> reports = [];
  LocationData? currentLocation;
  List<Marker> markers = [];

// =============================================================================
//                          Init State and Build
// =============================================================================
  @override
  void initState() {
    super.initState();
    getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    getUser();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meus Casos'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: reports.length,
              itemBuilder: (BuildContext context, int index) {
                final Report report = reports[index];
                return ListTile(
                  title: Text(
                    report.animalKind,
                    style: const TextStyle(),
                  ),
                  subtitle: Text(
                      ' ${DateFormat('dd/MM/yyyy HH:mm:ss').format(report.timestamp!.toDate())} \n ${report.message}\n Distância: ${locationUtil.formatAndCalculateDistance(currentLocation!, report.location)}'),
                  onTap: () {
                    markLocation(
                        conversionUtil.geoPointToLatLng(report.location));
                    if(currentLocation != null) {
                      ReportDetails(key: _dialogKey, onReportStatusChanged: (Report) {}).openReportDetails(
                          context, report, currentLocation!, markers, false);
                    }
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

// =============================================================================
//                               Dialogs
// =============================================================================

  void showFilterDialog(User? user) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Filtros'),
          content: DropdownButtonFormField<AnimalKind>(
            value: selectedAnimalKind,
            onChanged: (AnimalKind? newValue) {
              setState(() {
                selectedAnimalKind = newValue;
              });
            },
            items: AnimalKind.values
                .map<DropdownMenuItem<AnimalKind>>((AnimalKind kind) {
              return DropdownMenuItem<AnimalKind>(
                value: kind,
                child: Text(kind.name),
              );
            }).toList(),
            decoration: const InputDecoration(
              labelText: 'Animal Kind',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                fetchReports(user);
                Navigator.of(context).pop();
              },
              child: const Text('Filtrar'),
            ),
          ],
        );
      },
    );
  }

// =============================================================================
//                             Functions
// =============================================================================

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

  getUser() {
    if(currentLocation != null && reports.isEmpty) {
      AuthService auth = Provider.of<AuthService>(context);
      fetchReports(auth.usuario);
    }
  }

  Future<void> fetchReports(User? user) async {
    List<Report> unsolvedReports =
    await reportService.getReportsByUser(user);

    if (currentLocation != null) {
      unsolvedReports = locationUtil.sortReportsByDistanceFromLocation(
          unsolvedReports, currentLocation!);
    }

    setState(() {
      reports = unsolvedReports;
    });
  }

  void markLocation(LatLng location) {
    setState(() {
      markers = [
        Marker(
          width: 80.0,
          height: 80.0,
          point: location,
          builder: (ctx) => const Icon(Icons.location_on, color: Colors.red),
        ),
      ];
    });
  }
}
