import 'package:flutter/material.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import 'package:swol/utils/vibrate.dart';
import 'package:vibration/vibration.dart';

/*
animationController.duration = Duration(milliseconds: _duration)
share
editflag
answered Nov 8 '18 at 16:36

Johnny Boy
14099 bronze badges

Just a comment for others that look this up: 
if you want the duration change to be updated on the fly 
(i.e., while the animation controller is running), 
then it seems you have to activate the animation movement again. 
In other words, in my case, after updating the Duration, 
I had to add if (controller.isAnimating) controller.forward(); 
in order for the speed on the animation to change based on the new duration. 
A peek at the AnimationController code shows why: 
the internal parameters are updated not on setting the duration but on starting the animation
*/

//you can use a tween to go between two durations

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

class AnimLiquidIndicator extends StatefulWidget {
  AnimLiquidIndicator({
    @required this.fullDuration,
    @required this.timerStart,
    @required this.centerSize,
  });

  final ValueNotifier<Duration> fullDuration;
  final DateTime timerStart;
  final double centerSize;

  @override
  State<StatefulWidget> createState() => _AnimLiquidIndicatorState();
}

class _AnimLiquidIndicatorState extends State<AnimLiquidIndicator> with SingleTickerProviderStateMixin {
  //controllers
  AnimationController countDownController;
  //AnimationController countUpController;

  //keep track of both of these values so we can use them to update the animation if necesary
  Duration timerDisplay;

  //init
  @override
  void initState() {
    //super init
    super.initState();

    //create animation controller
    countDownController = AnimationController(
      vsync: this,
      duration: widget.fullDuration.value,
    );

    /*
    //create other animation controller
    countUpController = AnimationController(
      vsync: this,
      duration: Duration(minutes: 10),
    );
    */

    //refresh UI at phone framerate
    countDownController.addListener((){
       setState(() {});
    });

    countDownController.addStatusListener((status){
      if(status == AnimationStatus.completed){
        startVibration();
      }
      else{
        //NOTE:not cover case for isDismissed 
        //but should never happen
        stopVibration();
      }
    });

    /*
    countDownController.addStatusListener((status){
      if(status == AnimationStatus.completed){
        countUpController.forward();
      }
      else{
        countUpController.stop();
        countUpController.reset();
      }
    });
    */

    //start the countdown
    countDownController.forward();

    //react to update of full duration
    widget.fullDuration.addListener((){
      //grab how much time has passed
      Duration durationSinceStart = DateTime.now().difference(widget.timerStart);

      //check how much time is left (may be negative)
      Duration durationUntilEnd = widget.fullDuration.value - durationSinceStart;

      //determine if we need to modify the animation or just leave it as is
      if(durationUntilEnd > Duration.zero){ //we still need to count down
        //stop things so we can proceed to update
        countDownController.stop();

        //we only have X ammount left 
        //but for the output 0->1 value to be correct
        //we need to instead shift the value
        countDownController.duration = widget.fullDuration.value;

        //update new value
        double newValue = durationSinceStart.inMicroseconds / widget.fullDuration.value.inMicroseconds;
        countDownController.value = newValue;
        
        //start the animation mid way
        countDownController.forward();
      }
      else{ //we don't need to countdown
        if(countDownController.isAnimating){
          countDownController.stop();
          countDownController.value = 1;
        }
        //ELSE: the animation was already complete
      }

      //the animation will automatically update here
      setState(() {});
    });
  }

  @override
  void dispose() {
    stopVibration();
    countDownController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //calc time left
    Duration durationSinceStart = DateTime.now().difference(widget.timerStart);
    timerDisplay = widget.fullDuration.value - durationSinceStart;

    //vars to be set
    String only1stDigit = "0";
    String always2Digits = "00";

    if(timerDisplay > Duration.zero){
      //seperate minutes
      int minutes = timerDisplay.inMinutes;
      only1stDigit = minutes.toString();
      if(only1stDigit.length > 1){
        only1stDigit = only1stDigit.substring(0,1);
      }

      //remove minutes so only seconds left
      timerDisplay = timerDisplay - Duration(minutes: minutes);

      //seperate seconds
      int seconds = timerDisplay.inSeconds;
      always2Digits = seconds.toString();
      if(always2Digits.length < 2){
        always2Digits = "0" + always2Digits;
      }
    }

    //build return timer
    return LiquidCircularProgressIndicator(
      value: 1 - countDownController.value,
      backgroundColor: Colors.white, 
      borderColor: Colors.transparent,
      borderWidth: 0,
      direction: Axis.vertical, 
      center: Container(
        width: widget.centerSize,
        height: widget.centerSize,
        padding: EdgeInsets.all(24),
        child: FittedBox(
          fit: BoxFit.contain,
          child: Text(
            only1stDigit + " : " + always2Digits,
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

/*
  //possible update second
      double tempIndicatorFill;
      
  */