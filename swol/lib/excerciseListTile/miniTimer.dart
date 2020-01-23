//flutter
import 'package:flutter/material.dart';

//internal
import 'package:swol/excerciseTimer/displayUI/display.dart';
import 'package:swol/shared/structs/anExcercise.dart';
import 'package:swol/other/otherHelper.dart';

//NOTE: this wrapper exists so things update when desired
class AnimatedMiniNormalTimerAlternativeWrapper extends StatelessWidget {
  AnimatedMiniNormalTimerAlternativeWrapper({
    @required this.excerciseReference,
  });

  final AnExcercise excerciseReference;

  @override
  Widget build(BuildContext context) {
    return AnimatedMiniNormalTimer(
      excerciseReference: excerciseReference,
    );
  }
}

//NOTE: we must switch between this fella and the above so that our reloading of the leading widget works
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

  startOrReStart({bool restart: false}){
    Duration timePassed = DateTime.now().difference(widget.excerciseReference.tempStartTime);

    if(restart){
      //remove listeners
      controller.removeListener(updateState);
      controller.removeStatusListener(updateStateAnim);
    }

    //add listeners
    controller.addListener(updateState);
    controller.addStatusListener(updateStateAnim);

    //start animation
    controller.forward(
      from: timeToLerpValue(timePassed),
    );
  }

  //init
  @override
  void initState() {
    //create the controller
    controller = AnimationController(
      vsync: this,
      duration: maxDuration,
    );
    startOrReStart();

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
    return WatchUI(

    );
  }
}