//flutter
import 'package:flutter/material.dart';

//internal
import 'package:swol/action/tabs/recovery/secondary/explained.dart';
import 'package:swol/shared/widgets/complex/fields/headers/ourInformationPopUp.dart';
import 'package:swol/shared/methods/theme.dart';

//widget
class InfoOutlineWhiteButton extends StatelessWidget {
  const InfoOutlineWhiteButton({
    Key? key,
    required this.showAreYouSure,
    required this.totalDurationPassed,
    required this.selectedDuration,
    required this.isWhite,
  }) : super(key: key);

  final ValueNotifier<bool> showAreYouSure;
  final Duration totalDurationPassed;
  final Duration selectedDuration;
  final bool isWhite;

  @override
  Widget build(BuildContext context) {
    //text for pop ups and button
    String trainingSelected = durationToTrainingType(
      selectedDuration,
    );
    String trainingBreakGoodFor = durationToTrainingType(
      totalDurationPassed,
    );

    //are you sure?
    Duration buffer = Duration(seconds: 15);
    bool withinTrainingType = (trainingSelected == trainingBreakGoodFor);

    //determine what section to focus on first when the user is looking for guidance
    int sectionWithInitialFocus;
    if (totalDurationPassed <= Duration(minutes: 1))
      sectionWithInitialFocus = 0; //endurance
    else if (totalDurationPassed < Duration(minutes: 3))
      sectionWithInitialFocus = 1; //hypertrohpy
    else
      sectionWithInitialFocus = 2; //strength

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
        showAreYouSure: showAreYouSure,
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
    Key? key,
    required this.showAreYouSure,
    required this.withinTrainingTypeRange,
    required this.buffer,
    required this.selectedDuration,
    required this.trainingName,
    required this.totalDurationPassed,
    required this.showInfo,
    required this.isWhite,
  }) : super(key: key);

  final ValueNotifier<bool> showAreYouSure;
  final bool withinTrainingTypeRange;
  final Duration buffer;
  final Duration selectedDuration;
  final String trainingName;
  final Duration totalDurationPassed;
  final Function showInfo;
  final bool isWhite;

  @override
  Widget build(BuildContext context) {
    //the two varialbes that will inform the user what is happening
    String primaryMsg;
    String secondaryMsg;

    //fill the message given the conditions
    bool stillTimeLeft = totalDurationPassed < selectedDuration;
    showAreYouSure.value = false; //its false in most cases
    if (stillTimeLeft) {
      //if you are more than 30 seconds away from the selectied time
      //then bring up the pop up
      bool within30secondBuffer =
          (totalDurationPassed + Duration(seconds: 30)) >= selectedDuration;
      if (within30secondBuffer == false)
        showAreYouSure.value = true;
      else
        showAreYouSure.value =
            false; //we are within the buffer so don't show the pop up

      //what text to sho
      if (withinTrainingTypeRange == false) {
        primaryMsg = "Currently Recovering From";
        if (trainingName.length > 0) {
          secondaryMsg = trainingName + " Training";
        } else {
          secondaryMsg = "Your Last Set";
        }
      } else {
        primaryMsg = "You Should Wait For Full Recovery";
        secondaryMsg = "But You Are Ready For ";
        if (trainingName.length > 0) {
          secondaryMsg += trainingName + " Training";
        } else {
          secondaryMsg += "Your Next Set";
        }
      }
    } else {
      //your timer is over but you still have some time
      if (withinTrainingTypeRange) {
        if (trainingName.length > 0) {
          primaryMsg = "Move To Your Next Set";
          secondaryMsg = "You're Within " + trainingName + " Training Range";
        } else {
          primaryMsg = "You Can Move To Your Next Set";
          secondaryMsg = "Whenever You're Ready";
        }
      } else {
        if ((totalDurationPassed - buffer) < selectedDuration) {
          primaryMsg = "Move To Your Next Set";
          secondaryMsg = "Quickly!";
        } else {
          if (totalDurationPassed < (Duration(minutes: 5) + buffer)) {
            primaryMsg = "You Waited Too Long";
            secondaryMsg = "Quickly! Move On Before You Cool Down!";
          } else {
            if (totalDurationPassed < Duration(hours: 1, minutes: 30)) {
              primaryMsg = "You Waited Too Long";
              secondaryMsg = "Don't Worry! Just Do A Warm Up Set";
            } else {
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
                color: isWhite
                    ? Colors.white.withOpacity(0.5)
                    : Theme.of(context).primaryColorDark,
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
                    color: isWhite
                        ? Colors.white
                        : Theme.of(context).primaryColorDark,
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
          )),
    );
  }
}
