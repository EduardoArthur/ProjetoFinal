import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:location/location.dart';
import 'package:latlong2/latlong.dart';


class MapService extends StatefulWidget {
  @override
  _MapServiceState createState() => _MapServiceState();
}

class _MapServiceState extends State<MapService> {
  LocationData? currentLocation;
  List<Marker> markers = [];

  @override
  void initState() {
    super.initState();
    getCurrentLocation();
  }

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

  void handleMapTap(TapPosition? tapPosition, LatLng tappedLatLng) {
    final tappedLocation = LocationData.fromMap({
      "latitude": tappedLatLng.latitude,
      "longitude": tappedLatLng.longitude,
    });

    setState(() {
      markers = [
        Marker(
          width: 80.0,
          height: 80.0,
          point: tappedLatLng,
          builder: (ctx) => Container(
            child: Icon(Icons.location_on, color: Colors.red),
          ),
        ),
      ];
    });

    print('Tapped location: ${tappedLocation.latitude}, ${tappedLocation.longitude}');
  }

  List<CircleMarker> buildCircleMarkers() {
    return markers.map((marker) {
      final point = marker.point;
      final circleRadius = 50.0; // Adjust the radius as desired
      return CircleMarker(
        point: point,
        color: Colors.blue.withOpacity(0.3), // Adjust the color and opacity as desired
        borderStrokeWidth: 1.5,
        borderColor: Colors.blue,
        radius: circleRadius,
      );
    }).toList();
  }

  Widget buildMap() {
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
          subdomains: ['a', 'b', 'c'],
        ),
        MarkerLayer(markers: markers),
        CircleLayer(circles: buildCircleMarkers()),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return currentLocation != null
        ? buildMap()
        : Center(child: CircularProgressIndicator()); // Show a progress indicator while fetching the location
  }

}