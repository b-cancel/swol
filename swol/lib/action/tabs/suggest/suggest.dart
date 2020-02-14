//flutter
import 'package:flutter/material.dart';

//internal: action
import 'package:swol/action/tabs/suggest/suggestion/suggestion.dart';
import 'package:swol/action/bottomButtons/button.dart';
import 'package:swol/action/page.dart';

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
    return ClipRRect(
      //clipping so "hero" doesn't show up in the other page
      child: Column(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                bottom: 24, //extra for the complete button
              ),
              child: SuggestBody(
                excercise: widget.excercise,
                heroUp: widget.heroUp,
                heroAnimDuration: widget.heroAnimDuration,
                heroAnimTravel: widget.heroAnimTravel,
              ),
            ),
          ),
          BottomButtons(
            excercise: widget.excercise,
            forwardAction: () {
              ExcercisePage.pageNumber.value = 1;
            },
            forwardActionWidget: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "Record ",
                  ),
                  TextSpan(
                    text: "Set 1",
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(
                    text: "/3",
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
