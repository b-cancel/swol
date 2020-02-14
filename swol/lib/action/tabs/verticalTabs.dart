//dart
import 'dart:math' as math;

//flutter
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:swol/action/page.dart';

//internal: tabs
import 'package:swol/action/tabs/record/setRecord.dart';
import 'package:swol/action/tabs/recovery/recovery.dart';
import 'package:swol/action/tabs/sharedWidgets/doneButton.dart';
import 'package:swol/action/tabs/suggest/suggest.dart';
import 'package:swol/shared/structs/anExcercise.dart';

/// A vertical tab widget for flutter
class VerticalTabs extends StatefulWidget {
  final AnExcercise excercise;
  final double statusBarHeight;

  VerticalTabs({
    @required this.excercise,
    @required this.statusBarHeight,
  });

  @override
  _VerticalTabsState createState() => _VerticalTabsState();
}

class _VerticalTabsState extends State<VerticalTabs> with TickerProviderStateMixin {
  //for the hero widget
  PageController pageViewController;

  //for the "hero" widget (if not up then down)
  ValueNotifier<bool> goalSetUp;

  //init
  @override
  void initState() {
    //initally set the nnotifiers
    ExcercisePage.setWeight.value = widget?.excercise?.tempWeight ?? "";
    ExcercisePage.setReps.value = widget?.excercise?.tempReps ?? "";

    //TODO: select the first tab based on how far we are into the workout (HARD)
    //TODO: remove the random picker test code below
    var rng = new math.Random();
    ExcercisePage.pageNumber.value = 0; //(rng.nextInt(3)).clamp(0, 2);

    //set notifier based on random page
    goalSetUp = new ValueNotifier<bool>(ExcercisePage.pageNumber.value == 0);

    //travel to the page that has initial 
    /*
    WidgetsBinding.instance.addPostFrameCallback((_){
      WidgetsBinding.instance.addPostFrameCallback((_){
        toPage(randomPage, instant: true);
      });
    });
    */

    pageViewController = PageController(
      keepPage: false, //we need to use the on init of various pages
      initialPage: ExcercisePage.pageNumber.value,
    );

    //super init
    super.initState();
  }

  @override
  void dispose() { 
    pageViewController.dispose();
    super.dispose();
  }

  updateState(){
    if(mounted) setState(() {});
  }

  Duration transitionDuration = Duration(milliseconds: 300);

  //build
  @override
  Widget build(BuildContext context) {
    //both values grabbed raw
    double bottomPadding = 24.0 + 24.0 + 40.0 + 24;
    double topPadding = 16;

    //travel bottomPadding + bottomPadding + toPadding in 300 ms
    //10 feet in 5 seconds, 2 feets per second
    //how long to travel 3 feet? 3/2 = 1.5 seconds
    double totalTravel = (bottomPadding * 2) + topPadding;

    //all the stuffs
    return Stack(
      children: <Widget>[
        PageView(
          controller: pageViewController,
          physics: NeverScrollableScrollPhysics(),
          scrollDirection: Axis.vertical,
          children: <Widget>[
            Suggestion( 
              excercise: widget.excercise,
              statusBarHeight: widget.statusBarHeight,
              recordSet: () => toPage(1),
              heroUp: goalSetUp,
              heroAnimDuration: transitionDuration,
              heroAnimTravel: totalTravel,
            ),
            SetRecord(
              excercise: widget.excercise,
              statusBarHeight: widget.statusBarHeight,
              heroUp: goalSetUp,
              heroAnimDuration: transitionDuration,
              heroAnimTravel: totalTravel,
              //TODO: going back should not reset what they already typed
              //note: try to stop them from typing dumb stuff but if they do then restore the dumb stuff
              //TODO: do so when the user holds the button AND when they click it
              backToSuggestion: () => toPage(0),
              //TODO: dont allow the user to move onto the set break until they have valid set
              //1. numbers only (obvi)
              //2. whole numbers (kinda obvi)
              //3. for the weight less thatb 4 digits (nobody can nothing 9,999 pounds)
              //4. for the reps less than 3 digits (nobody can nothing 999 times)
              //5. weight CAN BE 0, but suggest that if its body weight excercise they record that
              //6. reps can't be 0
              //TODO: if they try to move onto the set break explain the above
              //- can use a pop up
              //- can use a snackbar
              //- can use a attached toast
              //- can just trigger the error or something like it on the field
              //- ideally just make it impossible for the user to do something dumb
              setBreak: (){
                toPage(2);
              },
            ),
            Recovery(
              excercise: widget.excercise,
              //NOTE: although at some point I thought the back button should trigger this too
              //that's silly the back button is a "short cut" since its only on android
              //and shortcuts should be for actions that happen often
              //and the user will only go back to fix their set if they mistaped
              //which ofcourse is rare in comparison to perhaps going to their next workout
              //and reviewing form or doing a super set or whatever else
              //TODO: tell the user timer will not reset no matter what
              //TODO: do so when the user holds the button AND when they click it
              backToRecordSet: () => toPage(1),
              //TODO: there are like a million and 1 things that have to happen here (HARD)
              nextSet: () => toPage(0),
            ),
          ],
        ),
        //must be on top... other wise it isnt clickable
        DoneButton(
          excercise: widget.excercise,
          showOrHideDuration: transitionDuration,
          animationCurve: Curves.easeInOut,
        ),
      ],
    );
  }

  //TODO: what happens if you jump or animate to the page you are already on
  //NOTE: this function will always run on init
  //this is so that we can go to a different page if need be
  //but also to initally show the done button if need be
  toPage(int pageID, {bool instant: false}){ //0 -> 
    //close the keybaord if needed
    FocusScope.of(context).unfocus();

    //save the page we are on
    ExcercisePage.pageNumber.value = pageID;

    //deterime the reaction
    if(instant){
      pageViewController.jumpToPage(pageID);
    }
    else{
      //animated to right page
      pageViewController.animateToPage(
        pageID, 
        duration: transitionDuration, 
        curve: Curves.easeInOut,
      );

      //handle the cross page "hero"
      //after waiting "a couple of frames" for the other page to start showing up
      WidgetsBinding.instance.addPostFrameCallback((_){
        WidgetsBinding.instance.addPostFrameCallback((_){
          WidgetsBinding.instance.addPostFrameCallback((_){
            goalSetUp.value = (ExcercisePage.pageNumber.value == 0);
          });
        });
      });
    }
  }
}