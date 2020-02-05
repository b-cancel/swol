//flutter
import 'package:flutter/material.dart';

//internal
import 'package:swol/excerciseAction/tabs/recovery/secondary/explained.dart';
import 'package:swol/shared/widgets/complex/fields/headers/ourInformationPopUp.dart';
import 'package:swol/shared/methods/theme.dart';

/*
-------------------------the button-------------------------

*****before you pass your designated time
1. "Recoverying For Your Next Set"
2. *what training type you are ready for*

*****after you pass your designated time
1. "Move onto your next set"
2. *what training type you are ready for*

*****after 5 minutes
1. "You might have to warm up again" (2.5 minutes from select time) 

*****after 10 minutes
1. "You Waited Too long"
2. its been X time since your last set

*****after so much longer its logical to assume they just forgot to stop it
1. "You Must've Forgot To Finish"
2. its been x time since your last set

-------------------------the pop up-------------------------

*****before
title: "Wait!"
subtitle: "finish recoverying for your next set"

*****after
title: "Move " 

*****after 5

*****after 10

*****after ridic
title: Its Been Way Too Long
subtitle: You Must've Forgotten To Finish
*/

//"you must warm up again for optimal results"

//widget
class InfoOutlineWhiteButton extends StatelessWidget {
  const InfoOutlineWhiteButton({
    Key key,
    @required this.firstTimerRunning,
    @required this.totalDurationPassed,
  }) : super(key: key);

  final bool firstTimerRunning;
  final Duration totalDurationPassed;

  @override
  Widget build(BuildContext context) {
    //determine what section to focus on first when the user is looking for guidance
    int sectionWithInitialFocus;
    if(totalDurationPassed <= Duration(minutes: 1)) sectionWithInitialFocus = 0; //endurance
    else if(totalDurationPassed < Duration(minutes: 3)) sectionWithInitialFocus = 1; //hypertrohpy
    else sectionWithInitialFocus = 2; //strength

    //generate function
    Function showInfo = () => infoPopUpFunction(
      //using white context
      //assumed for the users within this class
      context,
      //vars
      title: "Wait",
      subtitle: "to finish recoverying",
      isDense: true,
      body: ExplainFunctionality(
        sectionWithInitialFocus: sectionWithInitialFocus,
      ),
    );

    //return inner widget in dark mode
    return Theme(
      data: MyTheme.dark,
      child: InfoOutlineDarkButton(
        firstTimerRunning: firstTimerRunning,
        totalDurationPassed: totalDurationPassed,
        showInfo: showInfo,
      ),
    );
  }
}

class InfoOutlineDarkButton extends StatelessWidget {
  const InfoOutlineDarkButton({
    Key key,
    @required this.firstTimerRunning,
    @required this.totalDurationPassed,
    @required this.showInfo,
  }) : super(key: key);

  final bool firstTimerRunning;
  final Duration totalDurationPassed;
  final Function showInfo;

  @override
  Widget build(BuildContext context) {
    //initially tells the user what happening
    //then explains they can no longer to the training type behind the one they were aiming for
    String extraMessage = firstTimerRunning ? "Recoverying For Next Set" : "Move Onto Your Next Set";
    
    //reminds the user what this duration of break is good for
    String readyFor; //only empty for the first 15 seconds

    //we are ready for some type of workout
    if(totalDurationPassed < Duration(seconds: 15) == false 
    && Duration(minutes: 5) < totalDurationPassed == false){
      readyFor = "Ready For ";
      if(totalDurationPassed < Duration(minutes: 1)){ //15s to 1m
        readyFor += "Endurance";
      } 
      else{
        if(totalDurationPassed < Duration(minutes: 2)){ //to 2m hypertrophy
          readyFor += "Hypertrophy";
        }
        else if(totalDurationPassed < Duration(minutes: 3)){ //to 3m hypertrophy or strength
          readyFor += "Hypertrophy/Strength";
        }
        else{ //to 5m strength
          readyFor += "Strength";
        }
      }
      readyFor += " Training";
    }

    if(extraMessage == null && readyFor == null){// && lateFor == null){
      extraMessage = "You Waited Too Long";
      //lateFor = "you need to warm up again";
    }

    return FittedBox(
      fit: BoxFit.contain,
      child: Padding(
        padding: EdgeInsets.only(
          top: 12,
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 12,
          ),
          child: OutlineButton(
            highlightedBorderColor: Theme.of(context).accentColor,
            onPressed: () => showInfo(),
            padding: EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 4,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Visibility(
                  visible: extraMessage != null,
                  child: Text(
                    extraMessage ?? "",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
                Visibility(
                  visible: readyFor != null,
                  child: Text(
                    readyFor ?? "",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: extraMessage == null ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
              ],
            ),
          )
        ),
      ),
    );
  }
}

/*
RichText(
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
*/

/*
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
*/

/*
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
*/

//(wholeSeperateWorkout) ? "You Forgot To Finish" : "You Waited Too Long",

/*
Center(
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
*/