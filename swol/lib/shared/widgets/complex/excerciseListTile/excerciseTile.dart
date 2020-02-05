//flutter
import 'package:flutter/material.dart';

//plugin
import 'package:page_transition/page_transition.dart';

//internal: shared
import 'package:swol/shared/widgets/complex/excerciseListTile/excerciseLeading.dart';
import 'package:swol/shared/widgets/complex/excerciseListTile/oneRepMaxChip.dart';
import 'package:swol/shared/widgets/simple/heros/title.dart';
import 'package:swol/shared/structs/anExcercise.dart';

//internal: other
import 'package:swol/excerciseAction/excercisePage.dart';
import 'package:swol/main.dart';

//widget
class ExcerciseTile extends StatelessWidget { 
  ExcerciseTile({
    @required this.excercise,
    this.tileInSearch: false,
  });

  final AnExcercise excercise;
  final bool tileInSearch;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: (){
        //TODO: remove all this testing code
        //-----
        print("id:" + excercise.id.toString());
        print("time stamp: " + excercise.lastTimeStamp.value.toString());
        print("name: " +  excercise.name.toString());
        print("url: " + excercise.url.toString());
        print("note: " + excercise.note.toString());
        //-----
        print("prediction ID: " + excercise.predictionID.toString());
        print("rep target: " + excercise.repTarget.toString());
        print("recovery: " + excercise.recoveryPeriod.toString());
        print("set target: " + excercise.setTarget.toString());

        //travel to page
        App.navSpread.value = true;

        //page transition
        Duration transitionDuration = Duration(milliseconds: 300);
        PageTransition page = PageTransition(
          duration: transitionDuration,
          type: PageTransitionType.rightToLeft, 
          //when transitioning to this page relaoding leading is always false
          //WILL SET reloading leading to true
          child: ExcercisePage(
            excercise: excercise,
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
        excercise: excercise,
        inAppBar: false,
      ),
      //NOTE: this must output to null if there isn't a weight 
      //because otherwise it will yeild alot of wasted space
      subtitle: ExcerciseTileSubtitle(
        excercise: excercise,
      ),
      trailing: ExcerciseTileLeading(
        excercise: excercise,
        tileInSearch: tileInSearch,
      ),
    );
  }
}