import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'dart:math' as math;
import 'package:swol/excercise/excerciseStructure.dart';
import 'package:swol/sharedWidgets/excerciseListTile/miniTimer.dart';
import 'package:swol/sharedWidgets/excerciseListTile/triangleAngle.dart';

//96 close but still too dark
int greyValue = 128;

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
  }
}

class TimerButton extends StatelessWidget {
  TimerButton({
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
    Color backgroundColor = controller.value == 1 ? Theme.of(context).cardColor : Theme.of(context).primaryColorDark;
    DateTime timerStarted = excerciseReference.tempStartTime;
    Duration timePassed = DateTime.now().difference(timerStarted);
    bool thereIsStillTime = timePassed <= excerciseReference.recoveryPeriod;

    //build
    return ClipOval(
      child: Container(
        width: circleSize,
        height: circleSize,
        color: controller.value == 1 ? Colors.red : Colors.white,
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
                      end: controller.value * 360,
                      size: circleSize,
                      //thereIsStillTime ? Theme.of(context).accentColor : Colors.red,
                      color: thereIsStillTime ? Color.fromRGBO(greyValue, greyValue, greyValue, 1) : Colors.red,
                      //Colors.green, //Color.fromRGBO(128, 128, 128, 1),
                    ),
                  ),
                ),
              ),
              //-----
              (controller.value == 1) ? Container() : ClipPath(
                clipper: new InvertedCircleClipper(
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
                        excerciseReference: excerciseReference,
                        size: littleCircleSize,
                        fullRed: controller.value == 1,
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
          Positioned.fill(
            child: Center(
              child: Transform.translate(
                offset: Offset(0, 1.5),
                child: Icon(
                  FontAwesomeIcons.times,
                  color: Theme.of(context).cardColor,
                  size: 14,
                ),
              )
            ),
          ),
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
    DateTime timerStarted = excerciseReference.tempStartTime;
    Duration timePassed = DateTime.now().difference(timerStarted);
    bool thereIsStillTime = timePassed <= excerciseReference.recoveryPeriod;
    
    //widget build
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