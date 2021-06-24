import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:swol/shared/structs/anExercise.dart';
import 'package:swol/shared/widgets/simple/heros/curveMod.dart';

class ExerciseBegin extends StatelessWidget {
  ExerciseBegin({
    required this.inAppBar,
    this.exercise,
  });

  final bool inAppBar;
  final AnExercise? exercise;

  @override
  Widget build(BuildContext context) {
    if (exercise == null) {
      return ExerciseTitleBeginHelper(
        percentToAppBar: (inAppBar) ? 1 : 0,
      );
    } else {
      String generatedTag = "exerciseBegin" + exercise!.id.toString();
      return Hero(
        tag: generatedTag,
        createRectTween: (begin, end) {
          return CustomRectTween(
            a: begin,
            b: end,
          );
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
              return ExerciseTitleBeginHelper(
                percentToAppBar: animation.value,
              );
            },
          );
        },
        child: ExerciseTitleBeginHelper(
          percentToAppBar: (inAppBar) ? 1 : 0,
        ),
      );
    }
  }
}

class ExerciseTitleBeginHelper extends StatelessWidget {
  ExerciseTitleBeginHelper({
    required this.percentToAppBar,
  });

  final double percentToAppBar;

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: (-math.pi / 4) * (4 * percentToAppBar),
      child: Container(
        decoration: new BoxDecoration(
          color: (percentToAppBar == 0 || percentToAppBar == 1)
              ? Colors.transparent
              : Color.lerp(
                  Theme.of(context).cardColor,
                  Theme.of(context).primaryColor,
                  percentToAppBar,
                ),
          shape: BoxShape.circle,
        ),
        child: Icon(Icons.chevron_right),
      ),
    );
  }
}

class ContinueOrComplete extends StatelessWidget {
  const ContinueOrComplete({
    required this.afterLastSet,
    Key? key,
  }) : super(key: key);

  final bool afterLastSet;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Theme.of(context).accentColor,
      ),
      padding: EdgeInsets.all(8),
      child: Text(
        afterLastSet ? "Finished?" : "Next Set?",
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
