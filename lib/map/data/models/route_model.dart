import 'package:google_maps_flutter/google_maps_flutter.dart';

class RouteModel {
  final LatLng initialLocation;
  final Set<Polyline> polylines;
  final List<LatLng> polylineCoordinates;
  final Set<Marker> markers;

  RouteModel({
    required this.initialLocation,
    required this.polylines,
    required this.polylineCoordinates,
    required this.markers,
  });
}
