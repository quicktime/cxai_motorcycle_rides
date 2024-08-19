import 'package:cxai_motorcycle_rides/top_bar/data/ride_type_enum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class RideStyleCubit extends Cubit<RideType> {
  RideStyleCubit() : super(RideType.fast);

  void updateSelectedOption(RideType option) {
    emit(option);
  }
}

class RideStyleSelector extends StatelessWidget {
  const RideStyleSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: BlocProvider.of<RideStyleCubit>(context),
      child: BlocBuilder<RideStyleCubit, RideType>(
        builder: (context, selectedOption) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Ride Style'),
              SegmentedButton<RideType>(
                segments: const <ButtonSegment<RideType>>[
                  ButtonSegment(
                    label: Text('Fast'),
                    value: RideType.fast,
                    icon: FaIcon(FontAwesomeIcons.gaugeHigh),
                  ),
                  ButtonSegment(
                    label: Text('Cruising'),
                    value: RideType.cruising,
                    icon: FaIcon(FontAwesomeIcons.motorcycle),
                  ),
                  ButtonSegment(
                    label: Text('Twisty'),
                    value: RideType.twisty,
                    icon: FaIcon(FontAwesomeIcons.mountain),
                  ),
                ],
                selected: <RideType>{selectedOption},
                onSelectionChanged: (Set<RideType> newSelection) {
                  context.read<RideStyleCubit>().updateSelectedOption(newSelection.first);
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
