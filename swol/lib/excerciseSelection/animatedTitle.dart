//dart
import 'package:vector_math/vector_math_64.dart' as vect;

//flutter
import 'package:flutter/material.dart';

//plugin
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:page_transition/page_transition.dart';

//internal
import 'package:swol/excerciseSelection/decoration.dart';
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
          child: button,
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
          child: new SwolLogo(
            height: statusBarHeight,
          ),
        );
      },
    );
  }
}