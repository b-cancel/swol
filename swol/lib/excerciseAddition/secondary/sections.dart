import 'package:flutter/material.dart';
import 'package:swol/excerciseAddition/informationPopUps.dart';
import 'package:swol/excerciseAddition/secondary/dropdown.dart';
import 'package:swol/excerciseAddition/secondary/trainingTypeHelpers.dart';
import 'package:swol/sharedWidgets/informationDisplay.dart';
import 'package:swol/sharedWidgets/mySlider.dart';
import 'package:swol/sharedWidgets/timeHelper.dart';
import 'package:swol/sharedWidgets/timePicker.dart';

class FunctionSelection extends StatelessWidget {
  const FunctionSelection({
    Key key,
    @required this.functionIndex,
    @required this.functionString,
  }) : super(key: key);

  final ValueNotifier<int> functionIndex;
  final ValueNotifier<String> functionString;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(
              //Top 16 padding address above
              left: 16,
              right: 16,
              bottom: 16,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  child: new HeaderWithInfo(
                    title: "Prediction Formula",
                    popUpFunction: popUpWidgetToFunction(
                      context, 
                      PredictionFormulasPopUp(),
                    ),
                  ),
                ),
                //TODO: switch to the easy drop down after fixing issue
                FunctionDropDown(
                  functionIndex: functionIndex,
                  functionString: functionString,
                ),
              ],
            ),
          ),
        ]
      ),
    );
  }
}

class RepTargetCard extends StatelessWidget {
  const RepTargetCard({
    Key key,
    @required this.changeDuration,
    @required this.sliderWidth,
    @required this.repTargetDuration,
    @required this.repTarget,
  }) : super(key: key);

  final Duration changeDuration;
  final double sliderWidth;
  final ValueNotifier<Duration> repTargetDuration;
  final ValueNotifier<int> repTarget;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(
              top: 8,
              left: 16,
              right: 16,
            ),
            child: new HeaderWithInfo(
              title: "Rep Target",
              popUpFunction: popUpWidgetToFunction(
                context, 
                RepTargetPopUp(),
              ),
            ),
          ),
          Container(
            child: Padding(
              padding: const EdgeInsets.only(
                left: 16.0,
              ),
              child: AnimatedRecoveryTimeInfo(
                changeDuration: changeDuration,
                grownWidth: sliderWidth, 
                textHeight: 16, 
                textMaxWidth: 28,
                selectedDuration: repTargetDuration,
                bigTickNumber: 25,
                ranges: [
                  Range(
                    name: "Strength Training",
                    onTap: makeTrainingTypePopUp(
                      context: context,
                      title: "Strength Training",
                      showStrength: true,
                      highlightfield: 3,
                    ),
                    left: new SliderToolTipButton(
                      buttonText: "1",
                    ),
                    right: SliderToolTipButton(
                      buttonText: "6",
                    ),
                    startSeconds: (1*5),
                    endSeconds: (6*5),
                  ),
                  Range(
                    name: "Hypertrophy Training",
                    onTap: makeTrainingTypePopUp(
                      context: context,
                      title: "Hypertrophy Training",
                      showHypertrophy: true,
                      highlightfield: 3,
                    ),
                    left: SliderToolTipButton(
                      buttonText: "7",
                    ),
                    right: SliderToolTipButton(
                      buttonText: "12",
                    ),
                    startSeconds: (7*5),
                    endSeconds: (12*5),
                  ),
                  Range(
                    name: "Endurance Training",
                    onTap: makeTrainingTypePopUp(
                      context: context,
                      title: "Endurance Training",
                      showEndurance: true,
                      highlightfield: 3,
                    ),
                    left: SliderToolTipButton(
                      buttonText: "13",
                    ),
                    right: SliderToolTipButton(
                      buttonText: "35",
                      tooltipText: "Any More, and we won't be able to estimate your 1 Rep Max",
                    ),
                    startSeconds: (13*5),
                    endSeconds: (35*5),
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              bottom: 16.0,
              left: 16,
              right: 16,
              top: 8,
            ),
            child: Container(
              color: Theme.of(context).primaryColor,
              height: 2,
              width: MediaQuery.of(context).size.width,
            ),
          ),
          CustomSlider(
            value: repTarget,
            lastTick: 35,
          ),
        ],
      ),
    );
  }
}

class SetTargetCard extends StatelessWidget {
  const SetTargetCard({
    Key key,
    @required this.setTarget,
  }) : super(key: key);

  final ValueNotifier<int> setTarget;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(
              //Top 16 padding address above
              left: 16,
              right: 16,
            ),
            child: Container(
              child: new HeaderWithInfo(
                title: "Set Target",
                popUpFunction: popUpWidgetToFunction(
                  context, 
                  SetTargetPopUp(),
                ),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(
              //Top 16 padding address above
              left: 16,
              right: 16,
            ),
            child: TrainingTypeIndicator(
              setTarget: setTarget,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 8,
              bottom: 16.0,
              left: 16,
              right: 16,
            ),
            child: Container(
              color: Theme.of(context).primaryColor,
              height: 2,
              width: MediaQuery.of(context).size.width,
            ),
          ),
          new CustomSlider(
            value: setTarget,
            lastTick: 9,
          ),
        ]
      ),
    );
  }
}

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
            Container(
              child: HeaderWithInfo(
                title: "Recovery Time",
                popUpFunction: popUpWidgetToFunction(
                  context, 
                  SetBreakPopUp(),
                ), 
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
          child: AnimatedRecoveryTimeInfo(
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
                name: "Hypertrophy/Strength (50/50)",
                onTap: makeTrainingTypePopUp(
                  context: context,
                  title: "Hyper/Str (50/50)",
                  showHypertrophy: true,
                  showStrength: true,
                  highlightfield: 2,
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