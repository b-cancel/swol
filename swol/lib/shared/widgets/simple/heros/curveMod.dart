//taken from https://roszkowski.dev/2019/custom-hero-curve/

import 'package:flutter/material.dart';

class CustomRectTween extends RectTween {
  CustomRectTween({
    this.a, 
    this.b,
  }) : super(begin: a, end: b);
  final Rect a;
  final Rect b;

  @override
  Rect lerp(double t) {
    final verticalDist = Curves.easeInOut.transform(t);
    //final top = lerpDouble(a.top, b.top, t) * (1 - verticalDist);
    print("a: " + a.left.toString() + " vs " + "b: " + b.left.toString());
    bool aBelowB = a.left < b.left;
    return Rect.fromLTRB(
      //worked well here (a: 72.0 vs b: 349.42857142857144)
      lerpDouble(a.left, b.left, t),// * ((aBelowB) ? verticalDist : 1),
      lerpDouble(a.top, b.top, t),// * (1 - verticalDist),
      lerpDouble(a.right, b.right, t),
      lerpDouble(a.bottom, b.bottom, t),// * (1 - verticalDist),
    );
  }

  double lerpDouble(num a, num b, double t) {
    if (a == null && b == null) return null;
    a ??= 0.0;
    b ??= 0.0;
    return a + (b - a) * t;
  }
}