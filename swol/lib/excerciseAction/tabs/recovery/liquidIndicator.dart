//flutter
import 'package:flutter/material.dart';

//plugin
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';

//internal
import 'package:swol/excerciseAction/tabs/recovery/recovery.dart';
import 'package:swol/utils/vibrate.dart';

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
    @required this.timerDuration,
    @required this.timerStart,
    this.vibrateOnComplete: false,
    //TODO: required if vibratOnComplete == true
    this.possibleFullDuration,
    this.centerSize,
  });

  final ValueNotifier<Duration> timerDuration;
  final DateTime timerStart;
  final bool vibrateOnComplete;
  final ValueNotifier<Duration> possibleFullDuration;
  final double centerSize;

  @override
  State<StatefulWidget> createState() => _AnimLiquidIndicatorState();
}

class _AnimLiquidIndicatorState extends State<AnimLiquidIndicator> with SingleTickerProviderStateMixin {
  List<String> durationFullStrings;

  //controllers
  Animation<Color> animation;
  AnimationController controller;

  //init
  @override
  void initState() {
    //super init
    super.initState();

    //create animation controller
    controller = AnimationController(
      vsync: this,
      duration: widget.timerDuration.value,
    );
    animation = Tween<Color>(begin: Colors.red, end: Colors.blue).animate(controller);

    //refresh UI at phone framerate
    controller.addListener((){
       setState(() {});
    });

    if(widget.vibrateOnComplete){
      controller.addStatusListener((status){
        if(status == AnimationStatus.completed){
          Vibrator.startVibration();
        }
        else{
          //NOTE:not cover case for isDismissed 
          //but should never happen
          Vibrator.stopVibration();
        }
      });
    }
    
    //start the countdown
    controller.forward();

    //init
    durationFullStrings = durationToCustomDisplay(widget.timerDuration.value);

    //react to update of full duration
    widget.timerDuration.addListener((){
      //update string
      durationFullStrings = durationToCustomDisplay(widget.timerDuration.value);

      //grab how much time has passed
      Duration durationSinceStart = DateTime.now().difference(widget.timerStart);

      //check how much time is left (may be negative)
      Duration durationUntilEnd = widget.timerDuration.value - durationSinceStart;

      //determine if we need to modify the animation or just leave it as is
      if(durationUntilEnd > Duration.zero){ //we still need to count down
        //stop things so we can proceed to update
        controller.stop();

        //we only have X ammount left 
        //but for the output 0->1 value to be correct
        //we need to instead shift the value
        controller.duration = widget.timerDuration.value;

        //update new value
        double newValue = durationSinceStart.inMicroseconds / widget.timerDuration.value.inMicroseconds;
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
      setState(() {});
    });
  }

  @override
  void dispose() {
    Vibrator.stopVibration();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //calc time left
    Duration durationPassed = DateTime.now().difference(widget.timerStart);
    Duration durationLeft = widget.timerDuration.value - durationPassed;

    //calc strings
    List<String> durationPassedStrings = durationToCustomDisplay(durationPassed);
    List<String> durationLeftStrings = durationToCustomDisplay(durationLeft);

    //calc size
    double textContainerSize = (widget.vibrateOnComplete) ? widget.centerSize - (24 * 2) : 0;

    //build return timer
    return ClipOval(
      child: InkWell(
        onTap: widget.vibrateOnComplete ? (){
          maybeChangeTime(
            context: context,
            recoveryDuration: widget.timerDuration,
            possibleFullDuration: widget.possibleFullDuration,
          );
        } : null,
        child: LiquidCircularProgressIndicator(
          //animated values
          value: (widget.vibrateOnComplete) ? 1 - controller.value : controller.value,
          valueColor: (widget.vibrateOnComplete) 
          ? AlwaysStoppedAnimation(Theme.of(context).accentColor)
          : AlwaysStoppedAnimation(Colors.blue),
          //set value
          backgroundColor: (widget.vibrateOnComplete) ? Colors.transparent : Colors.white, 
          borderColor: Colors.transparent,
          borderWidth: 0,
          direction: Axis.vertical, 
          center: (widget.vibrateOnComplete == false) ? Container()
          : Container(
            width: widget.centerSize,
            height: widget.centerSize,
            padding: EdgeInsets.all(24),
            child: Container(
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

  List<String> durationToCustomDisplay(Duration duration){
    String only1stDigit = "0";
    String always2Digits = "00";

    if(duration > Duration.zero){
      //seperate minutes
      int minutes = duration.inMinutes;
      only1stDigit = minutes.toString();
      if(only1stDigit.length > 1){
        only1stDigit = only1stDigit.substring(0,1);
      }

      //remove minutes so only seconds left
      duration = duration - Duration(minutes: minutes);

      //seperate seconds
      int seconds = duration.inSeconds;
      always2Digits = seconds.toString();
      if(always2Digits.length < 2){
        always2Digits = "0" + always2Digits;
      }
    }

    return [only1stDigit, always2Digits];
  }
}