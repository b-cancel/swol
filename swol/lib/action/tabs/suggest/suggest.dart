//flutter
import 'package:flutter/material.dart';
import 'package:swol/action/shared/halfColored.dart';
import 'package:swol/action/shared/setDisplay.dart';

//internal: action
import 'package:swol/action/tabs/suggest/changeSuggestion.dart';
import 'package:swol/action/bottomButtons/button.dart';
import 'package:swol/action/page.dart';
import 'package:swol/action/tabs/suggest/corners.dart';

//internal: other
import 'package:swol/shared/structs/anExcercise.dart';
import 'package:swol/other/functions/helper.dart';

//TODO: from set record page
//we don't care if we are BEFORE or AFTER our set target
//either way the user has decided to continue
//we should respect that
//and there are no other bottom buttons to click or distract
//so we simply highligt the bottom next button at all times

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
  //function select
  ValueNotifier<int> functionIndex;
  String functionValue;

  //set target set
  ValueNotifier<int> repTarget;

  updateFunctionIndex() {
    functionValue = Functions.functions[functionIndex.value];
    widget.excercise.predictionID = functionIndex.value;
  }

  updateRepTarget() {
    widget.excercise.repTarget = repTarget.value;

    //TODO: might not need this
    setState(() {});
  }

  @override
  void initState() {
    //super init
    super.initState();
    //set function stuff initially
    functionIndex = new ValueNotifier(
      widget.excercise.predictionID,
    );
    functionValue = Functions.functions[functionIndex.value];

    //when the value changes we update it
    functionIndex.addListener(updateFunctionIndex);

    //set set target stuff initially
    repTarget = new ValueNotifier(
      widget.excercise.repTarget,
    );

    //when value changes we update it
    repTarget.addListener(updateRepTarget);
  }

  @override
  void dispose() {
    functionIndex.removeListener(updateFunctionIndex);
    repTarget.removeListener(updateRepTarget);

    //super dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //card radius
    Radius arrowRadius = Radius.circular(48);
    Radius cardRadius = Radius.circular(24);

    //calc sets passed for bottom buttons
    int setsPassed = widget.excercise.tempSetCount.value;
    bool timerNotStarted = widget.excercise.tempStartTime.value == AnExcercise.nullDateTime;
    if(timerNotStarted) setsPassed += 1;

    //color for bottom buttons
    bool lastSetOrBefore = setsPassed <= widget.excercise.setTarget.value;
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
                        useAccent: false,
                        extraCurvy: true,
                        title: "Last Set",
                        lastWeight: widget.excercise.lastWeight,
                        lastReps: widget.excercise.lastReps,
                      ),
                    ),
                    Expanded(
                      child: SuggestionChanger(
                        excercise: widget.excercise,
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
                        lastWeight: 124,
                        lastReps: 23,
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
            excercise: widget.excercise,
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
                    text: "/" + widget.excercise.setTarget.value.toString(),
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
