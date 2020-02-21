//flutter
import 'package:flutter/material.dart';

//plugins
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

//internal: action
import 'package:swol/action/shared/changeFunction.dart';
import 'package:swol/action/shared/halfColored.dart';
import 'package:swol/action/shared/setDisplay.dart';
import 'package:swol/action/popUps/textValid.dart';
import 'package:swol/action/page.dart';

//internal: shared
import 'package:swol/shared/widgets/simple/curvedCorner.dart';
import 'package:swol/shared/widgets/simple/conditional.dart';
import 'package:swol/shared/structs/anExcercise.dart';

//internal: other
import 'package:swol/other/functions/1RM&R=W.dart';
import 'package:swol/other/functions/1RM&W=R.dart';
import 'package:swol/other/functions/W&R=1RM.dart';

//widget
class MakeFunctionAdjustment extends StatefulWidget {
  const MakeFunctionAdjustment({
    Key key,
    @required this.topColor,
    @required this.heroUp,
    @required this.heroAnimDuration,
    @required this.heroAnimTravel,
    @required this.excercise,
  }) : super(key: key);

  final Color topColor;
  final AnExcercise excercise;
  final ValueNotifier<bool> heroUp;
  final Duration heroAnimDuration;
  final double heroAnimTravel;

  @override
  _MakeFunctionAdjustmentState createState() => _MakeFunctionAdjustmentState();
}

class _MakeFunctionAdjustmentState extends State<MakeFunctionAdjustment> {
  final ValueNotifier<int> predictionID = new ValueNotifier<int>(0);

  //update the goal set based on init
  //and changed valus
  updateGoal() {
    //we use 1m and weight to get reps
    //this is bause maybe we wanted them to do 125 for 5 but they only had 120
    //so ideally we want to match their weight here and take it from ther
    String setWeightString = ExcercisePage.setWeight.value;
    bool weightUseValid = isTextValid(setWeightString);
    double weight = weightUseValid ? double.parse(setWeightString) : 0;

    //check conditions
    List<int> repEstimates = new List<int>(8);
    if (weightUseValid) {
      //if the weight is valid you can estimate reps
      //calculate all the rep-estimates for all functions
      for (int thisFunctionID = 0; thisFunctionID < 8; thisFunctionID++) {
        //calc the 1 rep max if we go this route
        double oneRM = To1RM.fromWeightAndReps(
          widget.excercise.lastWeight.toDouble(),
          widget.excercise.lastReps.toDouble(),
          thisFunctionID,
        );

        //calc the rep estimate
        repEstimates[thisFunctionID] = ToReps.from1RMandWeight(
          oneRM,
          //use recorded weight
          //since we are assuming
          //that's what the user couldn't change
          weight,
          thisFunctionID,
        ).round();
      }

      //make sure all yield valid resuls
      for (int thisFunctionID = 0; thisFunctionID < 8; thisFunctionID++) {
        int estimate = repEstimates[thisFunctionID];
        bool zeroOrLess = (estimate <= 0);
        //NOTE: our encouraged upperbound is 35
        //but we don't want to limit things too much
        //so that this bit is never usefull
        //so we set it at a 100
        bool aboveUpperBound = (101 < estimate);
        if (zeroOrLess || aboveUpperBound) {
          weightUseValid = false;
          break;
        }
      }
    }

    print(repEstimates.toString());

    //only if all conditions are met do we use our inverse guess
    //this should only happen under very specific circumstances
    if (weightUseValid) {
      //calculate reps
      ExcercisePage.setGoalReps.value = repEstimates[predictionID.value];
      ExcercisePage.setGoalWeight.value = weight.round();
    } else {
      //calculate weight
      double oneRM = To1RM.fromWeightAndReps(
        widget.excercise.lastWeight.toDouble(),
        widget.excercise.lastReps.toDouble(),
        widget.excercise.predictionID,
      );

      ExcercisePage.setGoalReps.value = widget.excercise.repTarget;
      ExcercisePage.setGoalWeight.value = ToWeight.fromRepAnd1Rm(
        ExcercisePage.setGoalReps.value.toDouble(),
        oneRM,
        widget.excercise.predictionID,
      ).round();
    }
  }

  updatePredictionID() {
    widget.excercise.predictionID = predictionID.value;
    updateGoal();
  }

  @override
  void initState() {
    //super init
    super.initState();

    //init value and notifier addition
    predictionID.value = widget.excercise.predictionID;

    //add listeners
    predictionID.addListener(updatePredictionID);
    ExcercisePage.setWeight.addListener(updateGoal);

    //update goal initially before notifiers
    updateGoal();
  }

  @override
  void dispose() {
    //remove listeners
    predictionID.removeListener(updatePredictionID);
    ExcercisePage.setWeight.removeListener(updateGoal);

    //super dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget topBit = Container(
      width: MediaQuery.of(context).size.width,
      height:widget.topColor == Theme.of(context).accentColor ? 24 : 4,
      color: widget.topColor,
    );

    Widget goalSet = SetDisplay(
      useAccent: false,
      title: "Goal Set",
      heroUp: widget.heroUp,
      heroAnimDuration: widget.heroAnimDuration,
      heroAnimTravel: widget.heroAnimTravel,
    );

    return Container(
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Stack(
            children: <Widget>[
              //the widget below is only for height
              Column(
                children: [
                  topBit,
                  TopBackgroundColored(
                    color: widget.topColor,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.all(
                          Radius.circular(24),
                        ),
                      ),
                      child: Opacity(
                        opacity: 0,
                        child: goalSet,
                      ),
                    ),
                  ),
                ],
              ),
              Positioned(
                bottom: 0,
                child: goalSet,
              ), 
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    topBit,
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children:[
                        CurvedCorner(
                          isTop: false, 
                          isLeft: true, //left
                          cornerColor: widget.topColor,
                        ),
                        CurvedCorner(
                          isTop: false, 
                          isLeft: false, //right 
                          cornerColor: widget.topColor,
                        ),
                      ]
                    )
                  ],
                ),
              ),
            ],
          ),
          Expanded(
            child: InaccuracyCalculator(
              excercise: widget.excercise,
              predictionID: predictionID,
            ),
          ),
        ],
      ),
    );
  }
}

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
                  predictionID: widget.predictionID,
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
      widget.excercise.lastReps.toDouble(),
      widget.predictionID.value, //use PASSED predictionID
    ).round();

    int this1RM = To1RM.fromWeightAndReps(
      double.parse(ExcercisePage.setWeight.value),
      double.parse(ExcercisePage.setReps.value),
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
                  style: GoogleFonts.robotoMono(
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
