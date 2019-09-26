//dart
import 'dart:math' as math;

//flutter
import 'package:flutter/material.dart';

//plugins
import 'package:auto_size_text/auto_size_text.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:swol/addWorkout.dart';
import 'package:swol/functions/helper.dart';
import 'package:swol/helpers/addWorkout.dart';
import 'package:swol/helpers/addWorkoutInfo.dart';
import 'package:swol/helpers/mySlider.dart';
import 'package:swol/utils/data.dart';
import 'package:swol/workout.dart';

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
      getExcercises().value[widget.excerciseID].predictionID,
    );
    functionValue = functions[functionIndex.value];

    //when the value changes we update it
    functionIndex.addListener((){
      functionValue = functions[functionIndex.value];

      updateExcercise(
        widget.excerciseID,
        predictionID: functionIndex.value,
      );
    });

    //set set target stuff initially
    repTarget = new ValueNotifier(
      getExcercises().value[widget.excerciseID].lastSetTarget,
    );

    //when value changes we update it
    repTarget.addListener((){
      updateExcercise(
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
    Widget calibration = Container(
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          FittedBox(
            fit: BoxFit.contain,
            child: Padding(
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
              bottom: 16.0,
              left: 8,
            ),
            child: Text(
              "Without a previous set, we can't give you suggestions, so...",
              style: TextStyle(
                fontSize: 18,
              ),
            ),
          ),
          new CalibStep(
            stepNumber: 1,
          ),
          new CalibStep(
            stepNumber: 2,
          ),
          new CalibStep(
            stepNumber: 3,
          ),
          Expanded(
            child: Container(),
          )
        ],
      ),
    );

    Widget suggestion = Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Expanded(
          child: Container(
            padding: EdgeInsets.only(
              top: 8,
            ),
            child: SetDisplay(
              weight: "80",
              reps: "8",
              isLast: true,
            ),
          ),
        ),
        /*
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            new MyArrow(
              color: (true) ? Colors.white : Theme.of(context).accentColor,
            ),
            new MyArrow(
              color: (true) ? Colors.white : Theme.of(context).accentColor,
            ),
          ],
        ),
        */

        
        Stack(
          children: <Widget>[
            Positioned(
              top: 32,
              left: 0,
              child: new MyArrow(
                color: (true) ? Colors.white : Theme.of(context).accentColor,
              ),
            ),
            Positioned(
              top: 32,
              right: 0,
              child: new MyArrow(
                color: (true) ? Colors.white : Theme.of(context).accentColor,
              ),
            ),
            Positioned(
              bottom: 32,
              left: 0,
              child: new MyArrow(
                color: (false) ? Colors.white : Theme.of(context).accentColor,
              ),
            ),
            Positioned(
              bottom: 32,
              right: 0,
              child: new MyArrow(
                color: (false) ? Colors.white : Theme.of(context).accentColor,
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                new MyArrow(
                  color: Colors.transparent
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Theme.of(context).cardColor,
                        width: 2,
                      )
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        /*
                        Container(
                          child: new HeaderWithInfo(
                            title: "Prediction Formula",
                            popUp: new PredictionFormulasPopUp(),
                          ),
                        ),
                        */
                        Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text("Your next set using the"),
                              DropdownButton<String>(
                                value: functionValue,
                                icon: Icon(Icons.arrow_drop_down),
                                isExpanded: true,
                                iconSize: 24,
                                elevation: 16,
                                onChanged: (String newValue) {
                                  setState(() {
                                    functionValue = newValue;
                                    functionIndex.value = functionToIndex[functionValue];
                                  });
                                },
                                items: functions.map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                })
                                .toList(),
                              ),
                              Text("function and assuming your rep target is " + repTarget.value.toString()),
                            ],
                          ),
                        ),
                        /*
                        Container(
                          child: new HeaderWithInfo(
                            title: "Set Target",
                            popUp: new SetTargetPopUp(),
                          ),
                        ),
                        */
                        new CustomSlider(
                          value: repTarget,
                          lastTick: 35,
                        ),
                        new CustomSliderWarning(repTarget: repTarget),
                      ],
                    ),
                  ),
                ),
                new MyArrow(
                  color: Colors.transparent
                ),
              ],
            ),
          ],
        ),
        /*
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            new MyArrow(
              color: (false) ? Colors.white : Theme.of(context).accentColor,
            ),
            new MyArrow(
              color: (false) ? Colors.white : Theme.of(context).accentColor,
            ),
          ],
        ),
        */
        Expanded(
          child: SetDisplay(
            weight: "160",
            reps: "3",
            isLast: false,
          ),
        ),
      ],
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
              OutlineButton(
                highlightedBorderColor: Theme.of(context).accentColor,
                onPressed: (){
                  print("do thing");
                },
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "3 Sets",
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      TextSpan(
                        text: " Complete",
                        style: TextStyle(
                        ),
                      ),
                    ],
                  ),
                ),
              ),
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

class MyArrow extends StatelessWidget {
  const MyArrow({
    this.color,
    Key key,
  }) : super(key: key);

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Center(
        child: Transform.rotate(
          angle: 0, //math.pi / 2,
          child: Icon(
            Icons.arrow_downward,
            color: color,
          )
        ),
      ),
    );
  }
}

class SetDisplay extends StatelessWidget {
  SetDisplay({
    @required this.isLast,
    @required this.weight,
    @required this.reps,
  });

  final bool isLast;
  final String weight;
  final String reps;

  @override
  Widget build(BuildContext context) {
    Color theColor = (isLast) ? Colors.white : Theme.of(context).accentColor;

    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(
          color: theColor,
          width: 2,
        ),
      ),
      child: FittedBox(
        fit: BoxFit.contain,
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                child: Text(
                  (isLast) ? "Last Set" : "Goal Set",
                  style: TextStyle(
                    fontSize: 36,
                  ),
                ),
              ),
              Container(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      weight,
                      style: TextStyle(
                        fontSize: 48,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        left: 4,
                      ),
                      child: Transform.translate(
                        offset: Offset(0, -10),
                        child: Icon(
                          FontAwesomeIcons.dumbbell,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        left: 16,
                      ),
                      child: Text(
                        reps,
                        style: TextStyle(
                          fontSize: 36,
                        ),
                      ),
                    ),
                    Transform.translate(
                      offset: Offset(0, -4),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(
                              left: 4,
                            ),
                            child: Text(
                              (isLast) ? "MAX" : "MIN",
                              style: TextStyle(
                                fontSize: 24,
                              ),
                            ),
                          ),
                          Icon(
                            Icons.repeat,
                            size: 24,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      )
    );
  }
}

class CalibStep extends StatelessWidget {
  const CalibStep({
    Key key,
    @required this.stepNumber,
  }) : super(key: key);

  final int stepNumber;

  @override
  Widget build(BuildContext context) {
    double fontSize = 18;

    Widget step;
    if(stepNumber == 1){
      step = RichText(
        text: TextSpan(
          style: TextStyle(
            fontSize: fontSize,
          ),
          children: [
            TextSpan(
              text: "Pick ",
            ),
            TextSpan(
              text: "ANY",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            TextSpan(
              text: " weight you ",
            ),
            TextSpan(
              text: "KNOW",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            TextSpan(
              text: " you can lift for ",
            ),
            TextSpan(
              text: "AROUND",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            TextSpan(
              text: " 10 reps",
            ),
          ]
        ),
      );
    }
    else if(stepNumber == 2){
      step = RichText(
        text: TextSpan(
          style: TextStyle(
            fontSize: fontSize,
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
      );
    }
    else{
      step = RichText(
        text: TextSpan(
          style: TextStyle(
            fontSize: fontSize,
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
      );
    }

    //build
    return Container(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(16),
            decoration: new BoxDecoration(
              color: Theme.of(context).accentColor,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                stepNumber.toString(),
                style: TextStyle(
                  color: Theme.of(context).primaryColorDark,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(
                16,
              ),
              child: step,
            ),
          ),
        ],
      ),
    );
  }
}