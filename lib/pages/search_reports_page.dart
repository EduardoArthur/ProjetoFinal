import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import '../domain/report.dart';
import '../services/report_service.dart';
import 'package:flutter_map/flutter_map.dart';
import '../util/conversion_util.dart';
import '../util/location_util.dart';
import '../widgets/report_details.dart';

import '../domain/enumeration/AnimalKind.dart';

class SearchReportsPage extends StatefulWidget {
  @override
  _SearchReportsPageState createState() => _SearchReportsPageState();
}

class _SearchReportsPageState extends State<SearchReportsPage> {
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
        title: const Text('Buscar Casos'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
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
                        Text('Buscar Todos'),
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
                  label: const Text('Filtrar'),
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
                    markLocation(conversionUtil.geoPointToLatLng(report.location));
                    ReportDetails(key: _dialogKey, onReportStatusChanged: _updateReportStatus).openReportDetails(context, report, currentLocation, markers, true);
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
    try {
      List<Report> unsolvedReports =
      await reportService.getUnsolvedReports(animalKind);

      if (currentLocation != null) {
        unsolvedReports = locationUtil.sortReportsByDistanceFromLocation(
            unsolvedReports, currentLocation);
      }

      setState(() {
        reports = unsolvedReports;
      });
    } catch(e){
      print('Error lazy: $e');
    }
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

  void _updateReportStatus(Report report) {
    ReportDetails(key: _dialogKey, onReportStatusChanged: _updateReportStatus).openReportDetails(context, report, currentLocation, markers, true);
  }
}
