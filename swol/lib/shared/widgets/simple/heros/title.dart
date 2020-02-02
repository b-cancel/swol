import 'package:flutter/material.dart';
import 'package:swol/other/otherHelper.dart';
import 'package:swol/shared/structs/anExcercise.dart';
import 'package:swol/shared/widgets/simple/heros/curveMod.dart';

class ExcerciseTitleHero extends StatelessWidget {
  ExcerciseTitleHero({
    @required this.excercise,
    @required this.inAppBar,
    this.onTap,
  });

  final AnExcercise excercise;
  final bool inAppBar;
  final Function onTap;
  

  @override
  Widget build(BuildContext context) {
    String generatedTag = "excerciseTitle" + excercise.id.toString();
    return Hero(
      tag: generatedTag,
      createRectTween: (begin, end) {
        return CustomRectTween(a: begin, b: end);
      },
      flightShuttleBuilder: (
        BuildContext flightContext,
        Animation<double> animation,
        HeroFlightDirection flightDirection,
        BuildContext fromHeroContext,
        BuildContext toHeroContext,
      ) {
        return AnimatedBuilder(
          animation: animation,
          builder: (context, child){
            return ExcerciseTitleHeroHelper(
              percentToAppBar: animation.value,
              title: excercise.name,
              //during transition 
              //no action can be taken 
              //so we guarantee it by not passing onTap
            );
          },
        );
      },
      child: ExcerciseTitleHeroHelper(
        percentToAppBar: (inAppBar) ? 1 : 0,
        title: excercise.name,
        onTap: onTap,
      ),
    );
  }
}

class ExcerciseTitleHeroHelper extends StatelessWidget {
  ExcerciseTitleHeroHelper({
    @required this.percentToAppBar,
    @required this.title,
    this.onTap,
  });

  final double percentToAppBar;
  final String title;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: ClipRRect(
          borderRadius: new BorderRadius.all(
            new Radius.circular(
              lerpDouble(12, 0, percentToAppBar),
            ),
          ),
          child: Container(
            color: Color.lerp(
              Theme.of(context).cardColor, 
              Theme.of(context).primaryColorDark, 
              percentToAppBar,
            ),
            child: Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(
              left: lerpDouble(
                0,
                56,
                percentToAppBar,
              ),
            ),
            child: Text(
              title,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 18,
              ),
            ),
              ),
          ),
        ),
      ),
    );
  }
}