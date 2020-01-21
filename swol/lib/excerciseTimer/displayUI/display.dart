import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:swol/excerciseTimer/displayUI/shakingAlarm.dart';
import 'dart:math' as math;

import 'package:swol/sharedWidgets/triangleAngle.dart';

class WatchUI extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 56,
      height: 56,
      color: Colors.pink,
    );
    /*
    List<int> angles = new List<int>();
    for(int i = 0; i < 10 ; i++) angles.add(36 * i);
    angles.add(360);

    DateTime timerStarted = widget.excerciseReference.tempStartTime;
    Duration timePassed = DateTime.now().difference(timerStarted);

    //72 degrees 1 minutes
    //36 degrees 30 seconds
    //18 degrees 15 seconds
    //9 degrees 7.5 seconds
    //4.5 degrees 3.75 seconds
    double halfTick = 9; 
    List<Widget> ticks = new List<Widget>();
    Widget tick = TriangleAngle(
      size: widget.circleSize - widget.circleToTicksPadding,
      start: 360.0 - halfTick,
      end: halfTick,
      color: controller.value == 1 ? Colors.red : Colors.white,
    );

    for(int i = 0; i < 5; i++){
      ticks.add(
        Transform.rotate(
          angle: (math.pi / 2.5) * i, //72.0 * i,
          child: tick,
        ),
      );
    }

    double littleCircleSize = widget.circleSize 
      - (widget.circleToTicksPadding * 2) 
      - (widget.tickWidth * 2) 
      - (widget.ticksToProgressCirclePadding * 2);

    bool thereIsStillTime = timePassed <= widget.excerciseReference.recoveryPeriod;

    //62 is max size
    return Stack(
      children: <Widget>[
        Positioned.fill(
          child: Stack(
            children: <Widget>[
              thereIsStillTime ? Container() : Positioned.fill(
                child: Transform.translate(
                  offset: Offset(0, 1.5),
                  child: Container(
                    child: FittedBox(
                      fit: BoxFit.fill,
                      child: Transform.scale(
                        scale: 1.3,
                        child: Container(
                          height: 50,
                          width: 50,
                          child: LoadingIndicator(
                            indicatorType: Indicator.ballScaleMultiple, 
                            color: Colors.red,
                            //Color.fromRGBO(128,128,128,1),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned.fill(
                child: Transform.translate(
                  offset: Offset(0, 2.25),
                  child: Padding(
                    padding: const EdgeInsets.all(6),
                    child: AnimatedCircleWidget(
                      angles: angles, 
                      ticks: ticks,
                      //-----
                      circleSize: widget.circleSize,
                      circleToTicksPadding: widget.circleToTicksPadding,
                      tickWidth: widget.tickWidth,
                      ticksToProgressCirclePadding: widget.ticksToProgressCirclePadding,
                      littleCircleSize: littleCircleSize,
                      //-----
                      recoveryPeriod: widget.excerciseReference.recoveryPeriod,
                      tempStartTime: widget.excerciseReference.tempStartTime,
                      after5Mintes: controller.value == 1,
                      distanceFromLast5MinuteInternal: controller.value,
                    ),
                  ),
                ),
              ),
              //-----timer stuff for timer
              TimerButton(
                isRight: true,
              ),
              //-----stopwatch stuff for stopwatch
              thereIsStillTime ? Container() : TimerButton(
                isRight: false,
              ),
              //-----shaking thingymajig for both
              Positioned.fill(
                child: Opacity(
                  opacity: controller.value == 1 ? 0.0 : 1.0,
                  child: Transform.translate(
                    offset: Offset(0, -4),
                    child: Container(
                      alignment: Alignment.topCenter,
                      child: Container(
                        width: 14,
                        child: FittedBox(
                          fit: BoxFit.fitWidth,
                          child: Container(
                            //NOTE: width and height are placeholders to avoid an error
                            width: 50,
                            height: 50,
                            child: thereIsStillTime
                            ? Image(
                              image: new AssetImage("assets/tickStill.png"),
                              color: Colors.white,
                            )
                            : Image(
                              image: new AssetImage("assets/alarmTick.gif"),
                              color: Colors.white,
                            ),
                          )
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Opacity(
          opacity: controller.value == 1 ? 1.0 : 0.0,
          child: ShakingAlarm(maxSize: 54),
        ),
      ],
    );
    */
  }
}