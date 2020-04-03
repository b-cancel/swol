//dart
import 'package:swol/action/page.dart';
import 'package:vector_math/vector_math_64.dart' as vect;

//flutter
import 'package:flutter/material.dart';

//plugin
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:page_transition/page_transition.dart';

//internal
import 'package:swol/shared/widgets/complex/onBoarding/wrapper.dart';
import 'package:swol/shared/functions/onboarding.dart';
import 'package:swol/pages/learn/page.dart';
import 'package:swol/main.dart';

class AnimatedTitleAction extends StatelessWidget {
  const AnimatedTitleAction({
    Key key,
    @required this.screenWidth,
  }) : super(key: key);

  final double screenWidth;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: App.navSpread,
      builder: (context,child){
        return AnimatedContainer(
          transform: Matrix4.translation(
            vect.Vector3(
              (App.navSpread.value == true) ? screenWidth/2 : 0,
              0,
              0
            ),  
          ),
          duration: ExercisePage.transitionDuration,
          child: FeatureWrapper(
            featureID: AFeature.LearnPage.toString(),
            tapTarget: Icon(FontAwesomeIcons.leanpub),
            text: "Tap here to LEARN"
            + "\nabout the concepts,"
            + "\nmath, and science" 
            + "\nbehind our app",
            child: IconButton(
              onPressed: (){
                App.navSpread.value = true;
                Navigator.push(
                  context, 
                  PageTransition(
                    type: PageTransitionType.rightToLeft, 
                    duration: ExercisePage.transitionDuration,
                    child: LearnExercise(),
                  ),
                );
              },
              icon: Icon(FontAwesomeIcons.leanpub),
            ),
            top: true,
            left: false,
            prevFeature: (){
              OnBoarding.discoverSwolLogo(context);
            },
            nextFeature: (){
              OnBoarding.discoverAddExercise(context);
            },
          ),
        );
      },
    );
  }
}

class AnimatedTitle extends StatelessWidget {
  const AnimatedTitle({
    Key key,
    @required this.screenWidth,
    @required this.statusBarHeight,
  }) : super(key: key);

  final double screenWidth;
  final double statusBarHeight;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: App.navSpread,
      builder: (context, child){
        return AnimatedContainer(
          duration: ExercisePage.transitionDuration,
          transform: Matrix4.translation(
            vect.Vector3(
              (App.navSpread.value == true) ? -screenWidth/2 : 0,
              0,
              0,
            ),  
          ),
          child: FeatureWrapper(
            featureID: AFeature.SwolLogo.toString(),
            tapTarget: SwolLogo(
              height: statusBarHeight - 16,
            ),
            text: "What you're going to be"
            + "\nafter using this app",
            child: SwolLogo(
              height: statusBarHeight,
            ),
            top: true,
            left: true,
            nextFeature: (){
              OnBoarding.discoverLearnPage(context);
            }
          ),
        );
      },
    );
  }
}

class SwolLogo extends StatelessWidget {
  const SwolLogo({
    this.height,
    Key key,
  }) : super(key: key);

  final height;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      child: FittedBox(
        fit: BoxFit.cover,
        child: DefaultTextStyle(
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
          child: Stack(
            children: <Widget>[
              Transform.translate(
                offset: Offset(1, 0),
                child: Text(
                  "S W O L",
                  style: TextStyle(
                    color: Theme.of(context).accentColor,
                  ),
                ),
              ),
              Transform.translate(
                offset: Offset(-1, 0),
                child: Text(
                  "S W O L",
                  style: TextStyle(
                    color: Colors.red,
                  ),
                ),
              ),
              Text(
                "S W O L",
                style: TextStyle(
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}