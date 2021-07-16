//flutter
import 'package:flutter/material.dart';

//plugin
import 'package:awesome_dialog/awesome_dialog.dart';

//internal: action
import 'package:swol/action/popUps/textValid.dart';
import 'package:swol/action/popUps/reusable.dart';
import 'package:swol/action/page.dart';

//internal: other
import 'package:swol/shared/widgets/simple/ourHeaderIconPopUp.dart';
import 'package:swol/shared/structs/anExercise.dart';
import 'package:swol/main.dart';

resetTimerIfSetNotValid(AnExercise exercise) {
  //if the timer has started...
  bool timerStarted = (exercise.tempStartTime.value != AnExercise.nullDateTime);
  if (timerStarted) {
    //it should ONLY CONTINUE IF the set being saved is valid
    String newWeight = ExercisePage.setWeight.value;
    String newReps = ExercisePage.setReps.value;
    bool newWeightValid = isTextParsedIsLargerThan0(newWeight);
    bool newRepsValid = isTextParsedIsLargerThan0(newReps);
    bool newSetValid = newWeightValid && newRepsValid;

    //if not valid reset the timer
    if (newSetValid == false) {
      //reset the timer
      ExercisePage.toggleTimer.value = true;
    }
  }
}

backToExercise(BuildContext context) {
  //may have to unfocus
  FocusScope.of(context).unfocus();
  //animate the header
  App.navSpread.value = false;
  //pop the page
  Navigator.of(context).pop();
}

//!DOES NOT REQUIRE NOTIFICATION SCHEDULING
//this is because, SINCE we are now starting the timer immediately when they go to the record page
//if we go back from the suggestion page... we haven't started the timer
//if we go back from the recording page... we already started the timer and ASK if we can notify them
//if we go back from the timer page... we already started the timer
Future<bool> warningThenPop(BuildContext context, AnExercise exercise) async {
  //NOTE: we can assume TEMPS ARE ALWAYS VALID
  //IF they ARENT EMPTY

  //grab temps
  int? tempWeightInt = exercise.tempWeight;
  int? tempRepsInt = exercise.tempReps;
  //extra step needed because null.toString() isn't null
  String tempWeight = (tempWeightInt != null) ? tempWeightInt.toString() : "";
  String tempReps = (tempRepsInt != null) ? tempRepsInt.toString() : "";

  //grab news
  String newWeight = ExercisePage.setWeight.value;
  String newReps = ExercisePage.setReps.value;

  //check if matching
  bool matchingWeight = (newWeight == tempWeight);
  bool matchingReps = (newReps == tempReps);
  bool bothMatch = matchingWeight && matchingReps;

  //check if valid
  bool newWeightValid = isTextParsedIsLargerThan0(newWeight);
  bool newRepsValid = isTextParsedIsLargerThan0(newReps);
  bool newSetValid = newWeightValid && newRepsValid;

  //Of both match the cases to address drop significantly
  if (bothMatch) {
    //temp and new BOTH empty -OR- BOTH filled
    //both filled so nothing has changed

    //both empty
    if (newSetValid == false) {
      resetTimerIfSetNotValid(exercise);
    }

    //continue
    backToExercise(
      context,
    );
  } else {
    //if its valid horray! no extra pop ups
    if (newSetValid) {
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

        //TODO: possibly ask for permission to notify the user with a pop up
      }

      //expected action
      backToExercise(
        context,
      );
    } else {
      //if both don't match
      //either we are initially setting the value
      //or we are updating the value

      //remove focus so the pop up doesnt bring it back
      FocusScope.of(context).unfocus();

      //change display for pop up and
      //whether we wait to schedule the notification
      bool isNewSet = (tempWeight == "");

      //possible because either both are filled or neither
      String title =
          isNewSet ? "Begin Your Set Break" : "You Must Fix Your Set";
      String subtitle =
          isNewSet ? "so we can save your set" : "before we save it";

      //bring up pop up
      showBasicHeaderIconPopUp(
        context,
        [
          Text(
            title,
            style: TextStyle(
              fontSize: 24,
            ),
          ),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 16,
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
                  weight: newWeight,
                  reps: newReps,
                ),
                SetProblem(
                  weightValid: newWeightValid,
                  repsValid: newRepsValid,
                  setValid: newSetValid,
                ),
                GoBackAndFix(),
                Visibility(
                  visible: isNewSet == false,
                  child: RevertToPrevious(
                    exercise: exercise,
                  ),
                ),
              ],
            ),
          ),
        ],
        DialogType.WARNING,
        animationType: AnimType.LEFTSLIDE,
        clearBtn: TextButton(
          child: Text(
            (isNewSet ? "Delete The Set" : "Revert Back"),
          ),
          onPressed: () async {
            //NOTE: we revert back to the previous values
            //by just not saving the notifier values
            //since we are leaving so they will essentially reset

            //pop ourselves
            Navigator.of(context).pop();

            //delete the set resets the timer... revert back does not
            if (isNewSet) {
              resetTimerIfSetNotValid(exercise);
            }

            //we deleted the new set so now notification is needed
            //the timer hasn't started and won't because the set has been deleted
            backToExercise(
              context,
            );
          },
        ),
        colorBtn: ElevatedButton(
          child: Text(
            "Let Me Fix It",
          ),
          onPressed: () {
            //pop ourselves
            Navigator.of(context).pop();

            //NOTE: we don't yet NEED to request permission for the break
            //let the user correct their messed up set first

            //If the pop up came up the values typed are not valid
            //if we reverted then the refocus will do nothing
            //since the function will see that both values are valid
            ExercisePage.causeRefocusIfInvalid.value = true;

            //move to the right page
            //IF we are already there then good
            //  the "onDissmissCallback" will refocus
            //ELSE we will move to the right page
            //  and the init function of set record will refocus
            ExercisePage.pageNumber.value = 1;
          },
        ),
      );
    }
  }

  //don't allow popping automatically
  //at any point
  //just we just do it manually to simplify the problem
  return false;
}
