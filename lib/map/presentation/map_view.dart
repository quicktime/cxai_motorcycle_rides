import 'dart:convert';
import 'package:cxai_motorcycle_rides/env/env.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapView extends StatefulWidget {
  const MapView({super.key});

  @override
  MapViewState createState() => MapViewState();
}

class MapViewState extends State<MapView> {
  GoogleMapController? mapController;
  List<LatLng> polylineCoordinates = [];
  Set<Marker> markers = {};

  @override
  void initState() {
    super.initState();
    _getRoute();
  }

  Future<void> _getRoute() async {
    const String apiKey = Env.googleMapsApiKey;

    final String response = await rootBundle.loadString('assets/route.json');
    final Map<String, dynamic> data = json.decode(response);

    if (data['status'] == 'OK') {
      final List steps = data['routes'][0]['legs'][0]['steps'];
      final geocodedWaypoints = data['geocoded_waypoints'];

      for (var step in steps) {
        final polylinePoints = step['polyline']['points'];
        polylineCoordinates.addAll(_decodePolyline(polylinePoints));
      }

      setState(() {});

      // Add geocoded waypoints as markers
      for (var waypoint in geocodedWaypoints) {
        final placeId = waypoint['place_id'];
        final latLng = await _getLatLngFromPlaceId(placeId, apiKey);
        if (latLng != null) {
          setState(() {
            markers.add(Marker(
              markerId: MarkerId(placeId),
              position: latLng,
              icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
            ));
          });
        }
      }
    } else {
      print('Error: ${data['status']}');
    }
  }

  Future<LatLng?> _getLatLngFromPlaceId(String placeId, String apiKey) async {
    final url = 'https://maps.googleapis.com/maps/api/geocode/json?place_id=$placeId&key=$apiKey';
    final response = await http.get(Uri.parse(url));
    final data = jsonDecode(response.body);

    if (data['status'] == 'OK') {
      final location = data['results'][0]['geometry']['location'];
      return LatLng(location['lat'], location['lng']);
    }
    return null;
  }

  List<LatLng> _decodePolyline(String poly) {
    List<LatLng> points = [];
    int index = 0, len = poly.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = poly.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = poly.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      points.add(LatLng(lat / 1E5, lng / 1E5));
    }
    return points;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Motorcycle Route')),
      body: GoogleMap(
        initialCameraPosition: const CameraPosition(
          target: LatLng(37.7747, -121.9735),
          zoom: 12,
        ),
        polylines: {
          Polyline(
            polylineId: const PolylineId('route'),
            points: polylineCoordinates,
            color: Colors.blue,
            width: 5,
          ),
        },
        markers: {
          Marker(
            markerId: const MarkerId('start'),
            position: polylineCoordinates.isNotEmpty ? polylineCoordinates.first : const LatLng(37.7747, -121.9735),
          ),
          Marker(
            markerId: const MarkerId('end'),
            position: polylineCoordinates.isNotEmpty ? polylineCoordinates.last : const LatLng(37.7747, -121.9735),
          ),
        }.union(markers),
        onMapCreated: (GoogleMapController controller) {
          mapController = controller;
        },
      ),
    );
  }
}
