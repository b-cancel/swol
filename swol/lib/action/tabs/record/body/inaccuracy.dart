//flutter
import 'package:flutter/material.dart';

//plugin
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

//internal: action
import 'package:swol/action/page.dart';
import 'package:swol/action/popUps/textValid.dart';
import 'package:swol/action/shared/changeFunction.dart';

//internal: shared/other
import 'package:swol/shared/structs/anExcercise.dart';
import 'package:swol/shared/widgets/simple/conditional.dart';
import 'package:swol/other/functions/W&R=1RM.dart';

//widget
class InaccuracyCalculator extends StatefulWidget {
  const InaccuracyCalculator({
    Key key,
    @required this.excercise,
    @required this.predictionID,
  }) : super(key: key);

  final AnExcercise excercise;
  final ValueNotifier<int> predictionID;

  @override
  _InaccuracyCalculatorState createState() => _InaccuracyCalculatorState();
}

class _InaccuracyCalculatorState extends State<InaccuracyCalculator> {
  updateState() {
    if (mounted) setState(() {});
  }

  @override
  void initState() {
    //super init
    super.initState();

    //listeners
    ExcercisePage.setWeight.addListener(updateState);
    ExcercisePage.setReps.addListener(updateState);
  }

  @override
  void dispose() {
    //listeners
    ExcercisePage.setWeight.removeListener(updateState);
    ExcercisePage.setReps.removeListener(updateState);

    //super dipose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //check if we can show how far off they were from the target
    bool weightValid = isTextValid(ExcercisePage.setWeight.value);
    bool repsValid = isTextValid(ExcercisePage.setReps.value);
    bool setValid = weightValid && repsValid;

    //build
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Conditional(
            condition: setValid,
            ifTrue: PercentOff(
              excercise: widget.excercise,
              predictionID: widget.predictionID,
            ),
            ifFalse: WaitingForValid(),
          ),
          Transform.translate(
            offset: Offset(0, (setValid) ? -16 : 0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ChangeFunction(
                  functionID: widget.predictionID,
                  middleArrows: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class WaitingForValid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width / 4,
              child: Image(
                image: new AssetImage("assets/impatient.gif"),
                color: Theme.of(context).accentColor,
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width / 1.75,
              child: FittedBox(
                fit: BoxFit.contain,
                child: Text(
                  "Waiting For A Valid Set",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//NOTE: if this widget is displayed we KNOW that our set is valid
//and when we go into this we KNOW that our last set stuff is set
class PercentOff extends StatefulWidget {
  PercentOff({
    @required this.excercise,
    @required this.predictionID,
  });

  final AnExcercise excercise;
  final ValueNotifier<int> predictionID;

  @override
  _PercentOffState createState() => _PercentOffState();
}

class _PercentOffState extends State<PercentOff> {
  updateState() {
    if (mounted) setState(() {});
  }

  @override
  void initState() {
    //super init
    super.initState();

    //listeners
    ExcercisePage.setWeight.addListener(updateState);
    ExcercisePage.setReps.addListener(updateState);
    widget.predictionID.addListener(updateState);
  }

  @override
  void dispose() {
    //listeners
    ExcercisePage.setWeight.removeListener(updateState);
    ExcercisePage.setReps.removeListener(updateState);
    widget.predictionID.removeListener(updateState);

    //super dipose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Color color = Colors.white;
    /*
    int id = 0;
    if (id == 1)
      color = Colors.red.withOpacity(0.33);
    else if (id == 2)
      color = Colors.red.withOpacity(0.66);
    else if (id == 3) color = Colors.red;
    */

    //calculate our 1 rep maxes and compare them
    int last1RM = To1RM.fromWeightAndReps(
      widget.excercise.lastWeight.toDouble(),
      widget.excercise.lastReps,
      widget.predictionID.value, //use PASSED predictionID
    ).round();

    int this1RM = To1RM.fromWeightAndReps(
      double.parse(ExcercisePage.setWeight.value),
      int.parse(ExcercisePage.setReps.value),
      widget.predictionID.value, //use PASSED predictionID
    ).round();
    print("before: " + last1RM.toString() + " now: " + this1RM.toString());

    int change = last1RM - this1RM;
    if (change < 0) change *= -1;
    print("dif: " + change.toString());
    double percentOff = (change / last1RM) * 100;
    int visualPercentOff = percentOff.round();

    //build
    return Column(
      children: <Widget>[
        Conditional(
          condition: this1RM == last1RM,
          ifTrue: Padding(
            padding: EdgeInsets.only(
              bottom: 8.0,
            ),
            child: Text(
              "Exactly",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 56,
              ),
            ),
          ),
          ifFalse: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                child: Text(
                  visualPercentOff.toString(),
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.bold,
                    fontSize: 96,
                    wordSpacing: 0,
                  ),
                ),
              ),
              DefaultTextStyle(
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        FontAwesomeIcons.percentage,
                        color: color,
                        size: 42,
                      ),
                      Text(
                        (this1RM > last1RM) ? "higher" : "lower",
                        style: TextStyle(
                          fontSize: 42,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Center(
          child: Transform.translate(
            offset: Offset(0, (this1RM == last1RM) ? -12 : -16),
            child: Text(
              (this1RM == last1RM ? "as" : "than") + " calculated by the",
              style: TextStyle(
                fontSize: 22,
              ),
            ),
          ),
        ),
      ],
    );
  }
}