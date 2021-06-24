//dart
import 'dart:math' as math;

//flutter
import 'package:flutter/material.dart';

//plugins
import 'package:page_transition/page_transition.dart';

//internal
import 'package:swol/pages/add/addExercise.dart';
import 'package:swol/main.dart';
import 'package:swol/other/otherHelper.dart';
import 'package:swol/shared/widgets/simple/conditional.dart';
import 'package:swol/shared/widgets/simple/heros/curveMod.dart';

class AddNewHero extends StatelessWidget {
  const AddNewHero({
    Key? key,
    required this.inAppBar,
    required this.longTransitionDuration,
  }) : super(key: key);

  final bool inAppBar;
  final Duration longTransitionDuration;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'addNew',
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
            return AddNewHeroHelper(
              percentToAppBar: animation.value,
              longTransitionDuration: longTransitionDuration,
            );
          },
        );
      },
      child: AddNewHeroHelper(
        percentToAppBar: (inAppBar) ? 1 : 0,
        longTransitionDuration: longTransitionDuration,
      ),
    );
  }
}

class AddNewHeroHelper extends StatelessWidget {
  const AddNewHeroHelper({
    Key? key,
    required this.percentToAppBar,
    required this.longTransitionDuration,
  }) : super(key: key);

  final double percentToAppBar;
  final Duration longTransitionDuration;

  @override
  Widget build(BuildContext context) {
    Function? onTap;
    if (percentToAppBar == 0 || percentToAppBar == 1) {
      if (percentToAppBar == 1) {
        onTap = () {
          FocusScope.of(context).unfocus();
          App.navSpread.value = false;
          Navigator.of(context).pop();
        };
      } else {
        onTap = () {
          App.navSpread.value = true;
          Navigator.push(
            context,
            PageTransition(
              duration: longTransitionDuration,
              type: PageTransitionType.bottomToTop,
              child: AddExercise(
                longTransitionDuration: longTransitionDuration,
              ),
            ),
          );
        };
      }
    }

    //NOTE in all cases below (regular button first, then app bar button)
    return Conditional(
      condition: percentToAppBar == 0,
      ifTrue: FloatingActionButton(
        heroTag: null,
        onPressed: onTap != null ? () => onTap!() : null,
        backgroundColor: Theme.of(context).accentColor,
        child: Icon(
          Icons.add,
          color: Theme.of(context).primaryColorDark,
          size: 24,
        ),
      ),
      ifFalse: ClipRRect(
        borderRadius: new BorderRadius.all(
          new Radius.circular(
            //button size should never be larger than 56
            //and even if its a little bit above nothing bad will happen
            lerpDouble(28, 0, percentToAppBar),
          ),
        ),
        child: Container(
          color: Color.lerp(
            Theme.of(context).accentColor,
            Theme.of(context).primaryColorDark,
            percentToAppBar,
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap != null ? () => onTap!() : null,
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 16,
                ),
                child: Container(
                  height: 48,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Flexible(
                        child: Padding(
                          padding: EdgeInsets.only(
                            right: lerpDouble(
                              8,
                              NavigationToolbar.kMiddleSpacing,
                              percentToAppBar,
                            ),
                          ),
                          child: Transform.rotate(
                            angle: (-math.pi / 4) * (percentToAppBar),
                            child: (percentToAppBar == 0)
                                ? Icon(
                                    Icons.add,
                                    color: Color.lerp(
                                      Theme.of(context).primaryColorDark,
                                      Colors.white,
                                      percentToAppBar,
                                    ),
                                  )
                                //NOTE: the close button must be turned to look like an add button
                                : Transform.rotate(
                                    angle: (-math.pi / 4),
                                    child: Icon(
                                      Icons.close,
                                      color: Color.lerp(
                                        Theme.of(context).primaryColorDark,
                                        Colors.white,
                                        percentToAppBar,
                                      ),
                                    ),
                                  ),
                          ),
                        ),
                      ),
                      Flexible(
                        child: Padding(
                          padding: EdgeInsets.only(
                            right: 8,
                          ),
                          child: DefaultTextStyle(
                            style: TextStyle(
                              decoration: TextDecoration.none,
                              textBaseline: TextBaseline.alphabetic,
                              fontWeight: FontWeight.w500,
                            ),
                            child: Text(
                              "Add New",
                              style: TextStyle.lerp(
                                TextStyle(
                                  color: Theme.of(context).primaryColorDark,
                                  letterSpacing: 1,
                                  fontSize: 14,
                                ),
                                //NOTE: I have absolutely no idea why its isnt allowing me to jut use
                                //Theme.of(context).primaryTextTheme.title
                                //but after print it I realized what values are different
                                //and can simply copy them over
                                TextStyle(
                                  color: Colors.white,
                                  letterSpacing: 0,
                                  fontSize: 20,
                                ),
                                percentToAppBar,
                              ),
                              softWrap: false,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
