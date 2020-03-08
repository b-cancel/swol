//flutter
import 'package:flutter/material.dart';
import 'package:swol/shared/widgets/simple/conditional.dart';

//internal
import 'package:swol/shared/widgets/simple/heros/curveMod.dart';

//widget
class DoneButton extends StatelessWidget {
  DoneButton({
    @required this.show,
    @required this.color,
    @required this.setsPassed,
    //stay the same throughout
    @required this.exerciseID,
    @required this.animationCurve,
    @required this.showOrHideDuration,
  });

  final bool show;
  final Color color;
  final int setsPassed;
  //stay the same throughout
  final int exerciseID;
  final Curve animationCurve;
  final Duration showOrHideDuration;

  //build
  @override
  Widget build(BuildContext context) {
    //calculate the offset
    double halfOfScreen = MediaQuery.of(context).size.width / 2;
    double xOffset = show ? 0 : -halfOfScreen;
    Matrix4 newTransform = Matrix4.translationValues(
      xOffset,
      0,
      0,
    );

    //create decoration for both boxes
    Radius goalRadius = Radius.circular(show ? 12 : 24);
    BoxDecoration newBoxDecoration = BoxDecoration(
      color: color,
      borderRadius: new BorderRadius.only(
        topRight: goalRadius,
        bottomRight: goalRadius,
      ),
    );

    //create font color for card color
    Color fontColor = (color == Colors.red) ? Colors.black : Colors.white;

    //build
    return Stack(
      children: <Widget>[
        Positioned.fill(
          child: AnimatedContainer(
            duration: showOrHideDuration,
            curve: animationCurve,
            transform: newTransform,
            decoration: newBoxDecoration,
          ),
        ),
        Hero(
          tag: "exerciseComplete" + exerciseID.toString(),
          createRectTween: (begin, end) {
            return CustomRectTween(a: begin, b: end);
          },
          child: FittedBox(
            fit: BoxFit.contain,
            child: Material(
              color: Colors.transparent,
              child: AnimatedContainer(
                curve: animationCurve,
                duration: showOrHideDuration,
                transform: newTransform,
                decoration: newBoxDecoration,
                padding: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Icon(
                      Icons.arrow_left,
                      color: fontColor,
                    ),
                    Conditional(
                      condition: color == Colors.red,
                      ifTrue: Text(
                        "Delete This Set",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      ifFalse: RichText(
                        text: TextSpan(
                          style: TextStyle(
                            color: fontColor,
                          ),
                          children: [
                            TextSpan(
                              text: setsPassed.toString() + " Set" + (setsPassed == 1 ? "" : "s"),
                              style: TextStyle(
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            TextSpan(
                              text: " Finished",
                              style: TextStyle(),
                            ),
                          ],
                        ),
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
