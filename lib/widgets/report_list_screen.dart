import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:tcc/domain/report.dart';
import 'package:tcc/services/report_service.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:tcc/util/conversion_util.dart';
import 'package:tcc/util/location_util.dart';
import 'package:tcc/widgets/report_details.dart';

import '../domain/enumeration/AnimalKind.dart';

class ReportListScreen extends StatefulWidget {
  @override
  _ReportListScreenState createState() => _ReportListScreenState();
}

class _ReportListScreenState extends State<ReportListScreen> {
// =============================================================================
//                          Services and Widgets
// =============================================================================

  final ReportService reportService = ReportService();
  final ConversionUtil conversionUtil = ConversionUtil();
  final LocationUtil locationUtil = LocationUtil();
  final ReportDetails reportDetails = ReportDetails();

// =============================================================================
//                              Variables
// =============================================================================

  AnimalKind? selectedAnimalKind;
  List<Report> reports = [];
  late LocationData currentLocation;
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Report List'),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      fetchReports(null);
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(Icons.search),
                        SizedBox(width: 8),
                        Text('Buscar'),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                ElevatedButton.icon(
                  onPressed: () {
                    showFilterDialog();
                  },
                  icon: const Icon(Icons.filter_list),
                  label: const Text('Filtros'),
                ),
              ],
            ),
          ),
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
                      ' ${report.message}\n Distancia: ${locationUtil.formatAndCalculateDistance(currentLocation, report.location)}'),
                  onTap: () {
                    markLocation(
                        conversionUtil.geoPointToLatLng(report.location));
                    reportDetails.openReportDetails(
                        context, report, currentLocation, markers);
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

  void showFilterDialog() {
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
                fetchReports(selectedAnimalKind);
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

  Future<void> fetchReports(AnimalKind? animalKind) async {
    List<Report> unsolvedReports =
        await reportService.getUnsolvedReports(animalKind);

    if (currentLocation != null) {
      unsolvedReports = locationUtil.sortReportsByDistanceFromLocation(
          unsolvedReports, currentLocation);
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
