import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

class SliderCubit extends Cubit<double> {
  SliderCubit() : super(0.0);

  void updateSlider(double value) {
    emit(value);
  }
}

class DistanceSlider extends StatelessWidget {
  const DistanceSlider({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: BlocProvider.of<SliderCubit>(context),
      child: BlocBuilder<SliderCubit, double>(
        builder: (context, sliderValue) {
          return Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Row(
              children: [
                const Text('Distance'),
                Expanded(
                  child: Slider(
                    value: sliderValue,
                    min: 0.0,
                    max: 200.0,
                    divisions: 20,
                    label: sliderValue.round().toString(),
                    onChanged: (value) {
                      BlocProvider.of<SliderCubit>(context).updateSlider(value);
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
