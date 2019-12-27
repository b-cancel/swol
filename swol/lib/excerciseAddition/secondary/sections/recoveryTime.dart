//flutter
import 'package:flutter/material.dart';
import 'package:swol/excerciseAddition/popUps/popUpFunctions.dart';

//internal from addition
import 'package:swol/excerciseAddition/secondary/trainingTypeHelpers.dart';

//internal from shared
import 'package:swol/sharedWidgets/informationDisplay.dart';
import 'package:swol/sharedWidgets/timeHelper.dart';
import 'package:swol/sharedWidgets/timePicker.dart';

class RecoveryTimeCard extends StatelessWidget {
  const RecoveryTimeCard({
    Key key,
    @required this.changeDuration,
    @required this.sliderWidth,
    @required this.recoveryPeriod,
  }) : super(key: key);

  final Duration changeDuration;
  final double sliderWidth;
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
              RecoveryTimeWidget(
                changeDuration: changeDuration, 
                sliderWidth: sliderWidth, 
                textHeight: 16, 
                textMaxWidth: 28, 
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
    @required this.sliderWidth,
    @required this.textHeight,
    @required this.textMaxWidth,
    @required this.recoveryPeriod,
    this.darkTheme: true,
  }) : super(key: key);

  final Duration changeDuration;
  final double sliderWidth;
  final double textHeight;
  final double textMaxWidth;
  final ValueNotifier<Duration> recoveryPeriod;
  final bool darkTheme;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        FittedBox(
          fit: BoxFit.contain,
          child: Center(
            child: Theme(
              //light so that our pop ups work properly
              data: ThemeData.light(),
              child: AnimRecoveryTimeInfoToWhiteTheme(
                changeDuration: changeDuration, 
                sliderWidth: sliderWidth, 
                textHeight: textHeight, 
                textMaxWidth: textMaxWidth, 
                recoveryPeriod: recoveryPeriod, 
                darkTheme: darkTheme,
              ),
            ),
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

class AnimRecoveryTimeInfoToWhiteTheme extends StatelessWidget {
  const AnimRecoveryTimeInfoToWhiteTheme({
    Key key,
    @required this.changeDuration,
    @required this.sliderWidth,
    @required this.textHeight,
    @required this.textMaxWidth,
    @required this.recoveryPeriod,
    @required this.darkTheme,
  }) : super(key: key);

  final Duration changeDuration;
  final double sliderWidth;
  final double textHeight;
  final double textMaxWidth;
  final ValueNotifier<Duration> recoveryPeriod;
  final bool darkTheme;

  @override
  Widget build(BuildContext context) {
    return AnimatedRecoveryTimeInfo(
      changeDuration: changeDuration,
      grownWidth: sliderWidth, 
      textHeight: textHeight, 
      textMaxWidth: textMaxWidth,
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
          left: new SliderToolTipButton(
            buttonText: "15s",
            tooltipText: "Any Less, wouldn't be enough",
          ),
          right: SliderToolTipButton(
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
          left: SliderToolTipButton(
            buttonText: "1:05",
          ),
          right: SliderToolTipButton(
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
          left: SliderToolTipButton(
            buttonText: "2:05",
          ),
          right: SliderToolTipButton(
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
          left: SliderToolTipButton(
            buttonText: "3:05",
          ),
          right: SliderToolTipButton(
            buttonText: "4:55",
            tooltipText: "Any More, and your muscles would have cooled off",
          ),
          startSeconds: 185,
          endSeconds: 295,
        )
      ],
    );
  }
}