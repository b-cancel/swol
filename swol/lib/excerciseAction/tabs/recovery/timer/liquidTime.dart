//flutter 
import 'package:flutter/material.dart';

//packages
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';

//internal
import 'package:swol/excerciseAction/tabs/recovery/secondary/explained.dart';
import 'package:swol/excerciseAction/tabs/recovery/secondary/timeDisplay.dart';
import 'package:swol/excerciseAction/tabs/recovery/timer/changeTime.dart';
import 'package:swol/excerciseAction/tabs/recovery/timer/pulsingBackground.dart';
import 'package:swol/excerciseAction/tabs/recovery/timer/superOverflow.dart';
import 'package:swol/excerciseAction/tabs/recovery/timer/turnOffVibration.dart';
import 'package:swol/utils/vibrate.dart';

/*
TODO: improve turning off the vibration
the small snippet of code that stops vibration 
in "updateTimerDuration" covers some of the cases below

if you turned off the vibration after the timer went off
then as long as the timer isnt extended
changing it should not restart the vibration
neither should leaving and entering the excercise again
A.K.A.
setting the timer to the same time
or setting the timer to less time
should not restart the vibration

if you turned off the 5 minutes timer vibration
then leaving and entering the excercise again 
should not restart the vibration

if you turned off the 10 minutes timer vibration
then leaving and enter the excercise again 
should not restart the vibration
*/

//build
class LiquidTime extends StatefulWidget {
  LiquidTime({
    @required this.timerStart,
    @required this.changeableTimerDuration,
    this.showArrows: true,
    this.showIcon: true,
  });

  //initial controller set
  final DateTime timerStart;
  //time before we go any level of red
  final ValueNotifier<Duration> changeableTimerDuration;
  //smaller settings
  final bool showArrows;
  final bool showIcon;

  @override
  State<StatefulWidget> createState() => _LiquidTimeState();
}

class _LiquidTimeState extends State<LiquidTime> with TickerProviderStateMixin {
  //color constants
  final Color greyBackground = const Color(0xFFBFBFBF);

  //time constants
  final Duration maxEffectiveTimerDuration = const Duration(minutes: 10);
  final Duration maxEffectiveBreakDuration = const Duration(minutes: 5);

  //main Controller
  AnimationController controllerLonger; 
  AnimationController controllerShorter; 
  AnimationController controllerTimer; 

  //TODO: fix it not switching over to the new ui after the full 10 has passed

  //function removable from listeners
  updateState(){
    if(mounted) setState(() {});
  }

  vibrateOnComplete(AnimationStatus status){
    if(status == AnimationStatus.completed){
      Vibrator.startVibration();
      //needed so that when the 10 minutes pass 1 last reload causes us to switch to the new UI
      updateState();
    }
  }

  updateTimerDuration(){
    controllerTimer.removeStatusListener(vibrateOnComplete);
    Duration timePassed = DateTime.now().difference(widget.timerStart);
    controllerTimer.duration = widget.changeableTimerDuration.value;
    controllerTimer.addStatusListener(vibrateOnComplete); 
    controllerTimer.forward(
      from: timesToValue(timePassed, widget.changeableTimerDuration.value),
    );

    //stops the vibration IF before you were past the set time but before 5 minutes
    //but now you are within the set time and before 5 minutes
    bool shouldBeVibrating = (timePassed >= widget.changeableTimerDuration.value);
    //this extra condition guarantees that if the timer was shut off after 5, or 10
    //it doesn't get reset
    shouldBeVibrating = shouldBeVibrating && timePassed < maxEffectiveBreakDuration;
    if(shouldBeVibrating == false && Vibrator.isVibrating) Vibrator.stopVibration();

    updateState();
  }

  //other functions
  maybeChangeRecoveryDuration(){
    maybeChangeTime(
      context: context,
      recoveryDuration: widget.changeableTimerDuration,
    );
  }

  explainFunctionalityPopUp(int sectionWithInitialFocus){
    showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return ExplainFunctionality(
          sectionWithInitialFocus: sectionWithInitialFocus,
        );
      },
    );
  }

  double timesToValue(Duration passed, Duration total){
    return (passed.inMicroseconds / total.inMicroseconds).clamp(0.0, 1.0);
  }

  //init
  @override
  void initState() {
    //super init
    super.initState();

    //---Create Animation Controllers
    controllerLonger = AnimationController(
      vsync: this,
      duration: maxEffectiveTimerDuration,
    );

    controllerShorter = AnimationController(
      vsync: this,
      duration: maxEffectiveBreakDuration,
    );

    controllerTimer = AnimationController(
      vsync: this,
      duration: widget.changeableTimerDuration.value,
    );

    //---Update the UI as time passed
    controllerLonger.addListener(updateState);
    //controllerShorter.addListener(updateState); //NOTE: the above handles this too
    //controllerTimer.addListener(updateState); //NOTE: the above handles this too

    //---immediate update of time if it changes NOTE: might not be needed
    widget.changeableTimerDuration.addListener(updateTimerDuration);
 
    //how much has already passed in the background
    Duration timePassed = DateTime.now().difference(widget.timerStart);

    //---default vibration starts after controllers end
    controllerLonger.addStatusListener(vibrateOnComplete);
    controllerShorter.addStatusListener(vibrateOnComplete);
    controllerTimer.addStatusListener(vibrateOnComplete);

    //---start the controllers
    controllerLonger.forward(
      from: timesToValue(timePassed, maxEffectiveTimerDuration),
    );
    controllerShorter.forward(
      from: timesToValue(timePassed, maxEffectiveBreakDuration),
    );
    controllerTimer.forward(
      from: timesToValue(timePassed, widget.changeableTimerDuration.value),
    );
  }

  @override
  void dispose() {
    //remove from changeableTimerDuration
    widget.changeableTimerDuration.removeListener(updateTimerDuration);

    //remove the UI updater
    controllerLonger.removeListener(updateState);

    //remove status listeners
    controllerTimer.removeStatusListener(vibrateOnComplete);
    controllerShorter.removeStatusListener(vibrateOnComplete);
    controllerLonger.removeStatusListener(vibrateOnComplete);
    
    //controller dispose
    controllerTimer.dispose();
    controllerShorter.dispose();
    controllerLonger.dispose();

    //stop vibrating (when out of this page we don't vibrate, we only notify)
    Vibrator.stopVibration();

    //super dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //show UI depending on how much time has passed
    Duration totalDurationPassed = DateTime.now().difference(widget.timerStart);

    //calculate string for timer duration
    List<String> timerDurationStrings = durationToCustomDisplay(widget.changeableTimerDuration.value);
    String timerDurationString = timerDurationStrings[0] + " : " + timerDurationStrings[1];

    //super red gives us a completely different widget
    //NOTE: the ONE SECOND accounts for the fact that 
    //the controller might not call set state immediately at the 10 minute mark
    //but its highly unlikely the phone will lag so much 
    //that it won't call it within the last 1 second
    if(totalDurationPassed >= (maxEffectiveTimerDuration - Duration(seconds: 1))){
      return SuperOverflow(
        totalDurationPassed: totalDurationPassed,
        recoveryDurationString: timerDurationString,
        updateState: updateState,
        explainFunctionality: () => explainFunctionalityPopUp(2),
        maybeChangeRecoveryDuration: maybeChangeRecoveryDuration,
      );
    }
    else{ //either we are half red or not red at all
      //determine what section to focus on first when the user is looking for guidance
      int sectionWithInitialFocus;
      if(totalDurationPassed <= Duration(minutes: 1)) sectionWithInitialFocus = 0;
      else if(totalDurationPassed < Duration(minutes: 3)) sectionWithInitialFocus = 1;
      else sectionWithInitialFocus = 2;

      //format how much time has passed into a string
      List<String> totalDurationPassedStrings = durationToCustomDisplay(totalDurationPassed);
      String totalDurationString = totalDurationPassedStrings[0] + " : " + totalDurationPassedStrings[1]; //bottom right for ?

      //chosen colors
      final Color greenTimerAccent = Theme.of(context).accentColor;
      final Color redStopwatchAccent = Colors.red;

      //---calculate extra time passed
      Duration extraDurationPassed = Duration.zero;
      if(totalDurationPassed > widget.changeableTimerDuration.value){
        extraDurationPassed = totalDurationPassed - widget.changeableTimerDuration.value;
      }

      //simplifying varaible for the merge of timer and stopwatch widgets
      bool firstTimerRunning = (extraDurationPassed == Duration.zero);
      bool withinMaxDuration = (totalDurationPassed <= maxEffectiveBreakDuration);

      //-----variables that don't really vary
      String bottomLeftNumber = timerDurationString;
      String bottomRightNumber = totalDurationString;

      //-----varaibles that varry below
      //wave progress
      double progressValue; //should run from 0 -> 1
      //colors
      Animation<Color> waveColor;
      Color backgroundColor;
      //numbers
      String topNumber;

      //react differently to the timer or stopwatch
      if(firstTimerRunning){
        //For Timer (GREY background & green wave)
        backgroundColor = greyBackground;
        waveColor = AlwaysStoppedAnimation(greenTimerAccent);

        //calculate top number (+1 second handles a rounded error)
        Duration durationLeft = widget.changeableTimerDuration.value - totalDurationPassed + Duration(seconds: 1);
        List<String> durationLeftStrings = durationToCustomDisplay(durationLeft);
        String durationLeftString = durationLeftStrings[0] + " : " + durationLeftStrings[1]; //top number for timer
        topNumber = durationLeftString;

        //set progress value
        progressValue =  timesToValue(totalDurationPassed, widget.changeableTimerDuration.value);
      }
      else{
        //For Stopwatch (red background & GREY background)
        backgroundColor = (withinMaxDuration) ? redStopwatchAccent : Colors.transparent;
        waveColor = AlwaysStoppedAnimation(
          //when the stopwatch finishes we want our screen to be full red all the time
          (withinMaxDuration) ? greyBackground : Colors.transparent,
        );

        //calculate top Number
        List<String> extraDurationPassedStrings = durationToCustomDisplay(extraDurationPassed);
        String extraDurationPassedString = extraDurationPassedStrings[0] + " : " + extraDurationPassedStrings[1];
        topNumber = extraDurationPassedString;

        //---generate the progress values
        //make generate the proper progress value (we dont want it to jump)
        //thankfully since our max setable time is 4:55 and our actual max wait time is 5 minutes
        //we know we will have atleast 5 seconds for the 2nd progress bar to jump from bottom to top

        //maxDuration = maxEffectiveBREAKduration NOT maxEffectiveTIMERduration
        if(withinMaxDuration == false) progressValue = 1;
        else{ //between 0 and 1
          progressValue = timesToValue(
            totalDurationPassed - widget.changeableTimerDuration.value,
            maxEffectiveBreakDuration - widget.changeableTimerDuration.value,
          );
        }
      }

      //just in case for small floating point "mistakes"
      progressValue = progressValue.clamp(0.0, 1.0);

      //based on all the calculated variables above show the various numbers
      Widget timeDisplay = TimeDisplay(
        textContainerSize: MediaQuery.of(context).size.width - (24 * 2),
        topNumber: topNumber, 
        topArrowUp:  widget.showArrows ? (firstTimerRunning ? false : true) : null,
        bottomLeftNumber: bottomLeftNumber, 
        bottomRightNumber: bottomRightNumber,
        showBottomArrow: widget.showArrows ? true : false,
        isTimer: (firstTimerRunning) ? true : false,
        showIcon: widget.showIcon,
      );

      //initially tells the user what happening
      //then explains they can no longer to the training type behind the one they were aiming for
      String extraMessage = firstTimerRunning ? "Flushing Acid Build Up" : null;
      
      //reminds the user what this duration of break is good for
      String readyFor; //only empty for the first 15 seconds
      String lateFor;

      //we are ready for some type of workout
      if(totalDurationPassed < Duration(seconds: 15) == false 
      && Duration(minutes: 5) < totalDurationPassed == false){
        readyFor = "Ready For ";
        if(totalDurationPassed < Duration(minutes: 1)){ //15s to 1m
          readyFor += "Endurance";
        } 
        else{
          lateFor = "Too Late For ";
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

      //---------------------
      Widget topInfoButton = FittedBox(
        fit: BoxFit.contain,
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 0,
          ),
          child: OutlineButton(
            highlightedBorderColor: Theme.of(context).accentColor,
            onPressed: () => explainFunctionalityPopUp(sectionWithInitialFocus),
            padding: EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 4,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                extraMessage != null ? Text(
                  extraMessage,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ) : EmptyContainer(),
                readyFor != null ? 
                Text(
                  readyFor,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: extraMessage == null ? FontWeight.bold : FontWeight.normal,
                  ),
                )
                : EmptyContainer(),
                lateFor != null ? Text(
                  lateFor,
                  style: TextStyle(
                    fontSize: 10,
                  ),
                ) : EmptyContainer(),
              ],
            ),
          )
        ),
      );

      Widget timeWidget = Stack(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.width,
            width: MediaQuery.of(context).size.width, //3.25/5
            padding: EdgeInsets.all(24),
            child: ClipOval(
              child: Stack(
                children: <Widget>[
                  PulsingBackground(
                    width: MediaQuery.of(context).size.width,
                  ),
                  LiquidCircularProgressIndicator(
                    //animated values
                    value: 1 - progressValue,
                    valueColor: waveColor,
                    backgroundColor: backgroundColor,
                    //set values
                    borderColor: Colors.transparent,
                    borderWidth: 0,
                    direction: Axis.vertical, 
                    //only show when our timer has completed
                    center: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () => maybeChangeRecoveryDuration(),
                        child: Center(
                          child: timeDisplay
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          VibrationSwitch(),
        ],
      );

      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          topInfoButton,
          timeWidget,
        ],
      );
    }
  }
}