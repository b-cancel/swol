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

    //list to separate stuff into
    List<AnExercise> inProgressOnes = new List<AnExercise>();
    List<AnExercise> newOnes = new List<AnExercise>();
    List<AnExercise> regularOnes = new List<AnExercise>();
    List<AnExercise> hiddenOnes = new List<AnExercise>();
    
    //where to combine the list above into
    List<List<AnExercise>> groupsOfExercises = new List<List<AnExercise>>();

    //will contain the actual slivers
    List<Widget> sliverList = new List<Widget>();

    //a little bit of math
    List<double> goldenBS = measurementToGoldenRatioBS(
      MediaQuery.of(context).size.height,
    );
    double openHeaderHeight = goldenBS[1] - widget.statusBarHeight;

    //try to see if we have workouts to add
    List<int> exerciseOrder = ExerciseData.exercisesOrder.value;
    if (exerciseOrder.length == 0) {
      sliverList.add(AddExerciseFiller());
    } else {
      //NOTE: I don't need to call this pretty much ever again since I should be able to pass and update the reference
      Map<int, AnExercise> exercises = ExerciseData.getExercises();

      //seperate exercises given their TimeStampTypes
      for (int i = 0; i < exerciseOrder.length; i++) {
        int thisExerciseID = exerciseOrder[i];
        AnExercise thisExercise = exercises[thisExerciseID];
        TimeStampType thisExerciseType = LastTimeStamp.returnTimeStampType(
          thisExercise.lastTimeStamp,
        );

        //send to proper list
        if(thisExerciseType == TimeStampType.InProgress){
          inProgressOnes.add(thisExercise);
        }
        else if(thisExerciseType == TimeStampType.New){
          newOnes.add(thisExercise);
        }
        else if(thisExerciseType == TimeStampType.Other){
          regularOnes.add(thisExercise);
        }
        else{
          hiddenOnes.add(thisExercise);
        }
      }

      //add in progress ones if they exist
      if(inProgressOnes.length > 0){
        groupsOfExercises.add(inProgressOnes);
      }

      //add new ones if they exist
      if(newOnes.length > 0){
        groupsOfExercises.add(newOnes);
      }

      //create the groups of the regular ones
      //travel them in the opposite direction
      DateTime lastDateTime;
      for(int i = 0; i < regularOnes.length; i ++){
        //array from back to front
        int index = (regularOnes.length - 1) - i;
        AnExercise thisExercise = regularOnes[index];

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

          //every exercise must have at most 1.5 hours between
          //TODO... careful... after.difference(before)... for a positive result
          Duration timeBetweenExercises = thisExercise.lastTimeStamp
              .difference(lastExercise.lastTimeStamp);
          makeNewGroup = (timeBetweenExercises > maxTimeBetweenExercises);
        }

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

      //add archived ones
      if(hiddenOnes.length > 0){
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

        //set TOP SECTION color
        //color ALL special sections
        //and FIRST exercise section

        //all special sections
        bool specialSection = (sectionType == TimeStampType.InProgress
        || sectionType == TimeStampType.New 
        || sectionType == TimeStampType.Hidden);

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
        Color bottomColor = Theme.of(context).primaryColor;

        /*
        //if we have an inprogress and new section
        if(){
          //the in progress section has a special bottom Color
          //to blend with new section top
          if(index == 1) {
            bottomColor = Theme.of(context).accentColor;
          } else {
            bottomColor = Theme.of(context).primaryColor;
          }
        }
        else if(hiddenOnes.length > 0){ //if we have a hidden section
          //the last regular section has a special bottomColor
        }
        else{
          bottomColor = Theme.of(context).primaryColor;
        }


        if (hiddenSection) {
          //NOTE: here MUST use i... NOT INDEX
          if ((i + 2) == groupsOfExercises.length) 
        } else{
          bottomColor = Theme.of(context).primaryColor;
        }
        */

      
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
    slivers = new List<Widget>();
    slivers.add(
      HeaderForOneHandedUse(
        listOfGroupOfExercises: groupsOfExercises,
        inprogressWorkoutSection: (inProgressOnes.length > 0),
        newWorkoutSection: (newOnes.length > 0),
        hiddenWorkoutSection: (hiddenOnes.length > 0),
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
