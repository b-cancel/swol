import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'dart:math' as math;
import 'package:swol/excercise/excerciseStructure.dart';
import 'package:swol/sharedWidgets/excerciseListTile/miniTimer.dart';
import 'package:swol/sharedWidgets/excerciseListTile/triangleAngle.dart';

//TODO: add the little animated alarm clock to this widget and then also change the timer to match the alarm clock
//TODO: also start with a timer, then move onto a stopwatch (animate the little stick in)
//TODO: the whole thing stays WHITE as long as the alarm clock isnt ringing

class AnimatedMiniNormalTimer extends StatefulWidget {
  AnimatedMiniNormalTimer({
    @required this.excerciseReference,
    //NOTE: largest possible size seems to be 62
    //56 feels good
    //48 feels better
    this.circleSize: 48, 
    this.circleToTicksPadding: 3,
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

    //62 is max size
    return Stack(
      children: <Widget>[
        Positioned.fill(
          child: Stack(
            children: <Widget>[
              Positioned.fill(
                child: Transform.translate(
                  offset: Offset(0, 2.25),
                  child: Padding(
                    padding: const EdgeInsets.all(6),
                    child: AnimatedCircleWidget(
                      angles: angles, 
                      ticks: ticks,  
                      controller: controller, 
                      excerciseReference: widget.excerciseReference,
                      //-----
                      circleSize: widget.circleSize,
                      circleToTicksPadding: widget.circleToTicksPadding,
                      tickWidth: widget.tickWidth,
                      ticksToProgressCirclePadding: widget.ticksToProgressCirclePadding,
                      littleCircleSize: littleCircleSize,
                    ),
                  ),
                ),
              ),
              //-----timer stuff for timer
              //TODO: add this
              //-----stopwatch stuff for stopwatch
              //TODO: add this
            ],
          ),
        ),
        Opacity(
          opacity: controller.value == 1 ? 1.0 : 0.0,
          child: ShakingAlarm(maxSize: 54),
        ),
      ],
    );
  }
}

class AnimatedCircleWidget extends StatelessWidget {
  const AnimatedCircleWidget({
    Key key,
    @required this.angles,
    @required this.ticks,
    @required this.controller,
    @required this.excerciseReference,
    //-----
    @required this.circleSize,
    @required this.circleToTicksPadding,
    @required this.tickWidth,
    @required this.ticksToProgressCirclePadding,
    @required this.littleCircleSize,
  }) : super(key: key);

  final List<int> angles;
  final List<Widget> ticks;
  final AnimationController controller;
  final AnExcercise excerciseReference;
  //-----
  final double circleSize;
  final double circleToTicksPadding;
  final double tickWidth;
  final double ticksToProgressCirclePadding;
  final double littleCircleSize;

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Container(
        width: circleSize,
        height: circleSize,
        color: controller.value == 1 ? Colors.red : Colors.white, //TODO: decide rim color
        padding: EdgeInsets.all(
          circleToTicksPadding,
        ),
        child: ClipOval(
          child: Stack(
            children: <Widget>[
              Container(
                color: Theme.of(context).primaryColorDark,
                child: Container(),
              ),
              HighlightSlice(
                excerciseReference: excerciseReference,
                size: circleSize - circleToTicksPadding,
                angles: angles,
                controllerValue: controller.value
              ),
              Stack(
                children: ticks,
              ),
              Container(
                padding: EdgeInsets.all(
                  tickWidth,
                ),
                //TODO: replace this illusion of a inverted ClipOval
                //TODO: for an actual invertedClipOval so I can configured the background as I please
                child: ClipOval(
                  child: Container(
                    color: Theme.of(context).primaryColorDark,
                    padding: EdgeInsets.all(
                      ticksToProgressCirclePadding,
                    ),
                    child: ClipOval(
                      child: CircleProgress(
                        excerciseReference: excerciseReference,
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

class ShakingAlarm extends StatelessWidget {
  const ShakingAlarm({
    Key key,
    @required this.maxSize,
  }) : super(key: key);

  final double maxSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: maxSize,
      width: maxSize,
      child: Stack(
        children: <Widget>[
          Positioned.fill(
            child: Transform.translate(
              offset: Offset(0, 1.5),
              child: Container(
                height: maxSize,
                width: maxSize,
                child: LoadingIndicator(
                  indicatorType: Indicator.ballScaleMultiple, 
                  color: Colors.red,
                  //Color.fromRGBO(128,128,128,1),
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: new ClipPath(
              clipper: new InvertedCircleClipper(),
              child: Image(
                image: new AssetImage("assets/alarm.gif"),
                //lines being slightly distinguishable is ugly
                color: Colors.red,
              ),
            ),
          ),
          /*
          Positioned.fill(
            child: Center(
              child: Icon(
                FontAwesomeIcons.times,
                color: Colors.red,
              )
            ),
          ),
          */
        ],
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