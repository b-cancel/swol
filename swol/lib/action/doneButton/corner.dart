

import 'package:flutter/material.dart';

class DoneCorner extends StatelessWidget {
  DoneCorner({
    @required this.show,
    @required this.color,
    //stay the same throughout
    @required this.animationCurve,
    @required this.showOrHideDuration,
    @required this.isTop,
  });

  final bool show;
  final Color color;
  //stay the same throughout
  final Curve animationCurve;
  final Duration showOrHideDuration;
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
        duration: showOrHideDuration,
        //this is what primarily animates
        transform: newTransform,
        height: size,
        width: size,
        child: FittedBox(
          fit: BoxFit.contain,
          child: ClipPath(
            clipper: CornerClipper(
              top: isTop,
            ),
            child: AnimatedContainer(
              curve: animationCurve,
              duration: showOrHideDuration,
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

//modification of inverted circle clipper taken from somewhere on the internet
class CornerClipper extends CustomClipper<Path> {
  CornerClipper({
    @required this.top,
    this.left: true,
  });

  final bool top;
  final bool left;
  
  @override
  Path getClip(Size size) {
    return new Path()
      ..addOval(new Rect.fromCircle(
          center: new Offset((left ? size.width : 0), (top ? 0 : size.height)),
          radius: size.width * 1))
      ..addRect(new Rect.fromLTWH(0.0, 0.0, size.width, size.height))
      ..fillType = PathFillType.evenOdd;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}