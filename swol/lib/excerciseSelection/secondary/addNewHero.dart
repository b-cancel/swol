//dart
import 'dart:math' as math;

//flutter
import 'package:flutter/material.dart';

//plugins
import 'package:page_transition/page_transition.dart';

//internal
import 'package:swol/excerciseAddition/addExcercise.dart';
import 'package:swol/other/otherHelper.dart';

class AddNewHero extends StatelessWidget {
  const AddNewHero({
    Key key,
    @required this.inAppBar,
    @required this.navSpread,
  }) : super(key: key);

  final bool inAppBar;
  final ValueNotifier<bool> navSpread;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'addNew',
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
            return AddNewHeroHelper(
              percentToAppBar: animation.value,
              navSpread: navSpread,
            );
          },
        );
      },
      child: AddNewHeroHelper(
        percentToAppBar: (inAppBar) ? 1 : 0,
        navSpread: navSpread,
      ),
    );
  }
}

class AddNewHeroHelper extends StatelessWidget {
  const AddNewHeroHelper({
    Key key,
    @required this.percentToAppBar,
    @required this.navSpread,
  }) : super(key: key);

  final double percentToAppBar;
  final ValueNotifier<bool> navSpread;

  @override
  Widget build(BuildContext context) {
    Duration transitionDuration = Duration(milliseconds: 500);

    //determine on tap function
    Function onTap;
    if(percentToAppBar == 0 || percentToAppBar == 1){
      if(percentToAppBar == 1){
        onTap = (){
          FocusScope.of(context).unfocus();
          navSpread.value = false;
          Navigator.of(context).pop();
        };
      }
      else{
        onTap = (){
          navSpread.value = true;
          Navigator.push(
            context, 
            PageTransition(
              duration: transitionDuration,
              type: PageTransitionType.downToUp, 
              child: AddExcercise(
                navSpread: navSpread,
                showPageDuration: transitionDuration,
              ),
            ),
          );
        };
      }
    } //Tapping while transitioning does nothing
    else onTap = (){};

    //NOTE in all cases below (regular button first, then app bar button)
    return ClipRRect(
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
            onTap: onTap,
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
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}