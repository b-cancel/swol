import 'package:flutter/material.dart';
import 'package:swol/shared/structs/anExcercise.dart';
import 'package:swol/shared/widgets/simple/heros/curveMod.dart';
import 'package:vector_math/vector_math_64.dart' as vect;

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
    this.showOrHideDuration: const Duration(milliseconds: 1500),
    @required this.animationCurve,
    @required this.pageNumber,
  });

  final AnExcercise excercise;
  final Curve animationCurve;
  final Duration showOrHideDuration;
  final ValueNotifier<int> pageNumber;

  @override
  _DoneButtonState createState() => _DoneButtonState();
}

class _DoneButtonState extends State<DoneButton> {
  final ValueNotifier<Function> onTap = new ValueNotifier<Function>((){});
  
  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      child: Padding(
        padding: EdgeInsets.only(
          //TODO: update to be the actual height of the bottom buttons
          //24 for card peek, 24 extra for black boxes
          bottom: 24.0,
        ),
        child: GestureDetector(
          onTap: () => onTap.value(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              DoneButtonCorner(
                animationCurve: widget.animationCurve,
                showOrHideDuration: widget.showOrHideDuration,
                pageNumber: widget.pageNumber,
                excercise: widget.excercise,
                isTop: true,
              ),
              DoneButtonButton(
                onTap: onTap,
                excercise: widget.excercise,
                animationCurve: widget.animationCurve,
                showOrHideDuration: widget.showOrHideDuration,
                pageNumber: widget.pageNumber,
              ),
              DoneButtonCorner(
                animationCurve: widget.animationCurve,
                showOrHideDuration: widget.showOrHideDuration,
                pageNumber: widget.pageNumber,
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

class DoneButtonButton extends StatefulWidget {
  DoneButtonButton({
    @required this.onTap,
    @required this.excercise,
    @required this.animationCurve,
    @required this.showOrHideDuration,
    @required this.pageNumber,
  });

  final ValueNotifier<Function> onTap;
  final AnExcercise excercise;
  final Curve animationCurve;
  final Duration showOrHideDuration;
  final ValueNotifier<int> pageNumber;

  @override
  _DoneButtonButtonState createState() => _DoneButtonButtonState();
}

class _DoneButtonButtonState extends State<DoneButtonButton> {
  bool fullyHide; 
  
  updateState() {
    if (mounted) setState(() {});
  }

  @override
  void initState() {
    super.initState();
    updateFullyHide();
    widget.pageNumber.addListener(updateState);
  }

  @override
  void dispose() {
    widget.pageNumber.removeListener(updateState);
    super.dispose();
  }

  updateFullyHide(){
    fullyHide = (showButton() == false);
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
  }

  bool showButton(){
    bool pageWithButton = widget.pageNumber.value != 1;
    bool nullTSC = widget.excercise.tempSetCount.value == AnExcercise.nullInt;
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
    if(widget.pageNumber.value != 2){
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
    return Visibility(
      visible: fullyHide = false,
      child: Stack(
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
                  onEnd: (){
                    updateFullyHide();
                    WidgetsBinding.instance.addPostFrameCallback((_){
                      setState(() {});
                    });
                  },
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
      ),
    );
  }
}

class DoneButtonCorner extends StatefulWidget {
  DoneButtonCorner({
    @required this.animationCurve,
    @required this.showOrHideDuration,
    @required this.pageNumber,
    @required this.excercise,
    @required this.isTop,
  });

  final Curve animationCurve;
  final Duration showOrHideDuration;
  final ValueNotifier<int> pageNumber;
  final AnExcercise excercise;
  final bool isTop;

  @override
  _DoneButtonCornerState createState() => _DoneButtonCornerState();
}

class _DoneButtonCornerState extends State<DoneButtonCorner> {
  bool fullyHide;

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

  updateFullyHide(){
    fullyHide = (showButton() == false);
  }

  @override
  void initState() {
    super.initState();
    updateFullyHide();
    widget.pageNumber.addListener(updateState);
  }

  @override
  void dispose() {
    widget.pageNumber.removeListener(updateState);
    super.dispose();
  }

  bool showButton(){
    bool pageWithButton = widget.pageNumber.value != 1;
    bool nullTSC = widget.excercise.tempSetCount.value == AnExcercise.nullInt;
    return (pageWithButton && nullTSC == false);
  }

  @override
  Widget build(BuildContext context) {
    double size = showButton() ? 24 : 0;

    //handle page changes
    int tempSetCount = widget.excercise.tempSetCount.value ?? 0;
    int setsPassed;
    if(widget.pageNumber.value != 2){
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
    return Visibility(
      visible: fullyHide = false,
      child: Container(
        height: 24,
        width: 24,
        alignment: widget.isTop ? Alignment.bottomLeft : Alignment.topLeft,
        child: AnimatedContainer(
          onEnd: (){
            updateFullyHide();
            WidgetsBinding.instance.addPostFrameCallback((_){
              setState(() {});
            });
          },
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