//flutter
import 'package:flutter/material.dart';

//plugin
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:swol/action/popUps/button.dart';

//internal: action
import 'package:swol/action/popUps/reusable.dart';
import 'package:swol/action/page.dart';
import 'package:swol/action/popUps/textValid.dart';

//internal: other
import 'package:swol/shared/structs/anExcercise.dart';
import 'package:swol/main.dart';

//determine whether we should warn the user
warningThenAllowPop(BuildContext context, AnExcercise excercise,
    {bool alsoPop: false}) {
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
  int tempWeightString = excercise?.tempWeight;
  int tempRepsString = excercise?.tempReps;
  //extra step needed because null.toString() isn't null
  String tempWeight =
      (tempWeightString != null) ? tempWeightString.toString() : "";
  String tempReps = (tempRepsString != null) ? tempRepsString.toString() : "";

  //grab news
  String newWeight = ExcercisePage.setWeight.value;
  String newReps = ExcercisePage.setReps.value;

  //check if matching
  bool matchingWeight = (newWeight == tempWeight);
  bool matchingReps = (newReps == tempReps);
  bool bothMatch = matchingWeight && matchingReps;

  if (bothMatch) {
    //our notifiers match our temps
    //if the timer HASN'T STARTED this happens by BEING EMTPY
    //if the timer HAS STARTED this happens by NOT BEING EMPTY

    //allow the user to go to where they wanted to
    //IF (also pop), will pop
    //ELSE will return true and pop then
    backToExcercises(context, alsoPop);
    //allow poping if called by back button
    return true;
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

    if (newSetValid) {
      //will start or update the set
      ExcercisePage.updateSet.value = true;

      //allow the user to go to where they wanted to
      //IF (also pop), will pop
      //ELSE will return true and pop then
      backToExcercises(context, alsoPop);

      //allow poping if called by back button
      return true;
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
        onDissmissCallback: () {
          //If the pop up came up the values typed are not valid
          //if we reverted then the refocus will do nothing
          //since the function will see that both values are valid
          ExcercisePage.causeRefocusIfInvalid.value = true;
        },
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
                        excercise: excercise,
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
          onTap: () {
            //NOTE: we revert back to the previous values
            //by just not saving the notifier values
            //since we are leaving so they will essentially reset

            //pop ourselves
            Navigator.of(context).pop();
            //will call "onDissmissCallback"

            //do the action the user initially wanted
            //regardless of where this function was called from
            backToExcercises(context, true);
          },
        ),
        btnOk: AwesomeButton(
          child: Text(
            "Let Me Fix It",
          ),
          onTap: () {
            //pop ourselves
            Navigator.of(context).pop();
            //will call "onDissmissCallback"

            //move to the right page
            //IF we are already there then good
            //  the "onDissmissCallback" will refocus
            //ELSE we will move to the right page
            //  and the init function of set record will refocus
            ExcercisePage.pageNumber.value = 1;
          },
        ),
      ).show();

      //don't allow popping automatically
      return false;
    }
  }
}

backToExcercises(BuildContext context, bool alsoPop) {
  //may have to unfocus
  FocusScope.of(context).unfocus();
  //animate the header
  App.navSpread.value = false;
  //pop if not using the back button
  if (alsoPop) Navigator.of(context).pop();
}
