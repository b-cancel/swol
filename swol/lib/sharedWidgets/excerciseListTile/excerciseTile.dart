//flutter
import 'package:flutter/material.dart';

//plugin
import 'package:page_transition/page_transition.dart';

//internal: basic
import 'package:swol/excercise/excerciseData.dart';
import 'package:swol/excercise/excerciseStructure.dart';

//internal: link
import 'package:swol/excerciseAction/excercisePage.dart';
import 'package:swol/sharedWidgets/excerciseListTile/miniTimer.dart';
import 'package:swol/sharedWidgets/excerciseListTile/oneRepMaxChip.dart';

//widget
class ExcerciseTile extends StatelessWidget { 
  ExcerciseTile({
    @required this.excerciseID,
    this.tileInSearch: false,
    @required this.navSpread,
  });

  final int excerciseID;
  final bool tileInSearch;
  final ValueNotifier<bool> navSpread;

  @override
  Widget build(BuildContext context) {
    
    AnExcercise thisExcercise = ExcerciseData.getExcercises().value[excerciseID];
    return ListTile(
      onTap: (){
        //TODO: remove all this testing code
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

        //before traveling to the excercise
        if(tileInSearch){
          //close keyboard
          FocusScope.of(context).unfocus();
          //pop search page
          Navigator.of(context).pop();
        }

        //travel to page
        navSpread.value = true;
        Duration transitionDuration = Duration(milliseconds: 300);
        Navigator.push(
          context, 
          PageTransition(
            duration: transitionDuration,
            type: PageTransitionType.upToDown, 
            //when transitioning to this page relaoding leading is always false
            //WILL SET reloading leading to true
            child: ExcercisePage(
              excerciseID: excerciseID,
              navSpread: navSpread,
              transitionDuration: transitionDuration,
            ),
          ),
        );
      },
      title: Text(thisExcercise.name),
      //NOTE: this must output to null if there isn't a weight 
      //because otherwise it will yeild alot of wasted space
      subtitle: (thisExcercise.lastWeight == null) 
      //used so all tiles are the same height
      //and can properly show the mini timer
      ? Container(
        height: 0,
        width: 0,
        //height: 30, //TODO: uncomment for equal spacing (I prefer it to be uneven)
      )
      //show 1 rep max stuffs
      : ExcerciseTileSubtitle(
        lastWeight: thisExcercise.lastWeight,
        lastReps: thisExcercise.lastReps,
        functionID: thisExcercise.predictionID,
      ),
      trailing: ExcerciseTileLeading(
        excerciseReference: thisExcercise,
        tileInSearch: tileInSearch,
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