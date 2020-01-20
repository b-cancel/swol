//dart 
import 'dart:math' as math;

//flutter
import 'package:flutter/material.dart';

//the watch buttons that show very clearly what state our watch is in
//1 button means stopwatch
//2 buttons means timer
class WatchButtons extends StatelessWidget {
  WatchButtons({
    this.isRight: true,
  });

  final bool isRight;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      right: isRight ? 0 : null,
      left: isRight ? null : 0,
      child: Padding(
        padding: EdgeInsets.only(
          top: 9,
          right: isRight ? 5 : 0,
          left: isRight ? 0 : 5,
        ),
        child: Transform.rotate(
          angle: (- math.pi / 4) * (isRight ? 1 : -1),
          child: Container(
            color: Colors.white,
            height: 6,
            width: 4,
            child: Container(),
          ),
        ),
      ),
    );
  }
}