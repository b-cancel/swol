import 'dart:io';

//flutter
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

//plugin
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:feature_discovery/feature_discovery.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:swol/excercise/defaultDateTimes.dart';
import 'package:holding_gesture/holding_gesture.dart';

//internal: basics
import 'package:swol/excerciseSelection/secondary/animatedTitle.dart';
import 'package:swol/excerciseSelection/secondary/secondary.dart';
import 'package:swol/sharedWidgets/excerciseListTile/excerciseTile.dart';
import 'package:swol/sharedWidgets/scrollToTop.dart';
import 'package:swol/excercise/excerciseStructure.dart';
import 'package:swol/excercise/excerciseData.dart';
import 'package:swol/other/durationFormat.dart';
import 'package:swol/utils/onboarding.dart';

//Sections and how they are handled
//New => newest additions on bottom
//  since you would probably add your new routine and then work it
//Hidden => newest addition on top [EXCEPTION]
//  since the excercises you most recently archived are the ones most likely to be searched for again
//In Progress => newest additions on bottom
//  since we want to push people to doing super sets with atmost like 3 workouts
//  and while doing super sets you are doing set 1 A, then set 1 B, then set 1 C
//  and you would expect the user to go back to 1A before goign to 1B or 1C so 1A should be on top
//Other => newest additions on the bottom
//  since you want to cycle throughout all your workout routines
//  so if you did legs on monday and 3 other work outs
//  when its monday again you expect that workout to be on top with the first workout you did to be on top in the section

//TODO: when its the users first time to go into the list it should automatically go into add excercise perhaps?

//TODO: when the user open the app and there is ONLY 1 excercise in progress
//TODO: automatically go to that excercse (ensure animation)

//main widget
class ExcerciseSelect extends StatefulWidget {
  ExcerciseSelect({
    @required this.permissionGiven,
    @required this.shownInitialControls,
    @required this.shownSearchBar,
    @required this.shownCalculator,
    @required this.shownSettings,
  });

  final bool permissionGiven;
  final bool shownInitialControls;
  final bool shownSearchBar;
  final bool shownCalculator;
  final bool shownSettings;

  @override
  _ExcerciseSelectState createState() => _ExcerciseSelectState();
}

class _ExcerciseSelectState extends State<ExcerciseSelect>{
  final AutoScrollController autoScrollController = new AutoScrollController();

  ValueNotifier<bool> navSpread = new ValueNotifier(false);

  discoverBasicFeatures(){
    /*
    FeatureDiscovery.discoverFeatures(
      context,
      [
        //'swol_logo',
        //'learn_page',
        //'add_excercise',
        'search_excercise',
      ],
    );
    */
  }

  @override
  void initState() {
    //SchedulerBinding.instance.addPostFrameCallback(
    WidgetsBinding.instance.addPostFrameCallback((_){
      //pop up that comes up asking for permission
      if(widget.permissionGiven == false){
        String tab = "\t\t\t\t\t";
        String newLine = "\n\n";
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return Theme(
              data: ThemeData.light(),
              child: SimpleDialog(
                contentPadding: EdgeInsets.all(0),
                children: <Widget>[
                  Container(
                    color: Colors.red,
                    padding: EdgeInsets.all(16),
                    child: Text(
                      "User End License Agreement",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(16),
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                        children: [
                          TextSpan(
                            text: tab + "In order to assist you, there are many suggestions throughout the app."
                          ),
                          TextSpan(
                            style: TextStyle(
                              fontWeight: FontWeight.w900,
                            ),
                            text: newLine + tab + "But it's your responsibility\nto stay safe.",
                          ),
                          TextSpan(
                            text: newLine + tab + "We are not liable for any harm that you may cause yourself or others."
                          ),
                          TextSpan(
                            style: TextStyle(
                              fontWeight: FontWeight.w900,
                            ),
                            text: newLine + tab + "Follow our suggestions\nat your own risk.",
                          ),
                        ]
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(16),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        FlatButton(
                          onPressed: (){
                            SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                          },
                          child: Text("Close The App"),
                        ),
                        /*
                        HoldDetector(
                            onHold: _incrementCounter,
                            holdTimeout: Duration(milliseconds: 200),
                            enableHapticFeedback: true,
                            child: RaisedButton(
                              child: Text("I Agree"),
                              onPressed: _incrementCounter,
                          ),
                        ),
                        */
                        RaisedButton(
                          onPressed: ()async{
                            await OnBoarding.givePermission();
                            Navigator.of(context).pop();
                            discoverBasicFeatures();
                          },
                          child: Text("I Agree"),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            );
          },
        );
      } 
      else discoverBasicFeatures();
    });

    //super init
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double expandHeight = MediaQuery.of(context).size.height / 3;
    expandHeight = (expandHeight < 40) ? 40 : expandHeight;

    //swolheight (Since with mediaquery must be done here)
    double statusBarHeight = MediaQuery.of(context).padding.top;
    double screenWidth = MediaQuery.of(context).size.width;

    //build
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColorDark,
        title: AnimatedTitle(
          navSpread: navSpread, 
          screenWidth: screenWidth, 
          statusBarHeight: statusBarHeight,
        ),
        actions: <Widget>[
          /*
          IconButton(
            onPressed: (){
              showThemeSwitcher(context);
            },
            icon: Icon(Icons.settings),
          )
          */
          AnimatedTitleAction(
            navSpread: navSpread, 
            screenWidth: screenWidth,
          ),
        ],
      ),
      body: ExcerciseList(
        autoScrollController: autoScrollController,
        navSpread: navSpread,
      ),
    );
  }
}

class ExcerciseList extends StatefulWidget {
  ExcerciseList({
    @required this.autoScrollController,
    @required this.navSpread,
  });

  final AutoScrollController autoScrollController;
  final ValueNotifier<bool> navSpread;

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
  ValueNotifier<bool> onTop = new ValueNotifier(true);

  //init
  @override
  void initState() {
    //Updates every time we update[timestamp], add, or remove some excercise
    ExcerciseData.excercisesOrder.addListener((){
      if(mounted){
        setState(() {});
      }
    });

    //scroll inits
    //auto scroll controller
    widget.autoScrollController.addListener((){
      ScrollPosition position = widget.autoScrollController.position;
      double currentOffset = widget.autoScrollController.offset;

      //Determine whether we are on the top of the scroll area
      if (currentOffset <= position.minScrollExtent) {
        onTop.value = true;
      }
      else onTop.value = false;
    });

    //super init
    super.initState();
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
                        borderRadius: BorderRadius.circular(25.0),
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
                            navSpread: widget.navSpread,
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
      ),
    );

    finalWidgetList.addAll(sliverList);

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

    //grab screen width so you can pass it through
    double screenWidth = MediaQuery.of(context).size.width;

    //return
    return Container(
      color: Theme.of(context).primaryColor,
      child: Stack(
        children: <Widget>[
          CustomScrollView(
            controller: widget.autoScrollController,
            slivers: finalWidgetList,
          ),
          SearchExcerciseButton(
            navSpread: widget.navSpread,
            screenWidth: screenWidth,
          ),
          ScrollToTopButton(
            onTop: onTop,
            autoScrollController: widget.autoScrollController,
          ),
          //Add New Excercise Button
          AddExcerciseButton(
            navSpread: widget.navSpread,
            screenWidth: screenWidth,
          ),
        ],
      ),
    );
  }
}