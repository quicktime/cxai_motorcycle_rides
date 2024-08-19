import 'package:cxai_motorcycle_rides/top_bar/data/ride_type_enum.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Prompt {
  final LatLng startingLatLong;
  final String distance;
  final RideTypeEnum rideType;

  Prompt(this.startingLatLong, this.distance, this.rideType);

  String generatePrompt() {
    String condition;
    switch (rideType) {
      case RideTypeEnum.fast:
        condition = 'fast and where you can go full throttle';
      case RideTypeEnum.twisty:
        condition = 'twisty and full of curves while avoiding straight roads';
      case RideTypeEnum.cruising:
        condition = 'smooth and scenic, perfect for cruising';
      default:
        condition = 'enjoyable';
    }

    return 'Generate a motorcycle ride that is $distance miles long, starting at $startingLatLong. The ride should be $condition, and should prioritize enjoyment on the ride. The ride should return to the starting location via a different route. Return a googleapis Google Directions API Request URL.';
  }
}
