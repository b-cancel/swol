//flutter
import 'package:flutter/material.dart';

//plugin
import 'package:page_transition/page_transition.dart';

//internal: basic
import 'package:swol/excercise/excerciseData.dart';
import 'package:swol/excercise/excerciseStructure.dart';

//internal: list tile
import 'package:swol/excerciseListTile/excerciseLeading.dart';
import 'package:swol/excerciseListTile/oneRepMaxChip.dart';

//internal: other
import 'package:swol/excerciseAction/excercisePage.dart';

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
        //NOE: we can uncomment for equal spacing (I prefer it to be uneven)
        //height: 30, 
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