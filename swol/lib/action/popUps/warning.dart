//flutter
import 'package:flutter/material.dart';

//plugin
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:swol/action/notificationPopUp.dart';

//internal: action
import 'package:swol/action/popUps/textValid.dart';
import 'package:swol/action/popUps/reusable.dart';
import 'package:swol/action/popUps/button.dart';
import 'package:swol/action/page.dart';

//internal: other
import 'package:swol/shared/structs/anExercise.dart';
import 'package:swol/main.dart';
import 'package:swol/shared/widgets/simple/notify.dart';

//determine whether we should warn the user
Future<bool> warningThenPop(BuildContext context, AnExercise exercise)async{
  //NOTE: we can assume TEMPS ARE ALWAYS VALID
  //IF they ARENT EMPTY

  //-------------------------BEFORE the timer starts
  //our temps are EMPTY, our notifiers MAY BE

  //IF notifiers and temps match
  //  then both empty -> no pop up
  //ELSE
  //  notifier filled, temp empty -> POP UP

  //-------------------------AFTER the timer starts
  //our temps are NOT EMPTY, our notifiers MAY BE

  //IF notifier and temps match
  //  then both not empty -> no pop up
  //ELSE
  // notifiers updated, temp not empty -> POP UP

  //-------------------------IN BOTH cases
  //IF our notifers DO NOT MATCH our temps -> bring up pop up
  //  NOTE: assuming we allow manually updating temps after initially set

  //grab temps
  int tempWeightInt = exercise?.tempWeight;
  int tempRepsInt = exercise?.tempReps;
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
  //EXCEPT the one that goes back without having done anything

  //Of both match the cases to address drop significantly
  if (bothMatch) {
    //our notifiers match our temps
    //if the timer HASN'T STARTED this happens by BEING EMTPY
    //if the timer HAS STARTED this happens by NOT BEING EMPTY

    bool timerStarted = exercise.tempStartTime.value != AnExercise.nullDateTime;
    if (timerStarted) {
      //check if we have permission to schedule a notification
      PermissionStatus status = await PermissionHandler().checkPermissionStatus(
        PermissionGroup.notification,
      );

      //make sure they have been asked
      requestNotificationPermission(context, status, (){
        //regardless of whether the permission was given

        //try to schedlue notification
        //we already have tempStartTime 
        //and recoveryPeriod that we need
        //to schedule it since the timer started and no change has been made
        scheduleNotification(exercise);

        //perform expected action
        backToExercises(context);
      });
    }
    else {
      //timer hasn't started, both fields are empty
      //dont pester the user
      //ask for the permission only when you NEED it
      backToExercises(context);
    }
  } else {
    //if both don't match
    //either we are initially setting the value
    //or we are updating the value

    //check if valid
    bool newWeightValid = isTextValid(newWeight);
    bool newRepsValid = isTextValid(newReps);
    bool newSetValid = newWeightValid && newRepsValid;

    /*
    IF the set is valid -> we start the set or update it
      since its very unlikely that the user will ACCIDENTALLY place 2 valid values
      sicne if they ACCIDENTALLY tap the field the value will erase
    ELSE
      IF timer hasn't started -> (delete | or go to record page to fix)
      ELSE -> (revert | or got to record page to fix)
    */

    if(newSetValid){
      PermissionStatus status = await PermissionHandler().checkPermissionStatus(
        PermissionGroup.notification,
      );

      //make sure they have been asked
      requestNotificationPermission(context, status, (){
        //regardless of whether the permission was given

        //will start or update the set
        ExercisePage.updateSet.value = true;

        //expected action
        backToExercises(context);

        //schedule notification AFTER the set finishes updating
        scheduleNotificationAfterUpdate(exercise);
      });
    } else {
      //remove focus so the pop up doesnt bring it back
      FocusScope.of(context).unfocus();

      //possible because either both are filled or neither
      bool newSet = (tempWeight == "");
      String title = newSet ? "Begin Your Set Break" : "You Must Fix Your Set";
      String subtitle =
          newSet ? "so we can save your set" : "before we save it";

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
            SetTitle(
              title: title,
              subtitle: subtitle,
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
                      visible: newSet == false,
                      child: RevertToPrevious(
                        exercise: exercise,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        btnCancel: AwesomeButton(
          clear: true,
          child: Text(
            (newSet ? "Delete The Set" : "Revert Back"),
          ),
          onTap: () async {
            //NOTE: we revert back to the previous values
            //by just not saving the notifier values
            //since we are leaving so they will essentially reset

            //pop ourselves
            Navigator.of(context).pop();

            //check status
            PermissionStatus status = await PermissionHandler().checkPermissionStatus(
              PermissionGroup.notification,
            );

            //request permission
            requestNotificationPermission(context, status, (){
              //regardless of whether the permission was given

              //expected action
              backToExercises(context);

              //schedule notification
              scheduleNotification(exercise);
            });
          },
        ),
        btnOk: AwesomeButton(
          child: Text(
            "Let Me Fix It",
          ),
          onTap: () {
            //pop ourselves
            Navigator.of(context).pop();

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
      ).show();
    }
  }

  //don't allow popping automatically
  //at any point
  //just we just do it manually to simply the problem
  return false;
}

backToExercises(BuildContext context) {
  //may have to unfocus
  FocusScope.of(context).unfocus();
  //animate the header
  App.navSpread.value = false;
  //pop the page
  Navigator.of(context).pop();
}