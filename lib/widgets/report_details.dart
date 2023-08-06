import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:location/location.dart';
import 'package:tcc/services/report_service.dart';
import 'package:tcc/util/conversion_util.dart';
import 'package:tcc/util/location_util.dart';
import 'package:tcc/util/map_util.dart';

import '../domain/report.dart';

class ReportDetails {
  LocationUtil locationUtil = LocationUtil();
  ConversionUtil conversionUtil = ConversionUtil();
  MapUtil mapUtil = MapUtil();
  ReportService reportService = ReportService();
  final Function(Report) onReportStatusChanged;
  final GlobalKey<State> key;

  ReportDetails({required this.key, required this.onReportStatusChanged});

  Future openReportDetails(BuildContext context, Report report,
      LocationData userLocation, List<Marker> markers, bool isAdm) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Report Details'),
                const SizedBox(height: 10),
                Text('Animal Kind: ${report.animalKind}'),
                const SizedBox(height: 10),
                Text('Description: ${report.message ?? 'N/A'}'),
                const SizedBox(height: 10),
                Text(
                    'Distancia: ${locationUtil.formatAndCalculateDistance(userLocation, report.location)}'),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Text('Caso resolvido: ${report.solved ? 'Sim' : 'Não'}'),
                    // Exibir botao caso ong
                    if (isAdm)
                      TextButton(
                        onPressed: () {
                          reportService.setSolvedReport(report, true);
                          report.solved = true;
                          Navigator.of(context).pop();
                          onReportStatusChanged(report);
                        },
                        child: const Text('Marcar como resolvido'),
                      ),
                  ],
                ),
                const SizedBox(height: 10),
                if(report.ongId != null)
                  Flexible(
                    child: Text(
                      'Resgate realizado pela ONG: ${report.ongId}',
                      overflow: TextOverflow.ellipsis, // Handle long text gracefully
                    ),
                  ),
                const SizedBox(height: 10),
                Container(
                  height: 200,
                  child: mapUtil.displayMap(
                      conversionUtil.geoPointToLatLng(report.location),
                      markers),
                ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Close'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
