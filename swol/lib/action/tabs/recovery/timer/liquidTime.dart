//flutter
import 'package:flutter/material.dart';

//packages
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import 'package:swol/action/tabs/recovery/timer/notifcationSwitch.dart';

//internal
import 'package:swol/action/tabs/recovery/timer/puslingBackground.dart';
import 'package:swol/action/tabs/recovery/timer/turnOffVibration.dart';
import 'package:swol/action/tabs/recovery/secondary/timeDisplay.dart';
import 'package:swol/action/tabs/recovery/timer/onlyEditButton.dart';
import 'package:swol/action/tabs/recovery/timer/information.dart';
import 'package:swol/action/tabs/recovery/timer/changeTime.dart';

//internal: shared
import 'package:swol/shared/widgets/simple/conditional.dart';
import 'package:swol/shared/structs/anExercise.dart';
import 'package:swol/shared/methods/vibrate.dart';
import 'package:swol/shared/methods/theme.dart';

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

//build
class Timer extends StatefulWidget {
  Timer({
    required this.exercise,
    required this.timeStarted,
    required this.changeableTimerDuration,
    required this.showAreYouSure,
    this.showArrows: true,
    this.showIcon: true,
  });

  final AnExercise exercise;
  final DateTime timeStarted;
  //time before we go any level of red
  final ValueNotifier<Duration> changeableTimerDuration;
  final ValueNotifier<bool> showAreYouSure;
  //smaller settings
  final bool showArrows;
  final bool showIcon;

  @override
  State<StatefulWidget> createState() => _TimerState();
}

class _TimerState extends State<Timer> with TickerProviderStateMixin {
  //we grab how much time has passed initially and never grab it again
  //so that when we are transitioning to the next page
  //and the timerStart time changes to null the whole screen doesn't go red
  ValueNotifier<DateTime> timerStart =
      new ValueNotifier(AnExercise.nullDateTime);

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
    Duration timePassed = DateTime.now().difference(timerStart.value);
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

    //grab timer start initially
    timerStart.value = widget.timeStarted;

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
    Duration timePassed = DateTime.now().difference(timerStart.value);

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
    String generatedHeroTag = "timer" + widget.exercise.id.toString();

    //calc total duration passed
    Duration totalDurationPassed = DateTime.now().difference(timerStart.value);

    //the information button
    Widget infoButton = Theme(
      data: MyTheme.light,
      child: InfoOutlineWhiteButton(
        showAreYouSure: widget.showAreYouSure,
        totalDurationPassed: totalDurationPassed,
        selectedDuration: widget.exercise.recoveryPeriod,
        isWhite: maxTimerController.value != 1,
      ),
    );

    //show how much time we have selected
    List<String> breakTimeStrings =
        durationToCustomDisplay(widget.exercise.recoveryPeriod);
    String breakTimeString = breakTimeStrings[0] + ":" + breakTimeStrings[1];

    //-------------------------Optimize Below-------------------------

    //chosen colors
    final Color greenTimerAccent = Theme.of(context).accentColor;
    final Color redStopwatchAccent = Colors.red;

    //---calculate extra time passed
    Duration extraDurationPassed = Duration.zero;
    if (totalDurationPassed > widget.changeableTimerDuration.value) {
      extraDurationPassed =
          totalDurationPassed - widget.changeableTimerDuration.value;
    }

    //simplifying varaible for the merge of timer and stopwatch widgets
    bool firstTimerRunning = (extraDurationPassed == Duration.zero);
    bool withinMaxDuration = (totalDurationPassed <= maxBreakDuration);

    //-----varaibles that varry below
    //wave progress
    double progressValue; //should run from 0 -> 1
    //colors
    Animation<Color> waveColor;
    Color backgroundColor;
    //numbers
    String topNumber;

    //react differently to the timer or stopwatch
    if (firstTimerRunning) {
      //For Timer (GREY background & green wave)
      backgroundColor = greyBackground;
      waveColor = AlwaysStoppedAnimation(greenTimerAccent);

      //calculate top number (+1 second handles a rounded error)
      Duration durationLeft = widget.exercise.recoveryPeriod -
          totalDurationPassed +
          Duration(seconds: 1);

      List<String> durLeftStrs = durationToCustomDisplay(durationLeft);
      String durLeftString = durLeftStrs[0] + " : " + durLeftStrs[1];
      topNumber = durLeftString;

      //set progress value
      progressValue = timesToValue(
          totalDurationPassed, widget.changeableTimerDuration.value);
    } else {
      //For Stopwatch (red background & GREY background)
      backgroundColor =
          (withinMaxDuration) ? redStopwatchAccent : Colors.transparent;
      waveColor = AlwaysStoppedAnimation(
        //when the stopwatch finishes we want our screen to be full red all the time
        (withinMaxDuration) ? greyBackground : Colors.transparent,
      );

      //calculate top Number
      List<String> extraDurStrings =
          durationToCustomDisplay(extraDurationPassed);
      String extraDurationString =
          extraDurStrings[0] + " : " + extraDurStrings[1];
      topNumber = extraDurationString;

      //---generate the progress values
      //make generate the proper progress value (we dont want it to jump)
      //thankfully since our max setable time is 4:55 and our actual max wait time is 5 minutes
      //we know we will have atleast 5 seconds for the 2nd progress bar to jump from bottom to top

      //maxDuration = maxEffectiveBREAKduration NOT maxEffectiveTIMERduration
      if (withinMaxDuration == false)
        progressValue = 1;
      else {
        //between 0 and 1
        progressValue = timesToValue(
          totalDurationPassed - widget.changeableTimerDuration.value,
          maxBreakDuration - widget.changeableTimerDuration.value,
        );
      }
    }

    //just in case for small floating point "mistakes"
    progressValue = progressValue.clamp(0.0, 1.0);

    //-------------------------Optimize Above-------------------------

    Widget changeTimeWidget = Positioned.fill(
      child: Material(
        color: Colors.transparent,
        child: Theme(
          data: MyTheme.light,
          child: ActualButton(
            color: Theme.of(context).scaffoldBackgroundColor,
            changeableTimerDuration: widget.changeableTimerDuration,
          ),
        ),
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
            Positioned(
              top: 0,
              left: 0,
              child: VibrationSwitch(),
            ),
            Positioned(
              top: 0,
              right: 0,
              child: NotificationSwitch(
                exercise: widget.exercise,
              ),
            ),
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
                          Conditional(
                            condition: maxTimerController.value == 1,
                            ifTrue: Stack(
                              children: [
                                changeTimeWidget,
                                Positioned.fill(
                                  child: Center(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: <Widget>[
                                        Container(
                                          child: infoButton,
                                        ),
                                        Container(
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            children: <Widget>[
                                              Expanded(
                                                child: Container(),
                                              ),
                                              Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    5,
                                                child: Container(
                                                  padding: EdgeInsets.only(
                                                    top: 16,
                                                  ),
                                                  child: FittedBox(
                                                    fit: BoxFit.contain,
                                                    child: Stack(
                                                      children: <Widget>[
                                                        OnlyEditButton(
                                                          durationString:
                                                              breakTimeString,
                                                        ),
                                                        changeTimeWidget,
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Container(),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            ifFalse: Stack(
                              children: [
                                changeTimeWidget,
                                Center(
                                  child: TimeDisplay(
                                    textContainerSize:
                                        MediaQuery.of(context).size.width -
                                            (24 * 2),
                                    topNumber: topNumber,
                                    breakTime: breakTimeString,
                                    timePassed: totalDurationPassed,
                                    //easy variables
                                    topArrowUp: widget.showArrows
                                        ? (firstTimerRunning ? false : true)
                                        : null,
                                    isTimer: (firstTimerRunning) ? true : false,
                                    showBottomArrow:
                                        widget.showArrows ? true : false,
                                    showIcon: widget.showIcon,
                                    changeTimeWidget: changeTimeWidget,
                                  ),
                                ),
                              ],
                            ),
                          ),
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
  }
}
