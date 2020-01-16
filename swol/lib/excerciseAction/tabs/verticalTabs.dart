//MODIFICATION OF PLUGIN FOUND HERE
//https://pub.dev/packages/vertical_tabs#-readme-tab-

//dart
import 'dart:math' as math;

//flutter
import 'package:flutter/material.dart';

//internal: tabs
import 'package:swol/excerciseAction/tabs/record/setRecord.dart';
import 'package:swol/excerciseAction/tabs/recovery/recovery.dart';
import 'package:swol/excerciseAction/tabs/suggest/suggest.dart';

//plugin
import 'package:carousel_slider/carousel_slider.dart';

/// A vertical tab widget for flutter
class VerticalTabs extends StatefulWidget {
  final int excerciseID;
  final double maxHeight;

  VerticalTabs({
    @required this.excerciseID,
    @required this.maxHeight,
  });

  @override
  _VerticalTabsState createState() => _VerticalTabsState();
}

class _VerticalTabsState extends State<VerticalTabs> with TickerProviderStateMixin {
  //so that we can call the functions on the carousel
  var carousel;

  //used to so that we can show or hide the done button
  ValueNotifier<int> selectedTab;

  allSetsComplete(){
    print("fill all sets complete function");
  }

  toPage(int pageID, {bool instant: false}){ //0->2
    if(instant) carousel.jumpToPage(pageID);
    else{
      carousel.animateToPage(
        pageID, 
        duration: Duration(milliseconds: 250), 
        curve: Curves.easeInOut,
      );
    }
  }

  //init
  @override
  void initState() {
    selectedTab = new ValueNotifier<int>(0);

    //carousel
    carousel = CarouselSlider(
      //NOTE: DO NOT SET INITIAL PAGE: this breaks
      //we are instead jumping to our desired page on start up
      viewportFraction: 1.0,
      //TODO: when we are done with debuging we can uncomment this
      //scrollPhysics: NeverScrollableScrollPhysics(),
      scrollDirection: Axis.vertical,
      height: widget.maxHeight,
      items: [
        Suggestion(
          excerciseID: widget.excerciseID,
          allSetsComplete: allSetsComplete,
          recordSet: () => toPage(1),
        ),
        SetRecord(
          excerciseID: widget.excerciseID,
          backToSuggestion: () => toPage(0),
          setBreak: () => toPage(2),
        ),
        Recovery( 
          excerciseID: widget.excerciseID,
          allSetsComplete: allSetsComplete,
          //TODO: hold the back button should also do the same as below
          //TODO: toast that the timer will not reset no matter what
          backToRecordSet: () => toPage(1),
          nextSet: () => toPage(0),
        ),
      ],
    );

    //TODO: select the first tab based on how far we are into the workout
    //for now this functionality is test our randomly
    var rng = new math.Random();
    selectedTab.value = (rng.nextInt(3)).clamp(0, 2);

    WidgetsBinding.instance.addPostFrameCallback((_){
      toPage(selectedTab.value, instant: true);
    });

    //super init
    super.initState();
  }

  //build
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        carousel,
        //TODO: add the done button
        /*
        DoneButton(
                            allSetsComplete: allSetsComplete,
                            useRaisedButton: flipped,
                          ),
        */
      ],
    );
  }
}

//TODO: when at suggest page we only show IF
//1. we have atleast 1 set FINISHED so far
//2. BUT what to do if we already recorded our set and started the timer?
//TODO: handle important edge case above

//NOTE: if you have already recorded your set and started the timer
//I BELEIVE
//seeing the done button in the suggest page should show finished set X
//and seeing the done button in the timer page should show finished set X + 1
//ofcourse clicking them also has very different actions

//from the "recovery page" you consider the set you just recorded
//on purpose or accidently 
//(although it should be hard to be an accident cuz you need to type before going to next)

//from the "suggest page" you dont consider the set you just recorded
//I beleive that because of the way things are setup 
//I shouldn't have to worry about reseting the temp variable but 
//TODO: confirm the immediately above



//TODO: handle animation
//button animates in and out as we scroll through the pages
//and it animates in initially so that what ever page you start up on
//you know that its there (cuz its kind of easy to forget)
class DoneButton extends StatefulWidget {
  DoneButton({
    @required this.showButton,
    @required this.setsFinishedSoFar,
  });

  final ValueNotifier<bool> showButton;
  final ValueNotifier<int> setsFinishedSoFar;

  @override
  _DoneButtonState createState() => _DoneButtonState();
}

class _DoneButtonState extends State<DoneButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      
    );
  }
}