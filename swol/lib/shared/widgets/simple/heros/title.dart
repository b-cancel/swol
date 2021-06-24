import 'package:flutter/material.dart';
import 'package:swol/other/otherHelper.dart';
import 'package:swol/shared/structs/anExercise.dart';
import 'package:swol/shared/widgets/simple/heros/curveMod.dart';

class ExerciseTitleHero extends StatelessWidget {
  ExerciseTitleHero({
    required this.exercise,
    required this.inAppBar,
    this.onTap,
  });

  final AnExercise exercise;
  final bool inAppBar;
  final Function? onTap;

  @override
  Widget build(BuildContext context) {
    String generatedTag = "exerciseTitle" + exercise.id.toString();
    return Hero(
      tag: generatedTag,
      createRectTween: (begin, end) {
        if (begin != null && end != null) {
          return CustomRectTween(a: begin, b: end);
        } else {
          return CustomRectTween();
        }
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
          builder: (context, child) {
            return ExerciseTitleHeroHelper(
              percentToAppBar: animation.value,
              exercise: exercise,
              //during transition
              //no action can be taken
              //so we guarantee it by not passing onTap
            );
          },
        );
      },
      child: ExerciseTitleHeroHelper(
        percentToAppBar: (inAppBar) ? 1 : 0,
        exercise: exercise,
        onTap: onTap != null ? () => onTap!() : null,
      ),
    );
  }
}

class ExerciseTitleHeroHelper extends StatelessWidget {
  ExerciseTitleHeroHelper({
    required this.percentToAppBar,
    required this.exercise,
    this.onTap,
  });

  final double percentToAppBar;
  final AnExercise exercise;
  final Function? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap != null ? () => onTap!() : null,
        child: Container(
          color: (percentToAppBar == 0 || percentToAppBar == 1)
              ? Colors.transparent
              : Color.lerp(
                  Theme.of(context).cardColor,
                  Theme.of(context).primaryColor,
                  percentToAppBar,
                ),
          padding: EdgeInsets.symmetric(
            vertical: lerpDouble(
              0,
              16,
              percentToAppBar,
            ),
          ),
          child: Container(
            alignment: Alignment.centerLeft,
            child: Text(
              exercise.name,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 18,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
