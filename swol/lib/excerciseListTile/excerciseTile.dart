//flutter
import 'package:flutter/material.dart';

//plugin
import 'package:page_transition/page_transition.dart';

//internal: list tile
import 'package:swol/excerciseListTile/excerciseLeading.dart';
import 'package:swol/excerciseListTile/oneRepMaxChip.dart';
import 'package:swol/excerciseListTile/titleHero.dart';

//internal: shared
import 'package:swol/shared/methods/excerciseData.dart';
import 'package:swol/shared/structs/anExcercise.dart';

//internal: other
import 'package:swol/excerciseAction/excercisePage.dart';
import 'package:swol/main.dart';

//widget
class ExcerciseTile extends StatelessWidget { 
  ExcerciseTile({
    @required this.excerciseID,
    this.tileInSearch: false,
  });

  final int excerciseID;
  final bool tileInSearch;

  @override
  Widget build(BuildContext context) {
    //NOTE: we are using thisExcercise directly below because everything is stateless
    //and therefore updates won't break anything
    AnExcercise thisExcercise = ExcerciseData.getExcercises().value[excerciseID];

    //return
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

        //travel to page
        App.navSpread.value = true;

        //page transition
        Duration transitionDuration = Duration(milliseconds: 300);
        PageTransition page = PageTransition(
          duration: transitionDuration,
          type: PageTransitionType.upToDown, 
          //when transitioning to this page relaoding leading is always false
          //WILL SET reloading leading to true
          child: ExcercisePage(
            excerciseID: excerciseID,
            transitionDuration: transitionDuration,
          ),
        );

        //push or replace depending on scenario
        if(tileInSearch){
          //close keyboard IF open
          FocusScope.of(context).unfocus();
          //push replacement, lets heros still work
          Navigator.of(context).pushReplacement(page);
        }
        else Navigator.push(context, page);
      },
      title: ExcerciseTitleHero(
        inAppBar: false,
        title: thisExcercise.name,
        excerciseIDTag: thisExcercise.id,
      ),
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