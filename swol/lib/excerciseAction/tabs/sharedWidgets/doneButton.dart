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
    this.showOrHideDuration: const Duration(milliseconds: 1500),
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
          onTap: () {
            if (showDoneButton.value) {
              print("nothing but print");
              //TODO: finish this well
              Navigator.of(context).pop();
            }
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
              DoneButtonButton(
                excercise: excercise,
                animationCurve: animationCurve,
                showOrHideDuration: showOrHideDuration,
                showDoneButton: showDoneButton,
                setsFinishedSoFar: setsFinishedSoFar,
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
  });

  final AnExcercise excercise;
  final Curve animationCurve;
  final Duration showOrHideDuration;
  //triggers an animation
  final ValueNotifier<bool> showDoneButton;
  //doesn't trigger anything, more of a pass by reference
  final ValueNotifier<int> setsFinishedSoFar;

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

    Matrix4 newTransform = Matrix4.translation(
      vect.Vector3(
          (widget.showDoneButton.value)
              ? 0
              : -MediaQuery.of(context).size.width,
          0,
          0),
    );

    BoxDecoration newBoxDecoration = BoxDecoration(
      color: Theme.of(context).cardColor,
      borderRadius: new BorderRadius.only(
        topRight: goalRadius,
        bottomRight: goalRadius,
      ),
    );

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
                            text: widget.setsFinishedSoFar.value.toString() +
                                " Sets",
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
  updateState() {
    //we want to show but wait till the main button shows
    if(widget.showDoneButton.value){
      Future.delayed((widget.showOrHideDuration * (0.5)),(){
        if(mounted) setState(() {});
      });
    }
    else{
      if(mounted) setState(() {});
    }
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
    double size = widget.showDoneButton.value ? 24 : 0;

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
                color: Theme.of(context).cardColor,
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