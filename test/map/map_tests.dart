import 'package:flutter_test/flutter_test.dart';
import 'package:cxai_motorcycle_rides/map/presentation/bloc/map_view_cubit.dart';
import 'package:cxai_motorcycle_rides/map/presentation/pages/map_builder.dart';
import 'package:cxai_motorcycle_rides/map/presentation/pages/map_loading.dart';
import 'package:cxai_motorcycle_rides/map/presentation/pages/map_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() {
  group('MapBuilder', () {
    testWidgets('renders MapLoading when state is MapViewInitial', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: MapBuilder(),
        ),
      );

      expect(find.byType(MapLoading), findsOneWidget);
    });

    testWidgets('renders MapLoading when state is MapViewLoading', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<MapViewCubit>(
            create: (_) => MapViewCubit(),
            child: const MapBuilder(),
          ),
        ),
      );

      BlocProvider.of<MapViewCubit>(tester.element(find.byType(MapBuilder))).emit(MapViewLoading());

      await tester.pump();

      expect(find.byType(MapLoading), findsOneWidget);
    });

    testWidgets('renders MapView when state is MapViewLoaded', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<MapViewCubit>(
            create: (_) => MapViewCubit(),
            child: const MapBuilder(),
          ),
        ),
      );

      const initialLocation = LatLng(37.7581088, -122.2538817);
      BlocProvider.of<MapViewCubit>(tester.element(find.byType(MapBuilder)))
          .emit(const MapViewLoaded(initialLocation: initialLocation));

      await tester.pump();

      expect(find.byType(MapView), findsOneWidget);
    });

    testWidgets('renders MapView with route when state is MapViewRouted', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<MapViewCubit>(
            create: (_) => MapViewCubit(),
            child: const MapBuilder(),
          ),
        ),
      );
      await tester.pump();

      expect(find.byType(MapView), findsOneWidget);
    });

    testWidgets('renders error message when state is MapViewError', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<MapViewCubit>(
            create: (_) => MapViewCubit(),
            child: const MapBuilder(),
          ),
        ),
      );

      BlocProvider.of<MapViewCubit>(tester.element(find.byType(MapBuilder))).emit(const MapViewError(message: 'Error'));

      await tester.pump();

      expect(find.text('Error'), findsOneWidget);
    });

    testWidgets('renders unknown message when state is unknown', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<MapViewCubit>(
            create: (_) => MapViewCubit(),
            child: const MapBuilder(),
          ),
        ),
      );

      // Emit an unknown state
      BlocProvider.of<MapViewCubit>(tester.element(find.byType(MapBuilder))).emit(const UnknownState());

      await tester.pump();

      expect(find.text('Unknown'), findsOneWidget);
    });
  });
}

class UnknownState extends MapViewState {
  const UnknownState();

  @override
  List<Object> get props => [];
}
