//dart
import 'dart:math' as math;

//flutter
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

//internal: tabs
import 'package:swol/excerciseAction/tabs/record/setRecord.dart';
import 'package:swol/excerciseAction/tabs/recovery/recovery.dart';
import 'package:swol/excerciseAction/tabs/sharedWidgets/doneButton.dart';
import 'package:swol/excerciseAction/tabs/suggest/suggest.dart';
import 'package:swol/excerciseAction/tabs/suggest/suggestion/setDisplay.dart';

/// A vertical tab widget for flutter
class VerticalTabs extends StatefulWidget {
  final int excerciseID;
  final double maxHeight;
  final Duration transitionDuration;
  final Duration delayTillShowDoneButton;
  final double statusBarHeight;

  VerticalTabs({
    @required this.excerciseID,
    @required this.maxHeight,
    @required this.transitionDuration,
    this.delayTillShowDoneButton: const Duration(milliseconds: 200),
    @required this.statusBarHeight,
  });

  @override
  _VerticalTabsState createState() => _VerticalTabsState();
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

class _VerticalTabsState extends State<VerticalTabs> with TickerProviderStateMixin {
  ValueNotifier<int> controlAnimatedGoalSet;
  ValueNotifier<int> calculatedWeight;
  ValueNotifier<int> calculatedReps;

  //for done button
  ValueNotifier<bool> showDoneButton;
  ValueNotifier<int> setsFinishedSoFar;

  //for the hero widget
  PageController pageViewController;

  //init
  @override
  void initState() {
    //TODO: properly read in the value
    //NOTE: we might need to go the init page first (Reuse the logic)
    setsFinishedSoFar = new ValueNotifier<int>(1);

    //TODO: select the first tab based on how far we are into the workout (HARD)
    //TODO: remove the random picker test code below
    var rng = new math.Random();
    int randomPage = (rng.nextInt(3)).clamp(0, 2);

    //the done button must be initialy show in order for the hero transition to work properly
    showDoneButton = new ValueNotifier<bool>(randomPage != 1); 
    controlAnimatedGoalSet = new ValueNotifier<int>(randomPage);
    controlAnimatedGoalSet.addListener(updateState);

    //travel to the page that has initial focus
    WidgetsBinding.instance.addPostFrameCallback((_){
      WidgetsBinding.instance.addPostFrameCallback((_){
        toPage(randomPage, instant: true);
      });
    });

    pageViewController = PageController(
      keepPage: true,
    );

    //handle goal set caluclation and display
    calculatedWeight = new ValueNotifier<int>(160);
    calculatedReps = new ValueNotifier<int>(15);

    //super init
    super.initState();
  }

  @override
  void dispose() { 
    controlAnimatedGoalSet.removeListener(updateState);
    pageViewController.dispose();
    super.dispose();
  }

  updateState(){
    if(mounted) setState(() {});
  }

  //build
  @override
  Widget build(BuildContext context) {
    bool useAccent = controlAnimatedGoalSet.value == 0;

    return Stack(
      children: <Widget>[
        DoneButton(
          excerciseID: widget.excerciseID,
          showDoneButton: showDoneButton,
          setsFinishedSoFar: setsFinishedSoFar,
          animationCurve: Curves.bounceInOut,
        ),
        //on top so covers hacks done by me in button above
        PageView(
          controller: pageViewController,
          //TODO: when we are done with debuging we can uncomment this
          //scrollPhysics: NeverScrollableScrollPhysics(),
          scrollDirection: Axis.vertical,
          children: <Widget>[
            Suggestion( 
              statusBarHeight: widget.statusBarHeight,
              excerciseID: widget.excerciseID,
              recordSet: (){
                toPage(1);
              },
            ),
            SetRecord(
              statusBarHeight: widget.statusBarHeight,
              excerciseID: widget.excerciseID,
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
              excerciseID: widget.excerciseID,
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
      ],
    );
  }

  //NOTE: this function will always run on init
  //this is so that we can go to a different page if need be
  //but also to initally show the done button if need be
  toPage(int pageID, {bool instant: false}){ //0 -> 2
    //update position of goal set
    controlAnimatedGoalSet.value = pageID;

    //move to the next page
    if(instant){
      //jump the right page
      if(pageID != 0){ //we actually have to jump
        pageViewController.jumpToPage(pageID);
      }
      //ELSE: we are already on that page (avoid potential errors)
    }
    else{
      //determine wether to show or hide the page 
      if(pageID != 1){
        if(pageID == 0){
          //TODO: before show it properly update the set finished to so far
          //how to do so is discussed above
          setsFinishedSoFar.value = 2;

          //TODO: going to the suggest page doesn't always show the button
          showDoneButton.value = true;
        }
        else{
          //TODO: before show it properly update the set finished to so far
          //how to do so is discussed above
          setsFinishedSoFar.value = 3;

          //going to recovery page will for sure show it
          showDoneButton.value = true;
        }
      } 
      else{
        //in the record set page that option goes away

        //primarily so the user can go back to the suggestion page
        //or go initially into the suggestion page
        //and get the button to animate into the screen
        //and call their attention

        //NOTE: that we don't need to update the sets finished so far
        //we only update that if we are showing the button
        showDoneButton.value = false; //will hide it
      }

      //animated to right page
      pageViewController.animateToPage(
        pageID, 
        duration: Duration(milliseconds: 300), 
        curve: Curves.easeInOut,
      );
    }
  }
}