import 'package:flutter/material.dart';
import 'package:swol/action/doneButton/button.dart';
import 'package:swol/action/doneButton/corner.dart';
import 'package:swol/action/page.dart';
import 'package:swol/shared/structs/anExcercise.dart';

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

  //whether or not this particular page wants the button to show
  bool shouldShow(){
    bool pageWithButton = ExcercisePage.pageNumber.value != 1;

    //NOTE: because our tempSetCount is increase when we start the timer
    //if we start the timer
    //then are like naw and go back to suggest
    //we will be completing set 0
    //for that reason when our setsPassed are equal to 0
    //we show "Delete The Set" instead

    bool nullTSC = widget.excercise.tempSetCount.value == AnExcercise.nullInt;
    return (pageWithButton && nullTSC == false);
  }

  //runs after a change in pageNumber is detected
  updateButton(){
    showButton.value = shouldShow();
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
    );
  }

  completeSets(int setsPassed, {
    bool setTempsToNull: false,
    bool tempToLast: false,
  }){
    //time stamp
    widget.excercise.lastTimeStamp = ValueNotifier<DateTime>(DateTime.now());

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