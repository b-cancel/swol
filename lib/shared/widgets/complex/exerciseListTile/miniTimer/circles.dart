//flutter
import 'package:flutter/material.dart';

//internal
import 'package:swol/shared/widgets/simple/triangleAngle.dart';
import 'package:swol/other/otherHelper.dart';

//widget
class CircleProgress extends StatelessWidget {
  CircleProgress({
    required this.fullRed,
    required this.startTime,
    required this.recoveryPeriod,
  });

  final bool fullRed;
  final DateTime startTime;
  final Duration recoveryPeriod;

  @override
  Widget build(BuildContext context) {
    if (fullRed) {
      return Container(
        width: 1,
        height: 1,
        color: Colors.red,
      );
    } else {
      //time calcs
      DateTime timerStarted = startTime;
      Duration timePassed = DateTime.now().difference(timerStarted);

      //set basic variables
      bool thereIsStillTime = timePassed <= recoveryPeriod;
      double timeSetAngle = (timeToLerpValue(recoveryPeriod)).clamp(0.0, 1.0);
      double timePassedAngle = (timeToLerpValue(timePassed)).clamp(0.0, 1.0);

      //create angles
      double firstAngle =
          (thereIsStillTime ? timePassedAngle : timeSetAngle) * 360;
      double secondAngle =
          (thereIsStillTime ? timeSetAngle : timePassedAngle) * 360;

      //output
      return Container(
        width: 1,
        height: 1,
        child: Stack(
          children: <Widget>[
            TriangleAngle(
              start: 0,
              end: firstAngle,
              color: Colors.white,
              size: 1,
            ),
            TriangleAngle(
              start: firstAngle,
              end: secondAngle,
              color:
                  thereIsStillTime ? Theme.of(context).accentColor : Colors.red,
              size: 1,
            ),
          ],
        ),
      );
    }
  }
}
