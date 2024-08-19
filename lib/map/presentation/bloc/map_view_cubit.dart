import 'package:cxai_motorcycle_rides/core/location.dart';
import 'package:cxai_motorcycle_rides/map/data/models/route_model.dart';
import 'package:cxai_motorcycle_rides/map/data/sources/fetch_route.dart';
import 'package:cxai_motorcycle_rides/top_bar/data/ride_type_enum.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

abstract class MapViewState extends Equatable {
  const MapViewState();

  @override
  List<Object> get props => [];
}

class MapViewInitial extends MapViewState {}

class MapViewLoading extends MapViewState {}

class MapViewLoaded extends MapViewState {
  const MapViewLoaded({required this.initialLocation});

  final LatLng initialLocation;

  @override
  List<Object> get props => [initialLocation];
}

class MapViewRouted extends MapViewState {
  const MapViewRouted({required this.route});

  final RouteModel route;

  @override
  List<Object> get props => [route];
}

class MapViewError extends MapViewState {
  const MapViewError({required this.message});

  final String message;

  @override
  List<Object> get props => [message];
}

class MapViewCubit extends Cubit<MapViewState> {
  MapViewCubit() : super(MapViewInitial());

  Future<void> updateMapView(LatLng initialLocation, double distance, RideType rideType) async {
    emit(MapViewLoading());
    RouteModel route = await MotorcycleRoute().fetchRoute(initialLocation, distance, rideType);
    emit(MapViewRouted(route: route));
  }

  void showLoading() {
    emit(MapViewLoading());
  }

  Future<void> showStartingMap() async {
    emit(MapViewLoading());
    LatLng location = await getCurrentLocation();
    emit(MapViewLoaded(initialLocation: location));
  }

  void showError(String message) {
    emit(MapViewError(message: message));
  }
}
