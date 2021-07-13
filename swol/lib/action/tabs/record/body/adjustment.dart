//flutter
import 'package:flutter/material.dart';

//internal: action
import 'package:swol/action/tabs/record/body/inaccuracy.dart';
import 'package:swol/action/shared/halfColored.dart';
import 'package:swol/action/shared/setDisplay.dart';
import 'package:swol/action/popUps/textValid.dart';
import 'package:swol/action/page.dart';

//internal: shared
import 'package:swol/shared/widgets/simple/curvedCorner.dart';
import 'package:swol/shared/structs/anExercise.dart';

//internal: other
import 'package:swol/other/functions/1RM&R=W.dart';
import 'package:swol/other/functions/1RM&W=R.dart';
import 'package:swol/other/functions/W&R=1RM.dart';

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
  updatePredictionID() {
    updateGoal();
  }

  //when the weight updates
  //we update the rep estimates
  weightWasUpdated({bool updateTheGoal: true}) {
    //we use 1RM and weight to get reps
    //this is bause maybe we wanted them to do 125 for 5 but they only had 120
    //so ideally we want to match their weight here and take it from ther
    String setWeightString = ExercisePage.setWeight.value;
    bool weightRecordedValid = isTextParsedIsLargerThan0(setWeightString);
    double weight = weightRecordedValid ? double.parse(setWeightString) : 0;

    //update the goal
    if (updateTheGoal) updateGoal();
  }

  //when the rep updates
  //we update the weight estimates
  repsWereUpdated({bool updateTheGoal: true}) {
    //we use 1RM and reps to get weights
    String setRepsString = ExercisePage.setReps.value;
    bool repsRecordedValid = isTextParsedIsLargerThan0(setRepsString);
    int reps = repsRecordedValid ? int.parse(setRepsString) : 0;

    //update the goal
    if (updateTheGoal) updateGoal();
  }

  @override
  void initState() {
    //super init
    super.initState();

    //init values
    weightWasUpdated(updateTheGoal: false);
    repsWereUpdated(updateTheGoal: false);
    updateGoal();

    //add listeners
    ExercisePage.setWeight.addListener(weightWasUpdated);
    ExercisePage.setReps.addListener(repsWereUpdated);
  }

  @override
  void dispose() {
    //remove listeners
    ExercisePage.setWeight.removeListener(weightWasUpdated);
    ExercisePage.setReps.removeListener(repsWereUpdated);

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
      useAccent: false,
      title: "Predicted",
      heroUp: widget.heroUp,
      animate: true,
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
          /*
          Expanded(
            child: Center(
              child: InaccuracyCalculator(
                exercise: widget.exercise,
                predictionID: predictionID,
              ),
            ),
          ),
          */
          Spacer(),
        ],
      ),
    );
  }

  //update the goal set based on init
  //and changed valus
  updateGoal() {
    bool allRepsEstimatesValid = true;
    bool allWeightEstimatesValid = true;

    //upate the goal set
    if (allRepsEstimatesValid) {
      //use recorded weight
      //ExercisePage.setGoalWeight.value = int.parse(ExercisePage.setWeight.value).toDouble();

      //get calculated reps
      //NOTE: may be a double
      //ExercisePage.setGoalReps.value = repEstimates[predictionID.value];
    } else {
      if (allWeightEstimatesValid) {
        //get calculatd weight
        //ExercisePage.setGoalWeight.value = weightEstimates[predictionID.value];

        //use recorded reps
        //NOTE: will only ever be integer
        //ExercisePage.setGoalReps.value = int.parse(ExercisePage.setReps.value).toDouble();
      } else {
        //get calculated weight
        //ExercisePage.setGoalWeight.value = weight;

        //use recorded reps
        //NOTE: will only ever be integer
        //ExercisePage.setGoalReps.value = widget.exercise.repTarget.toDouble();
      }
    }

    //update the sorting of things
    bool weightValid = isTextParsedIsLargerThan0(ExercisePage.setWeight.value);
    bool repsValid = isTextParsedIsLargerThan0(ExercisePage.setReps.value);
    bool setValid = weightValid && repsValid;
  }
}
