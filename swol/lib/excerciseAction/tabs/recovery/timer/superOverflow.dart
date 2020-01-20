import 'package:flutter/material.dart';
import 'package:swol/excerciseAction/tabs/recovery/secondary/timeDisplay.dart';
import 'package:swol/excerciseAction/tabs/recovery/timer/turnOffVibration.dart';
import 'package:swol/other/durationFormat.dart';

class SuperOverflow extends StatelessWidget {
  SuperOverflow({
    @required this.totalDurationPassed,
    @required this.recoveryDurationString,
    @required this.updateState,
    @required this.explainFunctionality,
    @required this.maybeChangeRecoveryDuration,
  });

  final Duration totalDurationPassed;
  final String recoveryDurationString;
  final Function updateState;
  final Function explainFunctionality;
  final Function maybeChangeRecoveryDuration;

  @override
  Widget build(BuildContext context) {
    //set duration string
    String durationString;
    if(totalDurationPassed > Duration(days: 1)){
      //NOTE: nobodies workout is going to be this long
      durationString = "over a day";
    }
    else{
      //basically only show 1. hours 2. minutes
      durationString = DurationFormat.format(
        totalDurationPassed, 
        //show shorter version (aesthetic)
        short: false,
        //don't show anything larger than 24 horus
        showYears: false, 
        showMonths: false, 
        showWeeks: false, 
        showDays: false,
        //dont't show anything smaller than a minute (since seconds don't update)
        showSeconds: false,
        showMilliseconds: false,
        showMicroseconds: false,
      );
    }
    
    //check if they its REASONABLE that they just forgot and haven't finished their workout
    bool wholeSeperateWorkout = totalDurationPassed > Duration(hours: 1, minutes: 30);

    Widget timePassedSuggestion = Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        //---Main thing
        Text(
          (wholeSeperateWorkout) ? "You Forgot To Finish" : "You Waited Too Long",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        //---time since
        RichText(
          text: TextSpan(
            style: TextStyle(
              color: Theme.of(context).primaryColorDark,
            ),
            children: [
              TextSpan(
                text: "it's been ",
              ),
              TextSpan(
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
                text: durationString,
              ),
              TextSpan(
                text: " since your last set",
              ),
            ],
          ),
        ),
        //---Instruction
        (wholeSeperateWorkout == false) ? Text("you must warm up again for optimal results")
        : RichText(
          text: TextSpan(
            style: TextStyle(
              color: Theme.of(context).primaryColorDark,
            ),
            children: [
              TextSpan(
                text: "you can do so in the ",
              ),
              TextSpan(
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
                text: "bottom left",
              ),
              TextSpan(
                text: " corner",
              ),
            ],
          ),
        ),
      ],
    );

    //widget output
    return Container(
      height: MediaQuery.of(context).size.width,
      width: MediaQuery.of(context).size.width, 
      padding: EdgeInsets.all(24),
      child: Stack(
        children: <Widget>[
          ClipOval(
            child: Stack(
              children: <Widget>[
                /*
                PulsingBackground(
                  width: MediaQuery.of(context).size.width,
                ),
                */
                Positioned.fill(
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: Padding(
                      padding: EdgeInsets.only(
                        //button size - half bordered part size
                        top: (24.0 + (16 * 2)) - 24,
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 24.0,
                        ),
                        child: Column(
                          children: <Widget>[
                            OutlineButton(
                              highlightedBorderColor: Theme.of(context).accentColor,
                              borderSide: BorderSide(
                                color: Theme.of(context).primaryColor,
                              ),
                              onPressed: () => explainFunctionality(),
                              padding: EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              child: DefaultTextStyle(
                                style: TextStyle(
                                  color: Theme.of(context).primaryColorDark,
                                ),
                                child: timePassedSuggestion,
                              ),
                            ),
                            Center(
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  highlightColor: Colors.white.withOpacity(.75),
                                  borderRadius: BorderRadius.circular(24),
                                  onTap: () => maybeChangeRecoveryDuration(),
                                  child: Container(
                                    padding: const EdgeInsets.all(12.0),
                                    child: ConstrainedBox(
                                      constraints: BoxConstraints(
                                        maxWidth: MediaQuery.of(context).size.width/6,
                                      ),
                                      child: FittedBox(
                                        fit: BoxFit.contain,
                                        child: DefaultTextStyle(
                                          style: TextStyle(
                                            color: Theme.of(context).primaryColorDark,
                                          ),
                                          child: EditIcon(
                                            text: recoveryDurationString,
                                            roundedRight: true,
                                          ),
                                        ),
                                      ),
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
              ],
            ),
          ),
          VibrationSwitch(
            updateState: updateState,
          ),
        ],
      ),
    );
  }
}