import 'dart:async';
import 'dart:convert';
import 'package:cxai_motorcycle_rides/env/env.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

class NavigationView extends StatefulWidget {
  const NavigationView({super.key});

  @override
  NavigationViewState createState() => NavigationViewState();
}

class NavigationViewState extends State<NavigationView> {
  GoogleMapController? _controller;
  LocationData? currentLocation;
  Location location = Location();
  Set<Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];
  LatLng destination = const LatLng(37.7747, -121.9735); // Example destination

  @override
  void initState() {
    super.initState();
    location.onLocationChanged.listen((LocationData loc) {
      currentLocation = loc;
      _controller?.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(loc.latitude!, loc.longitude!),
            zoom: 16,
          ),
        ),
      );
      setState(() {});
    });
    _getRoute();
  }

  Future<void> _getRoute() async {
    const String apiKey = Env.googleMapsApiKey;
    const String url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=37.7747,-121.9735&destination=37.7747,-121.9735&waypoints=via:Felter+Rd,+San+Jose,+CA|via:Mount+Hamilton+Rd,+San+Jose,+CA|via:Sierra+Rd,+CA|via:Calaveras+Rd,+CA|via:Mount+Hamilton+Rd,+CA&key=$apiKey';

    final response = await http.get(Uri.parse(url));
    final data = jsonDecode(response.body);

    if (data['status'] == 'OK') {
      final points = PolylinePoints().decodePolyline(data['routes'][0]['overview_polyline']['points']);
      if (points.isNotEmpty) {
        for (var point in points) {
          polylineCoordinates.add(LatLng(point.latitude, point.longitude));
        }
        setState(() {
          polylines.add(Polyline(
            polylineId: const PolylineId('route'),
            visible: true,
            points: polylineCoordinates,
            color: const Color.fromARGB(255, 243, 33, 33),
            width: 1,
          ));
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Navigation View')),
      body: currentLocation == null
          ? const Center(child: CircularProgressIndicator())
          : GoogleMap(
              initialCameraPosition: const CameraPosition(
                target: LatLng(37.7747, -121.9735),
                zoom: 11,
              ),
              polylines: polylines,
              markers: {
                Marker(
                  markerId: const MarkerId('currentLocation'),
                  position: LatLng(currentLocation!.latitude!, currentLocation!.longitude!),
                ),
                Marker(
                  markerId: const MarkerId('destination'),
                  position: destination,
                ),
              },
              onMapCreated: (GoogleMapController controller) {
                _controller = controller;
              },
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
            ),
    );
  }
}
