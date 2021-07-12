//dart
import 'dart:math' as math;

//flutter
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';

//plugin
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:page_transition/page_transition.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:swol/action/tabs/recovery/secondary/breath.dart';
import 'package:swol/pages/notes/exerciseNotes.dart';

//internal: shared
import 'package:swol/shared/functions/defaultDateTimes.dart';
import 'package:swol/shared/functions/goldenRatio.dart';
import 'package:swol/shared/methods/exerciseData.dart';
import 'package:swol/shared/methods/theme.dart';
import 'package:swol/shared/structs/anExercise.dart';

//internal: pages
import 'package:swol/pages/selection/widgets/persistentHeaderDelegate.dart';
import 'package:swol/pages/selection/widgets/workoutSection.dart';
import 'package:swol/pages/selection/widgets/bottomButtons.dart';
import 'package:swol/pages/selection/exerciseListPage.dart';

//internal: others
import 'package:swol/other/durationFormat.dart';
import 'package:swol/action/page.dart';
import 'package:swol/main.dart';
import 'package:swol/shared/widgets/simple/toLearnPage.dart';

//widget
class ExerciseList extends StatefulWidget {
  ExerciseList({
    required this.autoScrollController,
    required this.statusBarHeight,
    required this.onTop,
  });

  final AutoScrollController autoScrollController;
  final double statusBarHeight;
  final ValueNotifier<bool> onTop;

  @override
  _ExerciseListState createState() => _ExerciseListState();
}

class _ExerciseListState extends State<ExerciseList> {
  //other vars
  final Duration maxTimeBetweenExercises = Duration(hours: 1, minutes: 30);

  //removalable listener
  updateState() {
    if (mounted) {
      beforeManualBuild();
      setState(() {});
    }
  }

  //NOTE: case analysis of function below
  //In particular when its triggered from page 0 or page 1 of an exercise

  //the function runs after a notification is triggered
  //a notification is triggered if the permission is given

  //NOTE: this DOES NOT mean its been requested
  //  since it automatically requested by android
  //  this WOULD mean its been requested if the platform is IOS tho
  //but assume that its irelevant
  //we only CARE ABOUT requesting permission IF we don't have it

  //NOTE: If a permission is taken away after a notification is scheduled
  //is the notification canceled? for both platforms?
  //for Android, turning off notification doesn't cancel the notification
  //  it just blocks them
  //IDK for IOS so assume that it isn't

  //So we know that when this pop ups a notification was schedule and arrived
  //1. we KNOW Notifications Are Current Enabled (Regardless of Platform)
  //2. we DONT KNOW if they have been requested
  //3. we KNOW 2 doesn't matter because Notifications are granted regardless
  //4. and because 3 is true than nothing having to do with permission will show up

  //So we know the error causing things that can occur are
  //* means its taken care off or doesn't cause a problem
  //we haven't started the timer
  //  1. and our set is invalid (ERROR)
  //  2. and our set is valid
  //  *3. and our set is not recorded
  //we have started the timer so we want to update our set
  //  1. and the update is invalid (ERROR)
  //  2. and the update is valid
  //  3. and our set is the same as it was before

  toPage2AfterSetUpdateComplete() {
    BuildContext rootContext = GrabSystemData.rootContext!;
    bool gestureInProgress = Navigator.of(rootContext).userGestureInProgress;
    if (gestureInProgress == false) {
      if (ExercisePage.updateSet.value) {
        //wait for the set to finish updating
        //NOTE: the statement is set back to false automatically
        //when its set to true, it updates stuff, then set itself to false
        WidgetsBinding.instance?.addPostFrameCallback((_) {
          toPage2AfterSetUpdateComplete();
        });
      } else {
        ExercisePage.pageNumber.value = 2; //shift to the timer page
      }
    }
  }

  //NOTE: this should only run if we are SURE
  //the on the top of the navigator are the vertical tabs
  toPage2({bool popUpIfThere: true}) {
    if (ExercisePage.pageNumber.value == 2) {
      if (popUpIfThere) {
        //the user is probably confused...
        //they are already there so remind them
        //and also be usedful and remind them where the button is for some reason
        BotToast.showCustomNotification(
          toastBuilder: (_) {
            //style
            TextStyle bold = TextStyle(
              fontWeight: FontWeight.bold,
            );

            //return
            return CustomToast(
              padding: 24.0 + 40.0 + 16,
              child: Row(
                children: <Widget>[
                  Expanded(
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
                            text: "Tap The Button",
                            style: bold,
                          ),
                          TextSpan(
                            text: " on the ",
                          ),
                          TextSpan(
                            text: "Bottom Right\n",
                            style: bold,
                          ),
                          TextSpan(
                            text: "to move onto your Next Set",
                          ),
                        ],
                      ),
                    ),
                  ),
                  Transform.rotate(
                    angle: (-math.pi / 4) * 2,
                    child: Icon(
                      Icons.subdirectory_arrow_left,
                      color: Colors.black,
                    ),
                  )
                ],
              ),
            );
          },
          align: Alignment(0, 1),
          duration: Duration(seconds: 5),
          dismissDirections: [
            DismissDirection.horizontal,
            DismissDirection.vertical,
          ],
          crossPage: false,
          onlyOne: true,
        );
      }
      //ELSE we are comming from the NOTES page
    } else {
      //active page is 0 or 1
      int exerciseID = ExercisePage.exerciseID.value;
      AnExercise exercise = ExerciseData.getExercises()[exerciseID]!;

      //handle what happens, might have to manually move and that MAY cause problems
      if (doBothMatch(exercise)) {
        //NOTE: we KNOW
        //1. the timer started and ended
        //    otherwise we wouldn't be here
        //2. the values are already saved for the set
        //    since both match and the timer started
        //    so we don't have to run anything special

        //all we need to do is navigate to page 2
        ExercisePage.pageNumber.value = 2;
      } else {
        //in page 0 or 1
        //imply the action the user wants to take
        //move onto the 2nd page
        if (isSetValid()) {
          ExercisePage.updateSet.value = true;
          toPage2AfterSetUpdateComplete();
        } else {
          //the set isn't valid so push the user to validate
          if (ExercisePage.pageNumber.value == 0) {
            //move to the page and it will automatically refocus
            ExercisePage.pageNumber.value = 1;
          } else {
            //we are already on the page, so confirm focus
            //if we have focus, remove it so we can then get it back
            if (FocusScope.of(context).hasFocus == false) {
              //Focus to show the user what is wrong
              ExercisePage.causeRefocusIfInvalid.value = true;
            }
          }

          //pop up that says the thing is invalid
          BotToast.showCustomNotification(
            toastBuilder: (_) {
              //style
              TextStyle bold = TextStyle(
                fontWeight: FontWeight.bold,
              );

              //return
              return CustomToast(
                padding: -(56.0 + 16),
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
                        text: "Finish Repairing",
                        style: bold,
                      ),
                      TextSpan(
                        text: " Your Set\n",
                      ),
                      TextSpan(
                        text: "Before",
                        style: bold,
                      ),
                      TextSpan(
                        text: " moving onto your next",
                        style: bold,
                      ),
                    ],
                  ),
                ),
              );
            },
            align: Alignment(0, -1),
            duration: Duration(seconds: 5),
            dismissDirections: [
              DismissDirection.horizontal,
              DismissDirection.vertical,
            ],
            crossPage: false,
            onlyOne: true,
          );
        }
      }
    }
  }

  //called when a notification is tapped regardless of platform
  //and for iOS it also called from the special pop up
  tryToGoToExercise() {
    if (exerciseToTravelTo.value != -1) {
      int currExerciseID = ExercisePage.exerciseID.value;
      int nextExerciseID = exerciseToTravelTo.value;

      //either we
      //1. had the app closed
      //2. were in the exercise list
      //3. were in the learn section
      //4. were searching
      //5. were adding an new exercise
      //TODO: for case below it might be nice to warn the user that they will lose their data
      if (currExerciseID == -1) {
        popThenGoToExercise(nextExerciseID);
      } else {
        //we are already where we want to be
        //but perhaps not exactly where we want to be
        //1. main pages (but not page 2)
        //2. breath page
        //3. note page
        if (currExerciseID == nextExerciseID) {
          //breathing page is ideal since it takes us directly to where we want to be
          if (BreathStateless.inStack) {
            Navigator.of(context).pop();
          } else {
            //notes page or in one of the vertical pages
            if (ExerciseNotesStateless.inStack) {
              //let the user know that they should save their changes
              BotToast.showCustomNotification(
                toastBuilder: (_) {
                  //style
                  TextStyle bold = TextStyle(
                    fontWeight: FontWeight.bold,
                  );

                  //return
                  return CustomToast(
                    padding: 24.0 + 8,
                    action: () {
                      Navigator.of(context).pop();
                      toPage2(popUpIfThere: false);
                    },
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
                            text: "Save Before",
                            style: bold,
                          ),
                          TextSpan(
                            text: " You Continue\n",
                          ),
                          TextSpan(
                            text: "or you will ",
                            style: bold,
                          ),
                          TextSpan(
                            text: "Lose Your Changes",
                            style: bold,
                          ),
                        ],
                      ),
                    ),
                  );
                },
                align: Alignment(0, 1),
                //5 to read, 5 to save and still use BTN
                duration: Duration(seconds: 5 + 5),
                dismissDirections: [
                  DismissDirection.horizontal,
                  DismissDirection.vertical,
                ],
                crossPage: false,
                onlyOne: true,
              );
            } else {
              toPage2();
            }
          }
        } else {
          //check the validity of the current exercise set
          if (ExerciseData.getExercises().containsKey(currExerciseID)) {
            AnExercise exercise = ExerciseData.getExercises()[currExerciseID]!;

            //we have to navigate away... IF WE CAN
            if (doBothMatch(exercise)) {
              //we are good to go whereever
              popThenGoToExercise(nextExerciseID);
            } else {
              if (isSetValid()) {
                ExercisePage.updateSet.value = true;
                popThenGoToExerciseAfterSetUpdateComplete(nextExerciseID);
              } else {
                //notify the user of the action that should take place first
                BotToast.showCustomNotification(
                  toastBuilder: (_) {
                    //style
                    TextStyle bold = TextStyle(
                      fontWeight: FontWeight.bold,
                    );

                    //return
                    return CustomToast(
                      padding: 24.0 + 8,
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
                              text: "You Should ",
                            ),
                            TextSpan(
                              text: "Finish " +
                                  (isNewSet(exercise) ? "Saving" : "Updating") +
                                  " This Set\n",
                              style: bold,
                            ),
                            TextSpan(
                              text: "Before",
                              style: bold,
                            ),
                            TextSpan(text: " Moving onto your next"),
                          ],
                        ),
                      ),
                    );
                  },
                  align: Alignment(0, 1),
                  duration: Duration(seconds: 5),
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
            popThenGoToExercise(nextExerciseID);
          }
        }
      }

      //reset for next notification
      exerciseToTravelTo.value = -1;
    }
  }

  popThenGoToExerciseAfterSetUpdateComplete(int exerciseID) {
    BuildContext rootContext = GrabSystemData.rootContext!;
    bool gestureInProgress = Navigator.of(rootContext).userGestureInProgress;
    if (gestureInProgress == false) {
      if (ExercisePage.updateSet.value) {
        //wait for the set to finish updating
        //NOTE: the statement is set back to false automatically
        //when its set to true, it updates stuff, then set itself to false
        WidgetsBinding.instance?.addPostFrameCallback((_) {
          popThenGoToExerciseAfterSetUpdateComplete(exerciseID);
        });
      } else {
        popThenGoToExercise(exerciseID);
      }
    }
  }

  //go back until the main page and then to the exercise
  //NOTE: this doesn't save any previous state
  //if skips out on the warnings that usually pop out
  //and doesn't autostart the set for the exercise that we are leaving
  popThenGoToExercise(int exerciseID) {
    BuildContext rootContext = GrabSystemData.rootContext!;
    bool gestureInProgress = Navigator.of(rootContext).userGestureInProgress;
    if (gestureInProgress == false) {
      if (Navigator.canPop(rootContext)) {
        //may need to unfocus
        if (FocusScope.of(context).hasFocus) {
          FocusScope.of(context).unfocus();
        }

        //pop with the animation
        App.navSpread.value = false;
        Navigator.pop(rootContext);

        //let the user see the animation
        Future.delayed(ExercisePage.transitionDuration, () {
          popThenGoToExercise(exerciseID);
        });
      } else {
        travelToExercise(exerciseID);
      }
    }
  }

  travelToExercise(int exerciseID) {
    if (ExerciseData.getExercises().containsKey(exerciseID)) {
      AnExercise exerciseWeMightTravelTo =
          ExerciseData.getExercises()[exerciseID]!;

      //wait a bit so that init runs
      travelAfterDisposeComplete(exerciseWeMightTravelTo);
    }
  }

  travelAfterDisposeComplete(AnExercise exercise) {
    BuildContext rootContext = GrabSystemData.rootContext!;
    bool gestureInProgress = Navigator.of(rootContext).userGestureInProgress;
    if (gestureInProgress == false) {
      //dipose has run because the exercise open in the page is none
      if (ExercisePage.exerciseID.value == -1) {
        //would be triggered by exercise tile
        App.navSpread.value = true;

        //travel there
        Navigator.push(
          context,
          PageTransition(
            duration: ExercisePage.transitionDuration,
            type: PageTransitionType.rightToLeft,
            //wrap in light so warning pop up works well
            child: Theme(
              data: MyTheme.light,
              child: ExercisePage(
                exercise: exercise,
              ),
            ),
          ),
        );
      } else {
        WidgetsBinding.instance?.addPostFrameCallback((_) {
          travelAfterDisposeComplete(exercise);
        });
      }
    }
  }

  //init
  @override
  void initState() {
    //TODO: below commented out because the new goToExercise from notification
    //may break with this
    /*
    //wait one frame before trying to travel
    //otherwise things will break
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      travelToExercise(exerciseToTravelTo.value);
    });
    */

    //wait to have mediaquery available
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      beforeManualBuild();
      setState(() {});
    });

    //allows any exercise to manually update order
    ExerciseSelectStateless.manualOrderUpdate.addListener(
      manualBeforeManualBuild,
    );

    //Updates every time we update[timestamp], add, or remove some exercise
    ExerciseData.exercisesOrder?.addListener(updateState);
    exerciseToTravelTo.addListener(tryToGoToExercise);
    super.initState();
  }

  @override
  void dispose() {
    ExerciseSelectStateless.manualOrderUpdate.removeListener(
      manualBeforeManualBuild,
    );
    exerciseToTravelTo.removeListener(tryToGoToExercise);
    ExerciseData.exercisesOrder?.addListener(updateState);
    super.dispose();
  }

  //set to true by the ones who want the update to occur
  manualBeforeManualBuild() {
    if (ExerciseSelectStateless.manualOrderUpdate.value == true) {
      updateState();
      ExerciseSelectStateless.manualOrderUpdate.value = false;
    }
  }

  //prevents unecessary calculation when navigating
  List<Widget>? slivers;
  beforeManualBuild() {
    //list to separate stuff into
    List<AnExercise> inProgressOnes = [];
    List<AnExercise> newOnes = [];
    List<AnExercise> regularOnes = [];
    List<AnExercise> hiddenOnes = [];

    //where to combine the list above into
    List<List<AnExercise>> groupsOfExercises = [];

    //will contain the actual slivers
    List<Widget> sliverList = [];

    //a little bit of math
    List<double> goldenBS = measurementToGoldenRatioBS(
      MediaQuery.of(context).size.height,
    );
    double openHeaderHeight = goldenBS[1] - widget.statusBarHeight;

    //try to see if we have workouts to add
    List<int>? exerciseOrder = ExerciseData.exercisesOrder?.value;
    if (exerciseOrder == null || exerciseOrder.length == 0) {
      sliverList.add(AddExerciseFiller());
    } else {
      //NOTE: I don't need to call this pretty much ever again since I should be able to pass and update the reference
      Map<int, AnExercise> exercises = ExerciseData.getExercises();

      //seperate exercises given their TimeStampTypes
      for (int i = 0; i < exerciseOrder.length; i++) {
        int thisExerciseID = exerciseOrder[i];
        if (exercises.containsKey(thisExerciseID)) {
          AnExercise thisExercise = exercises[thisExerciseID]!;
          TimeStampType thisExerciseType = LastTimeStamp.returnTimeStampType(
            thisExercise.lastTimeStamp,
          );

          //send to proper list
          if (thisExerciseType == TimeStampType.InProgress) {
            inProgressOnes.add(thisExercise);
          } else if (thisExerciseType == TimeStampType.New) {
            newOnes.add(thisExercise);
          } else if (thisExerciseType == TimeStampType.Other) {
            regularOnes.add(thisExercise);
          } else {
            hiddenOnes.add(thisExercise);
          }
        }
      }

      //add in progress ones if they exist
      if (inProgressOnes.length > 0) {
        //sort so the ones that have the least ammount before the timer runs out
        //are on top

        //Example
        //If I do EXERCISE 1 and want to wait 20 minutes for the next set
        //and do EXERCISE 2 and want to wait 1 minute for the next set
        //EXERCISE 2 should be first

        //create map, 2 duration might map to 2 difference indices
        //in which case how they sort is which one you did first
        //the one you did first goes on the bottom
        Map<Duration, List<int>> timeTillFinish2IndexInProgressOnes =
            new Map<Duration, List<int>>();

        //grab the timeTillFinish for each to be able to sort by that
        for (int i = 0; i < inProgressOnes.length; i++) {
          AnExercise inProgressExercise = inProgressOnes[i];
          DateTime timerStart = inProgressExercise.tempStartTime.value;
          Duration timerDuration = Duration.zero;
          //TODO: ignore actual recovery period, that seem pretty irelevant
          //inProgressExercise.recoveryPeriod;
          DateTime timerEnd = timerStart.add(timerDuration);

          //calculate the value we will sort based on
          //after.differene(before) produces positive values
          //if timerEnd is BEFORE DateTime.now() we should get a positive value
          Duration timeTillFinish = (timerEnd).difference(DateTime.now());

          //add to dictionary
          if (timeTillFinish2IndexInProgressOnes.containsKey(timeTillFinish) ==
              false) {
            timeTillFinish2IndexInProgressOnes[timeTillFinish] = [];
          }
          timeTillFinish2IndexInProgressOnes[timeTillFinish]!.add(i);
        }

        //sort keys
        List<Duration> timesTillFinish =
            timeTillFinish2IndexInProgressOnes.keys.toList();
        timesTillFinish.sort();

        //iterate through keys to grab sorted order
        List<AnExercise> newInProgressOnes = [];
        for (int i = 0; i < timesTillFinish.length; i++) {
          Duration thisTimeTillFinish = timesTillFinish[i];
          if (timeTillFinish2IndexInProgressOnes
              .containsKey(thisTimeTillFinish)) {
            List<int> indicesInProgressOnes =
                timeTillFinish2IndexInProgressOnes[thisTimeTillFinish]!;

            //cover main cases
            if (indicesInProgressOnes.length == 1) {
              int theIndex = indicesInProgressOnes[0];

              AnExercise theExercise = inProgressOnes[theIndex];
              newInProgressOnes.add(theExercise);
            } else {
              //2 different exercises have their timers finishing at the exact same time
              //NOTE:currently our sorting order views things like so
              //what was started first is on top
              //which is exatly how we want to be this bit sorted so just add them as they appear

              //but they where started at different times
              //which every one was started first goes on the bottom
              for (int i = 0; i < indicesInProgressOnes.length; i++) {
                int theIndex = indicesInProgressOnes[i];
                AnExercise theExercise = inProgressOnes[theIndex];
                newInProgressOnes.add(theExercise);
              }
            }
          }
        }

        //add to group
        groupsOfExercises.add(newInProgressOnes);
      }

      //add new ones if they exist
      if (newOnes.length > 0) {
        groupsOfExercises.add(newOnes);
      }

      //create the groups of the regular ones
      //travel them in the opposite direction
      DateTime? lastDateTime;
      for (int i = 0; i < regularOnes.length; i++) {
        //array from back to front
        int index = (regularOnes.length - 1) - i;
        AnExercise thisExercise = regularOnes[index];

        //determine if new group is required
        bool makeNewGroup;
        if (lastDateTime == null) {
          //NOTE: only happens for the first exercise
          makeNewGroup = true;
        } else {
          //NOTE: may still need to make a new group given things below
          List<AnExercise> lastGroup = groupsOfExercises.last;

          //its not the first exercise we check so we MIGHT need a new group
          //we know we process things in order... so we only need to check the last group added
          //and even further really just the last item added to that group
          AnExercise lastExercise = lastGroup.last;

          //every exercise must have at most 1.5 hours between
          Duration timeBetweenExercises =
              thisExercise.lastTimeStamp.difference(lastExercise.lastTimeStamp);
          makeNewGroup = (timeBetweenExercises > maxTimeBetweenExercises);
        }

        //add a new group because its needed
        if (makeNewGroup) {
          groupsOfExercises.add(
            [],
          );
        }

        //add this exercise to our
        //1. newly created group
        //2. OR old group
        //both of which are the last groups
        groupsOfExercises.last.add(
          thisExercise,
        );

        //update lastDateTime
        lastDateTime = thisExercise.lastTimeStamp;
      }

      //add archived ones
      if (hiddenOnes.length > 0) {
        groupsOfExercises.add(hiddenOnes);
      }

      //fill sliver list
      for (int i = 0; i < groupsOfExercises.length; i++) {
        //create header text
        int index = i;
        List<AnExercise> thisGroup = groupsOfExercises[index];
        DateTime oldestDT = thisGroup[0].lastTimeStamp;
        TimeStampType sectionType = LastTimeStamp.returnTimeStampType(oldestDT);

        //vars to set
        String title;
        String? subtitle;

        //set title and subtitle
        if (sectionType == TimeStampType.Other) {
          Duration timeSince = DateTime.now().difference(oldestDT);
          title = DurationFormat.format(
            timeSince,
            showMinutes: false,
            showSeconds: false,
            showMilliseconds: false,
            showMicroseconds: false,
            len: 1, //medium
          );

          //only use short length stuff if there is only one thing to show
          //better for scaling and such
          if (title.contains(" ")) {
            //make sure only the last couples things
            List items = title.split(" ");

            //we will be good no matter what
            if (items.length == 2) {
              title = DurationFormat.format(
                timeSince,
                showMinutes: false,
                showSeconds: false,
                showMilliseconds: false,
                showMicroseconds: false,
                len: 0, //medium
              );
            } else {
              //remove hours for starters
              if (title.contains("h")) {
                title = DurationFormat.format(
                  timeSince,
                  //---
                  showHours: false,
                  //---
                  showMinutes: false,
                  showSeconds: false,
                  showMilliseconds: false,
                  showMicroseconds: false,
                  len: 0, //medium
                );
              }

              //NOTE: now only years, months, weeks, days
              //for most people all of which are relevant
            }
          }

          //make sure title isn't empty
          if (title.length <= 0) {
            title = "Most Recent";
          }

          //gen subtitle
          subtitle = "on a " +
              (DurationFormat.weekDayToString[oldestDT.weekday] ?? "???");
        } else {
          title = LastTimeStamp.timeStampTypeToString(sectionType);
          if (sectionType != TimeStampType.InProgress) {
            title = title + " Exercises";
          }
        }

        //set TOP SECTION color
        //color ALL special sections
        //and FIRST exercise section

        //all special sections
        bool specialSection = (sectionType == TimeStampType.InProgress ||
            sectionType == TimeStampType.New ||
            sectionType == TimeStampType.Hidden);

        //how many special sections on top
        int specialSectionsOnTop = (inProgressOnes.length > 0) ? 1 : 0;
        specialSectionsOnTop += (newOnes.length > 0) ? 1 : 0;

        //check if first exercise section
        bool isFirstExerciseSection = (index == specialSectionsOnTop);

        //set top color
        Color topColor = (specialSection || isFirstExerciseSection)
            ? Theme.of(context).accentColor
            : Theme.of(context).primaryColor;

        //set bottom section color
        Color bottomColor;

        //if a hidden section is present
        //and this is the last regular
        int indexOfLastSection = groupsOfExercises.length - 1;
        bool haveHidden = hiddenOnes.length > 0;

        //if we are right above the last section
        //and the hidden section exists (its the last section)
        if (index == (indexOfLastSection - 1) && haveHidden) {
          bottomColor = Theme.of(context).accentColor;
        } else {
          //if atleast a single regular section
          if (regularOnes.length > 0) {
            //TODO: check further
            //this is what I get when I optimize...
            if (specialSectionsOnTop > index) {
              bottomColor = Theme.of(context).accentColor;
            } else {
              bottomColor = Theme.of(context).primaryColor;
            }
          } else {
            //we only have inprogress, new, hidden (if anything)
            if (index == 2) {
              //nothing can be below us
              bottomColor = Theme.of(context).primaryColor;
            } else {
              //CASES TO ADDRESS
              //  N,I,H

              //1. t,t,t
              //2. t,t,f
              //3. t,f,t
              //4. t,f,f
              //5. f,t,t
              //6. f,t,f
              //7. f,f,t
              //8. f,f,f

              //easy to use
              int sectionCount = groupsOfExercises.length;

              //use section count
              if (sectionCount == 1) {
                //CASE [4],6,7,8
                bottomColor = Theme.of(context).primaryColor;
              } else {
                //CASE 1,2,3,[5]
                //2 or 3 items
                //CASES TO ADDRESS
                //   N    I     H
                //1. t,   t,    t
                //2. t,   t,    [f] => N, I
                //3. t,   [f],  t   => N, H
                //5. [f], t,    t   => I, H
                if (sectionCount == 2) {
                  //CASE 2,3,5
                  if (index == 0) {
                    bottomColor = Theme.of(context).accentColor;
                  } else {
                    bottomColor = Theme.of(context).primaryColor;
                  }
                } else {
                  //we have 3 sections [CASE 1]
                  //the section with index 2 wont highlight because of above
                  //if(index == 0 || index == 1)
                  bottomColor = Theme.of(context).accentColor;
                }
              }
            }
          }
        }

        //add this section to the list of slivers
        sliverList.add(
          SliverStickyHeader(
            header: SectionHeader(
              title: title,
              subtitle: subtitle,
              sectionType: sectionType,
              highlightTop: topColor == Theme.of(context).accentColor,
              topColor: topColor,
            ),
            sliver: SectionBody(
              topColor: topColor,
              bottomColor: bottomColor,
              thisGroup: thisGroup,
              sectionType: sectionType,
            ),
          ),
        );
      }

      //add sliver so our exercises don't get hidden
      //by the bottom floating buttons
      sliverList.add(ButtonSpacer());
    }

    //add header because we always have one
    slivers?.clear();
    slivers = [];
    slivers!.add(
      HeaderForOneHandedUse(
        listOfGroupOfExercises: groupsOfExercises,
        inprogressWorkoutSection: (inProgressOnes.length > 0),
        newWorkoutSection: (newOnes.length > 0),
        hiddenWorkoutSection: (hiddenOnes.length > 0),
        openHeight: openHeaderHeight,
      ),
    );

    //add all the other widgets below it
    slivers!.addAll(sliverList);
  }

  //build
  @override
  Widget build(BuildContext context) {
    if (slivers == null)
      return SplashScreen();
    else {
      return Stack(
        children: <Widget>[
          CustomScrollView(
            controller: widget.autoScrollController,
            slivers: slivers!,
          ),
          SearchExerciseButton(),
          AddExerciseButton(
            //extra 150 makes it long
            longTransitionDuration: Duration(milliseconds: 300 + 150),
          ),
        ],
      );
    }
  }
}
