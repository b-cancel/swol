//flutter
import 'package:flutter/material.dart';

//internal
import 'package:swol/excercise/excerciseData.dart';
import 'package:swol/excerciseAction/tabs/sharedWidgets/done.dart';
import 'package:swol/excerciseAction/tabs/suggest/calibration.dart';
import 'package:swol/excerciseAction/tabs/suggest/suggestion.dart';
import 'package:swol/other/functions/helper.dart';
import 'package:swol/sharedWidgets/mySlider.dart';

class Suggestion extends StatefulWidget {
  Suggestion({
    @required this.excerciseID,
  });

  final int excerciseID;

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

    return Column(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Expanded(
          child: FlatButton(
            onPressed: (){
              firstTime.value = !firstTime.value;
            },
            child: (firstTime.value) ? calibration : suggestion,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
            bottom: 16.0,
            left: 16,
            right: 16,
            top: 16,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              new DoneButton(),
              Expanded(
                child: Container(),
              ),
              RaisedButton(
                color: Theme.of(context).accentColor,
                onPressed: (){
                  print("do thing");
                },
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "Record ",
                        style: TextStyle(
                          color: Theme.of(context).primaryColorDark,
                        ),
                      ),
                      TextSpan(
                        text: "Set 1",
                        style: TextStyle(
                          color: Theme.of(context).primaryColorDark,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      TextSpan(
                        text: "/3",
                        style: TextStyle(
                          color: Theme.of(context).primaryColorDark,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}