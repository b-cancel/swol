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
    return Transform.translate(
      offset: Offset(0, (setValid) ? 16 : 0),
      child: Conditional(
        condition: setValid,
        //sets the closestIndex to ?
        ifTrue: PercentOff(
          excercise: widget.excercise,
          predictionID: widget.predictionID,
        ),
        //sets the closestIndex to -1
        ifFalse: WaitingForValid(),
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
  List<double> oneRepMaxes = new List<double>(8);
  List<double> percentDifferences = new List<double>(8);

  double calcPercentDifference(double last, double current){
    double change = last - current;
    return (change / last) * 100;
  }

  updateOneRepMaxes(){
    //do new calculations
    for(int functionID = 0; functionID < 8; functionID++){
      //calc
      double calculated1RM = To1RM.fromWeightAndReps(
        double.parse(ExcercisePage.setWeight.value),
        int.parse(ExcercisePage.setReps.value),
        functionID, 
      );

      //save
      oneRepMaxes[functionID] = calculated1RM;

      //calc
      double calculatedDifference = calcPercentDifference(
        ExcercisePage.oneRepMaxes[functionID], 
        calculated1RM,
      );

      //save
      percentDifferences[functionID] = calculatedDifference;
    }

    //find closest match
    double smallestPercent = double.infinity;
    int functionIDwithSmallestPercent = -1;
    for(int functionID = 0; functionID < 8; functionID++){
      double percentForFunction = percentDifferences[functionID];
      if(percentForFunction < smallestPercent){
        smallestPercent = percentForFunction;
        functionIDwithSmallestPercent = functionID;
      }
    }

    print("function with closest match has ID: " + functionIDwithSmallestPercent.toString());
  }

  updateState() {
    if (mounted) setState(() {});
  }

  @override
  void initState() {
    //super init
    super.initState();

    //get init values for proper display
    updateOneRepMaxes();

    //listeners to update 1rm
    ExcercisePage.setWeight.addListener(updateOneRepMaxes);
    ExcercisePage.setReps.addListener(updateOneRepMaxes);

    //listeners to update percentages
    widget.predictionID.addListener(updateState);
  }

  @override
  void dispose() {
    //listeners to update 1rm
    ExcercisePage.setWeight.removeListener(updateOneRepMaxes);
    ExcercisePage.setReps.removeListener(updateOneRepMaxes);

    //remove percentage update listener
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

    int last1RM = ExcercisePage.oneRepMaxes[widget.predictionID.value].round();
    int this1RM = oneRepMaxes[widget.predictionID.value].round();
    bool same1RM = last1RM == this1RM;

    print("before: " + last1RM.toString() + " now: " + this1RM.toString());

    double percentOff = percentDifferences[widget.predictionID.value];
    //absolute value
    percentOff = (percentOff < 0) ? percentOff * -1 : percentOff;     

    //build
    return Column(
      children: <Widget>[
        Conditional(
          condition: same1RM,
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
                  percentOff.round().toString(),
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
            offset: Offset(0, (same1RM) ? -12 : -16),
            child: Text(
              (same1RM ? "as" : "than") + " calculated by the",
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