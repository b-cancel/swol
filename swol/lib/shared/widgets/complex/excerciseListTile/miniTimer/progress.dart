//dart
import 'dart:math' as math;

//flutter
import 'package:flutter/material.dart';

//internal
import 'package:swol/shared/widgets/complex/excerciseListTile/miniTimer/invertedCircleClipper.dart';
import 'package:swol/shared/widgets/complex/excerciseListTile/miniTimer/circles.dart';
import 'package:swol/shared/widgets/simple/triangleAngle.dart';
import 'package:swol/shared/structs/anExcercise.dart';

//shared
class ProgressCircle extends StatelessWidget {
  ProgressCircle({
    @required this.excercise,
    @required this.startTime,
    @required this.controller,
  });

  final AnExcercise excercise;
  final DateTime startTime;
  final AnimationController controller;

  @override
  Widget build(BuildContext context) {
    Duration timePassed = DateTime.now().difference(startTime);
    bool stillTimer = timePassed <= excercise.recoveryPeriod;

    return Positioned.fill(
      child: Padding(
        padding: EdgeInsets.all(9.5),
        //the outer rim of this circle 
        //will match the outer rim of the alarm clock's circle
        child: Stack(
          children: <Widget>[
            //background that hides the waves until the end
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: controller.value == 1 ? Colors.transparent : Theme.of(context).primaryColorDark,
                ),
              )
            ),
            //pie slice that show exactly how much time has passed
            GrowingPieSlice(
              controller: controller, 
              stillTimer: stillTimer,
            ),
            //pie slices that show time passed and time selected
            Positioned.fill(
              child: Padding(
                padding: EdgeInsets.all(10),
                child: ClipOval(
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: CircleProgress(
                      fullRed: controller.value == 1,
                      startTime: startTime,
                      recoveryPeriod: excercise.recoveryPeriod,
                    ),
                  ),
                ),
              ),
            ),
            //the ticks on the watch
            Visibility(
              visible: controller.value != 1,
              child: CircleTicks(),
            ),  
            //the rim of the circle          
            CircleRim(controller: controller),
          ],
        ),
      ),
    );
  }
}

class GrowingPieSlice extends StatelessWidget {
  const GrowingPieSlice({
    Key key,
    @required this.controller,
    @required this.stillTimer,
  }) : super(key: key);

  final AnimationController controller;
  final bool stillTimer;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: FittedBox(
        fit: BoxFit.contain,
        child: ClipOval(
          child: Container(
            width: 1,
            height: 1,
            child: TriangleAngle(
              start: 0,
              end: controller.value * 360,
              size: 1,
              color: stillTimer ? Color.fromRGBO(128, 128, 128, 1) : Colors.red,
            ),
          ),
        ),
      ),
    );
  }
}

class CircleRim extends StatelessWidget {
  const CircleRim({
    Key key,
    @required this.controller,
  }) : super(key: key);

  final AnimationController controller;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: ClipPath(
        clipper: InvertedCircleClipper(
          radiusPercent: 0.43,
        ),
        child: FittedBox(
          fit: BoxFit.contain,
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: controller.value == 1 ? Colors.red : Colors.white,
            ),
            height: 1,
            width: 1,
          ),
        ),
      ),
    );
  }
}

class CircleTicks extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //72 degrees 1 minutes
    //36 degrees 30 seconds
    //18 degrees 15 seconds
    //9 degrees 7.5 seconds
    //4.5 degrees 3.75 seconds

    //create the original tick
    double halfTickWidth = 9; 
    Widget tick = TriangleAngle(
      size: 1,
      start: 360.0 - halfTickWidth,
      end: halfTickWidth,
      color: Colors.white,
    );

    //create all the ticks by rotating the original
    List<Widget> ticks = new List<Widget>();
    for(int i = 0; i < 5; i++){
      ticks.add(
        Positioned.fill(
          child: FittedBox(
            fit: BoxFit.contain,
            child: Transform.rotate(
              angle: (math.pi / 2.5) * i, //72.0 * i,
              child: Container(
                height: 1,
                width: 1,
                child: FittedBox(
                  fit: BoxFit.contain,
                  child: tick,
                ),
              ),
            ),
          ),
        ),
      );
    }

    //compile the ticks
    return Positioned.fill(
      child: ClipPath(
        clipper: InvertedCircleClipper(
          radiusPercent: 0.35,
        ),
        child: FittedBox(
          fit: BoxFit.contain,
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
            ),
            height: 1,
            width: 1,
            child: Stack(
              children: ticks,
            ),
          ),
        ),
      ),
    );
  }
}