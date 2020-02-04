//flutter
import 'package:flutter/material.dart';

//internal
import 'package:swol/excerciseAction/tabs/recovery/secondary/explained.dart';
import 'package:swol/shared/widgets/complex/fields/headers/ourInformationPopUp.dart';
import 'package:swol/shared/methods/theme.dart';

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
    if(totalDurationPassed <= Duration(minutes: 1)) sectionWithInitialFocus = 0;
    else if(totalDurationPassed < Duration(minutes: 3)) sectionWithInitialFocus = 1;
    else sectionWithInitialFocus = 2;

    //generate function
    Function showInfo = () => infoPopUpFunction(
      //using white context
      //assumed for the users within this class
      context,
      //vars
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
                Visibility(
                  visible: lateFor != null,
                  child: Text(
                    lateFor ?? "",
                    style: TextStyle(
                      fontSize: 10,
                    ),
                  ),
                )
              ],
            ),
          )
        ),
      ),
    );
  }
}