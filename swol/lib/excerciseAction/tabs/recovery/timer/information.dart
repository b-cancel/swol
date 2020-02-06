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
    @required this.areYouSurePopUp,
    @required this.totalDurationPassed,
    @required this.selectedDuration,
    @required this.isWhite,
  }) : super(key: key);

  final ValueNotifier<bool> areYouSurePopUp;
  final Duration totalDurationPassed;
  final Duration selectedDuration;
  final bool isWhite;

  @override
  Widget build(BuildContext context) {
    //text for pop ups and button
    String trainingSelected = durationToTrainingType(
      selectedDuration,
      zeroIsEndurance: false,
    );
    String trainingBreakGoodFor = durationToTrainingType(
      totalDurationPassed, 
      zeroIsEndurance: false,
    );

    //are you sure?
    Duration buffer = Duration(seconds: 15);
    bool withinTrainingType = (trainingSelected == trainingBreakGoodFor);
    if (withinTrainingType)
      areYouSurePopUp.value = withinTrainingType;
    else {
      Duration lowerBound = selectedDuration - buffer;
      Duration upperBound = selectedDuration + buffer;
      areYouSurePopUp.value = (lowerBound <= totalDurationPassed &&
          totalDurationPassed <= upperBound);
    }

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
      title: "Wait To Recover",
      subtitle: "before moving onto your next set",
      isDense: true,
      body: ExplainFunctionality(
        trainingName: trainingSelected,
        sectionWithInitialFocus: sectionWithInitialFocus,
      ),
    );

    //return inner widget in dark mode
    return Theme(
      data: MyTheme.dark,
      child: InfoOutlineDarkButton(
        trainingName: trainingSelected,
        withinTrainingTypeRange: withinTrainingType,
        buffer: buffer,
        totalDurationPassed: totalDurationPassed,
        selectedDuration: selectedDuration,
        showInfo: showInfo,
        isWhite: isWhite,
      ),
    );
  }
}

class InfoOutlineDarkButton extends StatelessWidget {
  const InfoOutlineDarkButton({
    Key key,
    @required this.withinTrainingTypeRange,
    @required this.buffer,
    @required this.selectedDuration,
    @required this.trainingName,
    @required this.totalDurationPassed,
    @required this.showInfo,
    @required this.isWhite,
  }) : super(key: key);

  final bool withinTrainingTypeRange;
  final Duration buffer;
  final Duration selectedDuration;
  final String trainingName;
  final Duration totalDurationPassed;
  final Function showInfo;
  final bool isWhite;

  @override
  Widget build(BuildContext context) {
    //the two varialbes that will inform  the use what is happening
    String primaryMsg;
    String secondaryMsg;

    //fill the message given the conditions
    bool stillTimeLeft = totalDurationPassed < selectedDuration;
    if(stillTimeLeft){
      if(withinTrainingTypeRange == false){
        primaryMsg = "Currently Recovering From";
        secondaryMsg = trainingName + " Training";
      }
      else{
        primaryMsg = "You Should Wait For Full Recovery";
        secondaryMsg = "But You Are Ready For " + trainingName + " Training";
      }
    }
    else{
      if(withinTrainingTypeRange){
        primaryMsg = "Move To Your Next Set";
        secondaryMsg = "You're Within " + trainingName + " Training Range";
      }
      else{
        if((totalDurationPassed - buffer) < selectedDuration){
          primaryMsg = "Move To Your Next Set";
          secondaryMsg = "Quickly!";
        }
        else{
          if(totalDurationPassed < (Duration(minutes: 5) + buffer)){
            primaryMsg = "You Waited Too Long";
          }
          else{
            if(totalDurationPassed < Duration(hours: 1, minutes: 30)){
              primaryMsg = "You Waited Too Long";
              secondaryMsg = "you should warm up again";
            }
            else{
              primaryMsg = "Mark Your Set(s) Complete";
              secondaryMsg = "on the bottom left";
            }
          }
        }
      }
    }

    //return
    return Padding(
      padding: EdgeInsets.only(
        top: 24,
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 24,
        ),
        child: FittedBox(
          fit: BoxFit.contain,
          child: OutlineButton(
            highlightedBorderColor: Theme.of(context).accentColor,
            borderSide: BorderSide(
              color: isWhite ? Colors.white.withOpacity(0.5) : Theme.of(context).primaryColorDark,
              width: 2,
            ),
            onPressed: () => showInfo(),
            padding: EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 4,
            ),
            child: FittedBox(
              fit: BoxFit.contain,
              child: DefaultTextStyle(
                style: TextStyle(
                  color: isWhite ? Colors.white : Theme.of(context).primaryColorDark,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Visibility(
                      visible: primaryMsg != null,
                      child: Text(
                        primaryMsg ?? "",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    Visibility(
                      visible: secondaryMsg != null,
                      child: Text(
                        secondaryMsg ?? "",
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        )
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

*/