import 'package:cxai_motorcycle_rides/top_bar/data/ride_type_enum.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class RouteSettingsState extends Equatable {
  const RouteSettingsState({this.distance, this.rideType});
  final int? distance;
  final RideType? rideType;

  @override
  List<Object> get props => [];
}

class RouteSettingsInitial extends RouteSettingsState {
  const RouteSettingsInitial({required int distance, required RideType rideType});
  @override
  int? get distance => null;

  @override
  RideType? get rideType => null;
}

class RouteSettingsLoading extends RouteSettingsState {
  const RouteSettingsLoading();
}

class RouteSettingsLoaded extends RouteSettingsState {
  const RouteSettingsLoaded({required int distance, required RideType rideType});

  @override
  List<Object> get props => [distance as Object, rideType as Object];
}

class RouteSettingsCubit extends Cubit<RouteSettingsState> {
  RouteSettingsCubit()
      : super(
          const RouteSettingsInitial(
            distance: 0,
            rideType: RideType.fast,
          ),
        );

  void updateRouteSettings(int distance, RideType rideType) {
    emit(RouteSettingsLoaded(distance: distance, rideType: rideType));
  }
}
