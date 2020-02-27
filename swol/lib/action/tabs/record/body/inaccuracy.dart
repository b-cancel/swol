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
  List<int> percentDifferences = new List<int>(8);
  List<int> percentDifferencesAbsolute = new List<int>(8);
  Map<int,List<int>> absDifferenceTofunctionID = new Map<int,List<int>>();
  int smallestDifference;
  int ourIndex;

  updateOneRepMaxes(){
    absDifferenceTofunctionID.clear();

    //do new calculations
    for(int functionID = 0; functionID < 8; functionID++){
      //calc
      //NOTE: must calculate with these values since thats what the user typed
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

      //minor calcs
      int difference = calculatedDifference.round();
      int absDifference = difference < 0 ? -1 : 1;
      absDifference *= difference;

      //save
      percentDifferences[functionID] = difference;
      percentDifferencesAbsolute[functionID] = absDifference;

      //keep counter
      if(absDifferenceTofunctionID.containsKey(absDifference) == false){
        absDifferenceTofunctionID[absDifference] = new List<int>();
      }
      absDifferenceTofunctionID[absDifference].add(functionID);
    }

    print("differences: " + percentDifferences.toString());
    print("map: " + absDifferenceTofunctionID.toString());

    //get the smallest difference
    List<int> differences = absDifferenceTofunctionID.keys.toList();
    differences.sort();
    smallestDifference = differences[0];
    
    //will eventually set state
    updatePredictionID();
  }

  updatePredictionID(){
    int ourPercentDifference = percentDifferencesAbsolute[widget.predictionID.value];
    ourIndex = ExcercisePage.orderedIDs.value.indexOf(widget.predictionID.value);
    print("index of : " + widget.predictionID.value.toString() + " is " + ourIndex.toString()); 

    //based on the smallest difference see if another index is closer
    if(ourPercentDifference == smallestDifference){
      print("updated to ourselves");
      ExcercisePage.closestIndex.value = ourIndex;
    }
    else{
      //TODO: finish
      print("we need to iterate through all indices that hold the smallest");
      ExcercisePage.closestIndex.value = 3;
    }

    //now that we have the proper value everywhere
    updateState();
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
    widget.predictionID.addListener(updatePredictionID);
  }

  @override
  void dispose() {
    //listeners to update 1rm
    ExcercisePage.setWeight.removeListener(updateOneRepMaxes);
    ExcercisePage.setReps.removeListener(updateOneRepMaxes);

    //remove percentage update listener
    widget.predictionID.removeListener(updatePredictionID);

    //super dipose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Color overlayColor = Colors.white;
    //we are some distance from where we should be
    //TODO: uncomment this when things are being sorted properly
    /*
    int dif = ourIndex - ExcercisePage.closestIndex.value;
    print("dif: " + dif.toString());
    if(dif != 0){ 
      if(dif < 0) dif *= -1;
      switch(dif){
        case 1: 
          overlayColor = Colors.red.withOpacity(0.33); 
          break;
        case 2: 
          overlayColor = Colors.red.withOpacity(0.66); 
          break;
        default: overlayColor = Colors.red;
      }
    }
    */

    //grab how much this prediction ID is away from target
    int percentOff = percentDifferences[widget.predictionID.value];
    //if met or exceeded
    bool metExpectations = percentOff > 0;
    //display just a number
    percentOff = (percentOff < 0) ? percentOff * -1 : percentOff;     

    //build
    return Column(
      children: <Widget>[
        Conditional(
          condition: percentOff == 0,
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
                child: Stack(
                  children: <Widget>[
                    Text(
                      percentOff.toString(),
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 96,
                        wordSpacing: 0,
                      ),
                    ),
                    //warns the user that they should change functions
                    Text(
                      percentOff.toString(),
                      style: TextStyle(
                        color: overlayColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 96,
                        wordSpacing: 0,
                      ),
                    ),
                  ],
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
                      Stack(
                        children: <Widget>[
                          Icon(
                            FontAwesomeIcons.percentage,
                            color: Colors.white,
                            size: 42,
                          ),
                          Icon(
                            FontAwesomeIcons.percentage,
                            color: overlayColor,
                            size: 42,
                          ),
                        ],
                      ),
                      Text(
                       (metExpectations) ? "higher" : "lower",
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
            offset: Offset(0, (percentOff == 0) ? -12 : -16),
            child: Text(
              (percentOff == 0 ? "as" : "than") + " calculated by the",
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

double calcPercentDifference(double last, double current){
  double change = last - current;
  //so doing better than expected yeilds positive values
  return ((change / last) * 100) * -1;
}