import 'package:flutter/material.dart';
import 'package:swol/action/page.dart';
import 'package:swol/shared/structs/anExcercise.dart';
import 'package:swol/shared/widgets/simple/heros/curveMod.dart';
import 'package:vector_math/vector_math_64.dart' as vect;

class DoneButtonButton extends StatefulWidget {
  DoneButtonButton({
    @required this.onTap,
    @required this.excercise,
    @required this.animationCurve,
    @required this.showOrHideDuration,
  });

  final ValueNotifier<Function> onTap;
  final AnExcercise excercise;
  final Curve animationCurve;
  final Duration showOrHideDuration;

  @override
  _DoneButtonButtonState createState() => _DoneButtonButtonState();
}

class _DoneButtonButtonState extends State<DoneButtonButton> {
  updateState() {
    if (mounted) setState(() {});
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
    int tempSetCount = widget.excercise.tempSetCount.value ?? 0;
    if(tempSetCount != widget.excercise.setTarget.value){
      //TODO: bring the pop up that asks us if we want to update our set target
    }
    else{
      //the set target doesn't need to be updated
      widget.excercise.tempSetCount.value = AnExcercise.nullInt;
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
  Widget build(BuildContext context) {
    bool showTheButton = showButton();

    //handle radius change
    Radius goalRadius = Radius.circular(
      showTheButton ? 12 : 24,
    );

    //handle shift in an out of page
    Matrix4 newTransform = Matrix4.translation(
      vect.Vector3(
          showTheButton
              ? 0
              : -MediaQuery.of(context).size.width,
          0,
          0),
    );

    //handle page changes
    int tempSetCount = widget.excercise.tempSetCount.value ?? 0;
    int setsPassed;
    if(ExcercisePage.pageNumber.value != 2){
      //for page 0 and 1 
      //although page 1 shouldn't have the button
      DateTime tempStartTime = widget.excercise.tempStartTime.value;
      if(tempStartTime == AnExcercise.nullDateTime){
        setsPassed = tempSetCount;
        //we forgot to finish the set
        widget.onTap.value = (){
          completeSets();
        };
      }
      else{
        setsPassed = tempSetCount - 1;
        //we don't care about the set we started recording
        widget.onTap.value = (){
          completeSets(setTempsToNull: true);
        };
      }
    }
    else{
      setsPassed = tempSetCount;
      //normal scenario
      widget.onTap.value = (){
        completeSets(
          setTempsToNull: true,
          tempToLast: true,
        );
      };
    }

    //determine button color based on sets passed
    Color cardColor;
    if(setsPassed < widget.excercise.setTarget.value){
      cardColor = Theme.of(context).cardColor;
    }
    else cardColor = Theme.of(context).accentColor;

    //create decoration for both boxes
    BoxDecoration newBoxDecoration = BoxDecoration(
      color: cardColor,
      borderRadius: new BorderRadius.only(
        topRight: goalRadius,
        bottomRight: goalRadius,
      ),
    );

    //build
    return Stack(
      children: <Widget>[
        Positioned.fill(
          child: AnimatedContainer(
            duration: widget.showOrHideDuration,
            curve: widget.animationCurve,
            transform: newTransform,
            decoration: newBoxDecoration,
          ),
        ),
        Hero(
          tag: "excerciseComplete" + widget.excercise.id.toString(),
          createRectTween: (begin, end) {
            return CustomRectTween(a: begin, b: end);
          },
          child: FittedBox(
            fit: BoxFit.contain,
            child: Material(
              color: Colors.transparent,
              child: AnimatedContainer(
                curve: widget.animationCurve,
                duration: widget.showOrHideDuration,
                transform: newTransform,
                decoration: newBoxDecoration,
                padding: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Icon(Icons.arrow_left),
                    RichText(
                      text: TextSpan(
                        style: TextStyle(
                          color: Colors.white,
                        ),
                        children: [
                          TextSpan(
                            text: setsPassed.toString() + " Sets",
                            style: TextStyle(
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          TextSpan(
                            text: " Complete",
                            style: TextStyle(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}