//flutter
import 'package:flutter/material.dart';

//internal
import 'package:swol/excercise/excerciseData.dart';
import 'package:swol/excerciseAction/tabs/sharedWidgets/done.dart';
import 'package:swol/excerciseAction/tabs/suggest/widget.dart';
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
                              functionIndex.value = Functions.functionToIndex[functionValue];
                            });
                          },
                          items: Functions.functions.map<DropdownMenuItem<String>>((String value) {
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