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

    Widget child = Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      padding: EdgeInsets.all(16),
      child: GestureDetector(
        onTap: (){
          firstTime.value = !firstTime.value;
          //state will be set after
        },
        child: suggestion,
      ),
    );

    double fullHeight = MediaQuery.of(context).size.height;
    double appBarHeight = 56; //constant according to flutter docs
    double spaceToRedistribute = fullHeight - appBarHeight - widget.statusBarHeight ;

    //buildy boi
    return Container(
      width: fullHeight,
      child: Stack(
        children: <Widget>[
          Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Expanded(
                child: Container(),
                
                /*Column(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Expanded(
                      //NOTE: I do the 2 minus 8 and the 1 plus 16 so I can test that things are working properly
                      child: CalibrationCard(
                        rawSpaceToRedistribute: spaceToRedistribute, 
                        removeDoneButtonSpacing: false,
                        removeBottomButtonSpacing: true,
                      ),
                    ),
                    BottomButtonPadding(),
                  ],
                ),*/
              ),
              BottomButtons(
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
            ],
          ),
          Positioned(
            top: 0,
            child: firstTime.value ? CalibrationCard(
              rawSpaceToRedistribute: spaceToRedistribute, 
              removeDoneButtonSpacing: false,
              removeBottomButtonSpacing: false,
            ) : Container(),
          )
        ],
      ),
    );
  }
}

class CalibrationCard extends StatelessWidget {
  const CalibrationCard({
    Key key,
    @required this.rawSpaceToRedistribute,
    this.removeBottomButtonSpacing: false,
    this.removeDoneButtonSpacing: true,
  }) : super(key: key);

  final double rawSpaceToRedistribute;
  final bool removeDoneButtonSpacing;
  final bool removeBottomButtonSpacing;

  @override
  Widget build(BuildContext context) {
    double spaceToRedistribute = rawSpaceToRedistribute;

    //make instinct based removals since all the UI is semi contected
    if(removeDoneButtonSpacing){
      //NOTE: 48 is the padding between bottom buttons and our card
      spaceToRedistribute -= 48;
    }

    if(removeBottomButtonSpacing){
      //NOTE: 64 is the height of the bottom buttons
      spaceToRedistribute -= 64;
    }
    
    //calculate golden ratio
    List<double> bigToSmall = measurementToGoldenRatio(spaceToRedistribute);
    
    //card radius
    Radius cardRadius = Radius.circular(24);

    //minor setting
    double stepFontSize = 18;

    //build
    return Container(
      height: spaceToRedistribute,
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Container(
            //color: Colors.blue,
            height: bigToSmall[1] - 8,
            width: MediaQuery.of(context).size.width,
          ),
          Container(
            height: 16,
            //color: Colors.red,
            width: MediaQuery.of(context).size.width,
            child: OverflowBox(
              maxHeight: spaceToRedistribute,
              minHeight: 0,
              child: Padding(
                padding: EdgeInsets.only(
                  left : 0.0,
                ),
                child: Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.only(
                      topLeft: cardRadius,
                      bottomLeft: cardRadius,
                      //----
                      topRight: cardRadius,
                      bottomRight: cardRadius,
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      FittedBox(
                        fit: BoxFit.contain,
                        child: Container(
                          padding: EdgeInsets.only(
                            bottom: 0.0,
                          ),
                          child: DefaultTextStyle(
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                            child: Text("Calibration Set")
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          bottom: 24.0,
                          left: 8,
                        ),
                        child: Text(
                          "Without a previous set, we can't give you suggestions",
                          style: TextStyle(
                            fontSize: 22,
                          ),
                        ),
                      ),
                      new CalibrationStep(
                        number: 1,
                        content: RichText(
                          text: TextSpan(
                            style: TextStyle(
                              fontSize: stepFontSize,
                            ),
                            children: [
                              TextSpan(
                                text: "Pick ",
                              ),
                              TextSpan(
                                text: "any",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextSpan(
                                text: " weight you ",
                              ),
                              TextSpan(
                                text: "know",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextSpan(
                                text: " you can lift for ",
                              ),
                              TextSpan(
                                text: "around",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextSpan(
                                text: " 10 reps",
                              ),
                            ]
                          ),
                        ),
                      ),
                      new CalibrationStep(
                        number: 2,
                        content: RichText(
                          text: TextSpan(
                            style: TextStyle(
                              fontSize: stepFontSize,
                            ),
                            children: [
                              TextSpan(
                                text: "Do as many reps as ",
                              ),
                              TextSpan(
                                text: "possible",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextSpan(
                                text: " with ",
                              ),
                              TextSpan(
                                text: "good",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextSpan(
                                text: " form",
                              ),
                            ]
                          ),
                        ),
                      ),
                      new CalibrationStep(
                        number: 3,
                        content: RichText(
                          text: TextSpan(
                            style: TextStyle(
                              fontSize: stepFontSize,
                            ),
                            children: [
                              TextSpan(
                                text: "Record the weight you used and your ",
                              ),
                              TextSpan(
                                text: "maximum reps",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextSpan(
                                text: " so we can begin giving you suggestions",
                              ),
                            ]
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Container(
            //color: Colors.green,
            height: bigToSmall[0] - 8,
            width: MediaQuery.of(context).size.width,
          ),
        ],
      ),
    );
  }
}

class BottomButtonPadding extends StatelessWidget {
  const BottomButtonPadding({
    this.withDoneButton: true,
    Key key,
  }) : super(key: key);

  final bool withDoneButton;

  @override
  Widget build(BuildContext context) {
    return Container(
      //24 (p1) is for 24 away from the RIGHT BOTTOM buttons
      //24 (p2) is for 24 cuz of the curve
      height: 24.0 + ((withDoneButton) ? 24 : 0),
      width: MediaQuery.of(context).size.width,
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