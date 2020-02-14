//flutter
import 'package:flutter/material.dart';
import 'package:swol/action/page.dart';

//internal: action
import 'package:swol/action/tabs/suggest/suggestion/suggestion.dart';
import 'package:swol/action/tabs/sharedWidgets/bottomButtons.dart';
import 'package:swol/action/tabs/suggest/calibration.dart';

//internal: other
import 'package:swol/other/functions/helper.dart';
import 'package:swol/shared/structs/anExcercise.dart';

//TODO: implement this
//FLIPPED used when the user arrived directly to the suggest page
//and the temp set was not null
//meaning they came from the excercise list and for some reason either
//1. left the excercise without starting there break
//2. finished the break and was done with the excercise 
//    but didn't mark it as done

class Suggestion extends StatefulWidget {
  Suggestion({
    @required this.statusBarHeight,
    @required this.excercise,
    @required this.heroUp,
    @required this.heroAnimDuration,
    @required this.heroAnimTravel,
  });

  final double statusBarHeight;
  final AnExcercise excercise;
  final ValueNotifier<bool> heroUp;
  final Duration heroAnimDuration;
  final double heroAnimTravel;

  @override
  _SuggestionState createState() => _SuggestionState();
}

class _SuggestionState extends State<Suggestion> {
  bool showCalibration;

  //function select 
  ValueNotifier<int> functionIndex;
  String functionValue;

  //set target set
  ValueNotifier<int> repTarget;

  updateFunctionIndex(){
    functionValue = Functions.functions[functionIndex.value];
    widget.excercise.predictionID = functionIndex.value;
  }

  updateRepTarget(){
    widget.excercise.repTarget = repTarget.value;

    //TODO: might not need this
    setState(() {});
  }

  testFirstTime(){
    if(mounted) setState(() {});
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

    //determine what page we should be showing
    showCalibration = (widget.excercise.lastWeight == null); 
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
    double fullHeight = MediaQuery.of(context).size.height;
    double appBarHeight = 56; //constant according to flutter docs
    double bottomButtonsHeight = 64;
    double backButtonHeight = 48;
    double spaceToRedistribute = fullHeight - widget.statusBarHeight;
    spaceToRedistribute -= (appBarHeight + bottomButtonsHeight);

    //buildy boi
    return ClipRRect( //clipping so "hero" doesn't show up in the other page
      child: Container(
        width: fullHeight,
        child: Stack(
          children: <Widget>[
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: BottomButtons(
                excercise: widget.excercise,
                forwardAction: (){
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
            ),
            Positioned(
              top: 0,
              child: showCalibration ? CalibrationCard(
                rawSpaceToRedistribute: spaceToRedistribute, 
              ) : SuggestionSection(
                excercise: widget.excercise,
                lastWeight: 80, 
                lastReps: 5,
                rawSpaceToRedistribute: spaceToRedistribute - backButtonHeight, 
                heroUp: widget.heroUp,
                heroAnimDuration: widget.heroAnimDuration,
                heroAnimTravel: widget.heroAnimTravel,
              ),
            )
          ],
        ),
      ),
    );
  }
}