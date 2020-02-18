import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:swol/action/page.dart';
import 'package:swol/action/popUps/textValid.dart';
import 'package:swol/action/shared/changeFunction.dart';
import 'package:swol/action/shared/halfColored.dart';
import 'package:swol/action/shared/setDisplay.dart';
import 'package:swol/other/functions/1RM&R=W.dart';
import 'package:swol/other/functions/1RM&W=R.dart';
import 'package:swol/other/functions/W&R=1RM.dart';
import 'package:swol/shared/structs/anExcercise.dart';

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

  //update the goal set based on init
  //and changed valus
  updateGoal(){
    //we use 1m and weight to get reps
    //this is bause maybe we wanted them to do 125 for 5 but they only had 120
    //so ideally we want to match their weight here and take it from ther
    String setWeightString = ExcercisePage.setWeight.value;
    bool weightUseValid = isTextValid(setWeightString);
    double weight = weightUseValid ? double.parse(setWeightString) : 0;

    //check conditions
    List<int> repEstimates = new List<int>(8);
    if(weightUseValid){ //if the weight is valid you can estimate reps
      //calculate all the rep-estimates for all functions
      for(int thisFunctionID = 0; thisFunctionID < 8; thisFunctionID++){
        //calc the 1 rep max if we go this route
        double oneRM = To1RM.fromWeightAndReps(
          widget.excercise.lastWeight.toDouble(), 
          widget.excercise.lastReps.toDouble(), 
          thisFunctionID,
        );

        //calc the rep estimate
        repEstimates[thisFunctionID] = ToReps.from1RMandWeight(
          oneRM, 
          //use recorded weight
          //since we are assuming 
          //that's what the user couldn't change
          weight, 
          thisFunctionID,
        ).round();
      }

      //make sure all yield valid resuls
      for(int thisFunctionID = 0; thisFunctionID < 8; thisFunctionID++){
        int estimate = repEstimates[thisFunctionID];
        bool zeroOrLess = (estimate <= 0);
        //NOTE: our encouraged upperbound is 35
        //but we don't want to limit things too much 
        //so that this bit is never usefull
        //so we set it at a 100
        bool aboveUpperBound  = (101 < estimate);
        if(zeroOrLess || aboveUpperBound){
          weightUseValid = false;
          break;
        }
      }
    }
    
    //only if all conditions are met do we use our inverse guess
    //this should only happen under very specific circumstances
    if(weightUseValid){ //calculate reps
      ExcercisePage.setGoalReps.value = repEstimates[predictionID.value];
      ExcercisePage.setGoalWeight.value = weight.round();
    }
    else{ //calculate weight
      double oneRM = To1RM.fromWeightAndReps(
        widget.excercise.lastWeight.toDouble(), 
        widget.excercise.lastReps.toDouble(), 
        widget.excercise.predictionID,
      );

      ExcercisePage.setGoalReps.value = widget.excercise.repTarget;
      ExcercisePage.setGoalWeight.value = ToWeight.fromRepAnd1Rm(
        ExcercisePage.setGoalReps.value.toDouble(), 
        oneRM, 
        widget.excercise.predictionID,
      ).round();
    }
  }
  
  updatePredictionID() {
    widget.excercise.predictionID = predictionID.value;
    updateGoal();
  }

  @override
  void initState() {
    //super init
    super.initState();

    //init value and notifier addition
    predictionID.value = widget.excercise.predictionID;

    //add listeners
    predictionID.addListener(updatePredictionID);
    ExcercisePage.setWeight.addListener(updateGoal);

    //update goal initially before notifiers
    updateGoal();
  }

  @override
  void dispose() { 
    //remove listeners
    predictionID.removeListener(updatePredictionID);
    ExcercisePage.setWeight.removeListener(updateGoal);

    //super dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //color for "suggestion"
    //TODO: because we are wrapped in a white so the pop up works well
    //TODO: this distance color will be white even though it should be the dark card color
    //TODO: fix that... maybe... clean white is kinda cool to
    Color distanceColor = Theme.of(context).cardColor;
    int id = 0;
    if (id == 1)
      distanceColor = Colors.red.withOpacity(0.33);
    else if (id == 2)
      distanceColor = Colors.red.withOpacity(0.66);
    else if (id == 3) distanceColor = Colors.red;

    return Container(
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            height: widget.topColor == Theme.of(context).accentColor ? 24 : 4,
            color: widget.topColor,
          ),
          TopBackgroundColored(
            color: widget.topColor,
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.all(
                  Radius.circular(24),
                ),
              ),
              child: SetDisplay(
                useAccent: false,
                title: "Goal Set",
                heroUp: widget.heroUp,
                heroAnimDuration: widget.heroAnimDuration,
                heroAnimTravel: widget.heroAnimTravel,
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Container(
                        child: Text(
                          "24",
                          style: GoogleFonts.robotoMono(
                            color: distanceColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 96,
                            wordSpacing: 0,
                          ),
                        ),
                      ),
                      DefaultTextStyle(
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              Icon(
                                FontAwesomeIcons.percentage,
                                color: distanceColor,
                                size: 42,
                              ),
                              Text(
                                "higher",
                                style: TextStyle(
                                  fontSize: 42,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Transform.translate(
                    offset: Offset(0, -16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Center(
                          child: Text(
                            "than calculated by the",
                            style: TextStyle(
                              fontSize: 22,
                            ),
                          ),
                        ),
                        ChangeFunction(
                          predictionID: predictionID,
                          middleArrows: true,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}