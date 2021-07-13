//flutter
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:swol/action/page.dart';

//internal
import 'package:swol/shared/widgets/complex/fields/fields/sliders/sliderField.dart';
import 'package:swol/shared/widgets/complex/rangeInformation/animatedCarousel.dart';
import 'package:swol/shared/widgets/complex/fields/headers/fieldHeader.dart';
import 'package:swol/shared/widgets/simple/oneOrTheOtherIcon.dart';
import 'package:swol/shared/widgets/simple/ourToolTip.dart';
import 'package:swol/shared/widgets/simple/sliderTipButton.dart';
import 'package:swol/shared/functions/trainingPopUps.dart';
import 'package:swol/shared/structs/range.dart';
import 'package:swol/shared/methods/theme.dart';

//NOTE: this widget should not dispose its passed rep target
class RepTargetField extends StatefulWidget {
  RepTargetField({
    required this.repTarget,
    required this.subtle,
    required this.darkTheme,
  });

  final ValueNotifier<int> repTarget;
  final bool subtle;
  final bool darkTheme;

  @override
  _RepTargetFieldState createState() => _RepTargetFieldState();
}

class _RepTargetFieldState extends State<RepTargetField> {
  late ValueNotifier<Duration> repTargetDuration;

  repTargetUpdate() {
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
      indicator: Theme(
        data: MyTheme.light,
        child: AnimRepTargetInfoWhite(
          repTargetDuration: repTargetDuration,
          darkTheme: widget.darkTheme,
        ),
      ),
      belowIndicator: Padding(
        padding: EdgeInsets.only(
          bottom: 16,
        ),
        child: Material(
          color: Colors.blue,
          borderRadius: BorderRadius.all(
            Radius.circular(16),
          ),
          child: InkWell(
            onTap: () {
              showWidgetToolTip(
                context,
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    BotToast.cleanAll();
                  },
                  child: DefaultTextStyle(
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Wrap(
                          children: <Widget>[
                            Text(
                              "Edit",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              " your Rep Target ",
                            ),
                            Text(
                              "with the slider below",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                direction: PreferDirection.topCenter,
                seconds: 8,
              );
            },
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 56,
              padding: EdgeInsets.all(
                8,
              ),
              child: FittedBox(
                fit: BoxFit.contain,
                child: ReloadOnGoalChange(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ReloadOnGoalChange extends StatefulWidget {
  const ReloadOnGoalChange({
    Key? key,
  }) : super(key: key);

  @override
  _ReloadOnGoalChangeState createState() => _ReloadOnGoalChangeState();
}

class _ReloadOnGoalChangeState extends State<ReloadOnGoalChange> {
  updateState() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    ExercisePage.setGoalWeight.addListener(updateState);
    ExercisePage.setGoalPlusMinus.addListener(updateState);
    ExercisePage.setGoalReps.addListener(updateState);
  }

  @override
  void dispose() {
    ExercisePage.setGoalWeight.removeListener(updateState);
    ExercisePage.setGoalPlusMinus.removeListener(updateState);
    ExercisePage.setGoalReps.removeListener(updateState);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //gather
    String weight = ExercisePage.setGoalWeight.value.round().toString();
    int plusMinus = ExercisePage.setGoalPlusMinus.value.round().abs();
    int reps = ExercisePage.setGoalReps.value.round();

    //build
    return DefaultTextStyle(
      style: TextStyle(
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(weight),
              Icon(
                FontAwesomeIcons.dumbbell,
                color: Colors.white,
                size: 6,
              ),
            ],
          ),
          Visibility(
            visible: plusMinus > 0,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 10,
                  width: 10,
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: OneOrTheOtherIcon(
                      iconColor: Colors.white,
                      backgroundColor: Colors.blue,
                      one: Icon(
                        FontAwesomeIcons.plus,
                        color: Colors.white,
                      ),
                      other: Icon(
                        FontAwesomeIcons.minus,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Text(plusMinus.toString()),
              ],
            ),
          ),
          Text(" for "),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(reps.toString()),
              Icon(
                Icons.repeat,
                color: Colors.white,
                size: 6,
              ),
            ],
          ),
          Text("rep" + (reps == 1 ? "" : "s")),
        ],
      ),
    );
  }
}

//used by rep target (BoxFit.contained) and within white theme
class AnimRepTargetInfoWhite extends StatelessWidget {
  const AnimRepTargetInfoWhite({
    Key? key,
    required this.repTargetDuration,
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
            blackText: darkTheme == false,
          ),
          right: SlideRangeExtent(
            buttonText: "6",
            blackText: darkTheme == false,
          ),
          startSeconds: (1 * 5),
          endSeconds: (6 * 5),
        ),
        Range(
          name: "Hypertrophy Training",
          onTap: makeHypertrophyTrainingPopUp(context, 3),
          left: SlideRangeExtent(
            buttonText: "7",
            blackText: darkTheme == false,
          ),
          right: SlideRangeExtent(
            buttonText: "12",
            blackText: darkTheme == false,
          ),
          startSeconds: (7 * 5),
          endSeconds: (12 * 5),
        ),
        Range(
          name: "Endurance Training",
          onTap: makeEnduranceTrainingPopUp(context, 3),
          left: SlideRangeExtent(
            buttonText: "13",
            blackText: darkTheme == false,
          ),
          right: SlideRangeExtent(
            buttonText: "35",
            blackText: darkTheme == false,
            tipText: "Any more than 30 reps" +
                "\n" +
                "has been shown to be in-effective for most",
            tipToLeft: false,
          ),
          startSeconds: (13 * 5),
          endSeconds: (35 * 5),
        )
      ],
    );
  }
}
