//flutter
import 'package:flutter/material.dart';

//internal
import 'package:swol/shared/widgets/complex/fields/headers/fieldHeader.dart';
import 'package:swol/shared/widgets/complex/RangeInformation/animatedCarousel.dart';
import 'package:swol/shared/widgets/complex/recoveryTime/minSecs.dart';
import 'package:swol/shared/widgets/complex/recoveryTime/picker.dart';
import 'package:swol/shared/widgets/simple/sliderTipButton.dart';
import 'package:swol/shared/functions/trainingPopUps.dart';
import 'package:swol/shared/methods/theme.dart';
import 'package:swol/shared/structs/range.dart';

//widget
class RecoveryTimeCard extends StatelessWidget {
  const RecoveryTimeCard({
    Key key,
    @required this.recoveryPeriod,
  }) : super(key: key);

  final ValueNotifier<Duration> recoveryPeriod;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8),
      child: Container(
        padding: EdgeInsets.only(
          top: 8,
          left: 16,
          right: 16,
          bottom: 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            RecoveryTimeHeader(),
            RecoveryTimeWidget(
              recoveryPeriod: recoveryPeriod, 
            ),
          ],
        ),
      ),
    );
  }
}

class RecoveryTimeWidget extends StatelessWidget {
  const RecoveryTimeWidget({
    Key key,
    @required this.recoveryPeriod,
  }) : super(key: key);

  final ValueNotifier<Duration> recoveryPeriod;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Theme(
          data: MyTheme.light,
          child: AnimRecoveryTimeInfoToWhiteTheme(
            recoveryPeriod: recoveryPeriod, 
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
            top: 8,
            bottom: 16.0,
          ),
          child: Container(
            color: Theme.of(context).primaryColor,
            height: 2,
            width: MediaQuery.of(context).size.width,
          ),
        ),
        RecoveryTimePicker(
          duration: recoveryPeriod,
          darkTheme: true,
        ),
        MinsSecsBelowTimePicker(
          duration: recoveryPeriod,
          darkTheme: true,
        ),
      ],
    );
  }
}

class AnimRecoveryTimeInfoToWhiteTheme extends StatelessWidget {
  const AnimRecoveryTimeInfoToWhiteTheme({
    Key key,
    @required this.recoveryPeriod,
    this.darkTheme: true,
    this.hideNameButtons: false,
  }) : super(key: key);

  final ValueNotifier<Duration> recoveryPeriod;
  final bool darkTheme;
  final bool hideNameButtons;

  @override
  Widget build(BuildContext context) {
    return AnimatedRangeInformation(
      darkTheme: darkTheme,
      selectedDuration: recoveryPeriod,
      hideNameButtons: hideNameButtons,
      ranges: [
        Range(
          name: "Endurance Training",
          onTap: makeEnduranceTrainingPopUp(context, 2),
          left: SlideRangeExtent(
            buttonText: "15s",
            tipText: "Any Less, wouldn't be enough",
          ),
          right: SlideRangeExtent(
            buttonText: "1m",
          ),
          startSeconds: 15,
          endSeconds: 60,
        ),
        Range(
          name: "Hypertrophy Training",
          onTap: makeHypertrophyTrainingPopUp(context, 2),
          left: SlideRangeExtent(
            buttonText: "1:05",
          ),
          right: SlideRangeExtent(
            buttonText: "2m",
          ),
          startSeconds: 65,
          endSeconds: 120,
        ),
        Range(
          name: "Hypertrophy/Strength",
          onTap: makeHypertrophyStrengthTrainingPopUp(context, 2),
          left: SlideRangeExtent(
            buttonText: "2:05",
          ),
          right: SlideRangeExtent(
            buttonText: "3m",
          ),
          startSeconds: 125,
          endSeconds: 180,
        ),
        Range(
          name: "Strength Training",
          onTap: makeStrengthTrainingPopUp(context, 2),
          left: SlideRangeExtent(
            buttonText: "3:05",
          ),
          right: SlideRangeExtent(
            buttonText: "4:55",
            tipText: "Any More, will require you to\nwarm up again",
          ),
          startSeconds: 185,
          endSeconds: 295,
        )
      ],
    );
  }
}