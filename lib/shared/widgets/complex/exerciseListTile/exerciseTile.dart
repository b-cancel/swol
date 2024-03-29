//flutter
import 'package:flutter/material.dart';

//plugin
import 'package:page_transition/page_transition.dart';
import 'package:swol/pages/search/searchesData.dart';

//internal: shared
import 'package:swol/shared/widgets/complex/exerciseListTile/exerciseLeading.dart';
import 'package:swol/shared/widgets/complex/exerciseListTile/oneRepMaxChip.dart';
import 'package:swol/shared/widgets/simple/heros/title.dart';
import 'package:swol/shared/structs/anExercise.dart';
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
class ExerciseTile extends StatefulWidget {
  ExerciseTile({required this.exercise, this.search, required Key? key})
      : super(key: key);

  final AnExercise exercise;
  final TextEditingController? search;

  @override
  _ExerciseTileState createState() => _ExerciseTileState();
}

class _ExerciseTileState extends State<ExerciseTile> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: false,
      onTap: () {
        //travel to page
        App.navSpread.value = true;

        //page transition
        PageTransition page = PageTransition(
          duration: ExercisePage.transitionDuration,
          type: PageTransitionType.rightToLeft,
          //wrap in light so warning pop up works well
          child: Theme(
            data: MyTheme.light,
            child: ExercisePage(
              exercise: widget.exercise,
            ),
          ),
        );

        //push or replace depending on scenario
        if (widget.search != null) {
          //add to recent searches
          SearchesData.addToSearches(widget.search!.text);
          //close keyboard IF open
          FocusScope.of(context).unfocus();
          //push replacement, lets heros still work
          Navigator.of(context).pushReplacement(page);
        } else
          Navigator.push(context, page);
      },
      onLongPress: () {
        //debug stuff that only I know about
        print("-------------------------Data-------------------------");
        print("id: " + widget.exercise.id.toString());
        print("name: " + widget.exercise.name.toString());
        print("url: " + widget.exercise.url.toString());
        print("note: " + widget.exercise.note.toString());
        print("-------------------------Settings-------------------------");
        print("prediction ID: " + widget.exercise.predictionID.toString());
        print("rep target: " + widget.exercise.repTarget.toString());
        print("recovery: " + widget.exercise.recoveryPeriod.toString());
        print("set target: " + widget.exercise.setTarget.toString());
        print("-------------------------E-------------------------");
      },
      title: ExerciseTitleHero(
        exercise: widget.exercise,
        inAppBar: false,
      ),
      //NOTE: this must output to null if there isn't a weight
      //because otherwise it will yeild alot of wasted space
      subtitle: ExerciseTileSubtitle(
        key: widget.key,
        exercise: widget.exercise,
      ),
      trailing: ExerciseTileLeading(
        key: widget.key,
        exercise: widget.exercise,
        tileInSearch: widget.search != null,
      ),
    );
  }
}
