//flutter
import 'package:flutter/material.dart';
import 'package:swol/excerciseAddition/popUps/popUpFunctions.dart';

//internal from addition
import 'package:swol/excerciseAddition/secondary/trainingTypeHelpers.dart';

//internal from shared
import 'package:swol/sharedWidgets/informationDisplay.dart';
import 'package:swol/sharedWidgets/mySlider.dart';
import 'package:swol/sharedWidgets/timeHelper.dart';

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
              popUpFunction: () => repTargetPopUp(context),
            ),
          ),
          Container(
            child: Padding(
              padding: const EdgeInsets.only(
                left: 16.0,
              ),
              child: Theme(
                data: ThemeData.light(),
                child: AnimRepTargetInfoWhite(
                  changeDuration: changeDuration, 
                  sliderWidth: sliderWidth, 
                  repTargetDuration: repTargetDuration,
                ),
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

class AnimRepTargetInfoWhite extends StatelessWidget {
  const AnimRepTargetInfoWhite({
    Key key,
    @required this.changeDuration,
    @required this.sliderWidth,
    @required this.repTargetDuration,
  }) : super(key: key);

  final Duration changeDuration;
  final double sliderWidth;
  final ValueNotifier<Duration> repTargetDuration;

  @override
  Widget build(BuildContext context) {
    return AnimatedRecoveryTimeInfo(
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
            iconID: FitIcons.Strength,
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
            iconID: FitIcons.Hypertrophy,
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
            iconID: FitIcons.Endurance,
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
    );
  }
}