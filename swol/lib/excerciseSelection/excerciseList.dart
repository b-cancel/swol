//flutter
import 'package:flutter/material.dart';

//plugin
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

//internal: list tile
import 'package:swol/excerciseListTile/excerciseLeading.dart';
import 'package:swol/excerciseListTile/excerciseTile.dart';

//internal: shared
import 'package:swol/shared/functions/defaultDateTimes.dart';
import 'package:swol/shared/methods/excerciseData.dart';
import 'package:swol/shared/structs/anExcercise.dart';

//internal: other
import 'package:swol/excerciseSelection/secondary/secondary.dart';
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
  bool inprogressWorkoutSection = false;
  bool newWorkoutSection = false;
  bool hiddenWorkoutSection = false;

  //other vars
  final Duration maxTimeBetweenExcercises = Duration(hours: 1, minutes: 30);

  updateState(){
    if(mounted) setState(() {});
  }

  //init
  @override
  void initState() {
    //Updates every time we update[timestamp], add, or remove some excercise
    ExcerciseData.excercisesOrder.addListener(updateState);
    super.initState();
  }

  @override
  void dispose() {
    ExcerciseData.excercisesOrder.addListener(updateState);
    super.dispose();
  }

  //build
  @override
  Widget build(BuildContext context) {
    List<Widget> sliverList = new List<Widget>();
    List<List<AnExcercise>> listOfGroupOfExcercises = new List<List<AnExcercise>>();

    //try to see if we have workouts to add
    if(ExcerciseData.excercisesOrder.value.length > 0){
      //-----------------------------------------------------------------------------------------------------------------------------
      //-----------------------------------------------------------------------------------------------------------------------------
      //-----------------------------------------------------------------------------------------------------------------------------

      //seperate excercise into their groups bassed on the max distance
      DateTime lastDateTime; //MUST NOT COLLIDE WITH EVEN ARCHIVED DATE TIMES
      for(int i = 0; i < ExcerciseData.excercisesOrder.value.length; i++){
        int excerciseID = ExcerciseData.excercisesOrder.value[i];

        //easy to access vars
        AnExcercise thisExcercise = ExcerciseData.getExcercises().value[excerciseID];
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

      //-----------------------------------------------------------------------------------------------------------------------------
      //-----------------------------------------------------------------------------------------------------------------------------
      //-----------------------------------------------------------------------------------------------------------------------------

      //fill sliver list
      for(int i = 0; i < listOfGroupOfExcercises.length; i++){
        //create header text
        List<AnExcercise> thisGroup = listOfGroupOfExcercises[i];
        DateTime oldestDT = thisGroup[0].lastTimeStamp;
        TimeStampType sectionType = LastTimeStamp.returnTimeStampType(oldestDT);

        //vars to set
        bool highlightTop = (i == 0 || sectionType == TimeStampType.Hidden);
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
            short: false,
          );
          subtitle = "on a " + DurationFormat.weekDayToString[oldestDT.weekday];
        }
        else{
          title = LastTimeStamp.timeStampTypeToString(sectionType);
          if(sectionType != TimeStampType.InProgress){
            title = title + " Excercises";
          }
        }

        //Determine Section styling
        Color topColor;
        Color textColor;
        FontWeight fontWeight;
        Color bottomColor;

        //set top section color
        if(highlightTop){
          topColor = Theme.of(context).accentColor;
          textColor = Theme.of(context).primaryColor;
          fontWeight = FontWeight.bold;
        }
        else{
          topColor = Theme.of(context).primaryColor;
          textColor = Colors.white;
          fontWeight = FontWeight.normal;
        }

        //set bottom section color
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
            header: Container(
              color: topColor,
              padding: new EdgeInsets.only(
                left: 16,
                right: 16,
                top: 16,
                bottom: 8,
              ),
              alignment: Alignment.bottomLeft,
              child: DefaultTextStyle(
                style: TextStyle(
                  fontSize: 16,
                  color: textColor,
                  fontWeight: fontWeight,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    new Text(
                      title,
                    ),
                    (subtitle == null)
                    ? MyChip(
                      chipString: LastTimeStamp.timeStampTypeToString(sectionType).toUpperCase(), 
                      inverse: highlightTop,
                    )
                    : Text(
                      subtitle,
                    )
                  ],
                ),
              ),
            ),
            sliver: new SliverList(
              delegate: new SliverChildListDelegate([
                Stack(
                  children: <Widget>[
                    Positioned.fill(
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Expanded(
                            child: Container(
                              color: topColor,
                              child: Container(),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              color: bottomColor,
                              child: Container(),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Card(
                      margin: EdgeInsets.all(0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24.0),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: ClampingScrollPhysics(),
                        itemCount: thisGroup.length,
                        //ONLY false IF Hidden Section
                        reverse: (sectionType != TimeStampType.Hidden),
                        itemBuilder: (context, index){
                          return ExcerciseTile(
                            excerciseID: thisGroup[index].id,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ]),
            ),
          ),
        );
      }

      //add sliver showing excercise count
      sliverList.add(
        SliverToBoxAdapter(
          child: Container(
            color: Theme.of(context).primaryColor,
            //56 larger button height
            //48 smaller button height
            height: 16 + 48.0 + 16,
            width: MediaQuery.of(context).size.width,
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(left: 16),
            child: Text(
              "", //BLANK: the add new buttons fills the space now
              //listOfGroupOfExcercises.length.toString() + " Workouts",
              //excercises.value.length.toString() + " Excercises",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ),
      );

      //-----------------------------------------------------------------------------------------------------------------------------
      //-----------------------------------------------------------------------------------------------------------------------------
      //-----------------------------------------------------------------------------------------------------------------------------
    }
    else{
      //add sliver telling user to add item
      sliverList.add(
        AddExcerciseFiller(),
      );
    }

    //add header
    List<Widget> finalWidgetList = new List<Widget>();
    finalWidgetList.add(
      HeaderForOneHandedUse(
        listOfGroupOfExcercises: listOfGroupOfExcercises, 
        newWorkoutSection: newWorkoutSection, 
        hiddenWorkoutSection: hiddenWorkoutSection, 
        inprogressWorkoutSection: inprogressWorkoutSection,
        statusBarHeight: widget.statusBarHeight,
      ),
    );

    finalWidgetList.addAll(sliverList);

    /*
    finalWidgetList.add(
      SliverFillRemaining(
        hasScrollBody: true,
        fillOverscroll: true,
        child: Container(
          color: Colors.red,
          child: Container(),
        ),
        
        
        /*Center(
          child: OnBoardingImage(
            width: MediaQuery.of(context).size.width * (7/12),
            imageUrl: "assets/biceps/bottomLeft.png",
          ),
        ),*/
      ),
    );
    */

    //grab screen width so you can pass it through
    double screenWidth = MediaQuery.of(context).size.width;

    print("------------rebuidling");

    //return
    return Stack(
      children: <Widget>[
        CustomScrollView(
          controller: widget.autoScrollController,
          slivers: finalWidgetList,
        ),
        SearchExcerciseButton(
          screenWidth: screenWidth,
        ),
      ],
    );
  }
}