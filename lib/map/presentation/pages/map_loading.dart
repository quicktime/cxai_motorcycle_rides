import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class MapLoading extends StatelessWidget {
  const MapLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Lottie.asset('assets/loading-animation.json'),
      ),
    );
  }
}
