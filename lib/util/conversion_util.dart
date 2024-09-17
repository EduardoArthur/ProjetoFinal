import 'dart:math';
import 'package:latlong2/latlong.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ConversionUtil {

  double degreesToRadians(double degrees) {
    return degrees * (pi / 180.0);
  }

  LatLng geoPointToLatLng(GeoPoint location){
    return LatLng(location.latitude, location.longitude);
  }

}