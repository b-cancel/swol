//flutter
import 'package:flutter/material.dart';

//plugin
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';

//internal
import 'package:swol/excerciseAction/tabs/recovery/recovery.dart';
import 'package:swol/utils/vibrate.dart';

//utility (max is 9:59 but we indicate we are maxed out with 9:99)
List<String> durationToCustomDisplay(Duration duration){
  String only1stDigit = "0";
  String always2Digits = "00";

  if(duration > Duration.zero){
    //seperate minutes
    int minutes = duration.inMinutes;

    //9 minutes or less have passed (still displayable)
    if(minutes <= 9){
      only1stDigit = minutes.toString(); //9 through 0

      //remove minutes so only seconds left
      duration = duration - Duration(minutes: minutes);

      //seperate seconds
      int seconds = duration.inSeconds;
      always2Digits = seconds.toString(); //0 through 59

      //anything less than 10
      if(always2Digits.length < 2){ //0 -> 9
        always2Digits = "0" + always2Digits;
      }
      //ELSE: 10 -> 59
    }
    else{
      only1stDigit = "9";
      always2Digits = "99";
    }
  }

  return [only1stDigit, always2Digits];
}

//the animation will go from 0 to 1 in some duration
//when it start initially we will know what that duration is
//when we change the duration the animation can be in one of two states
//1. stopped
//2. running

//when we receive our new duration we need to
//1. update the animation duration
//2. start the animation mid way
//in some cases I image this may force us to restart our animation

//NOTE: AFTER our main animation ends... We NEED to start our other one...
//the other runs for 10 minutes until the clock reads 0 : 00
//if we change our main animation before it ends then we don't have to worry about this other one
//if we change it after our main animation has ended then we need to stop the other one and reset it and then proceed

class LiquidTimer extends StatefulWidget {
  LiquidTimer({
    @required this.changeableTimerDuration,
    @required this.timerStart,
  });

  final ValueNotifier<Duration> changeableTimerDuration;
  final DateTime timerStart;

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
      double newValue = durationSinceStart.inMicroseconds / widget.changeableTimerDuration.value.inMicroseconds;
      controller.value = newValue;
      
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
    //calc time left
    Duration durationPassed = DateTime.now().difference(widget.timerStart);
    Duration durationLeft = widget.changeableTimerDuration.value - durationPassed;

    //calc strings
    List<String> durationPassedStrings = durationToCustomDisplay(durationPassed);
    List<String> durationLeftStrings = durationToCustomDisplay(durationLeft);

    double textContainerSize = MediaQuery.of(context).size.width - (24 * 2);

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
              : Theme.of(context).accentColor,
            ),
            //set value
            backgroundColor: Colors.transparent,
            borderColor: Colors.transparent,
            borderWidth: 0,
            direction: Axis.vertical, 
            center: (controller.value == 1) ? Container() : Container(
              padding: EdgeInsets.all(24),
              child: FittedBox(
                fit: BoxFit.contain,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      width: textContainerSize,
                      child: FittedBox(
                        fit: BoxFit.contain,
                        child: Text(
                          durationLeftStrings[0] + " : " + durationLeftStrings[1],
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: textContainerSize,
                      padding: EdgeInsets.symmetric(
                        horizontal: (textContainerSize / 2) / 2,
                      ),
                      //NOTE: we want the text here to be HALF the size
                      //of the text above it
                      child: Container(
                        child: FittedBox(
                          fit: BoxFit.contain,
                          child: DefaultTextStyle(
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Text(durationFullStrings[0] + " : " + durationFullStrings[1]),
                                Text(" | "),
                                Text(durationPassedStrings[0] + " : " + durationPassedStrings[1]),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}


class LiquidStopwatch extends StatefulWidget {
  LiquidStopwatch({
    @required this.changeableTimerDuration,
    @required this.timerStart,
  });

  final ValueNotifier<Duration> changeableTimerDuration;
  final DateTime timerStart;

  @override
  State<StatefulWidget> createState() => _LiquidStopwatchState();
}

class _LiquidStopwatchState extends State<LiquidStopwatch> with SingleTickerProviderStateMixin {
  List<String> durationFullStrings;

  //controllers
  Animation<Color> animation;
  AnimationController controller;

  //function removable from listeners
  updateState(){
    if(mounted){
      setState(() {});
    }
  }

  //function removable from listeners
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
      double newValue = durationSinceStart.inMicroseconds / widget.changeableTimerDuration.value.inMicroseconds;
      controller.value = newValue;
      
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
      //our max value is 9:99
      //so our max duration is 10
      //after that the ammount of time overflowed is kind of irrelvant
      //because you know for a fact your muscles are super cold
      duration: Duration(minutes: 10),
    );

    animation = ColorTween(
      begin: Colors.red, 
      end: Colors.blue,
    ).animate(controller);

    //refresh UI at phone framerate
    controller.addListener(updateState);
    widget.changeableTimerDuration.addListener(updateText);
    
    //
    durationFullStrings = durationToCustomDisplay(widget.changeableTimerDuration.value);

    //start the stopwatch
    controller.forward();
  }

  @override
  void dispose() {
    Vibrator.stopVibration();
    controller.dispose();
    controller.removeListener(updateState);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //calc time left
    Duration durationPassed = DateTime.now().difference(widget.timerStart);
    Duration durationLeft = widget.changeableTimerDuration.value - durationPassed;

    //calc strings
    List<String> durationPassedStrings = durationToCustomDisplay(durationPassed);
    List<String> durationLeftStrings = durationToCustomDisplay(durationLeft);

    //build return timer
    return ClipOval(
      child: LiquidCircularProgressIndicator(
        //animated values
        value: controller.value,
        valueColor: animation,
        //set value
        backgroundColor: Colors.transparent,
        borderColor: Colors.transparent,
        borderWidth: 0,
        direction: Axis.vertical, 
        center: Container(
          child: Text("should show time overflowed... but also full time... and also time waited"),
        )
      ),
    );
  }
}