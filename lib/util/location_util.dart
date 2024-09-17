import 'dart:math';
import 'package:latlong2/latlong.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:location/location.dart';

import '../util/conversion_util.dart';

import '../domain/report.dart';

class LocationUtil {

  ConversionUtil conversionUtil = ConversionUtil();

  List<Report> sortReportsByDistanceFromLocation(List<Report> reports, LocationData userLocation){
    reports.sort((a, b) {
      final double distanceToA =
      calculateDistance(userLocation, a.location);
      final double distanceToB =
      calculateDistance(userLocation, b.location);
      return distanceToA.compareTo(distanceToB);
    });

    return reports;
  }

  double calculateDistance(LocationData from, GeoPoint to) {
    const int earthRadius = 6371; // in kilometers
    final double lat1 = from.latitude!;
    final double lon1 = from.longitude!;
    final double lat2 = to.latitude;
    final double lon2 = to.longitude;

    final double dLat = conversionUtil.degreesToRadians(lat2 - lat1);
    final double dLon = conversionUtil.degreesToRadians(lon2 - lon1);

    final double a = pow(sin(dLat / 2), 2) +
        cos(conversionUtil.degreesToRadians(lat1)) *
            cos(conversionUtil.degreesToRadians(lat2)) *
            pow(sin(dLon / 2), 2);
    final double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    final double distance = earthRadius * c;

    return distance;
  }

  String formatDistance(double distanceInKm) {
    if (distanceInKm < 1.0) {
      // Converter para metros
      int distanceInMeters = (distanceInKm * 1000).toInt();
      return '$distanceInMeters m';
    } else {
      // Manter em quilômetros com uma casa decimal
      String formattedDistance = distanceInKm.toStringAsFixed(1);
      return '$formattedDistance km';
    }
  }

  String formatAndCalculateDistance(LocationData from, GeoPoint to) {
    final double distance = calculateDistance(from, to);
    return formatDistance(distance);
  }

}