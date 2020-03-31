//flutter
import 'package:flutter/material.dart';

//plugin
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:page_transition/page_transition.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:swol/action/page.dart';
import 'package:swol/main.dart';

//internal: shared
import 'package:swol/shared/functions/defaultDateTimes.dart';
import 'package:swol/shared/functions/goldenRatio.dart';
import 'package:swol/shared/methods/exerciseData.dart';
import 'package:swol/shared/methods/theme.dart';
import 'package:swol/shared/structs/anExercise.dart';

//internal: other
import 'package:swol/pages/selection/widgets/persistentHeaderDelegate.dart';
import 'package:swol/pages/selection/widgets/workoutSection.dart';
import 'package:swol/pages/selection/widgets/bottomButtons.dart';
import 'package:swol/other/durationFormat.dart';

//widget
class ExerciseList extends StatefulWidget {
  ExerciseList({
    @required this.autoScrollController,
    @required this.statusBarHeight,
    @required this.onTop,
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

  //go back until the main page and then to the exercise
  //TODO: refine this so that state is saved
  //NOTE: this doesn't save any previous state
  //if skips out on the warnings that usually pop out
  //and doesn't autostart the set for the exercise that we are leaving
  goToExcercise() {
    BuildContext rootContext = GrabSystemData.rootContext;
    if (Navigator.canPop(rootContext)) {
      //may need to unfocus
      if (FocusScope.of(context).hasFocus) {
        FocusScope.of(context).unfocus();
      }

      //pop with the animation
      Navigator.pop(rootContext);

      //let the user see the animation
      Future.delayed(Duration(milliseconds: 300), () {
        goToExcercise();
      });
    } else {
      travelToExercise();
    }
  }

  travelToExercise() {
    if (exerciseToTravelTo.value != -1) {
      if (ExerciseData.getExercises().containsKey(exerciseToTravelTo.value)) {
        AnExercise exerciseWeMightTravelTo =
            ExerciseData.getExercises()[exerciseToTravelTo.value];

        //we already traveled there
        exerciseToTravelTo.value = -1;

        //would be triggered by exercise tile
        App.navSpread.value = true;

        //TODO: match with transition Duration in exerciseTile
        Duration transitionDuration = Duration(milliseconds: 300);

        //travel there
        Navigator.push(
          context,
          PageTransition(
            duration: transitionDuration,
            type: PageTransitionType.rightToLeft,
            //wrap in light so warning pop up works well
            child: Theme(
              data: MyTheme.light,
              child: ExercisePage(
                exercise: exerciseWeMightTravelTo,
                transitionDuration: transitionDuration,
              ),
            ),
          ),
        );
      }
    }
  }

  //init
  @override
  void initState() {
    //wait one frame before trying to travel
    //otherwise things will break
    WidgetsBinding.instance.addPostFrameCallback((_) {
      travelToExercise();
    });

    //wait to have mediaquery available
    WidgetsBinding.instance.addPostFrameCallback((_) {
      beforeManualBuild();
      setState(() {});
    });

    //Updates every time we update[timestamp], add, or remove some exercise
    ExerciseData.exercisesOrder.addListener(updateState);
    exerciseToTravelTo.addListener(goToExcercise);
    super.initState();
  }

  @override
  void dispose() {
    exerciseToTravelTo.removeListener(goToExcercise);
    ExerciseData.exercisesOrder.addListener(updateState);
    super.dispose();
  }

  //prevents unecessary calculation when navigating
  List<Widget> slivers;
  beforeManualBuild() {
    print("manual build");

    //special sections booleans to produce workout count
    //use in header with count and perhaps also icons of sorts
    bool inProgSection = false;
    bool newSection = false;
    bool hiddenSection = false;

    List<Widget> sliverList = new List<Widget>();
    List<List<AnExercise>> groupsOfExercises =
        new List<List<AnExercise>>();

    //a little bit of math
    List<double> goldenBS =
        measurementToGoldenRatioBS(MediaQuery.of(context).size.height);
    double openHeaderHeight = goldenBS[1] - widget.statusBarHeight;

    //try to see if we have workouts to add
    List<int> exerciseOrder = ExerciseData.exercisesOrder.value;
    if (exerciseOrder.length == 0) {
      sliverList.add(AddExerciseFiller());
    } else {
      //NOTE: I don't need to call this pretty much ever again since I should be able to pass and update the reference
      Map<int, AnExercise> exercises = ExerciseData.getExercises();

      //seperate exercise into their groups bassed on the max distance
      DateTime lastDateTime; //MUST NOT COLLIDE WITH EVEN ARCHIVED DATE TIMES
      for (int i = 0; i < exerciseOrder.length; i++) {
        int thisExerciseID = exerciseOrder[i];

        //easy to access vars
        AnExercise thisExercise = exercises[thisExerciseID];
        TimeStampType thisExerciseType = LastTimeStamp.returnTimeStampType(
          thisExercise.lastTimeStamp,
        );

        //determine if we have any of the special section
        if (inProgSection == false) {
          inProgSection = (thisExerciseType == TimeStampType.InProgress);
        }

        if (newSection == false) {
          newSection = (thisExerciseType == TimeStampType.New);
        }

        if (hiddenSection == false) {
          hiddenSection = (thisExerciseType == TimeStampType.Hidden);
        }

        //-------------------------CHECK-------------------------*-------------------------BELOW-------------------------
        //-------------------------CHECK-------------------------*-------------------------BELOW-------------------------
        //-------------------------CHECK-------------------------*-------------------------BELOW-------------------------

        //determine if new group is required
        bool makeNewGroup;
        if (lastDateTime == null){ //NOTE: only happens for the first exercise
          makeNewGroup = true;
        }
        else {
          //NOTE: may still need to make a new group given things below
          List<AnExercise> lastGroup = groupsOfExercises.last;

          //its not the first exercise we check so we MIGHT need a new group
          //we know we process things in order... so we only need to check the last group added
          //and even further really just the last item added to that group
          AnExercise lastExercise = lastGroup.last;
          TimeStampType lastExerciseType = LastTimeStamp.returnTimeStampType(
            lastExercise.lastTimeStamp,
          );

          //we are a different kind of exercise that the previous one so we KNOW we need a new group
          if (thisExerciseType != lastExerciseType){
            makeNewGroup = true;
          }
          else {
            //we are the same type of exercise
            if (thisExerciseType == TimeStampType.Other) {
              Duration timeBetweenExercises = lastExercise.lastTimeStamp
                  .difference(thisExercise.lastTimeStamp);
              makeNewGroup = (timeBetweenExercises > maxTimeBetweenExercises);
            } else{
              makeNewGroup = false;
            }
          }
        }

        //-------------------------CHECK-------------------------*-------------------------ABOVE-------------------------
        //-------------------------CHECK-------------------------*-------------------------ABOVE-------------------------
        //-------------------------CHECK-------------------------*-------------------------ABOVE-------------------------

        //add a new group because its needed
        if (makeNewGroup) {
          groupsOfExercises.add(
            List<AnExercise>(),
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

      //fill sliver list
      for (int i = 0; i < groupsOfExercises.length; i++) {
        //create header text
        int index = i;
        List<AnExercise> thisGroup = groupsOfExercises[index];
        DateTime oldestDT = thisGroup[0].lastTimeStamp;
        TimeStampType sectionType = LastTimeStamp.returnTimeStampType(oldestDT);

        //-------------------------CHECK-------------------------*-------------------------BELOW-------------------------
        //-------------------------CHECK-------------------------*-------------------------BELOW-------------------------
        //-------------------------CHECK-------------------------*-------------------------BELOW-------------------------

        //flip all regular sections
        //new and inprogress will be above them
        //but hidden will be below so take that into account when filipping sections
        if (sectionType == TimeStampType.Other) {
          //adjust the index
          int oldIndex = index;
          if (inProgSection) oldIndex -= 1;
          if (newSection) oldIndex -= 1;

          //adjust last index
          int lastPossibleIndex = groupsOfExercises.length - 1;
          if (hiddenSection) lastPossibleIndex -= 1;
          index = lastPossibleIndex - oldIndex;

          //recalc variables used below
          thisGroup = groupsOfExercises[index];
          oldestDT = thisGroup[0].lastTimeStamp;
          sectionType = LastTimeStamp.returnTimeStampType(oldestDT);
        }

        //-------------------------CHECK-------------------------*-------------------------ABOVE-------------------------
        //-------------------------CHECK-------------------------*-------------------------ABOVE-------------------------
        //-------------------------CHECK-------------------------*-------------------------ABOVE-------------------------

        //vars to set
        String title;
        String subtitle;

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
          subtitle = "on a " + DurationFormat.weekDayToString[oldestDT.weekday];
        } else {
          title = LastTimeStamp.timeStampTypeToString(sectionType);
          if (sectionType != TimeStampType.InProgress) {
            title = title + " Exercises";
          }
        }

        //set top section Color
        bool highlightTop = (index == 0 || sectionType == TimeStampType.Hidden);
        Color topColor = highlightTop
            ? Theme.of(context).accentColor
            : Theme.of(context).primaryColor;

        //set bottom section color
        Color bottomColor;
        if (hiddenSection) {
          //NOTE: here MUST use i... NOT INDEX
          if ((i + 2) == groupsOfExercises.length) {
            bottomColor = Theme.of(context).accentColor;
          } else{
            bottomColor = Theme.of(context).primaryColor;
          }
        } else{
          bottomColor = Theme.of(context).primaryColor;
        }
          

        //add this section to the list of slivers
        sliverList.add(
          SliverStickyHeader(
            header: SectionHeader(
              title: title,
              subtitle: subtitle,
              sectionType: sectionType,
              highlightTop: highlightTop,
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
    slivers = new List<Widget>();
    slivers.add(
      HeaderForOneHandedUse(
        listOfGroupOfExercises: groupsOfExercises,
        newWorkoutSection: newSection,
        hiddenWorkoutSection: hiddenSection,
        inprogressWorkoutSection: inProgSection,
        openHeight: openHeaderHeight,
      ),
    );

    //add all the other widgets below it
    slivers.addAll(sliverList);
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
            slivers: slivers,
          ),
          SearchExerciseButton(),
          AddExerciseButton(),
        ],
      );
    }
  }
}
