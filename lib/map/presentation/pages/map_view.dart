import 'package:cxai_motorcycle_rides/map/data/models/route_model.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapView extends StatelessWidget {
  const MapView({this.initialLocation, this.route, super.key});
  final LatLng? initialLocation;
  final RouteModel? route;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        mapType: MapType.satellite,
        initialCameraPosition: CameraPosition(
          target: route?.initialLocation ?? initialLocation!,
          zoom: 11,
        ),
        polylines: route?.polylines ?? {},
        markers: route == null
            ? {}
            : {
                Marker(
                  markerId: const MarkerId('start'),
                  position: route!.polylineCoordinates.first,
                ),
              }.union(route!.markers),
        myLocationEnabled: true,
        myLocationButtonEnabled: false,
      ),
    );
  }
}
