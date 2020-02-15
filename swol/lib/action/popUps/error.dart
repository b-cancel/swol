import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:swol/action/page.dart';
import 'package:swol/action/popUps/reusable.dart';
import 'package:swol/action/popUps/textValid.dart';
import 'package:swol/shared/structs/anExcercise.dart';

maybeError(BuildContext context, AnExcercise excercise) {
  //grab data
  String weight = ExcercisePage.setWeight.value;
  String reps = ExcercisePage.setReps.value;

  //validity
  bool weightValid = isTextValid(weight);
  bool repsValid = isTextValid(reps);
  bool setValid = weightValid && repsValid;

  //bring up the pop up if needed
  if (setValid) {
    ExcercisePage.updateSet.value = true; //start the set
    ExcercisePage.pageNumber.value = 2; //shift to the timer page
  } else {
    //NOTE: this assumes the user CANT type anything except digits of the right size

    //change the buttons shows a the wording a tad
    DateTime startTime = excercise.tempStartTime.value;
    bool timerNotStarted = startTime == AnExcercise.nullDateTime;
    String continueString =
        (timerNotStarted) ? "Begin Your Set Break" : "Return To Your Timer";

    //remove focus so the pop up doesnt bring it back
    FocusScope.of(context).unfocus();

    //show the dialog
    AwesomeDialog(
      context: context,
      isDense: false,
      onDissmissCallback: () {
        bool weightValid = isTextValid(ExcercisePage.setWeight.value);
        bool repsValid = isTextValid(ExcercisePage.setReps.value);
        bool setValid = weightValid && repsValid;

        //we will only need to refocus if your set is not valid
        if(setValid == false){
          ExcercisePage.causeRefocus.value = true;
        }
      },
      dismissOnTouchOutside: true,
      dialogType: DialogType.ERROR,
      animType: AnimType.BOTTOMSLIDE,
      headerAnimationLoop: false,
      body: Column(
        children: [
          Text(
            "Fix Your Set",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
              color: Colors.black,
            ),
          ),
          Text(
            "To " + continueString,
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
                    isError: true,
                  ),
                  SetProblem(
                    weightValid: weightValid,
                    repsValid: repsValid,
                    setValid: setValid,
                    isError: true,
                  ),
                  RichText(
                    text: TextSpan(
                      style: TextStyle(
                        color: Colors.black,
                      ),
                      children: [
                        TextSpan(
                          text: "Fix",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: " Your Set",
                          style: TextStyle(
                            fontWeight: timerNotStarted
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                        TextSpan(
                          text: " to " + continueString,
                        ),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: timerNotStarted == false,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        RevertToPrevious(
                          excercise: excercise,
                        ),
                        //-------------------------Butttons-------------------------
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
                                  //revert back (no need to update set)
                                  ExcercisePage.setWeight.value = excercise.tempWeight.toString();
                                  ExcercisePage.setReps.value = excercise.tempReps.toString();

                                  //pop ourselves
                                  Navigator.of(context).pop();
                                  //will call "onDissmissCallback"

                                  //continue as expected
                                  ExcercisePage.pageNumber.value = 2; //shift to the timer page
                                },
                                child: Text(
                                  "Revert Back",
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              RaisedButton(
                                color: Colors.blue,
                                onPressed: () {
                                  //pop ourselves
                                  Navigator.of(context).pop();
                                  //will call "onDissmissCallback"
                                },
                                child: Text(
                                  "Let Me Fix It",
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
                ],
              ),
            ),
          ),
        ],
      ),
    ).show();
  }
}
