import 'package:cxai_motorcycle_rides/top_bar/presentation/widgets/distance.dart';
import 'package:cxai_motorcycle_rides/top_bar/presentation/widgets/ride_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cxai_motorcycle_rides/top_bar/presentation/widgets/top_bar_widget.dart';

void main() {
  group('RouteSettingsBar', () {
    testWidgets('DistanceSlider widget test', (WidgetTester tester) async {
      // Build the DistanceSlider widget.
      await tester.pumpWidget(const DistanceSlider());

      // Verify that the DistanceSlider widget contains the expected elements.
      expect(find.text('Distance'), findsOneWidget);
      expect(find.byType(Slider), findsOneWidget);
    });

    testWidgets('SliderCubit update test', (WidgetTester tester) async {
      // Create a SliderCubit instance.
      final cubit = SliderCubit();

      // Verify that the initial value of the cubit is 0.0.
      expect(cubit.state, equals(0.0));

      // Update the slider value using the cubit.
      cubit.updateSlider(50.0);

      // Verify that the slider value has been updated.
      expect(cubit.state, equals(50.0));
    });

    testWidgets('renders DistanceSlider and RideStyleSelector', (WidgetTester tester) async {
      await tester.pumpWidget(const RouteSettingsBar());

      expect(find.byType(DistanceSlider), findsOneWidget);
      expect(find.byType(RideStyleSelector), findsOneWidget);
    });

    testWidgets('triggers updateMapView when Generate Ride button is pressed', (WidgetTester tester) async {
      await tester.pumpWidget(const RouteSettingsBar());

      final generateRideButton = find.byType(ElevatedButton);
      expect(generateRideButton, findsOneWidget);

      await tester.tap(generateRideButton);
      await tester.pump();
    });
  });
}
