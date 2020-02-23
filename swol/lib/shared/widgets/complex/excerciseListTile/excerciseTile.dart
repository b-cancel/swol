//flutter
import 'package:flutter/material.dart';

//plugin
import 'package:page_transition/page_transition.dart';

//internal: shared
import 'package:swol/shared/widgets/complex/excerciseListTile/excerciseLeading.dart';
import 'package:swol/shared/widgets/complex/excerciseListTile/oneRepMaxChip.dart';
import 'package:swol/shared/widgets/simple/heros/title.dart';
import 'package:swol/shared/structs/anExcercise.dart';
import 'package:swol/shared/methods/theme.dart';

//internal: other
import 'package:swol/action/page.dart';
import 'package:swol/main.dart';

/*
notes below based on this link
https://medium.com/flutter/keys-what-are-they-good-for-13cb51742e7d
*/
//1. should pass key to stateful widget
//3. the element tree all keys track of state 
//    A.K.A. the variables within that object
//    we need a KEY to tie the element tree node to the widget tree node
//    even after some update
//4. add them at the top of the widget subtree with the state you need to preserve.
//    yes even if its stateless
//Types of Keys:  ValueKey, ObjectKey, UniqueKey, GlobalKey
//    If you have multiple widgets in your collection with the same value 
//    or if you want to really ensure each widget 
//    is distinct from all others, you can use the UniqueKey
//NOTE: If you construct a newUniqueKey inside a build method, 
//    the widget using that key will get a different, 
//    unique key every time you the build method re-executes
//NOTE: this ofcourse won't happen with value and object keys but with those you are limited in that
//    you must not have the same value or object repeat

//widget
class ExcerciseTile extends StatefulWidget { 
  ExcerciseTile({
    @required this.excercise,
    this.tileInSearch: false,
    Key key
  }) : super(key: key); 

  final AnExcercise excercise;
  final bool tileInSearch;

  @override
  _ExcerciseTileState createState() => _ExcerciseTileState();
}

class _ExcerciseTileState extends State<ExcerciseTile> {
  //the value notifiers passed all over the place in the widgets below
  final ValueNotifier<DateTime> dtTimerStarted = ValueNotifier(AnExcercise.nullDateTime);

  updateTempStartTime(){
    if(dtTimerStarted.value == AnExcercise.nullDateTime){
      widget.excercise.tempStartTime = null;
    }
    else widget.excercise.tempStartTime = dtTimerStarted.value;
  }

  @override
  void initState(){
    //super init
    super.initState();

    //set initial value
    dtTimerStarted.value = widget.excercise.tempStartTime ?? AnExcercise.nullDateTime;
    dtTimerStarted.addListener(updateTempStartTime);
  }

  @override
  void dispose(){
    //notify
    dtTimerStarted.removeListener(updateTempStartTime);

    //super dipose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Duration transitionDuration = Duration(milliseconds: 300);

    //widget
    return ListTile(
      onTap: (){
        //-----
        print("id:" + widget.excercise.id.toString());
        print("time stamp: " + widget.excercise.lastTimeStamp.toString());
        print("name: " +  widget.excercise.name.toString());
        print("url: " + widget.excercise.url.toString());
        print("note: " + widget.excercise.note.toString());
        //-----
        print("prediction ID: " + widget.excercise.predictionID.toString());
        print("rep target: " + widget.excercise.repTarget.toString());
        print("recovery: " + widget.excercise.recoveryPeriod.toString());
        print("set target: " + widget.excercise.setTarget.toString());

        //travel to page
        App.navSpread.value = true;

        //page transition
        PageTransition page = PageTransition(
          duration: transitionDuration,
          type: PageTransitionType.rightToLeft, 
          //wrap in light so warning pop up works well
          child: Theme(
            data: MyTheme.light,
            child: ExcercisePage(
              excercise: widget.excercise,
              transitionDuration: transitionDuration, 
              dtTimerStarted: dtTimerStarted,
            ),
          ),
        );

        //push or replace depending on scenario
        if(widget.tileInSearch){
          //close keyboard IF open
          FocusScope.of(context).unfocus();
          //push replacement, lets heros still work
          Navigator.of(context).pushReplacement(page);
        }
        else Navigator.push(context, page);
      },
      title: ExcerciseTitleHero(
        excercise: widget.excercise,
        inAppBar: false,
      ),
      //NOTE: this must output to null if there isn't a weight 
      //because otherwise it will yeild alot of wasted space
      subtitle: ExcerciseTileSubtitle(
        excercise: widget.excercise,
        transitionDuration: transitionDuration,
        dtTimerStarted: dtTimerStarted,
      ),
      trailing: ExcerciseTileLeading(
        excercise: widget.excercise,
        transitionDuration: transitionDuration,
        tileInSearch: widget.tileInSearch,
        dtTimerStarted: dtTimerStarted,
      ),
    );
  }
}