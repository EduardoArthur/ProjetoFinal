import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:location/location.dart';
import 'package:tcc/util/conversion_util.dart';
import 'package:tcc/util/location_util.dart';
import 'package:tcc/util/map_util.dart';

import '../domain/report.dart';

class ReportDetails {

  LocationUtil locationUtil = LocationUtil();
  ConversionUtil conversionUtil = ConversionUtil();
  MapUtil mapUtil = MapUtil();

  Future openReportDetails(BuildContext context, Report report, LocationData userLocation, List<Marker> markers) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Report Details'),
                SizedBox(height: 10),
                Text('Animal Kind: ${report.animalKind}'),
                SizedBox(height: 10),
                Text('Description: ${report.message ?? 'N/A'}'),
                SizedBox(height: 10),
                Text(
                    'Distancia: ${locationUtil.formatAndCalculateDistance(userLocation, report.location)}'),
                SizedBox(height: 10),
                Container(
                  height: 200,
                  child: mapUtil.displayMap(
                      conversionUtil.geoPointToLatLng(report.location), markers),
                ),
                SizedBox(height: 10),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Close'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

}