//flutter
import 'package:flutter/material.dart';
import 'package:swol/action/page.dart';

//internal
import 'package:swol/shared/widgets/simple/curvedCorner.dart';

//widget
class DoneCorner extends StatelessWidget {
  DoneCorner({
    required this.show,
    required this.color,
    //stay the same throughout
    required this.animationCurve,
    required this.isTop,
  });

  final bool show;
  final Color color;
  //stay the same throughout
  final Curve animationCurve;
  final bool isTop;

  @override
  Widget build(BuildContext context) {
    double size = show ? 24 : 0;
    //just enough to show both animations
    //without the weird spikes
    double portionOfScreen = 12;
    double xOffset = show ? 0 : -portionOfScreen;
    Matrix4 newTransform = Matrix4.translationValues(
      xOffset,
      0,
      0,
    );

    return Container(
      height: 24,
      width: 24,
      alignment: isTop ? Alignment.bottomLeft : Alignment.topLeft,
      child: AnimatedContainer(
        curve: animationCurve,
        duration: ExercisePage.transitionDuration,
        //this is what primarily animates
        transform: newTransform,
        height: size,
        width: size,
        child: FittedBox(
          fit: BoxFit.contain,
          child: ClipPath(
            clipper: CornerClipper(
              isTop: isTop == false,
            ),
            child: AnimatedContainer(
              curve: animationCurve,
              duration: ExercisePage.transitionDuration,
              //color switch to match button
              decoration: new BoxDecoration(
                color: color,
              ),
              //this is what primarily animates
              height: 1,
              width: 1,
            ),
          ),
        ),
      ),
    );
  }
}
