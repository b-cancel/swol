//flutter
import 'package:flutter/material.dart';

//internal
import 'package:swol/action/tabs/recovery/secondary/explained.dart';
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
            secondaryMsg = "Quickly! Move On Before You Cool Down!";
          }
          else{
            if(totalDurationPassed < Duration(hours: 1, minutes: 30)){
              primaryMsg = "You Waited Too Long";
              secondaryMsg = "Don't Worry! Just Do A Warm Up Set";
            }
            else{
              primaryMsg = "Mark Your Sets Complete";
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
                    Text(
                      primaryMsg ?? "",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      secondaryMsg ?? "",
                      style: TextStyle(
                        fontSize: 12,
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