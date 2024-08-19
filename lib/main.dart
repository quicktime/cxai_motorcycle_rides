import 'package:cxai_motorcycle_rides/map/presentation/bloc/map_view_cubit.dart';
import 'package:cxai_motorcycle_rides/map/presentation/pages/map_builder.dart';
import 'package:cxai_motorcycle_rides/top_bar/presentation/bloc/route_settings_cubit.dart';
import 'package:cxai_motorcycle_rides/top_bar/presentation/widgets/top_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<RouteSettingsCubit>(
          create: (routeSettingsContext) => RouteSettingsCubit(),
        ),
        BlocProvider<MapViewCubit>(
          create: (mapContext) => MapViewCubit(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.purpleAccent[700],
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('MotoGenRides'),
        ),
        body: const Column(
          children: [
            RouteSettingsBar(),
            Expanded(child: MapBuilder()),
          ],
        ),
      ),
    );
  }
}
