//dart
import 'dart:math' as math;

//flutter
import 'package:flutter/material.dart';

//internal: tabs
import 'package:swol/excerciseAction/tabs/record/setRecord.dart';
import 'package:swol/excerciseAction/tabs/recovery/recovery.dart';
import 'package:swol/excerciseAction/tabs/suggest/suggest.dart';

//internal other
import 'package:swol/excerciseAction/doneButton.dart';

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
  //so that we can call the functions on the carousel
  var carousel;

  //for done button
  ValueNotifier<bool> showDoneButton;
  ValueNotifier<int> setsFinishedSoFar;

  //NOTE: this function will always run on init
  //this is so that we can go to a different page if need be
  //but also to initally show the done button if need be
  toPage(int pageID, {bool instant: false}){ //0 -> 2
    if(instant){
      //NOTE: this relies on the CURRENT FACT
      //that although we are leaving the possiblity to jump to any page
      //the done button starts off as hidden
      //and WE ONLY WANT it to animate in for the FIRST and LAST page
      //TODO: cover edge case that occurs if we call delayed
      //and before delayed ends we change page and shouldn't have it open
      //or possible should but should really wait for the future.delayed
      //that switching to that page would have triggered
      bool buttonShouldShow = true;
      if(pageID == 2){  
        //TODO: decide to not show the button if the necessary conditions are not met
        //NOTE: this might not even be possible but that's a problem for later
      }

      if(buttonShouldShow){
        Future.delayed(
          //NOTE: should be equal to ONLY 
          //how long transitioning into this page takes
          //doesn't need to be equal to how long it takes to change pages
          //since once you are on the vertical tabs the animation will show
          //and therefor we don't have to wait for the transition to show it
          Duration(milliseconds: 300),
          () => showDoneButton.value = true,
        );
      }

      //jump the right page
      if(pageID != 0){ //we actually have to jump
        carousel.jumpToPage(pageID);
      }
      //ELSE: we are already on that page (avoid potential errors)
    }
    else{
      //determine wether to show or hide the page
      if(pageID == 0 || pageID == 2){
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
      carousel.animateToPage(
        pageID, 
        duration: Duration(milliseconds: 300), 
        curve: Curves.easeInOut,
      );
    }
  }

  //init
  @override
  void initState() {
    //NOTE: starts as false because we always want the button to animate in
    showDoneButton = new ValueNotifier<bool>(false);

    //TODO: properly read in the value
    //NOTE: we might need to go the init page first (Reuse the logic)
    setsFinishedSoFar = new ValueNotifier<int>(1);

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
          recordSet: () => toPage(1),
        ),
        SetRecord(
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
          setBreak: () => toPage(2),
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
    );

    //TODO: select the first tab based on how far we are into the workout (HARD)
    //TODO: remove the random picker test code below
    var rng = new math.Random();

    //travel to the page that has initial focus
    WidgetsBinding.instance.addPostFrameCallback((_){
      toPage((rng.nextInt(3)).clamp(0, 2), instant: true);
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
        Positioned(
          bottom: 0,
          left: 0,
          child: DoneButton(
            showDoneButton: showDoneButton,
            setsFinishedSoFar: setsFinishedSoFar,
          ),
        ),
      ],
    );
  }
}