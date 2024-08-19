import 'package:cxai_motorcycle_rides/map/presentation/bloc/map_view_cubit.dart';
import 'package:cxai_motorcycle_rides/map/presentation/pages/map_view.dart';
import 'package:cxai_motorcycle_rides/map/presentation/pages/map_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MapBuilder extends StatelessWidget {
  const MapBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: BlocProvider.of<MapViewCubit>(context),
      child: const _MapPage(),
    );
  }
}

class _MapPage extends StatelessWidget {
  const _MapPage();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MapViewCubit, MapViewState>(
      builder: (context, state) {
        if (state is MapViewInitial) {
          BlocProvider.of<MapViewCubit>(context).showStartingMap();
          return const MapLoading();
        } else if (state is MapViewLoading) {
          return const MapLoading();
        } else if (state is MapViewLoaded) {
          return MapView(initialLocation: state.initialLocation);
        } else if (state is MapViewRouted) {
          return MapView(route: state.route);
        } else if (state is MapViewError) {
          return const Text('Error');
        } else {
          return const Text('Unknown');
        }
      },
    );
  }
}
