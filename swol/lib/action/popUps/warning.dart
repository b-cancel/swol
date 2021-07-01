//flutter
import 'package:flutter/material.dart';

//plugin
import 'package:awesome_dialog/awesome_dialog.dart';

//internal: action
import 'package:swol/action/popUps/textValid.dart';
import 'package:swol/action/popUps/reusable.dart';
import 'package:swol/action/page.dart';
import 'package:swol/permissions/specific/specificAsk.dart';

//internal: other
import 'package:swol/shared/widgets/simple/ourHeaderIconPopUp.dart';
import 'package:swol/shared/widgets/simple/notify.dart';
import 'package:swol/shared/structs/anExercise.dart';
import 'package:swol/main.dart';

backToExercises(BuildContext context) {
  //may have to unfocus
  FocusScope.of(context).unfocus();
  //animate the header
  App.navSpread.value = false;
  //pop the page
  Navigator.of(context).pop();
}

scheduleIfPossibleThenBackToExercises(
  BuildContext context,
  AnExercise exercise,
) {
  //regardless of whether the permission was given

  //try to schedlue notification
  //Case 1: here you already have processed a Valid Set
  //Case 2: we are reverting so nothing new was updated
  //we already have tempStartTime
  //and recoveryPeriod that we need
  //to schedule it since the timer started and no change has been made
  scheduleNotificationIfPossible(exercise);

  //perform expected action
  backToExercises(context);
}

//determine whether we should warn the user
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

  //its very unlikely that we need to schedule a notification here
  //1. the permission has to be automatically applied
  //2. the timer will start (by going to the permision page)
  //3. then the user has to go back to the record set page
  //4. then remove the permission manually
  //5. and then go back
  //but we dont want the notification to FAIL EVEN ONCE
  //so we HAVE to cover the case

  //all 3 cases below are to cover this case
  //and they are all paired with going back to the exercise page
  //EXCEPT when
  //1. the user want to go back from an misclick
  //2. the user want to go back by deleting the mistyped set
  //    which ofcourse won't start the timer and therefore not have a notification

  //check if valid
  bool newWeightValid = isTextParsedIsLargerThan0(newWeight);
  bool newRepsValid = isTextParsedIsLargerThan0(newReps);
  bool newSetValid = newWeightValid && newRepsValid;

  //Of both match the cases to address drop significantly
  if (bothMatch) {
    //our notifiers match our temps
    //if the timer HASN'T STARTED this happens by BEING EMTPY
    //if the timer HAS STARTED this happens by NOT BEING EMPTY

    if (newSetValid) {
      await askForPermissionIfNotGrantedAndWeNeverAsked();
      scheduleIfPossibleThenBack();
    } else {
      //timer hasn't started, both fields are empty
      //dont pester the user
      //ask for the permission only when you NEED it
      backToExercises(context);
    }
  } else {
    //-------------------------*-------------------------*-------------------------*-------------------------*-------------------------
    //if both don't match
    //either we are initially setting the value
    //or we are updating the value

    /*
    IF the set is valid -> we start the set or update it
      since its very unlikely that the user will ACCIDENTALLY place 2 valid values
      sicne if they ACCIDENTALLY tap the field the value will erase
    ELSE
      IF timer hasn't started -> (delete | or go to record page to fix)
      ELSE -> (revert | or got to record page to fix)
    */

    //change display for pop up and
    //whether we wait to schedule the notification
    bool isNewSet = (tempWeight == "");

    //if its valid horray! no extra pop ups
    if (newSetValid) {
      await askForPermissionIfNotGrantedAndWeNeverAsked();
      //regardless of whether the permission was given

      //will start or update the set
      ExercisePage.updateSet.value = true;

      //expected action
      backToExercises(context);

      //schedule notification AFTER the set finishes updating
      if (isNewSet) {
        scheduleNotificationAfterUpdate(exercise);
      } //things are set as they should be before this action
      else {
        //as in I have the time the timer started
        //because this set is an update
        //and the recovery period is set
        scheduleNotificationIfPossible(exercise);
      }
    } else {
      //remove focus so the pop up doesnt bring it back
      FocusScope.of(context).unfocus();

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

            //we deleted the new set so now notification is needed
            //the timer hasn't started and won't because the set has been deleted
            if (isNewSet) {
              backToExercises(context);
            } else {
              //we are reverting back so we do schedule
              await askForPermissionIfNotGrantedAndWeNeverAsked();
              scheduleIfPossibleThenBack();
            }
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
    //-------------------------*-------------------------*-------------------------*-------------------------*-------------------------
  }

  //don't allow popping automatically
  //at any point
  //just we just do it manually to simply the problem
  return false;
}
