import 'package:cxai_motorcycle_rides/top_bar/data/ride_type_enum.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Prompt {
  final LatLng startingLatLong;
  final double distance;
  final RideType rideType;

  Prompt(this.startingLatLong, this.distance, this.rideType);

  String generatePrompt() {
    String condition;
    switch (rideType) {
      case RideType.fast:
        condition = 'straight and where you can go fast. ';
      case RideType.twisty:
        condition = 'very twisty and challenging. Go on mountain roads. Avoid highways.';
      case RideType.cruising:
        condition = 'smooth and scenic. Prioritize scenic routes.';
      default:
        condition = 'enjoyable';
    }

    return 'Generate a motorcycle ride that is $distance miles long, starting at $startingLatLong. The ride should go on roads that are $condition. Return a googleapis Google Directions API Request URL. I do not need an explanation, just the URL. Limit the waypoints to a maximum of 6.';
  }
}
