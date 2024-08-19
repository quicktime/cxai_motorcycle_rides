import 'dart:convert';

import 'package:cxai_motorcycle_rides/gen_ai/gemini_ai_service.dart';
import 'package:cxai_motorcycle_rides/gen_ai/prompt.dart';
import 'package:cxai_motorcycle_rides/map/data/models/route_model.dart';
import 'package:cxai_motorcycle_rides/top_bar/data/ride_type_enum.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class MotorcycleRoute {
  Future<RouteModel> fetchRoute(LatLng initialLocation, double distance, RideType rideType) async {
    Set<Polyline> polylines = {};
    List<LatLng> polylineCoordinates = [];
    Set<Marker> markers = {};

    List<LatLng> decodePolyline(String poly) {
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

    final String directionsRequest = await GeminiAiService().getLinkFromPrompt(
      Prompt(
        initialLocation,
        distance,
        rideType,
      ).generatePrompt(),
    );

    var directionsResponse = await http.get(Uri.parse(directionsRequest));
    var data = jsonDecode(directionsResponse.body);

    while (data['status'] != 'OK') {
      final String directionsRequest = await GeminiAiService().getLinkFromPrompt(
        Prompt(
          initialLocation,
          distance,
          rideType,
        ).generatePrompt(),
      );

      directionsResponse = await http.get(Uri.parse(directionsRequest));
      data = jsonDecode(directionsResponse.body);
    }

    if (data['status'] == 'OK') {
      final legs = data['routes'][0]['legs'];

      // Add geocoded waypoints as markers
      for (int i = 0; i < legs.length; i++) {
        var leg = legs[i];
        List steps = leg['steps'];
        for (var step in steps) {
          final polylinePoints = step['polyline']['points'];
          polylineCoordinates.addAll(decodePolyline(polylinePoints));
        }
        final placeId = '$i';
        final latLng = LatLng(leg['start_location']['lat'], leg['start_location']['lng']);
        markers.add(
          Marker(
            markerId: MarkerId(placeId),
            position: latLng,
            icon: AssetMapBitmap('assets/markers/${i + 1}.png'),
            infoWindow: InfoWindow(title: leg['start_address']),
          ),
        );
      }
    }

    // Add polylines to map
    polylines.add(
      Polyline(
        polylineId: const PolylineId('overview_polyline'),
        visible: true,
        points: polylineCoordinates,
        color: Colors.blue,
        width: 5,
      ),
    );

    return RouteModel(
      initialLocation: initialLocation,
      polylines: polylines,
      polylineCoordinates: polylineCoordinates,
      markers: markers,
    );
  }
}
