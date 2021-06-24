//flutter
import 'package:flutter/material.dart';
import 'package:swol/action/page.dart';

//internal
import 'package:swol/shared/widgets/simple/heros/curveMod.dart';

//widget
class BottomNextButton extends StatelessWidget {
  const BottomNextButton({
    Key? key,
    required this.color,
    required this.forwardAction,
    required this.forwardActionWidget,
    required this.exerciseID,
  }) : super(key: key);

  final Color color;
  final Function forwardAction;
  final Widget forwardActionWidget;
  final int exerciseID;

  @override
  Widget build(BuildContext context) {
    BoxDecoration boxDecoration = BoxDecoration(
      color: color,
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(12),
        topRight: Radius.circular(12),
      ),
    );

    //big button
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => forwardAction(),
      child: Padding(
        padding: EdgeInsets.only(
          top: ExercisePage.mainButtonsHeight,
          bottom: 24,
        ),
        child: Container(
          height: ExercisePage.mainButtonsHeight,
          //NOTE: this container is only just a wrapper to the animated container
          //a place holder for when the hero is playing
          //and the hero will only be playing if the button has the accent color
          decoration: boxDecoration,
          //this is the actuall button with stuff in it
          child: Hero(
            tag: "exerciseContinue" + exerciseID.toString(),
            createRectTween: (Rect? begin, Rect? end) {
              return CustomRectTween(
                a: begin,
                b: end,
              );
            },
            child: Material(
              color: Colors.transparent,
              child: Container(
                height: ExercisePage.mainButtonsHeight,
                decoration: boxDecoration,
                padding: EdgeInsets.only(
                  right: 16,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Transform.translate(
                      offset: Offset(0, 0),
                      child: Icon(
                        Icons.arrow_drop_down,
                      ),
                    ),
                    Flexible(
                      child: forwardActionWidget,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
