//flutter
import 'package:flutter/material.dart';

//plugin
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:swol/main.dart';

//internal: shared
import 'package:swol/shared/functions/defaultDateTimes.dart';
import 'package:swol/shared/functions/goldenRatio.dart';
import 'package:swol/shared/methods/excerciseData.dart';
import 'package:swol/shared/structs/anExcercise.dart';

//internal: other
import 'package:swol/pages/selection/widgets/persistentHeaderDelegate.dart';
import 'package:swol/pages/selection/widgets/workoutSection.dart';
import 'package:swol/pages/selection/widgets/bottomButtons.dart';
import 'package:swol/other/durationFormat.dart';

//widget
class ExcerciseList extends StatefulWidget {
  ExcerciseList({
    @required this.autoScrollController,
    @required this.statusBarHeight,
    @required this.onTop,
  });

  final AutoScrollController autoScrollController;
  final double statusBarHeight;
  final ValueNotifier<bool> onTop;

  @override
  _ExcerciseListState createState() => _ExcerciseListState();
}

class _ExcerciseListState extends State<ExcerciseList> {
  //special sections booleans to produce workout count
  //use in header with count and perhaps also icons of sorts
  bool inprogressWorkoutSection = false;
  bool newWorkoutSection = false;
  bool hiddenWorkoutSection = false;

  //other vars
  final Duration maxTimeBetweenExcercises = Duration(hours: 1, minutes: 30);

  //removalable listener
  updateState(){
    if(mounted){
      beforeManualBuild();
      setState(() {});
    }
  }

  //init
  @override
  void initState() {
    //wait to have mediaquery available
    WidgetsBinding.instance.addPostFrameCallback((_){
      beforeManualBuild();
      setState(() {});
    });
    
    //Updates every time we update[timestamp], add, or remove some excercise
    ExcerciseData.excercisesOrder.addListener(updateState);
    super.initState();
  }

  @override
  void dispose() {
    ExcerciseData.excercisesOrder.addListener(updateState);
    super.dispose();
  }

  //prevents unecessary calculation when navigating
  List<Widget> slivers;
  beforeManualBuild(){
    print("manual build");

    List<Widget> sliverList = new List<Widget>();
    List<List<AnExcercise>> listOfGroupOfExcercises = new List<List<AnExcercise>>();

    //a little bit of math
    List<double> goldenBS = measurementToGoldenRatioBS(MediaQuery.of(context).size.height);
    double openHeaderHeight = goldenBS[1] - widget.statusBarHeight;

    //try to see if we have workouts to add
    List<int> excerciseOrder = ExcerciseData.excercisesOrder.value;
    if(excerciseOrder.length == 0){
      sliverList.add(AddExcerciseFiller());
    }
    else{
      //NOTE: I don't need to call this pretty much ever again since I should be able to pass and update the reference
      Map<int, AnExcercise> excercises = ExcerciseData.getExcercises();

      //seperate excercise into their groups bassed on the max distance
      DateTime lastDateTime; //MUST NOT COLLIDE WITH EVEN ARCHIVED DATE TIMES
      for(int i = 0; i < excerciseOrder.length; i++){
        int excerciseID = excerciseOrder[i];

        //easy to access vars
        AnExcercise thisExcercise = excercises[excerciseID];
        TimeStampType thisExcerciseType = LastTimeStamp.returnTimeStampType(thisExcercise.lastTimeStamp);

        //determine if we have any of the special section
        if(inprogressWorkoutSection == false){
          inprogressWorkoutSection = (thisExcerciseType == TimeStampType.InProgress);
        }

        if(newWorkoutSection == false){
          newWorkoutSection = (thisExcerciseType == TimeStampType.New);
        }

        if(hiddenWorkoutSection == false){
          hiddenWorkoutSection = (thisExcerciseType == TimeStampType.Hidden);
        }

        //determine if new group is required
        bool makeNewGroup;
        if(lastDateTime == null) makeNewGroup = true;
        else{
          List<AnExcercise> lastGroup = listOfGroupOfExcercises[listOfGroupOfExcercises.length - 1];

          //its not the first excercise we check so we MIGHT need a new group
          //we know we process things in order... so we only need to check the last group added
          //and even further really just the last item added to that group
          AnExcercise lastExcercise = lastGroup[lastGroup.length - 1];
          TimeStampType lastExcerciseType = LastTimeStamp.returnTimeStampType(lastExcercise.lastTimeStamp);

          //we are a different kind of excercise that the previous one so we KNOW we need a new group
          if(thisExcerciseType != lastExcerciseType) makeNewGroup = true;
          else{ //we are the same type of excercise
            if(thisExcerciseType == TimeStampType.Other){
              Duration timeBetweenExcercises = thisExcercise.lastTimeStamp.difference(lastExcercise.lastTimeStamp);
              makeNewGroup = (timeBetweenExcercises > maxTimeBetweenExcercises);
            }
            else makeNewGroup = false;
          }
        }

        //add a new group because its needed
        if(makeNewGroup){
          listOfGroupOfExcercises.add(new List<AnExcercise>());
        }

        //add this excercise to our 1. newly created group 2. OR old group
        listOfGroupOfExcercises[listOfGroupOfExcercises.length - 1].add(
          thisExcercise,
        );

        //update lastDateTime
        lastDateTime = thisExcercise.lastTimeStamp;
      }

      //fill sliver list
      for(int i = 0; i < listOfGroupOfExcercises.length; i++){
        //create header text
        List<AnExcercise> thisGroup = listOfGroupOfExcercises[i];
        DateTime oldestDT = thisGroup[0].lastTimeStamp;
        TimeStampType sectionType = LastTimeStamp.returnTimeStampType(oldestDT);

        //vars to set
        String title;
        String subtitle;

        //set title and subtitle
        if(sectionType == TimeStampType.Other){
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
        }
        else{
          title = LastTimeStamp.timeStampTypeToString(sectionType);
          if(sectionType != TimeStampType.InProgress){
            title = title + " Excercises";
          }
        }

        //set top section Color
        bool highlightTop = (i == 0 || sectionType == TimeStampType.Hidden);
        Color topColor = highlightTop ? Theme.of(context).accentColor : Theme.of(context).primaryColor;
        
        //set bottom section color
        Color bottomColor;
        if((i + 1) < listOfGroupOfExcercises.length){
          //there is a section below our but is it hidden
          DateTime prevTS = listOfGroupOfExcercises[i+1][0].lastTimeStamp;
          if(LastTimeStamp.isHidden(prevTS)){
            bottomColor = Theme.of(context).accentColor;
          }
        }
        else bottomColor = Theme.of(context).primaryColor;

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

      //add sliver so our excercises don't get hidden 
      //by the bottom floating buttons
      sliverList.add(ButtonSpacer());
    }

    //add header because we always have one
    slivers?.clear();
    slivers = new List<Widget>();
    slivers.add(
      HeaderForOneHandedUse(
        listOfGroupOfExcercises: listOfGroupOfExcercises, 
        newWorkoutSection: newWorkoutSection, 
        hiddenWorkoutSection: hiddenWorkoutSection, 
        inprogressWorkoutSection: inprogressWorkoutSection,
        openHeight: openHeaderHeight,
      ),
    );

    //add all the other widgets below it
    slivers.addAll(sliverList);
  }

  //build
  @override
  Widget build(BuildContext context) {
    if(slivers == null) return SplashScreen();
    else{
      return Stack(
        children: <Widget>[
          CustomScrollView(
            controller: widget.autoScrollController,
            slivers: slivers,
          ),
          SearchExcerciseButton(),
          AddExcerciseButton(),
        ],
      );
    }
  }
}