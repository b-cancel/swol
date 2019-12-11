//dart
import 'package:feature_discovery/feature_discovery.dart';
import 'package:swol/excerciseSelection/secondary/decoration.dart';
import 'package:swol/utils/onboarding.dart';
import 'package:vector_math/vector_math_64.dart' as vect;

//flutter
import 'package:flutter/material.dart';

//plugin
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:page_transition/page_transition.dart';

//internal
import 'package:swol/learn/learn.dart';

class AnimatedTitleAction extends StatelessWidget {
  const AnimatedTitleAction({
    Key key,
    @required this.navSpread,
    @required this.screenWidth,
  }) : super(key: key);

  final ValueNotifier<bool> navSpread;
  final double screenWidth;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: navSpread,
      builder: (context,child){
        Widget button = IconButton(
          onPressed: (){
            navSpread.value = true;
            Navigator.push(
              context, 
              PageTransition(
                type: PageTransitionType.rightToLeft, 
                child: LearnExcercise(
                  navSpread: navSpread,
                ),
              ),
            );
          },
          icon: Icon(FontAwesomeIcons.leanpub),
        );

        //-----Animated Offset
        return AnimatedContainer(
          transform: Matrix4.translation(
            vect.Vector3(
              (navSpread.value == true) ? screenWidth/2 : 0,
              0,
              0
            ),  
          ),
          duration: Duration(milliseconds: 300),
          child: DescribedFeatureOverlay(
            featureId: 'learn_page',
            //target
            tapTarget: button,
            targetColor: Theme.of(context).primaryColor,
            //background
            title: OnBoardingText(
              text: "Tap here to LEARN"
              + "\nabout the concepts,"
              + "\nmath, and science" 
              + "\nbehind our app",
              toLeft: false,
            ),
            textColor: Colors.white,
            description: OnBoardingImage(
              width: MediaQuery.of(context).size.width,
              multiplier: (2/3),
              imageUrl: "assets/biceps/topRight.png",
            ),
            backgroundColor: Theme.of(context).primaryColorDark,
            //settings
            contentLocation: ContentLocation.below,
            overflowMode: OverflowMode.wrapBackground,
            enablePulsingAnimation: true,
            //child
            child: button,
          ),
        );
      },
    );
  }
}

class AnimatedTitle extends StatelessWidget {
  const AnimatedTitle({
    Key key,
    @required this.navSpread,
    @required this.screenWidth,
    @required this.statusBarHeight,
  }) : super(key: key);

  final ValueNotifier<bool> navSpread;
  final double screenWidth;
  final double statusBarHeight;

  @override
  Widget build(BuildContext context) {
    Widget swolLogoSmall = SwolLogo(
      height: statusBarHeight - 16,
    );

    Widget swolLogo = SwolLogo(
      height: statusBarHeight,
    );

    //build
    return AnimatedBuilder(
      animation: navSpread,
      builder: (context, child){
        return AnimatedContainer(
          duration: Duration(milliseconds: 300),
          transform: Matrix4.translation(
            vect.Vector3(
              (navSpread.value == true) ? -screenWidth/2 : 0,
              0,
              0,
            ),  
          ),
          child: DescribedFeatureOverlay(
            featureId: 'swol_logo',
            //target
            tapTarget: swolLogoSmall,
            targetColor: Theme.of(context).primaryColor,
            //background
            title: OnBoardingText(
              text: "What you're going to be"
              + "\nafter using this app",
              toLeft: true,
            ),
            textColor: Colors.white,
            description: OnBoardingImage(
              width: MediaQuery.of(context).size.width,
              multiplier: (2/3),
              imageUrl: "assets/biceps/topLeft.png",
            ),
            backgroundColor: Theme.of(context).primaryColorDark,
            //settings
            contentLocation: ContentLocation.below,
            overflowMode: OverflowMode.wrapBackground,
            enablePulsingAnimation: true,
            //child
            child: swolLogo,
          ),
        );
      },
    );
  }
}