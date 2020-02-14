//flutter
import 'package:flutter/material.dart';

//plugin
import 'package:awesome_dialog/awesome_dialog.dart';

//internal: action
import 'package:swol/action/popUps/reusable.dart';
import 'package:swol/action/page.dart';

//internal: other
import 'package:swol/shared/structs/anExcercise.dart';
import 'package:swol/main.dart';
import 'package:swol/shared/widgets/simple/conditional.dart';

//determine whether we should warn the user
warningThenAllowPop(BuildContext context, AnExcercise excercise,
    {bool alsoPop: false}) {
  //NOTE: we can assume TEMPS ARE ALWAYS VALID (not empty, not 0)

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
  String tempWeight = (excercise?.tempWeight ?? "");
  String tempReps = (excercise?.tempReps ?? "");

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
    goBack(context, alsoPop);
    //allow poping if called by back button
    return true;
  } else {
    //if both don't match
    //either we are initially setting the value
    //or we are updating the value

    //possible because either both are filled or neither
    bool updatingSet = tempWeight != "";

    //check if valid
    bool newWeightValid = newWeight != "" && newWeight != "0";
    bool newRepsValid = newReps != "" && newReps != "0";
    bool newSetValid = newWeightValid && newRepsValid;

    /*
    IF timer hasnt started (both do same thing but have different text FOR NOW)

      case 1: & set is valid -> (delete | or go to page to begin set break)

        NOTE: we could start the set break for them (which cuts the required taps by 1)
        but we WANT to be annoying so that they start starting their own set break
        
        the right way for 2 reasons

        1. Even with letting them start their own set break from the pop up
        If they do so with the pop up it takes longer
          tap 1. tap in a way that the pop up comes up
          tap 2. tap the pop up so that you begin your set break and perform your initially desired action
          VS doing it the right way taking 1 tap
        2. if they do it through the pop up then they won't see the hero transition of the timer
          which might mean they dont immediately understand what the mini timer does

      case 2: & set is not valid -> (delete | or go to page to fix set)
    */

    /*
    ELSE timer has started
      & set is valid -> automatically update
        TODO: perhaps experiment with asking the user although it seems like they would expect it to happen automatically

      & set is not valid -> (revert to previous balue | or go to page to fix set)
    */

    if (updatingSet && newSetValid) {
      //auto update the temps
      excercise.tempWeight = int.parse(newWeight);
      excercise.tempReps = int.parse(newReps);
      //allow the user to go to where they wanted to
      goBack(context, alsoPop);
      //allow poping if called by back button
      return true;
    } else {
      //remove focus so the pop up doesnt bring it back
      FocusScope.of(context).unfocus();

      String title = updatingSet ? "You Must Fix Your Set" : "Begin Your Set Break";
      String subtitle = updatingSet ? "before we save it" : "so we can save your set";

      //bring up pop up
      AwesomeDialog(
        context: context,
        isDense: false,
        //NOTE: if we do need things to refocus after we dismiss
        //the on resume function should handle it
        //onDissmissCallback: ,
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
                    Conditional(
                      condition: newSetValid,
                      ifTrue: ValidSetWarning(),
                      //what will always show when editing a set
                      ifFalse: PartiallyInvalidSetWarning(),
                    ),
                    //-------------------------Buttons-------------------------
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
                              //TODO: if we are updating revert back to the previous values
                              //by just not updating the temp vars
                              //pop ourselves
                              Navigator.of(context).pop();
                              //do the action the user initially wanted
                              goBack(context, true);
                            },
                            child: Text(
                              //TODO: indiciate a revert back to the previous values if we are updating
                              "No, Delete The Set",
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                          ),
                          RaisedButton(
                            color: Colors.blue,
                            onPressed: (){
                              //pop ourselves
                              Navigator.of(context).pop();
                              //TODO: go to the record page by changing the notifier
                            },
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
    }
  }
}

//NOTE: at the moment if you edit your set
//and the edit yields a valid set
//it will auto update the set for you
//which is why here we don't handle the upating the option
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