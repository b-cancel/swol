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
    @required this.waveColor,
    @required this.backgroundColor,
    this.maxExtraDuration: const Duration(minutes: 5),
    this.showArrows: false,
    this.showIcon: false,
  });

  final ValueNotifier<Duration> changeableTimerDuration;
  final DateTime timerStart;
  final Color waveColor;
  final Color backgroundColor;
  final Duration maxExtraDuration;
  final bool showArrows;
  final bool showIcon;

  @override
  State<StatefulWidget> createState() => _LiquidStopwatchState();
}

class _LiquidStopwatchState extends State<LiquidStopwatch> with TickerProviderStateMixin {
  //main Controller
  AnimationController controller10Minutes;

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

    //refresh UI at phone framerate
    controller10Minutes.addListener(updateState);
    widget.changeableTimerDuration.addListener(updateState);

    //start the stopwatch
    controller10Minutes.forward();
  }

  @override
  void dispose() {
    widget.changeableTimerDuration.removeListener(updateState);
    controller10Minutes.removeListener(updateState);
    
    //controller dispose
    controller10Minutes.dispose();

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

    //if the total time passed overflows
    //then our timer has run as much as possible
    //so we overflow the larger top number as well
    if(totalDurationPassedStrings[1] == "99"){
      topNumber = "9 : 99";
    }

    //make generate the proper progress value (we dont want it to jump)
    //thankfully since our max setable time is 4:55 and our actual max wait time is 5 minutes
    //we know we will have atleast 5 seconds for the 2nd progress bar to jump from bottom to top
    double progressValue = 0;
    if(extraDurationPassed != Duration.zero){ //we should have some form of progress
      if(totalDurationPassed > widget.maxExtraDuration) progressValue = 1;
      else{ //between 0 and 1
        //Output: 0 -> 1
        //Input: widget.changeableTimerduration.value -> Duration(minutes 5)
        //Input: 0 -> fiveMinutes - widget.changeabletimerDuration.value
        Duration totalStopwatchAnimation = widget.maxExtraDuration - widget.changeableTimerDuration.value;
        //Input: 0 -> totalStopwatchAnimation (MIN of 5 seconds)
        //Output: 0 -> 1
        Duration adjustedTimePassed = totalDurationPassed - widget.changeableTimerDuration.value;

        //determine how far we have progressed within range
        progressValue = adjustedTimePassed.inMicroseconds / totalStopwatchAnimation.inMicroseconds;
        
        //just in case for small floating point "mistakes"
        progressValue = progressValue.clamp(0.0, 1.0).toDouble();
      }
    }

    //initially tells the user what happening
    //then explains they can no longer to the training type behind the one they were aiming for
    String extraMessage = (extraDurationPassed == Duration.zero) ? "Flushing Lactic Acid Build Up" : null;
    
    //reminds the user what this duration of break is good for
    String readyFor; //only empty for the first 15 seconds
    String lateFor;

    //we are ready for some type of workout
    if(Duration(seconds: 15) < totalDurationPassed && totalDurationPassed < Duration(minutes: 5)){
      readyFor = "Ready For ";
      if(totalDurationPassed < Duration(minutes: 1)){ //15s to 1m
        readyFor += "Endurance";
      } 
      else{
        lateFor = "To Late For ";
        if(totalDurationPassed < Duration(minutes: 2)){ //to 2m hypertrophy
          readyFor += "Hypertrophy";
          lateFor += "Endurance";
        }
        else if(totalDurationPassed < Duration(minutes: 3)){ //to 3m hypertrophy or strength
          readyFor += "Hypertrophy/Strength";
          lateFor += "Hypertrophy";
        }
        else{ //to 5m strength
          readyFor += "Strength";
          lateFor += "Hypertrophy";
        }
        lateFor += " Training";
      }
      readyFor += " Training";
    }

    if(extraMessage == null && readyFor == null && lateFor == null){
      extraMessage = "You Waited Too Long";
      lateFor = "you need to warm up again";
    }

    //handle 3 liners a bit more delicately
    if(lateFor != null && extraMessage != null && readyFor != null){
      lateFor = lateFor.toLowerCase();
      lateFor = null;
    }

    //build return timer
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          FittedBox(
            fit: BoxFit.contain,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: 16,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  extraMessage != null ? Text(
                    extraMessage,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ) : EmptyContainer(),
                  readyFor != null ? Text(
                    readyFor,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: extraMessage == null ? FontWeight.bold : FontWeight.normal,
                    ),
                  ) : EmptyContainer(),
                  lateFor != null ? Text(
                    lateFor,
                    style: TextStyle(
                      fontSize: 10,
                    ),
                  ) : EmptyContainer(),
                ],
              )
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.width,
            width: MediaQuery.of(context).size.width, //3.25/5
            padding: EdgeInsets.all(24),
            child: ClipOval(
              child: LiquidCircularProgressIndicator(
                //animated values
                value: 1 - progressValue,
                valueColor: (extraDurationPassed == Duration.zero || totalDurationPassed > widget.maxExtraDuration) 
                ? AlwaysStoppedAnimation(Colors.transparent) : AlwaysStoppedAnimation(widget.backgroundColor),
                //set value
                backgroundColor: widget.waveColor,
                borderColor: Colors.transparent,
                borderWidth: 0,
                direction: Axis.vertical, 
                //only show when our timer has completed
                center: (extraDurationPassed == Duration.zero) ? Container() : TimeDisplay(
                  textContainerSize: textContainerSize, 
                  topNumber: topNumber, 
                  topArrowUp: widget.showArrows ? true : null,
                  bottomLeftNumber: bottomLeftNumber, 
                  bottomRightNumber: bottomRightNumber,
                  showBottomArrow: widget.showArrows ? true : false,
                  isTimer: false,
                  showIcon: widget.showIcon,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}