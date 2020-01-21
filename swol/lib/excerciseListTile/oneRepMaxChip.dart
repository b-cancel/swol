import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:swol/other/functions/helper.dart';
import 'package:swol/sharedWidgets/ourSnackBar.dart';
import 'package:swol/sharedWidgets/thisOrThatIcon.dart';

//given the 
//1. last weight
//2. last reps
//3. prediction function
//we 
//1. calculate the 1 rep max or estimated 1 rep max
//2. generate a message to show if the user taps the chipd
class ExcerciseTileSubtitle extends StatelessWidget {
  ExcerciseTileSubtitle({
    @required this.lastWeight,
    @required this.lastReps,
    @required this.functionID,
  });

  final int lastWeight;
  final int lastReps;
  final int functionID;

  @override
  Widget build(BuildContext context) {
    //some contstant before I begin
    const double borderRadius = 8;
    const TextStyle BOLD = const TextStyle(
      fontWeight: FontWeight.bold,
    );

    //NOTE: contains defaults for when this set is indeed a one rep max
    bool isOneRepMaxEstimated = false; 
    Widget oneRepMaxWidget = Text(
      lastWeight.toString(),
      style: BOLD,
    );
    String snackbarMessage = "Your 1 Rep Max";

    //only calculate the 1 rep max and all its related values if you must
    if(lastReps != 1){
      isOneRepMaxEstimated = true;

      //estimate one rep max
      List oneRepMaxValues = Functions.getOneRepMaxValues(
        lastWeight, 
        lastReps,
      );

      //update onRepMaxWidget
      oneRepMaxWidget = Text(
        oneRepMaxValues[0][functionID].toInt().toString(),
        style: BOLD,
      );

      //extract data
      
      double standardDevaition = oneRepMaxValues[2];

      if(standardDevaition.toInt() == 0){
        snackbarMessage = "\"Without a doubt\" this is your 1 Rep Max";
        //NOTE: we keep default valueBorderColor
      }
      else{ //we aren't sure about our result
        //NOTE: updating 
        //1. oneRepMaxWidget
        //2. snackBarMessage
        //3. valueBorderColor

        //make that clear by 
        //1. showing the devaition
        //2. but also by highligting the GUESS in an appropiate color
        //3. and add an appropiate snackbar with 
        //    a. sureness string
        //    b. suggestions to improve
        double mean = oneRepMaxValues[1];
        int percentOfDeviation = (
          (mean == 0 || standardDevaition.toInt() == 0) ? 0 
          : (standardDevaition / mean) * 100
        ).toInt();

        //TODO: improvable by actually using Maps
        //"Map" percent devaition to all its respective components
        //red, orange, yellow, green, blue, purple
        String surenessString;
        int lessThanReps;
        if(percentOfDeviation > 25){
          surenessString = "not sure at all";
          lessThanReps = 25;
        }
        else if(percentOfDeviation > 20){
          surenessString = "very un-sure";
          lessThanReps = 20;
        }
        else if(percentOfDeviation > 15){
          surenessString = "somewhat un-sure";
          lessThanReps = 15;
        }
        else if(percentOfDeviation > 10){
          surenessString = "somewhat sure";
          lessThanReps = 10;
        }
        else if(percentOfDeviation > 5){
          surenessString = "very sure";
          lessThanReps = 5;
        }
        else{
          surenessString = "extremely sure";
          lessThanReps = 0;
        }

        //let the user know how far the guess is
        snackbarMessage = "We are \"" + surenessString + "\" this is your one rep max";
        
        //ONLY discourage anything above 15 
        //since anything below is going to produce pretty good results
        snackbarMessage += (lessThanReps <= 15) ? ""
        : "\nDo less than " + lessThanReps.toString() + " reps for a more accurate guess";

        //we are here because we have some level of uncertainty so we need to display that
        oneRepMaxWidget = Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            oneRepMaxWidget,
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 2.0,
              ),
              child: ThisOrThatIcon(
                one: Icon(
                  FontAwesomeIcons.plus,
                  color: Colors.white.withOpacity(0.75),
                ),
                other: Icon(
                  FontAwesomeIcons.minus,
                  color: Colors.white.withOpacity(0.75),
                ),
              ),
            ),
            Text(
              percentOfDeviation.toInt().toString() + "%",
            ),
          ],
        );
      }

      //generate the bordered widget
      oneRepMaxWidget = Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          oneRepMaxWidget,
          Padding(
            padding: const EdgeInsets.only(
              left: 4.0,
            ),
            child: Icon(
              Icons.info_outline,
              color: Colors.white.withOpacity(0.50),
              size: 16,
            ),
          ),
        ],
      );
    }
    //ELSE: this is the users 1 rm

    //create the subtitle given the retreived values
    return GestureDetector(
      onTap: (){
        openSnackBar(
          context, 
          Colors.blue, 
          Icons.info_outline,
          message: snackbarMessage,
        );
      },
      //NOTE: this is just extra padding to make it easier to click the chip
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(
              top: 2.0, 
              right: 16.0,
              bottom: 4.0,
            ),
            //NOTE: can join rounded edges but not border with rounded edges
            //which is why those are seperate below
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                //-------------------------1 RM tag
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColorDark,
                    borderRadius: new BorderRadius.only(
                      topLeft: Radius.circular(borderRadius),
                      bottomLeft: Radius.circular(borderRadius),
                    ),
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: 4,
                    vertical: 5, //1 pixel to account for border width
                  ),
                  child: Text(
                    (isOneRepMaxEstimated ? "E-" : "") + "1RM",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                //-------------------------Value
                Container(
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    border: Border.all( //default width of 1.0
                      color: Theme.of(context).primaryColorDark,
                    ),
                    borderRadius: new BorderRadius.only(
                      bottomRight: Radius.circular(borderRadius),
                      topRight: Radius.circular(borderRadius),
                    ),
                  ),
                  child: oneRepMaxWidget,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}