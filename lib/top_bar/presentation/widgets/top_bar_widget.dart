import 'package:cxai_motorcycle_rides/top_bar/presentation/bloc/route_settings_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<RouteSettingsCubit>(
      create: (context) => RouteSettingsCubit(),
      child: const Column(
        children: [
          SliderColumn(),
          OptionsColumn(),
          ElevatedButtonColumn(),
        ],
      ),
    );
  }
}

class SliderColumn extends StatelessWidget {
  const SliderColumn({super.key});

  @override
  Widget build(BuildContext context) {
    double? distance = BlocProvider.of<RouteSettingsCubit>(context).state.distance;
    return Column(
      children: [
        Text('Distance: $distance'),
        Slider(
          value: distance ?? 0,
          min: 0,
          max: 100,
          onChanged: (value) {
            BlocProvider.of<RouteSettingsCubit>(context)
                .updateRouteSettings(value, BlocProvider.of<RouteSettingsCubit>(context).state.rideType!);
          },
        ),
      ],
    );
  }
}

class OptionsColumn extends StatelessWidget {
  const OptionsColumn({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Text('Options Column'),
        // Add your options widgets here
        // Example: RadioListTile(value: 1, groupValue: 1, onChanged: (value) {}),
        // Example: RadioListTile(value: 2, groupValue: 1, onChanged: (value) {}),
        // Example: RadioListTile(value: 3, groupValue: 1, onChanged: (value) {}),
      ],
    );
  }
}

class ElevatedButtonColumn extends StatelessWidget {
  const ElevatedButtonColumn({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Text('Elevated Button Column'),
        // Add your elevated button widget here
        // Example: ElevatedButton(onPressed: () {}, child: Text('Button')),
      ],
    );
  }
}
