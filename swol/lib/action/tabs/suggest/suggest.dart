//flutter
import 'package:flutter/material.dart';
import 'package:swol/action/doneButton/doneWidget.dart';

//internal: action
import 'package:swol/action/tabs/suggest/changeSuggestion.dart';
import 'package:swol/action/bottomButtons/button.dart';
import 'package:swol/action/shared/halfColored.dart';
import 'package:swol/action/shared/setDisplay.dart';
import 'package:swol/action/page.dart';

//internal: other
import 'package:swol/shared/structs/anExercise.dart';
import 'package:swol/other/functions/1RM&R=W.dart';

//widget
class Suggestion extends StatefulWidget {
  Suggestion({
    @required this.exercise,
    @required this.heroUp,
    @required this.heroAnimTravel,
    @required this.functionIDToWeightFromRT,
  });

  final AnExercise exercise;
  final ValueNotifier<bool> heroUp;
  final double heroAnimTravel;
  final ValueNotifier<List<double>> functionIDToWeightFromRT;

  @override
  _SuggestionState createState() => _SuggestionState();
}

class _SuggestionState extends State<Suggestion> {
  //function select
  final ValueNotifier<int> functionID = new ValueNotifier<int>(0);

  //set target set
  final ValueNotifier<int> repTarget = new ValueNotifier<int>(0);

  //update the goal set based on init
  //and changed valus
  updateGoalWeight() {
    //grab correct goal weight
    ExercisePage.setGoalWeight.value = widget.functionIDToWeightFromRT.value[
        functionID.value //NOTE: before we used the exercise value here
        ];
  }

  updatePredictionID() {
    widget.exercise.predictionID = functionID.value;
    //retreive new weight
    updateGoalWeight();
  }

  updateRepTarget() {
    //update it in the file
    widget.exercise.repTarget = repTarget.value;
    ExercisePage.setGoalReps.value = repTarget.value.toDouble();

    //recalculate all weight with new rep target
    List<double> functionIDToWeight = new List<double>(8);
    for (int functionID = 0; functionID < 8; functionID++) {
      double weight = ToWeight.fromRepAnd1Rm(
        //rep target used
        repTarget.value,
        //one rep max that uses the same function as below
        ExercisePage.oneRepMaxes[functionID],
        //function index to use
        functionID,
      );

      functionIDToWeight[functionID] = weight;
    }
    widget.functionIDToWeightFromRT.value = functionIDToWeight;

    //based on new results update order
    updateOrderOfIDs(functionIDToWeight);

    //update the goal by chosing from everything we
    updateGoalWeight();
  }

  @override
  void initState() {
    //super init
    super.initState();

    //set inits
    functionID.value = widget.exercise.predictionID;
    repTarget.value = widget.exercise.repTarget;
    updateRepTarget();

    //add listeners
    functionID.addListener(updatePredictionID);
    repTarget.addListener(updateRepTarget);
  }

  @override
  void dispose() {
    functionID.removeListener(updatePredictionID);
    repTarget.removeListener(updateRepTarget);

    //dipose stuffs
    functionID.dispose();
    repTarget.dispose();

    //super dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //card radius
    Radius arrowRadius = Radius.circular(48);
    Radius cardRadius = Radius.circular(24);

    //calc sets passed for bottom buttons
    int setsPassed = widget.exercise.tempSetCount ?? 0;
    bool timerNotStarted =
        widget.exercise.tempStartTime.value == AnExercise.nullDateTime;
    if (timerNotStarted) setsPassed += 1;

    //color for bottom buttons
    bool lastSetOrBefore = setsPassed <= widget.exercise.setTarget;
    Color buttonsColor = lastSetOrBefore
        ? Theme.of(context).accentColor
        : Theme.of(context).cardColor;

    //build
    return ClipRRect(
      //clipping so "hero" doesn't show up in the other page
      child: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  TopBackgroundColored(
                    color: Theme.of(context).cardColor,
                    child: SetDisplay(
                      exercise: widget.exercise,
                      useAccent: false,
                      extraCurvy: true,
                      title: "Last Set",
                    ),
                  ),
                  Expanded(
                    child: SuggestionChanger(
                      functionID: functionID,
                      repTarget: repTarget,
                      arrowRadius: arrowRadius,
                      cardRadius: cardRadius,
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).accentColor,
                      borderRadius: BorderRadius.only(
                        bottomRight: cardRadius,
                        bottomLeft: cardRadius,
                      ),
                    ),
                    width: MediaQuery.of(context).size.width,
                    child: SetDisplay(
                      useAccent: true,
                      title: "Goal Set",
                      heroUp: widget.heroUp,
                      animate: true,
                      heroAnimTravel: widget.heroAnimTravel,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            //for done button curve
            padding: EdgeInsets.only(
              top: 24,
            ),
            child: BottomButtons(
              color: buttonsColor,
              exerciseID: widget.exercise.id,
              forwardAction: () {
                ExercisePage.pageNumber.value = 1;
              },
              forwardActionWidget: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    timerNotStarted ? "Record" : "View",
                  ),
                  Text(
                    " Set " + setsPassed.toString(),
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  Text(
                    "/" + widget.exercise.setTarget.toString(),
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