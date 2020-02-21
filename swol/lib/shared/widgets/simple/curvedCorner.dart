//modification of inverted circle clipper taken from somewhere on the internet
import 'package:flutter/material.dart';

//build
class CurvedCorner extends StatelessWidget {
  CurvedCorner({
    @required this.isTop,
    @required this.isLeft,
    this.backgroundColor,
    @required this.cornerColor,
    this.size: 24,
  });

  final bool isTop;
  final bool isLeft;
  final Color backgroundColor;
  final Color cornerColor;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor ?? Colors.transparent,
      height: size,
      width: size,
      child: FittedBox(
        fit: BoxFit.contain,
        child: ClipPath(
          clipper: CornerClipper(
            top: isTop,
            left: isLeft,
          ),
          child: Container(
            color: cornerColor,
            height: 1,
            width: 1,
          ),
        ),
      ),
    );
  }
}

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