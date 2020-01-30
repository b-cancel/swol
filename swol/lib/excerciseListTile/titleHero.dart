import 'package:flutter/material.dart';
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

/*
Flexible(
                      child: Padding(
                        padding: EdgeInsets.only(
                          right: lerpDouble(
                            8,
                            (NavigationToolbar.kMiddleSpacing * 2),
                            percentToAppBar,
                          ),
                        ),
                        child: Transform.rotate(
                          angle: (-math.pi / 4) * (5 * percentToAppBar),
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
    */
  }
}