//flutter
import 'package:flutter/material.dart';

//packages
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import 'package:swol/excerciseAction/tabs/recovery/timer/onlyEditButton.dart';
import 'package:swol/excerciseAction/tabs/recovery/timer/puslingBackground.dart';

//internal
import 'package:swol/excerciseAction/tabs/recovery/timer/turnOffVibration.dart';
import 'package:swol/excerciseAction/tabs/recovery/secondary/timeDisplay.dart';
import 'package:swol/excerciseAction/tabs/recovery/timer/information.dart';
import 'package:swol/excerciseAction/tabs/recovery/timer/changeTime.dart';

//internal: shared
import 'package:swol/shared/methods/theme.dart';
import 'package:swol/shared/methods/vibrate.dart';
import 'package:swol/shared/structs/anExcercise.dart';
import 'package:vibration/vibration.dart';

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

//NOTE: never ask wether we should change the timer
//if they stop at less time than expected the pop up will annoy them
//if they stop after more time then expected the buzzing will annoy them
//them being annoyed will cause them to change it themeselves

//NOTE: we want to stop users from accidentally continuing
//which is why we have the "are you sure" pop up
//but we don't want to stop them from purposely continuing quicker then they planned
//UNLESS its detrimental to them so...

//Being Flexible with the user
//IF they are within their selected training type we show it so
//  if they want to skip the extra time they know exactly when to do so
//  if they want to wait a bit more time they know exactly when to stop waiting
//Until they arrive at their desired training type we DONT show what training types they are ready for
//after they pass their desired training type we show that they waited too long

//When to show the are you sure pop up
//If we are not yet within our training type, the pop up only shows up if we are 15 seconds before our selected time
//if we are within our training type, regardless of how many seconds we are before our selected time the pop up doesn't show up
//  NOTE: distinction between Endurance training and less than 15 seconds of waiting

String durationToTrainingType(Duration duration, {bool zeroIsEndurance: true}) {
  if (duration < Duration(minutes: 1)) {
    if (zeroIsEndurance)
      return "Endurance";
    else {
      if (duration < Duration(seconds: 15)) {
        return "";
      } else
        return "Endurance";
    }
  } else if (duration < Duration(minutes: 2))
    return "Hypertrohpy";
  else if (duration < Duration(minutes: 3))
    return "Hyp/Str";
  else
    return "Strength";
}

String trainingTypeToMin(String training) {
  if (training == "Endurance")
    return "15 seconds";
  else if (training == "Hypertrohpy")
    return "1 minute";
  else if (training == "Hyp/Str")
    return "2 minutes";
  else
    return "3 minutes";
}

String trainingTypeToMax(String training) {
  if (training == "Endurance")
    return "1 minutes";
  else if (training == "Hypertrohpy")
    return "2 minutes";
  else if (training == "Hyp/Str")
    return "3 minutes";
  else
    return "5 minutes";
}

//build
class Timer extends StatefulWidget {
  Timer({
    @required this.excercise,
    @required this.changeableTimerDuration,
    @required this.areYouSurePopUp,
    this.showArrows: true,
    this.showIcon: true,
  });

  final AnExcercise excercise;
  //time before we go any level of red
  final ValueNotifier<Duration> changeableTimerDuration;
  final ValueNotifier<bool> areYouSurePopUp;
  //smaller settings
  final bool showArrows;
  final bool showIcon;

  @override
  State<StatefulWidget> createState() => _TimerState();
}

class _TimerState extends State<Timer> with TickerProviderStateMixin {
  //color constants
  final Color greyBackground = const Color(0xFFBFBFBF);

  //time constants
  final Duration maxTimerDuration = const Duration(minutes: 10);
  final Duration maxBreakDuration = const Duration(minutes: 5);

  //main Controller
  AnimationController maxTimerController;
  AnimationController maxBreakController;
  AnimationController chosenBreakController;

  //function removable from listeners
  updateState() {
    if (mounted) setState(() {});
  }

  vibrateOnComplete(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      Vibrator.startConstantVibration();
    }
  }

  //------------------------------inspect below-------------------------
  updateTimerDuration() {
    chosenBreakController.removeStatusListener(vibrateOnComplete);
    Duration timePassed =
        DateTime.now().difference(widget.excercise.tempStartTime.value);
    chosenBreakController.duration = widget.changeableTimerDuration.value;
    chosenBreakController.addStatusListener(vibrateOnComplete);
    chosenBreakController.forward(
      from: timesToValue(timePassed, widget.changeableTimerDuration.value),
    );

    //stops the vibration IF before you were past the set time but before 5 minutes
    //but now you are within the set time and before 5 minutes
    bool shouldBeVibrating =
        (timePassed >= widget.changeableTimerDuration.value);
    //this extra condition guarantees that if the timer was shut off after 5, or 10
    //it doesn't get reset
    shouldBeVibrating = shouldBeVibrating && timePassed < maxBreakDuration;
    if (shouldBeVibrating == false && Vibrator.isVibrating.value)
      Vibrator.stopVibration();

    updateState();
  }

  //other functions
  maybeChangeRecoveryDuration() {
    maybeChangeTime(
      context: context,
      recoveryDuration: widget.changeableTimerDuration,
    );
  }

  //------------------------------inspect above-------------------------

  //for calculating the controller's lerp value
  double timesToValue(Duration passed, Duration total) {
    return (passed.inMicroseconds / total.inMicroseconds).clamp(0.0, 1.0);
  }

  //init
  @override
  void initState() {
    //super init
    super.initState();

    //---Create Animation Controllers
    maxTimerController = AnimationController(
      vsync: this,
      duration: maxTimerDuration,
    );

    maxBreakController = AnimationController(
      vsync: this,
      duration: maxBreakDuration,
    );

    chosenBreakController = AnimationController(
      vsync: this,
      duration: widget.changeableTimerDuration.value,
    );

    //---Update the UI as time passed
    maxTimerController.addListener(updateState);
    //controllerShorter.addListener(updateState); //NOTE: the above handles this too
    //controllerTimer.addListener(updateState); //NOTE: the above handles this too

    //---immediate update of time if it changes NOTE: might not be needed
    widget.changeableTimerDuration.addListener(updateTimerDuration);

    //how much has already passed in the background
    Duration timePassed =
        DateTime.now().difference(widget.excercise.tempStartTime.value);

    //---default vibration starts after controllers end
    maxTimerController.addStatusListener(vibrateOnComplete);
    maxBreakController.addStatusListener(vibrateOnComplete);
    chosenBreakController.addStatusListener(vibrateOnComplete);

    //---start the controllers
    maxTimerController.forward(
      from: timesToValue(timePassed, maxTimerDuration),
    );
    maxBreakController.forward(
      from: timesToValue(timePassed, maxBreakDuration),
    );
    chosenBreakController.forward(
      from: timesToValue(timePassed, widget.changeableTimerDuration.value),
    );
  }

  @override
  void dispose() {
    //remove status listeners
    chosenBreakController.removeStatusListener(vibrateOnComplete);
    maxBreakController.removeStatusListener(vibrateOnComplete);
    maxTimerController.removeStatusListener(vibrateOnComplete);

    //remove from changeableTimerDuration
    widget.changeableTimerDuration.removeListener(updateTimerDuration);

    //remove the UI updater
    maxTimerController.removeListener(updateState);

    //controller dispose
    chosenBreakController.dispose();
    maxBreakController.dispose();
    maxTimerController.dispose();

    //stop vibrating (when out of this page we don't vibrate, we only notify)
    Vibrator.stopVibration();

    //super dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String generatedHeroTag = "timer" + widget.excercise.id.toString();

    //show UI depending on how much time has passed
    Duration totalDurationPassed =
        DateTime.now().difference(widget.excercise.tempStartTime.value);

    //text for pop ups and button
    String trainingSelected = durationToTrainingType(
        widget.excercise.recoveryPeriod,
        zeroIsEndurance: false);
    String trainingBreakGoodFor =
        durationToTrainingType(totalDurationPassed, zeroIsEndurance: false);

    //are you sure?
    Duration buffer = Duration(seconds: 15);
    bool withinTrainingType = (trainingSelected == trainingBreakGoodFor);
    if (withinTrainingType)
      widget.areYouSurePopUp.value = withinTrainingType;
    else {
      Duration lowerBound = widget.excercise.recoveryPeriod - buffer;
      Duration upperBound = widget.excercise.recoveryPeriod + buffer;
      widget.areYouSurePopUp.value = (lowerBound <= totalDurationPassed &&
          totalDurationPassed <= upperBound);
    }

    Widget infoButton = Theme(
      data: MyTheme.light,
      child: InfoOutlineWhiteButton(
        trainingName: trainingSelected,
        withinTrainingType: withinTrainingType,
        buffer: buffer,
        totalDurationPassed: totalDurationPassed,
        selectedDuration: widget.excercise.recoveryPeriod,
        isWhite: maxTimerController.value != 1,
      ),
    );

    //return
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Visibility(
          visible: maxTimerController.value != 1,
          child: infoButton,
        ),
        Stack(
          children: [
            VibrationSwitch(),
            Hero(
              tag: generatedHeroTag,
              child: Container(
                child: FittedBox(
                  fit: BoxFit.contain,
                  child: Container(
                    height: MediaQuery.of(context).size.width,
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.all(24),
                    child: ClipOval(
                      child: Stack(
                        children: <Widget>[
                          PulsingBackground(),
                          Positioned.fill(
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () => maybeChangeRecoveryDuration(),
                                child: Container(

                                ),
                              ),
                            ),
                          ),
                          Visibility(
                            visible: maxTimerController.value == 1,
                            child: Positioned.fill(
                              child: Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: <Widget>[
                                    infoButton,
                                    OnlyEditButton(
                                      breakDuration: widget.excercise.recoveryPeriod,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Visibility(
                            visible: maxTimerController.value != 1,
                            child: Container(
                              color: Colors.yellow,
                            ),
                          )
                          /*
                          LiquidCircularProgressIndicator(
                            //animated values
                            value: 1 - progressValue,
                            valueColor: waveColor,
                            backgroundColor: backgroundColor,
                            //set values
                            borderColor: Colors.transparent,
                            borderWidth: 0,
                            direction: Axis.vertical, 
                          ),
                          */
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );

/*
  //calculate string for timer duration
    //List<String> timerDurationStrings = durationToCustomDisplay(widget.changeableTimerDuration.value);
    //String timerDurationString = timerDurationStrings[0] + " : " + timerDurationStrings[1];

    //format how much time has passed into a string
    //List<String> totalDurationPassedStrings = durationToCustomDisplay(totalDurationPassed);
    //String totalDurationString = totalDurationPassedStrings[0] + " : " + totalDurationPassedStrings[1]; //bottom right for ?

    //chosen colors
    //final Color greenTimerAccent = Theme.of(context).accentColor;
    //final Color redStopwatchAccent = Colors.red;

    //bool withinMaxDuration = (totalDurationPassed <= maxEffectiveBreakDuration);
  */

    /*
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
        //todo finish fixing this
        explainFunctionality: () => print("hello"), //explainFunctionalityPopUp(2),
        maybeChangeRecoveryDuration: maybeChangeRecoveryDuration,
      );
    }
    else{ //either we are half red or not red at all
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

      Widget timeWidget = Stack(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.width,
            width: MediaQuery.of(context).size.width, //3.25/5
            padding: EdgeInsets.all(24),
            child: ClipOval(
              child: Stack(
                children: <Widget>[
                  Container(
                    color: Colors.red
                  ),
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

      print("----------from regular: " + "timer" + widget.excercise.id.toString());

      return Column(
        sldkfj
          timeWidget,
        ],
      );
    }
    */
  }
}