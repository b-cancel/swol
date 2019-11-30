import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import 'package:swol/excerciseAction/tabs/recovery/secondary/explained.dart';
import 'package:swol/excerciseAction/tabs/recovery/secondary/timeDisplay.dart';
import 'package:swol/excerciseAction/tabs/recovery/timer/changeTime.dart';
import 'package:swol/utils/vibrate.dart';

//the pulse that activates after our timer starts uses one of these libraries
import 'package:progress_indicators/progress_indicators.dart';
import 'package:loading_indicator_view/loading_indicator_view.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

//build
class LiquidTime extends StatefulWidget {
  LiquidTime({
    @required this.timerStart,
    @required this.changeableTimerDuration,
    this.maxDuration: const Duration(minutes: 5),
    this.showArrows: true,
    this.showIcon: true,
    
  });

  //initial controller set
  final DateTime timerStart;
  //time before we go any level of red
  final ValueNotifier<Duration> changeableTimerDuration;
  //total time before we go full red
  final Duration maxDuration;
  //smaller settings
  final bool showArrows;
  final bool showIcon;

  @override
  State<StatefulWidget> createState() => _LiquidTimeState();
}

class _LiquidTimeState extends State<LiquidTime> with TickerProviderStateMixin {
  //main Controller
  AnimationController controllerLonger; //never changes after init
  AnimationController controllerShorter; //might change after init

  //function removable from listeners
  updateState(){
    if(mounted) setState(() {});
  }

  /*

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
  */

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

  //init
  @override
  void initState() {
    //super init
    super.initState();

    //how much has already passed in the background
    Duration removeFromTotal = DateTime.now().difference(widget.timerStart);
    //our max value is 9:99
    //so our max duration is 10
    //after that the ammount of time overflowed is kind of irrelvant
    //because you know for a fact your muscles are super cold
    Duration longDuration = Duration(minutes: 10) - removeFromTotal;
    if(longDuration <= Duration.zero) longDuration = Duration(seconds: 1);

    //create animation controller
    controllerLonger = AnimationController(
      vsync: this,
      duration: longDuration,
    );
    
    //TODO: if we return and we are either KINDA red -> startVibrtion
    //TODO: or FULL red -> start vibration
    //start vibrating again if the user turned off vibration
    /*
    Future.delayed(
      widget.maxDuration,
      (){
        if(mounted) Vibrator.startVibration();
      }
    );
    */

    //refresh UI at phone framerate
    controllerLonger.addListener(updateState);
    widget.changeableTimerDuration.addListener(updateState);

    //start the stopwatch
    controllerLonger.forward();
  }

  @override
  void dispose() {
    widget.changeableTimerDuration.removeListener(updateState);
    controllerLonger.removeListener(updateState);
    
    //controller dispose
    controllerLonger.dispose();

    //stop vibrating
    Vibrator.stopVibration();

    //super dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color greyBackground =  Color(0xFFBFBFBF);

    //---the glowing indicator that we may or may not use
    
    //max size of pusler given width and nanually set padding
    double maxWidthIndicator = MediaQuery.of(context).size.width + (24.0 * 2);

    //in case at some point I want to switch between indicators
    Duration pusleDuration = Duration(milliseconds: 1000);
    List<Widget> pulsingBackgrounds = [
      //import 'package:flutter_spinkit/flutter_spinkit.dart';
      SpinKitDualRing(
        lineWidth: maxWidthIndicator/2,
        color: Colors.white,
        size: maxWidthIndicator,
        duration: pusleDuration,
      ),
      SpinKitDoubleBounce( //ABBY LIKED
        color: Colors.white,
        size: maxWidthIndicator,
        duration: pusleDuration,
      ),
      //import 'package:loading_indicator/loading_indicator.dart';
      LoadingIndicator(
        indicatorType: Indicator.ballScaleMultiple,
        color: Colors.white,
      ),
      LoadingIndicator(
        indicatorType: Indicator.ballScale, 
        color: Colors.white,
      ),
      //import 'package:progress_indicators/progress_indicators.dart';
      GlowingProgressIndicator( //KOBE LIKED
        child: Container(
          color: Colors.red.withOpacity(0.75),
        ),
        duration: Duration(milliseconds: 5000),
      ),
    ];

    //pusling backgrond widget that may or may not be used
    Widget pulsingBackground = Container(
      color: greyBackground,
      child: Stack(
        children: <Widget>[
          //pulsingBackgrounds[4],
          Container(
            color: Colors.red,
          ),
          Container(
            alignment: Alignment.center,
            width: maxWidthIndicator,
            height: maxWidthIndicator,
            child: pulsingBackgrounds[1],
          ),
          
        ],
      ),
    );

    //---calculate total time passed and react based on the result
    Duration totalDurationPassed = DateTime.now().difference(widget.timerStart);

    //---determine what section to focus on first when the user is looking for guidance
    int sectionWithInitialFocus;
    if(totalDurationPassed <= Duration(minutes: 1)) sectionWithInitialFocus = 0;
    else if(totalDurationPassed < Duration(minutes: 3)) sectionWithInitialFocus = 1;
    else sectionWithInitialFocus = 2;

    //---set main widget based on total duration passed
    Widget mainWidget;

    //super red gives us a completely different widget
    if(totalDurationPassed >= Duration(minutes: 10)){
      //TODO: just glowing indicator with some special text in front
      /*
      "You Waited Too Long";
        lateFor = "you need to warm up again";
      */
      /*
      Container(
            
      */
      mainWidget = Container(
        height: MediaQuery.of(context).size.width,
        width: MediaQuery.of(context).size.width, //3.25/5
        padding: EdgeInsets.all(24),
        child: ClipOval(
          child: Stack(
            children: <Widget>[
              pulsingBackground,
              Positioned.fill(
                child: FittedBox(
                  fit: BoxFit.contain,
                  child: Padding(
                    padding: EdgeInsets.all(24.0),
                    child: OutlineButton(
                      highlightedBorderColor: Theme.of(context).accentColor,
                      borderSide: BorderSide(
                        color: Theme.of(context).primaryColor,
                      ),
                      onPressed: () => explainFunctionalityPopUp(sectionWithInitialFocus),
                      padding: EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      child: DefaultTextStyle(
                        style: TextStyle(
                          color: Theme.of(context).primaryColorDark,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "You Waited Too Long",
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text("you need to warm up again"),
                            Text(
                              totalDurationPassed.inSeconds.toString() + " minutes",
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      );
      
      /*
      Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          topInfoButton,
          timeWidget,
        ],
      );
      */
    }
    else{ //either we are half red or not red at all
      List<String> totalDurationPassedStrings = durationToCustomDisplay(totalDurationPassed);
      String totalDurationString = totalDurationPassedStrings[0] + " : " + totalDurationPassedStrings[1]; //bottom right for ?
      //if the total time passed overflows
      //then our timer has run as much as possible
      //so we overflow the larger top number as well
      if(totalDurationPassedStrings[1] == "99"){
        totalDurationString = "9 : 99";
      }

      //chosen colors
      final Color greenTimerAccent = Theme.of(context).accentColor;
      final Color redStopwatchAccent = Colors.red;

      //---calculate string for timer duration
      List<String> timerDurationStrings = durationToCustomDisplay(widget.changeableTimerDuration.value);
      String timerDurationString = timerDurationStrings[0] + " : " + timerDurationStrings[1];

      //---calculate extra time passed
      Duration extraDurationPassed = Duration.zero;
      if(totalDurationPassed > widget.changeableTimerDuration.value){
        extraDurationPassed = totalDurationPassed - widget.changeableTimerDuration.value;
      }

      //simplifying varaible for the merge of timer and stopwatch widgets
      bool firstTimerRunning = (extraDurationPassed == Duration.zero);
      bool withinMaxDuration = (totalDurationPassed <= widget.maxDuration);

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

        //calculate top number
        Duration durationLeft = widget.changeableTimerDuration.value - totalDurationPassed + Duration(seconds: 1);
        List<String> durationLeftStrings = durationToCustomDisplay(durationLeft);
        String durationLeftString = durationLeftStrings[0] + " : " + durationLeftStrings[1]; //top number for timer
        topNumber = durationLeftString;

        //set progress value
        progressValue = totalDurationPassed.inMicroseconds / widget.changeableTimerDuration.value.inMicroseconds;
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
        
        if(withinMaxDuration == false) progressValue = 1;
        else{ //between 0 and 1
          //Output: 0 -> 1
          //Input: widget.changeableTimerduration.value -> Duration(minutes 5)
          //Input: 0 -> fiveMinutes - widget.changeabletimerDuration.value
          Duration totalStopwatchAnimation = widget.maxDuration - widget.changeableTimerDuration.value;
          //Input: 0 -> totalStopwatchAnimation (MIN of 5 seconds)
          //Output: 0 -> 1
          Duration adjustedTimePassed = totalDurationPassed - widget.changeableTimerDuration.value;

          //determine how far we have progressed within range
          progressValue = adjustedTimePassed.inMicroseconds / totalStopwatchAnimation.inMicroseconds;
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
      //TODO: double check
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
                  pulsingBackground,
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
                        onTap: (){
                          maybeChangeTime(
                            context: context,
                            recoveryDuration: widget.changeableTimerDuration,
                          );
                        },
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
          Positioned(
            top: 0,
            left: 0,
            child: Visibility(
              visible: (Vibrator.isVibrating) ? true : false,
              child: IconButton(
                padding: EdgeInsets.all(32),
                tooltip: 'Turn Off Vibration',
                onPressed: (){
                  Vibrator.stopVibration();
                },
                icon: Icon(
                  FontAwesomeIcons.bellSlash, //solidBellSlash
                ),
              ),
            ),
          )
        ],
      );

      mainWidget = Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          topInfoButton,
          timeWidget,
        ],
      );
    }
    
    //build return timer
    return Container(
      width: MediaQuery.of(context).size.width,
      child: mainWidget,
    );
  }
}