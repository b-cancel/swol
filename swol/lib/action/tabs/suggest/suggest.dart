//flutter
import 'package:flutter/material.dart';

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
    required this.exercise,
    required this.heroUp,
    required this.heroAnimTravel,
  });

  final AnExercise exercise;
  final ValueNotifier<bool> heroUp;
  final double heroAnimTravel;

  @override
  _SuggestionState createState() => _SuggestionState();
}

class _SuggestionState extends State<Suggestion> {
  //set target set
  final ValueNotifier<int> repTarget = new ValueNotifier<int>(0);

  //update the goal set based on init
  //and changed valus
  updateGoalWeight() {
    //grab correct goal weight
    ExercisePage.setGoalWeight.value = 0;
  }

  updateRepTarget() {
    //update it in the file
    widget.exercise.repTarget = repTarget.value;
    ExercisePage.setGoalReps.value = repTarget.value.toDouble();

    //update the goal by chosing from everything we
    updateGoalWeight();
  }

  @override
  void initState() {
    //super init
    super.initState();

    //set inits
    repTarget.value = widget.exercise.repTarget;
    updateRepTarget();
    repTarget.addListener(updateRepTarget);
  }

  @override
  void dispose() {
    repTarget.removeListener(updateRepTarget);
    repTarget.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //card radius
    Radius arrowRadius = Radius.circular(48);
    Radius cardRadius = Radius.circular(24);

    //calc sets passed for bottom buttons
    int setsPassed = widget.exercise.tempSetCount ?? 0;
    //TODO: this should still work since if we are in the suggest page & our timer isn't null
    //that should only be because our set was valid and we didn't reset it when comming from record
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
                //move to page 1
                ExercisePage.pageNumber.value = 1;

                //start the timer IF it hasn't been started already
                bool timerStarted = (widget.exercise.tempStartTime.value !=
                    AnExercise.nullDateTime);
                if (timerStarted == false) {
                  //start timer
                  ExercisePage.toggleTimer.value = true;
                }
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
