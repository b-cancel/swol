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
      //MUST BE ABOVE UPDATE SET
      bool setUpdated =
          (exercise.tempWeight != null && exercise.tempReps != null);

      //will START or UPDATE the set
      ExercisePage.updateSet.value = true;

      //if not last set... then this is the calibration set...
      //which means it's possible we have not yet asked for notification permissions for the first time
      //and it also means the timer has not started because we never moved from the suggestion page to the record page
      //which is what usually starts the timer
      if (exercise.lastWeight == null && setUpdated == false) {
        //the timer MAY HAVE started before it was needed... reset it

        //I can't see any case where the timer would have already started here
        //but I'm covering the case anyways
        bool timerStarted =
            (exercise.tempStartTime.value != AnExercise.nullDateTime);
        if (timerStarted == false) {
          //start the timer
          ExercisePage.toggleTimer.value = true;
        }
      }

      //continue
      toNextPageAfterSetUpdateComplete();
    } else {
      //change the buttons shows a the wording a tad\
      bool canRevert =
          (exercise.tempWeight != null && exercise.tempReps != null);

      //show the dialog
      showBasicHeaderIconPopUp(
        context,
        [
          Text(
            "Fix Your Set",
            style: TextStyle(
              fontSize: 28,
            ),
          ),
          /*
          Text(
            "Break Timer",
            style: TextStyle(
              fontSize: 14,
            ),
          ),
          */
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
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                Visibility(
                  visible: canRevert,
                  child: RevertToPrevious(
                    exercise: exercise,
                  ),
                ),
              ],
            ),
          ),
        ],
        DialogType.ERROR,
        animationType: AnimType.BOTTOMSLIDE,
        clearBtn: canRevert == false
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
                    //used to update set here since starting the timer was combined with it...
                    //but that is no longer the case
                    toNextPageAfterSetUpdateComplete();
                  });
                },
              ),
        colorBtn: ElevatedButton(
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
