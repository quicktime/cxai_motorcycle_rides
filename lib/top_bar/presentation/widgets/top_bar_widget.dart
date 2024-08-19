import 'package:cxai_motorcycle_rides/core/location.dart';
import 'package:cxai_motorcycle_rides/map/presentation/bloc/map_view_cubit.dart';
import 'package:cxai_motorcycle_rides/top_bar/presentation/widgets/distance.dart';
import 'package:cxai_motorcycle_rides/top_bar/presentation/widgets/ride_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RouteSettingsBar extends StatelessWidget {
  const RouteSettingsBar({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(providers: [
      BlocProvider(create: (_) => SliderCubit()),
      BlocProvider(create: (_) => RideStyleCubit()),
    ], child: const RouteSettingsBarWidget());
  }
}

class RouteSettingsBarWidget extends StatelessWidget {
  const RouteSettingsBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final sliderCubit = BlocProvider.of<SliderCubit>(context);
    final rideStyleCubit = BlocProvider.of<RideStyleCubit>(context);

    return Column(
      children: [
        const DistanceSlider(),
        const RideStyleSelector(),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.black,
            backgroundColor: const Color(0xFFefdcf5),
            surfaceTintColor: Colors.black,
            side: const BorderSide(color: Color.fromARGB(255, 126, 126, 126), width: 1),
          ),
          onPressed: () async {
            BlocProvider.of<MapViewCubit>(context)
                .updateMapView(await getCurrentLocation(), sliderCubit.state, rideStyleCubit.state);
          },
          child: const Text('Generate Ride'),
        ),
      ],
    );
  }
}
