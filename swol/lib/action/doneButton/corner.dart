

import 'package:flutter/material.dart';
import 'package:swol/action/page.dart';
import 'package:swol/shared/structs/anExcercise.dart';

class DoneButtonCorner extends StatefulWidget {
  DoneButtonCorner({
    @required this.animationCurve,
    @required this.showOrHideDuration,
    @required this.excercise,
    @required this.isTop,
  });

  final Curve animationCurve;
  final Duration showOrHideDuration;
  final AnExcercise excercise;
  final bool isTop;

  @override
  _DoneButtonCornerState createState() => _DoneButtonCornerState();
}

class _DoneButtonCornerState extends State<DoneButtonCorner> {
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

  bool showButton(){
    bool pageWithButton = ExcercisePage.pageNumber.value != 1;
    print("should show button: " + pageWithButton.toString());
    //TODO: remove this
    bool nullTSC = false; //widget.excercise.tempSetCount.value == AnExcercise.nullInt;
    return (pageWithButton && nullTSC == false);
  }

  @override
  Widget build(BuildContext context) {
    double size = showButton() ? 24 : 0;

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

    //animates corners
    return Container(
      height: 24,
      width: 24,
      alignment: widget.isTop ? Alignment.bottomLeft : Alignment.topLeft,
      child: AnimatedContainer(
        curve: widget.animationCurve,
        duration: (widget.showOrHideDuration * (0.5)),
        height: size,
        width: size,
        child: FittedBox(
          fit: BoxFit.contain,
          child: ClipPath(
            clipper: CornerClipper(
              top: widget.isTop,
            ),
            child: Container(
              height: 1,
              width: 1,
              decoration: new BoxDecoration(
                color: cardColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

//modification of inverted circle clipper taken from somewhere on the internet
class CornerClipper extends CustomClipper<Path> {
  CornerClipper({
    @required this.top,
  });

  final bool top;
  
  @override
  Path getClip(Size size) {
    return new Path()
      ..addOval(new Rect.fromCircle(
          center: new Offset(size.width, (top ? 0 : size.height)),
          radius: size.width * 1))
      ..addRect(new Rect.fromLTWH(0.0, 0.0, size.width, size.height))
      ..fillType = PathFillType.evenOdd;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}