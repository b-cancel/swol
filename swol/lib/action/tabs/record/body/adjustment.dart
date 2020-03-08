//flutter
import 'package:flutter/material.dart';

//internal: action
import 'package:swol/action/tabs/record/body/inaccuracy.dart';
import 'package:swol/action/shared/changeFunction.dart';
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
    Key key,
    @required this.topColor,
    @required this.heroUp,
    @required this.heroAnimDuration,
    @required this.heroAnimTravel,
    @required this.exercise,
    @required this.functionIDToWeightFromRT,
  }) : super(key: key);

  final Color topColor;
  final AnExercise exercise;
  final ValueNotifier<bool> heroUp;
  final Duration heroAnimDuration;
  final double heroAnimTravel;
  final ValueNotifier<List<double>> functionIDToWeightFromRT;

  @override
  _MakeFunctionAdjustmentState createState() => _MakeFunctionAdjustmentState();
}

class _MakeFunctionAdjustmentState extends State<MakeFunctionAdjustment> {
  final ValueNotifier<int> predictionID = new ValueNotifier<int>(0);

  //rep estimates
  final List<double> repEstimates = new List<double>(8);
  bool allRepsEstimatesValid = false;

  //weight estimates
  final List<double> weightEstimates = new List<double>(8);
  bool allWeightEstimatesValid = false;

  updatePredictionID() {
    widget.exercise.predictionID = predictionID.value;
    updateGoal();
  }

  //when the weight updates
  //we update the rep estimates
  weightWasUpdated({bool updateTheGoal: true}) {
    //we use 1RM and weight to get reps
    //this is bause maybe we wanted them to do 125 for 5 but they only had 120
    //so ideally we want to match their weight here and take it from ther
    String setWeightString = ExercisePage?.setWeight?.value ?? "";
    bool weightRecordedValid = isTextValid(setWeightString);
    double weight = weightRecordedValid ? double.parse(setWeightString) : 0;

    //check conditions
    if (weightRecordedValid) {
      //if the weight is valid you can estimate reps
      //calculate all the rep-estimates for all functions
      for (int thisFunctionID = 0; thisFunctionID < 8; thisFunctionID++) {
        repEstimates[thisFunctionID] = ToReps.from1RMandWeight(
          ExercisePage.oneRepMaxes[thisFunctionID],
          //use recorded weight
          //since we are assuming
          //that's what the user couldn't change
          weight,
          thisFunctionID,
        ); //no such thing as 9.5 reps
      }

      //make sure all yield valid resuls
      for (int thisFunctionID = 0; thisFunctionID < 8; thisFunctionID++) {
        int repsEstimate = repEstimates[thisFunctionID].round();
        bool zeroOrLess = (repsEstimate <= 0);
        //NOTE: our encouraged upperbound is 35
        //but we don't want to limit things too much
        //so that this bit is never usefull
        //so we set it at a 100
        bool aboveUpperBound = (999 < repsEstimate);
        if (zeroOrLess || aboveUpperBound) {
          weightRecordedValid = false;
          break;
        }
      }

      //if weight is still valid, then all rep estimates valid
      allRepsEstimatesValid = weightRecordedValid;
    } else
      allRepsEstimatesValid = false;

    print("estimatedReps:  " +
        allRepsEstimatesValid.toString() +
        " => " +
        repEstimates.toString());

    //update the goal
    if (updateTheGoal) updateGoal();
  }

  //when the rep updates
  //we update the weight estimates
  repsWereUpdated({bool updateTheGoal: true}) {
    //we use 1RM and reps to get weights
    String setRepsString = ExercisePage?.setReps?.value ?? "";
    bool repsRecordedValid = isTextValid(setRepsString);
    int reps = repsRecordedValid ? int.parse(setRepsString) : 0;

    //reps are valid so if we can use them
    if (repsRecordedValid) {
      //calculate are weight estimates
      for (int thisFunctionID = 0; thisFunctionID < 8; thisFunctionID++) {
        weightEstimates[thisFunctionID] = ToWeight.fromRepAnd1Rm(
          reps,
          ExercisePage.oneRepMaxes[thisFunctionID],
          thisFunctionID,
        );
      }

      //make sure all yield valid results
      for (int thisFunctionID = 0; thisFunctionID < 8; thisFunctionID++) {
        int weightEstimate = weightEstimates[thisFunctionID].round();
        bool zeroOrLess = (weightEstimate <= 0);
        bool aboveUpperBound = (9999 < weightEstimate);
        if (zeroOrLess || aboveUpperBound) {
          repsRecordedValid = false;
          break;
        }
      }

      //if reps is still valid, then all weight estimates are valid
      allWeightEstimatesValid = repsRecordedValid;
    } else
      allWeightEstimatesValid = false;

    print("estimatedWeights: " +
        allWeightEstimatesValid.toString() +
        " => " +
        weightEstimates.toString());

    //update the goal
    if (updateTheGoal) updateGoal();
  }

  @override
  void initState() {
    //super init
    super.initState();

    //init values
    predictionID.value = widget.exercise.predictionID;
    weightWasUpdated(updateTheGoal: false);
    repsWereUpdated(updateTheGoal: false);
    updateGoal();

    //add listeners
    predictionID.addListener(updatePredictionID);
    ExercisePage.setWeight.addListener(weightWasUpdated);
    ExercisePage.setReps.addListener(repsWereUpdated);
  }

  @override
  void dispose() {
    //remove listeners
    predictionID.removeListener(updatePredictionID);
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
      title: "Goal Set",
      heroUp: widget.heroUp,
      heroAnimDuration: widget.heroAnimDuration,
      heroAnimTravel: widget.heroAnimTravel,
    );

    print("---------------build");

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
                        ])
                  ],
                ),
              ),
            ],
          ),
          Expanded(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  InaccuracyCalculator(
                    exercise: widget.exercise,
                    predictionID: predictionID,
                  ),
                  ChangeFunction(
                    functionID: predictionID,
                    middleArrows: true,
                  ),
                ],
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
    List<double> valuesToSortWith;
    
    //upate the goal set
    if (allRepsEstimatesValid) {
      print("*****Using recorded weight");
      valuesToSortWith = repEstimates;

      //use recorded weight
      ExercisePage.setGoalWeight.value =
          int.parse(ExercisePage.setWeight.value).toDouble();

      //get calculated reps
      //NOTE: may be a double
      ExercisePage.setGoalReps.value = repEstimates[predictionID.value];
    } else {
      if (allWeightEstimatesValid) {
        print("*****Using recorded reps");
        valuesToSortWith = weightEstimates;

        //get calculatd weight
        ExercisePage.setGoalWeight.value = weightEstimates[predictionID.value];

        //use recorded reps
        //NOTE: will only ever be integer
        ExercisePage.setGoalReps.value =
            int.parse(ExercisePage.setReps.value).toDouble();
      } else {
        print("*****Using rep target");
        valuesToSortWith = widget.functionIDToWeightFromRT.value;

        //avoid init issue
        double weight =
            widget?.functionIDToWeightFromRT?.value[predictionID.value] ?? 0;
        //get calculated weight
        ExercisePage.setGoalWeight.value = weight;

        //use recorded reps
        //NOTE: will only ever be integer
        ExercisePage.setGoalReps.value = widget.exercise.repTarget.toDouble();
      }
    }

    //update the sorting of things
    bool weightValid = isTextValid(ExercisePage.setWeight.value);
    bool repsValid = isTextValid(ExercisePage.setReps.value);
    bool setValid = weightValid && repsValid;
    if(setValid) valuesToSortWith = getPercentDifferences();
    updateOrderOfIDs(valuesToSortWith);
  }

  getPercentDifferences() {
    //get the values we will use to sort the function IDs
    List<double> percentDifferences = new List<double>(8);
    for (int functionID = 0; functionID < 8; functionID++) {
      //get the 1RM from this Set
      double calculated1RM = To1RM.fromWeightAndReps(
        double.parse(ExercisePage.setWeight.value),
        int.parse(ExercisePage.setReps.value),
        functionID,
      );

      //get the difference between this and what was expected
      double calculatedDifference = calcPercentDifference(
        ExercisePage.oneRepMaxes[functionID],
        calculated1RM,
      );

      //add for use later (-1 for right order)
      percentDifferences[functionID] = calculatedDifference * -1;
    }
    return percentDifferences;
  }
}
