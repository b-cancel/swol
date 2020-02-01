import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:swol/shared/structs/anExcercise.dart';

class ExcerciseBegin extends StatelessWidget {
  ExcerciseBegin({
    @required this.inAppBar,
    @required this.excercise,
  });

  final bool inAppBar;
  final AnExcercise excercise;

  @override
  Widget build(BuildContext context) {
    String generatedTag = "excerciseBegin" + excercise.id.toString();
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

class ContinueOrComplete extends StatelessWidget {
  const ContinueOrComplete({
    @required this.afterLastSet,
    Key key,
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
          color: Theme.of(context).primaryColorDark,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}