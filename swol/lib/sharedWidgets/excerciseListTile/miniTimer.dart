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
        child: Text("Finished"),
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

class AnimatedMiniTimer extends StatelessWidget {
  AnimatedMiniTimer({
    @required this.excerciseReference,
    this.evenSliceDivision: true,
    this.flipUnEveness: false,
    this.negativeFirst: true,
    //NOTE: largest possible size seems to be 62
    //NOTE: 56 feels right
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

  int by36(int i){
    return 36 * i;
  }

  @override
  Widget build(BuildContext context) {
    //generate all start angles of slices
    List<int> angles = new List<int>();
    
    //generate all angles
    if(evenSliceDivision){
      for(int i = 0; i < 10 ; i++) angles.add(by36(i));
    }
    else{
      for(int i = 0; i < 5; i++){
        int first = flipUnEveness ? 1 : 3;
        angles.add(by36(i*2)); 
        angles.add(by36(i*2) + (18 * first));
      }
    }

    //in all cases you are going to end in 360
    //you may or may not need this
    //plan for it below
    angles.add(360);

    //generate slices
    List<Widget> slices = new List<Widget>();
    //-1 is for the 360
    for(int i = 0; i < angles.length-1; i++){ 
      bool isEven = (i%2 == 0);
      bool useStartAngle = false;
      if(isEven && negativeFirst == false) useStartAngle = true;
      else if(isEven == false && negativeFirst) useStartAngle = true;
      if(useStartAngle){
        slices.add(
          TriangleAngle(
            size: circleSize - circleToTicksPadding,
            start: angles[i].toDouble(),
            end: angles[i + 1].toDouble(),
          )
        );
      }
    }

    double littleCircleSize = circleSize 
      - (circleToTicksPadding * 2) 
      - (tickWidth * 2) 
      - (ticksToProgressCirclePadding * 2);

    //TODO: remove test print
    print("little circle size: " + littleCircleSize.toString());

    //display slices
    return ClipOval(
      child: Container(
        width: circleSize,
        height: circleSize,
        color: Theme.of(context).primaryColorDark,
        padding: EdgeInsets.all(
          circleToTicksPadding,
        ),
        child: ClipOval(
          child: Stack(
            children: <Widget>[
              Stack(
                children: slices,
              ),
              Container(
                padding: EdgeInsets.all(
                  tickWidth,
                ),
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
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        )
      ),
    );
  }
}

class CircleProgress extends StatefulWidget {
  CircleProgress({
    @required this.excerciseReference,
    @required this.size,
  });

  final AnExcercise excerciseReference;
  final double size;

  @override
  _CircleProgressState createState() => _CircleProgressState();
}

class _CircleProgressState extends State<CircleProgress> with SingleTickerProviderStateMixin{
  AnimationController controller; 
  final Duration maxDuration = const Duration(minutes: 5);

  //function removable from listeners
  updateState(){
    if(mounted) setState(() {});
  }
  updateStateAnim(AnimationStatus status) => updateState();

  @override
  void initState() {
    //create the controller
    controller = AnimationController(
      vsync: this,
      duration: maxDuration,
    );

    //add listeners
    controller.addListener(updateState);
    controller.addStatusListener(updateStateAnim);
    
    //set the value based on how far we arein
    DateTime timerStarted = widget.excerciseReference.tempStartTime;
    Duration timePassed = DateTime.now().difference(timerStarted);
    controller.value = timeToLerpValue(timePassed);

    //start animation
    controller.forward();

    //super init
    super.initState();
  }

  @override
  void dispose() {
    //remove the UI updater
    controller.removeListener(updateState);
    controller.removeStatusListener(updateStateAnim);
    controller.dispose();

    //super dispose
    super.dispose();
  }

  double timeToLerpValue(Duration timePassed){
    return timePassed.inMicroseconds / maxDuration.inMicroseconds;
  }

  @override
  Widget build(BuildContext context) {
    //time calcs
    DateTime timerStarted = widget.excerciseReference.tempStartTime;
    Duration timePassed = DateTime.now().difference(timerStarted);

    //set basic variables
    bool thereIsStillTime = timePassed <= widget.excerciseReference.recoveryPeriod;
    double timeSetAngle = (timeToLerpValue(widget.excerciseReference.recoveryPeriod)).clamp(0.0, 1.0);
    double timePassedAngle = (timeToLerpValue(timePassed)).clamp(0.0, 1.0);
    Color flatGrey = Color.fromRGBO(128,128,128,1);

    //create angles
    double firstAngle = (thereIsStillTime ? timePassedAngle : timeSetAngle) * 360;
    double secondAngle = (thereIsStillTime ? timeSetAngle : timePassedAngle) * 360;

    //test print
    print("-------------------------0 -> " + firstAngle.toString() + " -> " + secondAngle.toString());

    //output
    return Container(
      width: widget.size,
      height: widget.size,
      child: Stack(
        children: <Widget>[
          TriangleAngle(
            start: 0,
            end: firstAngle,
            color: flatGrey,
            size: widget.size,
          ),
          TriangleAngle(
            start: firstAngle,
            end: secondAngle,
            color: thereIsStillTime ? Theme.of(context).accentColor : Colors.red,
            size: widget.size,
          ),
        ],
      ),
    );
  }
}