//flutter
import 'package:flutter/material.dart';

//internal from addition
import 'package:swol/excerciseAddition/secondary/trainingTypeHelpers.dart';
import 'package:swol/excerciseAddition/popUps/popUpFunctions.dart';
import 'package:swol/shared/functions/theme.dart';

//internal from shared
import 'package:swol/sharedWidgets/informationDisplay.dart';
import 'package:swol/sharedWidgets/sliderTipButton.dart';
import 'package:swol/sharedWidgets/timeHelper.dart';
import 'package:swol/sharedWidgets/timePicker.dart';

class RecoveryTimeCard extends StatelessWidget {
  const RecoveryTimeCard({
    Key key,
    @required this.changeDuration,
    @required this.recoveryPeriod,
  }) : super(key: key);

  final Duration changeDuration;
  final ValueNotifier<Duration> recoveryPeriod;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.dark(),
      child: Card(
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
              Container(
                child: HeaderWithInfo(
                  title: "Recovery Time",
                  popUpFunction: () => recoveryTimePopUp(context),
                ),
              ),
              //edit this?
              RecoveryTimeWidget(
                changeDuration: changeDuration,
                recoveryPeriod: recoveryPeriod, 
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RecoveryTimeWidget extends StatelessWidget {
  const RecoveryTimeWidget({
    Key key,
    @required this.changeDuration,
    @required this.recoveryPeriod,
    this.darkTheme: true,
  }) : super(key: key);

  final Duration changeDuration;
  final ValueNotifier<Duration> recoveryPeriod;
  final bool darkTheme;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Theme(
          //light so that our pop ups work properly
          data: MyTheme.light,
          child: AnimRecoveryTimeInfoToWhiteTheme(
            changeDuration: changeDuration, 
            recoveryPeriod: recoveryPeriod, 
            darkTheme: darkTheme,
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
        TimePicker(
          duration: recoveryPeriod,
          darkTheme: darkTheme,
        ),
        MinsSecsBelowTimePicker(
          duration: recoveryPeriod,
          darkTheme: darkTheme,
        ),
      ],
    );
  }
}

//todo here
class AnimRecoveryTimeInfoToWhiteTheme extends StatelessWidget {
  const AnimRecoveryTimeInfoToWhiteTheme({
    Key key,
    @required this.changeDuration,
    @required this.recoveryPeriod,
    @required this.darkTheme,
  }) : super(key: key);

  final Duration changeDuration;
  final ValueNotifier<Duration> recoveryPeriod;
  final bool darkTheme;

  @override
  Widget build(BuildContext context) {
    return AnimatedTrainingInfo(
      changeDuration: changeDuration,
      selectedDuration: recoveryPeriod,
      darkTheme: darkTheme,
      ranges: [
        Range(
          name: "Endurance Training",
          onTap: makeTrainingTypePopUp(
            context: context,
            title: "Endurance Training",
            showEndurance: true,
            highlightfield: 2,
            iconID: FitIcons.Endurance,
          ),
          left: new SliderTipButton(
            buttonText: "15s",
            tipText: "Any Less, wouldn't be enough",
          ),
          right: SliderTipButton(
            buttonText: "1m",
          ),
          startSeconds: 15,
          endSeconds: 60,
        ),
        Range(
          name: "Hypertrophy Training",
          onTap: makeTrainingTypePopUp(
            context: context,
            title: "Hypertrophy Training",
            showHypertrophy: true,
            highlightfield: 2,
            iconID: FitIcons.Hypertrophy,
          ),
          left: SliderTipButton(
            buttonText: "1:05",
          ),
          right: SliderTipButton(
            buttonText: "2m",
          ),
          startSeconds: 65,
          endSeconds: 120,
        ),
        Range(
          name: "Hypertrophy/Strength",
          onTap: makeTrainingTypePopUp(
            context: context,
            title: "Hypertrophy/Strength",
            showHypertrophy: true,
            showStrength: true,
            highlightfield: 2,
            iconID: FitIcons.HypAndStr,
          ),
          left: SliderTipButton(
            buttonText: "2:05",
          ),
          right: SliderTipButton(
            buttonText: "3m",
          ),
          startSeconds: 125,
          endSeconds: 180,
        ),
        Range(
          name: "Strength Training",
          onTap: makeTrainingTypePopUp(
            context: context,
            title: "Strength Training",
            showStrength: true,
            highlightfield: 2,
            iconID: FitIcons.Strength,
          ),
          left: SliderTipButton(
            buttonText: "3:05",
          ),
          right: SliderTipButton(
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