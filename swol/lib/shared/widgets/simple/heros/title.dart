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
          builder: (context, child) {
            return ExcerciseTitleHeroHelper(
              percentToAppBar: animation.value,
              excercise: excercise,
              //during transition
              //no action can be taken
              //so we guarantee it by not passing onTap
            );
          },
        );
      },
      child: ExcerciseTitleHeroHelper(
        percentToAppBar: (inAppBar) ? 1 : 0,
        excercise: excercise,
        onTap: onTap,
      ),
    );
  }
}

class ExcerciseTitleHeroHelper extends StatelessWidget {
  ExcerciseTitleHeroHelper({
    @required this.percentToAppBar,
    @required this.excercise,
    this.onTap,
  });

  final double percentToAppBar;
  final AnExcercise excercise;
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
            color: (percentToAppBar == 0 || percentToAppBar == 1)
                ? Colors.transparent
                : Color.lerp(
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
              child: ReloadingTitle(
                excercise: excercise,
              )
            ),
          ),
        ),
      ),
    );
  }
}

//NOTE: this reloads simply because its stateful
class ReloadingTitle extends StatefulWidget {
  ReloadingTitle({
    @required this.excercise,
  });

  final AnExcercise excercise;

  @override
  _ReloadingTitleState createState() => _ReloadingTitleState();
}

class _ReloadingTitleState extends State<ReloadingTitle> {
  @override
  Widget build(BuildContext context) {
    return Text(
      widget.excercise.name,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        fontSize: 18,
      ),
    );
  }
}