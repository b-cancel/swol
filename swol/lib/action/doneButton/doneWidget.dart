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
  //TODO: the button parts animates immeditely
  //TODO: the corners animate in faster after a delay
  //TODO: the corner animate out faster 
  //TODO: make sure the handle consequences of start then ending
  //TODO: because no we have 2 seperate shows, one for button, one for corners
  updateState() {
    //we want to show but wait till the main button shows
    if(showButton()) { //play the show animation after a delay
      //so that the corners dont animation faster than the button
      Future.delayed(widget.showOrHideDuration * (0.5),(){
        if(mounted) setState(() {});
      });
    }
    else{ //play the hide animation immediately
      if(mounted) setState(() {});
    }
  }

  bool showButton(){
    bool pageWithButton = ExcercisePage.pageNumber.value != 1;
    print("should show button: " + pageWithButton.toString());
    //TODO: remove this
    bool nullTSC = false; //widget.excercise.tempSetCount.value == AnExcercise.nullInt;
    return (pageWithButton && nullTSC == false);
  }

  @override
  void initState() {
    super.initState();
    ExcercisePage.pageNumber.addListener(updateState);
  }

  @override
  void dispose() {
    ExcercisePage.pageNumber.removeListener(updateState);
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
  
    //handle page changes
    int setsPassed = widget.excercise.tempSetCount.value ?? 0;
    Complete completionType;
    if(ExcercisePage.pageNumber.value != 2){
      //for page 0 and 1 
      //although page 1 shouldn't have the button
      DateTime tempStartTime = widget.excercise.tempStartTime.value;
      if(tempStartTime == AnExcercise.nullDateTime){
        completionType = Complete.ForgotToFinish;
      }
      else{
        setsPassed -= 1;
        completionType = Complete.DeleteNewSet;
      }
    }
    else completionType = Complete.Normal;
    
    //determine button color based on sets passed
    Color cardColor;
    if(setsPassed < widget.excercise.setTarget.value){
      cardColor = Theme.of(context).cardColor;
    }
    else cardColor = Theme.of(context).accentColor;

    //position
    return Positioned(
      bottom: 0,
      left: 0,
      //NOTE: this button spans all the space possible 
      //from bottom of the screen
      //to the top of the visual button
      //TODO: when the button is hidden, tapping in this area shouldn't do anything
      child: GestureDetector(
        onTap: (){
          completeSets(
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
                show: showButton(),
                color: cardColor,
                animationCurve: widget.animationCurve,
                showOrHideDuration: widget.showOrHideDuration,
                isTop: true,
              ),
              DoneButton(
                show: showButton(),
                color: cardColor,
                setsPassed: setsPassed,
                excerciseID: widget.excercise.id,
                animationCurve: widget.animationCurve,
                showOrHideDuration: widget.showOrHideDuration,
              ),
              DoneCorner(
                show: showButton(),
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

  completeSets({
    bool setTempsToNull: false,
    bool tempToLast: false,
  }){
    //time stamp
    widget.excercise.lastTimeStamp.value = DateTime.now();

    //temp start time
    if(setTempsToNull){
      widget.excercise.tempStartTime.value = AnExcercise.nullDateTime; 
    }

    //weight
    if(tempToLast){
      widget.excercise.lastWeight = widget.excercise.tempWeight;
    }
    if(setTempsToNull){
      widget.excercise.tempWeight = null;
    }

    //reps
    if(tempToLast){
      widget.excercise.lastReps = widget.excercise.tempReps;
    }
    if(setTempsToNull){
      widget.excercise.tempReps = null;
    }

    //set target
    //TODO: might have to modify the temp set count here 
    //TODO: for the scenario where we don't care to keep our current set
    int tempSetCount = widget.excercise.tempSetCount.value ?? 0;
    if(tempSetCount != widget.excercise.setTarget.value){
      //TODO: bring the pop up that asks us if we want to update our set target
      //TODO: the pop up should also pop this page
    }
    else{
      //the set target doesn't need to be updated
      widget.excercise.tempSetCount.value = AnExcercise.nullInt;
      Navigator.of(context).pop();
    }
  }
}