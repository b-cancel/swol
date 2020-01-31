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
  });

  final AnExcercise excerciseReference;

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

    //start animation
    //NOTICE: this value never really changes, once its started... its started...
    Duration timePassed = DateTime.now().difference(widget.excerciseReference.tempStartTime);
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
    return WatchUI(
      controller: controller,
      excerciseReference: widget.excerciseReference,
    );
  }
}