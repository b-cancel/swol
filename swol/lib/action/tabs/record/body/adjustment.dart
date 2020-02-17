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
    @required this.heroUp,
    @required this.heroAnimDuration,
    @required this.heroAnimTravel,
    @required this.excercise,
  }) : super(key: key);

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
    //calc oneRM based on previous set
    double oneRM = To1RM.fromWeightAndReps(
      widget.excercise.lastWeight.toDouble(), 
      widget.excercise.lastReps.toDouble(), 
      widget.excercise.predictionID,
    );

    //TODO: if our set weight is valid 
    //TODO: and perhaps if our reps are also below a certain value
    //we use 1m and weight to get reps
    //this is bause maybe we wanted them to do 125 for 5 but they only had 120
    //so ideally we want to match their weight here and take it from ther
    if(isTextValid(ExcercisePage.setWeight.value)){
      print("weight valid *******************************");
      ExcercisePage.setGoalWeight.value = int.parse(ExcercisePage.setWeight.value);

      //calc goal reps based on goal weight
      ExcercisePage.setGoalReps.value = ToReps.from1RMandWeight(
        oneRM, 
        ExcercisePage.setGoalWeight.value.toDouble(), 
        widget.excercise.predictionID,
      ).round();
    }
    else{
      print("NOT valid *******************************");
      ExcercisePage.setGoalReps.value = widget.excercise.repTarget;

      //calc goal weight based on goal reps
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
            height: 24,
            color: Theme.of(context).accentColor,
          ),
          TopBackgroundColored(
            color: Theme.of(context).accentColor,
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