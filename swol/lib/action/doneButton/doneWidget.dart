import 'package:flutter/material.dart';
import 'package:swol/action/doneButton/button.dart';
import 'package:swol/action/doneButton/corner.dart';
import 'package:swol/action/page.dart';
import 'package:swol/shared/structs/anExcercise.dart';

//NOTE: we have a couple of timestamp types
//inprogress (on top), new, normal, hidden

//we are trying to cover X edge case

//case 1 of edge case
//if we are doing the calibration set for an excercise, it will be categorized as "NEW"
//if we don't complete this set and move onto our 2nd set (with suggestions) -> good
//else we dont complete this first set and SHOULD RETURN TO "NEW"

//case 2 of edge case
//same as above but replace "NEW" for "ARCHIVED"

//case 3 of edge case
//same as above but for any in progress

//in all cases we don't want to officially update the timestamp type UNTIL we finish our first set
//so we can revert back to our location if needed
//so we need to keep track of an extra variable in the excercise
//ONLY when recording the first set do we want to set it so we can use it
//and ONLY when deleting the first set do we want to reinstate it vs simply using the default DateTime.now()

enum Complete {ForgotToFinish, DeleteNewSet, Normal}

class FloatingDoneButton extends StatefulWidget {
  FloatingDoneButton({
    @required this.excercise,
    @required this.showOrHideDuration,
    @required this.animationCurve,
  });

  final AnExcercise excercise;
  final Curve animationCurve;
  final Duration showOrHideDuration;

  @override
  _FloatingDoneButtonState createState() => _FloatingDoneButtonState();
}

class _FloatingDoneButtonState extends State<FloatingDoneButton> {
  bool showButton; //show and hides entire button
  bool fullyHidden; //required so gestures wouldn't be registered by the hidden box

  //whether or not this particular page wants the button to show
  bool shouldShow(){
    bool pageWithButton = ExcercisePage.pageNumber.value != 1;
    bool nullTSC = widget.excercise.tempSetCount.value == AnExcercise.nullInt;

    //NOTE: because our tempSetCount is increase when we start the timer
    //if we start the timer
    //then are like naw and go back to suggest
    //we will be completing set 0
    //for that reason when our setsPassed are equal to 0
    //we show "Delete The Set" instead

    if(pageWithButton) return nullTSC == false;
    else{ //the page that usually doesn't have a done button
      //does have the done button but only for the calibration set
      //and only if all other conditions are met
      bool inCalibrationSet = widget.excercise.lastWeight == null;
      return inCalibrationSet && (nullTSC == false);
    }
  }

  updateButtonVisually(bool shouldStillShow){
    if(shouldStillShow){ //should animate in
          //start animation position to hidden
          showButton = false;
          //fully unhide so animation can play
          fullyHidden = false;
          //reflect both of these changes
          setState(() {});
          
          //wait a frame for fully hidden to regsiter
          //so animation can then play
          WidgetsBinding.instance.addPostFrameCallback((_){
            showButton = true;
            setState(() {});
          });
        }
        else{ //should animate out
          //start the animation that hides
          showButton = false;
          setState(() {});

          //wait for the animation to complete
          Future.delayed(widget.showOrHideDuration, (){
            //fully hide
            fullyHidden = true;
            setState(() {});
          });
        }
  }

  //runs after a change in pageNumber is detected
  updateButton(){
    //NOTE: we wait for the transition to complete...
    //primarily because the if we reset the timer immediately
    //then while the transition is occuring you will have a scary flash or red
    //so we start the transition, wait a bit, then make the change
    //which means we have to wait for the change ATLEAST
    //in order to properly update the done button with the pageNumber
    bool shouldShowAfterDelay = shouldShow();
    if(ExcercisePage.pageNumber.value == 0){
      Future.delayed(widget.showOrHideDuration, (){
        bool shouldStillShow = shouldShow();
        if(shouldShowAfterDelay == shouldStillShow){
          updateButtonVisually(shouldShowAfterDelay);
        }
        //ELSE this function has been called for the opposite thing
      });
    }
    else updateButtonVisually(shouldShowAfterDelay);
  }

  @override
  void initState() {
    //super init
    super.initState();
    
    //how the button reacts on init
    bool shouldBeShowing = shouldShow();
    //init should be immidiate since
    //if hidden we want it to be immediately hidden
    //if shown then we want the hero
    showButton = shouldBeShowing;
    fullyHidden = shouldBeShowing == false;

    //whenever page updates button get updated
    ExcercisePage.pageNumber.addListener(updateButton);
  }

  @override
  void dispose() {
    //remove listener from page to button
    ExcercisePage.pageNumber.removeListener(updateButton);

    //super dispose
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    String message = "";

    //handle page changes
    int setsPassedFromHere = widget.excercise.tempSetCount.value;
    Complete completionType;
    if(ExcercisePage.pageNumber.value != 2){
      //for page 0 and 1 
      //although page 1 shouldn't have the button
      DateTime tempStartTime = widget.excercise.tempStartTime.value;
      if(tempStartTime == AnExcercise.nullDateTime){
        completionType = Complete.ForgotToFinish;
      }
      else{
        setsPassedFromHere -= 1;
        completionType = Complete.DeleteNewSet;
        
      }
    }
    else completionType = Complete.Normal;

    int setTarget = widget.excercise.setTarget.value;
    int setsLeft = setTarget - setsPassedFromHere;

    //do we have values left?
    if(setsLeft > 0){
      message += "You have " + setsLeft.toString() 
      + " SET" + (setsLeft == 1 ? "" : "S")
      + " LEFT before you reach your set target(" + setTarget.toString() +  "), but you can ";
    }

    //are we trying to delete something?
    if(completionType == Complete.DeleteNewSet){
      message += "DELETE SET " + (setsPassedFromHere + 1).toString() + ", and ";
    }

    //what this does by default
    message += "Finish Here after having COMPLETED " + setsPassedFromHere.toString() 
    + " set" + (setsPassedFromHere == 1 ? "" : "s");

    //do we have extra values?
    if(setsLeft < 0){
      message += ", " +  (setsLeft * -1).toString() + " more than your set target(" + setTarget.toString() + ")";
    }
    
    //add spacing
    message = "\n" + message + "\n";
    
    //determine button color based on sets passed
    Color cardColor = Theme.of(context).cardColor;
    //NOTE: we also check if showButton is false because 
    //we don't want to scare the user with RED while the button is closing
    if(completionType == Complete.DeleteNewSet && showButton){
      cardColor = Colors.red;
    }
    else{
      bool shouldCompleteHere = (setsPassedFromHere >= widget.excercise.setTarget.value);
      if(shouldCompleteHere) cardColor = Theme.of(context).accentColor;
    }

    //position
    return Positioned(
      bottom: 0,
      left: 0,
      //NOTE: this button spans all the space possible 
      //from bottom of the screen
      //to the top of the visual button
      child: Visibility(
        visible: fullyHidden ? false : true,
        child: Tooltip(
          message: showButton == false ? "hiding" : message,
          child: GestureDetector(
            behavior: showButton == false ? HitTestBehavior.translucent : HitTestBehavior.opaque,
            onTap: showButton == false ? null : (){
              completeSets(
                setsPassedFromHere,
                //only if we forgot to finish are temps ALREADY null
                setTempsToNull: completionType != Complete.ForgotToFinish,
                //only if we are completing under normal circumstances
                //do we also have to copy the temp variables and save them to last
                tempToLast: completionType == Complete.Normal,
              );
            },
            child: Padding(
              padding: EdgeInsets.only(
                bottom: 24.0,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  DoneCorner(
                    show: showButton,
                    color: cardColor,
                    animationCurve: widget.animationCurve,
                    showOrHideDuration: widget.showOrHideDuration,
                    isTop: true,
                  ),
                  DoneButton(
                    show: showButton,
                    color: cardColor,
                    setsPassed: setsPassedFromHere,
                    excerciseID: widget.excercise.id,
                    animationCurve: widget.animationCurve,
                    showOrHideDuration: widget.showOrHideDuration,
                  ),
                  DoneCorner(
                    show: showButton,
                    color: cardColor,
                    animationCurve: widget.animationCurve,
                    showOrHideDuration: widget.showOrHideDuration,
                    isTop: false,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  completeSets(int setsPassed, {
    bool setTempsToNull: false,
    bool tempToLast: false,
  }){
    //time stamp
    DateTime newTimeStamp = DateTime.now();
    if(setsPassed == 0){ //we didn't care to even save this set
      newTimeStamp = widget.excercise.backUpTimeStamp;
    }
    widget.excercise.lastTimeStamp = new ValueNotifier<DateTime>(newTimeStamp);

    //temp start time
    if(setTempsToNull){
      widget.excercise.tempStartTime = new ValueNotifier<DateTime>(AnExcercise.nullDateTime); 
    }

    //weight
    if(tempToLast){ //we KNOW tempWeight is VALID
      widget.excercise.lastWeight = widget.excercise.tempWeight;
    }
    if(setTempsToNull){
      widget.excercise.tempWeight = null;
    }

    //reps
    if(tempToLast){ //we KNOW tempReps is VALID
      widget.excercise.lastReps = widget.excercise.tempReps;
    }
    if(setTempsToNull){
      widget.excercise.tempReps = null;
    }

    //set target
    //NOTE: if we start record a set, are like naw, and don't want to record it
    //we aren't going to show the pop up 
    //and half suggest that they update their setTarget to 0
    if(setsPassed != 0 && setsPassed != widget.excercise.setTarget.value){
      //TODO: bring the pop up that asks us if we want to update our set target
      //TODO: the pop up should also pop this page

      //TODO: remove test code
      widget.excercise.tempSetCount = ValueNotifier<int>(AnExcercise.nullInt);
      Navigator.of(context).pop();
    }
    else{
      //the set target doesn't need to be updated
      //but the tempSetCount MUST be nullified
      widget.excercise.tempSetCount = ValueNotifier<int>(AnExcercise.nullInt);
      Navigator.of(context).pop();
    }
  }
}