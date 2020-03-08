//flutter
import 'package:flutter/material.dart';

//plugin
import 'package:awesome_dialog/awesome_dialog.dart';

//internal
import 'package:swol/shared/structs/anExercise.dart';
import 'package:swol/action/popUps/textValid.dart';
import 'package:swol/action/popUps/reusable.dart';
import 'package:swol/action/popUps/button.dart';
import 'package:swol/action/page.dart';

toNextSet(){
  ExercisePage.updateSet.value = true; //start the set
  ExercisePage.pageNumber.value = 2; //shift to the timer page
}

//function
maybeError(
  BuildContext context, 
  AnExercise exercise, 
  DateTime startTime,
) {
  //TODO: ideally we let the user skip the step
  bool keyboardOpen = FocusScope.of(context).hasFocus;
  if(keyboardOpen){
    FocusScope.of(context).unfocus();
  }
  else{
    //grab data
    String weight = ExercisePage.setWeight.value;
    String reps = ExercisePage.setReps.value;

    //validity
    bool weightValid = isTextValid(weight);
    bool repsValid = isTextValid(reps);
    bool setValid = weightValid && repsValid;

    //we are valid and can therefore move on
    if(setValid){
      toNextSet();
    }
    else{
      //change the buttons shows a the wording a tad\
    bool timerNotStarted = startTime == AnExercise.nullDateTime;
    String continueString =
        (timerNotStarted) ? "Begin Your Set Break" : "Return To Your Break";

    //show the dialog
    AwesomeDialog(
      context: context,
      isDense: false,
      onDissmissCallback: () {
        //If the pop up came up the values typed are not valid
        //if we reverted then the refocus will do nothing
        //since the function will see that both values are valid
        ExercisePage.causeRefocusIfInvalid.value = true;
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
                          exercise: exercise,
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
      btnCancel: timerNotStarted ? null : AwesomeButton(
        clear: true,
        child: Text(
          "Revert Back",
        ), 
        onTap: () {
          //revert back (no need to update set)
          //we KNOW the temps are VALID
          //else the timer would not have started
          ExercisePage.setWeight.value = exercise.tempWeight.toString();
          ExercisePage.setReps.value = exercise.tempReps.toString();

          //pop ourselves
          toNextSet();
          //will call "onDissmissCallback"
        },
      ),
      btnOk: timerNotStarted ? null : AwesomeButton(
        child: Text(
          "Let Me Fix It",
        ),
        onTap: () {
          //pop ourselves
          Navigator.of(context).pop();
          //will call "onDissmissCallback"
        },
      ),
    ).show();
    }
  }
}
