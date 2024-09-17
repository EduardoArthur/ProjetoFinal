import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/flutter_map.dart';

class MapUtil {

  Widget displayMap(LatLng location, List<Marker> markers) {
    return FlutterMap(
      options: MapOptions(
        center: location,
        zoom: 16.5,
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
          subdomains: const ['a', 'b', 'c'],
        ),
        MarkerLayer(markers: markers),
        CircleLayer(circles: buildCircleMarkers(markers)),
      ],
    );
  }

  List<CircleMarker> buildCircleMarkers(List<Marker> markers) {
    return markers.map((marker) {
      final point = marker.point;
      const circleRadius = 50.0;
      return CircleMarker(
        point: point,
        color: Colors.blue.withOpacity(0.3),
        borderStrokeWidth: 1.5,
        borderColor: Colors.blue,
        radius: circleRadius,
      );
    }).toList();
  }

}
