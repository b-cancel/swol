//flutter
import 'dart:math';

import 'package:flutter/material.dart';

//internal
import 'package:swol/excercise/excerciseData.dart';
import 'package:swol/excerciseAction/tabs/sharedWidgets/bottomButtons.dart';
import 'package:swol/excerciseAction/tabs/suggest/calibration.dart';
import 'package:swol/excerciseAction/tabs/suggest/suggestion.dart';
import 'package:swol/other/functions/helper.dart';

//TODO: implement this
//FLIPPED used when the user arrived directly to the suggest page
//and the temp set was not null
//meaning they came from the excercise list and for some reason either
//1. left the excercise without starting there break
//2. finished the break and was done with the excercise 
//    but didn't mark it as done

class Suggestion extends StatefulWidget {
  Suggestion({
    @required this.excerciseID,
    @required this.allSetsComplete,
    @required this.recordSet,
  });

  final int excerciseID;
  final Function allSetsComplete;
  final Function recordSet;

  @override
  _SuggestionState createState() => _SuggestionState();
}

class _SuggestionState extends State<Suggestion> {
  //TODO: remove test code
  bool flippedTesting = false;

  //function select
  ValueNotifier<int> functionIndex;
  String functionValue;

  //set target set
  ValueNotifier<int> repTarget;

  //TODO: remove test code
  ValueNotifier<bool> firstTime = new ValueNotifier(false);

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
    functionIndex.addListener((){
      functionValue = Functions.functions[functionIndex.value];

      ExcerciseData.updateExcercise(
        widget.excerciseID,
        predictionID: functionIndex.value,
      );
    });

    //set set target stuff initially
    repTarget = new ValueNotifier(
      ExcerciseData.getExcercises().value[widget.excerciseID].setTarget,
    );

    //when value changes we update it
    repTarget.addListener((){
      ExcerciseData.updateExcercise(
        widget.excerciseID,
        repTarget: repTarget.value,
      );

      //TODO: might not need this
      setState(() {});
    });

    //TODO: remove test code
    //listen to test look
    firstTime.addListener((){
      setState(() {
        
      });
    });    
  }

  @override
  Widget build(BuildContext context) {
    Widget calibration = CalibrationBody();
    
    int lastWeight = 80;
    int lastReps = 8;

    Widget suggestion = SuggestionBody(
      lastWeight: lastWeight, 
      lastReps: lastReps,
    );

    int lastRecordedWeight = ExcerciseData.getExcercises().value[widget.excerciseID].lastWeight;
    String extra = "";
    if(lastRecordedWeight != null){
      extra = "different than ";
      extra += lastRecordedWeight.toString() + " x ";
      extra += ExcerciseData.getExcercises().value[widget.excerciseID].lastReps.toString();
    }

    //TODO: 
    return Stack(
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Expanded(
                child: FlatButton(
                  onPressed: (){
                    flippedTesting = !flippedTesting;
                    firstTime.value = !firstTime.value;
                    //state will be set after
                  },
                  child: (firstTime.value) ? calibration : suggestion,
                ),
              ),
              BottomButtons(
                allSetsComplete: widget.allSetsComplete,
                forwardAction: widget.recordSet,
                flipped: flippedTesting,
                forwardActionWidget: RichText(
                  text: TextSpan(
                    style: TextStyle(
                      color: flippedTesting ? Colors.white : Theme.of(context).primaryColorDark,
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
            ],
          ),
        ),
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
      ],
    );
  }
}