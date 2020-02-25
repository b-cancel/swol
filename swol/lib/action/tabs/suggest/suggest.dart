//flutter
import 'package:flutter/material.dart';

//internal: action
import 'package:swol/action/tabs/suggest/changeSuggestion.dart';
import 'package:swol/action/shared/toFunctionOrder.dart';
import 'package:swol/action/bottomButtons/button.dart';
import 'package:swol/action/shared/halfColored.dart';
import 'package:swol/action/shared/setDisplay.dart';
import 'package:swol/action/page.dart';

//internal: other
import 'package:swol/shared/structs/anExcercise.dart';

//widget
class Suggestion extends StatefulWidget {
  Suggestion({
    @required this.excercise,
    @required this.heroUp,
    @required this.heroAnimDuration,
    @required this.heroAnimTravel,
  });

  final AnExcercise excercise;
  final ValueNotifier<bool> heroUp;
  final Duration heroAnimDuration;
  final double heroAnimTravel;

  @override
  _SuggestionState createState() => _SuggestionState();
}

class _SuggestionState extends State<Suggestion> {
  final ValueNotifier<List<double>> functionIDToWeight = new ValueNotifier<List<double>>(new List<double>(8));

  //function select
  final ValueNotifier<int> predictionID = new ValueNotifier<int>(0);

  //set target set
  final ValueNotifier<int> repTarget = new ValueNotifier<int>(0);

  //update the goal set based on init
  //and changed valus
  updateGoalWeight(){
    //grab correct goal weight
    ExcercisePage.setGoalWeight.value = functionIDToWeight.value[
      widget.excercise.predictionID
    ].round();
  }

  updatePredictionID(){
    widget.excercise.predictionID = predictionID.value;
    //retreive new weight
    updateGoalWeight();
  }

  updateRepTarget(){
    //update it in the file
    widget.excercise.repTarget = repTarget.value;
    ExcercisePage.setGoalReps.value = repTarget.value; //TODO: notifier not value?

    //recalculate all weight with new rep target
    functionIDToWeight.value = calcAllWeightsWithReps(
      repTarget.value, //TODO: notifier not value?
    );

    //update the goal by chosing from everything we
    updateGoalWeight();
  }

  @override
  void initState() {
    //super init
    super.initState();
    
    //set inits
    predictionID.value = widget.excercise.predictionID;
    repTarget.value = widget.excercise.repTarget;
    updateRepTarget();

    //add listeners
    predictionID.addListener(updatePredictionID);
    repTarget.addListener(updateRepTarget);
  }

  @override
  void dispose() {
    predictionID.removeListener(updatePredictionID);
    repTarget.removeListener(updateRepTarget);

    //dipose stuffs
    predictionID.dispose();
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
    int setsPassed = widget.excercise.tempSetCount ?? 0;
    bool timerNotStarted = widget.excercise.tempStartTime.value == AnExcercise.nullDateTime;
    if(timerNotStarted) setsPassed += 1;

    //color for bottom buttons
    bool lastSetOrBefore = setsPassed <= widget.excercise.setTarget;
    Color buttonsColor =  lastSetOrBefore ? Theme.of(context).accentColor : Theme.of(context).cardColor;

    //build
    return ClipRRect(
      //clipping so "hero" doesn't show up in the other page
      child: Column(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                bottom: 24, //extra for the complete button
              ),
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    TopBackgroundColored(
                      color: Theme.of(context).cardColor,
                      child: SetDisplay(
                        excercise: widget.excercise,
                        useAccent: false,
                        extraCurvy: true,
                        title: "Last Set",
                      ),
                    ),
                    Expanded(
                      child: SuggestionChanger(
                        predictionID: predictionID,
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
                        heroAnimDuration: widget.heroAnimDuration,
                        heroAnimTravel: widget.heroAnimTravel,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          BottomButtons(
            color: buttonsColor,
            excerciseID: widget.excercise.id,
            forwardAction: () {
              ExcercisePage.pageNumber.value = 1;
            },
            forwardActionWidget: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: timerNotStarted ? "Record" : "View",
                  ),
                  TextSpan(
                    text: " Set " + setsPassed.toString(),
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(
                    text: "/" + widget.excercise.setTarget.toString(),
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
