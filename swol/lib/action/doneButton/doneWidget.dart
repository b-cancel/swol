import 'package:flutter/material.dart';
import 'package:swol/action/doneButton/button.dart';
import 'package:swol/action/doneButton/corner.dart';
import 'package:swol/action/page.dart';
import 'package:swol/shared/structs/anExcercise.dart';

//TODO: change the theme of the button depending on stuffs
//1. if BEFORE set target keep background dark
//2. if AFTER set target keep background light

//TODO: from suggest page -> simply close everything off
//TODO: including all temp variables

//TODO: from break page -> must do everything that clicking next set would
//TODO: essentially make all the pop ups that would pop up... do so...
class DoneButton extends StatefulWidget {
  DoneButton({
    @required this.excercise,
    this.showOrHideDuration: const Duration(milliseconds: 300),
    @required this.animationCurve,
  });

  final AnExcercise excercise;
  final Curve animationCurve;
  final Duration showOrHideDuration;

  @override
  _DoneButtonState createState() => _DoneButtonState();
}

class _DoneButtonState extends State<DoneButton> {

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
    int tempSetCount = widget.excercise.tempSetCount.value ?? 0;
    int setsPassed;
    if(ExcercisePage.pageNumber.value != 2){
      //for page 0 and 1 
      //although page 1 shouldn't have the button
      DateTime tempStartTime = widget.excercise.tempStartTime.value;
      if(tempStartTime == AnExcercise.nullDateTime){
        setsPassed = tempSetCount;
      }
      else setsPassed = tempSetCount - 1;
    }
    else setsPassed = tempSetCount;

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
      child: GestureDetector(
        onTap: (){
          print("hello world");
        },
        child: Padding(
          padding: EdgeInsets.only(
            bottom: 24.0,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              DoneButtonCorner(
                show: showButton(),
                color: cardColor,
                animationCurve: widget.animationCurve,
                showOrHideDuration: widget.showOrHideDuration,
                isTop: true,
              ),
              DoneButtonButton(
                onTap: new ValueNotifier<Function>((){}),
                excercise: widget.excercise,
                animationCurve: widget.animationCurve,
                showOrHideDuration: widget.showOrHideDuration,
              ),
              DoneButtonCorner(
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

  bool showButton(){
    bool pageWithButton = ExcercisePage.pageNumber.value != 1;
    print("should show button: " + pageWithButton.toString());
    //TODO: remove this
    bool nullTSC = false; //widget.excercise.tempSetCount.value == AnExcercise.nullInt;
    return (pageWithButton && nullTSC == false);
  }
}