//dart
import 'dart:math' as math;

//flutter
import 'package:flutter/material.dart';

//plugin
import 'package:loading_indicator/loading_indicator.dart';

//internal
import 'package:swol/shared/widgets/complex/excerciseListTile/miniTimer/progress.dart';
import 'package:swol/shared/widgets/complex/excerciseListTile/miniTimer/shaking.dart';
import 'package:swol/shared/structs/anExcercise.dart';

//widget
class WatchUI extends StatelessWidget {
  //NOTE: defaults is the mini version of the watch
  WatchUI({
    @required this.controller,
    @required this.excercise,
    @required this.startTime,
  });

  final AnimationController controller;
  final AnExcercise excercise;
  final DateTime startTime;

  @override
  Widget build(BuildContext context) {
    //NOTE: by now we already know the timer startTime isn't null
    DateTime timerStarted = startTime;
    Duration timePassed = DateTime.now().difference(timerStarted);
    bool noTimeLeft = timePassed > excercise.recoveryPeriod;

    //sizes
    double size = 56;
    
    String generatedTag = "timer" + excercise.id.toString();

    //the box I think will be in the hero
    //so that the fitted box within it can grow the widget inside of it
    return Hero(
      tag: generatedTag,
      child: Container( 
        //color: Colors.black,
        child: FittedBox(
          fit: BoxFit.contain,
          child: Container(
            height: size,
            width: size,
            child: Stack(
              children: [
                Visibility(
                  visible: noTimeLeft,
                  child: VisibleVibration(),
                ),
                //-----timer stuff for timer
                Visibility(
                  visible: controller.value != 1,
                  child: WatchButtons(
                    isRight: true,
                  ),
                ),
                //-----stopwatch stuff for stopwatch
                Visibility(
                  visible: noTimeLeft && controller.value != 1,
                  child: WatchButtons(
                    isRight: false,
                  ),
                ),
                //-----shaking thingymajig for both
                TimerShaker(
                  controller: controller, 
                  noTimeLeft: noTimeLeft,
                ),
                //-----circle that show progress
                ProgressCircle( 
                  excercise: excercise,
                  controller: controller,
                  startTime: startTime,
                ),
                //-----Shaking alarm clock that shows up on top at the end
                Visibility(
                  visible: controller.value == 1,
                  child: ShakingAlarm(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class VisibleVibration extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
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
    );
  }
}

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
          top: 10,
          right: isRight ? 8 : 0,
          left: isRight ? 0 : 8,
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