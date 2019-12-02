//flutter
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

//plugin
import 'package:page_transition/page_transition.dart';
import 'package:swol/excercise/defaultDateTimes.dart';

//internal: basic
import 'package:swol/excercise/excerciseData.dart';
import 'package:swol/excercise/excerciseStructure.dart';
import 'package:swol/other/durationFormat.dart';

//internal: link
import 'package:swol/excerciseAction/excercisePage.dart';
import 'package:swol/other/functions/helper.dart';

//widget
class ExcerciseTile extends StatelessWidget {
  ExcerciseTile({
    @required this.excerciseID,
    this.tileInSearch: false,
    @required this.navSpread,
  });

  final int excerciseID;
  //If this is displayed in the list then we dont have to show alot of info
  final bool tileInSearch;
  final ValueNotifier<bool> navSpread;

  @override
  Widget build(BuildContext context) {
    AnExcercise thisExcercise = ExcerciseData.getExcercises().value[excerciseID];

    //calcualted 1 rep max if possible
    Widget subtitle;
    if(thisExcercise.lastWeight != null){

      List oneRepMaxValues = Functions.getOneRepMaxValues(
        thisExcercise.lastWeight, 
        thisExcercise.lastReps,
      );

      //splits things up
      String oneRepMax = oneRepMaxValues[0][thisExcercise.predictionID].toInt().toString();
      String error;
      String sureness;
      int lessThanReps;

      int deviation = oneRepMaxValues[2].toInt();
      print("Dev: " + deviation.toString());
      int percentDeviation;
      Color deviationBackgroundColor;
      Color deviationTextColor;
      if(deviation != 0){
        error = deviation.toString();

        percentDeviation = (
          (oneRepMaxValues[1] == 0 || deviation == 0) 
          ? 0 
          : (oneRepMaxValues[2] / oneRepMaxValues[1]) * 100
        ).toInt();

        //set text
        if(percentDeviation > 25) sureness = "Not Sure At All";
        else if(percentDeviation > 20) sureness = "Very Un-Sure";
        else if(percentDeviation > 15) sureness = "Somewhat Un-Sure";
        else if(percentDeviation > 10) sureness = "Somewhat Sure";
        else if(percentDeviation > 5) sureness = "Very Sure";
        else sureness = "Extremely Sure";

        //less than reps
        if(percentDeviation > 25) lessThanReps = 25;
        else if(percentDeviation > 20) lessThanReps = 20;
        else if(percentDeviation > 15) lessThanReps = 15;
        else if(percentDeviation > 10) lessThanReps = 10;
        else if(percentDeviation > 5) lessThanReps = 5;
        else lessThanReps = 0;

        //based on the deviation set the colors

        //set background
        if(percentDeviation > 25) deviationBackgroundColor = Colors.red;
        else if(percentDeviation > 20) deviationBackgroundColor = Colors.orange;
        else if(percentDeviation > 15) deviationBackgroundColor = Colors.yellow;
        else if(percentDeviation > 10) deviationBackgroundColor = Colors.green;
        else if(percentDeviation > 5) deviationBackgroundColor = Colors.blue;
        else deviationBackgroundColor = Colors.purple;

        //set text color
        if(percentDeviation > 10) deviationTextColor = Colors.black;
        else deviationTextColor = Colors.white;
      }

      Widget oneRepMaxText = Text(
        oneRepMax,
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      );

      double borderSize = 8;

      //create the subtitle given the retreived values
      subtitle = Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColorDark,
              borderRadius: new BorderRadius.only(
                topLeft: Radius.circular(borderSize),
                bottomLeft: Radius.circular(borderSize),
              ),
            ),
            padding: EdgeInsets.symmetric(
              horizontal: 4,
              vertical: 5,
            ),
            child: Text(
              "1RM",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          error == null ? Container(
            decoration: BoxDecoration(
              border: Border.all(color: Theme.of(context).primaryColorDark),
              borderRadius: new BorderRadius.only(
                bottomRight: Radius.circular(borderSize),
                topRight: Radius.circular(borderSize),
              ),
            ),
            padding: EdgeInsets.all(4),
            child: oneRepMaxText,
          ) : Padding(
            padding: const EdgeInsets.only(
              top: 2.0,
            ),
            child: Tooltip(
              preferBelow: false,
              message: "We are \"" + sureness + "\" this is your 1 Rep Max"
               + (
                 (lessThanReps >= 15) 
                 ? "\nConsider doing less than " + lessThanReps.toString() + " reps for Better Results" 
                 : ""
              ),
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 2.0,
                    bottom: 4,
                    right: 16,
                  ),
                  child: Container(
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      border: Border.all(color: deviationBackgroundColor),
                      borderRadius: new BorderRadius.only(
                        bottomRight: Radius.circular(borderSize),
                        topRight: Radius.circular(borderSize),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        oneRepMaxText,
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 2.0,
                          ),
                          child: PlusMinusIcon(),
                        ),
                        Text(
                          error,
                        ),
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
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    }

    //right trailing icon
    Widget trailing;
    
    //if in progress set the proper icon
    if(LastTimeStamp.isInProgress(thisExcercise.lastTimeStamp)){
      if(thisExcercise.tempStartTime != null){
        //TODO test below
        Duration timeSinceBreakStarted = DateTime.now().difference(thisExcercise.tempStartTime);
        if(timeSinceBreakStarted > thisExcercise.recoveryPeriod){
          trailing = Icon(
            FontAwesomeIcons.hourglassEnd, //time done ticking
            color: Colors.red,
          );
        }
        else trailing = Icon(FontAwesomeIcons.hourglassHalf); //time ticking
      }
      else trailing = Icon(FontAwesomeIcons.hourglassStart); //time may tick again
    }
    else{
      if(tileInSearch){
        if(LastTimeStamp.isNew(thisExcercise.lastTimeStamp)){
          trailing = ListTileChipShell(
            chip: MyChip(
              chipString: 'NEW',
            ),
          );
        }
        else{
          if(LastTimeStamp.isHidden(thisExcercise.lastTimeStamp)){
            trailing = ListTileChipShell(
              chip: MyChip(
                chipString: 'HIDDEN',
              ),
            );
          }
          else{
            trailing = Text(
              DurationFormat.format(
                DateTime.now().difference(thisExcercise.lastTimeStamp),
                showMinutes: false,
                showSeconds: false,
                showMilliseconds: false,
                showMicroseconds: false,
                short: true,
              ),
            );
          }
        }
      }
      else trailing = Icon(Icons.chevron_right);
    }
    
    //build our widget given that search term
    return ListTile(
      onTap: (){
        //-----
        print("id:" + excerciseID.toString());
        print("time stamp: " + thisExcercise.lastTimeStamp.toString());
        print("name: " +  thisExcercise.name.toString());
        print("url: " + thisExcercise.url.toString());
        print("note: " + thisExcercise.note.toString());
        //-----
        print("prediction ID: " + thisExcercise.predictionID.toString());
        print("rep target: " + thisExcercise.repTarget.toString());
        print("recovery: " + thisExcercise.recoveryPeriod.toString());
        print("set target: " + thisExcercise.setTarget.toString());

        //pop search page
        if(tileInSearch){
          FocusScope.of(context).unfocus();
          Navigator.of(context).pop();
        }

        //travel to page
        navSpread.value = true;
        Navigator.push(
          context, 
          PageTransition(
            type: PageTransitionType.rightToLeft, 
            child: ExcercisePage(
              excerciseID: excerciseID,
              navSpread: navSpread,
            ),
          ),
        );
      },
      title: Text(thisExcercise.name),
      subtitle: subtitle,
      trailing: trailing,
    );
  }
}

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

class ListTileChipShell extends StatelessWidget {
  const ListTileChipShell({
    Key key,
    @required this.chip,
  }) : super(key: key);

  final Widget chip;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: 8,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          chip,
        ],
      ),
    );
  }
}

class MyChip extends StatelessWidget {
  const MyChip({
    Key key,
    @required this.chipString,
    this.inverse: false,
  }) : super(key: key);

  final String chipString;
  final bool inverse;

  @override
  Widget build(BuildContext context) {
    Color chipColor = (inverse) ? Theme.of(context).primaryColorDark : Theme.of(context).accentColor;
    Color textColor = (inverse) ? Theme.of(context).accentColor : Theme.of(context).primaryColorDark;

    return Container(
      alignment: Alignment.topLeft,
      child: Padding(
        padding: EdgeInsets.only(
          right: 4,
        ),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: 4,
          ),
          decoration: new BoxDecoration(
            color: chipColor,
            borderRadius: new BorderRadius.all(
              Radius.circular(12.0),
            ),
          ),
          child: Text(
            chipString,
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}