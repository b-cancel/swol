//flutter
import 'package:flutter/material.dart';

//internal
import 'package:swol/shared/widgets/complex/fields/fields/sliders/sliderField.dart';
import 'package:swol/shared/widgets/complex/rangeInformation/animatedCarousel.dart';
import 'package:swol/shared/widgets/complex/fields/headers/fieldHeader.dart';
import 'package:swol/shared/widgets/simple/sliderTipButton.dart';
import 'package:swol/shared/functions/trainingPopUps.dart';
import 'package:swol/shared/structs/range.dart';
import 'package:swol/shared/methods/theme.dart';

//NOTE: this widget should not dispose its passed rep target
class RepTargetField extends StatefulWidget {
  RepTargetField({
    @required this.repTarget,
    @required this.subtle,
    this.darkTheme: true,
  });

  final ValueNotifier<int> repTarget;
  final bool subtle;
  final bool darkTheme;

  @override
  _RepTargetFieldState createState() => _RepTargetFieldState();
}

class _RepTargetFieldState extends State<RepTargetField> {
  ValueNotifier<Duration> repTargetDuration;

  repTargetUpdate(){
    //update duration that is used by tick slider
    repTargetDuration.value = Duration(
      seconds: widget.repTarget.value * 5,
    );
  }

  @override
  void initState() {
    //create notifier
    repTargetDuration = new ValueNotifier<Duration>(Duration.zero);

    //set its value given rep target
    repTargetUpdate();

    //listen to value changes so both notifiers stay synced
    widget.repTarget.addListener(repTargetUpdate);

    //super init
    super.initState();
  }

  @override
  void dispose() {
    widget.repTarget.removeListener(repTargetUpdate);
    //DO NOT DISPOSE REP TARGET since it was passed

    //super dispose 
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SliderField(
      lastTick: 35,
      subtle: widget.subtle,
      value: widget.repTarget,
      header: RepTargetHeader(subtle: widget.subtle),
      indicator: Theme(
        data: MyTheme.light,
        child: AnimRepTargetInfoWhite(
          repTargetDuration: repTargetDuration,
          darkTheme: widget.subtle == false,
        ),
      ),
    );
  }
}

//used by rep target (BoxFit.contained) and within white theme
class AnimRepTargetInfoWhite extends StatelessWidget {
  const AnimRepTargetInfoWhite({
    Key key,
    @required this.repTargetDuration,
    this.darkTheme: true,
  }) : super(key: key);

  final ValueNotifier<Duration> repTargetDuration;
  final bool darkTheme;

  @override
  Widget build(BuildContext context) {
    return AnimatedRangeInformation(
      selectedDuration: repTargetDuration,
      bigTickNumber: 25,
      darkTheme: darkTheme,
      hideNameButtons: false,
      ranges: [
        Range(
          name: "Strength Training",
          onTap: makeStrengthTrainingPopUp(context, 3),
          left: new SlideRangeExtent(
            buttonText: "1",
          ),
          right: SlideRangeExtent(
            buttonText: "6",
          ),
          startSeconds: (1*5),
          endSeconds: (6*5),
        ),
        Range(
          name: "Hypertrophy Training",
          onTap: makeHypertrophyTrainingPopUp(context, 3),
          left: SlideRangeExtent(
            buttonText: "7",
          ),
          right: SlideRangeExtent(
            buttonText: "12",
          ),
          startSeconds: (7*5),
          endSeconds: (12*5),
        ),
        Range(
          name: "Endurance Training",
          onTap: makeEnduranceTrainingPopUp(context, 3),
          left: SlideRangeExtent(
            buttonText: "13",
          ),
          right: SlideRangeExtent(
            buttonText: "35",
            tipText: "Any More, and we will have trouble estimating your 1 Rep Max",
            tipToLeft: false,
          ),
          startSeconds: (13*5),
          endSeconds: (35*5),
        )
      ],
    );
  }
}