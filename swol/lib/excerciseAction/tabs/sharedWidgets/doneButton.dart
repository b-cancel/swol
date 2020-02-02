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
class DoneButton extends StatelessWidget {
  DoneButton({
    @required this.excercise,
    this.showOrHideDuration: const Duration(milliseconds: 300),
    @required this.animationCurve,
    @required this.showDoneButton,
    @required this.setsFinishedSoFar,
  });

  final AnExcercise excercise;
  final Curve animationCurve;
  final Duration showOrHideDuration;
  //triggers an animation
  final ValueNotifier<bool> showDoneButton;
  //doesn't trigger anything, more of a pass by reference
  final ValueNotifier<int> setsFinishedSoFar;

  /*
  Breif Explanations of all the hacks I'm planing to use to get the desired effect
  the desired is a liquid like button that comes from the left edge

  everything will essentially look like its in a column
  and everything will be except the bottom buttons
  1. corner of button       \
  2. button                  BUTTON)
  3. other corner of button /
  4. bottom nav bar             BACK|NEXT

  1 and 2 will be created by 
  a. having a background container 
    that is always the same colorthe color of the button
  b. but on top of them will be a container the color of the background with a rounded edge
    for 1 the rounded edge is on the bottom left
    for 2 the rounded edge is on the top left
    - in both cases the card ammount of rounded when opened and 0 when closed

  the button will also be an animated container
  1. its width will adjust from full width to 0
    full when opened, 0 when closed
  2. and its right (top and bottom) corners will also be less or more rounded
    the card ammount of rounded when opened
    and the most ammount rounded possible when closed
  */

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
          onTap: (){
            //TODO: finish this well
            Navigator.of(context).pop();
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              DoneButtonCorner(
                animationCurve: animationCurve,
                showOrHideDuration: showOrHideDuration,
                showDoneButton: showDoneButton,
                isTop: true,
              ),
              Stack(
                children: <Widget>[
                  DoneButtonButton(
                    excercise: excercise,
                    animationCurve: animationCurve,
                    showOrHideDuration: showOrHideDuration,
                    showDoneButton: showDoneButton,
                    setsFinishedSoFar: setsFinishedSoFar,
                    wrapInHero: false,
                  ),
                  DoneButtonButton(
                    excercise: excercise,
                    animationCurve: animationCurve,
                    showOrHideDuration: showOrHideDuration,
                    showDoneButton: showDoneButton,
                    setsFinishedSoFar: setsFinishedSoFar,
                    wrapInHero: true,
                  ),
                ],
              ),
              DoneButtonCorner(
                animationCurve: animationCurve,
                showOrHideDuration: showOrHideDuration,
                showDoneButton: showDoneButton,
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
    @required this.excercise,
    @required this.animationCurve,
    @required this.showOrHideDuration,
    @required this.showDoneButton,
    @required this.setsFinishedSoFar,
    @required this.wrapInHero,
  });

  final AnExcercise excercise;
  final Curve animationCurve;
  final Duration showOrHideDuration;
  //triggers an animation
  final ValueNotifier<bool> showDoneButton;
  //doesn't trigger anything, more of a pass by reference
  final ValueNotifier<int> setsFinishedSoFar;
  final bool wrapInHero;

  @override
  _DoneButtonButtonState createState() => _DoneButtonButtonState();
}

class _DoneButtonButtonState extends State<DoneButtonButton> {
  updateState(){
    if(mounted) setState(() {});
  }

  @override
  void initState() { 
    super.initState();
    widget.showDoneButton.addListener(updateState);
  }

  @override
  void dispose() { 
    widget.showDoneButton.removeListener(updateState);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Radius goalRadius = Radius.circular(
      //TODO: more closely approximate the actual height
      //in order for the transition to take as long as I set it to
      //otherwise it will last that long but it wont seem like i
      widget.showDoneButton.value ? 12 : 24,
    );

    Widget main = AnimatedContainer(
      curve: widget.animationCurve,
      duration: widget.showOrHideDuration,
      transform: Matrix4.translation(
        vect.Vector3(
          (widget.showDoneButton.value) ? 0
          : -MediaQuery.of(context).size.width,
          0,
          0
        ),  
      ),
      decoration: new BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: new BorderRadius.only(
          topRight: goalRadius,
          bottomRight: goalRadius,
        ),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      child: Opacity(
        opacity: widget.wrapInHero ? 1 : 0,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              Icons.arrow_left
            ),
            RichText(
              text: TextSpan(
                style: TextStyle(
                  color: Colors.white,
                ),
                children: [
                  TextSpan(
                    text: widget.setsFinishedSoFar.value.toString() + " Sets",
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(
                    text: " Complete",
                    style: TextStyle(
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );

    if(widget.wrapInHero){
      return Hero(
        tag: "excerciseComplete"+ widget.excercise.id.toString(),
        createRectTween: (begin, end) {
          return CustomRectTween(a: begin, b: end);
        },
        child: FittedBox(
          fit: BoxFit.contain,
          child: Material(
            color: Colors.transparent,
            child: main,
          ),
        ),
      );
    }
    else return main;
  }
}

class DoneButtonCorner extends StatefulWidget {
  DoneButtonCorner({
    @required this.animationCurve,
    @required this.showOrHideDuration,
    @required this.showDoneButton,
    @required this.isTop,
  });

  final Curve animationCurve;
  final Duration showOrHideDuration;
  final ValueNotifier<bool> showDoneButton;
  final bool isTop;

  @override
  _DoneButtonCornerState createState() => _DoneButtonCornerState();
}

class _DoneButtonCornerState extends State<DoneButtonCorner> {
  updateState(){
    if(mounted) setState(() {});
  }

  @override
  void initState() { 
    super.initState();
    widget.showDoneButton.addListener(updateState);
  }

  @override
  void dispose() { 
    widget.showDoneButton.removeListener(updateState);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Radius goalRadius = Radius.circular(
      widget.showDoneButton.value ? 24 : 0,
    );

    //animates corners
    return Container(
      height: 24,
      width: 24,
      child: Stack(
        children: <Widget>[
          Container(
            height: 24,
            width: 24,
            decoration: new BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: new BorderRadius.only(
                bottomRight: widget.isTop ? Radius.zero : goalRadius,
                //
                topRight: widget.isTop ? goalRadius : Radius.zero,
              ),
            ),
          ),
          AnimatedContainer(
            height: 24,
            width: 24,
            curve: widget.animationCurve,
            duration: widget.showOrHideDuration,
            decoration: new BoxDecoration(
              color: Theme.of(context).primaryColorDark,
              borderRadius: new BorderRadius.only(
                topLeft: widget.isTop ? Radius.zero : goalRadius,
                bottomRight: widget.isTop ? Radius.zero : goalRadius,
                //
                bottomLeft: widget.isTop ? goalRadius : Radius.zero,
                topRight: widget.isTop ? goalRadius : Radius.zero,
              ),
            ),
          ),
        ],
      ),
    );
  }
}