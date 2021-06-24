//from: https://stackoverflow.com/questions/49374893/flutter-inverted-clipoval/49396544
import 'package:flutter/material.dart';

class InvertedCircleClipper extends CustomClipper<Path> {
  InvertedCircleClipper({
    this.radiusPercent: 0.25,
  });

  final double radiusPercent;

  @override
  Path getClip(Size size) {
    return new Path()
      ..addOval(new Rect.fromCircle(
          center: new Offset(size.width / 2, size.height / 2),
          radius: size.width * radiusPercent))
      ..addRect(new Rect.fromLTWH(0.0, 0.0, size.width, size.height))
      ..fillType = PathFillType.evenOdd;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}