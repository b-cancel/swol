import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:swol/shared/structs/anExcercise.dart';
import 'package:swol/shared/widgets/complex/excerciseListTile/miniTimer/circles.dart';
import 'package:swol/shared/widgets/complex/excerciseListTile/miniTimer/invertedCircleClipper.dart';
import 'package:swol/shared/widgets/simple/triangleAngle.dart';

class ProgressCircle extends StatelessWidget {
  ProgressCircle({
    @required this.excercise,
    @required this.controller,
  });

  final AnExcercise excercise;
  final AnimationController controller;

  @override
  Widget build(BuildContext context) {
    /*
    //NOTE: largest possible circle size seems to be 62
    //56 feels good
    //48 feels better
    double circleSize = 48;
    double circleToTicksPadding = 3;
    double tickWidth = 4;
    double ticksToProgressCirclePadding = 4;

    //calculate stuff needed to build
    List<int> angles = new List<int>();
    for(int i = 0; i < 10 ; i++) angles.add(36 * i);
    angles.add(360);

    //NOTE: by now we already know the timer tempStartTime isn't null
    DateTime timerStarted = excercise.tempStartTime.value;
    Duration timePassed = DateTime.now().difference(timerStarted);

    

    double littleCircleSize = circleSize 
      - (circleToTicksPadding * 2) 
      - (tickWidth * 2) 
      - (ticksToProgressCirclePadding * 2);
      */

    Duration timePassed = DateTime.now().difference(excercise.tempStartTime.value);
    bool stillTimer = timePassed <= excercise.recoveryPeriod;

    return Positioned.fill(
      child: Padding(
        padding: EdgeInsets.all(9.5),
        //the outer rim of this circle 
        //will match the outer rim of the alarm clock's circle
        child: Stack(
          children: <Widget>[
            GrowingPieSlice(controller: controller, stillTimer: stillTimer),
            Visibility(
              visible: controller.value != 1,
              child: CircleTicks(),
            ),
            CircleRim(controller: controller),
          ],
        ),
        
        
        
        /*AnimatedCircleWidget(
          angles: angles, 
          ticks: ticks,
          //-----
          circleSize: circleSize,
          circleToTicksPadding: circleToTicksPadding,
          tickWidth: tickWidth,
          ticksToProgressCirclePadding: ticksToProgressCirclePadding,
          littleCircleSize: littleCircleSize,
          //-----
          recoveryPeriod: excercise.recoveryPeriod,
          tempStartTime: excercise.tempStartTime.value,
          after5Mintes: controller.value == 1,
          distanceFromLast5MinuteInternal: controller.value,
        ),
        */
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
      child: Container(
        child: FittedBox(
          fit: BoxFit.contain,
          child: ClipPath(
            clipper: InvertedCircleClipper(
              radiusPercent: 0.10,
            ),
            child: FittedBox(
              fit: BoxFit.contain,
              child: Container(
                color: Colors.yellow,
              )
              
              
              /*Stack(
                children: ticks,
              ),*/
            ),
          ),
        ),
      ),
    );
  }
}


/*

              //-----
              after5Mintes? Container() : 
              //-----
              Container(
                padding: EdgeInsets.all(
                  tickWidth,
                ),
                child: ClipOval(
                  child: Container(
                    padding: EdgeInsets.all(
                      ticksToProgressCirclePadding,
                    ),
                    child: ClipOval(
                      child: CircleProgress(
                        size: littleCircleSize,
                        fullRed: after5Mintes,
                        tempStartTime: tempStartTime,
                        recoveryPeriod: recoveryPeriod,
                      ),
                    ),
                  ),
                ),
              ),
              //-----
            ],
          ),
*/