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
    this.showOrHideDuration: const Duration(milliseconds: 300),
    @required this.animationCurve,
  });

  final AnExcercise excercise;
  final Curve animationCurve;
  final Duration showOrHideDuration;

  @override
  _FloatingDoneButtonState createState() => _FloatingDoneButtonState();
}

class _FloatingDoneButtonState extends State<FloatingDoneButton> {
  ValueNotifier<bool> showButton;
  bool showCorners;
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

  //runs after a change in pageNumber is detected
  updateButton(){
    showButton.value = shouldShow();
    if(showButton.value) fullyHidden = false;
    setState(() {});
  }

  //runs after a change in showButton is detected
  //TODO: handle edge case of doing false before true finishes
  //NOTE: I'll handle the above if it becomes a problem
  updateCorners(){
    if(showButton.value){ //delay then show
      Future.delayed(widget.showOrHideDuration * 0.5, (){
        showCorners = true;
        setState(() {});
      });
    }
    else{ //immediately hide with button
      showCorners = false;
      setState(() {});
      Future.delayed(widget.showOrHideDuration, (){
        fullyHidden = true;
        setState(() {});
      });
    }
  }

  @override
  void initState() {
    //super init
    super.initState();
    
    //create notifiers (with non defaults)
    bool shouldBeShowing = shouldShow();
    showButton = new ValueNotifier<bool>(shouldBeShowing);
    showCorners = shouldBeShowing;
    fullyHidden = shouldBeShowing == false;

    //whenever button updates corners get updated
    showButton.addListener(updateCorners);
    //whenever page updates button get updated
    ExcercisePage.pageNumber.addListener(updateButton);
  }

  @override
  void dispose() {
    //remove listener from page to button
    ExcercisePage.pageNumber.removeListener(updateButton);
    //remove listener from button to corners
    showButton.removeListener(updateCorners);

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
    if(completionType == Complete.DeleteNewSet){
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
      child: Container(
        color: Colors.green,
        child: Visibility(
          visible: fullyHidden ? false : true,
          child: Tooltip(
            message: showButton.value == false ? "hiding" : message,
            child: GestureDetector(
              behavior: showButton.value == false ? HitTestBehavior.translucent : HitTestBehavior.opaque,
              onTap: showButton.value == false ? null : (){
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
                      show: showCorners,
                      color: cardColor,
                      animationCurve: widget.animationCurve,
                      showOrHideDuration: widget.showOrHideDuration,
                      isTop: true,
                    ),
                    DoneButton(
                      show: showButton.value,
                      color: cardColor,
                      setsPassed: setsPassedFromHere,
                      excerciseID: widget.excercise.id,
                      animationCurve: widget.animationCurve,
                      showOrHideDuration: widget.showOrHideDuration,
                    ),
                    DoneCorner(
                      show: showCorners,
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
    widget.excercise.lastTimeStamp = ValueNotifier<DateTime>(newTimeStamp);

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