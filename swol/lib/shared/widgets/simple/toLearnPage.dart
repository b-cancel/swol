//flutter
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';

//plugin
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:swol/action/page.dart';
import 'package:swol/action/popUps/textValid.dart';

//internal
import 'package:swol/pages/learn/page.dart';
import 'package:swol/main.dart';
import 'package:swol/shared/methods/exerciseData.dart';
import 'package:swol/shared/structs/anExercise.dart';

//we don't need to do anything complex to get to the main page
//all we have to do is pass to this widget the amount of time we have to pop
//every page should react accordingly to its pop

//in the case of the add exercise page
//the pop OF THIS TYPE should cause settings to be saved for reloading later

//the simply navigate to the learn page
class SuggestToLearnPage extends StatelessWidget {
  goToLearnAfterSetUpdateComplete() {
    BuildContext rootContext = GrabSystemData.rootContext!;
    bool gestureInProgress = Navigator.of(rootContext).userGestureInProgress;
    if (gestureInProgress == false) {
      if (ExercisePage.updateSet.value) {
        //wait for the set to finish updating
        //NOTE: the statement is set back to false automatically
        //when its set to true, it updates stuff, then set itself to false
        WidgetsBinding.instance?.addPostFrameCallback((_) {
          goToLearnAfterSetUpdateComplete();
        });
      } else {
        goToLearn();
      }
    }
  }

  goToLearn() {
    BuildContext rootContext = GrabSystemData.rootContext!;
    bool gestureInProgress = Navigator.of(rootContext).userGestureInProgress;
    if (gestureInProgress == false) {
      if (Navigator.canPop(rootContext)) {
        //pop with the animation
        App.navSpread.value = false;
        Navigator.pop(rootContext);

        //let the user see the animation
        Future.delayed(ExercisePage.transitionDuration, () {
          goToLearn();
        });
      } else {
        App.navSpread.value = true;
        Navigator.push(
          rootContext,
          PageTransition(
            type: PageTransitionType.rightToLeft,
            duration: ExercisePage.transitionDuration,
            child: LearnExercise(),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        //this function can only be triggered from
        //1. add exercise page
        //2. excercise page 0
        //so...
        onTap: () {
          //pop to make space for snackbar
          Navigator.of(context).pop();

          //ID to be used below
          int exerciseID = ExercisePage.exerciseID.value;

          //we triggered it from addExcercise page
          //the will learn that their data will be wiped the first time
          //NOTE: so adding a CONFIRM box or pop up is unecesarry
          //TODO: eventually save things temporarily and then let them be restored
          if (exerciseID == -1) {
            goToLearn();
          } else {
            //its possible for our our set to not be fully recorded
            //in which case alert the user to make the the edit first
            //or that they will lose the data

            //all the data needed to determine if we need to generate a pop up

            if (ExerciseData.getExercises().containsKey(exerciseID)) {
              AnExercise exercise = ExerciseData.getExercises()[exerciseID]!;

              //if both match proceed as expected
              if (doBothMatch(exercise)) {
                //our notifiers match our temps
                //if the timer HASN'T STARTED this happens by BEING EMTPY
                //      so don't pester the user
                //if the timer HAS STARTED this happens by NOT BEING EMPTY
                //      so the set is already what it should be
                goToLearn();
              } else {
                //if both don't match
                //either we are initially setting the value
                //or we are updating the value

                //imply action if possible
                if (isSetValid()) {
                  ExercisePage.updateSet.value = true;
                  goToLearnAfterSetUpdateComplete();
                } else {
                  BotToast.showCustomNotification(
                    toastBuilder: (_) {
                      //style
                      TextStyle bold = TextStyle(
                        fontWeight: FontWeight.bold,
                      );

                      //return
                      return CustomToast(
                        action: () {
                          goToLearn();
                        },
                        padding: 24.0 + 12,
                        child: RichText(
                          textScaleFactor: MediaQuery.of(
                            context,
                          ).textScaleFactor,
                          text: TextSpan(
                            style: TextStyle(
                              color: Colors.black,
                            ),
                            children: [
                              TextSpan(
                                text: "If You Continue, ",
                              ),
                              TextSpan(
                                text: "You Will\n",
                                style: bold,
                              ),
                              TextSpan(
                                text: "Lose Your ",
                                style: bold,
                              ),
                              TextSpan(
                                text: isNewSet(exercise)
                                    ? "New Set"
                                    : "Set Update",
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    align: Alignment(0, 1),
                    duration: Duration(seconds: 8),
                    dismissDirections: [
                      DismissDirection.horizontal,
                      DismissDirection.vertical,
                    ],
                    crossPage: false,
                    onlyOne: true,
                  );
                }
              }
            } else {
              goToLearn();
            }
          }
        },
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 8,
          ),
          child: IntrinsicHeight(
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Flexible(
                  child: RichText(
                    textScaleFactor: MediaQuery.of(
                      context,
                    ).textScaleFactor,
                    text: TextSpan(
                      style: TextStyle(
                        color: Colors.black,
                      ),
                      children: [
                        TextSpan(
                          text: "To Learn More\n",
                        ),
                        TextSpan(
                          text: "Tap Here",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: " to visit the ",
                        ),
                        TextSpan(
                          text: "Learn",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: " page",
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(
                    FontAwesomeIcons.leanpub,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

bool isSetValid() {
  //grab news
  String newWeight = ExercisePage.setWeight.value;
  String newReps = ExercisePage.setReps.value;

  //check validity
  bool newWeightValid = isTextValid(newWeight);
  bool newRepsValid = isTextValid(newReps);

  //ret
  return (newWeightValid && newRepsValid);
}

bool isNewSet(AnExercise? exercise) {
  //NOTE: IF tempWeight is filled that so is tempReps
  int? tempWeightInt = exercise?.tempWeight;
  String tempWeight = (tempWeightInt != null) ? tempWeightInt.toString() : "";
  return tempWeight == "";
}

bool doBothMatch(AnExercise? exercise) {
  //grab temps
  int? tempWeightInt = exercise?.tempWeight;
  int? tempRepsInt = exercise?.tempReps;

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

  //ret
  return bothMatch;
}

class CustomToast extends StatelessWidget {
  CustomToast({
    required this.child,
    required this.padding,
    this.action,
    this.isWarning: true,
  });

  final Widget child;
  final Function? action;
  final double padding;
  final bool isWarning;

  @override
  Widget build(BuildContext context) {
    TextStyle bold = TextStyle(
      fontWeight: FontWeight.bold,
    );
    //build
    return Padding(
      padding: EdgeInsets.only(
        bottom: padding > 0 ? padding : 0,
        top: padding < 0 ? -padding : 0,
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 16.0,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.all(
            Radius.circular(6),
          ),
          child: Material(
            color: Colors.white,
            child: InkWell(
              onTap: () {
                BotToast.cleanAll();
              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 16,
                ),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Row(
                        children: <Widget>[
                          Visibility(
                            visible: isWarning,
                            child: Padding(
                              padding: EdgeInsets.only(
                                right: 16.0,
                              ),
                              child: Icon(
                                Icons.warning,
                                color: Colors.red,
                              ),
                            ),
                          ),
                          Expanded(
                            child: child,
                          ),
                        ],
                      ),
                    ),
                    Visibility(
                      visible: action != null,
                      child: ElevatedButton(
                        onPressed: action != null ? () => action!() : null,
                        child: Text(
                          "Continue",
                          style: bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
