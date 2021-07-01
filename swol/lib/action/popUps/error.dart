//flutter
import 'package:flutter/material.dart';

//plugin
import 'package:awesome_dialog/awesome_dialog.dart';

//internal: shared
import 'package:swol/shared/widgets/simple/ourHeaderIconPopUp.dart';
import 'package:swol/shared/structs/anExercise.dart';

//internal: action
import 'package:swol/action/popUps/textValid.dart';
import 'package:swol/action/popUps/reusable.dart';
import 'package:swol/action/page.dart';

//function
toNextPageAfterSetUpdateComplete() {
  if (ExercisePage.updateSet.value) {
    //wait for the set to finish updating
    //NOTE: the statement is set back to false automatically
    //when its set to true, it updates stuff, then set itself to false
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      toNextPageAfterSetUpdateComplete();
    });
  } else {
    ExercisePage.pageNumber.value = 2; //shift to the timer page
  }
}

//function
maybeError(
  BuildContext context,
  AnExercise exercise,
) {
  bool keyboardOpen = FocusScope.of(context).hasFocus;
  if (keyboardOpen) {
    FocusScope.of(context).unfocus();
  } else {
    //grab data
    String weight = ExercisePage.setWeight.value;
    String reps = ExercisePage.setReps.value;

    //validity
    bool weightValid = isTextParsedIsLargerThan0(weight);
    bool repsValid = isTextParsedIsLargerThan0(reps);
    bool setValid = weightValid && repsValid;

    //we are valid and can therefore move on
    if (setValid) {
      //move onto the next set
      ExercisePage.updateSet.value = true; //start the set
      toNextPageAfterSetUpdateComplete();
    } else {
      //change the buttons shows a the wording a tad\
      bool timerNotStarted =
          (exercise.tempStartTime.value) == AnExercise.nullDateTime;
      String continueString =
          (timerNotStarted) ? "Begin Your Set Break" : "Return To Your Break";

      //show the dialog
      showBasicHeaderIconPopUp(
        context,
        [
          Text(
            "Fix Your Set",
            style: TextStyle(
              fontSize: 24,
            ),
          ),
          Text(
            "To " + continueString,
            style: TextStyle(
              fontSize: 14,
            ),
          ),
        ],
        [
          Padding(
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
                  textScaleFactor: MediaQuery.of(
                    context,
                  ).textScaleFactor,
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
        ],
        DialogType.ERROR,
        animationType: AnimType.BOTTOMSLIDE,
        clearBtn: timerNotStarted
            ? null
            : TextButton(
                child: Text(
                  "Revert Back",
                ),
                onPressed: () {
                  //revert back (no need to update set)
                  //we KNOW the temps are VALID
                  //else the timer would not have started
                  ExercisePage.setWeight.value = exercise.tempWeight.toString();
                  ExercisePage.setReps.value = exercise.tempReps.toString();

                  //pop ourselves
                  Navigator.of(context).pop();

                  //PRECAUTION: wait a frame to wait for setWeight and setReps to update
                  WidgetsBinding.instance?.addPostFrameCallback((_) {
                    ExercisePage.updateSet.value = true; //start the set
                    toNextPageAfterSetUpdateComplete();
                  });
                },
              ),
        colorBtn: timerNotStarted
            ? null
            : ElevatedButton(
                child: Text(
                  "Let Me Fix It",
                ),
                onPressed: () {
                  //pop ourselves
                  Navigator.of(context).pop();

                  //If the pop up came up the values typed are not valid
                  //if we reverted then the refocus will do nothing
                  //since the function will see that both values are valid
                  ExercisePage.causeRefocusIfInvalid.value = true;
                },
              ),
      );
    }
  }
}
