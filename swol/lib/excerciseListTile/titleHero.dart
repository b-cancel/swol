import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:swol/other/otherHelper.dart';

class ExcerciseTitleHero extends StatelessWidget {
  ExcerciseTitleHero({
    @required this.inAppBar,
    @required this.title,
    this.onTap,
    @required this.excerciseIDTag,
  });

  final bool inAppBar;
  final String title;
  final Function onTap;
  final int excerciseIDTag;

  @override
  Widget build(BuildContext context) {
    String generatedTag = "excerciseTitle" + excerciseIDTag.toString();
    return Hero(
      tag: generatedTag,
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
              title: title,
              //during transition 
              //no action can be taken 
              //so we guarantee it by not passing onTap
            );
          },
        );
      },
      child: ExcerciseTitleHeroHelper(
        percentToAppBar: (inAppBar) ? 1 : 0,
        title: title,
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

class ExcerciseBegin extends StatelessWidget {
  ExcerciseBegin({
    @required this.inAppBar,
    @required this.excerciseIDTag,
  });

  final bool inAppBar;
  final int excerciseIDTag;

  @override
  Widget build(BuildContext context) {
    String generatedTag = "excerciseBegin" + excerciseIDTag.toString();
    return Hero(
      tag: generatedTag,
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
            return ExcerciseTitleBeginHelper(
              percentToAppBar: animation.value,
            );
          },
        );
      },
      child: ExcerciseTitleBeginHelper(
        percentToAppBar: (inAppBar) ? 1 : 0,
      ),
    );
  }
}

class ExcerciseTitleBeginHelper extends StatelessWidget {
  ExcerciseTitleBeginHelper({
    @required this.percentToAppBar,
  });

  final double percentToAppBar;

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: (-math.pi / 4) * (4 * percentToAppBar),
      child: Container(
        decoration: new BoxDecoration(
          color: Color.lerp(
            Theme.of(context).cardColor, 
            Theme.of(context).primaryColorDark, 
            percentToAppBar,
          ),
          shape: BoxShape.circle,
        ),
        child: Icon(Icons.chevron_right),
      ),
    );
  }
}

/*
class ExcerciseContinueOrEnd extends StatelessWidget {
  ExcerciseContinueOrEnd({
    @required this.inAppBar,
    @required this.excerciseIDTag,
    @required this.afterLastSet,
  });

  final bool inAppBar;
  final int excerciseIDTag;
  final bool afterLastSet;

  @override
  Widget build(BuildContext context) {
    String generatedTag = "excerciseContinueOrEnd" + excerciseIDTag.toString();
    return Hero(
      tag: generatedTag,
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
            return ExcerciseContinueOrEndHelper(
              percentToAppBar: animation.value,
              fromInAppBar: inAppBar,
              afterLastSet: afterLastSet,
            );
          },
        );
      },
      child: ExcerciseContinueOrEndHelper(
        percentToAppBar: (inAppBar) ? 1 : 0,
        fromInAppBar: inAppBar,
        afterLastSet: afterLastSet,
      ),
    );
  }
}

class ExcerciseContinueOrEndHelper extends StatelessWidget {
  ExcerciseContinueOrEndHelper({
    @required this.percentToAppBar,
    @required this.fromInAppBar,
    @required this.afterLastSet,
  });

  final double percentToAppBar;
  final bool fromInAppBar;
  final bool afterLastSet;

  @override
  Widget build(BuildContext context) {
    return ;
  }
}
*/