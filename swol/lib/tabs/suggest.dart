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

    Widget suggestion = Padding(
      padding: EdgeInsets.only(top:16),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: SetDisplay(
                weight: "80",
                reps: "8",
                isLast: true,
              ),
            ),
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
            new CustomSliderWarning(
              repTarget: new ValueNotifier(10),
              alwaysHaveSpace: true,
            ),
            Container(
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
                        Text(
                          "Your next set using the",
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                        DropdownButton<String>(
                          value: functionValue,
                          icon: Icon(Icons.arrow_drop_down),
                          iconSize: 24,
                          elevation: 16,
                          isExpanded: true,
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
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 16.0,
                      right: 16,
                      bottom: 16,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Text(
                          "and a rep target of " + repTarget.value.toString() + " should be",
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: 8,
              ),
              child: new CustomSliderWarning(
                repTarget: repTarget,
                alwaysHaveSpace: true,
              ),
            ),
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
            Expanded(
              child: SetDisplay(
                weight: "160",
                reps: "3",
                isLast: false,
              ),
            ),
          ],
        ),
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

class DoneButton extends StatelessWidget {
  const DoneButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OutlineButton(
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
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                child: Text(
                  (isLast) ? "Last Set" : "Goal Set",
                  style: TextStyle(
                    fontSize: 24,
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
                          fontSize: 48,
                        ),
                      ),
                    ),
                    Transform.translate(
                      offset: Offset(0, -4),
                      child: Padding(
                        padding: EdgeInsets.only(
                          left: 4,
                          right: 4,
                        ),
                        child: Text(
                          (isLast) ? "MAX Reps" : "MIN Reps",
                          style: TextStyle(
                            fontSize: 24,
                          ),
                        ),
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