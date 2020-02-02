//taken from https://roszkowski.dev/2019/custom-hero-curve/

import 'package:flutter/material.dart';

class CustomRectTween extends RectTween {
  CustomRectTween({
    this.a, 
    this.b,
  }) : super(begin: a, end: b);
  final Rect a;
  final Rect b;

  //todo modify if really needed
  @override
  Rect lerp(double t) {
    return Rect.fromLTRB(
      lerpDouble(a.left, b.left, t),
      lerpDouble(a.top, b.top, t),
      lerpDouble(a.right, b.right, t),
      lerpDouble(a.bottom, b.bottom, t),
    );
  }

  double lerpDouble(num a, num b, double t) {
    if (a == null && b == null) return null;
    a ??= 0.0;
    b ??= 0.0;
    return a + (b - a) * t;
  }
}