//dart
import 'dart:math' as math;

//flutter
import 'package:flutter/material.dart';

//plugin
import 'package:loading_indicator/loading_indicator.dart';

//internal
import 'package:swol/shared/widgets/complex/excerciseListTile/miniTimer/shakingAlarm.dart';
import 'package:swol/shared/widgets/complex/excerciseListTile/miniTimer/timerButton.dart';
import 'package:swol/shared/widgets/complex/excerciseListTile/miniTimer/circles.dart';
import 'package:swol/shared/widgets/simple/triangleAngle.dart';
import 'package:swol/shared/structs/anExcercise.dart';

//widget
class WatchUI extends StatelessWidget {
  //NOTE: defaults is the mini version of the watch
  WatchUI({
    @required this.controller,
    @required this.excerciseReference,
  });

  final AnimationController controller;
  final AnExcercise excerciseReference;

  @override
  Widget build(BuildContext context) {
    //NOTE: by now we already know the timer tempStartTime isn't null
    DateTime timerStarted = excerciseReference.tempStartTime.value;
    Duration timePassed = DateTime.now().difference(timerStarted);
    bool noTimeLeft = timePassed > excerciseReference.recoveryPeriod;

    //sizes
    double total = 56;
    double circleSize = 48;
    
    String generatedTag = "timer" + excerciseReference.id.toString();
    print("----------from mini: " + generatedTag);

    //the box I think will be in the hero
    //so that the fitted box within it can grow the widget inside of it
    return Hero(
      tag: generatedTag,
      child: Container( 
        //color: Colors.black,
        child: FittedBox(
          fit: BoxFit.contain,
          child: Container(
            height: total,
            width: total,
            child: Stack(
              children: [
                VisibleVibration(
                  showVibrations: noTimeLeft,
                ),
                Centerer(),
                //-----timer stuff for timer
                WatchButtons(
                  isRight: true,
                ),
                //-----stopwatch stuff for stopwatch
                noTimeLeft ? WatchButtons(
                  isRight: false,
                ) : Container(),
                //-----Shaking alarm clock that shows up on top at the end
                ShakingAlarm(
                  //since this is applied on both sides
                  padding: (total - circleSize) / 2,
                ),
                
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Centerer extends StatelessWidget {
  const Centerer({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Center(
        child: Container(
          height: 15,
          width: 15,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}

class VisibleVibration extends StatelessWidget {
  const VisibleVibration({
    @required this.showVibrations,
    Key key,
  }) : super(key: key);

  final showVibrations;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Opacity(
        opacity: showVibrations ? 1 : 0,
        child: Transform.scale(
          //scales past its bounding box to call extra attention
          scale: 1.25,
          child: FittedBox(
            fit: BoxFit.fill,
            //it needs some kind of size to not break
            child: Container(
              height: 1,
              width: 1,
              child: LoadingIndicator(
                indicatorType: Indicator.ballScaleMultiple,
                color: Colors.red,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

//NOTE: largest possible circle size seems to be 62
//56 feels good
//48 feels better
/*
  this.circleSize: 48, 
    this.circleToTicksPadding: 3,
    this.tickWidth: 4,
    this.ticksToProgressCirclePadding: 4,
  final double circleSize;
  final double circleToTicksPadding;
  final double tickWidth;
  final double ticksToProgressCirclePadding;
  */

/*
  List<int> angles = new List<int>();
    for(int i = 0; i < 10 ; i++) angles.add(36 * i);
    angles.add(360);

    //NOTE: by now we already know the timer tempStartTime isn't null
    DateTime timerStarted = excerciseReference.tempStartTime.value;
    Duration timePassed = DateTime.now().difference(timerStarted);

    //72 degrees 1 minutes
    //36 degrees 30 seconds
    //18 degrees 15 seconds
    //9 degrees 7.5 seconds
    //4.5 degrees 3.75 seconds
    double halfTick = 9; 
    List<Widget> ticks = new List<Widget>();
    Widget tick = TriangleAngle(
      size: circleSize - circleToTicksPadding,
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

    double littleCircleSize = circleSize 
      - (circleToTicksPadding * 2) 
      - (tickWidth * 2) 
      - (ticksToProgressCirclePadding * 2);

    bool thereIsStillTime = timePassed <= excerciseReference.recoveryPeriod;
  */

  /*
  Positioned.fill(
                  child: Transform.translate(
                    offset: Offset(0, 2.25),
                    child: Padding(
                      padding: const EdgeInsets.all(6),
                      child: AnimatedCircleWidget(
                        angles: angles, 
                        ticks: ticks,
                        //-----
                        circleSize: circleSize,
                        circleToTicksPadding: circleToTicksPadding,
                        tickWidth: tickWidth,
                        ticksToProgressCirclePadding: ticksToProgressCirclePadding,
                        littleCircleSize: littleCircleSize,
                        //-----
                        recoveryPeriod: excerciseReference.recoveryPeriod,
                        tempStartTime: excerciseReference.tempStartTime.value,
                        after5Mintes: controller.value == 1,
                        distanceFromLast5MinuteInternal: controller.value,
                      ),
                    ),
                  ),
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
  */
