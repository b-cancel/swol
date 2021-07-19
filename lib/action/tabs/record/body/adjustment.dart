//flutter
import 'package:flutter/material.dart';

//internal: action
import 'package:swol/action/tabs/record/body/inaccuracy.dart';
import 'package:swol/action/shared/halfColored.dart';
import 'package:swol/action/shared/setDisplay.dart';
import 'package:swol/action/popUps/textValid.dart';
import 'package:swol/action/page.dart';
import 'package:swol/other/functions/helper.dart';

//internal: shared
import 'package:swol/shared/widgets/simple/curvedCorner.dart';
import 'package:swol/shared/structs/anExercise.dart';

//widget
class MakeFunctionAdjustment extends StatefulWidget {
  const MakeFunctionAdjustment({
    Key? key,
    required this.topColor,
    required this.heroUp,
    required this.heroAnimTravel,
    required this.exercise,
  }) : super(key: key);

  final Color topColor;
  final AnExercise exercise;
  final ValueNotifier<bool> heroUp;
  final double heroAnimTravel;

  @override
  _MakeFunctionAdjustmentState createState() => _MakeFunctionAdjustmentState();
}

class _MakeFunctionAdjustmentState extends State<MakeFunctionAdjustment> {
  @override
  void initState() {
    //super init
    super.initState();

    //init values
    updateGoal();

    //add listeners
    ExercisePage.setWeight.addListener(updateGoal);
    ExercisePage.setReps.addListener(updateGoal);
  }

  @override
  void dispose() {
    //remove listeners
    ExercisePage.setWeight.removeListener(updateGoal);
    ExercisePage.setReps.removeListener(updateGoal);

    //super dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget topBit = Container(
      width: MediaQuery.of(context).size.width,
      height: widget.topColor == Theme.of(context).accentColor ? 24 : 4,
      color: widget.topColor,
    );

    Widget goalSet = SetDisplay(
      repTarget: widget.exercise.repTarget,
      useAccent: false,
      title: "Adjusted",
      //heroUp: widget.heroUp,
      //animate: true,
      heroAnimTravel: widget.heroAnimTravel,
    );

    return Container(
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Stack(
            children: <Widget>[
              //the widget below is only for height
              Column(
                children: [
                  topBit,
                  TopBackgroundColored(
                    color: widget.topColor,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.all(
                          Radius.circular(24),
                        ),
                      ),
                      child: Opacity(
                        opacity: 0,
                        child: goalSet,
                      ),
                    ),
                  ),
                ],
              ),
              Positioned(
                bottom: 0,
                child: goalSet,
              ),
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    topBit,
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CurvedCorner(
                          isTop: true,
                          isLeft: true, //left
                          cornerColor: widget.topColor,
                        ),
                        CurvedCorner(
                          isTop: true,
                          isLeft: false, //right
                          cornerColor: widget.topColor,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          Expanded(
            child: Center(
              child: InaccuracyCalculator(
                exercise: widget.exercise,
              ),
            ),
          ),
        ],
      ),
    );
  }

  //update the goal set based on init
  //and changed valus
  updateGoal() {
    //we use 1RM and weight to get reps
    //this is bause maybe we wanted them to do 125 for 5 but they only had 120
    //so ideally we want to match their weight here and take it from ther
    String setWeightString = ExercisePage.setWeight.value;
    bool weightRecordedValid = isTextParsedIsLargerThan0(setWeightString);
    double weight =
        weightRecordedValid ? (double.tryParse(setWeightString) ?? 0) : 0;

    //we use 1RM and reps to get weights
    String setRepsString = ExercisePage.setReps.value;
    bool repsRecordedValid = isTextParsedIsLargerThan0(setRepsString);
    int reps = repsRecordedValid ? (int.tryParse(setRepsString) ?? 0) : 0;

    //if both valid -> pivot on weight...
    //if only weight valid -> pivot on weight...
    if ((reps > 0 && weight > 0) || weight > 0) {
      ExercisePage.setGoalWeight.value = weight;

      //calculate reps from weight and 1rm
      List maxRepValues = Functions.getMaxRepsWithGoalWeight(
        lastWeight: widget.exercise.lastWeight!.toDouble(),
        lastReps: widget.exercise.lastReps!,
        goalWeight: weight,
      );

      //adjusted will show +/- in the appropiate area
      ExercisePage.setGoalReps.value = maxRepValues[1]; //mean
      ExercisePage.setGoalPlusMinus.value = maxRepValues[2]; //std dev
    } else {
      //if only reps are valid -> pivot on reps
      if (reps > 0) {
        ExercisePage.setGoalReps.value = reps.toDouble();
      } else {
        //pivot on rep target
        ExercisePage.setGoalReps.value =
            widget.exercise.repTarget.abs().toDouble();
      }

      //calculate weight from reps and 1rm
      List maxWeightValues = Functions.getMaxWeightsWithGoalReps(
        lastWeight: widget.exercise.lastWeight!.toDouble(),
        lastReps: widget.exercise.lastReps!,
        goalReps: ExercisePage.setGoalReps.value.toInt(),
      );

      //adjusted will show +/- in the appropiate area
      ExercisePage.setGoalWeight.value = maxWeightValues[1]; //mean
      ExercisePage.setGoalPlusMinus.value = maxWeightValues[2]; //std dev
    }
  }
}
