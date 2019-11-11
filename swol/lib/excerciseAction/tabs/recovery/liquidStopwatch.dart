import 'package:flutter/material.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import 'package:swol/excerciseAction/tabs/recovery/liquidTime.dart';
import 'package:swol/excerciseAction/tabs/recovery/liquidTimer.dart';

//TODO: all below
//the animation will go from 0 to 1 in 10 minutes always

//After 10: show 9:99 and keep the wave at 1

//Before 10:

//IF our timer has not completed:
//1. keep the wave at 0 and invisible
//2. keep the text invisible (no need to calcuate the text each frame)

//ELSE our timer has completed
//the progress of our wave depends entirely on how much extra time has passed since our timer stopped
//10 minutes - time passed = ammount of time stopwatch will show some animation or update [stop watch time]

//TODO; complete notes and stuff

//while Stop watch time > 0 
//we only want to show text and the wave when we

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

class _LiquidStopwatchState extends State<LiquidStopwatch> with TickerProviderStateMixin {
  final Duration fiveMinutes = Duration(minutes: 5);
  final Color finalBlue = Color(0xFF145C9E);
  final Color finalBlue2 = Color(0xFF2193FF);

  //main Controller
  AnimationController controller10Minutes;

  //color Controller
  //NOTE: only used for the wave color and doesnt need a listener
  //since while its running so will the controller10Minutes be running
  AnimationController controller5Minutes;
  Animation<Color> animation5Minutes;

  //function removable from listeners
  updateState(){
    if(mounted){
      setState(() {});
    }
  }

  //init
  @override
  void initState() {
    //super init
    super.initState();

    //create animation controller
    controller10Minutes = AnimationController(
      vsync: this,
      //our max value is 9:99
      //so our max duration is 10
      //after that the ammount of time overflowed is kind of irrelvant
      //because you know for a fact your muscles are super cold
      duration: Duration(minutes: 10),
    );

    controller5Minutes = AnimationController(
      vsync: this,
      duration: fiveMinutes,
    );

    animation5Minutes = ColorTween(
      begin: Colors.red, 
      end: finalBlue,
    ).animate(controller5Minutes);

    //refresh UI at phone framerate
    controller10Minutes.addListener(updateState);
    widget.changeableTimerDuration.addListener(updateState);

    //start the stopwatch
    controller10Minutes.forward();
    controller5Minutes.forward();
  }

  @override
  void dispose() {
    widget.changeableTimerDuration.removeListener(updateState);
    controller10Minutes.removeListener(updateState);
    
    //controller dispose
    controller10Minutes.dispose();
    controller5Minutes.dispose();

    //super dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double textContainerSize = MediaQuery.of(context).size.width - (24 * 2);

    //calc time left
    Duration totalDurationPassed = DateTime.now().difference(widget.timerStart);
    Duration extraDurationPassed = Duration.zero;
    if(totalDurationPassed > widget.changeableTimerDuration.value){
      extraDurationPassed = totalDurationPassed - widget.changeableTimerDuration.value;
    }

    //calc strings
    List<String> extraDurationPassedStrings = durationToCustomDisplay(extraDurationPassed);
    List<String> timerDurationStrings = durationToCustomDisplay(widget.changeableTimerDuration.value);
    List<String> totalDurationPassedStrings = durationToCustomDisplay(totalDurationPassed);
    
    //prep vars
    String topNumber = extraDurationPassedStrings[0] + " : " + extraDurationPassedStrings[1];
    String bottomLeftNumber = timerDurationStrings[0] + " : " + timerDurationStrings[1];
    String bottomRightNumber = totalDurationPassedStrings[0] + " : " + totalDurationPassedStrings[1];

    //make generate the proper progress value (we dont want it to jump)
    //thankfully since our max setable time is 4:55 and our actual max wait time is 5 minutes
    //we know we will have atleast 5 seconds for the 2nd progress bar to jump from bottom to top
    double progressValue = 0;
    if(extraDurationPassed != Duration.zero){ //we should have some form of progress
      if(totalDurationPassed > fiveMinutes) progressValue = 1;
      else{ //between 0 and 1
        //Output: 0 -> 1
        //Input: widget.changeableTimerduration.value -> Duration(minutes 5)
        //Input: 0 -> fiveMinutes - widget.changeabletimerDuration.value
        Duration totalStopwatchAnimation = fiveMinutes - widget.changeableTimerDuration.value;
        //Input: 0 -> totalStopwatchAnimation (MIN of 5 seconds)
        //Output: 0 -> 1
        Duration adjustedTimePassed = totalDurationPassed - widget.changeableTimerDuration.value;

        //determine how far we have progressed within range
        progressValue = adjustedTimePassed.inMicroseconds / totalStopwatchAnimation.inMicroseconds;
        
        //just in case for small floating point "mistakes"
        progressValue = progressValue.clamp(0.0, 1.0).toDouble();
      }
    }

    //build return timer
    return Container(
      height: MediaQuery.of(context).size.width,
      width: MediaQuery.of(context).size.width, //3.25/5
      padding: EdgeInsets.all(24),
      child: ClipOval(
        child: Container(
          color: (totalDurationPassed > fiveMinutes) ? finalBlue : Colors.transparent,
          child: LiquidCircularProgressIndicator(
            //animated values
            value: progressValue,
            valueColor: (extraDurationPassed == Duration.zero || totalDurationPassed > fiveMinutes) 
            ? AlwaysStoppedAnimation(Colors.transparent) : animation5Minutes,
            //set value
            backgroundColor: Colors.transparent,
            borderColor: Colors.transparent,
            borderWidth: 0,
            direction: Axis.vertical, 
            //only show when our timer has completed
            center: (extraDurationPassed == Duration.zero) ? Container() : TimeDisplay(
              textContainerSize: textContainerSize, 
              topNumber: topNumber, 
              bottomLeftNumber: bottomLeftNumber, 
              bottomRightNumber: bottomRightNumber,
            ),
          ),
        ),
      ),
    );
  }
}