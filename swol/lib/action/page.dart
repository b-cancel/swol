//flutter
import 'package:flutter/material.dart';

//plugin
import 'package:page_transition/page_transition.dart';

//internal: exercise
import 'package:swol/shared/widgets/simple/heros/leading.dart';
import 'package:swol/shared/functions/defaultDateTimes.dart';
import 'package:swol/shared/widgets/simple/heros/title.dart';
import 'package:swol/shared/widgets/simple/notify.dart';
import 'package:swol/shared/structs/anExercise.dart';
import 'package:swol/shared/methods/theme.dart';

//internal
import 'package:swol/pages/notes/exerciseNotes.dart';
import 'package:swol/action/tabs/verticalTabs.dart';
import 'package:swol/action/popUps/warning.dart';

//used to
//1. keep track of all the variables and be able to access them from everywhere
//2. and generate the functions to show the warning when needed
//3. but also wrap the rest of the widgets in the dark theme
class ExercisePage extends StatelessWidget {
  ExercisePage({
    required this.exercise,
  });

  final AnExercise exercise;

  static double mainButtonsHeight = 36;

  //static vars used through out initializaed with their default values
  static GlobalKey globalKey = GlobalKey();

  //function trigger that can be accessed from nearly anywhere
  static final ValueNotifier<bool> updateSet =
      new ValueNotifier<bool>(false); //being listened
  static final ValueNotifier<bool> nextSet =
      new ValueNotifier<bool>(false); //being listened
  static final ValueNotifier<bool> toggleTimer = new ValueNotifier<bool>(false);

  //any more is super annoying
  //use for ENTIRE app
  static Duration transitionDuration = const Duration(milliseconds: 300);

  //to allow notifications to work properly keep track of what exercise we are currently messing with
  static ValueNotifier<int> exerciseID = new ValueNotifier<int>(-1);

  //used so that we can change the page number from anywhere
  static final ValueNotifier<int> pageNumber =
      new ValueNotifier<int>(0); //being listened
  //used so that we can save the set locally before saving it in temps
  static final ValueNotifier<String> setWeight =
      new ValueNotifier<String>(""); //being listened
  static final ValueNotifier<String> setReps =
      new ValueNotifier<String>(""); //being listened
  //used so that we can cause a field refocusing from different parts of the app
  static final ValueNotifier<bool> causeRefocusIfInvalid =
      new ValueNotifier<bool>(false); //being listened

  //NOTE: these are shown as INTs but are actually DOUBLEs to avoid issues with calculations and sorting later
  //used so that we can set the goal set from both the suggest and record page
  static final ValueNotifier<double> setGoalWeight =
      new ValueNotifier<double>(0); //being listened
  static final ValueNotifier<double> setGoalPlusMinus =
      new ValueNotifier<double>(0);
  static final ValueNotifier<double> setGoalReps =
      new ValueNotifier<double>(0); //being listened

  //build
  @override
  Widget build(BuildContext context) {
    return Theme(
      key: globalKey,
      data: MyTheme.dark,
      child: WillPopScope(
        onWillPop: () async {
          return await warningThenPop(
            context,
            exercise,
          );
        },
        child: ExercisePageDark(
          exercise: exercise,
        ),
      ),
    );
  }
}

class ExercisePageDark extends StatefulWidget {
  ExercisePageDark({
    required this.exercise,
  });

  final AnExercise exercise;

  @override
  _ExercisePageDarkState createState() => _ExercisePageDarkState();
}

class _ExercisePageDarkState extends State<ExercisePageDark> {
  toggleTimer() {
    if (ExercisePage.toggleTimer.value) {
      bool timerStarted =
          (widget.exercise.tempStartTime.value != AnExercise.nullDateTime);
      if (timerStarted) {
        //if started stop it
        widget.exercise.tempStartTime = ValueNotifier<DateTime>(
          AnExercise.nullDateTime,
        );

        //undo previous order
        widget.exercise.lastTimeStamp = widget.exercise.backUpTimeStamp;
      } else {
        //if stoped start it
        widget.exercise.tempStartTime = ValueNotifier<DateTime>(
          DateTime.now(),
        );

        //keep items ordered
        widget.exercise.lastTimeStamp = LastTimeStamp.inProgressDateTime();
      }

      //action complete
      ExercisePage.toggleTimer.value = false;
    }
  }

  updateSet() {
    //also cover resume case
    if (ExercisePage.updateSet.value) {
      bool setUpdated = (widget.exercise.tempWeight != null &&
          widget.exercise.tempReps != null);

      //whenever we begin or resume the set we KNOW our setWeight and setReps are valid
      String newSetWeight = ExercisePage.setWeight.value;
      String newSetReps = ExercisePage.setReps.value;

      //save our NEW or UPDATE set
      widget.exercise.tempWeight = int.parse(newSetWeight);
      widget.exercise.tempReps = int.parse(newSetReps);

      //IF we are "SAVING FOR THE FIRST TIME" and "NOT UPDATING" the set
      if (setUpdated == false) {
        //fix things when sarting FIRST set
        if (widget.exercise.tempSetCount == null) {
          widget.exercise.tempSetCount = 0;
        }

        //this is a new set
        widget.exercise.tempSetCount = widget.exercise.tempSetCount! + 1;

        //we are recording our FIRST set so may go back to it
        //if we delete it instead of deciding to continue
        //TODO: why do we do this only for the first time?
        if (widget.exercise.tempSetCount == 1) {
          widget.exercise.backUpTimeStamp = widget.exercise.lastTimeStamp;
        }
      }

      //action complete
      ExercisePage.updateSet.value = false;
    }
  }

  nextSet() {
    if (ExercisePage.nextSet.value) {
      //in order for the timer to start it has to be a value other than this
      //this covers the edge case where the user quick taps the next button

      //worst case scenario this little exception cover won't break anything
      if (widget.exercise.tempStartTime.value != AnExercise.nullDateTime) {
        //cancel the notifcation that perhaps didn't trigger
        safeCancelNotification(widget.exercise.id);

        //reset timer
        //TODO: figure out why at some point I marked that this NEEDED to be BEFORE everything else
        //NOTE: that at the moment I should wait for lastWeight and lastReps to update
        //before reacting to the change here in the one rep max chip
        widget.exercise.tempStartTime =
            new ValueNotifier<DateTime>(AnExercise.nullDateTime);

        //save values (that we know are valid)
        widget.exercise.lastWeight = widget.exercise.tempWeight;
        widget.exercise.lastReps = widget.exercise.tempReps;

        //wipe temps
        widget.exercise.tempWeight = null;
        widget.exercise.tempReps = null;

        //reset notifiers
        ExercisePage.setWeight.value = "";
        ExercisePage.setReps.value = "";

        //move onto the next set
        //NOTE: must happen after all variables updates
        //since the suggest page will use the variables in their calculations
        ExercisePage.pageNumber.value = 0;
      }
      //ELSE: something went wrong but we will only make it worse if we don't stop it here

      //action complete
      ExercisePage.nextSet.value = false;
    }
  }

  resetToDefault() {
    //reset all statics to defaults
    ExercisePage.exerciseID.value = -1;
    ExercisePage.pageNumber.value = 0; //this will properly update itself later

    //notifiers
    ExercisePage.setWeight.value = "";
    ExercisePage.setReps.value = "";

    //functions
    ExercisePage.causeRefocusIfInvalid.value = false;
    ExercisePage.updateSet.value = false;
    ExercisePage.nextSet.value = false;

    //goals
    ExercisePage.setGoalWeight.value = 0;
    ExercisePage.setGoalPlusMinus.value = 0;
    ExercisePage.setGoalReps.value = 0;
  }

  @override
  void initState() {
    //super init
    super.initState();

    //TODO: confirm that all these are causing issues because of not updating on init
    //static other: pageNumber [CHECKED]
    //  but clearly "initalPage" which set it is not being created properly
    //  checking its generation and fixing that first
    //static vars: setWeight, setReps, oneRepMaxes, orderedIDs, closestIndex, setGoalWeight, setGoalReps
    //static func starters: causeRefocusIfInvalid, updateSet, nextSet

    //we just got here but we are working with statics
    //so manually reset to default
    resetToDefault();

    //add listeners
    ExercisePage.toggleTimer.addListener(toggleTimer);
    ExercisePage.updateSet.addListener(updateSet);
    ExercisePage.nextSet.addListener(nextSet);

    //proper inits
    ExercisePage.exerciseID.value = widget.exercise.id;

    //initally set the notifiers
    //after this our notifiers initially set our controllers
    //our controllers update our notifiers
    //and then our notifiers ONLY update our temps under very specific conditions
    int? tempWeight = widget.exercise.tempWeight;
    int? tempReps = widget.exercise.tempReps;

    //extra step needed because null.toString() isn't null
    ExercisePage.setWeight.value =
        (tempWeight != null) ? tempWeight.toString() : "";
    ExercisePage.setReps.value = (tempReps != null) ? tempReps.toString() : "";
  }

  @override
  void dispose() {
    //remove listeners
    ExercisePage.toggleTimer.removeListener(toggleTimer);
    ExercisePage.updateSet.removeListener(updateSet);
    ExercisePage.nextSet.removeListener(nextSet);

    //reset
    resetToDefault();

    //super dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //set the first page we will be at based on startTimerValue
    int initialPage;
    bool timerStarted =
        (widget.exercise.tempStartTime.value != AnExercise.nullDateTime);
    bool lastSetPresent = (widget.exercise.lastWeight != null);
    if (timerStarted) {
      initialPage = 2;
    } else {
      initialPage = (lastSetPresent) ? 0 : 1;
    }

    //build
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColorDark,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: Container(
          width: MediaQuery.of(context).size.width,
          color: Colors.transparent,
          child: SafeArea(
            child: Theme(
              data: MyTheme.light,
              child: PageTitle(
                exercise: widget.exercise,
              ),
            ),
          ),
        ),
      ),
      body: ClipRRect(
        //clipping so the done button doesnt show out of screen
        child: VerticalTabs(
          exercise: widget.exercise,
          //this the only place this works from
          //since this is the whole new context after navigation
          //and the others are within a scaffold
          statusBarHeight: MediaQuery.of(context).padding.top,
          initialPage: initialPage,
        ),
      ),
    );
  }
}

class PageTitle extends StatelessWidget {
  PageTitle({
    required this.exercise,
  });

  final AnExercise exercise;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: MyTheme.dark,
      child: AppBar(
        leading: IconButton(
          icon: ExerciseBegin(
            inAppBar: true,
            exercise: exercise,
          ),
          color: Colors.white,
          tooltip: backToolTip(),
          onPressed: () {
            warningThenPop(
              context,
              exercise,
            );
          },
        ),
        titleSpacing: 0,
        title: ExerciseTitleHero(
          inAppBar: true,
          exercise: exercise,
          onTap: () => toNotes(context),
        ),
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(
              right: 8,
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: 8.0,
              ),
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  primary: Theme.of(context).accentColor,
                ),
                onPressed: () => toNotes(context),
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        right: 6,
                      ),
                      child: Icon(Icons.edit),
                    ),
                    Text("Notes"),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String backToolTip() {
    return "Will Automaticaly Start Or Update Your New Set";
  }

  toNotes(BuildContext context) {
    //close keyboard if perhaps typing next set
    FocusScope.of(context).unfocus();

    //go to notes
    Navigator.push(
      context,
      PageTransition(
        type: PageTransitionType.rightToLeft,
        duration: ExercisePage.transitionDuration,
        child: ExerciseNotes(
          exercise: exercise,
        ),
      ),
    );
  }
}
