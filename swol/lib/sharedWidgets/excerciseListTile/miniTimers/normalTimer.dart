import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:swol/excercise/excerciseStructure.dart';
import 'package:swol/sharedWidgets/excerciseListTile/miniTimer.dart';
import 'package:swol/sharedWidgets/excerciseListTile/triangleAngle.dart';

class AnimatedMiniNormalTimer extends StatefulWidget {
  AnimatedMiniNormalTimer({
    @required this.excerciseReference,
    //NOTE: largest possible size seems to be 62
    //56 feels good
    //48 feels better
    this.circleSize: 48, 
    this.circleToTicksPadding: 4,
    this.tickWidth: 4,
    this.ticksToProgressCirclePadding: 4,
  });

  final AnExcercise excerciseReference;
  final double circleSize;
  final double circleToTicksPadding;
  final double tickWidth;
  final double ticksToProgressCirclePadding;

  @override
  _AnimatedMiniNormalTimerState createState() => _AnimatedMiniNormalTimerState();
}

class _AnimatedMiniNormalTimerState extends State<AnimatedMiniNormalTimer> with SingleTickerProviderStateMixin{
  final Duration maxDuration = const Duration(minutes: 5);
  AnimationController controller; 

  //function removable from listeners
  updateState(){
    if(mounted) setState(() {});
  }
  updateStateAnim(AnimationStatus status) => updateState();

  //init
  @override
  void initState() {
    //create the controller
    controller = AnimationController(
      vsync: this,
      duration: maxDuration,
    );

    //set the value based on how far we arein
    DateTime timerStarted = widget.excerciseReference.tempStartTime;
    Duration timePassed = DateTime.now().difference(timerStarted);

    //add listeners
    controller.addListener(updateState);
    controller.addStatusListener(updateStateAnim);

    //start animation
    controller.forward(
      from: ExcerciseTileLeading.timeToLerpValue(timePassed),
    );

    //super init
    super.initState();
  }

  //dispose
  @override
  void dispose() {
    //remove the UI updater
    controller.removeListener(updateState);
    controller.removeStatusListener(updateStateAnim);
    controller.dispose();

    //super dispose
    super.dispose();
  }

  //build
  @override
  Widget build(BuildContext context) {
    //generate all start angles of slices
    List<int> angles = new List<int>();
    for(int i = 0; i < 10 ; i++) angles.add(36 * i);
    angles.add(360);

    DateTime timerStarted = widget.excerciseReference.tempStartTime;
    Duration timePassed = DateTime.now().difference(timerStarted);
    bool borderRed = timePassed > widget.excerciseReference.recoveryPeriod;

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
      color: borderRed ? Colors.red : Colors.white,
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

    //display slices
    return ClipOval(
      child: Container(
        width: widget.circleSize,
        height: widget.circleSize,
        color: controller.value == 1 ? Colors.red : Colors.white, //TODO: decide rim color
        padding: EdgeInsets.all(
          widget.circleToTicksPadding,
        ),
        child: ClipOval(
          child: Stack(
            children: <Widget>[
              Container(
                color: Theme.of(context).primaryColorDark,
                child: Container(),
              ),
              HighlightSlice(
                excerciseReference: widget.excerciseReference,
                size: widget.circleSize - widget.circleToTicksPadding,
                angles: angles,
                controllerValue: controller.value
              ),
              Stack(
                children: ticks,
              ),
              Container(
                padding: EdgeInsets.all(
                  widget.tickWidth,
                ),
                //TODO: replace this illusion of a inverted ClipOval
                //TODO: for an actual invertedClipOval so I can configured the background as I please
                child: ClipOval(
                  child: Container(
                    color: Theme.of(context).primaryColorDark,
                    padding: EdgeInsets.all(
                      widget.ticksToProgressCirclePadding,
                    ),
                    child: ClipOval(
                      child: CircleProgress(
                        excerciseReference: widget.excerciseReference,
                        size: littleCircleSize,
                        fullRed: controller.value == 1,
                      ),
                    ),
                  ),
                ),
              ),
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
      double angle = controllerValue * 360;
      double start;
      double end;
      //0,45,90
      for(int i = 0; i < angles.length; i++){
        double thisAngle = angles[i].toDouble();
        if(thisAngle > angle){
          start = angles[i-1].toDouble();
          end = angles[i].toDouble();
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
              color: Color.fromRGBO(128, 128, 128, 1),
            ),
          ),
        ),
      );
    }
  }
}

class CircleProgress extends StatelessWidget {
  CircleProgress({
    @required this.excerciseReference,
    @required this.size,
    @required this.fullRed,
  });

  final AnExcercise excerciseReference;
  final double size;
  final bool fullRed;

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
      DateTime timerStarted = excerciseReference.tempStartTime;
      Duration timePassed = DateTime.now().difference(timerStarted);

      //set basic variables
      bool thereIsStillTime = timePassed <= excerciseReference.recoveryPeriod;
      double timeSetAngle = (ExcerciseTileLeading.timeToLerpValue(excerciseReference.recoveryPeriod)).clamp(0.0, 1.0);
      double timePassedAngle = (ExcerciseTileLeading.timeToLerpValue(timePassed)).clamp(0.0, 1.0);
      Color flatGrey = Color.fromRGBO(128,128,128,1);

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
              color: flatGrey,
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