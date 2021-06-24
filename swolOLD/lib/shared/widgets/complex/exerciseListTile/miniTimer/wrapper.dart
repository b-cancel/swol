//flutter
import 'package:flutter/material.dart';

//internal
import 'package:swol/shared/widgets/complex/exerciseListTile/miniTimer/display.dart';
import 'package:swol/shared/structs/anExercise.dart';
import 'package:swol/other/otherHelper.dart';

//NOTE: we must switch between this fella and the above so that our reloading of the leading widget works
class AnimatedMiniNormalTimer extends StatefulWidget {
  AnimatedMiniNormalTimer({
    @required this.exercise,
    this.startTime,
  });

  final AnExercise exercise;
  final DateTime startTime;

  @override
  _AnimatedMiniNormalTimerState createState() => _AnimatedMiniNormalTimerState();
}

class _AnimatedMiniNormalTimerState extends State<AnimatedMiniNormalTimer> with SingleTickerProviderStateMixin{
  final Duration maxDuration = const Duration(minutes: 5);
  AnimationController controller;
  DateTime startTime;

  //function removable from listeners
  updateState(){
    if(mounted) setState(() {});
  }

  //wrapper for update state
  updateStateAnim(AnimationStatus status) => updateState();

  //init
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

    startTime = widget.startTime ?? 
      widget.exercise.tempStartTime.value;

    //start animation
    //NOTICE: this value never really changes, once its started... its started...
    //NOTE: again by now we know timerStart isnt null
    Duration timePassed = DateTime.now().difference(
      startTime
    );
    controller.forward(
      from: timeToLerpValue(timePassed),
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
    startTime = widget.startTime ?? 
    widget.exercise.tempStartTime.value;

    return WatchUI(
      controller: controller,
      exercise: widget.exercise,
      startTime: startTime,
    );
  }
}