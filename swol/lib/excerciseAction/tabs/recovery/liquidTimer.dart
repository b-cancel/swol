//flutter
import 'package:flutter/material.dart';

//plugin
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import 'package:swol/excerciseAction/tabs/recovery/liquidTime.dart';

//internal
import 'package:swol/excerciseAction/tabs/recovery/recovery.dart';
import 'package:swol/utils/vibrate.dart';

//widget
class LiquidTimer extends StatefulWidget {
  LiquidTimer({
    @required this.changeableTimerDuration,
    @required this.timerStart,
    @required this.waveColor,
    @required this.backgroundColor,
  });

  final ValueNotifier<Duration> changeableTimerDuration;
  final DateTime timerStart;
  final Color waveColor;
  final Color backgroundColor;

  @override
  State<StatefulWidget> createState() => _LiquidTimerState();
}

class _LiquidTimerState extends State<LiquidTimer> with SingleTickerProviderStateMixin {
  List<String> durationFullStrings;

  //controllers
  AnimationController controller;

  //function make removable from listener
  updateState(){
    if(mounted){
      setState(() {});
    }
  }

  //function make removable from listener
  updateVibration(status){
    if(status == AnimationStatus.completed){
      Vibrator.startVibration();
    }
    else{
      //NOTE:not cover case for isDismissed 
      //but should never happen
      Vibrator.stopVibration();
    }

    //upate the text
    updateText();
  }

  //function make removable from listener
  updateText(){
    //update string
    durationFullStrings = durationToCustomDisplay(widget.changeableTimerDuration.value);

    //grab how much time has passed
    Duration durationSinceStart = DateTime.now().difference(widget.timerStart);

    //check how much time is left (may be negative)
    Duration durationUntilEnd = widget.changeableTimerDuration.value - durationSinceStart;

    //determine if we need to modify the animation or just leave it as is
    if(durationUntilEnd > Duration.zero){ //we still need to count down
      //stop things so we can proceed to update
      controller.stop();

      //we only have X ammount left 
      //but for the output 0->1 value to be correct
      //we need to instead shift the value
      controller.duration = widget.changeableTimerDuration.value;

      //update new value
      controller.value = durationSinceStart.inMicroseconds 
        / widget.changeableTimerDuration.value.inMicroseconds;
      
      //start the animation mid way
      controller.forward();
    }
    else{ //we don't need to countdown
      if(controller.isAnimating){
        controller.stop();
        controller.value = 1;
      }
      //ELSE: the animation was already complete
    }

    //the animation will automatically update here
    updateState();
  }

  //init
  @override
  void initState() {
    //super init
    super.initState();

    //create animation controller
    controller = AnimationController(
      vsync: this,
      duration: widget.changeableTimerDuration.value,
    );

    //listeners
    controller.addListener(updateState);
    controller.addStatusListener(updateVibration);
    widget.changeableTimerDuration.addListener(updateText);

    //initiall duration left number
    durationFullStrings = durationToCustomDisplay(widget.changeableTimerDuration.value);

    //start the countdown
    controller.forward();
  }

  @override
  void dispose() {
    //just in case it isn't done we leave this page
    Vibrator.stopVibration();
    
    //remove listeners
    controller.removeListener(updateState);
    controller.removeStatusListener(updateVibration);
    widget.changeableTimerDuration.removeListener(updateText);

    //remove listener
    controller.dispose();

    //super dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double textContainerSize = MediaQuery.of(context).size.width - (24 * 2);

    //calc time left
    Duration durationPassed = DateTime.now().difference(widget.timerStart);
    //NOTE: this covers a small edge case
    Duration durationLeft = widget.changeableTimerDuration.value - durationPassed + Duration(seconds: 1);

    //calc strings
    List<String> durationPassedStrings = durationToCustomDisplay(durationPassed);
    List<String> durationLeftStrings = durationToCustomDisplay(durationLeft);

    //prep vars
    String topNumber = durationLeftStrings[0] + " : " + durationLeftStrings[1];
    String bottomLeftNumber = durationFullStrings[0] + " : " + durationFullStrings[1];
    String bottomRightNumber = durationPassedStrings[0] + " : " + durationPassedStrings[1];

    //build return timer
    return Container(
      height: MediaQuery.of(context).size.width,
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(24),
      child: ClipOval(
        child: InkWell(
          onTap: (){
            maybeChangeTime(
              context: context,
              recoveryDuration: widget.changeableTimerDuration,
            );
          },
          child: LiquidCircularProgressIndicator(
            //animated values
            value: 1 - controller.value,
            valueColor: AlwaysStoppedAnimation(
              (controller.value == 1) 
              ? Colors.transparent 
              : widget.waveColor,
            ),
            backgroundColor: (controller.value == 1) ? Colors.transparent : widget.backgroundColor,
            //set value
            borderColor: Colors.transparent,
            borderWidth: 0,
            direction: Axis.vertical, 
            center: (controller.value == 1) ? Container() : TimeDisplay(
              textContainerSize: textContainerSize, 
              topNumber: topNumber, 
              topArrowUp: false,
              bottomLeftNumber: bottomLeftNumber, 
              bottomRightNumber: bottomRightNumber,
              showBottomArrow: true,
            ),
          ),
        ),
      ),
    );
  }
}