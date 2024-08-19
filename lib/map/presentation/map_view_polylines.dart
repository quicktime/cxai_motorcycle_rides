import 'dart:convert';
import 'package:cxai_motorcycle_rides/env/env.dart';
import 'package:cxai_motorcycle_rides/open_ai/open_ai_service.dart';
import 'package:cxai_motorcycle_rides/open_ai/prompt.dart.dart';
import 'package:cxai_motorcycle_rides/top_bar/data/ride_type_enum.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

class MapWithPolyline extends StatefulWidget {
  const MapWithPolyline({super.key});

  @override
  MapWithPolylineState createState() => MapWithPolylineState();
}

class MapWithPolylineState extends State<MapWithPolyline> {
  Set<Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];
  Set<Marker> markers = {};
  LatLng initialLocation = const LatLng(37.7747, -121.9735); // Starting location

  @override
  void initState() {
    super.initState();
    _fetchPolyline();
  }

  Future<void> _fetchPolyline() async {
    const String googleMapsApiKey = Env.googleMapsApiKey;

    final String url = await OpenAiService()
        .getMapsLinkFromPrompt(Prompt(initialLocation, '50', RideTypeEnum.twisty).generatePrompt());

    final response = await http.get(Uri.parse(url));
    final data = jsonDecode(response.body);
    // final String response = await rootBundle.loadString('assets/route.json');
    // final Map<String, dynamic> data = json.decode(response);

    if (data['status'] == 'OK') {
      final overviewPolyline = data['routes'][0]['overview_polyline']['points'];
      final geocodedWaypoints = data['geocoded_waypoints'];

      // Decode polyline
      PolylinePoints polylinePoints = PolylinePoints();
      List<PointLatLng> decodedPoints = polylinePoints.decodePolyline(overviewPolyline);

      // Convert to LatLng
      polylineCoordinates = decodedPoints.map((point) => LatLng(point.latitude, point.longitude)).toList();

      // Add geocoded waypoints as markers
      for (var waypoint in geocodedWaypoints) {
        final placeId = waypoint['place_id'];
        final latLng = await _getLatLngFromPlaceId(placeId, googleMapsApiKey);
        if (latLng != null) {
          setState(() {
            markers.add(Marker(
              markerId: MarkerId(placeId),
              position: latLng,
              infoWindow: InfoWindow(title: waypoint['geocoder_status'], snippet: waypoint['types'].join(', ')),
            ));
          });
        }
      }

      setState(() {
        polylines.add(Polyline(
          polylineId: const PolylineId('overview_polyline'),
          visible: true,
          points: polylineCoordinates,
          color: Colors.blue,
          width: 5,
        ));
      });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Map with Polyline')),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: initialLocation,
          zoom: 12,
        ),
        polylines: polylines,
        markers: {
          Marker(
            markerId: const MarkerId('start'),
            position: polylineCoordinates.isNotEmpty ? polylineCoordinates.first : initialLocation,
          ),
        }.union(markers),
        myLocationEnabled: true,
        myLocationButtonEnabled: false,
      ),
    );
  }
}
