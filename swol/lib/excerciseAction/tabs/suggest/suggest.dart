//flutter
import 'dart:math';

import 'package:flutter/material.dart';

//internal
import 'package:swol/excercise/excerciseData.dart';
import 'package:swol/excerciseAction/tabs/sharedWidgets/bottomButtons.dart';
import 'package:swol/excerciseAction/tabs/suggest/calibration.dart';
import 'package:swol/excerciseAction/tabs/suggest/suggestion.dart';
import 'package:swol/other/functions/helper.dart';
import 'package:swol/utils/goldenRatio.dart';

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
    @required this.excerciseID,
    @required this.recordSet,
  });

  final double statusBarHeight;
  final int excerciseID;
  final Function recordSet;

  @override
  _SuggestionState createState() => _SuggestionState();
}

class _SuggestionState extends State<Suggestion> {
  //function select
  ValueNotifier<int> functionIndex;
  String functionValue;

  //set target set
  ValueNotifier<int> repTarget;

  //TODO: remove test code
  ValueNotifier<bool> firstTime = new ValueNotifier(false);

  updateFunctionIndex(){
    functionValue = Functions.functions[functionIndex.value];

    ExcerciseData.updateExcercise(
      widget.excerciseID,
      predictionID: functionIndex.value,
    );
  }

  updateRepTarget(){
    ExcerciseData.updateExcercise(
      widget.excerciseID,
      repTarget: repTarget.value,
    );

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
      ExcerciseData.getExcercises().value[widget.excerciseID].predictionID,
    );
    functionValue = Functions.functions[functionIndex.value];

    //when the value changes we update it
    functionIndex.addListener(updateFunctionIndex);

    //set set target stuff initially
    repTarget = new ValueNotifier(
      ExcerciseData.getExcercises().value[widget.excerciseID].setTarget,
    );

    //when value changes we update it
    repTarget.addListener(updateRepTarget);

    //TODO: remove test code
    //listen to test look
    firstTime.addListener(testFirstTime);    
  }

  @override
  void dispose() { 
    functionIndex.removeListener(updateFunctionIndex);
    repTarget.removeListener(updateRepTarget);
    firstTime.removeListener(testFirstTime);

    //super dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    int lastRecordedWeight = ExcerciseData.getExcercises().value[widget.excerciseID].lastWeight;
    String extra = "";
    if(lastRecordedWeight != null){
      extra = "different than ";
      extra += lastRecordedWeight.toString() + " x ";
      extra += ExcerciseData.getExcercises().value[widget.excerciseID].lastReps.toString();
    }

    double fullHeight = MediaQuery.of(context).size.height;
    double appBarHeight = 56; //constant according to flutter docs
    double spaceToRedistribute = fullHeight - appBarHeight - widget.statusBarHeight ;
    /*
    GestureDetector(
        onTap: (){
          firstTime.value = !firstTime.value;
          //state will be set after
        },
        child: suggestion,
      ),
    */

    //buildy boi
    return GestureDetector(
      onTap: (){
        firstTime.value = !firstTime.value;
        //state will be set after
      },
      child: Container(
        width: fullHeight,
        child: Stack(
          children: <Widget>[
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: BottomButtons(
                forwardAction: widget.recordSet,
                forwardActionWidget: RichText(
                  text: TextSpan(
                    style: TextStyle(
                      color: Theme.of(context).primaryColorDark,
                    ),
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
              child: firstTime.value ? CalibrationCard(
                rawSpaceToRedistribute: spaceToRedistribute, 
                removeDoneButtonSpacing: false,
                removeBottomButtonSpacing: false,
              ) : SuggestionSection(
                lastWeight: 80, 
                lastReps: 5,
                //NOTE: 48 is the padding between bottom buttons and our card
                //NOTE: 64 is the height of the bottom buttons
                rawSpaceToRedistribute: spaceToRedistribute - 48 - 64, 
              ),
            )
          ],
        ),
      ),
    );
  }
}


/*
Positioned(
  child: Center(
    child: RaisedButton(
      onPressed: (){
        //give the item a random lastWeight [5->75] and random lastReps [1->35]
        var rnd = new Random();
        ExcerciseData.updateExcercise(
          widget.excerciseID,
          lastWeight: rnd.nextInt(70) + 5,
          lastReps: rnd.nextInt(34) + 1,
        );
      },
      child: Text("generate random weight and reps " + extra),
    ),
  ),
),
*/