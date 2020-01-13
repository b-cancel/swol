//flutter
import 'package:flutter/material.dart';
import 'package:swol/excerciseAddition/popUps/popUpFunctions.dart';

//internal from addition
import 'package:swol/excerciseAddition/secondary/trainingTypeHelpers.dart';

//internal from shared
import 'package:swol/sharedWidgets/informationDisplay.dart';
import 'package:swol/sharedWidgets/mySlider.dart';
import 'package:swol/sharedWidgets/timeHelper.dart';

class RepTargetCard extends StatefulWidget {
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
  _RepTargetCardState createState() => _RepTargetCardState();
}

class _RepTargetCardState extends State<RepTargetCard> {
  repTargetUpdate(){
    widget.repTargetDuration.value = Duration(
      seconds: widget.repTarget.value * 5,
    );
  }

  @override
  void initState() {
    //handle listeners that will then make it possible to give tips all throghout
    widget.repTarget.addListener(repTargetUpdate);

    //super init
    super.initState();
  }

  @override
  void dispose() {
    widget.repTarget.removeListener(repTargetUpdate);

    //super dispose 
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.dark(),
      child: Card(
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
                    changeDuration: widget.changeDuration, 
                    sliderWidth: widget.sliderWidth, 
                    repTargetDuration: widget.repTargetDuration,
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
                color: Colors.black, //line color
                height: 2,
                width: MediaQuery.of(context).size.width,
              ),
            ),
            CustomSlider(
              value: widget.repTarget,
              lastTick: 35,
            ),
          ],
        ),
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
          left: new SliderTipButton(
            buttonText: "1",
          ),
          right: SliderTipButton(
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
          left: SliderTipButton(
            buttonText: "7",
          ),
          right: SliderTipButton(
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
          left: SliderTipButton(
            buttonText: "13",
          ),
          right: SliderTipButton(
            buttonText: "35",
            tipText: "Any More, and we won't be able to estimate your 1 Rep Max",
          ),
          startSeconds: (13*5),
          endSeconds: (35*5),
        )
      ],
    );
  }
}