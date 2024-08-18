import 'package:cxai_motorcycle_rides/top_bar/data/ride_type_enum.dart';
import 'package:cxai_motorcycle_rides/top_bar/data/ride_type_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class RouteSettingsState extends Equatable {
  const RouteSettingsState({this.distance, this.rideType});
  final double? distance;
  final RideType? rideType;

  @override
  List<Object> get props => [];
}

class RouteSettingsInitial extends RouteSettingsState {
  const RouteSettingsInitial({required this.distance, required this.rideType});
  final double distance;
  final RideType rideType;
}

class RouteSettingsLoading extends RouteSettingsState {
  const RouteSettingsLoading();
}

class RouteSettingsLoaded extends RouteSettingsState {
  const RouteSettingsLoaded({required this.distance, required this.rideType});
  final double distance;
  final RideType rideType;

  @override
  List<Object> get props => [distance, rideType];
}


class RouteSettingsCubit extends Cubit<RouteSettingsState> {
  RouteSettingsCubit()
      : super(
          RouteSettingsInitial(
            distance: 0,
            rideType: RideType(
              type: RideTypeEnum.fast,
              icon: 'fast',
            ),
          ),
        );

  void updateRouteSettings(double distance, RideType rideType) {
    emit(const RouteSettingsLoading());
    try {
      emit(RouteSettingsLoaded(distance: distance, rideType: rideType));
    } catch (e) {
      // TODO(quicktime): Add error handling
    }
  }
}
