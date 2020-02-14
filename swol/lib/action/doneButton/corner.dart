

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
    return Container(
      height: 24,
      width: 24,
      alignment: isTop ? Alignment.bottomLeft : Alignment.topLeft,
      child: AnimatedContainer(
        curve: animationCurve,
        duration: (showOrHideDuration * (0.5)),
        height: size,
        width: size,
        child: FittedBox(
          fit: BoxFit.contain,
          child: ClipPath(
            clipper: CornerClipper(
              top: isTop,
            ),
            child: Container(
              height: 1,
              width: 1,
              decoration: new BoxDecoration(
                color: color,
              ),
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
  });

  final bool top;
  
  @override
  Path getClip(Size size) {
    return new Path()
      ..addOval(new Rect.fromCircle(
          center: new Offset(size.width, (top ? 0 : size.height)),
          radius: size.width * 1))
      ..addRect(new Rect.fromLTWH(0.0, 0.0, size.width, size.height))
      ..fillType = PathFillType.evenOdd;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}