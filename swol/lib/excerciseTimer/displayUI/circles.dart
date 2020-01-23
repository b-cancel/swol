//flutter
import 'package:flutter/material.dart';

//internal
import 'package:swol/excerciseTimer/displayUI/shakingAlarm.dart';
import 'package:swol/sharedWidgets/triangleAngle.dart';
import 'package:swol/shared/structs/anExcercise.dart';
import 'package:swol/other/otherHelper.dart';

//widget
class AnimatedCircleWidget extends StatelessWidget {
  const AnimatedCircleWidget({
    Key key,
    @required this.angles,
    @required this.ticks,
    //-----
    @required this.circleSize,
    @required this.circleToTicksPadding,
    @required this.tickWidth,
    @required this.ticksToProgressCirclePadding,
    @required this.littleCircleSize,
    //-----
    @required this.after5Mintes, //controller.value == 1
    //between 0 and 1
    @required this.distanceFromLast5MinuteInternal, //controller.value
    @required this.tempStartTime,
    @required this.recoveryPeriod,
  }) : super(key: key);

  final List<int> angles;
  final List<Widget> ticks;
  //-----
  final double circleSize;
  final double circleToTicksPadding;
  final double tickWidth;
  final double ticksToProgressCirclePadding;
  final double littleCircleSize;
  //-----
  final bool after5Mintes;
  final double distanceFromLast5MinuteInternal;
  final DateTime tempStartTime;
  final Duration recoveryPeriod;

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = after5Mintes ? Theme.of(context).cardColor : Theme.of(context).primaryColorDark;
    DateTime timerStarted = tempStartTime;
    Duration timePassed = DateTime.now().difference(timerStarted);
    bool thereIsStillTime = timePassed <= recoveryPeriod;

    //build
    return ClipOval(
      child: Container(
        width: circleSize,
        height: circleSize,
        color: after5Mintes ? Colors.red : Colors.white,
        padding: EdgeInsets.all(
          circleToTicksPadding,
        ),
        child: ClipOval(
          child: Stack(
            children: <Widget>[
              Container(
                color: backgroundColor,
                child: Container(),
              ),
              //-----
              Center(
                child: ClipOval(
                  child: Container(
                    width: circleSize,
                    height: circleSize,
                    child: TriangleAngle(
                      start: 0,
                      end: distanceFromLast5MinuteInternal * 360,
                      size: circleSize,
                      //thereIsStillTime ? Theme.of(context).accentColor : Colors.red,
                      color: thereIsStillTime ? Color.fromRGBO(128, 128, 128, 1) : Colors.red,
                      //Colors.green, //Color.fromRGBO(128, 128, 128, 1),
                    ),
                  ),
                ),
              ),
              //-----
              after5Mintes? Container() : ClipPath(
                clipper: InvertedCircleClipper(
                  radiusPercent: 0.40,
                ),
                child: Stack(
                  children: ticks,
                ),
              ),
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
        )
      ),
    );
  }
}

class HighlightSlice extends StatelessWidget {
  HighlightSlice({
    @required this.excerciseReference,
    @required this.size,
    @required this.angles,
    @required this.controllerValue,
  });

  final AnExcercise excerciseReference;
  final double size;
  final List<int> angles;
  final double controllerValue;

  @override
  Widget build(BuildContext context) {
    if(controllerValue == 1) return Container();
    else{
      double sub = (36/4*3);
      double angle = controllerValue * 360;
      double start;
      double end;
      //0,45,90
      for(int i = 0; i < angles.length; i++){
        double thisAngle = angles[i].toDouble();
        if(thisAngle > angle){ //false, even, etc...
          bool isEven = (i%2 == 0);
          start = angles[i-1].toDouble() + (isEven ? sub : 0);
          end = angles[i].toDouble() - (isEven == false ? sub : 0);
          break;
        }
      }

      return Center(
        child: ClipOval(
          child: Container(
            width: size,
            height: size,
            child: TriangleAngle(
              start: start,
              end: end,
              size: size,
              //thereIsStillTime ? Theme.of(context).accentColor : Colors.red,
              color: Theme.of(context).primaryColorDark,
            ),
          ),
        ),
      );
    }
  }
}

class CircleProgress extends StatelessWidget {
  CircleProgress({
    @required this.size,
    @required this.fullRed,
    @required this.tempStartTime,
    @required this.recoveryPeriod,
  });

  final double size;
  final bool fullRed;
  final DateTime tempStartTime;
  final Duration recoveryPeriod;

  @override
  Widget build(BuildContext context) {
    if(fullRed){
      return Container(
        width: size,
        height: size,
        color: Colors.red,
      );
    }
    else{
      //time calcs
      DateTime timerStarted = tempStartTime;
      Duration timePassed = DateTime.now().difference(timerStarted);

      //set basic variables
      bool thereIsStillTime = timePassed <= recoveryPeriod;
      double timeSetAngle = (timeToLerpValue(recoveryPeriod)).clamp(0.0, 1.0);
      double timePassedAngle = (timeToLerpValue(timePassed)).clamp(0.0, 1.0);

      //create angles
      double firstAngle = (thereIsStillTime ? timePassedAngle : timeSetAngle) * 360;
      double secondAngle = (thereIsStillTime ? timeSetAngle : timePassedAngle) * 360;

      //output
      return Container(
        width: size,
        height: size,
        child: Stack(
          children: <Widget>[
            TriangleAngle(
              start: 0,
              end: firstAngle,
              color: Colors.white,
              size: size,
            ),
            TriangleAngle(
              start: firstAngle,
              end: secondAngle,
              color: thereIsStillTime ? Theme.of(context).accentColor : Colors.red,
              size: size,
            ),
          ],
        ),
      );
    }
  }
}