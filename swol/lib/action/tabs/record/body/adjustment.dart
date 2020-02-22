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
import 'package:swol/shared/structs/anExcercise.dart';

//internal: other
import 'package:swol/other/functions/1RM&R=W.dart';
import 'package:swol/other/functions/1RM&W=R.dart';

//widget
class MakeFunctionAdjustment extends StatefulWidget {
  const MakeFunctionAdjustment({
    Key key,
    @required this.topColor,
    @required this.heroUp,
    @required this.heroAnimDuration,
    @required this.heroAnimTravel,
    @required this.excercise,
  }) : super(key: key);

  final Color topColor;
  final AnExcercise excercise;
  final ValueNotifier<bool> heroUp;
  final Duration heroAnimDuration;
  final double heroAnimTravel;

  @override
  _MakeFunctionAdjustmentState createState() => _MakeFunctionAdjustmentState();
}

class _MakeFunctionAdjustmentState extends State<MakeFunctionAdjustment> {
  final ValueNotifier<int> predictionID = new ValueNotifier<int>(0);

  //rep estimates
  final List<int> repEstimates = new List<int>(8);
  final ValueNotifier<bool> allRepsEstimatesValid = new ValueNotifier<bool>(false);

  //weight estimates
  final List<int> weightEstimates = new List<int>(8);
  final ValueNotifier<bool> allWeightEstimatesValid = new ValueNotifier<bool>(false);

  updatePredictionID(){
    widget.excercise.predictionID = predictionID.value;
    updateGoal();
  }

  weightWasUpdated({bool updateTheGoal: true}){
    //when the weight updates
    //we update the rep estimates
    //TODO: complete
    /*
    //we use 1m and weight to get reps
    //this is bause maybe we wanted them to do 125 for 5 but they only had 120
    //so ideally we want to match their weight here and take it from ther
    String setWeightString = ExcercisePage?.setWeight?.value ?? "";
    bool weightUseValid = isTextValid(setWeightString);
    double weight = weightUseValid ? double.parse(setWeightString) : 0;

    //check conditions
    List<int> repEstimates = new List<int>(8);
    if (weightUseValid){
      //if the weight is valid you can estimate reps
      //calculate all the rep-estimates for all functions
      for (int thisFunctionID = 0; thisFunctionID < 8; thisFunctionID++) {
        repEstimates[thisFunctionID] = ToReps.from1RMandWeight(
          ExcercisePage.oneRepMaxes[thisFunctionID],
          //use recorded weight
          //since we are assuming
          //that's what the user couldn't change
          weight,
          thisFunctionID,
        ).round();
      }

      //make sure all yield valid resuls
      for (int thisFunctionID = 0; thisFunctionID < 8; thisFunctionID++) {
        int estimate = repEstimates[thisFunctionID];
        bool zeroOrLess = (estimate <= 0);
        //NOTE: our encouraged upperbound is 35
        //but we don't want to limit things too much
        //so that this bit is never usefull
        //so we set it at a 100
        bool aboveUpperBound = (101 < estimate);
        if (zeroOrLess || aboveUpperBound) {
          weightUseValid = false;
          break;
        }
      }
    }

    print(repEstimates.toString());

    */

    //update the goal
    if(updateTheGoal) updateGoal();
  }

  repsWereUpdated({bool updateTheGoal: true}){
    //when the rep updates
    //we update the weight estimates
    //TODO: complete

    //update the goal
    if(updateTheGoal) updateGoal();
  }

  @override
  void initState() {
    //super init
    super.initState();

    //init values
    predictionID.value = widget.excercise.predictionID;
    weightWasUpdated(updateTheGoal: false);
    repsWereUpdated(updateTheGoal: false);
    updateGoal();

    //add listeners
    predictionID.addListener(updatePredictionID);
    ExcercisePage.setWeight.addListener(weightWasUpdated);
    ExcercisePage.setReps.addListener(repsWereUpdated);
  }

  @override
  void dispose() {
    //remove listeners
    predictionID.removeListener(updatePredictionID);
    ExcercisePage.setWeight.removeListener(weightWasUpdated);
    ExcercisePage.setReps.removeListener(repsWereUpdated);

    //super dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget topBit = Container(
      width: MediaQuery.of(context).size.width,
      height:widget.topColor == Theme.of(context).accentColor ? 24 : 4,
      color: widget.topColor,
    );

    Widget goalSet = SetDisplay(
      useAccent: false,
      title: "Goal Set",
      heroUp: widget.heroUp,
      heroAnimDuration: widget.heroAnimDuration,
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
                      children:[
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
                      ]
                    )
                  ],
                ),
              ),
            ],
          ),
          Expanded(
            child: InaccuracyCalculator(
              excercise: widget.excercise,
              predictionID: predictionID,
            ),
          ),
        ],
      ),
    );
  }

  //update the goal set based on init
  //and changed valus
  updateGoal() {
    if (allWeightEstimatesValid.value) {
      //get calculated reps
      ExcercisePage.setGoalReps.value = repEstimates[predictionID.value];
      ExcercisePage.setGoalWeight.value = int.parse(ExcercisePage.setWeight.value);
    } else {
      if(allRepsEstimatesValid.value){
        //get calculatd weight
        ExcercisePage.setGoalWeight.value = weightEstimates[predictionID.value];
        ExcercisePage.setGoalReps.value = int.parse(ExcercisePage.setReps.value);
      }
      else{
        //update goal reps
        ExcercisePage.setGoalReps.value = widget.excercise.repTarget;

        //calc goal weight based on goal reps
        ExcercisePage.setGoalWeight.value = ToWeight.fromRepAnd1Rm(
          //rep target used
          (widget.excercise.repTarget).toDouble(), 
          //one rep max that uses the same function as below
          ExcercisePage.oneRepMaxes[
            predictionID.value
          ], 
          //function index to use
          predictionID.value,
        ).round();
      }
    }
  }
}