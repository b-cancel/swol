import 'package:flutter/material.dart';
import 'package:swol/action/doneButton/button.dart';
import 'package:swol/action/doneButton/corner.dart';
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
  //this function is update by done button button
  //im not sure why... 
  final ValueNotifier<Function> onTap = new ValueNotifier<Function>((){});
  
  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      //NOTE: this button spans all the space possible 
      //from bottom of the screen
      //to the top of the visual button
      child: GestureDetector(
        onTap: () => onTap.value(),
        child: Padding(
          padding: EdgeInsets.only(
            bottom: 24.0,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              DoneButtonCorner(
                animationCurve: widget.animationCurve,
                showOrHideDuration: widget.showOrHideDuration,
                excercise: widget.excercise,
                isTop: true,
              ),
              DoneButtonButton(
                onTap: onTap,
                excercise: widget.excercise,
                animationCurve: widget.animationCurve,
                showOrHideDuration: widget.showOrHideDuration,
              ),
              DoneButtonCorner(
                animationCurve: widget.animationCurve,
                showOrHideDuration: widget.showOrHideDuration,
                excercise: widget.excercise,
                isTop: false,
              ),
            ],
          ),
        ),
      ),
    );
  }
}