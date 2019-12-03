import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:swol/other/functions/helper.dart';

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

    //TODO: this relies of the user not being allowed to plugin 0 as their rep count
    //TODO: the todo is to ensure this throughout the app

    //TODO: perhaps add something special since they actual literally improved their 1RM
    //NOTE: contains defaults for when this set is indeed a one rep max
    bool isOneRepMaxEstimated = false; 
    Widget oneRepMaxWidget = Text(
      lastWeight.toString(),
      style: BOLD,
    );
    String tooltipMessage = "Your 1 Rep Max";
    Color valueBorderColor = Theme.of(context).primaryColorDark;
    

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
        tooltipMessage = "Without a doubt this is your 1 Rep Max";
        //NOTE: we keep default valueBorderColor
      }
      else{ //we aren't sure about our result
        //NOTE: updating 
        //1. oneRepMaxWidget
        //2. tooltipMessage
        //3. valueBorderColor

        //make that clear by 
        //1. showing the devaition
        //2. but also by highligting the GUESS in an appropiate color
        //3. and add an appropiate tooltip with 
        //    a. sureness string
        //    b. suggestions to improve
        double mean = oneRepMaxValues[1];
        int percentOfDeviation = (
          (mean == 0 || standardDevaition.toInt() == 0) ? 0 
          : (standardDevaition / mean) * 100
        ).toInt();

        //TODO: improvable by actually using Maps
        //"Map" percent devaition to all its respective components
        String surenessString;
        int lessThanReps;
        if(percentOfDeviation > 25){
          surenessString = "Not Sure At All";
          lessThanReps = 25;
          valueBorderColor = Colors.red;
        }
        else if(percentOfDeviation > 20){
          surenessString = "Very Un-Sure";
          lessThanReps = 20;
          valueBorderColor = Colors.orange;
        }
        else if(percentOfDeviation > 15){
          surenessString = "Somewhat Un-Sure";
          lessThanReps = 15;
          valueBorderColor = Colors.yellow;
        }
        else if(percentOfDeviation > 10){
          surenessString = "Somewhat Sure";
          lessThanReps = 10;
          valueBorderColor = Colors.green;
        }
        else if(percentOfDeviation > 5){
          surenessString = "Very Sure";
          lessThanReps = 5;
          valueBorderColor = Colors.blue;
        }
        else{
          surenessString = "Extremely Sure";
          lessThanReps = 0;
          valueBorderColor = Colors.purple;
        }

        //let the user know how far the guess is
        tooltipMessage = "We are \"" + surenessString + "\" this is your 1 Rep Max";
        
        //ONLY discourage anything above 15 
        //since anything below is going to produce pretty good results
        tooltipMessage += (lessThanReps <= 15) ? ""
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
              child: PlusMinusIcon(),
            ),
            Text(
              standardDevaition.toInt().toString(),
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
    return Tooltip(
      preferBelow: false,
      message: tooltipMessage,
      //NOTE: this is just extra padding to make it easier to click the tooltip
      child: Padding(
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
                  color: valueBorderColor,
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
    );
  }
}

//-------------------------the icon I needed created programmatically for the giggles-------------------------

class PlusMinusIcon extends StatelessWidget {
  const PlusMinusIcon({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double size = 16;

    return Container(
      height: size,
      width: size,
      child: Stack(
        children: <Widget>[
          Positioned.fill(
            child: FittedBox(
              fit: BoxFit.contain,
              child: Icon(
                FontAwesomeIcons.percentage,
                color: Colors.white.withOpacity(0.75),
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            child: Container(
              height: size/2,
              width: size/2,
              child: FittedBox(
                fit: BoxFit.contain,
                child: Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 4.0,
                    ),
                    child: ClipOval(
                      child: Container(
                        color: Theme.of(context).cardColor,
                        child: Icon(
                          FontAwesomeIcons.plus,
                          color: Colors.white.withOpacity(0.75),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              height: size/2,
              width: size/2,
              child: FittedBox(
                fit: BoxFit.contain,
                child: Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: Padding(
                    padding: const EdgeInsets.only(
                      bottom: 4.0,
                    ),
                    child: ClipOval(
                      child: Container(
                        color: Theme.of(context).cardColor,
                        child: Icon(
                          FontAwesomeIcons.minus,
                          color: Colors.white.withOpacity(0.75),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}