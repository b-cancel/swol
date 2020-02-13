import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:swol/action/page.dart';
import 'package:swol/action/popUps/reusable.dart';
import 'package:swol/main.dart';
import 'package:swol/shared/structs/anExcercise.dart';

//determine whether we should warn the user
warningThenAllowPop(
  BuildContext context, 
  AnExcercise excercise,
{bool alsoPop: false}) {
    DateTime startTime = excercise.tempStartTime.value;
    bool timerNotStarted = (startTime == AnExcercise.nullDateTime);

    //if the timer hasn't yet started we may need to bring up the pop up
    if (timerNotStarted) {
      //handle weight
      String weight = ExcercisePage.setWeight.value;
      bool weightValid =  weight != "" && weight != "0";

      //hanlde reps
      String reps = ExcercisePage.setReps.value;
      bool repsValid = reps != "" && reps != "0";

      //since this isthe warning we only care of atleast one if filled
      //else we assume a misclick
      if (weightValid || repsValid) {
        //NOTE: this assumes the user CANT type anything except digits of the right size
        bool setValid = weightValid && repsValid;

        //remove focus so the pop up doesnt bring it back
        FocusScope.of(context).unfocus();

        //bring up pop up
        AwesomeDialog(
          context: context,
          isDense: false,
          dismissOnTouchOutside: true,
          dialogType: DialogType.WARNING,
          animType: AnimType.LEFTSLIDE,
          headerAnimationLoop: false,
          body: Column(
            children: [
              Text(
                "Begin Your Set Break",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: Colors.black,
                ),
              ),
              Text(
                "to avoid losing your set",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: 16,
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 24.0,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SetDescription(
                        weight: weight,
                        reps: reps,
                      ),
                      SetProblem(
                        weightValid: weightValid, 
                        repsValid: repsValid,
                        setValid: setValid,
                      ),
                      Visibility(
                        visible: setValid == false,
                        child: PartiallyInvalidSetWarning(),
                      ),
                      Visibility(
                        visible: setValid,
                        child: ValidSetWarning(),
                      ),
                      //-------------------------Reps-------------------------
                      Transform.translate(
                        offset: Offset(0, 16),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Expanded(
                              child: Container(),
                            ),
                            FlatButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                                goBack(context, true);
                              },
                              child: Text(
                                "No, Delete The Set",
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            RaisedButton(
                              color: Colors.blue,
                              onPressed: () => Navigator.of(context).pop(),
                              child: Text(
                                "Yes, Go Back",
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
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
        ).show();

        //don't allow popping automatically
        return false;
      } else { //both invalid so pop as expected
        goBack(context, alsoPop);
        return true;
      }
    } else { //timer has started so no need to limit the user
      //TODO: perhaps there is
      goBack(context, alsoPop);
      return true;
    }
  }

class ValidSetWarning extends StatelessWidget {
  const ValidSetWarning({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: TextStyle(
          color: Colors.black,
        ),
        children: [
          TextSpan(
            text: "But if you don't ",
          ),
          TextSpan(
            text: "Begin Your Set Break",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          TextSpan(
            text: ", this set will be lost. ",
          ),
          TextSpan(
            text: "Would you like to ",
          ),
          TextSpan(
            text: "Go Back",
            style: TextStyle( 
              fontWeight: FontWeight.bold,
            ),
          ),
          TextSpan(
            text: " and Begin Your Set Break?",
          ),
        ],
      ),
    );
  }
}

class PartiallyInvalidSetWarning extends StatelessWidget {
  const PartiallyInvalidSetWarning({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: TextStyle(
          color: Colors.black,
        ),
        children: [
          TextSpan(
            text: "If you don't ",
          ),
          TextSpan(
            text: "Fix Your Set",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          TextSpan(
            text: ", this information will be lost. ",
          ),
          TextSpan(
            text: "Would you like to ",
          ),
          TextSpan(
            text: "Go Back",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          TextSpan(
            text: " and Fix Your Set?",
          ),
        ],
      ),
    );
  }
}

goBack(BuildContext context, bool alsoPop) {
  //may have to unfocus
  FocusScope.of(context).unfocus();
  //animate the header
  App.navSpread.value = false;
  //pop if not using the back button
  if (alsoPop) Navigator.of(context).pop();
}