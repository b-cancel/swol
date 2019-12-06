import 'package:flutter/material.dart';
import 'package:swol/excercise/defaultDateTimes.dart';
import 'package:swol/excercise/excerciseStructure.dart';
import 'package:swol/other/durationFormat.dart';
import 'package:swol/sharedWidgets/excerciseListTile/excerciseTile.dart';
import 'package:swol/sharedWidgets/excerciseListTile/triangleAngle.dart';

class ExcerciseTileLeading extends StatelessWidget {
  ExcerciseTileLeading({
    @required this.excerciseReference,
    @required this.tileInSearch,
  });

  final AnExcercise excerciseReference;
  final bool tileInSearch;

  @override
  Widget build(BuildContext context) {
    //NOTE: timer takes precendence over regular inprogress
    if(excerciseReference.tempStartTime != null){
      return AnimatedMiniTimer(
        excerciseReference: excerciseReference,
        evenSliceDivision: true, 
        negativeFirst: true,
      );
    }
    else if(LastTimeStamp.isInProgress(excerciseReference.lastTimeStamp)){
      return Container(
        child: Text("Finished?"),
      );
    }
    else{ //NOT in timer, NOT in progress => show in what section it is
      if(tileInSearch){
        if(LastTimeStamp.isNew(excerciseReference.lastTimeStamp)){
          return ListTileChipShell(
            chip: MyChip(
              chipString: 'NEW',
            ),
          );
        }
        else{
          if(LastTimeStamp.isHidden(excerciseReference.lastTimeStamp)){
            return ListTileChipShell(
              chip: MyChip(
                chipString: 'HIDDEN',
              ),
            );
          }
          else{
            return Text(
              DurationFormat.format(
                DateTime.now().difference(excerciseReference.lastTimeStamp),
                showMinutes: false,
                showSeconds: false,
                showMilliseconds: false,
                showMicroseconds: false,
                short: true,
              ),
            );
          }
        }
      }
      else return Icon(Icons.chevron_right);
    }
  }
}

class ListTileChipShell extends StatelessWidget {
  const ListTileChipShell({
    Key key,
    @required this.chip,
  }) : super(key: key);

  final Widget chip;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: 8,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          chip,
        ],
      ),
    );
  }
}

//reusable function
double timeToLerpValue(Duration timePassed){
  return timePassed.inMicroseconds / Duration(minutes: 5).inMicroseconds;
}

class AnimatedMiniTimer extends StatefulWidget {
  AnimatedMiniTimer({
    @required this.excerciseReference,
    this.evenSliceDivision: true,
    this.flipUnEveness: false,
    this.negativeFirst: true,
    //NOTE: largest possible size seems to be 62
    //56 feels good
    //48 feels better
    this.circleSize: 48, 
    this.circleToTicksPadding: 4,
    this.tickWidth: 4,
    this.ticksToProgressCirclePadding: 4,
  });

  final AnExcercise excerciseReference;
  final bool evenSliceDivision;
  final bool flipUnEveness;
  final bool negativeFirst;
  final double circleSize;
  final double circleToTicksPadding;
  final double tickWidth;
  final double ticksToProgressCirclePadding;

  @override
  _AnimatedMiniTimerState createState() => _AnimatedMiniTimerState();
}

class _AnimatedMiniTimerState extends State<AnimatedMiniTimer> with SingleTickerProviderStateMixin{
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
    controller.value = timeToLerpValue(timePassed);

    //add listeners
    controller.addListener(updateState);
    controller.addStatusListener(updateStateAnim);

    //start animation
    controller.forward();

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
    
    //generate all angles
    if(widget.evenSliceDivision){
      for(int i = 0; i < 10 ; i++) angles.add(36 * i);
    }
    else{
      for(int i = 0; i < 5; i++){
        int first = widget.flipUnEveness ? 1 : 3;
        angles.add(36 * (i*2)); 
        angles.add(26 * (i*2) + (18 * first));
      }
    }

    //in all cases you are going to end in 360
    //you may or may not need this
    //plan for it below
    angles.add(360);

    DateTime timerStarted = widget.excerciseReference.tempStartTime;
    Duration timePassed = DateTime.now().difference(timerStarted);
    bool borderRed = timePassed > widget.excerciseReference.recoveryPeriod;

    //generate slices
    List<Widget> slices = new List<Widget>();
    //-1 is for the 360
    for(int i = 0; i < angles.length-1; i++){ 
      bool isEven = (i%2 == 0);
      bool useStartAngle = false;
      if(isEven && widget.negativeFirst == false) useStartAngle = true;
      else if(isEven == false && widget.negativeFirst) useStartAngle = true;
      if(useStartAngle){
        slices.add(
          TriangleAngle(
            size: widget.circleSize - widget.circleToTicksPadding,
            start: angles[i].toDouble(),
            end: angles[i + 1].toDouble(),
            color: borderRed ? Colors.red : Colors.white,
          )
        );
      }
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
        color: Theme.of(context).primaryColorDark,
        padding: EdgeInsets.all(
          widget.circleToTicksPadding,
        ),
        child: ClipOval(
          child: Stack(
            children: <Widget>[
              Stack(
                children: slices,
              ),
              HighlightSlice(
                excerciseReference: widget.excerciseReference,
                size: widget.circleSize - widget.circleToTicksPadding,
                angles: angles,
                controllerValue: controller.value
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
      double timeSetAngle = (timeToLerpValue(excerciseReference.recoveryPeriod)).clamp(0.0, 1.0);
      double timePassedAngle = (timeToLerpValue(timePassed)).clamp(0.0, 1.0);
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